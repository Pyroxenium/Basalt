local Object = require("Object")
local utils = require("utils")
local xmlValue = utils.getValueFromXML
local tHex = require("tHex")

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
            self:updateDraw()
            return self
        end;

        setVerticalAlign = function(self, pos)
            textVerticalAlign = pos
            self:updateDraw()
            return self
        end;

        setText = function(self, text)
            base:setValue(text)
            self:updateDraw()
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

                    for n = 1, h do
                        if (n == verticalAlign) then
                            self.parent:setText(obx, oby + (n - 1), utils.getTextHorizontalAlign(self:getValue(), w, textHorizontalAlign))
                            self.parent:setFG(obx, oby + (n - 1), utils.getTextHorizontalAlign(tHex[self.fgColor]:rep(self:getValue():len()), w, textHorizontalAlign))
                        end
                    end
                end
            end
        end,

    }
    return setmetatable(object, base)
end