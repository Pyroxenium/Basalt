local utils = require("utils")
local wrapText = utils.wrapText
local writeWrappedText = utils.writeWrappedText
local tHex = require("tHex")

return function(name, basalt)
    -- Label
    local base = basalt.getObject("VisualObject")(name, basalt)
    local objectType = "Label"

    base:setZIndex(3)
    base:setSize(5, 1)
    base:setBackground(false)

    local autoSize = true
    local text, textAlign = "Label", "left"

    local object = {
        --- Returns the object type.
        --- @return string
        getType = function(self)
            return objectType
        end,

        --- Returns the label's base object.
        --- @return object
        getBase = function(self)
            return base
        end,
        
        --- Changes the label's text.
        --- @param newText string  The new text of the label.
        --- @return object
        setText = function(self, newText)
            text = tostring(newText)
            if(autoSize)then
                local t = wrapText(text, #text)
                local newW, newH = 1,1
                for k,v in pairs(t)do
                    newH = newH+1
                    newW = math.max(newW, v:len())
                end
                self:setSize(newW, newH)
                autoSize = true
            end
            self:updateDraw()
            return self
        end,

        --- Returns the label's autoSize property.
        --- @return boolean
        getAutoSize = function(self)
            return autoSize
        end,

        --- Sets the label's autoSize property.
        --- @param bool boolean  The new value of the autoSize property.
        --- @return object
        setAutoSize = function(self, bool)
            autoSize = bool
            return self
        end,

        --- Returns the label's text.
        --- @return string
        getText = function(self)
            return text
        end,

        --- Sets the size of the label.
        --- @param width number  The width of the label.
        --- @param height number  The height of the label.
        --- @return object
        setSize = function(self, width, height)
            base.setSize(self, width, height)
            autoSize = false
            return self
        end,

        --- Gets the text alignment of the label.
        --- @return string
        getTextAlign = function(self)
            return textAlign
        end,

        --- Sets the text alignment of the label.
        --- @param align string  The alignment of the text. Can be "left", "center", or "right".
        --- @return object
        setTextAlign = function(self, align)
            textAlign = align or textAlign
            return self;
        end,

        --- Queues a new draw function to be called when the object is drawn.
        draw = function(self)
            base.draw(self)
            self:addDraw("label", function()
                local w, h = self:getSize()
                local align = textAlign=="center" and math.floor(w/2-text:len()/2+0.5) or textAlign=="right" and w-(text:len()-1) or 1
                writeWrappedText(self, align, 1, text, w+1, h)
            end)
        end,
        
        --- Initializes the label.
        init = function(self)
            base.init(self)
            local parent = self:getParent()
            self:setForeground(parent:getForeground())
        end

    }

    object.__index = object
    return setmetatable(object, base)
end