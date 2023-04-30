return function(name, basalt)
    local base = basalt.getObject("Object")(name, basalt)

    local objectType = "Thread"

    local func
    local cRoutine
    local isActive = false
    local filter

    local object = {
        getType = function(self)
            return objectType
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
            self:listenEvent("mouse_click")
            self:listenEvent("mouse_up")
            self:listenEvent("mouse_scroll")
            self:listenEvent("mouse_drag")
            self:listenEvent("key")
            self:listenEvent("key_up")
            self:listenEvent("char")
            self:listenEvent("other_event")
            return self
        end,

        getStatus = function(self, f)
            if (cRoutine ~= nil) then
                return coroutine.status(cRoutine)
            end
            return nil
        end,

        stop = function(self, f)
            isActive = false
            self:listenEvent("mouse_click", false)
            self:listenEvent("mouse_up", false)
            self:listenEvent("mouse_scroll", false)
            self:listenEvent("mouse_drag", false)
            self:listenEvent("key", false)
            self:listenEvent("key_up", false)
            self:listenEvent("char", false)
            self:listenEvent("other_event", false)
            return self
        end,

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
        end,

    }

    object.__index = object
    return setmetatable(object, base)
end