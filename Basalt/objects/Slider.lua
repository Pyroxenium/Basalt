local tHex = require("tHex")

return function(name, basalt)
    local base = basalt.getObject("ChangeableObject")(name, basalt)
    local objectType = "Slider"

    base:setSize(12, 1)
    base:setValue(1)
    base:setBackground(false, "\140", colors.black)

    local barType = "horizontal"
    local symbol = " "
    local symbolFG = colors.black
    local symbolBG = colors.gray
    local maxValue = 12
    local index = 1
    local symbolSize = 1

    local function mouseEvent(self, button, x, y)
    local obx, oby = self:getPosition()
    local w,h = self:getSize()
        local size = barType == "vertical" and h or w
        for i = 0, size do
            if ((barType == "vertical" and oby + i == y) or (barType == "horizontal" and obx + i == x)) and (obx <= x) and (obx + w > x) and (oby <= y) and (oby + h > y) then
                index = math.min(i + 1, size - (#symbol + symbolSize - 2))
                self:setValue(maxValue / size * index)
                self:updateDraw()
            end
        end
    end

    local object = {
        getType = function(self)
            return objectType
        end,

        load = function(self)
            self:listenEvent("mouse_click")
            self:listenEvent("mouse_drag")
            self:listenEvent("mouse_scroll")
        end,

        setSymbol = function(self, _symbol)
            symbol = _symbol:sub(1, 1)
            self:updateDraw()
            return self
        end,

        setIndex = function(self, _index)
            index = _index
            if (index < 1) then
                index = 1
            end
            local w,h = self:getSize()
            index = math.min(index, (barType == "vertical" and h or w) - (symbolSize - 1))
            self:setValue(maxValue / (barType == "vertical" and h or w) * index)
            self:updateDraw()
            return self
        end,

        getIndex = function(self)
            return index
        end,

        setMaxValue = function(self, val)
            maxValue = val
            return self
        end,

        setSymbolColor = function(self, col)
            symbolColor = col
            self:updateDraw()
            return self
        end,

        setBarType = function(self, _typ)
            barType = _typ:lower()
            self:updateDraw()
            return self
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
                if (barType == "horizontal") then
                    self:addText(index, oby, symbol:rep(symbolSize))
                    if(symbolBG~=false)then self:addBG(index, 1, tHex[symbolBG]:rep(#symbol*symbolSize)) end
                    if(symbolFG~=false)then self:addFG(index, 1, tHex[symbolFG]:rep(#symbol*symbolSize)) end
                end

                if (barType == "vertical") then
                    for n = 0, h - 1 do
                        if (index == n + 1) then
                            for curIndexOffset = 0, math.min(symbolSize - 1, h) do
                                self:addBlit(1, 1+n+curIndexOffset, symbol, tHex[symbolColor], tHex[symbolColor])
                            end
                        else
                            if (n + 1 < index) or (n + 1 > index - 1 + symbolSize) then
                                self:addBlit(1, 1+n, bgSymbol, tHex[fgCol], tHex[bgCol])
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