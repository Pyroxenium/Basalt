local max,min,sub,rep = math.max,math.min,string.sub,string.rep

return function(name, basalt)
    local base = basalt.getObject("Frame")(name, basalt)
    local objectType = "MovableFrame"
    local parent

    local dragXOffset, dragYOffset = 0, 0

    local dragMap = {
        {x1 = 1, x2 = "width", y1 = 1, y2 = 1}
    }

    local object = {    
        getType = function()
            return objectType
        end,

        setDraggingMap = function(self, t)
            dragMap = t
            return self
        end,

        getDraggingMap = function(self)
            return dragMap
        end,

        isType = function(self, t)
            return objectType==t or (base.isType~=nil and base.isType(t)) or false
        end,

        getBase = function(self)
            return base
        end, 
        
        load = function(self)
            base.load(self)
            self:listenEvent("mouse_click")
            self:listenEvent("mouse_up")
            self:listenEvent("mouse_drag")
        end,

        dragHandler = function(self, btn, x, y)
            if(base.dragHandler(self, btn, x, y))then
                if (isDragging) then
                    local xO, yO = parent:getOffset()
                    xO = xO < 0 and math.abs(xO) or -xO
                    yO = yO < 0 and math.abs(yO) or -yO
                    local parentX = 1
                    local parentY = 1
                    parentX, parentY = parent:getAbsolutePosition()
                    self:setPosition(x + dragXOffset - (parentX - 1) + xO, y + dragYOffset - (parentY - 1) + yO)
                    self:updateDraw()
                end
                return true
            end
        end,

        mouseHandler = function(self, btn, x, y, ...)
            if(base.mouseHandler(self, btn, x, y, ...))then
                parent:setImportant(self)
                local fx, fy = self:getAbsolutePosition()
                local w, h = self:getSize()
                for k,v in pairs(dragMap)do
                    local x1, x2 = v.x1=="width" and w or v.x1, v.x2=="width" and w or v.x2
                    local y1, y2= v.y1=="height" and h or v.y1, v.y2=="height" and h or v.y2
                    if(x>=fx+x1-1)and(x<=fx+x2-1)and(y>=fy+y1-1)and(y<=fy+y2-1)then
                        isDragging = true
                        dragXOffset = fx - x
                        dragYOffset = fy - y
                        return true
                    end
                end
                return true
            end
        end,

        mouseUpHandler = function(self, ...)
            isDragging = false
            return base.mouseUpHandler(self, ...)
        end,

        setParent = function(self, p, ...)
            base.setParent(self, p, ...)
            parent = p
            return self
        end,
    }

    object.__index = object
    return setmetatable(object, base)
end