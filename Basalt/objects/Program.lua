local Object = require("Object")
local tHex = require("tHex")
local process = require("process")
local xmlValue = require("utils").getValueFromXML
local log = require("basaltLogs")

local sub = string.sub

return function(name, parent)
    local base = Object(name)
    local objectType = "Program"
    base:setZIndex(5)
    local object
    local cachedPath

    local function createBasaltWindow(x, y, width, height, self)
        local xCursor, yCursor = 1, 1
        local bgColor, fgColor = colors.black, colors.white
        local cursorBlink = false
        local visible = false

        local cacheT = {}
        local cacheBG = {}
        local cacheFG = {}

        local tPalette = {}

        local emptySpaceLine
        local emptyColorLines = {}

        for i = 0, 15 do
            local c = 2 ^ i
            tPalette[c] = { parent:getBasaltInstance().getBaseTerm().getPaletteColour(c) }
        end

        local function createEmptyLines()
            emptySpaceLine = (" "):rep(width)
            for n = 0, 15 do
                local nColor = 2 ^ n
                local sHex = tHex[nColor]
                emptyColorLines[nColor] = sHex:rep(width)
            end
        end

        local function recreateWindowArray()
            createEmptyLines()
            local emptyText = emptySpaceLine
            local emptyFG = emptyColorLines[colors.white]
            local emptyBG = emptyColorLines[colors.black]
            for n = 1, height do
                cacheT[n] = sub(cacheT[n] == nil and emptyText or cacheT[n] .. emptyText:sub(1, width - cacheT[n]:len()), 1, width)
                cacheFG[n] = sub(cacheFG[n] == nil and emptyFG or cacheFG[n] .. emptyFG:sub(1, width - cacheFG[n]:len()), 1, width)
                cacheBG[n] = sub(cacheBG[n] == nil and emptyBG or cacheBG[n] .. emptyBG:sub(1, width - cacheBG[n]:len()), 1, width)
            end
            base.updateDraw(base)
        end
        recreateWindowArray()

        local function updateCursor()
            if xCursor >= 1 and yCursor >= 1 and xCursor <= width and yCursor <= height then
                --parentTerminal.setCursorPos(xCursor + x - 1, yCursor + y - 1)
            else
                --parentTerminal.setCursorPos(0, 0)
            end
            --parentTerminal.setTextColor(fgColor)
        end

        local function internalBlit(sText, sTextColor, sBackgroundColor)
            -- copy pasti strikes again (cc: window.lua)
            local nStart = xCursor
            local nEnd = nStart + #sText - 1
            if yCursor >= 1 and yCursor <= height then
                if nStart <= width and nEnd >= 1 then
                    -- Modify line
                    if nStart == 1 and nEnd == width then
                        cacheT[yCursor] = sText
                        cacheFG[yCursor] = sTextColor
                        cacheBG[yCursor] = sBackgroundColor
                    else
                        local sClippedText, sClippedTextColor, sClippedBackgroundColor
                        if nStart < 1 then
                            local nClipStart = 1 - nStart + 1
                            local nClipEnd = width - nStart + 1
                            sClippedText = sub(sText, nClipStart, nClipEnd)
                            sClippedTextColor = sub(sTextColor, nClipStart, nClipEnd)
                            sClippedBackgroundColor = sub(sBackgroundColor, nClipStart, nClipEnd)
                        elseif nEnd > width then
                            local nClipEnd = width - nStart + 1
                            sClippedText = sub(sText, 1, nClipEnd)
                            sClippedTextColor = sub(sTextColor, 1, nClipEnd)
                            sClippedBackgroundColor = sub(sBackgroundColor, 1, nClipEnd)
                        else
                            sClippedText = sText
                            sClippedTextColor = sTextColor
                            sClippedBackgroundColor = sBackgroundColor
                        end

                        local sOldText = cacheT[yCursor]
                        local sOldTextColor = cacheFG[yCursor]
                        local sOldBackgroundColor = cacheBG[yCursor]
                        local sNewText, sNewTextColor, sNewBackgroundColor
                        if nStart > 1 then
                            local nOldEnd = nStart - 1
                            sNewText = sub(sOldText, 1, nOldEnd) .. sClippedText
                            sNewTextColor = sub(sOldTextColor, 1, nOldEnd) .. sClippedTextColor
                            sNewBackgroundColor = sub(sOldBackgroundColor, 1, nOldEnd) .. sClippedBackgroundColor
                        else
                            sNewText = sClippedText
                            sNewTextColor = sClippedTextColor
                            sNewBackgroundColor = sClippedBackgroundColor
                        end
                        if nEnd < width then
                            local nOldStart = nEnd + 1
                            sNewText = sNewText .. sub(sOldText, nOldStart, width)
                            sNewTextColor = sNewTextColor .. sub(sOldTextColor, nOldStart, width)
                            sNewBackgroundColor = sNewBackgroundColor .. sub(sOldBackgroundColor, nOldStart, width)
                        end

                        cacheT[yCursor] = sNewText
                        cacheFG[yCursor] = sNewTextColor
                        cacheBG[yCursor] = sNewBackgroundColor
                    end
                    object:updateDraw()
                end
                xCursor = nEnd + 1
                if (visible) then
                    updateCursor()
                end
            end
        end

        local function setText(_x, _y, text)
            if (text ~= nil) then
                local gText = cacheT[_y]
                if (gText ~= nil) then
                    cacheT[_y] = sub(gText:sub(1, _x - 1) .. text .. gText:sub(_x + (text:len()), width), 1, width)
                end
            end
            object:updateDraw()
        end

        local function setBG(_x, _y, colorStr)
            if (colorStr ~= nil) then
                local gBG = cacheBG[_y]
                if (gBG ~= nil) then
                    cacheBG[_y] = sub(gBG:sub(1, _x - 1) .. colorStr .. gBG:sub(_x + (colorStr:len()), width), 1, width)
                end
            end
            object:updateDraw()
        end

        local function setFG(_x, _y, colorStr)
            if (colorStr ~= nil) then
                local gFG = cacheFG[_y]
                if (gFG ~= nil) then
                    cacheFG[_y] = sub(gFG:sub(1, _x - 1) .. colorStr .. gFG:sub(_x + (colorStr:len()), width), 1, width)
                end
            end
            object:updateDraw()
        end

        local setTextColor = function(color)
            if type(color) ~= "number" then
                error("bad argument #1 (expected number, got " .. type(color) .. ")", 2)
            elseif tHex[color] == nil then
                error("Invalid color (got " .. color .. ")", 2)
            end
            fgColor = color
        end

        local setBackgroundColor = function(color)
            if type(color) ~= "number" then
                error("bad argument #1 (expected number, got " .. type(color) .. ")", 2)
            elseif tHex[color] == nil then
                error("Invalid color (got " .. color .. ")", 2)
            end
            bgColor = color
        end

        local setPaletteColor = function(colour, r, g, b)
            -- have to work on
            if type(colour) ~= "number" then
                error("bad argument #1 (expected number, got " .. type(colour) .. ")", 2)
            end

            if tHex[colour] == nil then
                error("Invalid color (got " .. colour .. ")", 2)
            end

            local tCol
            if type(r) == "number" and g == nil and b == nil then
                tCol = { colours.rgb8(r) }
                tPalette[colour] = tCol
            else
                if type(r) ~= "number" then
                    error("bad argument #2 (expected number, got " .. type(r) .. ")", 2)
                end
                if type(g) ~= "number" then
                    error("bad argument #3 (expected number, got " .. type(g) .. ")", 2)
                end
                if type(b) ~= "number" then
                    error("bad argument #4 (expected number, got " .. type(b) .. ")", 2)
                end

                tCol = tPalette[colour]
                tCol[1] = r
                tCol[2] = g
                tCol[3] = b
            end
        end

        local getPaletteColor = function(colour)
            if type(colour) ~= "number" then
                error("bad argument #1 (expected number, got " .. type(colour) .. ")", 2)
            end
            if tHex[colour] == nil then
                error("Invalid color (got " .. colour .. ")", 2)
            end
            local tCol = tPalette[colour]
            return tCol[1], tCol[2], tCol[3]
        end

        local basaltwindow = {
            setCursorPos = function(_x, _y)
                if type(_x) ~= "number" then
                    error("bad argument #1 (expected number, got " .. type(_x) .. ")", 2)
                end
                if type(_y) ~= "number" then
                    error("bad argument #2 (expected number, got " .. type(_y) .. ")", 2)
                end
                xCursor = math.floor(_x)
                yCursor = math.floor(_y)
                if (visible) then
                    updateCursor()
                end
            end;

            getCursorPos = function()
                return xCursor, yCursor
            end;

            setCursorBlink = function(blink)
                if type(blink) ~= "boolean" then
                    error("bad argument #1 (expected boolean, got " .. type(blink) .. ")", 2)
                end
                cursorBlink = blink
            end;

            getCursorBlink = function()
                return cursorBlink
            end;


            getPaletteColor = getPaletteColor,
            getPaletteColour = getPaletteColor,

            setBackgroundColor = setBackgroundColor,
            setBackgroundColour = setBackgroundColor,

            setTextColor = setTextColor,
            setTextColour = setTextColor,

            setPaletteColor = setPaletteColor,
            setPaletteColour = setPaletteColor,

            getBackgroundColor = function()
                return bgColor
            end;
            getBackgroundColour = function()
                return bgColor
            end;

            getSize = function()
                return width, height
            end;

            getTextColor = function()
                return fgColor
            end;
            getTextColour = function()
                return fgColor
            end;

            basalt_resize = function(_width, _height)
                width, height = _width, _height
                recreateWindowArray()
            end;

            basalt_reposition = function(_x, _y)
                x, y = _x, _y
            end;

            basalt_setVisible = function(vis)
                visible = vis
            end;

            drawBackgroundBox = function(_x, _y, _width, _height, bgCol)
                for n = 1, _height do
                    setBG(_x, _y + (n - 1), tHex[bgCol]:rep(_width))
                end
            end;
            drawForegroundBox = function(_x, _y, _width, _height, fgCol)
                for n = 1, _height do
                    setFG(_x, _y + (n - 1), tHex[fgCol]:rep(_width))
                end
            end;
            drawTextBox = function(_x, _y, _width, _height, symbol)
                for n = 1, _height do
                    setText(_x, _y + (n - 1), symbol:rep(_width))
                end
            end;

            writeText = function(_x, _y, text, bgCol, fgCol)
                bgCol = bgCol or bgColor
                fgCol = fgCol or fgColor
                setText(x, _y, text)
                setBG(_x, _y, tHex[bgCol]:rep(text:len()))
                setFG(_x, _y, tHex[fgCol]:rep(text:len()))
            end;

            basalt_update = function()
                if (parent ~= nil) then
                    for n = 1, height do
                        parent:setText(x, y + (n - 1), cacheT[n])
                        parent:setBG(x, y + (n - 1), cacheBG[n])
                        parent:setFG(x, y + (n - 1), cacheFG[n])
                    end
                end
            end;

            scroll = function(offset)
                if type(offset) ~= "number" then
                    error("bad argument #1 (expected number, got " .. type(offset) .. ")", 2)
                end
                if offset ~= 0 then
                    local sEmptyText = emptySpaceLine
                    local sEmptyTextColor = emptyColorLines[fgColor]
                    local sEmptyBackgroundColor = emptyColorLines[bgColor]
                    for newY = 1, height do
                        local y = newY + offset
                        if y >= 1 and y <= height then
                            cacheT[newY] = cacheT[y]
                            cacheBG[newY] = cacheBG[y]
                            cacheFG[newY] = cacheFG[y]
                        else
                            cacheT[newY] = sEmptyText
                            cacheFG[newY] = sEmptyTextColor
                            cacheBG[newY] = sEmptyBackgroundColor
                        end
                    end
                end
                if (visible) then
                    updateCursor()
                end
            end;


            isColor = function()
                return parent:getBasaltInstance().getBaseTerm().isColor()
            end;

            isColour = function()
                return parent:getBasaltInstance().getBaseTerm().isColor()
            end;

            write = function(text)
                text = tostring(text)
                if (visible) then
                    internalBlit(text, tHex[fgColor]:rep(text:len()), tHex[bgColor]:rep(text:len()))
                end
            end;

            clearLine = function()
                if (visible) then
                    setText(1, yCursor, (" "):rep(width))
                    setBG(1, yCursor, tHex[bgColor]:rep(width))
                    setFG(1, yCursor, tHex[fgColor]:rep(width))
                end
                if (visible) then
                    updateCursor()
                end
            end;

            clear = function()
                for n = 1, height do
                    setText(1, n, (" "):rep(width))
                    setBG(1, n, tHex[bgColor]:rep(width))
                    setFG(1, n, tHex[fgColor]:rep(width))
                end
                if (visible) then
                    updateCursor()
                end
            end;

            blit = function(text, fgcol, bgcol)
                if type(text) ~= "string" then
                    error("bad argument #1 (expected string, got " .. type(text) .. ")", 2)
                end
                if type(fgcol) ~= "string" then
                    error("bad argument #2 (expected string, got " .. type(fgcol) .. ")", 2)
                end
                if type(bgcol) ~= "string" then
                    error("bad argument #3 (expected string, got " .. type(bgcol) .. ")", 2)
                end
                if #fgcol ~= #text or #bgcol ~= #text then
                    error("Arguments must be the same length", 2)
                end
                if (visible) then
                    internalBlit(text, fgcol, bgcol)
                end
            end


        }

        return basaltwindow
    end

    base.width = 30
    base.height = 12
    local pWindow = createBasaltWindow(1, 1, base.width, base.height)
    local curProcess
    local paused = false
    local queuedEvent = {}

    local function updateCursor(self)
        local xCur, yCur = pWindow.getCursorPos()
        local obx, oby = self:getAnchorPosition()
        local w,h = self:getSize()
        if (obx + xCur - 1 >= 1 and obx + xCur - 1 <= obx + w - 1 and yCur + oby - 1 >= 1 and yCur + oby - 1 <= oby + h - 1) then
            self.parent:setCursor(pWindow.getCursorBlink(), obx + xCur - 1, yCur + oby - 1, pWindow.getTextColor())
        end
    end

    local function mouseEvent(self, event, p1, x, y)
        if (curProcess == nil) then
            return false
        end
        if not (curProcess:isDead()) then
            if not (paused) then
                local absX, absY = self:getAbsolutePosition(self:getAnchorPosition(nil, nil, true))
                curProcess:resume(event, p1, x-absX+1, y-absY+1)
                updateCursor(self)
            end
        end
    end

    local function keyEvent(self, event, key, isHolding)
        if (curProcess == nil) then
            return false
        end
        if not (curProcess:isDead()) then
            if not (paused) then
                if (self.draw) then
                    curProcess:resume(event, key, isHolding)
                    updateCursor(self)
                end
            end
        end
    end

    object = {
        getType = function(self)
            return objectType
        end;

        show = function(self)
            base.show(self)
            pWindow.setBackgroundColor(self.bgColor)
            pWindow.setTextColor(self.fgColor)
            pWindow.basalt_setVisible(true)
            return self
        end;

        hide = function(self)
            base.hide(self)
            pWindow.basalt_setVisible(false)
            return self
        end;

        setPosition = function(self, x, y, rel)
            base.setPosition(self, x, y, rel)
            pWindow.basalt_reposition(self:getAnchorPosition())
            return self
        end;

        setValuesByXMLData = function(self, data)
            base.setValuesByXMLData(self, data)
            if(xmlValue("path", data)~=nil)then cachedPath = xmlValue("path", data) end
            if(xmlValue("execute", data)~=nil)then if(xmlValue("execute", data))then if(cachedPath~=nil)then self:execute(cachedPath) end end end
        end,

        getBasaltWindow = function()
            return pWindow
        end;

        getBasaltProcess = function()
            return curProcess
        end;

        setSize = function(self, width, height, rel)
            base.setSize(self, width, height, rel)
            pWindow.basalt_resize(self:getWidth(), self:getHeight())
            return self
        end;

        getStatus = function(self)
            if (curProcess ~= nil) then
                return curProcess:getStatus()
            end
            return "inactive"
        end;

        execute = function(self, path, ...)
            cachedPath = path or cachedPath
            curProcess = process:new(cachedPath, pWindow, ...)
            pWindow.setBackgroundColor(colors.black)
            pWindow.setTextColor(colors.white)
            pWindow.clear()
            pWindow.setCursorPos(1, 1)
            pWindow.setBackgroundColor(self.bgColor)
            pWindow.setTextColor(self.fgColor)
            pWindow.basalt_setVisible(true)
            curProcess:resume()
            paused = false
            if(self.parent~=nil)then
                self.parent:addEvent("mouse_click", self)
                self.parent:addEvent("mouse_up", self)
                self.parent:addEvent("mouse_drag", self)
                self.parent:addEvent("mouse_scroll", self)
                self.parent:addEvent("key", self)
                self.parent:addEvent("key_up", self)
                self.parent:addEvent("char", self)
                self.parent:addEvent("other_event", self)
            end
            return self
        end;

        stop = function(self)
            if (curProcess ~= nil) then
                if not (curProcess:isDead()) then
                    curProcess:resume("terminate")
                    if (curProcess:isDead()) then
                        if (self.parent ~= nil) then
                            self.parent:setCursor(false)
                        end
                    end
                end
            end
            self.parent:removeEvents(self)
            return self
        end;

        pause = function(self, p)
            paused = p or (not paused)
            if (curProcess ~= nil) then
                if not (curProcess:isDead()) then
                    if not (paused) then
                        self:injectEvents(queuedEvent)
                        queuedEvent = {}
                    end
                end
            end
            return self
        end;

        isPaused = function(self)
            return paused
        end;

        injectEvent = function(self, event, p1, p2, p3, p4, ign)
            if (curProcess ~= nil) then
                if not (curProcess:isDead()) then
                    if (paused == false) or (ign) then
                        curProcess:resume(event, p1, p2, p3, p4)
                    else
                        table.insert(queuedEvent, { event = event, args = { p1, p2, p3, p4 } })
                    end
                end
            end
            return self
        end;

        getQueuedEvents = function(self)
            return queuedEvent
        end;

        updateQueuedEvents = function(self, events)
            queuedEvent = events or queuedEvent
            return self
        end;

        injectEvents = function(self, events)
            if (curProcess ~= nil) then
                if not (curProcess:isDead()) then
                    for _, value in pairs(events) do
                        curProcess:resume(value.event, table.unpack(value.args))
                    end
                end
            end
            return self
        end;

        mouseHandler = function(self, button, x, y)
            if (base.mouseHandler(self, button, x, y)) then
                mouseEvent(self, "mouse_click", button, x, y)
                return true
            end
            return false
        end,

        mouseUpHandler = function(self, button, x, y)
            if (base.mouseUpHandler(self, button, x, y)) then
                mouseEvent(self, "mouse_up", button, x, y)
                return true
            end
            return false
        end,

        scrollHandler = function(self, dir, x, y)
            if (base.scrollHandler(self, dir, x, y)) then
                mouseEvent(self, "mouse_scroll", dir, x, y)
                return true
            end
            return false
        end,

        dragHandler = function(self, button, x, y)
            if (base.dragHandler(self, button, x, y)) then
                mouseEvent(self, "mouse_drag", button, x, y)
                return true
            end
            return false
        end,

        keyHandler = function(self, key, isHolding)
            if(base.keyHandler(self, key, isHolding))then
                keyEvent(self, "key", key, isHolding)
                return true
            end
            return false
        end,

        keyUpHandler = function(self, key)
            if(base.keyUpHandler(self, key))then
                keyEvent(self, "key_up", key)
                return true
            end
            return false
        end,

        charHandler = function(self, char)
            if(base.charHandler(self, char))then
                keyEvent(self, "char", char)
                return true
            end
            return false
        end,

        getFocusHandler = function(self)
            base.getFocusHandler(self)
            if (curProcess ~= nil) then
                if not (curProcess:isDead()) then
                    if not (paused) then
                        if (self.parent ~= nil) then
                            local xCur, yCur = pWindow.getCursorPos()
                            local obx, oby = self:getAnchorPosition()
                            if (self.parent ~= nil) then
                                local w,h = self:getSize()
                                if (obx + xCur - 1 >= 1 and obx + xCur - 1 <= obx + w - 1 and yCur + oby - 1 >= 1 and yCur + oby - 1 <= oby + h - 1) then
                                    self.parent:setCursor(pWindow.getCursorBlink(), obx + xCur - 1, yCur + oby - 1, pWindow.getTextColor())
                                end
                            end
                        end
                    end
                end
            end
        end,

        loseFocusHandler = function(self)
            base.loseFocusHandler(self)
            if (curProcess ~= nil) then
                if not (curProcess:isDead()) then
                    if (self.parent ~= nil) then
                        self.parent:setCursor(false)
                    end
                end
            end
        end,

        eventHandler = function(self, event, p1, p2, p3, p4)
            if(base.eventHandler(self, event, p1, p2, p3, p4))then
                if (curProcess == nil) then
                    return
                end
                if(event=="dynamicValueEvent")then
                    local w, h = pWindow.getSize()
                    local pW, pH = self:getSize()
                    if(w~=pW)or(h~=pH)then
                        pWindow.basalt_resize(pW, pH)
                        if not (curProcess:isDead()) then
                            curProcess:resume("term_resize")
                        end
                    end
                    pWindow.basalt_reposition(self:getAnchorPosition())
                    
                end
                if not (curProcess:isDead()) then
                    if not (paused) then
                        if(event ~= "terminate") then
                            curProcess:resume(event, p1, p2, p3, p4)
                        end
                        if (self:isFocused()) then
                            local obx, oby = self:getAnchorPosition()
                            local xCur, yCur = pWindow.getCursorPos()
                            if (self.parent ~= nil) then
                                local w,h = self:getSize()
                                if (obx + xCur - 1 >= 1 and obx + xCur - 1 <= obx + w - 1 and yCur + oby - 1 >= 1 and yCur + oby - 1 <= oby + h - 1) then
                                    self.parent:setCursor(pWindow.getCursorBlink(), obx + xCur - 1, yCur + oby - 1, pWindow.getTextColor())
                                end
                            end

                            if (event == "terminate") then
                                log(self:isFocused())
                                curProcess:resume(event)
                                self.parent:setCursor(false)
                                return true
                            end
                        end
                    else
                        table.insert(queuedEvent, { event = event, args = { p1, p2, p3, p4 } })
                    end
                end
                return false
            end
        end,

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    local w,h = self:getSize()
                    pWindow.basalt_reposition(obx, oby)
                    pWindow.basalt_update()
                end
            end
        end,

        init = function(self)
            self.bgColor = self.parent:getTheme("ProgramBG")
        end,

    }

    return setmetatable(object, base)
end