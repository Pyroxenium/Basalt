local tHex = require("tHex")

return function(name, basalt)
    local base = basalt.getObject("ChangeableObject")(name, basalt)
    base:setType("Slider")

    base:setSize(12, 1)
    base:setValue(1)

    base:addProperty("SymbolText", "char", " ")
    base:addProperty("SymbolForeground", "color", colors.black)
    base:addProperty("SymbolBackground", "color", colors.gray)
    base:combineProperty("Symbol", "SymbolText", "SymbolForeground", "SymbolBackground")
    base:addProperty("SymbolSize", "number", 1)
    base:addProperty("BarType", {"vertical", "horizontal"}, "horizontal")
    base:addProperty("MaxValue", "number", 12)

    local index = 1

    local function mouseEvent(self, _, x, y)
    local obx, oby = self:getPosition()
    local w,h = self:getSize()
    local barType = self:getBarType()
        local size = barType == "vertical" and h or w
        local symbolSize = self:getSymbolSize()
        local symbol = self:getSymbol()
        local maxValue = self:getMaxValue()
        for i = 0, size do
            if ((barType == "vertical" and oby + i == y) or (barType == "horizontal" and obx + i == x)) and (obx <= x) and (obx + w > x) and (oby <= y) and (oby + h > y) then
                index = math.min(i + 1, size - (#symbol + symbolSize - 2))
                self:setValue(maxValue / size * index)
                self:updateDraw()
            end
        end
    end

    local object = {
        init = function(self)
            base.init(self)
            base:setBgSymbol("\140")
            base:setBgSymbolColor(colors.black)
            base:setBackground(nil)
        end,
        load = function(self)
            self:listenEvent("mouse_click")
            self:listenEvent("mouse_drag")
            self:listenEvent("mouse_scroll")
        end,

        setIndex = function(self, _index)
            index = _index
            if (index < 1) then
                index = 1
            end
            local w,h = self:getSize()
            local symbolSize = self:getSymbolSize()
            local maxValue = self:getMaxValue()
            local barType = self:getBarType()
            index = math.min(index, (barType == "vertical" and h or w) - (symbolSize - 1))
            self:setValue(maxValue / (barType == "vertical" and h or w) * index)
            self:updateDraw()
            return self
        end,

        getIndex = function(self)
            return index
        end,

        mouseHandler = function(self, button, x, y)
            if (base.mouseHandler(self, button, x, y)) then
                mouseEvent(self, button, x, y)
                return true
            end
            return false
        end,

        dragHandler = function(self, button, x, y)
            if (base.dragHandler(self, button, x, y)) then
                mouseEvent(self, button, x, y)
                return true
            end
            return false
        end,

        scrollHandler = function(self, dir, x, y)
            if(base.scrollHandler(self, dir, x, y))then
                local w,h = self:getSize()
                index = index + dir
                if (index < 1) then
                    index = 1
                end
                local symbolSize = self:getSymbolSize()
                local maxValue = self:getMaxValue()
                local barType = self:getBarType()
                index = math.min(index, (barType == "vertical" and h or w) - (symbolSize - 1))
                self:setValue(maxValue / (barType == "vertical" and h or w) * index)
                self:updateDraw()
                return true
            end
            return false
        end,

        draw = function(self)
            base.draw(self)
            self:addDraw("slider", function()
                local w,h = self:getSize()
                local bgCol,fgCol = self:getBackground(), self:getForeground()
                local symbolSize = self:getSymbolSize()
                local symbol = self:getSymbolText()
                local symbolFG = self:getSymbolForeground()
                local symbolBG = self:getSymbolBackground()
                local barType = self:getBarType()
                local obx, oby = self:getPosition()
                if (barType == "horizontal") then
                    self:addText(index, oby, symbol:rep(symbolSize))
                    if(symbolBG~=false)then self:addBg(index, 1, tHex[symbolBG]:rep(#symbol*symbolSize)) end
                    if(symbolFG~=false)then self:addFg(index, 1, tHex[symbolFG]:rep(#symbol*symbolSize)) end
                end

                if (barType == "vertical") then
                    for n = 0, h - 1 do
                        if (index == n + 1) then
                            for curIndexOffset = 0, math.min(symbolSize - 1, h) do
                                self:addBlit(1, 1+n+curIndexOffset, symbol, tHex[symbolFG], tHex[symbolFG])
                            end
                        else
                            if (n + 1 < index) or (n + 1 > index - 1 + symbolSize) then
                                self:addBlit(1, 1+n, " ", tHex[fgCol], tHex[bgCol])
                            end
                        end
                    end
                end
            end)
        end,
    }

    object.__index = object
    return setmetatable(object, base)
end