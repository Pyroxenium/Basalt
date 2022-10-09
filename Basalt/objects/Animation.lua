local xmlValue = require("utils").getValueFromXML
local basaltEvent = require("basaltEvent")

local floor,sin,cos,pi,sqrt,pow = math.floor,math.sin,math.cos,math.pi,math.sqrt,math.pow

-- You can find the easing curves here https://easings.net

local lerp = function(s, e, pct)
    return s + (e - s) * pct
end

local linear = function (t)
    return t
end

local flip = function (t)
    return 1 - t
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

local easeOutSine = function(t)
    return sin((t * pi) / 2);
end

local easeInSine = function(t)
    return flip(cos((t * pi) / 2))
end

local easeInOutSine = function(t)
    return -(cos(pi * x) - 1) / 2
end

local easeInBack = function(t)
    local c1 = 1.70158;
    local c3 = c1 + 1
    return c3*t^3-c1*t^2
end

local easeInCubic = function(t)
    return t^3
end

local easeInElastic = function(t)
    local c4 = (2*pi)/3;
    return t == 0 and 0 or (t == 1 and 1 or (
        -2^(10*t-10)*sin((t*10-10.75)*c4)
    ))
end

local function easeInExpo(t)
    return t == 0 and 0 or 2^(10*t-10)
end

local function easeInExpo(t)
    return t == 0 and 0 or 2^(10*t-10)
end

local function easeInOutBack(t)
    local c1 = 1.70158;
    local c2 = c1 * 1.525;
    return t < 0.5 and ((2*t)^2*((c2+1)*2*t-c2))/2 or ((2*t-2)^2*((c2+1)*(t*2-2)+c2)+2)/2
end

local function easeInOutCubic(t)
    return t < 0.5 and 4 * t^3 or 1-(-2*t+2)^3 / 2
end

local function easeInOutElastic(t)
    local c5 = (2*pi) / 4.5
    return t==0 and 0 or (t == 1 and 1 or (t < 0.5 and -(2^(20*t-10) * sin((20*t - 11.125) * c5))/2 or (2^(-20*t+10) * sin((20*t - 11.125) * c5))/2 + 1))
end

local function easeInOutExpo(t)
    return t == 0 and 0 or (t == 1 and 1 or (t < 0.5 and 2^(20*t-10)/2 or (2-2^(-20*t+10)) /2))
end

local function easeInOutQuad(t)
    return t < 0.5 and 2*t^2 or 1-(-2*t+2)^2/2
end

local function easeInOutQuart(t)
    return t < 0.5 and 8*t^4 or 1 - (-2*t+2)^4 / 2
end

local function easeInOutQuint(t)
    return t < 0.5 and 16*t^5 or 1-(-2*t+2)^5 / 2
end

local function easeInQuad(t)
    return t^2
end

local function easeInQuart(t)
    return t^4
end

local function easeInQuint(t)
    return t^5
end

local function easeOutBack(t)
    local c1 = 1.70158;
    local c3 = c1 + 1
    return 1+c3*(t-1)^3+c1*(t-1)^2
end

local function easeOutCubic(t)
    return 1 - (1-t)^3
end

local function easeOutElastic(t)
    local c4 = (2*pi)/3;

    return t == 0 and 0 or (t == 1 and 1 or (2^(-10*t)*sin((t*10-0.75)*c4)+1))
end

local function easeOutExpo(t)
    return t == 1 and 1 or 1-2^(-10*t)
end

local function easeOutQuad(t)
    return 1 - (1 - t) * (1 - t)
end

local function easeOutQuart(t)
    return 1 - (1-t)^4
end

local function easeOutQuint(t)
    return 1 - (1 - t)^5
end

local function easeInCirc(t)
    return 1 - sqrt(1 - pow(t, 2))
end

local function easeOutCirc(t)
    return sqrt(1 - pow(t - 1, 2))
end

local function easeInOutCirc(t)
    return t < 0.5 and (1 - sqrt(1 - pow(2 * t, 2))) / 2 or (sqrt(1 - pow(-2 * t + 2, 2)) + 1) / 2;
end

local function easeOutBounce(t)
    local n1 = 7.5625;
    local d1 = 2.75;

    if (t < 1 / d1)then
        return n1 * t * t
    elseif (t < 2 / d1)then
        local a = t - 1.5 / d1
        return n1 * a * a + 0.75;
    elseif (t < 2.5 / d1)then
        local a = t - 2.25 / d1
        return n1 * a * a + 0.9375;
    else
        local a = t - 2.625 / d1
        return n1 * a * a + 0.984375;
    end
end

local function easeInBounce(t)
    return 1 - easeOutBounce(1 - t)
end

local function easeInOutBounce(t)
    return x < 0.5 and (1 - easeOutBounce(1 - 2 * t)) / 2 or (1 + easeOutBounce(2 * t - 1)) / 2;
end



local lerp = {
    linear = linear,
    lerp = lerp,
    flip=flip,
    easeIn=easeIn,
    easeInSine = easeInSine,
    easeInBack=easeInBack,
    easeInCubic=easeInCubic,
    easeInElastic=easeInElastic,
    easeInExpo=easeInExpo,
    easeInQuad=easeInQuad,
    easeInQuart=easeInQuart,
    easeInQuint=easeInQuint,
    easeInCirc=easeInCirc,
    easeInBounce=easeInBounce,
    easeOut=easeOut,
    easeOutSine = easeOutSine,
    easeOutBack=easeOutBack,
    easeOutCubic=easeOutCubic,
    easeOutElastic=easeOutElastic,
    easeOutExpo=easeOutExpo,
    easeOutQuad=easeOutQuad,
    easeOutQuart=easeOutQuart,
    easeOutQuint=easeOutQuint,
    easeOutCirc=easeOutCirc,
    easeOutBounce=easeOutBounce,
    easeInOut=easeInOut,
    easeInOutSine = easeInOutSine,
    easeInOutBack=easeInOutBack,
    easeInOutCubic=easeInOutCubic,
    easeInOutElastic=easeInOutElastic,
    easeInOutExpo=easeInOutExpo,
    easeInOutQuad=easeInOutQuad,
    easeInOutQuart=easeInOutQuart,
    easeInOutQuint=easeInOutQuint,
    easeInOutCirc=easeInOutCirc,
    easeInOutBounce=easeInOutBounce,
}

local activeAnimations = {}

return function(name)
    local object = {}
    local objectType = "Animation"

    local timerObj

    local animations = {}
    local animationTime = 0
    local animationActive = false
    local index = 1
    local infinitePlay = false

    local eventSystem = basaltEvent()

    local nextWaitTimer = 0
    local lastFunc
    local loop=false
    local autoDestroy = false
    local mode = "easeOut"

    local _OBJ

    local function call(tab)
        for k,v in pairs(tab)do
            v(object, animations[index].t, index)
        end
    end

    local function onPlay(self)
        if(index==1)then self:animationStartHandler() end
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
    

    local function predefinedLerp(v1,v2,d,t,get,set,typ,self)
        local obj = _OBJ
        local x,y 
        local name = ""
        if(obj.parent~=nil)then name = obj.parent:getName() end
        name = name..obj:getName()
        addAnimationPart(t+0.05, function()
            if(typ~=nil)then
                if(activeAnimations[typ]==nil)then activeAnimations[typ] = {} end
                    if(activeAnimations[typ][name]~=nil)then
                        if(activeAnimations[typ][name]~=self)then
                            activeAnimations[typ][name]:cancel()
                        end
                    end
                activeAnimations[typ][name] = self
            end
            x,y = get(obj)
        end)
        for n=0.05,d+0.01,0.05 do
            addAnimationPart(t+n, function()
                local _x = math.floor(lerp.lerp(x, v1, lerp[mode](n / d))+0.5)
                local _y = math.floor(lerp.lerp(y, v2, lerp[mode](n / d))+0.5)
                set(obj, _x,_y)
                if(typ~=nil)then
                    if(n>=d-0.01)then
                        if(activeAnimations[typ][name]==self)then
                            activeAnimations[typ][name] = nil
                        end
                    end
                end
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

        setMode = function(self, newMode)
            mode = newMode
            return self
        end,

        addMode = function(self, modeId, modeF)
            lerp[modeId] = modeF
            return self
        end,

        generateXMLEventFunction = function(self, func, val)
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
        end,

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
                self:move(x, y, duration, time)
            end
            if(data["size"]~=nil)then 
                local w = xmlValue("width", data["size"])
                local h = xmlValue("height", data["size"])
                local duration = xmlValue("duration", data["size"])
                local time = xmlValue("time", data["size"])
                self:size(w, h, duration, time)
            end
            if(data["offset"]~=nil)then 
                local x = xmlValue("x", data["offset"])
                local y = xmlValue("y", data["offset"])
                local duration = xmlValue("duration", data["offset"])
                local time = xmlValue("time", data["offset"])
                self:offset(x, y, duration, time)
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
            if(xmlValue("onDone", data)~=nil)then self:generateXMLEventFunction(self.onDone, xmlValue("onDone", data)) end
            if(xmlValue("onStart", data)~=nil)then self:generateXMLEventFunction(self.onDone, xmlValue("onStart", data)) end
            if(xmlValue("autoDestroy", data)~=nil)then
                if(xmlValue("autoDestroy", data))then
                    autoDestroy = true
                end
            end
            mode = xmlValue("mode", data) or mode
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
            predefinedLerp(x,y,duration,timer or 0,_OBJ.getPosition,_OBJ.setPosition, "position", self)
            return self
        end,

        offset = function(self, x, y, duration, timer, obj)
            _OBJ = obj or _OBJ
            predefinedLerp(x,y,duration,timer or 0,_OBJ.getOffset,_OBJ.setOffset, "offset", self)
            return self
        end,

        size = function(self, w, h, duration, timer, obj)
            _OBJ = obj or _OBJ
            predefinedLerp(w,h,duration,timer or 0,_OBJ.getSize,_OBJ.setSize, "size", self)
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

        add = function(self, func, timer)
            lastFunc = func
            addAnimationPart((timer or nextWaitTimer) + (animations[#animations]~=nil and animations[#animations].t or 0), func)
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

        onDone = function(self, f)
            eventSystem:registerEvent("animation_done", f)
            return self
        end,

        onStart = function(self, f)
            eventSystem:registerEvent("animation_start", f)
            return self
        end,

        setAutoDestroy = function(self, destroy)
            autoDestroy = destroy~=nil and destroy or true
            return self
        end,

        animationDoneHandler = function(self)
            eventSystem:sendEvent("animation_done", self)
            self.parent:removeEvent("other_event", self)
            if(autoDestroy)then
                self.parent:removeObject(self)
                self = nil
            end
        end;

        animationStartHandler = function(self)
            eventSystem:sendEvent("animation_start", self)
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
            animationActive = true
            infinitePlay = infinite and true or false
            index = 1
            animationTime = 0
            if (animations[index] ~= nil) then
                if (animations[index].t > 0) then
                    timerObj = os.startTimer(animations[index].t)
                else
                    onPlay(self)
                end
            else
                self:animationDoneHandler()
            end
            self.parent:addEvent("other_event", self)
            return self
        end;

        cancel = function(self)
            if(timerObj~=nil)then
                os.cancelTimer(timerObj)
                infinitePlay = false
            end
            animationActive = false
            self.parent:removeEvent("other_event", self)
            return self
        end;

        internalObjetCall = function(self)
            self:play(loop)
        end,

        eventHandler = function(self, event, tObj)
            if(animationActive)then
                if (event == "timer") and (tObj == timerObj) then
                    if (animations[index] ~= nil) then
                        onPlay(self)
                    else
                        self:animationDoneHandler()
                    end
                end
            end
        end;
    }
    object.__index = object

    return object
end