local Object = require("Object")
local utils = require("utils")
local xmlValue = utils.getValueFromXML

return function(name)
    -- Button
    local base = Object(name)
    local objectType = "Button"
    local textHorizontalAlign = "center"
    local textVerticalAlign = "center"

    base:setZIndex(5)
    base:setValue("Button")
    base.width = 12
    base.height = 3

    local object = {
        init = function(self)
            self.bgColor = self.parent:getTheme("ButtonBG")
            self.fgColor = self.parent:getTheme("ButtonText")        
        end,
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

        setValuesByXMLData = function(self, data)
            base.setValuesByXMLData(self, data)
            if(xmlValue("text", data)~=nil)then self:setText(xmlValue("text", data)) end
            if(xmlValue("horizontalAlign", data)~=nil)then textHorizontalAlign = xmlValue("horizontalAlign", data) end
            if(xmlValue("verticalAlign", data)~=nil)then textVerticalAlign = xmlValue("verticalAlign", data) end
            return self
        end,

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    local w,h = self:getSize()
                    local verticalAlign = utils.getTextVerticalAlign(h, textVerticalAlign)

                    if(self.bgColor~=false)then
                        self.parent:drawBackgroundBox(obx, oby, w, h, self.bgColor)
                        self.parent:drawTextBox(obx, oby, w, h, " ")
                    end
                    if(self.fgColor~=false)then self.parent:drawForegroundBox(obx, oby, w, h, self.fgColor) end
                    for n = 1, h do
                        if (n == verticalAlign) then
                            self.parent:setText(obx, oby + (n - 1), utils.getTextHorizontalAlign(self:getValue(), w, textHorizontalAlign))
                        end
                    end
                end
                self:setVisualChanged(false)
            end
        end;

    }
    return setmetatable(object, base)
end