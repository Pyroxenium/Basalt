local utils = require("utils")
local wrapText = utils.wrapText
local writeWrappedText = utils.writeWrappedText

return function(name, basalt)
    -- Label
    local base = basalt.getObject("VisualObject")(name, basalt)
    base:setType("Label")

    base:setZ(3)
    base:setSize(5, 1)

    base:addProperty("text", "string", "Label", nil, function(self, value)
        local autoSize = self:getAutoSize()
        value = tostring(value)
        if(autoSize)then
            local t = wrapText(value, #value)
            local newW, newH = 1,0
            for _,v in pairs(t)do
                newH = newH + 1
                newW = math.max(newW, v:len())
            end
            if(newH==0)then newH = 1 end
            self:setSize(newW, newH)
            self:setAutoSize(true)
        end
    end)
    base:addProperty("autoSize", "boolean", true)
    base:addProperty("textAlign", {"left", "center", "right"}, "left")

    local object = {
        init = function(self)
            base.init(self)
            local parent = self:getParent()
            self:setBackground(nil)
            self:setForeground(parent:getForeground())
        end,
        --- Returns the label's base object.
        --- @return object
        getBase = function(self)
            return base
        end,
        
        --- Sets the size of the label.
        --- @param width number  The width of the label.
        --- @param height number  The height of the label.
        --- @return object
        setSize = function(self, width, height)
            base.setSize(self, width, height)
            self:setAutoSize(false)
            return self
        end,

        --- Queues a new draw function to be called when the object is drawn.
        draw = function(self)
            base.draw(self)
            self:addDraw("label", function()
                local w, h = self:getSize()
                local text = self:getText()
                local textAlign = self:getTextAlign()
                local align = textAlign=="center" and math.floor(w/2-text:len()/2+0.5) or textAlign=="right" and w-(text:len()-1) or 1
                writeWrappedText(self, align, 1, text, w+1, h)
            end)
        end,
    }

    object.__index = object
    return setmetatable(object, base)
end
