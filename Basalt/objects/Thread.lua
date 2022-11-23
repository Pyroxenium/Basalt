local xmlValue = require("utils").getValueFromXML

return function(name)
    local object
    local objectType = "Thread"

    local func
    local cRoutine
    local isActive = false
    local filter

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
            filter=nil
            local ok, result = coroutine.resume(cRoutine)
            filter = result
            if not (ok) then
                if (result ~= "Terminated") then
                    error("Thread Error Occurred - " .. result)
                end
            end
            self.parent:addEvent("mouse_click", self)
            self.parent:addEvent("mouse_up", self)
            self.parent:addEvent("mouse_scroll", self)
            self.parent:addEvent("mouse_drag", self)
            self.parent:addEvent("key", self)
            self.parent:addEvent("key_up", self)
            self.parent:addEvent("char", self)
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
            self.parent:removeEvent("mouse_click", self)
            self.parent:removeEvent("mouse_up", self)
            self.parent:removeEvent("mouse_scroll", self)
            self.parent:removeEvent("mouse_drag", self)
            self.parent:removeEvent("key", self)
            self.parent:removeEvent("key_up", self)
            self.parent:removeEvent("char", self)
            self.parent:removeEvent("other_event", self)
            return self
        end;

        mouseHandler = function(self, ...)
            self:eventHandler("mouse_click", ...)
        end,
        mouseUpHandler = function(self, ...)
            self:eventHandler("mouse_up", ...)
        end,
        mouseScrollHandler = function(self, ...)
            self:eventHandler("mouse_scroll", ...)
        end,
        mouseDragHandler = function(self, ...)
            self:eventHandler("mouse_drag", ...)
        end,
        mouseMoveHandler = function(self, ...)
            self:eventHandler("mouse_move", ...)
        end,
        keyHandler = function(self, ...)
            self:eventHandler("key", ...)
        end,
        keyUpHandler = function(self, ...)
            self:eventHandler("key_up", ...)
        end,
        charHandler = function(self, ...)
            self:eventHandler("char", ...)
        end,

        eventHandler = function(self, event, ...)
            if (isActive) then
                if (coroutine.status(cRoutine) == "suspended") then
                    if(filter~=nil)then
                        if(event~=filter)then return end
                        filter=nil
                    end
                    local ok, result = coroutine.resume(cRoutine, event, ...)
                    filter = result
                    if not (ok) then
                        if (result ~= "Terminated") then
                            error("Thread Error Occurred - " .. result)
                        end
                    end
                else
                    self:stop()
                end
            end
        end;

    }

    object.__index = object

    return object
end