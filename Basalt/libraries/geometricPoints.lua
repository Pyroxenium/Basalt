local function line(x1,y1,x2,y2)
    local points = {}
    if x1 == x2 and y1 == y2 then return {x=x1,y=x2} end
    local minX = math.min(x1, x2)
    local maxX, minY, maxY
    if minX == x1 then minY,maxX,maxY = y1,x2,y2
    else minY,maxX,maxY = y2,x1,y1 end
    local xDiff,yDiff = maxX - minX,maxY - minY
    if xDiff > math.abs(yDiff) then
        local y = minY
        local dy = yDiff / xDiff
        for x = minX, maxX do
            table.insert(points,{x=x,y=math.floor(y + 0.5)})
            y = y + dy
        end
    else
        local x,dx = minX,xDiff / yDiff
        if maxY >= minY then
            for y = minY, maxY do
                table.insert(points,{x=math.floor(x + 0.5),y=y})
                x = x + dx
            end
        else
            for y = minY, maxY, -1 do
                table.insert(points,{x=math.floor(x + 0.5),y=y})
                x = x - dx
            end
        end
    end
    return points
end

local function filledCircle(xC, yC, r)
    local points = {}
    for x=-r, r+1 do
        local dy = math.floor(math.sqrt(r*r - x*x))
        for y=-dy, dy+1 do
            table.insert(points, {x=xC+x, y=yC+y})
        end
    end
    return points
end

local function ellipse(xC, yC, r1, r2, filled)
    local rx,ry = math.ceil(math.floor(r1-0.5)/2),math.ceil(math.floor(r2-0.5)/2)
    local x,y=0,ry
    local d1 = ((ry * ry) - (rx * rx * ry) + (0.25 * rx * rx))
    local dx = 2*ry^2*x
    local dy = 2*rx^2*y
    local points = {}
    while dx < dy do
        table.insert(points,{x=x+xC,y=y+yC})
        table.insert(points,{x=-x+xC,y=y+yC})
        table.insert(points,{x=x+xC,y=-y+yC})
        table.insert(points,{x=-x+xC,y=-y+yC})
        if filled then
            for y=-y+yC+1,y+yC-1 do
                table.insert(points,{x=x+xC,y=y})
                table.insert(points,{x=-x+xC,y=y})
            end
        end
        if d1 < 0 then
            x = x + 1
            dx = dx + 2*ry^2
            d1 = d1 + dx + ry^2
        else
            x,y = x+1,y-1
            dx = dx + 2*ry^2
            dy = dy - 2*rx^2
            d1 = d1 + dx - dy + ry^2
        end
    end
    local d2 = (((ry * ry) * ((x + 0.5) * (x + 0.5))) + ((rx * rx) * ((y - 1) * (y - 1))) - (rx * rx * ry * ry))
    while y >= 0 do
        table.insert(points,{x=x+xC,y=y+yC})
        table.insert(points,{x=-x+xC,y=y+yC})
        table.insert(points,{x=x+xC,y=-y+yC})
        table.insert(points,{x=-x+xC,y=-y+yC})
        if filled then
            for y=-y+yC,y+yC do
                table.insert(points,{x=x+xC,y=y})
                table.insert(points,{x=-x+xC,y=y})
            end
        end
        if d2 > 0 then
            y = y - 1
            dy = dy - 2*rx^2
            d2 = d2 + rx^2 - dy
        else
            y = y - 1
            x = x + 1
            dy = dy - 2*rx^2
            dx = dx + 2*ry^2
            d2 = d2 + dx - dy + rx^2
        end
    end
    return points
end

local function circle(xC, yC, r, filled)
    return ellipse(xC, yC, r, r, filled)
end

return {
circle = function(x, y, radius, filled)
    return circle(x, y, radius, filled)
end,

rectangle = function(x1, y1, x2, y2, filled)
    local points = {}
    if(filled)then
        for y=y1,y2 do
            for x=x1,x2 do
                table.insert(points, {x=x,y=y})
            end
        end
    else
        for y=y1,y2 do
                for x=x1,x2 do
                    if(x==x1)or(x==x2)or(y==y1)or(y==y2)then
                        table.insert(points, {x=x,y=y})
                    end
                end
        end
    end
    return points
end,

triangle = function(x1, y1, x2, y2, x3, y3, filled)
    local function drawFlatTopTriangle(points,x1,y1,x2,y2,x3,y3)
        local m1 = (x3 - x1) / (y3 - y1)
        local m2 = (x3 - x2) / (y3 - y2)
        local yStart = math.ceil(y1 - 0.5)
        local yEnd =   math.ceil(y3 - 0.5)-1
        for y = yStart, yEnd do
            local px1 = m1 * (y + 0.5 - y1) + x1
            local px2 = m2 * (y + 0.5 - y2) + x2
            local xStart = math.ceil(px1 - 0.5)
            local xEnd =   math.ceil(px2 - 0.5)
            for x=xStart,xEnd do
                table.insert(points,{x=x,y=y})
            end
        end
    end
    
    local function drawFlatBottomTriangle(points,x1,y1,x2,y2,x3,y3)
        local m1 = (x2 - x1) / (y2 - y1)
        local m2 = (x3 - x1) / (y3 - y1)
        local yStart = math.ceil(y1-0.5)
        local yEnd =   math.ceil(y3-0.5)-1
        for y = yStart, yEnd do
            local px1 = m1 * (y + 0.5 - y1) + x1
            local px2 = m2 * (y + 0.5 - y1) + x1
            local xStart = math.ceil(px1 - 0.5)
            local xEnd =   math.ceil(px2 - 0.5)
            for x=xStart,xEnd do
                table.insert(points,{x=x,y=y})
            end
        end
    end
    local points = {}
        if(filled)then
            if y2 < y1 then x1,y1,x2,y2 = x2,y2,x1,y1 end
            if y3 < y2 then x2,y2,x3,y3 = x3,y3,x2,y2 end
            if y2 < y2 then x1,y1,x2,y2 = x2,y2,x1,y1 end
            if y1 == y2 then
                if x2 < x1 then x1,y1,x2,y2 = x2,y2,x1,y1 end
                drawFlatTopTriangle(points,x1,y1,x2,y2,x3,y3)
            elseif y2 == y3 then
                if x3 < x2 then x3,y3,x2,y2 = x2,y2,x3,y3 end
                drawFlatBottomTriangle(points,x1,y1,x2,y2,x3,y3)
            else 
                local alphaSplit = (y2-y1)/(y3-y1)
                local x = x1 + ((x3 - x1) * alphaSplit)     
                local y = y1 + ((y3 - y1) * alphaSplit)
                if x2 < x then
                    drawFlatBottomTriangle(points,x1,y1,x2,y2,x, y)
                    drawFlatTopTriangle(points,x2,y2,x,y,x3,y3)
                else
                    drawFlatBottomTriangle(points,x1,y1,x,y,x1,y1)
                    drawFlatTopTriangle(points,x,y,x2,y2,x3,y3)
                end
            end
        else
            points = line(x1,y1,x2,y2)
            for k,v in pairs(line(x2,y2,x3,y3))do table.insert(points, v) end
            for k,v in pairs(line(x3,y3,x1,y1))do table.insert(points, v) end
        end
    return points
end,

line = line,

ellipse = function(xCenter, yCenter, radius1, radius2, filled)
    return ellipse(xCenter, yCenter, radius1, radius2, filled)
end
}