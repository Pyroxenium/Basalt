local utils = require("utils")
local tHex = require("tHex")

return function(name, basalt)
    -- Checkbox
    local base = basalt.getObject("ChangeableObject")(name, basalt)
    base:setType("Checkbox")

    base:setZ(5)
    base:setValue(false)
    base:setSize(1, 1)

    base:addProperty("activeSymbol", "char", "\42")
    base:addProperty("inactiveSymbol", "char", " ")
    base:combineProperty("Symbol", "activeSymbol", "inactiveSymbol")

    base:addProperty("text", "string", "")
    base:addProperty("textPosition", {"left", "right"}, "right")

    local object = {
        load = function(self)
            self:listenEvent("mouse_click", self)
            self:listenEvent("mouse_up", self)
        end,
        
        setChecked = base.setValue,

        getChecked = base.getValue,

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

        draw = function(self)
            base.draw(self)
            self:addDraw("checkbox", function()
                local w,h = self:getSize()
                local verticalAlign = utils.getTextVerticalAlign(h, "center")
                local bg,fg = self:getBackground(), self:getForeground()
                local symbol = self:getActiveSymbol()
                local inactiveSymbol = self:getInactiveSymbol()
                local text = self:getText()
                local textPos = self:getTextPosition()
                if (self:getValue()) then
                    self:addBlit(1, verticalAlign, utils.getTextHorizontalAlign(symbol, w, "center"), tHex[fg], tHex[bg])
                else
                    self:addBlit(1, verticalAlign, utils.getTextHorizontalAlign(inactiveSymbol, w, "center"), tHex[fg], tHex[bg])
                end
                if(text~="")then
                    local align = textPos=="left" and -text:len() or 3
                    self:addText(align, verticalAlign, text)
                end
            end)
        end,
    }

    object.__index = object
    return setmetatable(object, base)
end