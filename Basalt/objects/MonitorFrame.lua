local basaltMon = require("basaltMon")
local max,min,sub,rep = math.max,math.min,string.sub,string.rep


return function(name, basalt)
    local base = basalt.getObject("BaseFrame")(name, basalt)
    local objectType = "MonitorFrame"

    base:setTerm(nil)
    local isMonitorGroup = false
    local monGroup
    
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

        setMonitor = function(self, newMon)
            if(type(newMon)=="string")then
                local mon = peripheral.wrap(newMon)
                if(mon~=nil)then
                    self:setTerm(mon)
                end
            elseif(type(newMon)=="table")then
                self:setTerm(newMon)
            end
            return self
        end,

        setMonitorGroup = function(self, monGrp)
            monGroup = basaltMon(monGrp)
            self:setTerm(monGroup)
            isMonitorGroup = true
            return self
        end,

        render = function(self)
            if(self:getTerm()~=nil)then
                base.render(self)
            end
        end,
    }

    object.mouseHandler = function(self, btn, x, y, isMon, monitor, ...)
        if(isMonitorGroup)then
            x, y = monGroup.calculateClick(monitor, x, y)
        end
        base.mouseHandler(self, btn, x, y, isMon, monitor, ...)
    end

    object.__index = object
    return setmetatable(object, base)
end