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

        mouseHandler = function(self, event, button, x, y)
            if (base.mouseHandler(self, event, button, x, y)) then
                if ((event == "mouse_click") and (button == 1)) or (event == "monitor_touch") then
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

                    if(self.bgColor~=false)then self.parent:drawBackgroundBox(obx, oby, self.width, self.height, self.bgColor) end
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
                self:setVisualChanged(false)
            end
        end;

    }

    return setmetatable(object, base)
end