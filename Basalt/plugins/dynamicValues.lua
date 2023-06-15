local protectedNames = {clamp=true, round=true, math=true, colors=true}
local function replace(word)
    if(protectedNames[word])then return word end
    if word:sub(1, 1):find('%a') and not word:find('.', 1, true) then
        return '"' .. word .. '"'
    end
    return word
end

local function parseString(str)
    str = str:gsub("{", "")
    str = str:gsub("}", "")
    for k,v in pairs(colors)do
        if(type(k)=="string")then
            str = str:gsub("%f[%w]"..k.."%f[%W]", "colors."..k)
        end
    end
    str = str:gsub("(%s?)([%w.]+)", function(a, b) return a .. replace(b) end)
    str = str:gsub("%s?%?", " and ")
    str = str:gsub("%s?:", " or ")
    str = str:gsub("%.w%f[%W]", ".width")
    str = str:gsub("%.h%f[%W]", ".height")
    return str
end



local function processString(str, env)
    env.math = math
    env.colors = colors
    env.clamp = function(val, min, max)
        return math.min(math.max(val, min), max)
    end
    env.round = function(val)
        return math.floor(val + 0.5)
    end
    local f = load("return " .. str, "", nil, env)

    if(f==nil)then error(str.." - is not a valid dynamic value string") end
    return f()
end

local function dynamicValue(object, name, dynamicString, basalt)
    local objectGroup = {}
    local observers = {}
    dynamicString = parseString(dynamicString)
    local cachedValue = nil
    local needsUpdate = true

    local function updateFunc()
        needsUpdate = true
    end

    for v in dynamicString:gmatch("%a+%.%a+")do
        local name = v:gsub("%.%a+", "")
        local prop = v:gsub("%a+%.", "")
        if(objectGroup[name]==nil)then
            objectGroup[name] = {}
        end
        table.insert(objectGroup[name], prop)
    end

    for k,v in pairs(objectGroup) do
        if(k=="self") then
            for _, b in pairs(v) do
                if(name~=b)then
                    object:addPropertyObserver(b, updateFunc)
                    if(b=="clicked")or(b=="dragging")then
                        object:listenEvent("mouse_click")
                        object:listenEvent("mouse_up")
                    end
                    if(b=="dragging")then
                        object:listenEvent("mouse_drag")
                    end
                    if(b=="hovered")then
                        --object:listenEvent("mouse_enter")
                        --object:listenEvent("mouse_exit")
                    end
                    table.insert(observers, {obj=object, name=b})
                else
                    error("Dynamic Values - self reference to self")
                end
            end
        end

        if(k=="parent") then
            for _, b in pairs(v) do
                object:getParent():addPropertyObserver(b, updateFunc)
                table.insert(observers, {obj=object:getParent(), name=b})
            end
        end

        if(k~="self" and k~="parent")and(protectedNames[k]==nil)then
            local obj = object:getParent():getChild(k)
            for _, b in pairs(v) do
                obj:addPropertyObserver(b, updateFunc)
                table.insert(observers, {obj=obj, name=b})
            end
        end
    end


    local function calculate()
        local env = {}
        local parent = object:getParent()
        for k,v in pairs(objectGroup)do
            local objTable = {}

            if(k=="self")then
                for _,b in pairs(v)do
                    objTable[b] = object:getProperty(b)
                end
            end

            if(k=="parent")then
                for _,b in pairs(v)do
                    objTable[b] = parent:getProperty(b)
                end
            end

            if(k~="self")and(k~="parent")and(protectedNames[k]==nil)then
                local obj = parent:getChild(k)
                if(obj==nil)then
                    error("Dynamic Values - unable to find object: "..k)
                end
                for _,b in pairs(v)do
                    objTable[b] = obj:getProperty(b)
                end
            end
            env[k] = objTable
        end
        return processString(dynamicString, env)
    end

    return {
        get = function(self)
            if(needsUpdate)then
                cachedValue = calculate() + 0.5
                if(type(cachedValue)=="number")then
                    cachedValue = math.floor(cachedValue + 0.5)
                end
                needsUpdate = false
                object:updatePropertyObservers(name)
            end
            return cachedValue
        end,
        removeObservers = function(self)
            for _,v in pairs(observers)do
                v.obj:removePropertyObserver(v.name, updateFunc)
            end
        end,
    }
end

return {
    Object = function(base, basalt)
        local observers = {}
        local activeDynValues = {}

        local function filterDynValues(self, name, value)
            if(type(value)=="string")and(value:sub(1,1)=="{")and(value:sub(-1)=="}")then
                if(activeDynValues[name]~=nil)then
                    activeDynValues[name].removeObservers()
                end
                activeDynValues[name] = dynamicValue(self, name, value, basalt)
                value = activeDynValues[name].get
            end
            return value
        end

        return {
            updatePropertyObservers = function(self, name)
                if(observers[name]~=nil)then
                    for _,v in pairs(observers[name])do
                        v(self, name)
                    end
                end
                return self
            end,

            setProperty = function(self, name, value, rule)
                value = filterDynValues(self, name, value)
                base.setProperty(self, name, value, rule)
                if(observers[name]~=nil)then
                    for _,v in pairs(observers[name])do
                        v(self, name)
                    end
                end
                return self
            end,

            addPropertyObserver = function(self, name, func)
                name = name:gsub("^%l", string.upper)
                if(observers[name]==nil)then
                    observers[name] = {}
                end
                table.insert(observers[name], func)
            end,

            removePropertyObserver = function(self, name, func)
                name = name:gsub("^%l", string.upper)
                if(observers[name]~=nil)then
                    for k,v in pairs(observers[name])do
                        if(v==func)then
                            table.remove(observers[name], k)
                        end
                    end
                end
            end,
        }
    end
}
