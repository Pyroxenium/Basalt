local Object = require("Object")
local utils = require("utils")
local xmlValue = utils.getValueFromXML

return function(name)
    -- Checkbox
    local base = Object(name)
    local objectType = "Checkbox"

    base:setZIndex(5)
    base:setValue(false)
    base.width = 1
    base.height = 1

    local symbol = "\42"

    local object = {

        getType = function(self)
            return objectType
        end;

        setSymbol = function(self, sym)
            symbol = sym
            self:updateDraw()
            return self
        end,

        mouseHandler = function(self, button, x, y)
            if (base.mouseHandler(self, button, x, y)) then
                if(button == 1)then
                    if (self:getValue() ~= true) and (self:getValue() ~= false) then
                        self:setValue(false)
                    else
                        self:setValue(not self:getValue())
                    end
                self:updateDraw()
                return true
                end
            end
            return false
        end,

        touchHandler = function(self, x, y)
            return self:mouseHandler(1, x, y)
        end,

        setValuesByXMLData = function(self, data)
            base.setValuesByXMLData(self, data)
            if(xmlValue("checked", data)~=nil)then if(xmlValue("checked", data))then self:setValue(true) else self:setValue(false) end end
            return self
        end,

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    local w,h = self:getSize()
                    local verticalAlign = utils.getTextVerticalAlign(h, "center")
                    if(self.bgColor~=false)then self.parent:drawBackgroundBox(obx, oby, w, h, self.bgColor) end
                    for n = 1, h do
                        if (n == verticalAlign) then
                            if (self:getValue() == true) then
                                self.parent:writeText(obx, oby + (n - 1), utils.getTextHorizontalAlign(symbol, w, "center"), self.bgColor, self.fgColor)
                            else
                                self.parent:writeText(obx, oby + (n - 1), utils.getTextHorizontalAlign(" ", w, "center"), self.bgColor, self.fgColor)
                            end
                        end
                    end
                end
            end
        end,
        
        init = function(self)
            base.init(self)
            self.bgColor = self.parent:getTheme("CheckboxBG")
            self.fgColor = self.parent:getTheme("CheckboxText")       
            self.parent:addEvent("mouse_click", self)
        end,
    }

    return setmetatable(object, base)
end