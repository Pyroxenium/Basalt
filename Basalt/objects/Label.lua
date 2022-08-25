local Object = require("Object")
local utils = require("utils")
local xmlValue = utils.getValueFromXML
local createText = utils.createText
local tHex = require("tHex")
local bigFont = require("bigfont")

return function(name)
    -- Label
    local base = Object(name)
    local objectType = "Label"

    base:setZIndex(3)

    local autoSize = true
    base:setValue("Label")
    base.width = 5

    local textHorizontalAlign = "left"
    local textVerticalAlign = "top"
    local fontsize = 0

    local fgColChanged,bgColChanged = false,false

    local object = {
        getType = function(self)
            return objectType
        end;
        
        setText = function(self, text)
            text = tostring(text)
            base:setValue(text)
            if (autoSize) then
                self.width = text:len()
            end
            self:updateDraw()
            return self
        end;

        setBackground = function(self, col)
            base.setBackground(self, col)
            bgColChanged = true
            self:updateDraw()
            return self
        end,

        setForeground = function(self, col)
            base.setForeground(self, col)
            fgColChanged = true
            self:updateDraw()
            return self
        end,

        setTextAlign = function(self, hor, vert)
            textHorizontalAlign = hor or textHorizontalAlign
            textVerticalAlign = vert or textVerticalAlign
            self:updateDraw()
            return self
        end;

        setFontSize = function(self, size)
            if(size>0)and(size<=4)then
                fontsize = size-1 or 0
            end
            self:updateDraw()
            return self
        end;

        getFontSize = function(self)
            return fontsize+1
        end;

        setValuesByXMLData = function(self, data)
            base.setValuesByXMLData(self, data)
            if(xmlValue("text", data)~=nil)then self:setText(xmlValue("text", data)) end
            if(xmlValue("verticalAlign", data)~=nil)then textVerticalAlign = xmlValue("verticalAlign", data) end
            if(xmlValue("horizontalAlign", data)~=nil)then textHorizontalAlign = xmlValue("horizontalAlign", data) end
            if(xmlValue("font", data)~=nil)then self:setFontSize(xmlValue("font", data)) end
            return self
        end,

        setSize = function(self, width, height, rel)
            base.setSize(self, width, height, rel)
            autoSize = false
            self:updateDraw()
            return self
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    local w,h = self:getSize()
                    local verticalAlign = utils.getTextVerticalAlign(h, textVerticalAlign)
                    if(fontsize==0)then
                        if not(autoSize)then
                            local text = createText(self:getValue(), self:getWidth())
                            for k,v in pairs(text)do
                                self.parent:writeText(obx, oby+k-1, v, self.bgColor, self.fgColor)
                            end
                        else
                            self.parent:writeText(obx, oby, self:getValue(), self.bgColor, self.fgColor)
                        end
                    else
                        local tData = bigFont(fontsize, self:getValue(), self.fgColor, self.bgColor or colors.lightGray)
                        if(autoSize)then
                            self:setSize(#tData[1][1], #tData[1]-1)
                        end
                            local oX, oY = self.parent:getSize()
                            local cX, cY = #tData[1][1], #tData[1]
                            obx = obx or math.floor((oX - cX) / 2) + 1
                            oby = oby or math.floor((oY - cY) / 2) + 1
                        
                            for i = 1, cY do
                                self.parent:setFG(obx, oby + i - 2, tData[2][i])
                                self.parent:setBG(obx, oby + i - 2, tData[3][i])
                                self.parent:setText(obx, oby + i - 2, tData[1][i])
                            end
                    end
                end
            end
        end,
        init = function(self)
            if(base.init(self))then
                self.bgColor = self.parent:getTheme("LabelBG")
                self.fgColor = self.parent:getTheme("LabelText")
                if(self.parent.bgColor==colors.black)and(self.fgColor==colors.black)then
                    self.fgColor = colors.lightGray
                end
            end
        end

    }

    return setmetatable(object, base)
end