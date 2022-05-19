local function Label(name)
    -- Label
    local base = Object(name)
    local objectType = "Label"

    base:setZIndex(3)

    local autoWidth = true
    base:setValue("")

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

        setSize = function(self, width, h)
            self.width, self.height = width, h
            autoWidth = false
            return self
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    self.parent:writeText(obx, oby, self:getValue(), self.bgColor, self.fgColor)
                end
            end
        end;

    }

    return setmetatable(object, base)
end