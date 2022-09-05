local Object = require("Object")
local utils = require("utils")
local log = require("basaltLogs")
local xmlValue = utils.getValueFromXML

return function(name)
    -- Input
    local base = Object(name)
    local objectType = "Input"

    local inputType = "text"
    local inputLimit = 0
    base:setZIndex(5)
    base:setValue("")
    base.width = 10
    base.height = 1

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
            self:updateDraw()
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
            self:updateDraw()
            return self
        end;

        getInputType = function(self)
            return inputType
        end;

        setValue = function(self, val)
            base.setValue(self, tostring(val))
            if not (internalValueChange) then
                if(self:isFocused())then
                    textX = tostring(val):len() + 1
                    wIndex = math.max(1, textX-self:getWidth()+1)
                    local obx, oby = self:getAnchorPosition()
                    self.parent:setCursor(true, obx + textX - wIndex, oby+math.floor(self:getHeight()/2), self.fgColor)
                end
            end
            self:updateDraw()
            return self
        end;

        getValue = function(self)
            local val = base.getValue(self)
            return inputType == "number" and tonumber(val) or val
        end;

        setInputLimit = function(self, limit)
            inputLimit = tonumber(limit) or inputLimit
            self:updateDraw()
            return self
        end;

        getInputLimit = function(self)
            return inputLimit
        end;

        setValuesByXMLData = function(self, data)
            base.setValuesByXMLData(self, data)
            local dBG,dFG
            if(xmlValue("defaultBG", data)~=nil)then dBG = xmlValue("defaultBG", data) end
            if(xmlValue("defaultFG", data)~=nil)then dFG = xmlValue("defaultFG", data) end
            if(xmlValue("default", data)~=nil)then self:setDefaultText(xmlValue("default", data), dFG~=nil and colors[dFG], dBG~=nil and colors[dBG]) end
            if(xmlValue("limit", data)~=nil)then self:setInputLimit(xmlValue("limit", data)) end
            if(xmlValue("type", data)~=nil)then self:setInputType(xmlValue("type", data)) end
            return self
        end,

        getFocusHandler = function(self)
            base.getFocusHandler(self)
            if (self.parent ~= nil) then
                local obx, oby = self:getAnchorPosition()
                showingText = ""
                if(defaultText~="")then
                    self:updateDraw()
                end
                self.parent:setCursor(true, obx + textX - wIndex, oby+math.max(math.ceil(self:getHeight()/2-1, 1)), self.fgColor)
            end
        end;

        loseFocusHandler = function(self)
            base.loseFocusHandler(self)
            if (self.parent ~= nil) then
                showingText = defaultText
                if(defaultText~="")then
                    self:updateDraw()
                end
                self.parent:setCursor(false)
            end
        end;

        keyHandler = function(self, key)
            if (base.keyHandler(self, key)) then
                local w,h = self:getSize()
                internalValueChange = true
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
                        if (textX < wIndex) or (textX >= w + wIndex) then
                            wIndex = textX - w + 1
                        end
                        if (wIndex < 1) then
                            wIndex = 1
                        end
                    end

                    if (key == keys.left) then
                        -- left arrow
                        textX = textX - 1
                        if (textX >= 1) then
                            if (textX < wIndex) or (textX >= w + wIndex) then
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
                local obx, oby = self:getAnchorPosition()
                local val = tostring(base.getValue())
                local cursorX = (textX <= val:len() and textX - 1 or val:len()) - (wIndex - 1)
                
                local inpX = self:getX()
                if (cursorX > inpX + w - 1) then
                    cursorX = inpX + w - 1
                end
                if (self.parent ~= nil) then
                    self.parent:setCursor(true, obx + cursorX, oby+math.max(math.ceil(h/2-1, 1)), self.fgColor)
                end
                self:updateDraw()
                internalValueChange = false
                return true
            end
            return false
        end,

        charHandler = function(self, char)
            if (base.charHandler(self, char)) then
                internalValueChange = true
                local w,h = self:getSize()
                local text = base.getValue()
                if (text:len() < inputLimit or inputLimit <= 0) then
                    if (inputType == "number") then
                        local cache = text
                        if (char == ".") or (tonumber(char) ~= nil) then
                            self:setValue(text:sub(1, textX - 1) .. char .. text:sub(textX, text:len()))
                            textX = textX + 1
                        end
                        if (tonumber(base.getValue()) == nil) then
                            self:setValue(cache)
                        end
                    else
                        self:setValue(text:sub(1, textX - 1) .. char .. text:sub(textX, text:len()))
                        textX = textX + 1
                    end
                    if (textX >= w + wIndex) then
                        wIndex = wIndex + 1
                    end
                end
                local obx, oby = self:getAnchorPosition()
                local val = tostring(base.getValue())
                local cursorX = (textX <= val:len() and textX - 1 or val:len()) - (wIndex - 1)

                local x = self:getX()
                if (cursorX > x + w - 1) then
                    cursorX = x + w - 1
                end
                if (self.parent ~= nil) then
                    self.parent:setCursor(true, obx + cursorX, oby+math.max(math.ceil(h/2-1, 1)), self.fgColor)
                end
                internalValueChange = false
                self:updateDraw()
                return true
            end
            return false
        end,

        mouseHandler = function(self, button, x, y)
            if(base.mouseHandler(self, button, x, y))then
                local ax, ay = self:getAnchorPosition()
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
                self.parent:setCursor(true, ax + textX - wIndex, ay+math.max(math.ceil(h/2-1, 1)), self.fgColor)
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
                self.parent:removeFocusedObject()
            end
        end,

        eventHandler = function(self, event, paste, p2, p3, p4)
            if(base.eventHandler(self, event, paste, p2, p3, p4))then
                if(event=="paste")then
                    if(self:isFocused())then
                        local text = base.getValue()
                        local w, h = self:getSize()
                        internalValueChange = true
                        if (inputType == "number") then
                            local cache = text
                            if (paste == ".") or (tonumber(paste) ~= nil) then
                                self:setValue(text:sub(1, textX - 1) .. paste .. text:sub(textX, text:len()))
                                textX = textX + paste:len()
                            end
                            if (tonumber(base.getValue()) == nil) then
                                self:setValue(cache)
                            end
                        else
                            self:setValue(text:sub(1, textX - 1) .. paste .. text:sub(textX, text:len()))
                            textX = textX + paste:len()
                        end
                        if (textX >= w + wIndex) then
                            wIndex = (textX+1)-w
                        end

                        local obx, oby = self:getAnchorPosition()
                        local val = tostring(base.getValue())
                        local cursorX = (textX <= val:len() and textX - 1 or val:len()) - (wIndex - 1)

                        local x = self:getX()
                        if (cursorX > x + w - 1) then
                            cursorX = x + w - 1
                        end
                        if (self.parent ~= nil) then
                            self.parent:setCursor(true, obx + cursorX, oby+math.max(math.ceil(h/2-1, 1)), self.fgColor)
                        end
                        self:updateDraw()
                        internalValueChange = false
                    end
                end
            end
        end,

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    local w,h = self:getSize()
                    local verticalAlign = utils.getTextVerticalAlign(h, "center")

                    if(self.bgColor~=false)then self.parent:drawBackgroundBox(obx, oby, w, h, self.bgColor) end
                    for n = 1, h do
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
                            text = text:sub(wIndex, w + wIndex - 1)
                            local space = w - text:len()
                            if (space < 0) then
                                space = 0
                            end
                            if (inputType == "password") and (val ~= "") then
                                text = string.rep("*", text:len())
                            end
                            text = text .. string.rep(self.bgSymbol, space)
                            self.parent:writeText(obx, oby + (n - 1), text, bCol, fCol)
                        end
                    end
                    if(self:isFocused())then
                        self.parent:setCursor(true, obx + textX - wIndex, oby+math.floor(self:getHeight()/2), self.fgColor)
                    end
                end
            end
        end,

        init = function(self)
            self.bgColor = self.parent:getTheme("InputBG")
            self.fgColor = self.parent:getTheme("InputText")
            if(self.parent~=nil)then
                self.parent:addEvent("mouse_click", self)
                self.parent:addEvent("key", self)
                self.parent:addEvent("char", self)
                self.parent:addEvent("other_event", self)
                self.parent:addEvent("mouse_drag", self)
            end
        end,
    }

    return setmetatable(object, base)
end