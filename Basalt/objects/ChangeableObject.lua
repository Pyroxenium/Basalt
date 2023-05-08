return function(name, basalt)
    local base = basalt.getObject("VisualObject")(name, basalt)
    -- Base object
    local objectType = "ChangeableObject"

    local value
    
    local object = {
        setValue = function(self, _value, valueChangedHandler)
            if (value ~= _value) then
                value = _value
                self:updateDraw()
                if(valueChangedHandler~=false)then
                    self:valueChangedHandler()
                end
            end
            return self
        end,

        getValue = function(self)
            return value
        end,

        onChange = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("value_changed", v)
                end
            end
            return self
        end,

        valueChangedHandler = function(self)
            self:sendEvent("value_changed", value)
        end,
    }

    object.__index = object
    return setmetatable(object, base)
end