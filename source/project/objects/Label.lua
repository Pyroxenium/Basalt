local function Label(name)
    -- Label
    local base = Object(name)
    local objectType = "Label"

    base:setZIndex(3)

    local autoWidth = true
    base:setValue("")

    local textHorizontalAlign = "left"
    local textVerticalAlign = "top"

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

        setTextAlign = function(self, hor, vert)
            textHorizontalAlign = hor or textHorizontalAlign
            textVerticalAlign = vert or textVerticalAlign
            self:setVisualChanged()
            return self
        end;

        setSize = function(self, width, height)
            base.setSize(self, width, height)
            autoWidth = false
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
                    for n = 1, self.height do
                        if (n == verticalAlign) then
                            self.parent:writeText(obx, oby + (n - 1), getTextHorizontalAlign(self:getValue(), self.width, textHorizontalAlign), self.bgColor, self.fgColor)
                        end
                    end
                end
            end
        end;

    }

    return setmetatable(object, base)
end