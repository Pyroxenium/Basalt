local tHex = require("tHex")

local function line(x1, y1, x2, y2)
    local points = {}
    local dx = math.abs(x2 - x1)
    local dy = math.abs(y2 - y1)
    local sx = (x1 < x2) and 1 or -1
    local sy = (y1 < y2) and 1 or -1
    local err = dx - dy

    while true do
        table.insert(points, {x = x1, y = y1})

        if (x1 == x2 and y1 == y2) then break end
        local e2 = err * 2
        if e2 > -dy then
            err = err - dy
            x1 = x1 + sx
        end
        if e2 < dx then
            err = err + dx
            y1 = y1 + sy
        end
    end
    return points
end

local function circle(xPos, yPos, radius, filled)
    local points = {}

    local function plotPoints(xc, yc, x, y)
        table.insert(points, {x = xc + x, y = yc + y})
        table.insert(points, {x = xc - x, y = yc + y})
        table.insert(points, {x = xc + x, y = yc - y})
        table.insert(points, {x = xc - x, y = yc - y})
        table.insert(points, {x = xc + y, y = yc + x})
        table.insert(points, {x = xc - y, y = yc + x})
        table.insert(points, {x = xc + y, y = yc - x})
        table.insert(points, {x = xc - y, y = yc - x})
    end

    local function fillPoints(xc, yc, x, y)
        for fillX = -x, x do
            table.insert(points, {x = xc + fillX, y = yc + y})
            table.insert(points, {x = xc + fillX, y = yc - y})
        end
        for fillY = -y, y do
            table.insert(points, {x = xc + fillY, y = yc + x})
            table.insert(points, {x = xc + fillY, y = yc - x})
        end
    end

    local x = 0
    local y = radius
    local d = 3 - 2 * radius

    if filled then
        fillPoints(xPos, yPos, x, y)
    else
        plotPoints(xPos, yPos, x, y)
    end

    while y >= x do
        x = x + 1

        if d > 0 then
            y = y - 1
            d = d + 4 * (x - y) + 10
        else
            d = d + 4 * x + 6
        end

        if filled then
            fillPoints(xPos, yPos, x, y)
        else
            plotPoints(xPos, yPos, x, y)
        end
    end

    return points
end

local function ellipse(xPos, yPos, radiusX, radiusY, filled)
    local points = {}            
    local function plotPoints(xc, yc, x, y)
        table.insert(points, {x = xc + x, y = yc + y})
        table.insert(points, {x = xc - x, y = yc + y})
        table.insert(points, {x = xc + x, y = yc - y})
        table.insert(points, {x = xc - x, y = yc - y})
    end

    local function fillPoints(xc, yc, x, y)
        for fillX = -x, x do
            table.insert(points, {x = xc + fillX, y = yc + y})
            table.insert(points, {x = xc + fillX, y = yc - y})
        end
    end

    local x = 0
    local y = radiusY
    local d1 = (radiusY * radiusY) - (radiusX * radiusX * radiusY) + (0.25 * radiusX * radiusX)

    plotPoints(xPos, yPos, x, y)

    while ((radiusX * radiusX * (y - 0.5)) > (radiusY * radiusY * (x + 1))) do
        if (d1 < 0) then
            d1 = d1 + (2 * radiusY * radiusY * x) + (3 * radiusY * radiusY)
        else
            d1 = d1 + (2 * radiusY * radiusY * x) - (2 * radiusX * radiusX * y) + (2 * radiusX * radiusX)
            y = y - 1
        end
        x = x + 1
        if filled then fillPoints(xPos, yPos, x, y) end
    end

    local d2 = ((radiusY * radiusY) * ((x + 0.5) * (x + 0.5))) + ((radiusX * radiusX) * ((y - 1) * (y - 1))) - (radiusX * radiusX * radiusY * radiusY)

    while y > 0 do
        y = y - 1
        if d2 < 0 then
            d2 = d2 + (2 * radiusY * radiusY * x) - (2 * radiusX * radiusX * y) + (radiusX * radiusX)
            x = x + 1
        else
            d2 = d2 - (2 * radiusX * radiusX * y) + (radiusX * radiusX)
        end
        if filled then fillPoints(xPos, yPos, x, y) end
    end
    return points
end

local function polygon(points, filled)
    local newPoints = {}
            
    local pointsCopy = {}
    for i, point in ipairs(points) do
        table.insert(pointsCopy, {x = point.x, y = point.y})
    end
    if pointsCopy[1].x ~= pointsCopy[#pointsCopy].x or pointsCopy[1].y ~= pointsCopy[#pointsCopy].y then
        table.insert(pointsCopy, {x = pointsCopy[1].x, y = pointsCopy[1].y})
    end

    local lines = {}
    for i = 1, #pointsCopy - 1 do
        local linePoints = line(pointsCopy[i].x, pointsCopy[i].y, pointsCopy[i+1].x, pointsCopy[i+1].y)
        for _, point in ipairs(linePoints) do
            table.insert(lines, point)
        end
    end

    if filled then
        local minX, maxX, minY, maxY = math.huge, -math.huge, math.huge, -math.huge
        for _, point in ipairs(pointsCopy) do
            minX = math.min(minX, point.x)
            maxX = math.max(maxX, point.x)
            minY = math.min(minY, point.y)
            maxY = math.max(maxY, point.y)
        end

        local fillPoints = {}
        for y = minY, maxY do
            for x = minX, maxX do
                local numCrossings = 0
                for i = 1, #pointsCopy - 1 do
                    if ((pointsCopy[i].y > y) ~= (pointsCopy[i+1].y > y)) and
                        (x < (pointsCopy[i+1].x - pointsCopy[i].x) * (y - pointsCopy[i].y) / 
                            (pointsCopy[i+1].y - pointsCopy[i].y) + pointsCopy[i].x) then
                        numCrossings = numCrossings + 1
                    end
                end
                if numCrossings % 2 == 1 then
                    table.insert(fillPoints, {x = x, y = y})
                end
            end
        end
        return fillPoints
    end
    return lines
end

local function rectangle(xPos, yPos, width, height, filled)
    local points = {}
            
    if filled then
        for y = yPos, yPos + height - 1 do
            for x = xPos, xPos + width - 1 do
                table.insert(points, {x = x, y = y})
            end
        end
    else
        for x = xPos, xPos + width - 1 do
            table.insert(points, {x = x, y = yPos})
            table.insert(points, {x = x, y = yPos + height - 1})
        end
        for y = yPos, yPos + height - 1 do
            table.insert(points, {x = xPos, y = y})
            table.insert(points, {x = xPos + width - 1, y = y})
        end
    end
    return points
end

local rep,sub = string.rep, string.sub

return {
    VisualObject = function(base)
        local object = {}

        for _,v in pairs({"Text", "Bg", "Fg"})do
            object["add"..v.."Line"] = function(self, x1, y1, x2, y2, val)
                if(type(val)=="number")then
                    val = tHex[val]
                end
                if(#val>1)then
                    val = sub(val, 1, 1)
                end
                local points = line(x1, y1, x2, y2)
                for _,point in ipairs(points)do
                    self["add"..v](self, point.x, point.y, val)
                end
                return self
            end

            object["add"..v.."Circle"] = function(self, xPos, yPos, radius, filled, val)
                if(type(val)=="number")then
                    val = tHex[val]
                end
                if(#val>1)then
                    val = sub(val, 1, 1)
                end

                local points = circle(xPos, yPos, radius, filled)

                for _,point in ipairs(points)do
                    self["add"..v](self, point.x, point.y, val)
                end
                return self
            end

            object["add"..v.."Ellipse"] = function(self, xPos, yPos, radiusX, radiusY, filled, val)
                if(type(val)=="number")then
                    val = tHex[val]
                end
                if(#val>1)then
                    val = sub(val, 1, 1)
                end

                local points = ellipse(xPos, yPos, radiusX, radiusY, filled)
                for _,point in ipairs(points)do
                    self["add"..v](self, point.x, point.y, val)
                end
                return self
            end

            object["add"..v.."Polygon"] = function(self, points, filled, val)
                if(type(val)=="number")then
                    val = tHex[val]
                end
                if(#val>1)then
                    val = sub(val, 1 ,1)
                end
                local newPoints = polygon(points, filled)
                for _,point in ipairs(newPoints)do
                    self["add"..v](self, point.x, point.y, val)
                end
                return self
            end

            object["add"..v.."Rectangle"] = function(self, xPos, yPos, width, height, filled, val)
                if(type(val)=="number")then
                    val = tHex[val]
                end
                if(#val>1)then
                    val = sub(val, 1, 1)
                end
                local points = rectangle(xPos, yPos, width, height, filled)
                for _,point in ipairs(points)do
                    self["add"..v](self, point.x, point.y, val)
                end
                return self
            end
        end

        --[[
        function object.addInlineBorder(self, x, y, width, height, color, bg)
            self:addTextBox(x, y, 1, h, "\149")
            self:addBackgroundBox(x, y, 1, h, bgCol)
            self:addForegroundBox(x, y, 1, h, borderColors["left"])

        
            self:addTextBox(x, y, x+width-1, 1, "\131")
            self:addBackgroundBox(x, y, x+width-1, 1, bgCol)
            self:addForegroundBox(x, y, x+width-1, 1, borderColors["top"])

            self:addTextBox(x, y, 1, 1, "\151")
            self:addBackgroundBox(x, y, 1, 1, bgCol)
            self:addForegroundBox(x, y, 1, 1, borderColors["left"])
        
            self:addTextBox(x+width-1, 1, 1, h, "\149")
            self:addForegroundBox(x+width-1, 1, 1, h, bgCol)
            self:addBackgroundBox(x+width-1, 1, 1, h, borderColors["right"])
        
            self:addTextBox(1, h, x+width-1, 1, "\143")
            self:addForegroundBox(1, h, x+width-1, 1, bgCol)
            self:addBackgroundBox(1, h, x+width-1, 1, borderColors["bottom"])

            self:addTextBox(x+width-1, 1, 1, 1, "\148")
            self:addForegroundBox(x+width-1, 1, 1, 1, bgCol)
            self:addBackgroundBox(x+width-1, 1, 1, 1, borderColors["right"])

            self:addTextBox(x+width-1, h, 1, 1, "\133")
            self:addForegroundBox(x+width-1, h, 1, 1, bgCol)
            self:addBackgroundBox(x+width-1, h, 1, 1, borderColors["right"])

            self:addTextBox(1, h, 1, 1, "\138")
            self:addForegroundBox(1, h, 1, 1, bgCol)
            self:addBackgroundBox(1, h, 1, 1, borderColors["left"])
        end]]

        return object
    end
}