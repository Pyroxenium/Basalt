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