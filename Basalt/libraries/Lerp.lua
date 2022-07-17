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

return {
    lerp = lerp,
    flip = flip,
    easeIn = easeIn,
    easeOut = easeOut,

    easeInOut = function(t)
        return lerp(easeIn(t), easeOut(t), t)
    end

}