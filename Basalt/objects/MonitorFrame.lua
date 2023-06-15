local basaltMon = require("basaltMon")
local max,min,sub,rep = math.max,math.min,string.sub,string.rep


return function(name, basalt)
    local base = basalt.getObject("BaseFrame")(name, basalt)
    base:setType("MonitorFrame")

    local isMonitorGroup = false

    base:addProperty("Monitor", "string|table", nil, false, function(self, value)
        if(type(value)=="string")then
            local mon = peripheral.wrap(value)
            if(mon~=nil)then
                self:setTerm(mon)
            end
        elseif(type(value)=="table")then
            self:setTerm(value)
        end
    end)

    base:addProperty("MonitorGroup", "string|table", nil, false, function(self, value)
            self:setTerm(basaltMon(value))
            isMonitorGroup = true
    end)

    base:setTerm(nil)

    local object = {
        getBase = function(self)
            return base
        end,
    }

    object.mouseHandler = function(self, btn, x, y, isMon, monitor, ...)
        if(isMonitorGroup)then
            local monGroup = self:getTerm()
            x, y = monGroup.calculateClick(monitor, x, y)
        end
        base.mouseHandler(self, btn, x, y, isMon, monitor, ...)
    end

    object.__index = object
    return setmetatable(object, base)
end