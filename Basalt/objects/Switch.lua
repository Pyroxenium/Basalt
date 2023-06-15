return function(name, basalt)
    local base = basalt.getObject("ChangeableObject")(name, basalt)
    base:setType("Switch")

    base:setSize(4, 1)
    base:setValue(false)
    base:setZ(5)

    base:addProperty("SymbolColor", "color", colors.black)
    base:addProperty("ActiveBackground", "color", colors.green)
    base:addProperty("InactiveBackground", "color", colors.red)

    local object = {
        load = function(self)
            self:listenEvent("mouse_click")
        end,

        mouseHandler = function(self, ...)
            if (base.mouseHandler(self, ...)) then
                self:setValue(not self:getValue())
                self:updateDraw()
                return true
            end
        end,

        draw = function(self)
            base.draw(self)
            self:addDraw("switch", function()
                local activeBG = self:getActiveBackground()
                local inactiveBG = self:getInactiveBackground()
                local bgSymbol = self:getSymbolColor()
                local w,h = self:getSize()
                if(self:getValue())then
                    self:addBackgroundBox(1, 1, w, h, activeBG)
                    self:addBackgroundBox(w, 1, 1, h, bgSymbol)
                else
                    self:addBackgroundBox(1, 1, w, h, inactiveBG)
                    self:addBackgroundBox(1, 1, 1, h, bgSymbol)
                end
            end)
        end,
    }

    object.__index = object
    return setmetatable(object, base)
end