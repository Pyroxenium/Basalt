local function Switch(name)
    local base = Object(name)
    local objectType = "Switch"

    base.width = 3
    base.height = 1
    base.bgColor = colors.lightGray
    base.fgColor = colors.gray
    base:setValue(false)
    base:setZIndex(5)

    local object = {
        getType = function(self)
            return objectType
        end;


        mouseClickHandler = function(self, event, button, x, y)
            if (base.mouseClickHandler(self, event, button, x, y)) then
                local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
                if ((event == "mouse_click") or (event == "mouse_drag")) and (button == 1) then


                end
                return true
            end
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()

                end
            end
        end;
    }

    return setmetatable(object, base)
end