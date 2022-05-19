-- current version 1
local theme = {
    basaltBG = colors.lightGray,
    basaltFG = colors.black,
    FrameBG = colors.gray,
    FrameFG = colors.black,
    ButtonBG = colors.gray,
    ButtonFG = colors.black,
    CheckboxBG = colors.gray,
    CheckboxFG = colors.black,
    InputBG = colors.gray,
    InputFG = colors.black,
    textfieldBG = colors.gray,
    textfieldFG = colors.black,
    listBG = colors.gray,
    listFG = colors.black,
    dropdownBG = colors.gray,
    dropdownFG = colors.black,
    radioBG = colors.gray,
    radioFG = colors.black,
    selectionBG = colors.black,
    selectionFG = colors.lightGray,
}

local basalt = { debugger = true, version = 1 }
local activeFrame
local frames = {}

local keyModifier = {}
local parentTerminal = term.current()

local sub = string.sub

local function getTextHorizontalAlign(text, width, textAlign)
    text = string.sub(text, 1, width)
    local offset = width - string.len(text)
    if (textAlign == "right") then
        text = string.rep(" ", offset) .. text
    elseif (textAlign == "center") then
        text = string.rep(" ", math.floor(offset / 2)) .. text .. string.rep(" ", math.floor(offset / 2))
        text = text .. (string.len(text) < width and " " or "")
    else
        text = text .. string.rep(" ", offset)
    end
    return text
end

local function getTextVerticalAlign(h, textAlign)
    local offset = 0
    if (textAlign == "center") then
        offset = math.ceil(h / 2)
        if (offset < 1) then
            offset = 1
        end
    end
    if (textAlign == "bottom") then
        offset = h
    end
    return offset
end

local function rpairs(t)
    return function(t, i)
        i = i - 1
        if i ~= 0 then
            return i, t[i]
        end
    end, t, #t + 1
end

local tHex = { -- copy paste is a very important feature
    [colors.white] = "0",
    [colors.orange] = "1",
    [colors.magenta] = "2",
    [colors.lightBlue] = "3",
    [colors.yellow] = "4",
    [colors.lime] = "5",
    [colors.pink] = "6",
    [colors.gray] = "7",
    [colors.lightGray] = "8",
    [colors.cyan] = "9",
    [colors.purple] = "a",
    [colors.blue] = "b",
    [colors.brown] = "c",
    [colors.green] = "d",
    [colors.red] = "e",
    [colors.black] = "f",
}

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

local function BasaltEvents()

    local events = {}
    local index = {}

    local event = {
        registerEvent = function(self, _event, func)
            if (events[_event] == nil) then
                events[_event] = {}
                index[_event] = 1
            end
            events[_event][index[_event]] = func
            index[_event] = index[_event] + 1
            return index[_event] - 1
        end;

        removeEvent = function(self, _event, index)
            events[_event][index[_event]] = nil
        end;

        sendEvent = function(self, _event, ...)
            if (events[_event] ~= nil) then
                for _, value in pairs(events[_event]) do
                    value(...)
                end
            end
        end;
    }
    event.__index = event
    return event
end

local processes = {}
local process = {}
local processId = 0

function process:new(path, window, ...)
    local args = table.pack(...)
    local newP = setmetatable({ path = path }, { __index = self })
    newP.window = window
    newP.processId = processId
    newP.coroutine = coroutine.create(function()
        os.run({ basalt = basalt }, path, table.unpack(args))
    end)
    processes[processId] = newP
    processId = processId + 1
    return newP
end

function process:resume(event, ...)
    term.redirect(self.window)
    local ok, result = coroutine.resume(self.coroutine, event, ...)
    self.window = term.current()
    if ok then
        self.filter = result
    else
        basalt.debug(result)
    end
end

function process:isDead()
    if (self.coroutine ~= nil) then
        if (coroutine.status(self.coroutine) == "dead") then
            table.remove(processes, self.processId)
            return true
        end
    else
        return true
    end
    return false
end

function process:getStatus()
    if (self.coroutine ~= nil) then
        return coroutine.status(self.coroutine)
    end
    return nil
end

function process:start()
    coroutine.resume(self.coroutine)
end

local function Object(name)
    -- Base object
    local objectType = "Object" -- not changeable
    --[[
    local horizontalAnchor = "left"
    local verticalAnchor = "top"
    local ignYOffset = false
    local ignXOffset = false  ]]
    local value
    local zIndex = 1
    local hanchor = "left"
    local vanchor = "top"
    local ignOffset = false
    local isVisible = false

    local visualsChanged = true

    local eventSystem = BasaltEvents()

    local object = {
        x = 1,
        y = 1,
        width = 1,
        height = 1,
        bgColor = colors.black,
        fgColor = colors.white,
        name = name or "Object",
        parent = nil,

        show = function(self)
            isVisible = true
            visualsChanged = true
            return self
        end;

        hide = function(self)
            isVisible = false
            visualsChanged = true
            return self
        end;

        isVisible = function(self)
            return isVisible
        end;

        getZIndex = function(self)
            return zIndex;
        end;

        setFocus = function(self)
            if (self.parent ~= nil) then
                self.parent:setFocusedObject(self)
            end
            return self
        end;

        setZIndex = function(self, index)
            zIndex = index
            if (self.parent ~= nil) then
                self.parent:removeObject(self)
                self.parent:addObject(self)
            end
            return self
        end;

        getType = function(self)
            return objectType
        end;

        getName = function(self)
            return self.name
        end;

        remove = function(self)
            if (self.parent ~= nil) then
                self.parent:removeObject(self)
            end
            return self
        end;

        setParent = function(self, frame)
            if (frame.getType ~= nil and frame:getType() == "Frame") then
                self:remove()
                frame:addObject(self)
                if (self.draw) then
                    self:show()
                end
            end
            return self
        end;

        setValue = function(self, _value)
            if (value ~= _value) then
                value = _value
                visualsChanged = true
                self:valueChangedHandler()
            end
            return self
        end;

        getValue = function(self)
            return value
        end;

        getVisualChanged = function(self)
            return visualsChanged
        end;

        setVisualChanged = function(self, change)
            visualsChanged = change or true
            return self
        end;


        getEventSystem = function(self)
            return eventSystem
        end;


        getParent = function(self)
            return self.parent
        end;

        setPosition = function(self, xPos, yPos, rel)
            if (rel) then
                self.x, self.y = self.x + xPos, self.y + yPos
            else
                self.x, self.y = xPos, yPos
            end
            visualsChanged = true
            return self
        end;

        getPosition = function(self)
            return self.x, self.y
        end;

        getVisibility = function(self)
            return isVisible
        end;

        setVisibility = function(self, _isVisible)
            isVisible = _isVisible or not isVisible
            visualsChanged = true
            return self
        end;

        setSize = function(self, width, height)
            self.width, self.height = width, height
            visualsChanged = true
            return self
        end;

        getHeight = function(self)
            return self.height
        end;

        getWidth = function(self)
            return self.w
        end;

        setBackground = function(self, color)
            self.bgColor = color
            visualsChanged = true
            return self
        end;

        getBackground = function(self)
            return self.bgColor
        end;

        setForeground = function(self, color)
            self.fgColor = color
            visualsChanged = true
            return self
        end;

        getForeground = function(self)
            return self.fgColor
        end;

        draw = function(self)
            if (isVisible) then
                return true
            end
            return false
        end;


        getAbsolutePosition = function(self, x, y)
            -- relative position to absolute position
            if (x == nil) then
                x = self.x
            end
            if (y == nil) then
                y = self.y
            end

            if (self.parent ~= nil) then
                local fx, fy = self.parent:getAbsolutePosition(self.parent:getAnchorPosition())
                x = fx + x - 1
                y = fy + y - 1
            end
            return x, y
        end;

        getAnchorPosition = function(self, x, y, ignOff)
            if (x == nil) then
                x = self.x
            end
            if (y == nil) then
                y = self.y
            end
            if (hanchor == "right") then
                x = self.parent.width - x - self.width + 2
            end
            if (vanchor == "bottom") then
                y = self.parent.height - y - self.height + 2
            end
            local xO, yO = self:getOffset()
            if (ignOffset or ignOff) then
                return x, y
            end
            return x + xO, y + yO
        end;

        getOffset = function(self)
            if (self.parent ~= nil) and (ignOffset == false) then
                return self.parent:getFrameOffset()
            end
            return 0, 0
        end;

        ignoreOffset = function(self, ignore)
            ignOffset = ignore or true
            return self
        end;

        setAnchor = function(self, ...)
            for _, value in pairs(table.pack(...)) do
                if (value == "right") or (value == "left") then
                    hanchor = value
                end
                if (value == "top") or (value == "bottom") then
                    vanchor = value
                end
            end
            visualsChanged = true
            return self
        end;

        getAnchor = function(self)
            return hanchor, vanchor
        end;

        onChange = function(self, func)
            self:registerEvent("value_changed", func)
            return self
        end;

        onClick = function(self, func)
            self:registerEvent("mouse_click", func)
            return self
        end;

        onEvent = function(self, func)
            self:registerEvent("custom_event_handler", func)
            return self
        end;

        onClickUp = function(self, func)
            self:registerEvent("mouse_up", func)
            return self
        end;

        onKey = function(self, func)
            self:registerEvent("key", func)
            self:registerEvent("char", func)
            return self
        end;

        onKeyUp = function(self, func)
            self:registerEvent("key_up", func)
            return self
        end;

        onBackgroundKey = function(self, func)
            self:registerEvent("background_key", func)
            self:registerEvent("background_char", func)
            return self
        end;

        onBackgroundKeyUp = function(self, func)
            self:registerEvent("background_key_up", func)
            return self
        end;

        isFocused = function(self)
            if (self.parent ~= nil) then
                return self.parent:getFocusedObject() == self
            end
            return false
        end;

        onGetFocus = function(self, func)
            self:registerEvent("get_focus", func)
            return self
        end;

        onLoseFocus = function(self, func)
            self:registerEvent("lose_focus", func)
            return self
        end;

        registerEvent = function(self, event, func)
            return eventSystem:registerEvent(event, func)
        end;

        removeEvent = function(self, event, index)
            return eventSystem:removeEvent(event, index)
        end;

        sendEvent = function(self, event, ...)
            return eventSystem:sendEvent(event, self, ...)
        end;

        mouseClickHandler = function(self, event, button, x, y)
            local objX, objY = self:getAbsolutePosition(self:getAnchorPosition())
            if (objX <= x) and (objX + self.width > x) and (objY <= y) and (objY + self.height > y) and (isVisible) then
                if (self.parent ~= nil) then
                    self.parent:setFocusedObject(self)
                end
                eventSystem:sendEvent(event, self, event, button, x, y)
                return true
            end
            return false
        end;

        keyHandler = function(self, event, key)
            if (self:isFocused()) then
                eventSystem:sendEvent(event, self, event, key)
                return true
            end
            return false
        end;

        backgroundKeyHandler = function(self, event, key)
            eventSystem:sendEvent("background_" .. event, self, event, key)
        end;

        valueChangedHandler = function(self)
            eventSystem:sendEvent("value_changed", self)
        end;

        eventHandler = function(self, event, p1, p2, p3, p4)
            eventSystem:sendEvent("custom_event_handler", self, event, p1, p2, p3, p4)
        end;

        getFocusHandler = function(self)
            eventSystem:sendEvent("get_focus", self)
        end;

        loseFocusHandler = function(self)
            eventSystem:sendEvent("lose_focus", self)
        end;


    }

    object.__index = object
    return object
end

local function Button(name)
    -- Button
    local base = Object(name)
    local objectType = "Button"

    base:setValue("Button")
    base:setZIndex(5)
    base.width = 8
    base.bgColor = theme.ButtonBG
    base.fgColor = theme.ButtonFG

    local textHorizontalAlign = "center"
    local textVerticalAlign = "center"

    local object = {
        getType = function(self)
            return objectType
        end;
        setHorizontalAlign = function(self, pos)
            textHorizontalAlign = pos
        end;

        setVerticalAlign = function(self, pos)
            textVerticalAlign = pos
        end;

        setText = function(self, text)
            base:setValue(text)
            return self
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    local verticalAlign = getTextVerticalAlign(self.height, textVerticalAlign)

                    self.parent:drawBackgroundBox(obx, oby, self.width, self.height, self.bgColor)
                    self.parent:drawForegroundBox(obx, oby, self.width, self.height, self.fgColor)
                    self.parent:drawTextBox(obx, oby, self.width, self.height, " ")
                    for n = 1, self.height do
                        if (n == verticalAlign) then
                            self.parent:setText(obx, oby + (n - 1), getTextHorizontalAlign(self:getValue(), self.width, textHorizontalAlign))
                        end
                    end
                end
            end
        end;

    }
    return setmetatable(object, base)
end

local function Program(name)
    local base = Object(name)
    local objectType = "Program"
    base:setZIndex(5)
    local object

    local function createBasaltWindow(x, y, width, height)
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
            tPalette[c] = { parentTerminal.getPaletteColour(c) }
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
        end

        local function setBG(_x, _y, colorStr)
            if (colorStr ~= nil) then
                local gBG = cacheBG[_y]
                if (gBG ~= nil) then
                    cacheBG[_y] = sub(gBG:sub(1, _x - 1) .. colorStr .. gBG:sub(_x + (colorStr:len()), width), 1, width)
                end
            end
        end

        local function setFG(_x, _y, colorStr)
            if (colorStr ~= nil) then
                local gFG = cacheFG[_y]
                if (gFG ~= nil) then
                    cacheFG[_y] = sub(gFG:sub(1, _x - 1) .. colorStr .. gFG:sub(_x + (colorStr:len()), width), 1, width)
                end
            end
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
                if (object.parent ~= nil) then
                    for n = 1, height do
                        object.parent:setText(x, y + (n - 1), cacheT[n])
                        object.parent:setBG(x, y + (n - 1), cacheBG[n])
                        object.parent:setFG(x, y + (n - 1), cacheFG[n])
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
                return parentTerminal.isColor()
            end;

            isColour = function()
                return parentTerminal.isColor()
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
                    --setText(xCursor, yCursor, text)
                    --setBG(xCursor, yCursor, bgcol)
                    --setFG(xCursor, yCursor, fgcol)
                    --xCursor = xCursor+text:len()
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

        getBasaltWindow = function()
            return pWindow
        end;

        getBasaltProcess = function()
            return curProcess
        end;

        setSize = function(self, width, height)
            base.setSize(self, width, height)
            pWindow.basalt_resize(self.width, self.height)
            return self
        end;

        getStatus = function(self)
            if (curProcess ~= nil) then
                return curProcess:getStatus()
            end
            return "inactive"
        end;

        execute = function(self, path, ...)
            curProcess = process:new(path, pWindow, ...)
            pWindow.setBackgroundColor(colors.black)
            pWindow.setTextColor(colors.white)
            pWindow.clear()
            pWindow.setCursorPos(1, 1)
            curProcess:resume()
            paused = false
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

        mouseClickHandler = function(self, event, button, x, y)
            if (base.mouseClickHandler(self, event, button, x, y)) then
                if (curProcess == nil) then
                    return false
                end
                if not (curProcess:isDead()) then
                    if not (paused) then
                        local absX, absY = self:getAbsolutePosition(self:getAnchorPosition(nil, nil, true))
                        curProcess:resume(event, button, x - absX + 1, y - absY + 1)
                    end
                end
                return true
            end
        end;

        keyHandler = function(self, event, key)
            base.keyHandler(self, event, key)
            if (self:isFocused()) then
                if (curProcess == nil) then
                    return false
                end
                if not (curProcess:isDead()) then
                    if not (paused) then
                        if (self.draw) then
                            curProcess:resume(event, key)
                        end
                    end
                end
            end
        end;

        getFocusHandler = function(self)
            base.getFocusHandler(self)
            if (curProcess ~= nil) then
                if not (curProcess:isDead()) then
                    if not (paused) then
                        if (self.parent ~= nil) then
                            local xCur, yCur = pWindow.getCursorPos()
                            local obx, oby = self:getAnchorPosition()
                            if (self.parent ~= nil) then
                                if (obx + xCur - 1 >= 1 and obx + xCur - 1 <= obx + self.width - 1 and yCur + oby - 1 >= 1 and yCur + oby - 1 <= oby + self.height - 1) then
                                    self.parent:setCursor(pWindow.getCursorBlink(), obx + xCur - 1, yCur + oby - 1, pWindow.getTextColor())
                                end
                            end
                        end
                    end
                end
            end
        end;

        loseFocusHandler = function(self)
            base.loseFocusHandler(self)
            if (curProcess ~= nil) then
                if not (curProcess:isDead()) then
                    if (self.parent ~= nil) then
                        self.parent:setCursor(false)
                    end
                end
            end
        end;

        eventHandler = function(self, event, p1, p2, p3, p4)
            if (curProcess == nil) then
                return
            end
            if not (curProcess:isDead()) then
                if not (paused) then
                    if (event ~= "mouse_click") and (event ~= "mouse_up") and (event ~= "mouse_scroll") and (event ~= "mouse_drag") and (event ~= "key_up") and (event ~= "key") and (event ~= "char") and (event ~= "terminate") then
                        curProcess:resume(event, p1, p2, p3, p4)
                    end
                    if (self:isFocused()) then
                        local obx, oby = self:getAnchorPosition()
                        local xCur, yCur = pWindow.getCursorPos()
                        if (self.parent ~= nil) then
                            if (obx + xCur - 1 >= 1 and obx + xCur - 1 <= obx + self.width - 1 and yCur + oby - 1 >= 1 and yCur + oby - 1 <= oby + self.height - 1) then
                                self.parent:setCursor(pWindow.getCursorBlink(), obx + xCur - 1, yCur + oby - 1, pWindow.getTextColor())
                            end
                        end

                        if (event == "terminate") and (self:isFocused()) then
                            self:stop()
                        end
                    end
                else
                    if (event ~= "mouse_click") and (event ~= "mouse_up") and (event ~= "mouse_scroll") and (event ~= "mouse_drag") and (event ~= "key_up") and (event ~= "key") and (event ~= "char") and (event ~= "terminate") then
                        table.insert(queuedEvent, { event = event, args = { p1, p2, p3, p4 } })
                    end
                end
            end
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    pWindow.basalt_reposition(obx, oby)
                    self.parent:drawBackgroundBox(obx, oby, self.width, self.height, self.bgColor)
                    pWindow.basalt_update()
                end
            end
        end;

    }

    return setmetatable(object, base)
end

local function Label(name)
    -- Label
    local base = Object(name)
    local objectType = "Label"

    base:setZIndex(3)

    local autoWidth = true
    base:setValue("")

    local object = {
        getType = function(self)
            return objectType
        end;
        setText = function(self, text)
            text = tostring(text)
            base:setValue(text)
            if (autoWidth) then
                self.width = text:len()
            end
            return self
        end;

        setSize = function(self, width, h)
            self.width, self.height = width, h
            autoWidth = false
            return self
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    self.parent:writeText(obx, oby, self:getValue(), self.bgColor, self.fgColor)
                end
            end
        end;

    }

    return setmetatable(object, base)
end

local function Pane(name)
    -- Pane
    local base = Object(name)
    local objectType = "Pane"

    local object = {
        getType = function(self)
            return objectType
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    self.parent:drawBackgroundBox(obx, oby, self.width, self.height, self.bgColor)
                    self.parent:drawForegroundBox(obx, oby, self.width, self.height, self.bgColor)
                end
            end
        end;

    }

    return setmetatable(object, base)
end

local function Image(name)
    -- Pane
    local base = Object(name)
    local objectType = "Image"
    base:setZIndex(2)
    local image
    local shrinkedImage
    local imageGotShrinked = false

    local function shrink()

        -- shrinkSystem is copy pasted (and slightly changed) from blittle by Bomb Bloke: http://www.computercraft.info/forums2/index.php?/topic/25354-cc-176-blittle-api/
        local relations = { [0] = { 8, 4, 3, 6, 5 }, { 4, 14, 8, 7 }, { 6, 10, 8, 7 }, { 9, 11, 8, 0 }, { 1, 14, 8, 0 }, { 13, 12, 8, 0 }, { 2, 10, 8, 0 }, { 15, 8, 10, 11, 12, 14 },
                            { 0, 7, 1, 9, 2, 13 }, { 3, 11, 8, 7 }, { 2, 6, 7, 15 }, { 9, 3, 7, 15 }, { 13, 5, 7, 15 }, { 5, 12, 8, 7 }, { 1, 4, 7, 15 }, { 7, 10, 11, 12, 14 } }

        local colourNum, exponents, colourChar = {}, {}, {}
        for i = 0, 15 do
            exponents[2 ^ i] = i
        end
        do
            local hex = "0123456789abcdef"
            for i = 1, 16 do
                colourNum[hex:sub(i, i)] = i - 1
                colourNum[i - 1] = hex:sub(i, i)
                colourChar[hex:sub(i, i)] = 2 ^ (i - 1)
                colourChar[2 ^ (i - 1)] = hex:sub(i, i)

                local thisRel = relations[i - 1]
                for i = 1, #thisRel do
                    thisRel[i] = 2 ^ thisRel[i]
                end
            end
        end

        local function getBestColourMatch(usage)
            local lastCol = relations[exponents[usage[#usage][1]]]

            for j = 1, #lastCol do
                local thisRelation = lastCol[j]
                for i = 1, #usage - 1 do
                    if usage[i][1] == thisRelation then
                        return i
                    end
                end
            end

            return 1
        end

        local function colsToChar(pattern, totals)
            if not totals then
                local newPattern = {}
                totals = {}
                for i = 1, 6 do
                    local thisVal = pattern[i]
                    local thisTot = totals[thisVal]
                    totals[thisVal], newPattern[i] = thisTot and (thisTot + 1) or 1, thisVal
                end
                pattern = newPattern
            end

            local usage = {}
            for key, value in pairs(totals) do
                usage[#usage + 1] = { key, value }
            end

            if #usage > 1 then
                -- Reduce the chunk to two colours:
                while #usage > 2 do
                    table.sort(usage, function(a, b)
                        return a[2] > b[2]
                    end)
                    local matchToInd, usageLen = getBestColourMatch(usage), #usage
                    local matchFrom, matchTo = usage[usageLen][1], usage[matchToInd][1]
                    for i = 1, 6 do
                        if pattern[i] == matchFrom then
                            pattern[i] = matchTo
                            usage[matchToInd][2] = usage[matchToInd][2] + 1
                        end
                    end
                    usage[usageLen] = nil
                end

                -- Convert to character. Adapted from oli414's function:
                -- http://www.computercraft.info/forums2/index.php?/topic/25340-cc-176-easy-drawing-characters/
                local data = 128
                for i = 1, #pattern - 1 do
                    if pattern[i] ~= pattern[6] then
                        data = data + 2 ^ (i - 1)
                    end
                end
                return string.char(data), colourChar[usage[1][1] == pattern[6] and usage[2][1] or usage[1][1]], colourChar[pattern[6]]
            else
                -- Solid colour character:
                return "\128", colourChar[pattern[1]], colourChar[pattern[1]]
            end
        end

        local results, width, height, bgCol = { {}, {}, {} }, 0, #image + #image % 3, base.bgColor or colors.black
        for i = 1, #image do
            if #image[i] > width then
                width = #image[i]
            end
        end

        for y = 0, height - 1, 3 do
            local cRow, tRow, bRow, counter = {}, {}, {}, 1

            for x = 0, width - 1, 2 do
                -- Grab a 2x3 chunk:
                local pattern, totals = {}, {}

                for yy = 1, 3 do
                    for xx = 1, 2 do
                        pattern[#pattern + 1] = (image[y + yy] and image[y + yy][x + xx]) and (image[y + yy][x + xx] == 0 and bgCol or image[y + yy][x + xx]) or bgCol
                        totals[pattern[#pattern]] = totals[pattern[#pattern]] and (totals[pattern[#pattern]] + 1) or 1
                    end
                end

                cRow[counter], tRow[counter], bRow[counter] = colsToChar(pattern, totals)
                counter = counter + 1
            end

            results[1][#results[1] + 1], results[2][#results[2] + 1], results[3][#results[3] + 1] = table.concat(cRow), table.concat(tRow), table.concat(bRow)
        end

        results.width, results.height = #results[1][1], #results[1]

        shrinkedImage = results
    end

    local object = {
        getType = function(self)
            return objectType
        end;

        loadImage = function(self, path)
            image = paintutils.loadImage(path)
            imageGotShrinked = false
            return self
        end;

        loadBlittleImage = function(self, path)
            --image = paintutils.loadImage(path)
            imageGotShrinked = true
            return self
        end;

        shrinkImage = function(self)
            shrink()
            imageGotShrinked = true
            return self
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    if (image ~= nil) then
                        local obx, oby = self:getAnchorPosition()
                        if (imageGotShrinked) then
                            -- this is copy pasted (and slightly changed) from blittle by Bomb Bloke: http://www.computercraft.info/forums2/index.php?/topic/25354-cc-176-blittle-api/
                            local t, tC, bC = shrinkedImage[1], shrinkedImage[2], shrinkedImage[3]
                            for i = 1, shrinkedImage.height do
                                local tI = t[i]
                                if type(tI) == "string" then
                                    self.parent:setText(obx, oby + i - 1, tI)
                                    self.parent:setFG(obx, oby + i - 1, tC[i])
                                    self.parent:setBG(obx, oby + i - 1, bC[i])
                                elseif type(tI) == "table" then
                                    self.parent:setText(obx, oby + i - 1, tI[2])
                                    self.parent:setFG(obx, oby + i - 1, tC[i])
                                    self.parent:setBG(obx, oby + i - 1, bC[i])
                                end
                            end
                        else
                            for yPos = 1, math.min(#image, self.height) do
                                local line = image[yPos]
                                for xPos = 1, math.min(#line, self.width) do
                                    if line[xPos] > 0 then
                                        self.parent:drawBackgroundBox(obx + xPos - 1, oby + yPos - 1, 1, 1, line[xPos])
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end;
    }

    return setmetatable(object, base)
end

local function Checkbox(name)
    -- Checkbox
    local base = Object(name)
    local objectType = "Checkbox"

    base:setZIndex(5)
    base:setValue(false)
    base.width = 1
    base.height = 1
    base.bgColor = theme.CheckboxBG
    base.fgColor = theme.CheckboxFG

    local object = {
        symbol = "\42",

        getType = function(self)
            return objectType
        end;

        mouseClickHandler = function(self, event, button, x, y)
            if (base.mouseClickHandler(self, event, button, x, y)) then
                if (event == "mouse_click") and (button == 1) then
                    if (self:getValue() ~= true) and (self:getValue() ~= false) then
                        self:setValue(false)
                    else
                        self:setValue(not self:getValue())
                    end
                end
                return true
            end
            return false
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    local verticalAlign = getTextVerticalAlign(self.height, "center")

                    self.parent:drawBackgroundBox(obx, oby, self.width, self.height, self.bgColor)
                    for n = 1, self.height do
                        if (n == verticalAlign) then
                            if (self:getValue() == true) then
                                self.parent:writeText(obx, oby + (n - 1), getTextHorizontalAlign(self.symbol, self.width, "center"), self.bgColor, self.fgColor)
                            else
                                self.parent:writeText(obx, oby + (n - 1), getTextHorizontalAlign(" ", self.width, "center"), self.bgColor, self.fgColor)
                            end
                        end
                    end
                end
            end
        end;

    }

    return setmetatable(object, base)
end

local function Progressbar(name)
    -- Checkbox
    local base = Object(name)
    local objectType = "Progressbar"

    local progress = 0

    base:setZIndex(5)
    base:setValue(false)
    base.width = 25
    base.height = 1
    base.bgColor = theme.CheckboxBG
    base.fgColor = theme.CheckboxFG

    local activeBarColor = colors.black
    local activeBarSymbol = ""
    local activeBarSymbolCol = colors.white
    local bgBarSymbol = ""
    local direction = 0

    local object = {

        getType = function(self)
            return objectType
        end;

        setDirection = function(self, dir)
            direction = dir
            return self
        end;

        setProgressBar = function(self, color, symbol, symbolcolor)
            activeBarColor = color or activeBarColor
            activeBarSymbol = symbol or activeBarSymbol
            activeBarSymbolCol = symbolcolor or activeBarSymbolCol
            return self
        end;

        setBackgroundSymbol = function(self, symbol)
            bgBarSymbol = symbol:sub(1, 1)
            return self
        end;

        setProgress = function(self, value)
            if (value >= 0) and (value <= 100) and (progress ~= value) then
                progress = value
                self:setValue(progress)
                if (progress == 100) then
                    self:progressDoneHandler()
                end
            end
            return self
        end;

        getProgress = function(self)
            return progress
        end;

        onProgressDone = function(self, f)
            self:registerEvent("progress_done", f)
            return self
        end;

        progressDoneHandler = function(self)
            self:sendEvent("progress_done")
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    self.parent:drawBackgroundBox(obx, oby, self.width, self.height, self.bgColor)
                    self.parent:drawForegroundBox(obx, oby, self.width, self.height, self.fgColor)
                    self.parent:drawTextBox(obx, oby, self.width, self.height, bgBarSymbol)
                    if (direction == 1) then
                        self.parent:drawBackgroundBox(obx, oby, self.width, self.height / 100 * progress, activeBarColor)
                        self.parent:drawForegroundBox(obx, oby, self.width, self.height / 100 * progress, activeBarSymbolCol)
                        self.parent:drawTextBox(obx, oby, self.width, self.height / 100 * progress, activeBarSymbol)
                    elseif (direction == 2) then
                        self.parent:drawBackgroundBox(obx, oby + math.ceil(self.height - self.height / 100 * progress), self.width, self.height / 100 * progress, activeBarColor)
                        self.parent:drawForegroundBox(obx, oby + math.ceil(self.height - self.height / 100 * progress), self.width, self.height / 100 * progress, activeBarSymbolCol)
                        self.parent:drawTextBox(obx, oby + math.ceil(self.height - self.height / 100 * progress), self.width, self.height / 100 * progress, activeBarSymbol)
                    elseif (direction == 3) then
                        self.parent:drawBackgroundBox(obx + math.ceil(self.width - self.width / 100 * progress), oby, self.width / 100 * progress, self.height, activeBarColor)
                        self.parent:drawForegroundBox(obx + math.ceil(self.width - self.width / 100 * progress), oby, self.width / 100 * progress, self.height, activeBarSymbolCol)
                        self.parent:drawTextBox(obx + math.ceil(self.width - self.width / 100 * progress), oby, self.width / 100 * progress, self.height, activeBarSymbol)
                    else
                        self.parent:drawBackgroundBox(obx, oby, self.width / 100 * progress, self.height, activeBarColor)
                        self.parent:drawForegroundBox(obx, oby, self.width / 100 * progress, self.height, activeBarSymbolCol)
                        self.parent:drawTextBox(obx, oby, self.width / 100 * progress, self.height, activeBarSymbol)
                    end
                end
            end
        end;

    }

    return setmetatable(object, base)
end

local function Input(name)
    -- Input
    local base = Object(name)
    local objectType = "Input"

    local inputType = "text"
    local inputLimit = 0
    base:setZIndex(5)
    base:setValue("")
    base.width = 10
    base.height = 1
    base.bgColor = theme.InputBG
    base.fgColor = theme.InputFG

    local textX = 1
    local wIndex = 1

    local defaultText = ""
    local defaultBGCol
    local defaultFGCol
    local showingText = defaultText
    local internalValueChange = false

    local object = {

        getType = function(self)
            return objectType
        end;

        setInputType = function(self, iType)
            if (iType == "password") or (iType == "number") or (iType == "text") then
                inputType = iType
            end
            return self
        end;

        setDefaultText = function(self, text, fCol, bCol)
            defaultText = text
            defaultBGCol = bCol or defaultBGCol
            defaultFGCol = fCol or defaultFGCol
            if (self:isFocused()) then
                showingText = ""
            else
                showingText = defaultText
            end
            return self
        end;

        getInputType = function(self)
            return inputType
        end;

        setValue = function(self, val)
            base.setValue(self, tostring(val))
            if not (internalValueChange) then
                textX = tostring(val):len() + 1
            end
            return self
        end;

        getValue = function(self)
            local val = base.getValue(self)
            return inputType == "number" and tonumber(val) or val
        end;

        setInputLimit = function(self, limit)
            inputLimit = tonumber(limit) or inputLimit
            return self
        end;

        getInputLimit = function(self)
            return inputLimit
        end;

        getFocusHandler = function(self)
            base.getFocusHandler(self)
            if (self.parent ~= nil) then
                local obx, oby = self:getAnchorPosition()
                showingText = ""
                if (self.parent ~= nil) then
                    self.parent:setCursor(true, obx + textX - wIndex, oby, self.fgColor)
                end
            end
        end;

        loseFocusHandler = function(self)
            base.loseFocusHandler(self)
            if (self.parent ~= nil) then
                self.parent:setCursor(false)
                showingText = defaultText
            end
        end;

        keyHandler = function(self, event, key)
            if (base.keyHandler(self, event, key)) then
                internalValueChange = true
                if (event == "key") then
                    if (key == keys.backspace) then
                        -- on backspace
                        local text = tostring(base.getValue())
                        if (textX > 1) then
                            self:setValue(text:sub(1, textX - 2) .. text:sub(textX, text:len()))
                            if (textX > 1) then
                                textX = textX - 1
                            end
                            if (wIndex > 1) then
                                if (textX < wIndex) then
                                    wIndex = wIndex - 1
                                end
                            end
                        end
                    end
                    if (key == keys.enter) then
                        -- on enter
                        if (self.parent ~= nil) then
                            --self.parent:removeFocusedObject(self)
                        end
                    end
                    if (key == keys.right) then
                        -- right arrow
                        local tLength = tostring(base.getValue()):len()
                        textX = textX + 1

                        if (textX > tLength) then
                            textX = tLength + 1
                        end
                        if (textX < 1) then
                            textX = 1
                        end
                        if (textX < wIndex) or (textX >= self.width + wIndex) then
                            wIndex = textX - self.width + 1
                        end
                        if (wIndex < 1) then
                            wIndex = 1
                        end
                    end

                    if (key == keys.left) then
                        -- left arrow
                        textX = textX - 1
                        if (textX >= 1) then
                            if (textX < wIndex) or (textX >= self.width + wIndex) then
                                wIndex = textX
                            end
                        end
                        if (textX < 1) then
                            textX = 1
                        end
                        if (wIndex < 1) then
                            wIndex = 1
                        end
                    end
                end

                if (event == "char") then
                    local text = base.getValue()
                    if (text:len() < inputLimit or inputLimit <= 0) then
                        if (inputType == "number") then
                            local cache = text
                            if (key == ".") or (tonumber(key) ~= nil) then
                                self:setValue(text:sub(1, textX - 1) .. key .. text:sub(textX, text:len()))
                                textX = textX + 1
                            end
                            if (tonumber(base.getValue()) == nil) then
                                self:setValue(cache)
                            end
                        else
                            self:setValue(text:sub(1, textX - 1) .. key .. text:sub(textX, text:len()))
                            textX = textX + 1
                        end
                        if (textX >= self.width + wIndex) then
                            wIndex = wIndex + 1
                        end
                    end
                end
                local obx, oby = self:getAnchorPosition()
                local val = tostring(base.getValue())
                local cursorX = (textX <= val:len() and textX - 1 or val:len()) - (wIndex - 1)

                if (cursorX > self.x + self.width - 1) then
                    cursorX = self.x + self.width - 1
                end
                if (self.parent ~= nil) then
                    self.parent:setCursor(true, obx + cursorX, oby, self.fgColor)
                end
                internalValueChange = false
            end
        end;

        mouseClickHandler = function(self, event, button, x, y)
            if (base.mouseClickHandler(self, event, button, x, y)) then
                if (event == "mouse_click") and (button == 1) then

                end
                return true
            end
            return false
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    local verticalAlign = getTextVerticalAlign(self.height, "center")

                    self.parent:drawBackgroundBox(obx, oby, self.width, self.height, self.bgColor)
                    for n = 1, self.height do
                        if (n == verticalAlign) then
                            local val = tostring(base.getValue())
                            local bCol = self.bgColor
                            local fCol = self.fgColor
                            local text
                            if (val:len() <= 0) then
                                text = showingText
                                bCol = defaultBGCol or bCol
                                fCol = defaultFGCol or fCol
                            end

                            text = showingText
                            if (val ~= "") then
                                text = val
                            end
                            text = text:sub(wIndex, self.width + wIndex - 1)
                            local space = self.width - text:len()
                            if (space < 0) then
                                space = 0
                            end
                            if (inputType == "password") and (val ~= "") then
                                text = string.rep("*", text:len())
                            end
                            text = text .. string.rep(" ", space)
                            self.parent:writeText(obx, oby + (n - 1), text, bCol, fCol)
                        end
                    end
                end
            end
        end;
    }

    return setmetatable(object, base)
end

local function Textfield(name)
    local base = Object(name)
    local objectType = "Textfield"
    local hIndex, wIndex, textX, textY = 1, 1, 1, 1

    local lines = { "" }
    local keyWords = { [colors.purple] = { "break" } }

    base.width = 20
    base.height = 8
    base.bgColor = theme.textfieldBG
    base.fgColor = theme.textfieldFG
    base:setZIndex(5)

    local object = {
        getType = function(self)
            return objectType
        end;

        getLines = function(self)
            return lines
        end;

        getLine = function(self, index)
            return lines[index] or ""
        end;

        editLine = function(self, index, text)
            lines[index] = text or lines[index]
            return self
        end;

        addLine = function(self, text, index)
            if (index ~= nil) then
                table.insert(lines, index, text)
            else
                table.insert(lines, text)
            end
            return self
        end;

        addKeyword = function(self, keyword, color)

        end;

        removeLine = function(self, index)
            table.remove(lines, index or #lines)
            if (#lines <= 0) then
                table.insert(lines, "")
            end
            return self
        end;

        getTextCursor = function(self)
            return textX, textY
        end;

        getFocusHandler = function(self)
            base.getFocusHandler(self)
            if (self.parent ~= nil) then
                local obx, oby = self:getAnchorPosition()
                if (self.parent ~= nil) then
                    self.parent:setCursor(true, obx + textX - wIndex, oby + textY - hIndex, self.fgColor)
                end
            end
        end;

        loseFocusHandler = function(self)
            base.loseFocusHandler(self)
            if (self.parent ~= nil) then
                self.parent:setCursor(false)
            end
        end;

        keyHandler = function(self, event, key)
            if (base.keyHandler(self, event, key)) then
                local obx, oby = self:getAnchorPosition()
                if (event == "key") then
                    if (key == keys.backspace) then
                        -- on backspace
                        if (lines[textY] == "") then
                            if (textY > 1) then
                                table.remove(lines, textY)
                                textX = lines[textY - 1]:len() + 1
                                wIndex = textX - self.width + 1
                                if (wIndex < 1) then
                                    wIndex = 1
                                end
                                textY = textY - 1
                            end
                        elseif (textX <= 1) then
                            if (textY > 1) then
                                textX = lines[textY - 1]:len() + 1
                                wIndex = textX - self.width + 1
                                if (wIndex < 1) then
                                    wIndex = 1
                                end
                                lines[textY - 1] = lines[textY - 1] .. lines[textY]
                                table.remove(lines, textY)
                                textY = textY - 1
                            end
                        else
                            lines[textY] = lines[textY]:sub(1, textX - 2) .. lines[textY]:sub(textX, lines[textY]:len())
                            if (textX > 1) then
                                textX = textX - 1
                            end
                            if (wIndex > 1) then
                                if (textX < wIndex) then
                                    wIndex = wIndex - 1
                                end
                            end
                        end
                        if (textY < hIndex) then
                            hIndex = hIndex - 1
                        end
                        self:setValue("")
                    end

                    if (key == keys.delete) then
                        -- on delete
                        if (textX > lines[textY]:len()) then
                            if (lines[textY + 1] ~= nil) then
                                lines[textY] = lines[textY] .. lines[textY + 1]
                                table.remove(lines, textY + 1)
                            end
                        else
                            lines[textY] = lines[textY]:sub(1, textX - 1) .. lines[textY]:sub(textX + 1, lines[textY]:len())
                        end
                    end

                    if (key == keys.enter) then
                        -- on enter
                        table.insert(lines, textY + 1, lines[textY]:sub(textX, lines[textY]:len()))
                        lines[textY] = lines[textY]:sub(1, textX - 1)
                        textY = textY + 1
                        textX = 1
                        wIndex = 1
                        if (textY - hIndex >= self.height) then
                            hIndex = hIndex + 1
                        end
                        self:setValue("")
                    end

                    if (key == keys.up) then
                        -- arrow up
                        if (textY > 1) then
                            textY = textY - 1
                            if (textX > lines[textY]:len() + 1) then
                                textX = lines[textY]:len() + 1
                            end
                            if (wIndex > 1) then
                                if (textX < wIndex) then
                                    wIndex = textX - self.width + 1
                                    if (wIndex < 1) then
                                        wIndex = 1
                                    end
                                end
                            end
                            if (hIndex > 1) then
                                if (textY < hIndex) then
                                    hIndex = hIndex - 1
                                end
                            end
                        end
                    end
                    if (key == keys.down) then
                        -- arrow down
                        if (textY < #lines) then
                            textY = textY + 1
                            if (textX > lines[textY]:len() + 1) then
                                textX = lines[textY]:len() + 1
                            end

                            if (textY >= hIndex + self.height) then
                                hIndex = hIndex + 1
                            end
                        end
                    end
                    if (key == keys.right) then
                        -- arrow right
                        textX = textX + 1
                        if (textY < #lines) then
                            if (textX > lines[textY]:len() + 1) then
                                textX = 1
                                textY = textY + 1
                            end
                        elseif (textX > lines[textY]:len()) then
                            textX = lines[textY]:len() + 1
                        end
                        if (textX < 1) then
                            textX = 1
                        end
                        if (textX < wIndex) or (textX >= self.width + wIndex) then
                            wIndex = textX - self.width + 1
                        end
                        if (wIndex < 1) then
                            wIndex = 1
                        end

                    end
                    if (key == keys.left) then
                        -- arrow left
                        textX = textX - 1
                        if (textX >= 1) then
                            if (textX < wIndex) or (textX >= self.width + wIndex) then
                                wIndex = textX
                            end
                        end
                        if (textY > 1) then
                            if (textX < 1) then
                                textY = textY - 1
                                textX = lines[textY]:len() + 1
                                wIndex = textX - self.width + 1
                            end
                        end
                        if (textX < 1) then
                            textX = 1
                        end
                        if (wIndex < 1) then
                            wIndex = 1
                        end
                    end
                end

                if (event == "char") then
                    lines[textY] = lines[textY]:sub(1, textX - 1) .. key .. lines[textY]:sub(textX, lines[textY]:len())
                    textX = textX + 1
                    if (textX >= self.width + wIndex) then
                        wIndex = wIndex + 1
                    end
                    self:setValue("")
                end

                local cursorX = (textX <= lines[textY]:len() and textX - 1 or lines[textY]:len()) - (wIndex - 1)
                if (cursorX > self.x + self.width - 1) then
                    cursorX = self.x + self.width - 1
                end
                local cursorY = (textY - hIndex < self.height and textY - hIndex or textY - hIndex - 1)
                if (cursorX < 1) then
                    cursorX = 0
                end
                self.parent:setCursor(true, obx + cursorX, oby + cursorY, self.fgColor)
                return true
            end
        end;

        mouseClickHandler = function(self, event, button, x, y)
            if (base.mouseClickHandler(self, event, button, x, y)) then
                local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
                local anchx, anchy = self:getAnchorPosition()
                if (event == "mouse_click") then
                    if (lines[y - oby + hIndex] ~= nil) then
                        textX = x - obx + wIndex
                        textY = y - oby + hIndex
                        if (textX > lines[textY]:len()) then
                            textX = lines[textY]:len() + 1
                        end
                        if (textX < wIndex) then
                            wIndex = textX - 1
                            if (wIndex < 1) then
                                wIndex = 1
                            end
                        end
                        if (self.parent ~= nil) then
                            self.parent:setCursor(true, anchx + textX - wIndex, anchy + textY - hIndex)
                        end
                    end
                end
                if (event == "mouse_drag") then
                    if (lines[y - oby + hIndex] ~= nil) then
                        textX = x - obx + wIndex
                        textY = y - oby + hIndex
                        if (textX > lines[textY]:len()) then
                            textX = lines[textY]:len() + 1
                        end
                        if (textX < wIndex) then
                            wIndex = textX - 1
                            if (wIndex < 1) then
                                wIndex = 1
                            end
                        end
                        if (self.parent ~= nil) then
                            self.parent:setCursor(true, anchx + textX - wIndex, anchy + textY - hIndex)
                        end
                    end
                end

                if (event == "mouse_scroll") then
                    hIndex = hIndex + button
                    if (hIndex > #lines - (self.height - 1)) then
                        hIndex = #lines - (self.height - 1)
                    end

                    if (hIndex < 1) then
                        hIndex = 1
                    end

                    if (self.parent ~= nil) then
                        if (obx + textX - wIndex >= obx and obx + textX - wIndex <= obx + self.width) and (oby + textY - hIndex >= oby and oby + textY - hIndex <= oby + self.height) then
                            self.parent:setCursor(true, anchx + textX - wIndex, anchy + textY - hIndex)
                        else
                            self.parent:setCursor(false)
                        end
                    end
                end
                self:setVisualChanged()
                return true
            end
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    self.parent:drawBackgroundBox(obx, oby, self.width, self.height, self.bgColor)
                    self.parent:drawForegroundBox(obx, oby, self.width, self.height, self.fgColor)
                    for n = 1, self.height do
                        local text = ""
                        if (lines[n + hIndex - 1] ~= nil) then
                            text = lines[n + hIndex - 1]
                        end
                        text = text:sub(wIndex, self.width + wIndex - 1)
                        local space = self.width - text:len()
                        if (space < 0) then
                            space = 0
                        end
                        text = text .. string.rep(" ", space)
                        self.parent:setText(obx, oby + n - 1, text)
                    end
                end
            end
        end;
    }

    return setmetatable(object, base)
end

local function List(name)
    local base = Object(name)
    local objectType = "List"
    base.width = 16
    base.height = 6
    base.bgColor = theme.listBG
    base.fgColor = theme.listFG
    base:setZIndex(5)

    local list = {}
    local itemSelectedBG = theme.selectionBG
    local itemSelectedFG = theme.selectionFG
    local selectionColorActive = true
    local align = "left"
    local yOffset = 0
    local scrollable = true

    local object = {
        getType = function(self)
            return objectType
        end;

        addItem = function(self, text, bgCol, fgCol, ...)
            table.insert(list, { text = text, bgCol = bgCol or self.bgColor, fgCol = fgCol or self.fgColor, args = { ... } })
            if (#list == 1) then
                self:setValue(list[1])
            end
            return self
        end;

        setIndexOffset = function(self, yOff)
            yOffset = yOff
            return self
        end;

        getIndexOffset = function(self)
            return yOffset
        end;

        removeItem = function(self, index)
            table.remove(list, index)
            return self
        end;

        getItem = function(self, index)
            return list[index]
        end;

        getItemIndex = function(self)
            local selected = self:getValue()
            for key, value in pairs(list) do
                if (value == selected) then
                    return key
                end
            end
        end;

        clear = function(self)
            list = {}
            self:setValue({})
            return self
        end;

        getItemCount = function(self)
            return #list
        end;

        editItem = function(self, index, text, bgCol, fgCol, ...)
            table.remove(list, index)
            table.insert(list, index, { text = text, bgCol = bgCol or self.bgColor, fgCol = fgCol or self.fgColor, args = { ... } })
            return self
        end;

        selectItem = function(self, index)
            self:setValue(list[index] or {})
            return self
        end;

        setSelectedItem = function(self, bgCol, fgCol, active)
            itemSelectedBG = bgCol or self.bgColor
            itemSelectedFG = fgCol or self.fgColor
            selectionColorActive = active
            return self
        end;

        setScrollable = function(self, scroll)
            scrollable = scroll
            return self
        end;

        mouseClickHandler = function(self, event, button, x, y)
            local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
            if (obx <= x) and (obx + self.width > x) and (oby <= y) and (oby + self.height > y) and (self:isVisible()) then
                if (event == "mouse_click") or (event == "mouse_drag") then
                    -- remove mouse_drag if i want to make objects moveable uwuwuwuw
                    if (button == 1) then
                        if (#list > 0) then
                            for n = 1, self.height do
                                if (list[n + yOffset] ~= nil) then
                                    if (obx <= x) and (obx + self.width > x) and (oby + n - 1 == y) then
                                        self:setValue(list[n + yOffset])
                                        self:getEventSystem():sendEvent("mouse_click", self, "mouse_click", 0, x, y, list[n + yOffset])
                                    end
                                end
                            end
                        end
                    end
                end

                if (event == "mouse_scroll") and (scrollable) then
                    yOffset = yOffset + button
                    if (yOffset < 0) then
                        yOffset = 0
                    end
                    if (button >= 1) then
                        if (#list > self.height) then
                            if (yOffset > #list - self.height) then
                                yOffset = #list - self.height
                            end
                            if (yOffset >= #list) then
                                yOffset = #list - 1
                            end
                        else
                            yOffset = yOffset - 1
                        end
                    end
                end
                self:setVisualChanged()
                return true
            end
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    self.parent:drawBackgroundBox(obx, oby, self.width, self.height, self.bgColor)
                    for n = 1, self.height do
                        if (list[n + yOffset] ~= nil) then
                            if (list[n + yOffset] == self:getValue()) then
                                if (selectionColorActive) then
                                    self.parent:writeText(obx, oby + n - 1, getTextHorizontalAlign(list[n + yOffset].text, self.width, align), itemSelectedBG, itemSelectedFG)
                                else
                                    self.parent:writeText(obx, oby + n - 1, getTextHorizontalAlign(list[n + yOffset].text, self.width, align), list[n + yOffset].bgCol, list[n + yOffset].fgCol)
                                end
                            else
                                self.parent:writeText(obx, oby + n - 1, getTextHorizontalAlign(list[n + yOffset].text, self.width, align), list[n + yOffset].bgCol, list[n + yOffset].fgCol)
                            end
                        end
                    end
                end
            end
        end;
    }

    return setmetatable(object, base)
end

local function Menubar(name)
    local base = Object(name)
    local objectType = "Menubar"
    local object = {}

    base.width = 30
    base.height = 1
    base.bgColor = colors.gray
    base.fgColor = colors.lightGray
    base:setZIndex(5)

    local list = {}
    local itemSelectedBG = theme.selectionBG
    local itemSelectedFG = theme.selectionFG
    local selectionColorActive = true
    local align = "left"
    local itemOffset = 0
    local space = 2
    local scrollable = false

    local function maxScroll()
        local mScroll = 0
        local xPos = 1
        for n = 1, #list do
            if (xPos + list[n].text:len() + space * 2 > object.w) then
                mScroll = mScroll + list[n].text:len() + space * 2
            end
            xPos = xPos + list[n].text:len() + space * 2

        end
        return mScroll
    end

    object = {
        getType = function(self)
            return objectType
        end;

        addItem = function(self, text, bgCol, fgCol, ...)
            table.insert(list, { text = text, bgCol = bgCol or self.bgColor, fgCol = fgCol or self.fgColor, args = { ... } })
            if (#list == 1) then
                self:setValue(list[1])
            end
            return self
        end;

        getItemIndex = function(self)
            local selected = self:getValue()
            for key, value in pairs(list) do
                if (value == selected) then
                    return key
                end
            end
        end;

        clear = function(self)
            list = {}
            self:setValue({})
            return self
        end;

        setSpace = function(self, _space)
            space = _space or space
            return self
        end;

        setButtonOffset = function(self, offset)
            itemOffset = offset or 0
            if (itemOffset < 0) then
                itemOffset = 0
            end

            local mScroll = maxScroll()
            if (itemOffset > mScroll) then
                itemOffset = mScroll
            end
            return self
        end;

        setScrollable = function(self, scroll)
            scrollable = scroll
            return self
        end;

        removeItem = function(self, index)
            table.remove(list, index)
            return self
        end;

        getItem = function(self, index)
            return list[index]
        end;

        getItemCount = function(self)
            return #list
        end;

        editItem = function(self, index, text, bgCol, fgCol, ...)
            table.remove(list, index)
            table.insert(list, index, { text = text, bgCol = bgCol or self.bgColor, fgCol = fgCol or self.fgColor, args = { ... } })
            return self
        end;

        selectItem = function(self, index)
            self:setValue(list[index] or {})
            return self
        end;

        setSelectedItem = function(self, bgCol, fgCol, active)
            itemSelectedBG = bgCol or self.bgColor
            itemSelectedFG = fgCol or self.fgColor
            selectionColorActive = active
            return self
        end;

        mouseClickHandler = function(self, event, button, x, y)
            local objX, objY = self:getAbsolutePosition(self:getAnchorPosition())
            if (objX <= x) and (objX + self.width > x) and (objY <= y) and (objY + self.height > y) and (self:isVisible()) then
                if (self.parent ~= nil) then
                    self.parent:setFocusedObject(self)
                end
                if (event == "mouse_click") then
                    local xPos = 1
                    for n = 1 + itemOffset, #list do
                        if (list[n] ~= nil) then
                            if (xPos + list[n].text:len() + space * 2 <= self.width) then
                                if (objX + (xPos - 1) <= x) and (objX + (xPos - 1) + list[n].text:len() + space * 2 > x) and (objY == y) then
                                    self:setValue(list[n])
                                    self:getEventSystem():sendEvent("mouse_click", self, "mouse_click", 0, x, y, list[n])
                                end
                                xPos = xPos + list[n].text:len() + space * 2
                            else
                                break
                            end
                        end
                    end

                end
                if (event == "mouse_scroll") and (scrollable) then
                    itemOffset = itemOffset + button
                    if (itemOffset < 0) then
                        itemOffset = 0
                    end

                    local mScroll = maxScroll()

                    if (itemOffset > mScroll) then
                        itemOffset = mScroll
                    end
                end
                return true
            end
            return false
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    self.parent:drawBackgroundBox(obx, oby, self.width, self.height, self.bgColor)
                    local xPos = 0
                    for _, value in pairs(list) do
                        if (xPos + value.text:len() + space * 2 <= self.width) then
                            if (value == self:getValue()) then
                                self.parent:writeText(obx + (xPos - 1) + (-itemOffset), oby, getTextHorizontalAlign((" "):rep(space) .. value.text .. (" "):rep(space), value.text:len() + space * 2, align), itemSelectedBG or value.bgCol, itemSelectedFG or value.fgCol)
                            else
                                self.parent:writeText(obx + (xPos - 1) + (-itemOffset), oby, getTextHorizontalAlign((" "):rep(space) .. value.text .. (" "):rep(space), value.text:len() + space * 2, align), value.bgCol, value.fgCol)
                            end
                            xPos = xPos + value.text:len() + space * 2
                        else
                            if (xPos < self.width + itemOffset) then
                                if (value == self:getValue()) then
                                    self.parent:writeText(obx + (xPos - 1) + (-itemOffset), oby, getTextHorizontalAlign((" "):rep(space) .. value.text .. (" "):rep(space), value.text:len() + space * 2, align):sub(1, self.width + itemOffset - xPos), itemSelectedBG or value.bgCol, itemSelectedFG or value.fgCol)
                                else
                                    self.parent:writeText(obx + (xPos - 1) + (-itemOffset), oby, getTextHorizontalAlign((" "):rep(space) .. value.text .. (" "):rep(space), value.text:len() + space * 2, align):sub(1, self.width + itemOffset - xPos), value.bgCol, value.fgCol)
                                end
                                xPos = xPos + value.text:len() + space * 2
                            end
                        end
                    end
                end
            end
        end;
    }

    return setmetatable(object, base)
end

local function Dropdown(name)
    local base = Object(name)
    local objectType = "Dropdown"
    base.width = 12
    base.height = 1
    base.bgColor = theme.dropdownBG
    base.fgColor = theme.dropdownFG
    base:setZIndex(6)

    local list = {}
    local itemSelectedBG = theme.selectionBG
    local itemSelectedFG = theme.selectionFG
    local selectionColorActive = true
    local align = "left"
    local yOffset = 0

    local dropdownW = 16
    local dropdownH = 6
    local closedSymbol = "\16"
    local openedSymbol = "\31"
    local state = 1

    local object = {
        getType = function(self)
            return objectType
        end;

        setIndexOffset = function(self, yOff)
            yOffset = yOff
            return self
        end;

        getIndexOffset = function(self)
            return yOffset
        end;

        addItem = function(self, text, bgCol, fgCol, ...)
            table.insert(list, { text = text, bgCol = bgCol or self.bgColor, fgCol = fgCol or self.fgColor, args = { ... } })
            return self
        end;

        removeItem = function(self, index)
            table.remove(list, index)
            return self
        end;

        getItem = function(self, index)
            return list[index]
        end;

        getItemIndex = function(self)
            local selected = self:getValue()
            for key, value in pairs(list) do
                if (value == selected) then
                    return key
                end
            end
        end;

        clear = function(self)
            list = {}
            self:setValue({})
            return self
        end;

        getItemCount = function(self)
            return #list
        end;

        editItem = function(self, index, text, bgCol, fgCol, ...)
            table.remove(list, index)
            table.insert(list, index, { text = text, bgCol = bgCol or self.bgColor, fgCol = fgCol or self.fgColor, args = { ... } })
            return self
        end;

        selectItem = function(self, index)
            self:setValue(list[index] or {})
            return self
        end;

        setSelectedItem = function(self, bgCol, fgCol, active)
            itemSelectedBG = bgCol or self.bgColor
            itemSelectedFG = fgCol or self.fgColor
            selectionColorActive = active
            return self
        end;

        setDropdownSize = function(self, width, height)
            dropdownW, dropdownH = width, height
            return self
        end;

        mouseClickHandler = function(self, event, button, x, y)
            if (state == 2) then
                local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
                if (event == "mouse_click") then
                    -- remove mouse_drag if i want to make objects moveable uwuwuwuw
                    if (button == 1) then
                        if (#list > 0) then
                            for n = 1, dropdownH do
                                if (list[n + yOffset] ~= nil) then
                                    if (obx <= x) and (obx + dropdownW > x) and (oby + n == y) then
                                        self:setValue(list[n + yOffset])
                                        return true
                                    end
                                end
                            end
                        end
                    end
                end

                if (event == "mouse_scroll") then
                    yOffset = yOffset + button
                    if (yOffset < 0) then
                        yOffset = 0
                    end
                    if (button == 1) then
                        if (#list > dropdownH) then
                            if (yOffset > #list - dropdownH) then
                                yOffset = #list - dropdownH
                            end
                        else
                            yOffset = list - 1
                        end
                    end
                    return true
                end
                self:setVisualChanged()
            end
            if (base.mouseClickHandler(self, event, button, x, y)) then
                state = 2
            else
                state = 1
            end
        end;

        draw = function(self)
            if (base.draw(self)) then
                local obx, oby = self:getAnchorPosition()
                if (self.parent ~= nil) then
                    self.parent:drawBackgroundBox(obx, oby, self.width, self.height, self.bgColor)
                    if (#list >= 1) then
                        if (self:getValue() ~= nil) then
                            if (self:getValue().text ~= nil) then
                                if (state == 1) then
                                    self.parent:writeText(obx, oby, getTextHorizontalAlign(self:getValue().text, self.width, align):sub(1, self.width - 1) .. closedSymbol, self.bgColor, self.fgColor)
                                else
                                    self.parent:writeText(obx, oby, getTextHorizontalAlign(self:getValue().text, self.width, align):sub(1, self.width - 1) .. openedSymbol, self.bgColor, self.fgColor)
                                end
                            end
                        end
                        if (state == 2) then
                            for n = 1, dropdownH do
                                if (list[n + yOffset] ~= nil) then
                                    if (list[n + yOffset] == self:getValue()) then
                                        if (selectionColorActive) then
                                            self.parent:writeText(obx, oby + n, getTextHorizontalAlign(list[n + yOffset].text, dropdownW, align), itemSelectedBG, itemSelectedFG)
                                        else
                                            self.parent:writeText(obx, oby + n, getTextHorizontalAlign(list[n + yOffset].text, dropdownW, align), list[n + yOffset].bgCol, list[n + yOffset].fgCol)
                                        end
                                    else
                                        self.parent:writeText(obx, oby + n, getTextHorizontalAlign(list[n + yOffset].text, dropdownW, align), list[n + yOffset].bgCol, list[n + yOffset].fgCol)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end;
    }

    return setmetatable(object, base)
end

local function Radio(name)
    local base = Object(name)
    local objectType = "Radio"
    base.width = 8
    base.bgColor = theme.listBG
    base.fgColor = theme.listFG
    base:setZIndex(5)

    local list = {}
    local itemSelectedBG = theme.selectionBG
    local itemSelectedFG = theme.selectionFG
    local boxSelectedBG = base.bgColor
    local boxSelectedFG = base.fgColor
    local selectionColorActive = true
    local symbol = "\7"
    local align = "left"

    local object = {
        getType = function(self)
            return objectType
        end;

        addItem = function(self, text, x, y, bgCol, fgCol, ...)
            table.insert(list, { x = x or 1, y = y or 1, text = text, bgCol = bgCol or self.bgColor, fgCol = fgCol or self.fgColor, args = { ... } })
            if (#list == 1) then
                self:setValue(list[1])
            end
            return self
        end;

        removeItem = function(self, index)
            table.remove(list, index)
            return self
        end;

        getItem = function(self, index)
            return list[index]
        end;

        getItemIndex = function(self)
            local selected = self:getValue()
            for key, value in pairs(list) do
                if (value == selected) then
                    return key
                end
            end
        end;

        clear = function(self)
            list = {}
            self:setValue({})
            return self
        end;

        getItemCount = function(self)
            return #list
        end;

        editItem = function(self, index, text, x, y, bgCol, fgCol, ...)
            table.remove(list, index)
            table.insert(list, index, { x = x or 1, y = y or 1, text = text, bgCol = bgCol or self.bgColor, fgCol = fgCol or self.fgColor, args = { ... } })
            return self
        end;

        selectItem = function(self, index)
            self:setValue(list[index] or {})
            return self
        end;

        setSelectedItem = function(self, bgCol, fgCol, boxBG, boxFG, active)
            itemSelectedBG = bgCol or itemSelectedBG
            itemSelectedFG = fgCol or itemSelectedFG
            boxSelectedBG = boxBG or boxSelectedBG
            boxSelectedFG = boxFG or boxSelectedFG
            selectionColorActive = active
            return self
        end;

        mouseClickHandler = function(self, event, button, x, y)
            local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
            if (event == "mouse_click") then
                -- remove mouse_drag if i want to make objects moveable uwuwuwuw
                if (button == 1) then
                    if (#list > 0) then
                        for _, value in pairs(list) do
                            if (obx + value.x - 1 <= x) and (obx + value.x - 1 + value.text:len() + 2 >= x) and (oby + value.y - 1 == y) then
                                self:setValue(value)
                                if (self.parent ~= nil) then
                                    self.parent:setFocusedObject(self)
                                end
                                --eventSystem:sendEvent(event, self, event, button, x, y)
                                self:setVisualChanged()
                                return true
                            end
                        end
                    end
                end
            end
            return false
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    for _, value in pairs(list) do
                        if (value == self:getValue()) then
                            if (align == "left") then
                                self.parent:writeText(value.x + obx - 1, value.y + oby - 1, symbol, boxSelectedBG, boxSelectedFG)
                                self.parent:writeText(value.x + 2 + obx - 1, value.y + oby - 1, value.text, itemSelectedBG, itemSelectedFG)
                            end
                        else
                            self.parent:drawBackgroundBox(value.x + obx - 1, value.y + oby - 1, 1, 1, self.bgColor)
                            self.parent:writeText(value.x + 2 + obx - 1, value.y + oby - 1, value.text, value.bgCol, value.fgCol)
                        end
                    end
                end
            end
        end;
    }

    return setmetatable(object, base)
end

local function Timer(name)
    local objectType = "Timer"

    local timer = 0
    local savedRepeats = 0
    local repeats = 0
    local timerObj
    local eventSystem = BasaltEvents()

    local object = {
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

        setTime = function(self, _timer, _repeats)
            timer = _timer or 0
            savedRepeats = _repeats or 1
            return self
        end;

        start = function(self)
            repeats = savedRepeats
            timerObj = os.startTimer(timer)
            return self
        end;

        cancel = function(self)
            if (timerObj ~= nil) then
                os.cancelTimer(timerObj)
            end
            return self
        end;

        onCall = function(self, func)
            eventSystem:registerEvent("timed_event", func)
            return self
        end;

        eventHandler = function(self, event, tObj)
            if (event == "timer") and (tObj == timerObj) then
                eventSystem:sendEvent("timed_event", self)
                if (repeats >= 1) then
                    repeats = repeats - 1
                    if (repeats >= 1) then
                        timerObj = os.startTimer(timer)
                    end
                elseif (repeats == -1) then
                    timerObj = os.startTimer(timer)
                end
            end
        end;
    }
    object.__index = object

    return object
end

local function Thread(name)
    local object
    local objectType = "Thread"

    local func
    local cRoutine
    local isActive = false

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

        start = function(self, f)
            if (f == nil) then
                error("function is nil")
            end
            func = f
            cRoutine = coroutine.create(func)
            isActive = true
            local ok, result = coroutine.resume(cRoutine)
            if not (ok) then
                if (result ~= "Terminated") then
                    error("Threaderror - " .. result)
                end
            end
            return self
        end;

        getStatus = function(self, f)
            if (cRoutine ~= nil) then
                return coroutine.status(cRoutine)
            end
            return nil
        end;

        stop = function(self, f)
            isActive = false
            return self
        end;

        eventHandler = function(self, event, p1, p2, p3)
            if (isActive) then
                if (coroutine.status(cRoutine) ~= "dead") then
                    local ok, result = coroutine.resume(cRoutine, event, p1, p2, p3)
                    if not (ok) then
                        if (result ~= "Terminated") then
                            error("Threaderror - " .. result)
                        end
                    end
                else
                    isActive = false
                end
            end
        end;

    }

    object.__index = object

    return object
end

local function Animation(name)
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

local function Slider(name)
    local base = Object(name)
    local objectType = "Slider"

    base.width = 8
    base.bgColor = colors.lightGray
    base.fgColor = colors.gray
    base:setValue(1)

    local barType = "horizontal"
    local symbol = " "
    local symbolColor = colors.black
    local bgSymbol = "\140"
    local maxValue = base.width
    local index = 1

    local object = {
        getType = function(self)
            return objectType
        end;

        setSymbol = function(self, _symbol)
            symbol = _symbol:sub(1, 1)
            self:setVisualChanged()
            return self
        end;

        setBackgroundSymbol = function(self, _bgSymbol)
            bgSymbol = string.sub(_bgSymbol, 1, 1)
            self:setVisualChanged()
            return self
        end;

        setSymbolColor = function(self, col)
            symbolColor = col
            self:setVisualChanged()
            return self
        end;

        setBarType = function(self, _typ)
            barType = _typ:lower()
            return self
        end;

        mouseClickHandler = function(self, event, button, x, y)
            if (base.mouseClickHandler(self, event, button, x, y)) then
                local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
                if (barType == "horizontal") then
                    for _index = 0, self.width - 1 do
                        if (obx + _index == x) and (oby <= y) and (oby + self.height > y) then
                            index = _index + 1
                            self:setValue(maxValue / self.width * (index))
                            self:setVisualChanged()
                        end
                    end
                end
                if (barType == "vertical") then
                    for _index = 0, self.height - 1 do
                        if (oby + _index == y) and (obx <= x) and (obx + self.width > x) then
                            index = _index + 1
                            self:setValue(maxValue / self.height * (index))
                            self:setVisualChanged()
                        end
                    end
                end
                --[[if(event=="mouse_scroll")then
                    self:setValue(self:getValue() + (maxValue/(barType=="vertical" and self.height or self.width))*typ)
                    self:setVisualChanged()
                end
                if(self:getValue()>maxValue)then self:setValue(maxValue) end
                if(self:getValue()<maxValue/(barType=="vertical" and self.height or self.width))then self:setValue(maxValue/(barType=="vertical" and self.height or self.width)) end
                ]]
            end
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    if (barType == "horizontal") then
                        self.parent:writeText(obx, oby, bgSymbol:rep(index - 1), self.bgColor, self.fgColor)
                        self.parent:writeText(obx + index - 1, oby, symbol, symbolColor, symbolColor)
                        self.parent:writeText(obx + index, oby, bgSymbol:rep(self.width - (index)), self.bgColor, self.fgColor)
                    end

                    if (barType == "vertical") then
                        for n = 0, self.height - 1 do
                            if (n + 1 == index) then
                                self.parent:writeText(obx, oby + n, symbol, symbolColor, symbolColor)
                            else
                                self.parent:writeText(obx, oby + n, bgSymbol, self.bgColor, self.fgColor)
                            end
                        end
                    end
                end
            end
        end;

    }

    return setmetatable(object, base)
end

local function Scrollbar(name)
    local base = Object(name)
    local objectType = "Scrollbar"

    base.width = 1
    base.height = 8
    base.bgColor = colors.lightGray
    base.fgColor = colors.gray
    base:setValue(1)
    base:setZIndex(2)

    local barType = "vertical"
    local symbol = " "
    local symbolColor = colors.black
    local bgSymbol = "\127"
    local maxValue = base.height
    local index = 1
    local symbolSize = 1

    local object = {
        getType = function(self)
            return objectType
        end;

        setSymbol = function(self, _symbol)
            symbol = _symbol:sub(1, 1)
            self:setVisualChanged()
            return self
        end;

        setSymbolSize = function(self, size)
            symbolSize = tonumber(size) or 1
            if (barType == "vertical") then
                self:setValue(index - 1 * (maxValue / (self.height - (symbolSize - 1))) - (maxValue / (self.height - (symbolSize - 1))))
            elseif (barType == "horizontal") then
                self:setValue(index - 1 * (maxValue / (self.width - (symbolSize - 1))) - (maxValue / (self.width - (symbolSize - 1))))
            end
            self:setVisualChanged()
            return self
        end;

        setMaxValue = function(self, val)
            maxValue = val
            return self
        end;

        setBackgroundSymbol = function(self, _bgSymbol)
            bgSymbol = string.sub(_bgSymbol, 1, 1)
            self:setVisualChanged()
            return self
        end;

        setSymbolColor = function(self, col)
            symbolColor = col
            self:setVisualChanged()
            return self
        end;

        setBarType = function(self, _typ)
            barType = _typ:lower()
            return self
        end;

        mouseClickHandler = function(self, event, button, x, y)
            if (base.mouseClickHandler(self, event, button, x, y)) then
                local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
                if ((event == "mouse_click") or (event == "mouse_drag")) and (button == 1) then
                    if (barType == "horizontal") then
                        for _index = 0, self.width do
                            if (obx + _index == x) and (oby <= y) and (oby + self.height > y) then
                                index = math.min(_index + 1, self.width - (symbolSize - 1))
                                self:setValue(maxValue / self.width * (index))
                                self:setVisualChanged()
                            end
                        end
                    end
                    if (barType == "vertical") then
                        for _index = 0, self.height do
                            if (oby + _index == y) and (obx <= x) and (obx + self.width > x) then
                                index = math.min(_index + 1, self.height - (symbolSize - 1))
                                self:setValue(maxValue / self.height * (index))
                                self:setVisualChanged()
                            end
                        end
                    end
                end
                if (event == "mouse_scroll") then
                    index = index + button
                    if (index < 1) then
                        index = 1
                    end
                    index = math.min(index, (barType == "vertical" and self.height or self.width) - (symbolSize - 1))
                    self:setValue(maxValue / (barType == "vertical" and self.height or self.width) * index)
                end
                return true
            end
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    if (barType == "horizontal") then
                        self.parent:writeText(obx, oby, bgSymbol:rep(index - 1), self.bgColor, self.fgColor)
                        self.parent:writeText(obx + index - 1, oby, symbol:rep(symbolSize), symbolColor, symbolColor)
                        self.parent:writeText(obx + index + symbolSize - 1, oby, bgSymbol:rep(self.width - (index + symbolSize - 1)), self.bgColor, self.fgColor)
                    end

                    if (barType == "vertical") then
                        for n = 0, self.height - 1 do

                            if (index == n + 1) then
                                for curIndexOffset = 0, math.min(symbolSize - 1, self.height) do
                                    self.parent:writeText(obx, oby + n + curIndexOffset, symbol, symbolColor, symbolColor)
                                end
                            else
                                if (n + 1 < index) or (n + 1 > index - 1 + symbolSize) then
                                    self.parent:writeText(obx, oby + n, bgSymbol, self.bgColor, self.fgColor)
                                end
                            end
                        end
                    end
                end
            end
        end;
    }

    return setmetatable(object, base)
end

local function Switch(name)
    local base = Object(name)
    local objectType = "Switch"

    base.width = 3
    base.height = 1
    base.bgColor = colors.lightGray
    base.fgColor = colors.gray
    base:setValue(false)
    base:setZIndex(5)

    local object = {
        getType = function(self)
            return objectType
        end;


        mouseClickHandler = function(self, event, button, x, y)
            if (base.mouseClickHandler(self, event, button, x, y)) then
                local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
                if ((event == "mouse_click") or (event == "mouse_drag")) and (button == 1) then


                end
                return true
            end
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()

                end
            end
        end;
    }

    return setmetatable(object, base)
end

local function Frame(name, parent)
    -- Frame
    local base = Object(name)
    local objectType = "Frame"
    local objects = {}
    local objZIndex = {}
    local object = {}
    local focusedObject
    base:setZIndex(10)

    local cursorBlink = false
    local xCursor = 1
    local yCursor = 1
    local cursorColor = colors.white

    local xOffset, yOffset = 0, 0

    if (parent ~= nil) then
        base.parent = parent
        base.width, base.height = parent.w, parent.h
        base.bgColor = theme.FrameBG
        base.fgColor = theme.FrameFG
    else
        local termW, termH = parentTerminal.getSize()
        base.width, base.height = termW, termH
        base.bgColor = theme.basaltBG
        base.fgColor = theme.basaltFG
    end

    local function getObject(name)
        for _, value in pairs(objects) do
            for _, b in pairs(value) do
                if (b.name == name) then
                    return value
                end
            end
        end
    end

    local function addObject(obj)
        local zIndex = obj:getZIndex()
        if (getObject(obj.name) ~= nil) then
            return nil
        end
        if (objects[zIndex] == nil) then
            for x = 1, #objZIndex + 1 do
                if (objZIndex[x] ~= nil) then
                    if (zIndex == objZIndex[x]) then
                        break
                    end
                    if (zIndex > objZIndex[x]) then
                        table.insert(objZIndex, x, zIndex)
                        break
                    end
                else
                    table.insert(objZIndex, zIndex)
                end
            end
            if (#objZIndex <= 0) then
                table.insert(objZIndex, zIndex)
            end
            objects[zIndex] = {}
        end
        obj.parent = object
        table.insert(objects[zIndex], obj)
        return obj
    end

    local function removeObject(obj)
        for a, b in pairs(objects) do
            for key, value in pairs(b) do
                if (value == obj) then
                    table.remove(objects[a], key)
                    return true;
                end
            end
        end
        return false
    end

    ---@class Frame
    object = {
        barActive = false,
        barBackground = colors.gray,
        barTextcolor = colors.black,
        barText = "New Frame",
        barTextAlign = "left",
        isMovable = false,
        ---@deprecated spelled incorrectly, will be replaced in favor of @see Frame#isMovable
        isMoveable = false,

        getType = function(self)
            return objectType
        end;

        setFocusedObject = function(self, obj)
            for _, index in pairs(objZIndex) do
                for _, value in pairs(objects[index]) do
                    if (value == obj) then
                        if (focusedObject ~= nil) then
                            focusedObject:loseFocusHandler()
                        end
                        focusedObject = obj
                        focusedObject:getFocusHandler()
                    end
                end
            end
            return self
        end;

        setOffset = function(self, xO, yO)
            xOffset = xO ~= nil and math.floor(xO < 0 and math.abs(xO) or -xO) or xOffset
            yOffset = yO ~= nil and math.floor(yO < 0 and math.abs(yO) or -yO) or yOffset
            return self
        end;

        getFrameOffset = function(self)
            return xOffset, yOffset
        end;

        removeFocusedObject = function(self)
            if (focusedObject ~= nil) then
                focusedObject:loseFocusHandler()
            end
            focusedObject = nil
            return self
        end;

        getFocusedObject = function(self)
            return focusedObject
        end;

        show = function(self)
            base:show()
            if (self.parent == nil) then
                activeFrame = self
            end
            return self
        end;

        setCursor = function(self, _blink, _xCursor, _yCursor, color)
            local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
            cursorBlink = _blink or false
            if (_xCursor ~= nil) then
                xCursor = obx + _xCursor - 1
            end
            if (_yCursor ~= nil) then
                yCursor = oby + _yCursor - 1
            end
            cursorColor = color or cursorColor
            self:setVisualChanged()
            return self
        end;

        setMovable = function(self, movable)
            self.isMovable = movable or not self.isMovable
            self:setVisualChanged()
            return self;
        end;

        ---@deprecated spelled incorrectly, will be replaced in favor of @see Frame#setMovable
        setMoveable = function(self, moveable)
            self.isMoveable = moveable or not self.isMoveable
            self:setVisualChanged()
            return self;
        end;


        showBar = function(self, showIt)
            self.barActive = showIt or not self.barActive
            self:setVisualChanged()
            return self
        end;

        setBar = function(self, text, bgCol, fgCol)
            self.barText = text or ""
            self.barBackground = bgCol or self.barBackground
            self.barTextcolor = fgCol or self.barTextcolor
            self:setVisualChanged()
            return self
        end;

        setBarTextAlign = function(self, align)
            self.barTextAlign = align or "left"
            self:setVisualChanged()
            return self
        end;

        getVisualChanged = function(self)
            local changed = base.getVisualChanged(self)
            for _, index in pairs(objZIndex) do
                if (objects[index] ~= nil) then
                    for _, value in pairs(objects[index]) do
                        if (value.getVisualChanged ~= nil and value:getVisualChanged()) then
                            changed = true
                        end
                    end
                end
            end
            return changed
        end;

        loseFocusHandler = function(self)
            base.loseFocusHandler(self)
        end;

        getFocusHandler = function(self)
            base.getFocusHandler(self)
            if (self.parent ~= nil) then
                self.parent:removeObject(self)
                self.parent:addObject(self)
            end
        end;

        keyHandler = function(self, event, key)
            if (focusedObject ~= nil) then
                if (focusedObject.keyHandler ~= nil) then
                    if (focusedObject:keyHandler(event, key)) then
                        return true
                    end
                end
            end
            return false
        end;

        backgroundKeyHandler = function(self, event, key)
            base.backgroundKeyHandler(self, event, key)
            for _, index in pairs(objZIndex) do
                if (objects[index] ~= nil) then
                    for _, value in pairs(objects[index]) do
                        if (value.backgroundKeyHandler ~= nil) then
                            value:backgroundKeyHandler(event, key)
                        end
                    end
                end
            end
        end;

        eventHandler = function(self, event, p1, p2, p3, p4)
            base.eventHandler(self, event, p1, p2, p3, p4)
            for _, index in pairs(objZIndex) do
                if (objects[index] ~= nil) then
                    for _, value in pairs(objects[index]) do
                        if (value.eventHandler ~= nil) then
                            value:eventHandler(event, p1, p2, p3, p4)
                        end
                    end
                end
            end
            if (event == "terminate") then
                parentTerminal.clear()
                parentTerminal.setCursorPos(1, 1)
                basalt.stop()
            end
        end;

        mouseClickHandler = function(self, event, button, x, y)
            local xO, yO = self:getOffset()
            xO = xO < 0 and math.abs(xO) or -xO
            yO = yO < 0 and math.abs(yO) or -yO
            if (self.drag) then
                if (event == "mouse_drag") then
                    local parentX = 1;
                    local parentY = 1
                    if (self.parent ~= nil) then
                        parentX, parentY = self.parent:getAbsolutePosition(self.parent:getAnchorPosition())
                    end
                    self:setPosition(x + self.xToRem - (parentX - 1) + xO, y - (parentY - 1) + yO)
                end
                if (event == "mouse_up") then
                    self.drag = false
                end
                return true
            end

            if (base.mouseClickHandler(self, event, button, x, y)) then
                local fx, fy = self:getAbsolutePosition(self:getAnchorPosition())
                for _, index in pairs(objZIndex) do
                    if (objects[index] ~= nil) then
                        for _, value in rpairs(objects[index]) do
                            if (value.mouseClickHandler ~= nil) then
                                if (value:mouseClickHandler(event, button, x + xO, y + yO)) then
                                    return true
                                end
                            end
                        end
                    end
                end

                if (self.isMoveable) then
                    if (x >= fx) and (x <= fx + self.width - 1) and (y == fy) and (event == "mouse_click") then
                        self.drag = true
                        self.xToRem = fx - x
                    end
                end
                if (focusedObject ~= nil) then
                    focusedObject:loseFocusHandler()
                    focusedObject = nil
                end
                return true
            end
            return false
        end;

        setText = function(self, x, y, text)
            local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
            if (y >= 1) and (y <= self.height) then
                if (self.parent ~= nil) then
                    self.parent:setText(math.max(x + (obx - 1), obx) - (self.parent.x - 1), oby + y - 1 - (self.parent.y - 1), sub(text, math.max(1 - x + 1, 1), self.width - x + 1))
                else
                    drawHelper.setText(math.max(x + (obx - 1), obx), oby + y - 1, sub(text, math.max(1 - x + 1, 1), self.width - x + 1))
                end
            end
        end;

        setBG = function(self, x, y, bgCol)
            local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
            if (y >= 1) and (y <= self.height) then
                if (self.parent ~= nil) then
                    self.parent:setBG(math.max(x + (obx - 1), obx) - (self.parent.x - 1), oby + y - 1 - (self.parent.y - 1), sub(bgCol, math.max(1 - x + 1, 1), self.width - x + 1))
                else
                    drawHelper.setBG(math.max(x + (obx - 1), obx), oby + y - 1, sub(bgCol, math.max(1 - x + 1, 1), self.width - x + 1))
                end
            end
        end;

        setFG = function(self, x, y, fgCol)
            local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
            if (y >= 1) and (y <= self.height) then
                if (self.parent ~= nil) then
                    self.parent:setFG(math.max(x + (obx - 1), obx) - (self.parent.x - 1), oby + y - 1 - (self.parent.y - 1), sub(fgCol, math.max(1 - x + 1, 1), self.width - x + 1))
                else
                    drawHelper.setFG(math.max(x + (obx - 1), obx), oby + y - 1, sub(fgCol, math.max(1 - x + 1, 1), self.width - x + 1))
                end
            end
        end;

        writeText = function(self, x, y, text, bgCol, fgCol)
            local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
            if (y >= 1) and (y <= self.height) then
                if (self.parent ~= nil) then
                    self.parent:writeText(math.max(x + (obx - 1), obx) - (self.parent.x - 1), oby + y - 1 - (self.parent.y - 1), sub(text, math.max(1 - x + 1, 1), self.width - x + 1), bgCol, fgCol)
                else
                    drawHelper.writeText(math.max(x + (obx - 1), obx), oby + y - 1, sub(text, math.max(1 - x + 1, 1), self.width - x + 1), bgCol, fgCol)
                end
            end
        end;

        drawBackgroundBox = function(self, x, y, width, height, bgCol)
            local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
            height = (y < 1 and (height + y > self.height and self.height or height + y - 1) or (height + y > self.height and self.height - y + 1 or height))
            width = (x < 1 and (width + x > self.width and self.width or width + x - 1) or (width + x > self.width and self.width - x + 1 or width))
            if (self.parent ~= nil) then
                self.parent:drawBackgroundBox(math.max(x + (obx - 1), obx) - (self.parent.x - 1), math.max(y + (oby - 1), oby) - (self.parent.y - 1), width, height, bgCol)
            else
                drawHelper.drawBackgroundBox(math.max(x + (obx - 1), obx), math.max(y + (oby - 1), oby), width, height, bgCol)
            end
        end;

        drawTextBox = function(self, x, y, width, height, symbol)
            local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
            height = (y < 1 and (height + y > self.height and self.height or height + y - 1) or (height + y > self.height and self.height - y + 1 or height))
            width = (x < 1 and (width + x > self.width and self.width or width + x - 1) or (width + x > self.width and self.width - x + 1 or width))
            if (self.parent ~= nil) then
                self.parent:drawTextBox(math.max(x + (obx - 1), obx) - (self.parent.x - 1), math.max(y + (oby - 1), oby) - (self.parent.y - 1), width, height, symbol:sub(1, 1))
            else
                drawHelper.drawTextBox(math.max(x + (obx - 1), obx), math.max(y + (oby - 1), oby), width, height, symbol:sub(1, 1))
            end
        end;

        drawForegroundBox = function(self, x, y, width, height, fgCol)
            local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
            height = (y < 1 and (height + y > self.height and self.height or height + y - 1) or (height + y > self.height and self.height - y + 1 or height))
            width = (x < 1 and (width + x > self.width and self.width or width + x - 1) or (width + x > self.width and self.width - x + 1 or width))
            if (self.parent ~= nil) then
                self.parent:drawForegroundBox(math.max(x + (obx - 1), obx) - (self.parent.x - 1), math.max(y + (oby - 1), oby) - (self.parent.y - 1), width, height, fgCol)
            else
                drawHelper.drawForegroundBox(math.max(x + (obx - 1), obx), math.max(y + (oby - 1), oby), width, height, fgCol)
            end
        end;

        draw = function(self)
            if (self:getVisualChanged()) then
                if (base.draw(self)) then
                    local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
                    local anchx, anchy = self:getAnchorPosition()
                    if (self.parent ~= nil) then
                        self.parent:drawBackgroundBox(anchx, anchy, self.width, self.height, self.bgColor)
                        self.parent:drawForegroundBox(anchx, anchy, self.width, self.height, self.fgColor)
                        self.parent:drawTextBox(anchx, anchy, self.width, self.height, " ")
                    else
                        drawHelper.drawBackgroundBox(obx, oby, self.width, self.height, self.bgColor)
                        drawHelper.drawForegroundBox(obx, oby, self.width, self.height, self.fgColor)
                        drawHelper.drawTextBox(obx, oby, self.width, self.height, " ")
                    end
                    parentTerminal.setCursorBlink(false)
                    if (self.barActive) then
                        if (self.parent ~= nil) then
                            self.parent:writeText(anchx, anchy, getTextHorizontalAlign(self.barText, self.width, self.barTextAlign), self.barBackground, self.barTextcolor)
                        else
                            drawHelper.writeText(obx, oby, getTextHorizontalAlign(self.barText, self.width, self.barTextAlign), self.barBackground, self.barTextcolor)
                        end
                    end

                    for _, index in rpairs(objZIndex) do
                        if (objects[index] ~= nil) then
                            for _, value in pairs(objects[index]) do
                                if (value.draw ~= nil) then
                                    value:draw()
                                end
                            end
                        end
                    end

                    if (cursorBlink) then
                        parentTerminal.setTextColor(cursorColor)
                        parentTerminal.setCursorPos(xCursor, yCursor)
                        if (self.parent ~= nil) then
                            parentTerminal.setCursorBlink(self:isFocused())
                        else
                            parentTerminal.setCursorBlink(cursorBlink)
                        end
                    end
                    self:setVisualChanged(false)
                end
            end
        end;

        addObject = function(self, obj)
            return addObject(obj)
        end;

        removeObject = function(self, obj)
            return removeObject(obj)
        end;

        getObject = function(self, obj)
            return getObject(obj)
        end;

        addButton = function(self, name)
            local obj = Button(name)
            obj.name = name
            return addObject(obj)
        end;

        addLabel = function(self, name)
            local obj = Label(name)
            obj.name = name
            obj.bgColor = self.bgColor
            obj.fgColor = self.fgColor
            return addObject(obj)
        end;

        addCheckbox = function(self, name)
            local obj = Checkbox(name)
            obj.name = name
            return addObject(obj)
        end;

        addInput = function(self, name)
            local obj = Input(name)
            obj.name = name
            return addObject(obj)
        end;

        addProgram = function(self, name)
            local obj = Program(name)
            obj.name = name
            return addObject(obj)
        end;

        addTextfield = function(self, name)
            local obj = Textfield(name)
            obj.name = name
            return addObject(obj)
        end;

        addList = function(self, name)
            local obj = List(name)
            obj.name = name
            return addObject(obj)
        end;

        addDropdown = function(self, name)
            local obj = Dropdown(name)
            obj.name = name
            return addObject(obj)
        end;

        addRadio = function(self, name)
            local obj = Radio(name)
            obj.name = name
            return addObject(obj)
        end;

        addTimer = function(self, name)
            local obj = Timer(name)
            obj.name = name
            return addObject(obj)
        end;

        addAnimation = function(self, name)
            local obj = Animation(name)
            obj.name = name
            return addObject(obj)
        end;

        addSlider = function(self, name)
            local obj = Slider(name)
            obj.name = name
            return addObject(obj)
        end;

        addScrollbar = function(self, name)
            local obj = Scrollbar(name)
            obj.name = name
            return addObject(obj)
        end;

        addMenubar = function(self, name)
            local obj = Menubar(name)
            obj.name = name
            return addObject(obj)
        end;

        addThread = function(self, name)
            local obj = Thread(name)
            obj.name = name
            return addObject(obj)
        end;

        addPane = function(self, name)
            local obj = Pane(name)
            obj.name = name
            return addObject(obj)
        end;

        addImage = function(self, name)
            local obj = Image(name)
            obj.name = name
            return addObject(obj)
        end;

        addProgressbar = function(self, name)
            local obj = Progressbar(name)
            obj.name = name
            return addObject(obj)
        end;

        addFrame = function(self, name)
            local obj = Frame(name, self)
            obj.name = name
            return addObject(obj)
        end;
    }
    setmetatable(object, base)
    if (parent == nil) then
        table.insert(frames, object)
    end
    return object
end

local updaterActive = false
local function basaltUpdateEvent(event, p1, p2, p3, p4)
    if (event == "mouse_click") then
        activeFrame:mouseClickHandler(event, p1, p2, p3, p4)
    end
    if (event == "mouse_drag") then
        activeFrame:mouseClickHandler(event, p1, p2, p3, p4)
    end
    if (event == "mouse_up") then
        activeFrame:mouseClickHandler(event, p1, p2, p3, p4)
    end
    if (event == "mouse_scroll") then
        activeFrame:mouseClickHandler(event, p1, p2, p3, p4)
    end
    if (event == "key") or (event == "char") then
        activeFrame:keyHandler(event, p1)
        activeFrame:backgroundKeyHandler(event, p1)
    end
    for _, value in pairs(frames) do
        value:eventHandler(event, p1, p2, p3, p4)
    end
    if (updaterActive) then
        activeFrame:draw()
        drawHelper.update()
    end
end

function basalt.autoUpdate(isActive)
    parentTerminal.clear()
    updaterActive = isActive or true
    activeFrame:draw()
    drawHelper.update()
    while updaterActive do
        local event, p1, p2, p3, p4 = os.pullEventRaw() -- change to raw later
        basaltUpdateEvent(event, p1, p2, p3, p4)
    end
end

function basalt.update(event, p1, p2, p3, p4)
    if (event ~= "nil") then
        basaltUpdateEvent(event, p1, p2, p3, p4)
    else
        activeFrame:draw()
        drawHelper.update()
    end
end

function basalt.stop()
    updaterActive = false
end

function basalt.getFrame(name)
    for _, value in pairs(frames) do
        if (value.name == name) then
            return value
        end
    end
end

function basalt.getActiveFrame()
    return activeFrame
end

function basalt.setActiveFrame(frame)
    if (frame:getType() == "Frame") then
        activeFrame = frame
        return true
    end
    return false
end

function basalt.createFrame(name)
    local frame = Frame(name)
    return frame
end

function basalt.removeFrame(name)
    for key, value in pairs(frames) do
        if (value.name == name) then
            frames[key] = nil
            return true
        end
    end
    return false
end

if (basalt.debugger) then
    basalt.debugFrame = basalt.createFrame("basaltDebuggingFrame"):showBar():setBackground(colors.lightGray):setBar("Debug", colors.black, colors.gray)
    basalt.debugList = basalt.debugFrame:addList("debugList"):setSize(basalt.debugFrame.width - 2, basalt.debugFrame.height - 3):setPosition(2, 3):setScrollable(true):show()
    basalt.debugFrame:addButton("back"):setAnchor("right"):setSize(1, 1):setText("\22"):onClick(function()
        basalt.oldFrame:show()
    end)  :setBackground(colors.red):show()
    basalt.debugLabel = basalt.debugFrame:addLabel("debugLabel"):onClick(function()
        basalt.oldFrame = activeFrame
        basalt.debugFrame:show()
    end)                      :setBackground(colors.black):setForeground(colors.white):setAnchor("bottom"):setZIndex(20):show()
end

if (basalt.debugger) then
    function basalt.debug(...)
        local args = { ... }
        if (activeFrame.name ~= "basaltDebuggingFrame") then
            if (activeFrame ~= basalt.debugLabel.frame) then
                basalt.debugLabel:setParent(activeFrame)
            end
        end
        local str = ""
        for key, value in pairs(args) do
            str = str .. tostring(value) .. (#args ~= key and ", " or "")
        end
        basalt.debugLabel:setText("[Debug] " .. str)
        basalt.debugList:addItem(str)
        if (basalt.debugList:getItemCount() > 50) then
            basalt.debugList:removeItem(1)
        end
        basalt.debugList:setValue(basalt.debugList:getItem(basalt.debugList:getItemCount()))
        basalt.debugLabel:show()
    end
end

return basalt