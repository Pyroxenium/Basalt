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

    local object = {
        symbol = "\42",

        init = function(self)
            self.bgColor = self.parent:getTheme("CheckboxBG")
            self.fgColor = self.parent:getTheme("CheckboxText")        
        end,

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
                                self.parent:writeText(obx, oby + (n - 1), utils.getTextHorizontalAlign(self.symbol, w, "center"), self.bgColor, self.fgColor)
                            else
                                self.parent:writeText(obx, oby + (n - 1), utils.getTextHorizontalAlign(" ", w, "center"), self.bgColor, self.fgColor)
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