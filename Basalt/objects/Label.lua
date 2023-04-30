local utils = require("utils")
local wrapText = utils.wrapText
local tHex = require("tHex")

return function(name, basalt)
    -- Label
    local base = basalt.getObject("VisualObject")(name, basalt)
    local objectType = "Label"

    base:setZIndex(3)

    local autoSize = true
    local fgColChanged,bgColChanged = false,false
    local text, textAlign = "Label", "left"

    local object = {
        getType = function(self)
            return objectType
        end,

        getBase = function(self)
            return base
        end,    
        
        setText = function(self, newText)
            text = tostring(newText)
            if(autoSize)then
                self:setSize(#text, 1)
                autoSize = true
            end
            self:updateDraw()
            return self
        end,

        getText = function(self)
            return text
        end,

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

        setSize = function(self, ...)
            base.setSize(self, ...)
            autoSize = false
            return self
        end,

        setTextAlign = function(self, align)
            textAlign = align or textAlign
            return self;
        end,

        draw = function(self)
            base.draw(self)
            self:addDraw("label", function()
                local parent = self:getParent()
                local obx, oby = self:getPosition()
                local w,h = self:getSize()
                local bgCol,fgCol = self:getBackground(), self:getForeground()
                if not(autoSize)then
                    local text = wrapText(text, w)
                    for k,v in pairs(text)do
                        if(k<=h)then
                            local align = textAlign=="center" and math.floor(w/2-v:len()/2+0.5) or textAlign=="right" and w-(v:len()-1) or 1
                            self:addText(align, k, v)
                        end
                    end
                else
                    self:addText(1, 1, text:sub(1,w))
                end
            end)
        end,
        
        init = function(self)
            base.init(self)
            local parent = self:getParent()
            self:setForeground(parent:getForeground())
            self:setBackground(parent:getBackground())
        end

    }

    object.__index = object
    return setmetatable(object, base)
end