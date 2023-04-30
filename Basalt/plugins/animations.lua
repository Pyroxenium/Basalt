local floor,sin,cos,pi,sqrt,pow = math.floor,math.sin,math.cos,math.pi,math.sqrt,math.pow

-- You can find the easing curves here https://easings.net

local function lerp(s, e, pct)
    return s + (e - s) * pct
end

local function linear(t)
    return t
end

local function flip(t)
    return 1 - t
end

local function easeIn(t)
    return t * t * t
end

local function easeOut(t)
    return flip(easeIn(flip(t)))
end

local function easeInOut(t)
    return lerp(easeIn(t), easeOut(t), t)
end

local function easeOutSine(t)
    return sin((t * pi) / 2);
end

local function easeInSine(t)
    return flip(cos((t * pi) / 2))
end

local function easeInOutSine(t)
    return -(cos(pi * x) - 1) / 2
end

local function easeInBack(t)
    local c1 = 1.70158;
    local c3 = c1 + 1
    return c3*t^3-c1*t^2
end

local function easeInCubic(t)
    return t^3
end

local function easeInElastic(t)
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

return {
    VisualObject = function(base, basalt)
        local activeAnimations = {}
        local defaultMode = "linear"

        local function getAnimation(self, timerId)
            for k,v in pairs(activeAnimations)do
                if(v.timerId==timerId)then
                    return v
                end
            end
        end

        local function createAnimation(self, v1, v2, duration, timeOffset, mode, typ, f, get, set)
            local v1Val, v2Val = get(self)
            if(activeAnimations[typ]~=nil)then
                os.cancelTimer(activeAnimations[typ].timerId)
            end
            activeAnimations[typ] = {}
            activeAnimations[typ].call = function()
                local progress = activeAnimations[typ].progress
                local _v1 = math.floor(lerp.lerp(v1Val, v1, lerp[mode](progress / duration))+0.5)
                local _v2 = math.floor(lerp.lerp(v2Val, v2, lerp[mode](progress / duration))+0.5)
                set(self, _v1, _v2)
            end
            activeAnimations[typ].finished = function()
                set(self, v1, v2)
                if(f~=nil)then f(self) end
            end

            activeAnimations[typ].timerId=os.startTimer(0.05+timeOffset)
            activeAnimations[typ].progress=0
            activeAnimations[typ].duration=duration
            activeAnimations[typ].mode=mode
            self:listenEvent("other_event")
        end

        local object = {
            animatePosition = function(self, x, y, duration, timeOffset, mode, f)
                mode = mode or defaultMode
                duration = duration or 1
                timeOffset = timeOffset or 0
                x = math.floor(x+0.5)
                y = math.floor(y+0.5)
                createAnimation(self, x, y, duration, timeOffset, mode, "position", f, self.getPosition, self.setPosition)
                return self
            end,

            animateSize = function(self, w, h, duration, timeOffset, mode, f)
                mode = mode or defaultMode
                duration = duration or 1
                timeOffset = timeOffset or 0
                createAnimation(self, w, h, duration, timeOffset, mode, "size", f, self.getSize, self.setSize)
                return self
            end,

            animateOffset = function(self, x, y, duration, timeOffset, mode, f)
                mode = mode or defaultMode
                duration = duration or 1
                timeOffset = timeOffset or 0
                createAnimation(self, x, y, duration, timeOffset, mode, "offset", f, self.getOffset, self.setOffset)
                return self
            end,

            doneHandler = function(self, timerId, ...)
                for k,v in pairs(activeAnimations)do
                    if(v.timerId==timerId)then
                        activeAnimations[k] = nil
                        self:sendEvent("animation_done", self, "animation_done", k)
                    end
                end
            end,

            onAnimationDone = function(self, ...)
                for _,v in pairs(table.pack(...))do
                    if(type(v)=="function")then
                        self:registerEvent("animation_done", v)
                    end
                end

                return self
            end,

            eventHandler = function(self, event, timerId, ...)
                base.eventHandler(self, event, timerId, ...)
                if(event=="timer")then
                    local animation = getAnimation(self, timerId)
                    if(animation~=nil)then
                        if(animation.progress<animation.duration)then
                            animation.call()
                            animation.progress = animation.progress+0.05
                            animation.timerId=os.startTimer(0.05)
                        else
                            animation.finished()
                            self:doneHandler(timerId)
                        end
                    end
                end
            end,

            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
                local animX, animY, animateDuration, animeteTimeOffset, animateMode = xmlValue("animateX", data), xmlValue("animateY", data), xmlValue("animateDuration", data), xmlValue("animateTimeOffset", data), xmlValue("animateMode", data)
                local animW, animH, animateDuration, animeteTimeOffset, animateMode = xmlValue("animateW", data), xmlValue("animateH", data), xmlValue("animateDuration", data), xmlValue("animateTimeOffset", data), xmlValue("animateMode", data)
                local animXOffset, animYOffset, animateDuration, animeteTimeOffset, animateMode = xmlValue("animateXOffset", data), xmlValue("animateYOffset", data), xmlValue("animateDuration", data), xmlValue("animateTimeOffset", data), xmlValue("animateMode", data)
                if(animX~=nil and animY~=nil)then
                    self:animatePosition(animX, animY, animateDuration, animeteTimeOffset, animateMode)
                end
                if(animW~=nil and animH~=nil)then
                    self:animateSize(animW, animH, animateDuration, animeteTimeOffset, animateMode)
                end
                if(animXOffset~=nil and animYOffset~=nil)then
                    self:animateOffset(animXOffset, animYOffset, animateDuration, animeteTimeOffset, animateMode)
                end                
                return self
            end,
        }

        return object
    end
}