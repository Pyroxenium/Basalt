local Object = require("Object")
local theme = require("theme")

return function(name)
    local base = Object(name)
    local objectType = "Switch"

    base.width = 2
    base.height = 1
    base.bgColor = colors.lightGray
    base.fgColor = colors.gray
    base:setValue(false)
    base:setZIndex(5)

    local bgSymbol = colors.black
    local inactiveBG = colors.red
    local activeBG = colors.green

    local object = {
        getType = function(self)
            return objectType
        end;

        setSymbolColor = function(self, symbolColor)
            bgSymbol = symbolColor
            self:setVisualChanged()
            return self
        end;

        setActiveBackground = function(self, bgcol)
            activeBG = bgcol
            self:setVisualChanged()
            return self
        end;

        setInactiveBackground = function(self, bgcol)
            inactiveBG = bgcol
            self:setVisualChanged()
            return self
        end;

        mouseHandler = function(self, event, button, x, y)
            if (base.mouseHandler(self, event, button, x, y)) then
                local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
                if ((event == "mouse_click") and (button == 1))or(event=="monitor_touch") then
                    self:setValue(not self:getValue())
                end
                return true
            end
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    self.parent:drawBackgroundBox(obx, oby, self.width, self.height, self.bgColor)
                    if(self:getValue())then
                        self.parent:drawBackgroundBox(obx, oby, 1, self.height, activeBG)
                        self.parent:drawBackgroundBox(obx+1, oby, 1, self.height, bgSymbol)
                    else
                        self.parent:drawBackgroundBox(obx, oby, 1, self.height, bgSymbol)
                        self.parent:drawBackgroundBox(obx+1, oby, 1, self.height, inactiveBG)
                    end
                end
                self:setVisualChanged(false)
            end
        end;
    }

    return setmetatable(object, base)
end