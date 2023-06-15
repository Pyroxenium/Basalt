local utils = require("utils")
local tHex = require("tHex")

return function(name, basalt)
    -- Button
    local base = basalt.getObject("VisualObject")(name, basalt)
    base:setType("Button")

    base:setSize(12, 3)
    base:setZ(5)

    base:addProperty("text", "string", "Button")
    base:addProperty("textHorizontalAlign", {"left", "center", "right"}, "center")
    base:addProperty("textVerticalAlign", {"left", "center", "right"}, "center")
    base:combineProperty("textAlign", "textHorizontalAlign", "textVerticalAlign")

    local object = {
        getBase = function(self)
            return base
        end,

        draw = function(self)
            base.draw(self)
            self:addDraw("button", function()
                local w,h = self:getSize()
                local textHorizontalAlign = self:getTextHorizontalAlign()
                local textVerticalAlign = self:getTextVerticalAlign()
                local verticalAlign = utils.getTextVerticalAlign(h, textVerticalAlign)
                local text = self:getText()
                local xOffset
                if(textHorizontalAlign=="center")then
                    xOffset = math.floor((w - text:len()) / 2)
                elseif(textHorizontalAlign=="right")then
                    xOffset = w - text:len()
                end

                self:addText(xOffset + 1, verticalAlign, text)
                self:addFg(xOffset + 1, verticalAlign, tHex[self:getForeground() or colors.white]:rep(text:len()))
            end)
        end,
    }
    object.__index = object
    return setmetatable(object, base)
end