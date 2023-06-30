return function(name, basalt)
    local base = basalt.getObject("VisualObject")(name, basalt)
    base:setType("Graph")

    base:setZ(5)
    base:setSize(30, 10)

    base:addProperty("GraphColor", "color", colors.gray)
    base:addProperty("GraphSymbol", "char", "\7")
    base:addProperty("GraphSymbolColor", "color", colors.black)
    base:addProperty("MaxValue", "number", 100)
    base:addProperty("MinValue", "number", 0)
    base:addProperty("GraphType", {"bar", "line", "scatter"}, "line")
    base:addProperty("MaxEntries", "number", 10)

    local graphData = {}

    local object = {
        addDataPoint = function(self, value)
            local minValue = self:getMinValue()
            local maxValue = self:getMaxValue()
            if value >= minValue and value <= maxValue then
                table.insert(graphData, value)
                self:updateDraw()
            end
            while #graphData>self:getMaxEntries() do
                table.remove(graphData,1)
            end
            return self
        end,

        clear = function(self)
            graphData = {}
            self:updateDraw()
            return self
        end,

        draw = function(self)
            base.draw(self)
            self:addDraw("graph", function()
                local w, h = self:getSize()
                local graphColor = self:getGraphColor()
                local graphSymbol = self:getGraphSymbol()
                local graphSymbolCol = self:getGraphSymbolColor()
                local maxValue = self:getMaxValue()
                local minValue = self:getMinValue()
                local graphType = self:getGraphType()
                local maxEntries = self:getMaxEntries()

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
