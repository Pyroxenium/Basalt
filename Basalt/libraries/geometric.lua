local function filledRectangle(x1,y1,x2,y2)

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

local function elipse(xC, yC, r1, r2, filled)
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
    return elipse(xC, yC, r, r, filled)
end

return {
circle = function(x, y, radius, filled)
    return circle(x, y, radius, filled)
end,

rectangle = function(x1,y1,x2, y2, filled)
    local positions = {}
end,

elipse = function(xCenter, yCenter, radius1, radius2, filled)
    return elipse(xCenter, yCenter, radius1, radius2, filled)
end
}