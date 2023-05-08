return function(name, basalt)
    local base = basalt.getObject("ChangeableObject")(name, basalt)
    local objectType = "Switch"

    base:setSize(4, 1)
    base:setValue(false)
    base:setZIndex(5)

    local bgSymbol = colors.black
    local inactiveBG = colors.red
    local activeBG = colors.green

    local object = {
        getType = function(self)
            return objectType
        end,

        setSymbol = function(self, col)
            bgSymbol = col
            return self
        end,

        setActiveBackground = function(self, col)
            activeBG = col
            return self
        end,

        setInactiveBackground = function(self, col)
            inactiveBG = col
            return self
        end,


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
                local parent = self:getParent()
                local bgCol,fgCol = self:getBackground(), self:getForeground()
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