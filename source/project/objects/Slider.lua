local function Slider(name)
    local base = Object(name)
    local objectType = "Slider"

    base.width = 8
    base.bgColor = colors.lightGray
    base.fgColor = colors.gray
    base:setValue(1)

    local barType = "horizontal"
    local symbol = " "
    local symbolColor = colors.black
    local bgSymbol = "\140"
    local maxValue = base.width
    local index = 1

    local object = {
        getType = function(self)
            return objectType
        end;

        setSymbol = function(self, _symbol)
            symbol = _symbol:sub(1, 1)
            self:setVisualChanged()
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

        setValue = function(self, val)
            index = math.floor(val / maxValue)
            if (barType == "horizontal") then
                if(index<1)then index = 1
                elseif(index>self.width)then index = self.width end
                base.setValue(self, maxValue / self.width * (index))
            elseif (barType == "vertical") then
                if(index<1)then index = 1
                elseif(index>self.height)then index = self.height end
                base.setValue(self, maxValue / self.height * (index))
            end
            return self
        end;

        setIndex = function(self, _index)
            if (barType == "horizontal") then
                if(_index>=1)and(_index<=self.width)then
                    index = _index
                    base.setValue(self, maxValue / self.width * (index))
                end
            elseif(barType == "vertical") then
                if(_index>=1)and(_index<=self.height)then
                    index = _index
                    base.setValue(self, maxValue / self.height * (index))
                end
            end
            return self
        end;

        mouseClickHandler = function(self, event, button, x, y)
            if (base.mouseClickHandler(self, event, button, x, y)) then
                local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
                if (barType == "horizontal") then
                    for _index = 0, self.width - 1 do
                        if (obx + _index == x) and (oby <= y) and (oby + self.height > y) then
                            index = _index + 1
                            base.setValue(self, maxValue / self.width * (index))
                            self:setVisualChanged()
                        end
                    end
                end
                if (barType == "vertical") then
                    for _index = 0, self.height - 1 do
                        if (oby + _index == y) and (obx <= x) and (obx + self.width > x) then
                            index = _index + 1
                            base.setValue(self, maxValue / self.height * (index))
                            self:setVisualChanged()
                        end
                    end
                end
                --[[if(event=="mouse_scroll")then
                    self:setValue(self:getValue() + (maxValue/(barType=="vertical" and self.height or self.width))*typ)
                    self:setVisualChanged()
                end
                if(self:getValue()>maxValue)then self:setValue(maxValue) end
                if(self:getValue()<maxValue/(barType=="vertical" and self.height or self.width))then self:setValue(maxValue/(barType=="vertical" and self.height or self.width)) end
                ]]
            end
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    if (barType == "horizontal") then
                        self.parent:writeText(obx, oby, bgSymbol:rep(index - 1), self.bgColor, self.fgColor)
                        self.parent:writeText(obx + index - 1, oby, symbol, symbolColor, symbolColor)
                        self.parent:writeText(obx + index, oby, bgSymbol:rep(self.width - (index)), self.bgColor, self.fgColor)
                    end

                    if (barType == "vertical") then
                        for n = 0, self.height - 1 do
                            if (n + 1 == index) then
                                self.parent:writeText(obx, oby + n, symbol, symbolColor, symbolColor)
                            else
                                self.parent:writeText(obx, oby + n, bgSymbol, self.bgColor, self.fgColor)
                            end
                        end
                    end
                end
            end
        end;

    }

    return setmetatable(object, base)
end