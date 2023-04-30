local max,min,sub,rep = math.max,math.min,string.sub,string.rep

return function(name, basalt)
    local base = basalt.getObject("BaseFrame")(name, basalt)
    local objectType = "MonitorFrame"
    
    base:hide()
    
    local object = {    
        getType = function()
            return objectType
        end,

        isType = function(self, t)
            return objectType==t or base.isType~=nil and base.isType(t) or false
        end,

        getBase = function(self)
            return base
        end,

        setMonitor = function(self, name)
            local mon = peripheral.wrap(name)
            if(mon~=nil)then
                self:setTerm(mon)
            end
            return self
        end,
        
        show = function(self)
            if(basalt.getTerm()~=self:getTerm())then
                base.show()
            end
            return self
        end,
    }

    object.__index = object
    return setmetatable(object, base)
end