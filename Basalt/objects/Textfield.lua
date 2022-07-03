local Object = require("Object")
local theme = require("theme")

return function(name)
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

        mouseHandler = function(self, event, button, x, y)
            if (base.mouseHandler(self, event, button, x, y)) then
                local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
                local anchx, anchy = self:getAnchorPosition()
                if (event == "mouse_click")or(event=="monitor_touch") then
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
                            self.parent:setCursor(true, anchx + textX - wIndex, anchy + textY - hIndex, self.fgColor)
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
                            self.parent:setCursor(true, anchx + textX - wIndex, anchy + textY - hIndex, self.fgColor)
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
                            self.parent:setCursor(true, anchx + textX - wIndex, anchy + textY - hIndex, self.fgColor)
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
                    if(self.bgColor~=false)then
                        self.parent:drawBackgroundBox(obx, oby, self.width, self.height, self.bgColor)
                    end
                    if(self.fgColor~=false)then
                        self.parent:drawForegroundBox(obx, oby, self.width, self.height, self.fgColor)
                    end
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
                self:setVisualChanged(false)
            end
        end;
    }

    return setmetatable(object, base)
end