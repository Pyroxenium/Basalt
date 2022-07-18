
local xmlValue = require("utils").getValueFromXML
local basaltEvent = require("basaltEvent")

local floor = math.floor

local lerp = function(s, e, pct)
    return s + (e - s) * pct
end

local flip = function (x)
    return 1 - x
end

local easeIn = function (t)
    return t * t * t
end

local easeOut = function(t)
    return flip(easeIn(flip(t)))
end

local easeInOut = function(t)
    return lerp(easeIn(t), easeOut(t), t)
end

local lerp = {
    lerp = lerp,
    flip=flip,
    easeIn=easeIn,
    easeOut=easeOut,
    easeInOut=easeInOut,
}

return function(name)
    local object = {}
    local objectType = "Animation"

    local timerObj

    local animations = {}
    local animationTime = 0
    local index = 1
    local infinitePlay = false

    local eventSystem = basaltEvent()

    local nextWaitTimer = 0
    local lastFunc
    local loop=false

    local _OBJ

    local function call(tab)
        for k,v in pairs(tab)do
            v(object, animations[index].t, index)
        end
    end

    local function onPlay(self)
        if (animations[index] ~= nil) then
            call(animations[index].f)
            animationTime = animations[index].t
        end
        index = index + 1
        if(animations[index]==nil)then
            if(infinitePlay)then
                index = 1
                animationTime = 0
            else
                self:animationDoneHandler()
                return
            end
        end
        if (animations[index].t > 0) then
            timerObj = os.startTimer(animations[index].t - animationTime)
        else
            onPlay(self)
        end
    end

    local function addAnimationPart(time, f)
        for n=1,#animations do
            if(animations[n].t==time)then
                table.insert(animations[n].f, f)
                return
            end
        end
        for n=1,#animations do
            if(animations[n].t>time)then
                if(animations[n-1]~=nil)then
                    if(animations[n-1].t<time)then
                        table.insert(animations, n-1, {t=time, f={f}})
                        return
                    end
                else
                    table.insert(animations, n, {t=time, f={f}})
                    return
                end
            end
        end
        if(#animations<=0)then
            table.insert(animations, 1, {t=time, f={f}})
            return
        elseif(animations[#animations].t<time)then
            table.insert(animations, {t=time, f={f}})
        end
    end

    local function predefinedLerp(v1,v2,d,t,get,set,mode)
        mode = mode or "easeOut"
        local x,y 
        addAnimationPart(t+0.05, function()
            x,y = get(_OBJ)
        end)
        for n=0.05,d,0.05 do
            addAnimationPart(t+n, function()
                local _x = math.floor(lerp.lerp(x, v1, lerp[mode](n / d))+0.5)
                local _y = math.floor(lerp.lerp(y, v2, lerp[mode](n / d))+0.5)
                set(_OBJ, _x,_y)
            end)
        end
    end;

    object = {
        name = name,
        getType = function(self)
            return objectType
        end;

        getBaseFrame = function(self)
            if(self.parent~=nil)then
                return self.parent:getBaseFrame()
            end
            return self
        end;

        setValuesByXMLData = function(self, data)
            loop = xmlValue("loop", data)==true and true or false
            if(xmlValue("object", data)~=nil)then 
                local o = self:getBaseFrame():getDeepObject(xmlValue("object", data)) 
                if(o==nil)then
                    o = self:getBaseFrame():getVariable(xmlValue("object", data))
                end
                if(o~=nil)then
                    self:setObject(o)
                end
            end
            if(data["move"]~=nil)then 
                local x = xmlValue("x", data["move"])
                local y = xmlValue("y", data["move"])
                local duration = xmlValue("duration", data["move"])
                local time = xmlValue("time", data["move"])
                local mode = xmlValue("mode", data["move"])
                self:move(x, y, duration, time, mode)
            end
            if(data["size"]~=nil)then 
                local w = xmlValue("width", data["size"])
                local h = xmlValue("height", data["size"])
                local duration = xmlValue("duration", data["size"])
                local time = xmlValue("time", data["size"])
                local mode = xmlValue("mode", data["size"])
                self:size(w, h, duration, time, mode)
            end
            if(data["offset"]~=nil)then 
                local x = xmlValue("x", data["offset"])
                local y = xmlValue("y", data["offset"])
                local duration = xmlValue("duration", data["offset"])
                local time = xmlValue("time", data["offset"])
                local mode = xmlValue("mode", data["offset"])
                self:offset(x, y, duration, time, mode)
            end
            if(data["textColor"]~=nil)then 
                local duration = xmlValue("duration", data["textColor"])
                local timer = xmlValue("time", data["textColor"])
                local t = {}
                local tab = data["textColor"]["color"]
                if(tab~=nil)then
                    if(tab.properties~=nil)then tab = {tab} end
                    for k,v in pairs(tab)do
                        table.insert(t, colors[v:value()])
                    end
                end
                if(duration~=nil)and(#t>0)then
                    self:changeTextColor(duration, timer or 0, table.unpack(t))
                end
            end
            if(data["background"]~=nil)then 
                local duration = xmlValue("duration", data["background"])
                local timer = xmlValue("time", data["background"])
                local t = {}
                local tab = data["background"]["color"]
                if(tab~=nil)then
                    if(tab.properties~=nil)then tab = {tab} end
                    for k,v in pairs(tab)do
                        table.insert(t, colors[v:value()])
                    end
                end
                if(duration~=nil)and(#t>0)then
                    self:changeBackground(duration, timer or 0, table.unpack(t))
                end
            end
            if(data["text"]~=nil)then 
                local duration = xmlValue("duration", data["text"])
                local timer = xmlValue("time", data["text"])
                local t = {}
                local tab = data["text"]["text"]
                if(tab~=nil)then
                    if(tab.properties~=nil)then tab = {tab} end
                    for k,v in pairs(tab)do
                        table.insert(t, v:value())
                    end
                end
                if(duration~=nil)and(#t>0)then
                    self:changeText(duration, timer or 0, table.unpack(t))
                end
            end
            if(xmlValue("onDone", data)~=nil)then
                local value = xmlValue("onDone", data)
                if(value:sub(1,1)=="#")then
                    value = xmlValue("onDone", data):sub(2,value:len())
                    local o = self:getBaseFrame():getDeepObject(value) 
                    if(o~=nil)then
                        self:onAnimationDone(function()o:internalObjetCall()end)
                    end
                else
                    local f = self:getBaseFrame():getVariable(value)
                    if(f~=nil)then
                        self:onAnimationDone(f)
                    end
                end
            end
            if(xmlValue("autoRemove", data)~=nil)then
                if(xmlValue("autoRemove", data)~=false)then
                    self:onAnimationDone(function() self.parent:removeObject(self) end)
                end 
            else
                self:onAnimationDone(function() self.parent:removeObject(self) end)
            end
            
            if(xmlValue("play", data)~=nil)then if(xmlValue("play", data))then self:play(loop) end end
            return self
        end,

        getZIndex = function(self)
            return 1
        end;

        getName = function(self)
            return self.name
        end;

        setObject = function(self, obj)
            _OBJ = obj
            return self
        end;

        move = function(self, x, y, duration, timer, obj)
            _OBJ = obj or _OBJ
            predefinedLerp(x,y,duration,timer or 0,_OBJ.getPosition,_OBJ.setPosition)
            return self
        end,

        offset = function(self, x, y, duration, timer, obj)
            _OBJ = obj or _OBJ
            predefinedLerp(x,y,duration,timer or 0,_OBJ.getOffset,_OBJ.setOffset)
            return self
        end,

        size = function(self, w, h, duration, timer, obj)
            _OBJ = obj or _OBJ
            predefinedLerp(w,h,duration,timer or 0,_OBJ.getSize,_OBJ.setSize)
            return self
        end,

        changeText = function(self, duration, timer, ...)
            local text = {...}
            timer = timer or 0
            _OBJ = obj or _OBJ
            for n=1,#text do
                addAnimationPart(timer+n*(duration/#text), function()
                    _OBJ.setText(_OBJ, text[n])
                end)
            end
            return self
        end,

        changeBackground = function(self, duration, timer, ...)
            local colors = {...}
            timer = timer or 0
            _OBJ = obj or _OBJ
            for n=1,#colors do
                addAnimationPart(timer+n*(duration/#colors), function()
                    _OBJ.setBackground(_OBJ, colors[n])
                end)
            end
            return self
        end,

        changeTextColor = function(self, duration, timer, ...)
            local colors = {...}
            timer = timer or 0
            _OBJ = obj or _OBJ
            for n=1,#colors do
                addAnimationPart(timer+n*(duration/#colors), function()
                    _OBJ.setForeground(_OBJ, colors[n])
                end)
            end
            return self
        end,

        add = function(self, func, wait)
            lastFunc = func
            addAnimationPart((wait or nextWaitTimer) + (animations[#animations]~=nil and animations[#animations].t or 0), func)
            return self
        end;

        wait = function(self, wait)
            nextWaitTimer = wait
            return self
        end;

        rep = function(self, reps)
            if(lastFunc~=nil)then
                for n = 1, reps or 1 do
                    addAnimationPart((wait or nextWaitTimer) + (animations[#animations]~=nil and animations[#animations].t or 0), lastFunc)
                end
            end
            return self
        end;

        onAnimationDone = function(self, f)
            eventSystem:registerEvent("animation_done", f)
            return self
        end,

        animationDoneHandler = function(self)
            eventSystem:sendEvent("animation_done", self)
        end;

        clear = function(self)
            animations = {}
            lastFunc = nil
            nextWaitTimer = 0
            index = 1
            animationTime = 0
            infinitePlay = false
            return self
        end;

        play = function(self, infinite)
            self:cancel()
            infinitePlay = infinite and true or false
            index = 1
            animationTime = 0
            if (animations[index] ~= nil) then
                if (animations[index].t > 0) then
                    timerObj = os.startTimer(animations[index].t)
                else
                    onPlay()
                end
            else
                self:animationDoneHandler()
            end
            return self
        end;

        cancel = function(self)
            if(timerObj~=nil)then
                os.cancelTimer(timerObj)
                infinitePlay = false
            end
            return self
        end;

        internalObjetCall = function(self)
            self:play(loop)
        end,

        eventHandler = function(self, event, tObj)
            if (event == "timer") and (tObj == timerObj) then
                if (animations[index] ~= nil) then
                    onPlay(self)
                else
                    self:animationDoneHandler()
                end
            end
        end;
    }
    object.__index = object

    return object
end