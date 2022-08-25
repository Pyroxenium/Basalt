local xmlValue = require("utils").getValueFromXML

return function(name)
    local object
    local objectType = "Thread"

    local func
    local cRoutine
    local isActive = false

    local generateXMLEventFunction = function(self, str)
        if(str:sub(1,1)=="#")then
            local o = self:getBaseFrame():getDeepObject(str:sub(2,str:len()))
            if(o~=nil)and(o.internalObjetCall~=nil)then
                return (function()o:internalObjetCall()end)
            end
        else
            return self:getBaseFrame():getVariable(str)
        end
        return self
    end
    
    object = {
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

        getBaseFrame = function(self)
            if(self.parent~=nil)then
                return self.parent:getBaseFrame()
            end
            return self
        end;

        setValuesByXMLData = function(self, data)
            local f
            if(xmlValue("thread", data)~=nil)then  f = generateXMLEventFunction(self, xmlValue("thread", data)) end
            if(xmlValue("start", data)~=nil)then  if(xmlValue("start", data))and(f~=nil)then self:start(f) end end
            return self
        end,

        start = function(self, f)
            if (f == nil) then
                error("Function provided to thread is nil")
            end
            func = f
            cRoutine = coroutine.create(func)
            isActive = true
            local ok, result = coroutine.resume(cRoutine)
            if not (ok) then
                if (result ~= "Terminated") then
                    error("Thread Error Occurred - " .. result)
                end
            end
            self.parent:addEvent("other_event", self)
            return self
        end;

        getStatus = function(self, f)
            if (cRoutine ~= nil) then
                return coroutine.status(cRoutine)
            end
            return nil
        end;

        stop = function(self, f)
            isActive = false
            self.parent:removeEvent("other_event", self)
            return self
        end;

        eventHandler = function(self, event, p1, p2, p3)
            if (isActive) then
                if (coroutine.status(cRoutine) ~= "dead") then
                    local ok, result = coroutine.resume(cRoutine, event, p1, p2, p3)
                    if not (ok) then
                        if (result ~= "Terminated") then
                            error("Thread Error Occurred - " .. result)
                        end
                    end
                else
                    isActive = false
                end
            end
        end;

    }

    object.__index = object

    return object
end