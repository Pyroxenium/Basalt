
local max, sub = math.max,string.sub

return function(monitorNames)
    local monitors = {}
    local multiMonWidth, multiMonHeight = 0,0
    local multiMonX, multiMonY = 1, 1
    local bgColor, txtColor = colors.black, colors.white
    for k,v in pairs(monitorNames) do
            monitors[k] = {}
        for a,b in pairs(v)do
            monitors[k][a] = {name=b, monitor=peripheral.wrap(b)}
        end
    end

    local function calculateSize()
        local absWidth, absHeight = 0,0
        local height = 0
        for _,v in pairs(monitors)do
            local width = 0
            for _,b in pairs(v)do
                local w, h = b.monitor.getSize()
                width = width + w
                height = max(height, h)
            end
            absWidth = max(absWidth, width)
            absHeight = absHeight + height
            height = 0
        end
        multiMonWidth, multiMonHeight = absWidth, absHeight
    end
    calculateSize()

    local function getMonitorFromPosition(x, y)
        local absWidth, absHeight = 0,0
        local height = 0
        for k,v in pairs(monitors)do
            local width = 0
            for a,b in pairs(v)do
                local w, h = b.monitor.getSize()
                width = width + w
                height = max(height, h)
                if(x >= absWidth and x <= absWidth + w and y >= absHeight and y <= absHeight + h)then
                    return b.monitor, a, k
                end
                absWidth = absWidth + w
            end
            absWidth = 0
            absHeight = absHeight + height
            height = 0
        end
    end

    local function getRelativeCursorPos(mon, x, y)
        local absWidth, absHeight = 0,0
        local height = 0
        for k,v in pairs(monitors)do
            local width = 0
            for a,b in pairs(v)do
                local w, h = b.monitor.getSize()
                width = width + w
                height = max(height, h)
                if(b.monitor == mon)then
                    return x - absWidth, y - absHeight
                end
                absWidth = absWidth + w
            end
            absWidth = 0
            absHeight = absHeight + height
            height = 0
        end
    end

    local function blit(text, fgColor, bgColor)
        local mon, x, y = getMonitorFromPosition(multiMonX, multiMonY)

        for k, v in pairs(monitors[y])do
            if(k >= x)then
                local xCursor, yCursor = getRelativeCursorPos(v.monitor, multiMonX, multiMonY)
                local w, h = v.monitor.getSize()
                local textToScreen = sub(text, 1, w)
                text = sub(text, w+1)
                local fgColorToScreen = sub(fgColor, 1, w)
                fgColor = sub(fgColor, w+1)
                local bgColorToScreen = sub(bgColor, 1, w)
                bgColor = sub(bgColor, w+1)
                v.monitor.setCursorPos(xCursor, yCursor)
                v.monitor.blit(textToScreen, fgColorToScreen, bgColorToScreen)
                multiMonX = multiMonX + w
            end
        end
    end

    return {
        getSize = function()
            return multiMonWidth, multiMonHeight
        end,

        blit = blit,
        getCursorPos = function()
            return multiMonX, multiMonY
        end,

        setCursorPos = function(x, y)
            multiMonX, multiMonY = x, y
            for _,v in pairs(monitors)do
                for _,b in pairs(v)do
                    local xCursor, yCursor = getRelativeCursorPos(b.monitor, multiMonX, multiMonY)
                    b.monitor.setCursorPos(xCursor, yCursor)
                end
            end
        end,

        getCursorBlink = function()
            local mon = getMonitorFromPosition(multiMonX, multiMonY)
            return mon.getCursorBlink()
        end,

        setCursorBlink = function(blink)
            for _,v in pairs(monitors)do
                for _,b in pairs(v)do
                    b.monitor.setCursorBlink(blink)
                end
            end
        end,

        setBackgroundColor = function(color)
            bgColor = color
        end,

        getBackgroundColor = function()
            return bgColor
        end,

        setTextColor = function(color)
            txtColor = color
        end,

        getTextColor = function()
            return txtColor
        end,

        calculateClick = function(name, xClick, yClick)
            local relY = 0
            for k,v in pairs(monitors)do
                local relX = 0
                local maxY = 0
                for a,b in pairs(v)do
                    local wM,hM = b.monitor.getSize()
                    if(b.name==name)then
                        return xClick + relX, yClick + relY
                    end
                    relX = relX + wM
                    if(hM > maxY)then maxY = hM end
                end
                relY = relY + maxY
            end
            return xClick, yClick
        end,
    }
end