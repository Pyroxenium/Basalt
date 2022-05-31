local function Label(name)
    -- Label
    local base = Object(name)
    local objectType = "Label"

    base:setZIndex(3)
    base.fgColor = colors.white
    base.bgcolor = colors.black

    local autoSize = true
    base:setValue("")

    local textHorizontalAlign = "left"
    local textVerticalAlign = "top"
    local fontsize = 0

    local object = {
        getType = function(self)
            return objectType
        end;
        setText = function(self, text)
            text = tostring(text)
            base:setValue(text)
            if (autoSize) then
                self.width = text:len()
            end
            return self
        end;

        setTextAlign = function(self, hor, vert)
            textHorizontalAlign = hor or textHorizontalAlign
            textVerticalAlign = vert or textVerticalAlign
            self:setVisualChanged()
            return self
        end;

        setFontSize = function(self, size)
            if(size>0)and(size<=4)then
                fontsize = size-1 or 0
            end
            return self
        end;

        getFontSize = function(self)
            return fontsize+1
        end;

        setSize = function(self, width, height)
            base.setSize(self, width, height)
            autoSize = false
            self:setVisualChanged()
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
                    if(fontsize==0)then
                        for n = 1, self.height do
                            if (n == verticalAlign) then
                                self.parent:writeText(obx, oby + (n - 1), getTextHorizontalAlign(self:getValue(), self.width, textHorizontalAlign), self.bgColor, self.fgColor)
                            end
                        end
                    else
                        local tData = makeText(fontsize, self:getValue(), self.fgColor, self.bgColor)
                        if(autoSize)then
                            self.height = #tData[1]-1
                            self.width = #tData[1][1]
                        end
                        for n = 1, self.height do
                            if (n == verticalAlign) then
                                local oX, oY = self.parent:getSize()
                                local cX, cY = #tData[1][1], #tData[1]
                                obx = obx or math.floor((oX - cX) / 2) + 1
                                oby = oby or math.floor((oY - cY) / 2) + 1
                            
                                for i = 1, cY do
                                    self.parent:setFG(obx, oby + i + n - 2, getTextHorizontalAlign(tData[2][i], self.width, textHorizontalAlign))
                                    self.parent:setBG(obx, oby + i + n - 2, getTextHorizontalAlign(tData[3][i], self.width, textHorizontalAlign, tHex[self.bgColor]))
                                    self.parent:setText(obx, oby + i + n - 2, getTextHorizontalAlign(tData[1][i], self.width, textHorizontalAlign))
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