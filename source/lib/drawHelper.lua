local function basaltDrawHelper()
    local terminal = parentTerminal
    local width, height = terminal.getSize()
    local cacheT = {}
    local cacheBG = {}
    local cacheFG = {}

    local _cacheT = {}
    local _cacheBG = {}
    local _cacheFG = {}

    local emptySpaceLine
    local emptyColorLines = {}

    local function createEmptyLines()
        emptySpaceLine = (" "):rep(width)
        for n = 0, 15 do
            local nColor = 2 ^ n
            local sHex = tHex[nColor]
            emptyColorLines[nColor] = sHex:rep(width)
        end
    end
    ----
    createEmptyLines()

    local function recreateWindowArray()
        local emptyText = emptySpaceLine
        local emptyFG = emptyColorLines[colors.white]
        local emptyBG = emptyColorLines[colors.black]
        for currentY = 1, height do
            cacheT[currentY] = sub(cacheT[currentY] == nil and emptyText or cacheT[currentY] .. emptyText:sub(1, width - cacheT[currentY]:len()), 1, width)
            cacheFG[currentY] = sub(cacheFG[currentY] == nil and emptyFG or cacheFG[currentY] .. emptyFG:sub(1, width - cacheFG[currentY]:len()), 1, width)
            cacheBG[currentY] = sub(cacheBG[currentY] == nil and emptyBG or cacheBG[currentY] .. emptyBG:sub(1, width - cacheBG[currentY]:len()), 1, width)
        end
    end
    recreateWindowArray()

    local function setText(x, y, text)
        if (y >= 1) and (y <= height) then
            if (x + text:len() > 0) and (x <= width) then
                local oldCache = cacheT[y]
                local newCache
                local nEnd = x + #text - 1

                if (x < 1) then
                    local startN = 1 - x + 1
                    local endN = width - x + 1
                    text = sub(text, startN, endN)
                elseif (nEnd > width) then
                    local endN = width - x + 1
                    text = sub(text, 1, endN)
                end

                if (x > 1) then
                    local endN = x - 1
                    newCache = sub(oldCache, 1, endN) .. text
                else
                    newCache = text
                end
                if nEnd < width then
                    newCache = newCache .. sub(oldCache, nEnd + 1, width)
                end
                cacheT[y] = newCache
            end
        end
    end

    local function setBG(x, y, colorStr)
        if (y >= 1) and (y <= height) then
            if (x + colorStr:len() > 0) and (x <= width) then
                local oldCache = cacheBG[y]
                local newCache
                local nEnd = x + #colorStr - 1

                if (x < 1) then
                    colorStr = sub(colorStr, 1 - x + 1, width - x + 1)
                elseif (nEnd > width) then
                    colorStr = sub(colorStr, 1, width - x + 1)
                end

                if (x > 1) then
                    newCache = sub(oldCache, 1, x - 1) .. colorStr
                else
                    newCache = colorStr
                end
                if nEnd < width then
                    newCache = newCache .. sub(oldCache, nEnd + 1, width)
                end
                cacheBG[y] = newCache
            end
        end
    end

    local function setFG(x, y, colorStr)
        if (y >= 1) and (y <= height) then
            if (x + colorStr:len() > 0) and (x <= width) then
                local oldCache = cacheFG[y]
                local newCache
                local nEnd = x + #colorStr - 1

                if (x < 1) then
                    local startN = 1 - x + 1
                    local endN = width - x + 1
                    colorStr = sub(colorStr, startN, endN)
                elseif (nEnd > width) then
                    local endN = width - x + 1
                    colorStr = sub(colorStr, 1, endN)
                end

                if (x > 1) then
                    local endN = x - 1
                    newCache = sub(oldCache, 1, endN) .. colorStr
                else
                    newCache = colorStr
                end
                if nEnd < width then
                    newCache = newCache .. sub(oldCache, nEnd + 1, width)
                end
                cacheFG[y] = newCache
            end
        end
    end

    local drawHelper = {
        setBG = function(x, y, colorStr)
            setBG(x, y, colorStr)
        end;

        setText = function(x, y, text)
            setText(x, y, text)
        end;

        setFG = function(x, y, colorStr)
            setFG(x, y, colorStr)
        end;

        drawBackgroundBox = function(x, y, width, height, bgCol)
            for n = 1, height do
                setBG(x, y + (n - 1), tHex[bgCol]:rep(width))
            end
        end;
        drawForegroundBox = function(x, y, width, height, fgCol)
            for n = 1, height do
                setFG(x, y + (n - 1), tHex[fgCol]:rep(width))
            end
        end;
        drawTextBox = function(x, y, width, height, symbol)
            for n = 1, height do
                setText(x, y + (n - 1), symbol:rep(width))
            end
        end;
        writeText = function(x, y, text, bgCol, fgCol)
            bgCol = bgCol or terminal.getBackgroundColor()
            fgCol = fgCol or terminal.getTextColor()
            setText(x, y, text)
            setBG(x, y, tHex[bgCol]:rep(text:len()))
            setFG(x, y, tHex[fgCol]:rep(text:len()))
        end;

        update = function()
            local xC, yC = terminal.getCursorPos()
            local isBlinking = false
            if (terminal.getCursorBlink ~= nil) then
                isBlinking = terminal.getCursorBlink()
            end
            terminal.setCursorBlink(false)
            for n = 1, height do
                terminal.setCursorPos(1, n)
                terminal.blit(cacheT[n], cacheFG[n], cacheBG[n])
            end
            terminal.setCursorBlink(isBlinking)
            terminal.setCursorPos(xC, yC)
        end;

        setTerm = function(newTerm)
            terminal = newTerm;
        end;
    }
    return drawHelper
end
local drawHelper = basaltDrawHelper()