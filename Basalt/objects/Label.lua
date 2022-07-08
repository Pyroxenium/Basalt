local Object = require("Object")
local theme = require("theme")
local utils = require("utils")
local tHex = require("tHex")
local bigFont = require("bigfont")

return function(name)
    -- Label
    local base = Object(name)
    local objectType = "Label"

    base:setZIndex(3)

    local autoSize = true
    base:setValue("")

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
            if not(fgColChanged)then self.fgColor = self.parent:getForeground() or colors.white end
            if not(bgColChanged)then self.bgColor = self.parent:getBackground() or colors.black end
            return self
        end;

        setBackground = function(self, col)
            base.setBackground(self, col)
            bgColChanged = true
            return self
        end,

        setForeground = function(self, col)
            base.setForeground(self, col)
            fgColChanged = true
            return self
        end,

        setTextAlign = function(self, hor, vert)
            textHorizontalAlign = hor or textHorizontalAlign
            textVerticalAlign = vert or textVerticalAlign
            self:setVisualChanged()
            return self
        end;

        setFontSize = function(self, size)
            if(size>0)and(size<=4)then
                fontsize = size-1 or 0
            end
            return self
        end;

        getFontSize = function(self)
            return fontsize+1
        end;

        setSize = function(self, width, height)
            base.setSize(self, width, height)
            autoSize = false
            self:setVisualChanged()
            return self
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    local verticalAlign = utils.getTextVerticalAlign(self.height, textVerticalAlign)
                    if(self.bgColor~=false)then 
                        self.parent:drawBackgroundBox(obx, oby, self.width, self.height, self.bgColor)
                        self.parent:drawTextBox(obx, oby, self.width, self.height, " ") end
                    if(self.fgColor~=false)then self.parent:drawForegroundBox(obx, oby, self.width, self.height, self.fgColor) end
                    if(fontsize==0)then
                        if not(autoSize)then
                            local splittedText = utils.splitString(self:getValue(), " ")
                            local text = {}
                            local line = ""
                            for _,v in pairs(splittedText)do
                                if(line:len()+v:len()<=self.width)then
                                    line = line=="" and v or line.." "..v
                                else
                                    table.insert(text, line)
                                    line = v:sub(1,self.width)
                                end
                            end
                            for k,v in pairs(text)do
                                self.parent:setText(obx, oby+k-1, v)
                            end
                        else
                            for n = 1, self.height do
                                if (n == verticalAlign) then
                                    self.parent:setText(obx, oby + (n - 1), utils.getTextHorizontalAlign(self:getValue(), self.width, textHorizontalAlign))
                                end
                            end
                        end
                    else
                        local tData = bigFont(fontsize, self:getValue(), self.fgColor, self.bgColor or colors.black)
                        if(autoSize)then
                            self.height = #tData[1]-1
                            self.width = #tData[1][1]
                        end
                        for n = 1, self.height do
                            if (n == verticalAlign) then
                                local oX, oY = self.parent:getSize()
                                local cX, cY = #tData[1][1], #tData[1]
                                obx = obx or math.floor((oX - cX) / 2) + 1
                                oby = oby or math.floor((oY - cY) / 2) + 1
                            
                                for i = 1, cY do
                                    self.parent:setFG(obx, oby + i + n - 2, utils.getTextHorizontalAlign(tData[2][i], self.width, textHorizontalAlign))
                                    self.parent:setBG(obx, oby + i + n - 2, utils.getTextHorizontalAlign(tData[3][i], self.width, textHorizontalAlign, tHex[self.bgColor or colors.black]))
                                    self.parent:setText(obx, oby + i + n - 2, utils.getTextHorizontalAlign(tData[1][i], self.width, textHorizontalAlign))
                                end
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