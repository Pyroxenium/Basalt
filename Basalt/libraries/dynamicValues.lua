return function(value, parentF, ...)
    local cache
    local fList = ...
    if(...~=nil)then 
        if(type(...)~="table")then
            fList = table.pack(...)
        end
    end

    local function numberFromString(str)
        return load("return " .. str)()
    end

    local function replacePercentage(str, parentValue)
        local _fullStr = str
        for v in _fullStr:gmatch("%d+%%") do
            local pValue = v:gsub("%%", "")
            str = str:gsub(v.."%", parentValue / 100 * math.max(math.min(tonumber(pValue),100),0))
        end
        return str
    end

    local function fToNumber(str)
        for k,v in pairs(fList)do
            if(type(v)=="function")then
                for _ in str:gmatch("f"..k)do
                    str = string.gsub(str, "f"..k, v())
                end
            end
        end
        return str
    end

    local function calculateValue()
        if(value~=nil)then
            if(type(value)=="string")then
                if(fList~=nil and #fList>0)then
                    cache = math.floor(numberFromString(replacePercentage(fToNumber(value), parentF() or 1))+0.5)
                else
                    cache = math.floor(numberFromString(replacePercentage(value, parentF() or 1)))
                end
            end
        end
        return cache
    end

    local public = {
        getType = function(self)
            return "DynamicValue"
        end,

        get = function(self)
            return cache or calculateValue()
        end,

        calculate = function(self)
            calculateValue()
            return self
        end,

        setParent = function(self, p)
            parentF = p
            return self
        end
    }
    return public
end