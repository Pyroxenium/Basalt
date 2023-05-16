local XMLParser = require("xmlParser")

return {
    VisualObject = function(base)
        local bgSymbol = false
        local bgSymbolColor = colors.black  

        local object = {
            setBackground = function(self, bg, symbol, symbolCol)
                base.setBackground(self, bg)
                bgSymbol = symbol or bgSymbol
                bgSymbolColor = symbolCol or bgSymbolColor
                return self
            end,

            setBackgroundSymbol = function(self, symbol, symbolCol)
                bgSymbol = symbol
                bgSymbolColor = symbolCol or bgSymbolColor
                self:updateDraw()
                return self
            end,

            getBackgroundSymbol = function(self)
                return bgSymbol
            end,

            getBackgroundSymbolColor = function(self)
                return bgSymbolColor
            end,

            draw = function(self)
                base.draw(self)
                self:addDraw("advanced-bg", function()
                    local w, h = self:getSize()
                    if(bgSymbol~=false)then
                        self:addTextBox(1, 1, w, h, bgSymbol:sub(1,1))
                        if(bgSymbol~=" ")then
                            self:addForegroundBox(1, 1, w, h, bgSymbolColor)
                        end
                    end
                end, 2)
            end
        }

        return object
    end
}