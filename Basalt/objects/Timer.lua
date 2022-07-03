local basaltEvent = require("basaltEvent")

return function(name)
    local objectType = "Timer"

    local timer = 0
    local savedRepeats = 0
    local repeats = 0
    local timerObj
    local eventSystem = basaltEvent()
    local timerIsActive = false

    local object = {
        name = name,
        getType = function(self)
            return objectType
        end;

        getZIndex = function(self)
            return 1
        end;

        getName = function(self)
            return self.name
        end;

        setTime = function(self, _timer, _repeats)
            timer = _timer or 0
            savedRepeats = _repeats or 1
            return self
        end;

        start = function(self)
            if(timerIsActive)then
                os.cancelTimer(timerObj)
            end
            repeats = savedRepeats
            timerObj = os.startTimer(timer)
            timerIsActive = true
            return self
        end;

        isActive = function(self)
            return timerIsActive
        end;

        cancel = function(self)
            if (timerObj ~= nil) then
                os.cancelTimer(timerObj)
            end
            timerIsActive = false
            return self
        end;

        onCall = function(self, func)
            eventSystem:registerEvent("timed_event", func)
            return self
        end;

        eventHandler = function(self, event, tObj)
            if event == "timer" and tObj == timerObj and timerIsActive then
                eventSystem:sendEvent("timed_event", self)
                if (repeats >= 1) then
                    repeats = repeats - 1
                    if (repeats >= 1) then
                        timerObj = os.startTimer(timer)
                    end
                elseif (repeats == -1) then
                    timerObj = os.startTimer(timer)
                end
            end
        end;
    }
    object.__index = object

    return object
end