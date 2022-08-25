local basaltEvent = require("basaltEvent")
local xmlValue = require("utils").getValueFromXML

return function(name)
    local objectType = "Timer"

    local timer = 0
    local savedRepeats = 0
    local repeats = 0
    local timerObj
    local eventSystem = basaltEvent()
    local timerIsActive = false

    local generateXMLEventFunction = function(self, func, val)
        local createF = function(str)
            if(str:sub(1,1)=="#")then
                local o = self:getBaseFrame():getDeepObject(str:sub(2,str:len()))
                if(o~=nil)and(o.internalObjetCall~=nil)then
                    func(self,function()o:internalObjetCall()end)
                end
            else
                func(self,self:getBaseFrame():getVariable(str))
            end
        end
        if(type(val)=="string")then
            createF(val)
        elseif(type(val)=="table")then
            for k,v in pairs(val)do
                createF(v)
            end
        end
        return self
    end

    local object = {
        name = name,
        getType = function(self)
            return objectType
        end;

        setValuesByXMLData = function(self, data)
            if(xmlValue("time", data)~=nil)then  timer = xmlValue("time", data) end
            if(xmlValue("repeat", data)~=nil)then  savedRepeats = xmlValue("repeat", data) end
            if(xmlValue("start", data)~=nil)then  if(xmlValue("start", data))then self:start() end end
            if(xmlValue("onCall", data)~=nil)then generateXMLEventFunction(self, self.onCall, xmlValue("onCall", data)) end
            return self
        end,

        getBaseFrame = function(self)
            if(self.parent~=nil)then
                return self.parent:getBaseFrame()
            end
            return self
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
            self.parent:addEvent("other_event", self)
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
            self.parent:removeEvent("other_event", self)
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