local Object = require("Object")
local geometric = require("geometric")
local tHex = require("tHex")

return function(name)
    -- Graphic
    local base = Object(name)
    local objectType = "Graphic"
    base:setZIndex(2)

    local graphic = {}
    local graphicCache = {}

    local object = {
        getType = function(self)
            return objectType
        end;

        addCircle = function(self, rad, color, x, y, filled)
            table.insert(graphic, {area=geometric.circle(x or 1, y or 1, rad, filled), color=color})
            return self
        end;

        addElipse = function(self, rad,rad2, color, x, y, filled)
            table.insert(graphic, {area=geometric.elipse(x or 1, y or 1, rad, rad2, filled), color=color})
            return self
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    if(#graphic>0)then
                        local obx, oby = self:getAnchorPosition()
                        if(self.bgColor~=false)then 
                            self.parent:drawBackgroundBox(obx, oby, self.width, self.height, self.bgColor)
                        end
                        for _,v in pairs(graphic)do
                            local col = tHex[v.color]
                            for _,b in pairs(v.area)do
                                if(b.x>=1)and(b.x<=self.width)and(b.y>=1)and(b.y<=self.height)then
                                    self.parent:setBG(obx+b.x-1, oby+b.y-1, col)
                                end
                            end
                        end
                    end
                end
                self:setVisualChanged(false)
            end
        end;
    }

    return setmetatable(object, base)
end