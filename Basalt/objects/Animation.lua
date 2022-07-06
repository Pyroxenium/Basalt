return function(name)
    local object = {}
    local objectType = "Animation"

    local timerObj

    local animations = {}
    local index = 1
    local infinitePlay = false

    local nextWaitTimer = 0
    local lastFunc

    local _OBJ

    local function onPlay()
        if (animations[index] ~= nil) then
            animations[index].f(object, index)
        end
        index = index + 1
        if(animations[index]==nil)then
            if(infinitePlay)then
                index = 1
            else
                return
            end
        end
        if (animations[index].t > 0) then
            timerObj = os.startTimer(animations[index].t)
        else
            onPlay()
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

        setObject = function(self, obj)
            _OBJ = obj
            return self
        end;

        move = function(self, x, y, time, frames, obj)
            if(obj~=nil)then
                _OBJ = obj
            end
            if(_OBJ.setPosition==nil)or(_OBJ.getPosition==nil)then return self end
            local oX,oY = _OBJ:getPosition()
            if(oX==x)and(oY==y)then return self end

            local xAdd = oX<=x and (x-oX)/frames or (oX-x)/frames
            local yAdd = oY<=y and (y-oY)/frames or (oY-y)/frames
            local xInverted,yInverted = oX>x and true or false, oY>y and true or false

            for n=1, math.floor(frames) do
                local f
                if(n==frames)then
                    f = function()
                        _OBJ:setPosition(x, y)
                    end
                else
                    f = function()
                        _OBJ:setPosition(math.floor(xInverted and oX+(-xAdd*n) or oX+xAdd*n), math.floor(yInverted and oY+(-yAdd*n) or oY+yAdd*n))
                    end
                end
                table.insert(animations, { f = f, t = time/frames})
            end
            return self
        end;

        moveLerp = function(self, x, y, time, obj)
            
        end,

        offset = function(self, x, y, time, frames, obj)
            if(obj~=nil)then
                _OBJ = obj
            end
            if(_OBJ.setOffset==nil)or(_OBJ.getOffset==nil)then return self end
            local oX,oY = _OBJ:getOffset()
            oX = math.abs(oX)
            oY = math.abs(oY)
            
            if(oX==x)and(oY==y)then return self end

            local xAdd = oX<=x and (x-oX)/frames or (oX-x)/frames
            local yAdd = oY<=y and (y-oY)/frames or (oY-y)/frames
            local xInverted,yInverted = oX>x and true or false, oY>y and true or false

            for n=1, math.floor(frames) do
                local f
                if(n==frames)then
                    f = function()
                        _OBJ:setOffset(x, y)
                    end
                else
                    f = function()
                        _OBJ:setOffset(math.floor(xInverted and oX+(-xAdd*n) or oX+xAdd*n), math.floor(yInverted and oY+(-yAdd*n) or oY+yAdd*n))
                    end
                end
                table.insert(animations, { f = f, t = time/frames})
            end
            return self
        end;

        textColoring = function(self, time, ...)
            local colors = table.pack(...)
            for n=1, #colors do
                table.insert(animations, { f = function()
                    _OBJ:setForeground(colors[n])
                end, t = time/#colors})
            end
            return self
        end;

        backgroundColoring = function(self, time, ...)
            local colors = table.pack(...)
            for n=1, #colors do
                table.insert(animations, { f = function()
                    _OBJ:setBackground(colors[n])
                end, t = time/#colors})
            end
            return self
        end;

        setText = function(self, time, text)
            if(_OBJ.setText~=nil)then
                for n=1, text:len() do
                    table.insert(animations, { f = function()
                        _OBJ:setText(text:sub(1,n))
                    end, t = time/text:len()})
                end
            end
            return self
        end;

        changeText = function(self, time, ...)
            if(_OBJ.setText~=nil)then
                local text = table.pack(...)
                for n=1, #text do
                    table.insert(animations, { f = function()
                        _OBJ:setText(text[n])
                    end, t = time/#text})
                end
            end
            return self
        end;

        coloring = function(self, time, ...)
            local colors = table.pack(...)
            for n=1, #colors do
                if(type(colors[n]=="table"))then
                    table.insert(animations, { f = function()
                        if(colors[n][1]~=nil)then
                            _OBJ:setBackground(colors[n][1])
                        end
                        if(colors[n][2]~=nil)then
                            _OBJ:setForeground(colors[n][2])
                        end
                    end, t = time/#colors})

                end
            end
            return self
        end;

        wait = function(self, wait)
            nextWaitTimer = wait
            return self
        end;

        rep = function(self, reps)
            for n = 1, reps do
                table.insert(animations, { f = lastFunc, t = nextWaitTimer })
            end
            return self
        end;

        clear = function(self)
            animations = {}
            lastFunc = nil
            nextWaitTimer = 0
            index = 1
            infinitePlay = false
            return self
        end;

        play = function(self, infinite)
            infinitePlay = infinite and true or false
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
            infinitePlay = false
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
