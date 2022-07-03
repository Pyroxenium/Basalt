return function(name)
    local object
    local objectType = "Thread"

    local func
    local cRoutine
    local isActive = false

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