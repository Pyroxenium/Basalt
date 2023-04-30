return function(name, basalt)
    local base = basalt.getObject("ChangeableObject")(name, basalt)
    local objectType = "Graph"

    base:setZIndex(5)
    base:setSize(30, 10)

    local graphData = {}
    local graphColor = colors.gray
    local graphSymbol = "\7"
    local graphSymbolCol = colors.black
    local maxValue = 100
    local minValue = 0
    local graphType = "line"
    local maxEntries = 10

    local object = {
        getType = function(self)
            return objectType
        end,

        setGraphColor = function(self, color)
            graphColor = color or graphColor
            self:updateDraw()
            return self
        end,

        setGraphSymbol = function(self, symbol, symbolcolor)
            graphSymbol = symbol or graphSymbol
            graphSymbolCol = symbolcolor or graphSymbolCol
            self:updateDraw()
            return self
        end,

        getGraphSymbol = function(self)
            return graphSymbol, graphSymbolCol
        end,

        addDataPoint = function(self, value)
            if value >= minValue and value <= maxValue then
                table.insert(graphData, value)
                self:updateDraw()
            end
            if(#graphData>100)then -- 100 is hard capped to prevent memory leaks
                table.remove(graphData,1)
            end
            return self
        end,

        setMaxValue = function(self, value)
            maxValue = value
            self:updateDraw()
            return self
        end,

        getMaxValue = function(self)
            return maxValue
        end,

        setMinValue = function(self, value)
            minValue = value
            self:updateDraw()
            return self
        end,

        getMinValue = function(self)
            return minValue
        end,

        setGraphType = function(self, graph_type)
            if graph_type == "scatter" or graph_type == "line" or graph_type == "bar" then
                graphType = graph_type
                self:updateDraw()
            end
            return self
        end,

        setMaxEntries = function(self, value)
            maxEntries = value
            self:updateDraw()
            return self
        end,
    
        getMaxEntries = function(self)
            return maxEntries
        end,

        clear = function(self)
            graphData = {}
            self:updateDraw()
            return self
        end,

        draw = function(self)
            base.draw(self)
            self:addDraw("graph", function()
                local obx, oby = self:getPosition()
                local w, h = self:getSize()
                local bgCol, fgCol = self:getBackground(), self:getForeground()

                local range = maxValue - minValue
                local prev_x, prev_y

                local startIndex = #graphData - maxEntries + 1
                if startIndex < 1 then startIndex = 1 end

                for i = startIndex, #graphData do
                    local data = graphData[i]
                    local x = math.floor(((w - 1) / (maxEntries - 1)) * (i - startIndex) + 1.5)
                    local y = math.floor((h - 1) - ((h - 1) / range) * (data - minValue) + 1.5)


                    if graphType == "scatter" then
                        self:addBackgroundBox(x, y, 1, 1, graphColor)
                        self:addForegroundBox(x, y, 1, 1, graphSymbolCol)
                        self:addTextBox(x, y, 1, 1, graphSymbol)
                    elseif graphType == "line" then
                        if prev_x and prev_y then
                            local dx = math.abs(x - prev_x)
                            local dy = math.abs(y - prev_y)
                            local sx = prev_x < x and 1 or -1
                            local sy = prev_y < y and 1 or -1
                            local err = dx - dy
                        
                            while true do
                                self:addBackgroundBox(prev_x, prev_y, 1, 1, graphColor)
                                self:addForegroundBox(prev_x, prev_y, 1, 1, graphSymbolCol)
                                self:addTextBox(prev_x, prev_y, 1, 1, graphSymbol)
                        
                                if prev_x == x and prev_y == y then
                                    break
                                end
                        
                                local e2 = 2 * err
                        
                                if e2 > -dy then
                                    err = err - dy
                                    prev_x = prev_x + sx
                                end
                        
                                if e2 < dx then
                                    err = err + dx
                                    prev_y = prev_y + sy
                                end
                            end
                        end
                        prev_x, prev_y = x, y
                    elseif graphType == "bar" then
                        self:addBackgroundBox(x - 1, y, 1, h - y, graphColor)
                    end
                end
            end)
        end,

    }

    object.__index = object
    return setmetatable(object, base)
end