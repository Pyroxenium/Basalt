local function Scrollbar(name)
    local base = Object(name)
    local objectType = "Scrollbar"

    base.width = 1
    base.height = 8
    base.bgColor = colors.lightGray
    base.fgColor = colors.gray
    base:setValue(1)
    base:setZIndex(2)

    local barType = "vertical"
    local symbol = " "
    local symbolColor = colors.black
    local bgSymbol = "\127"
    local maxValue = base.height
    local index = 1
    local symbolSize = 1

    local object = {
        getType = function(self)
            return objectType
        end;

        setSymbol = function(self, _symbol)
            symbol = _symbol:sub(1, 1)
            self:setVisualChanged()
            return self
        end;

        setSymbolSize = function(self, size)
            symbolSize = tonumber(size) or 1
            if (barType == "vertical") then
                self:setValue(index - 1 * (maxValue / (self.height - (symbolSize - 1))) - (maxValue / (self.height - (symbolSize - 1))))
            elseif (barType == "horizontal") then
                self:setValue(index - 1 * (maxValue / (self.width - (symbolSize - 1))) - (maxValue / (self.width - (symbolSize - 1))))
            end
            self:setVisualChanged()
            return self
        end;

        setMaxValue = function(self, val)
            maxValue = val
            return self
        end;

        setBackgroundSymbol = function(self, _bgSymbol)
            bgSymbol = string.sub(_bgSymbol, 1, 1)
            self:setVisualChanged()
            return self
        end;

        setSymbolColor = function(self, col)
            symbolColor = col
            self:setVisualChanged()
            return self
        end;

        setBarType = function(self, _typ)
            barType = _typ:lower()
            return self
        end;

        mouseClickHandler = function(self, event, button, x, y)
            if (base.mouseClickHandler(self, event, button, x, y)) then
                local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
                if ((event == "mouse_click") or (event == "mouse_drag")) and (button == 1) then
                    if (barType == "horizontal") then
                        for _index = 0, self.width do
                            if (obx + _index == x) and (oby <= y) and (oby + self.height > y) then
                                index = math.min(_index + 1, self.width - (symbolSize - 1))
                                self:setValue(maxValue / self.width * (index))
                                self:setVisualChanged()
                            end
                        end
                    end
                    if (barType == "vertical") then
                        for _index = 0, self.height do
                            if (oby + _index == y) and (obx <= x) and (obx + self.width > x) then
                                index = math.min(_index + 1, self.height - (symbolSize - 1))
                                self:setValue(maxValue / self.height * (index))
                                self:setVisualChanged()
                            end
                        end
                    end
                end
                if (event == "mouse_scroll") then
                    index = index + button
                    if (index < 1) then
                        index = 1
                    end
                    index = math.min(index, (barType == "vertical" and self.height or self.width) - (symbolSize - 1))
                    self:setValue(maxValue / (barType == "vertical" and self.height or self.width) * index)
                end
                return true
            end
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    if (barType == "horizontal") then
                        self.parent:writeText(obx, oby, bgSymbol:rep(index - 1), self.bgColor, self.fgColor)
                        self.parent:writeText(obx + index - 1, oby, symbol:rep(symbolSize), symbolColor, symbolColor)
                        self.parent:writeText(obx + index + symbolSize - 1, oby, bgSymbol:rep(self.width - (index + symbolSize - 1)), self.bgColor, self.fgColor)
                    end

                    if (barType == "vertical") then
                        for n = 0, self.height - 1 do

                            if (index == n + 1) then
                                for curIndexOffset = 0, math.min(symbolSize - 1, self.height) do
                                    self.parent:writeText(obx, oby + n + curIndexOffset, symbol, symbolColor, symbolColor)
                                end
                            else
                                if (n + 1 < index) or (n + 1 > index - 1 + symbolSize) then
                                    self.parent:writeText(obx, oby + n, bgSymbol, self.bgColor, self.fgColor)
                                end
                            end
                        end
                    end
                end
            end
        end;
    }

    return setmetatable(object, base)
end