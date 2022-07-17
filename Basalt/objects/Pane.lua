local Object = require("Object")

return function(name)
    -- Pane
    local base = Object(name)
    local objectType = "Pane"

    local object = {
        init = function(self)
            self.bgColor = self.parent:getTheme("PaneBG")
            self.fgColor = self.parent:getTheme("PaneBG")
        end,
        getType = function(self)
            return objectType
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    local w,h = self:getSize()
                    self.parent:drawBackgroundBox(obx, oby, w, h, self.bgColor)
                    self.parent:drawForegroundBox(obx, oby, w, h, self.fgColor)
                end
                self:setVisualChanged(false)
            end
        end;

    }

    return setmetatable(object, base)
end