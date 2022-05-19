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