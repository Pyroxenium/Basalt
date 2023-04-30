local utils = require("utils")
local tHex = require("tHex")

return function(name, basalt)
    -- Input
    local base = basalt.getObject("ChangeableObject")(name, basalt)
    local objectType = "Input"

    local inputType = "text"
    local inputLimit = 0
    base:setZIndex(5)
    base:setValue("")
    base:setSize(12, 1)

    local textX = 1
    local wIndex = 1

    local defaultText = ""
    local defaultBGCol = colors.black
    local defaultFGCol = colors.white
    local showingText = defaultText
    local internalValueChange = false

    local object = {
        load = function(self)
            self:listenEvent("mouse_click")
            self:listenEvent("key")
            self:listenEvent("char")
            self:listenEvent("other_event")
            self:listenEvent("mouse_drag")
        end,

        getType = function(self)
            return objectType
        end,
        isType = function(self, t)
            return objectType==t or base.isType~=nil and base.isType(t) or false
        end,

        setDefaultText = function(self, text, fCol, bCol)
            defaultText = text
            defaultFGCol = fCol or defaultFGCol
            defaultBGCol = bCol or defaultBGCol
            if (self:isFocused()) then
                showingText = ""
            else
                showingText = defaultText
            end
            self:updateDraw()
            return self
        end,

        getDefaultText = function(self)
            return defaultText, defaultFGCol, defaultBGCol
        end,

        setOffset = function(self, x)
            wIndex = x
            self:updateDraw()
            return self
        end,

        getOffset = function(self)
            return wIndex
        end,

        setTextOffset = function(self, x)
            textX = x
            self:updateDraw()
            return self
        end,

        getTextOffset = function(self)
            return textX
        end,

        setInputType = function(self, t)
            inputType = t
            self:updateDraw()
            return self
        end,

        getInputType = function(self)
            return inputType
        end,

        setValue = function(self, val)
            base.setValue(self, tostring(val))
            if not (internalValueChange) then
                textX = tostring(val):len() + 1
                wIndex = math.max(1, textX-self:getWidth()+1)
                if(self:isFocused())then
                    local parent = self:getParent()
                    local obx, oby = self:getPosition()
                    parent:setCursor(true, obx + textX - wIndex, oby+math.floor(self:getHeight()/2), self:getForeground())
                end
            end
            self:updateDraw()
            return self
        end,

        getValue = function(self)
            local val = base.getValue(self)
            return inputType == "number" and tonumber(val) or val
        end,

        setInputLimit = function(self, limit)
            inputLimit = tonumber(limit) or inputLimit
            self:updateDraw()
            return self
        end,

        getInputLimit = function(self)
            return inputLimit
        end,

        getFocusHandler = function(self)
            base.getFocusHandler(self)
            local parent = self:getParent()
            if (parent ~= nil) then
                local obx, oby = self:getPosition()
                showingText = ""
                if(defaultText~="")then
                    self:updateDraw()
                end
                parent:setCursor(true, obx + textX - wIndex, oby+math.max(math.ceil(self:getHeight()/2-1, 1)), self:getForeground())
            end
        end,

        loseFocusHandler = function(self)
            base.loseFocusHandler(self)
            local parent = self:getParent()
            showingText = defaultText
            if(defaultText~="")then
                self:updateDraw()
            end
            parent:setCursor(false)
        end,

        keyHandler = function(self, key)
            if (base.keyHandler(self, key)) then
                local w,h = self:getSize()
                local parent = self:getParent()
                internalValueChange = true
                    if (key == keys.backspace) then
                        -- on backspace
                        local text = tostring(base.getValue())
                        if (textX > 1) then
                            self:setValue(text:sub(1, textX - 2) .. text:sub(textX, text:len()))
                            textX = math.max(textX - 1, 1)
                            if (textX < wIndex) then
                                wIndex = math.max(wIndex - 1, 1)
                            end
                        end
                    end
                    if (key == keys.enter) then
                        parent:removeFocusedObject(self)
                    end
                    if (key == keys.right) then
                        local tLength = tostring(base.getValue()):len()
                        textX = textX + 1

                        if (textX > tLength) then
                            textX = tLength + 1
                        end
                        textX = math.max(textX, 1)
                        if (textX < wIndex) or (textX >= w + wIndex) then
                            wIndex = textX - w + 1
                        end
                        wIndex = math.max(wIndex, 1)
                    end

                    if (key == keys.left) then
                        -- left arrow
                        textX = textX - 1
                        if (textX >= 1) then
                            if (textX < wIndex) or (textX >= w + wIndex) then
                                wIndex = textX
                            end
                        end
                        textX = math.max(textX, 1)
                        wIndex = math.max(wIndex, 1)
                    end
                local obx, oby = self:getPosition()
                local val = tostring(base.getValue())

                self:updateDraw()
                internalValueChange = false
                return true
            end
        end,

        charHandler = function(self, char)
            if (base.charHandler(self, char)) then
                internalValueChange = true
                local w,h = self:getSize()
                local text = base.getValue()
                if (text:len() < inputLimit or inputLimit <= 0) then
                    if (inputType == "number") then
                        local cache = text
                        if (textX==1 and char == "-") or (char == ".") or (tonumber(char) ~= nil) then
                            self:setValue(text:sub(1, textX - 1) .. char .. text:sub(textX, text:len()))
                            textX = textX + 1
                            if(char==".")or(char=="-")and(#text>0)then
                                if (tonumber(base.getValue()) == nil) then
                                    self:setValue(cache)
                                    textX = textX - 1
                                end
                            end
                        end
                    else
                        self:setValue(text:sub(1, textX - 1) .. char .. text:sub(textX, text:len()))
                        textX = textX + 1
                    end
                    if (textX >= w + wIndex) then
                        wIndex = wIndex + 1
                    end
                end
                local obx, oby = self:getPosition()
                local val = tostring(base.getValue())

                internalValueChange = false
                self:updateDraw()
                return true
            end
        end,

        mouseHandler = function(self, button, x, y)
            if(base.mouseHandler(self, button, x, y))then
                local parent = self:getParent()
                local ax, ay = self:getPosition()
                local obx, oby = self:getAbsolutePosition(ax, ay)
                local w, h = self:getSize()
                textX = x - obx + wIndex
                local text = base.getValue()
                if (textX > text:len()) then
                    textX = text:len() + 1
                end
                if (textX < wIndex) then
                    wIndex = textX - 1
                    if (wIndex < 1) then
                        wIndex = 1
                    end
                end
                parent:setCursor(true, ax + textX - wIndex, ay+math.max(math.ceil(h/2-1, 1)), self:getForeground())
                return true
            end
        end,

        dragHandler = function(self, btn, x, y, xOffset, yOffset)
            if(self:isFocused())then
                if(self:isCoordsInObject(x, y))then
                    if(base.dragHandler(self, btn, x, y, xOffset, yOffset))then
                        return true
                    end
                end
                local parent = self:getParent()
                parent:removeFocusedObject()
            end
        end,

        draw = function(self)
            base.draw(self)
            self:addDraw("input", function()
                local parent = self:getParent()
                local obx, oby = self:getPosition()
                local w,h = self:getSize()
                local verticalAlign = utils.getTextVerticalAlign(h, textVerticalAlign)
     
                local val = tostring(base.getValue())
                local bCol = self:getBackground()
                local fCol = self:getForeground()
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
                text = text:sub(wIndex, w + wIndex - 1)
                local space = w - text:len()
                if (space < 0) then
                    space = 0
                end
                if (inputType == "password") and (val ~= "") then
                    text = string.rep("*", text:len())
                end
                text = text .. string.rep(" ", space)
                self:addBlit(1, verticalAlign, text, tHex[fCol]:rep(text:len()), tHex[bCol]:rep(text:len()))

                if(self:isFocused())then
                    parent:setCursor(true, obx + textX - wIndex, oby+math.floor(self:getHeight()/2), self:getForeground())
                end
            end)
        end,
    }

    object.__index = object
    return setmetatable(object, base)
end