return function(name, basalt)
    local base = basalt.getObject("Object")(name, basalt)
    base:setType("Timer")

    base:addProperty("Timer", "number", 0, false, function(self, value)
        if (value < 0) then
            value = 0
        end
        return value
    end)

    base:addProperty("Repeat", "number", 1, false, function(self, value)
        if(value~=nil)then
            if (value < 0) then
                value = 0
            end
        else
            value = 0
        end
        return value
    end)

    base:combineProperty("Time", "Timer", "Repeat")

    local timerObj
    local timerIsActive = false

    local object = {
        start = function(self)
            if(timerIsActive)then
                os.cancelTimer(timerObj)
            end
            local timer, repeatAmount = self:getTime()
            timerObj = os.startTimer(timer)
            timerIsActive = true
            self:listenEvent("other_event")
            return self
        end,

        isActive = function(self)
            return timerIsActive
        end,

        cancel = function(self)
            if (timerObj ~= nil) then
                os.cancelTimer(timerObj)
            end
            timerIsActive = false
            self:removeEvent("other_event")
            return self
        end,

        setStart = function(self, start)
            if (start == true) then
                return self:start()
            else
                return self:cancel()
            end
        end,

        onCall = function(self, func)
            self:registerEvent("timed_event", func)
            return self
        end,

        eventHandler = function(self, event, tObj, ...)
            base.eventHandler(self, event, tObj, ...)
            if event == "timer" and tObj == timerObj and timerIsActive then
                self:sendEvent("timed_event")
                local timer = self:getTimer()
                local repeats = self:getRepeat()
                if (repeats >= 1) then
                    repeats = repeats - 1
                    if (repeats >= 1) then
                        timerObj = os.startTimer(timer)
                    end
                elseif (repeats == -1) then
                    timerObj = os.startTimer(timer)
                end
            end
        end,
    }

    object.__index = object
    return setmetatable(object, base)
end
