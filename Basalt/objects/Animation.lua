return function(name)
    local object = {}
    local objectType = "Animation"

    local timerObj

    local animations = {}
    local index = 1

    local nextWaitTimer = 0
    local lastFunc

    local function onPlay()
        if (animations[index] ~= nil) then
            animations[index].f(object, index)
        end
        index = index + 1
        if (animations[index] ~= nil) then
            if (animations[index].t > 0) then
                timerObj = os.startTimer(animations[index].t)
            else
                onPlay()
            end
        end
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

        add = function(self, func, wait)
            lastFunc = func
            table.insert(animations, { f = func, t = wait or nextWaitTimer })
            return self
        end;

        wait = function(self, wait)
            nextWaitTimer = wait
            return self
        end;

        rep = function(self, reps)
            for x = 1, reps do
                table.insert(animations, { f = lastFunc, t = nextWaitTimer })
            end
            return self
        end;

        clear = function(self)
            animations = {}
            lastFunc = nil
            nextWaitTimer = 0
            index = 1
            return self
        end;

        play = function(self)
            index = 1
            if (animations[index] ~= nil) then
                if (animations[index].t > 0) then
                    timerObj = os.startTimer(animations[index].t)
                else
                    onPlay()
                end
            end
            return self
        end;

        cancel = function(self)
            os.cancelTimer(timerObj)
            return self
        end;

        eventHandler = function(self, event, tObj)
            if (event == "timer") and (tObj == timerObj) then
                if (animations[index] ~= nil) then
                    onPlay()
                end
            end
        end;
    }
    object.__index = object

    return object
end