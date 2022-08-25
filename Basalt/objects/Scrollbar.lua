local Object = require("Object")
local xmlValue = require("utils").getValueFromXML

return function(name)
    local base = Object(name)
    local objectType = "Scrollbar"

    base.width = 1
    base.height = 8
    base:setValue(1)
    base:setZIndex(2)

    local barType = "vertical"
    local symbol = " "
    local symbolColor
    local bgSymbol = "\127"
    local maxValue = base.height
    local index = 1
    local symbolSize = 1

    local function mouseEvent(self, button, x, y)
    local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
    local w,h = self:getSize()
        if (barType == "horizontal") then
            for _index = 0, w do
                if (obx + _index == x) and (oby <= y) and (oby + h > y) then
                    index = math.min(_index + 1, w - (symbolSize - 1))
                    self:setValue(maxValue / w * (index))
                    self:updateDraw()
                end
            end
        end
        if (barType == "vertical") then
            for _index = 0, h do
                if (oby + _index == y) and (obx <= x) and (obx + w > x) then
                    index = math.min(_index + 1, h - (symbolSize - 1))
                    self:setValue(maxValue / h * (index))
                    self:updateDraw()
                end
            end
        end
    end

    local object = {
        getType = function(self)
            return objectType
        end;

        setSymbol = function(self, _symbol)
            symbol = _symbol:sub(1, 1)
            self:updateDraw()
            return self
        end;

        setValuesByXMLData = function(self, data)
            base.setValuesByXMLData(self, data)
            if(xmlValue("maxValue", data)~=nil)then maxValue = xmlValue("maxValue", data) end
            if(xmlValue("backgroundSymbol", data)~=nil)then bgSymbol = xmlValue("backgroundSymbol", data):sub(1,1) end
            if(xmlValue("symbol", data)~=nil)then symbol = xmlValue("symbol", data):sub(1,1) end
            if(xmlValue("barType", data)~=nil)then barType = xmlValue("barType", data):lower() end
            if(xmlValue("symbolSize", data)~=nil)then self:setSymbolSize(xmlValue("symbolSize", data)) end
            if(xmlValue("symbolColor", data)~=nil)then symbolColor = colors[xmlValue("symbolColor", data)] end
            if(xmlValue("index", data)~=nil)then self:setIndex(xmlValue("index", data)) end
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

        setSymbolSize = function(self, size)
            symbolSize = tonumber(size) or 1
            local w,h = self:getSize()
            if (barType == "vertical") then
                self:setValue(index - 1 * (maxValue / (h - (symbolSize - 1))) - (maxValue / (h - (symbolSize - 1))))
            elseif (barType == "horizontal") then
                self:setValue(index - 1 * (maxValue / (w - (symbolSize - 1))) - (maxValue / (w - (symbolSize - 1))))
            end
            self:updateDraw()
            return self
        end;

        setMaxValue = function(self, val)
            maxValue = val
            self:updateDraw()
            return self
        end;

        setBackgroundSymbol = function(self, _bgSymbol)
            bgSymbol = string.sub(_bgSymbol, 1, 1)
            self:updateDraw()
            return self
        end;

        setSymbolColor = function(self, col)
            symbolColor = col
            self:updateDraw()
            return self
        end;

        setBarType = function(self, _typ)
            barType = _typ:lower()
            self:updateDraw()
            return self
        end;

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
            end
        end,

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    local w,h = self:getSize()
                    if (barType == "horizontal") then
                        self.parent:writeText(obx, oby, bgSymbol:rep(index - 1), self.bgColor, self.fgColor)
                        self.parent:writeText(obx + index - 1, oby, symbol:rep(symbolSize), symbolColor, symbolColor)
                        self.parent:writeText(obx + index + symbolSize - 1, oby, bgSymbol:rep(w - (index + symbolSize - 1)), self.bgColor, self.fgColor)
                    end

                    if (barType == "vertical") then
                        for n = 0, h - 1 do
                            if (index == n + 1) then
                                for curIndexOffset = 0, math.min(symbolSize - 1, h) do
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
        end,

        init = function(self)
            self.bgColor = self.parent:getTheme("ScrollbarBG")
            self.fgColor = self.parent:getTheme("ScrollbarText")
            symbolColor = self.parent:getTheme("ScrollbarSymbolColor")
            self.parent:addEvent("mouse_click", self)
            self.parent:addEvent("mouse_drag", self)
            self.parent:addEvent("mouse_scroll", self)
        end,
    }

    return setmetatable(object, base)
end