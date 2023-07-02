local basaltEvent = require("basaltEvent")
local utils = require("utils")
local split = utils.splitString
local uuid = utils.uuid

local unpack,sub = table.unpack,string.sub

return function(name, basalt)
    name = name or uuid()
    assert(basalt~=nil, "Unable to find basalt instance! ID: "..name)

    -- Base object
    local initialized = false

    local eventSystem = basaltEvent()
    local registeredEvents = {}
    local activeEvents = {}
    local properties = {}
    local propertyConfig = {}

    local function defaultRule(typ)
        return function(self, value)
         local isValid = false
            if(type(typ)=="string")then
            local types = split(typ, "|")

                for _,v in pairs(types)do
                    if(type(value)==v)then
                        isValid = true
                    end
                end
            end
            if(type(typ)=="table")then
                for _,v in pairs(typ)do
                    if(v==value)then
                        isValid = true
                    end
                end
            end
            if(typ=="color")then
                if(type(value)=="string")then
                    if(colors[value]~=nil)then
                        isValid = true
                        value = colors[value]
                    end
                else
                    for _,v in pairs(colors)do
                        if(v==value)then
                            isValid = true
                        end
                    end
                end
            end
            if(typ=="char")then
                if(type(value)=="string")then
                    if(#value==1)then
                        isValid = true
                    end
                end
            end
            if(typ=="any")or(value==nil)or(type(value)=="function")then
                isValid = true
            end
            if(typ=="string")and(type(value)~="function")then
                value = tostring(value)
                isValid = true
            end

            if(not isValid)then
                local t = type(value)
                if(type(typ)=="table")then
                    typ = table.concat(typ, ", ")
                    t = value
                end
                error(self:getType()..": Invalid type for property "..name.."! Expected "..typ..", got "..t)
            end
            return value
        end
    end

    local parent
    local object

    object = {
        init = function(self)
            if(initialized)then return false end
            initialized = true
            return true
        end,

        isType = function(self, typ)
            for k,v in pairs(properties["Type"])do
                if(v==typ)then
                    return true
                end
            end
            return false
        end,

        getTypes = function(self)
            return properties["Type"]
        end,

        load = function(self)
        end,

        getName = function(self)
            return name
        end,

        getProperty = function(self, name)
            local prop = properties[name:gsub("^%l", string.upper)]
            if(type(prop)=="function")then
                return prop()
            end
            return prop
        end,

        getProperties = function(self)
            local p = {}
            for k,v in pairs(properties)do
                if(type(v)=="function")then
                    p[k] = v()
                else
                    p[k] = v
                end
            end
            return p
        end,

        setProperty = function(self, name, value, rule)
            name = name:gsub("^%l", string.upper)
            if(rule~=nil)then
                value = rule(self, value)
            end
            --if(properties[name]~=value)then
                properties[name] = value
                if(self.updateDraw~=nil)then
                    self:updateDraw()
                end
            --end
            return self
        end,

        getPropertyConfig = function(self, name)
            return propertyConfig[name]
        end,

        addProperty = function(self, name, typ, defaultValue, readonly, setLogic, getLogic, alteredRule)
            name = name:gsub("^%l", string.upper)
            propertyConfig[name] = {type=typ, defaultValue=defaultValue, readonly=readonly}
            if(properties[name]~=nil)then
                error("Property "..name.." in "..self:getType().." already exists!")
            end
            self:setProperty(name, defaultValue)

            object["get" .. name] = function(self, ...)
                if(self~=nil)then
                    local prop = self:getProperty(name)
                    if(getLogic~=nil)then
                        return getLogic(self, prop, ...)
                    end
                    return prop
                end
            end
            if(not readonly)then
                object["set" .. name] = function(self, value, ...)
                    if(self~=nil)then
                        if(setLogic~=nil)then
                            local modifiedVal = setLogic(self, value, ...)
                            if(modifiedVal~=nil)then
                                value = modifiedVal
                            end
                        end
                        self:setProperty(name, value, alteredRule~=nil and alteredRule(typ) or defaultRule(typ))
                    end
                    return self
                end
            end
            return self
        end,

        combineProperty = function(self, name, ...)
            name = name:gsub("^%l", string.upper)
            local args = {...}
            object["get" .. name] = function(self)
                local result = {}
                for _,v in pairs(args)do
                    v = v:gsub("^%l", string.upper)
                    result[#result+1] = self["get" .. v](self)
                end
                return unpack(result)
            end
            object["set" .. name] = function(self, ...)
                local values = {...}
                for k,v in pairs(args)do
                    if(self["set"..v]~=nil)then -- if später entfernen
                        self["set" .. v](self, values[k])
                    end
                end
                return self
            end
            return self
        end,

        setParent = function(self, newParent, noRemove)
            if(noRemove)then parent = newParent return self end
            if (newParent.getType ~= nil and newParent:isType("Container")) then
                self:remove()
                newParent:addChild(self)
                parent = newParent
            end
            return self
        end,

        getParent = function(self)
            return parent
        end,

        updateEvents = function(self)
            for k,v in pairs(activeEvents)do
                parent:removeEvent(k, self)
                if(v)then
                    parent:addEvent(k, self)
                end
            end
            return self
        end,

        listenEvent = function(self, event, active)
            if(parent~=nil)then
                if(active)or(active==nil)then
                    activeEvents[event] = true
                    parent:addEvent(event, self)
                elseif(active==false)then
                    activeEvents[event] = false
                    parent:removeEvent(event, self)
                end
            end
            return self
        end,

        enable = function(self)
            self:setProperty("Enabled", true)
            return self
        end,

        disable = function(self)
            self:setProperty("Enabled", false)
            return self
        end,

        isEnabled = function(self)
            return self:getProperty("Enabled")
        end,

        remove = function(self)
            if (parent ~= nil) then
                parent:removeChild(self)
            end
            self:updateDraw()
            return self
        end,

        getBaseFrame = function(self)
            if(parent~=nil)then
                return parent:getBaseFrame()
            end
            return self
        end,

        onEvent = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("other_event", v)
                end
            end
            return self
        end,

        getEventSystem = function(self)
            return eventSystem
        end,

        getRegisteredEvents = function(self)
            return registeredEvents
        end,

        registerEvent = function(self, event, func)
            if(parent~=nil)then
                parent:addEvent(event, self)
                if(event=="mouse_drag")then
                    parent:addEvent("mouse_click", self)
                    parent:addEvent("mouse_up", self)
                end
            end
            eventSystem:registerEvent(event, func)
            if (registeredEvents[event] == nil) then
                registeredEvents[event] = {}
            end
            table.insert(registeredEvents[event], func)
        end,

        removeEvent = function(self, event, index)
            if(eventSystem:getEventCount(event)<1)then
                if(parent~=nil)then
                    parent:removeEvent(event, self)
                end
            end
            eventSystem:removeEvent(event, index)
            if (registeredEvents[event] ~= nil) then
                table.remove(registeredEvents[event], index)
                if (#registeredEvents[event] == 0) then
                    registeredEvents[event] = nil
                end
            end
        end,

        eventHandler = function(self, event, ...)
            local val = self:sendEvent("other_event", event, ...)
            if(val~=nil)then return val end
        end,

        customEventHandler = function(self, event, ...)
            local val = self:sendEvent("custom_event", event, ...)
            if(val~=nil)then return val end
            return true
        end,

        sendEvent = function(self, event, ...)
            if(event=="other_event")or(event=="custom_event")then
                return eventSystem:sendEvent(event, self, ...)
            end
            return eventSystem:sendEvent(event, self, event, ...)
        end,

        onClick = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("mouse_click", v)
                end
            end
            return self
        end,

        onClickUp = function(self, ...)
                for _,v in pairs(table.pack(...))do
                    if(type(v)=="function")then
                        self:registerEvent("mouse_up", v)
                    end
                end
            return self
        end,

        onRelease = function(self, ...)
                for _,v in pairs(table.pack(...))do
                    if(type(v)=="function")then
                        self:registerEvent("mouse_release", v)
                    end
                end
            return self
        end,

        onScroll = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("mouse_scroll", v)
                end
            end
            return self
        end,

        onHover = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("mouse_hover", v)
                end
            end
            return self
        end,

        onLeave = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("mouse_leave", v)
                end
            end
            return self
        end,

        onDrag = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("mouse_drag", v)
                end
            end
            return self
        end,

        onKey = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("key", v)
                end
            end
            return self
        end,

        onChar = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("char", v)
                end
            end
            return self
        end,

        onKeyUp = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("key_up", v)
                end
            end
            return self
        end,
    }

    object:addProperty("Z", "number", 1, false, function(self, value)
        if (parent ~= nil) then
            parent:updateZIndex(self, value)
            self:updateDraw()
        end
        return value
    end)
    object:addProperty("Type", "string|table", {"Object"}, false, function(self, value)
        if(type(value)=="string")then
            table.insert(properties["Type"], 1, value)
            return properties["Type"]
        end
    end,
    function(self, _, depth)
        return properties["Type"][depth or 1]
    end)
    object:addProperty("Enabled", "boolean", true)

    object.__index = object
    return object
end