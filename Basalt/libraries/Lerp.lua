return {
    lerp = function(s, e, pct)
        return s + (e - s) * pct
    end,

    flip = function (x)
        return 1 - x
    end,

    easeIn = function (t)
        return t * t
    end,

}