local drawSystem = require("basaltDraw")
local utils = require("utils")

local max,min,sub,rep = math.max,math.min,string.sub,string.rep

return function(name, basalt)
    local base = basalt.getObject("Container")(name, basalt)
    local objectType = "BaseFrame"

    local xOffset, yOffset = 0, 0

    local colorTheme = {}

    local updateRender = true
    
    local termObject = basalt.getTerm()
    local basaltDraw = drawSystem(termObject)

    local xCursor, yCursor, cursorBlink, cursorColor = 1, 1, false, colors.white

    local object = {   
        getType = function()
            return objectType
        end,
        isType = function(self, t)
            return objectType==t or base.isType~=nil and base.isType(t) or false
        end,

        getBase = function(self)
            return base
        end,

        getOffset = function(self)
            return xOffset, yOffset
        end,

        setOffset = function(self, xOff, yOff)
            xOffset = xOff or xOffset
            yOffset = yOff or yOffset
            self:updateDraw()
            return self
        end,

        getXOffset = function(self)
            return xOffset
        end,

        setXOffset = function(self, newXOffset)
            return self:setOffset(newXOffset, nil)
        end,

        getYOffset = function(self)
            return yOffset
        end,

        setYOffset = function(self, newYOffset)
            return self:setOffset(nil, newYOffset)
        end,

        setPalette = function(self, col, ...)            
            if(self==basalt.getActiveFrame())then
                if(type(col)=="string")then
                    colorTheme[col] = ...
                    termObject.setPaletteColor(type(col)=="number" and col or colors[col], ...)
                elseif(type(col)=="table")then
                    for k,v in pairs(col)do
                        colorTheme[k] = v
                        if(type(v)=="number")then
                            termObject.setPaletteColor(type(k)=="number" and k or colors[k], v)
                        else
                            local r,g,b = table.unpack(v)
                            termObject.setPaletteColor(type(k)=="number" and k or colors[k], r,g,b)
                        end
                    end
                end
            end
            return self
        end,

        setSize = function(self, ...)
            base.setSize(self, ...)
            basaltDraw = drawSystem(termObject)
            return self
        end,

        getSize = function()
            return termObject.getSize()
        end,

        getWidth = function(self)
            return ({termObject.getSize()})[1]
        end,

        getHeight = function(self)
            return ({termObject.getSize()})[2]
        end,

        show = function(self)
            base.show(self)
            basalt.setActiveFrame(self)
            for k,v in pairs(colors)do
                if(type(v)=="number")then
                    termObject.setPaletteColor(v, colors.packRGB(term.nativePaletteColor((v))))
                end
            end
            for k,v in pairs(colorTheme)do
                if(type(v)=="number")then
                    termObject.setPaletteColor(type(k)=="number" and k or colors[k], v)
                else
                    local r,g,b = table.unpack(v)
                    termObject.setPaletteColor(type(k)=="number" and k or colors[k], r,g,b)
                end
            end
            basalt.setMainFrame(self)
            return self
        end,

        render = function(self)
            if(base.render~=nil)then
                if(self:isVisible())then
                    if(updateRender)then
                        base.render(self)
                        local children = self:getChildren()
                        for _, child in ipairs(children) do
                            if (child.element.render ~= nil) then
                                child.element:render()
                            end
                        end
                        updateRender = false
                    end
                end
            end
        end,

        updateDraw = function(self)
            updateRender = true
            return self
        end,

        eventHandler = function(self, event, ...)
            base.eventHandler(self, event, ...)
            if(event=="term_resize")then
                self:setSize(termObject.getSize())
            end
        end,

        updateTerm = function(self)
            if(basaltDraw~=nil)then
                basaltDraw.update()
            end
        end,

        setTerm = function(self, newTerm)
            termObject = newTerm
            if(newTerm==nil)then
                basaltDraw = nil
            else
                basaltDraw = drawSystem(termObject)
            end
            return self
        end,

        getTerm = function()
            return termObject
        end,

        blit = function (self, x, y, t, f, b)
            local obx, oby = self:getPosition()
            local w, h = self:getSize()
            if y >= 1 and y <= h then
                local t_visible = sub(t, max(1 - x + 1, 1), max(w - x + 1, 1))
                local f_visible = sub(f, max(1 - x + 1, 1), max(w - x + 1, 1))
                local b_visible = sub(b, max(1 - x + 1, 1), max(w - x + 1, 1))
                basaltDraw.blit(max(x + (obx - 1), obx), oby + y - 1, t_visible, f_visible, b_visible)
            end
        end,

        setCursor = function(self, _blink, _xCursor, _yCursor, color)
            local obx, oby = self:getAbsolutePosition()
            local xO, yO = self:getOffset()
            cursorBlink = _blink or false
            if (_xCursor ~= nil) then
                xCursor = obx + _xCursor - 1 - xO
            end
            if (_yCursor ~= nil) then
                yCursor = oby + _yCursor - 1 - yO
            end
            cursorColor = color or cursorColor
            if (cursorBlink) then
                termObject.setTextColor(cursorColor)
                termObject.setCursorPos(xCursor, yCursor)
                termObject.setCursorBlink(cursorBlink)
            else
                termObject.setCursorBlink(false)
            end
            return self
        end,
    }

    for k,v in pairs({mouse_click={"mouseHandler", true},mouse_up={"mouseUpHandler", false},mouse_drag={"dragHandler", false},mouse_scroll={"scrollHandler", true},mouse_hover={"hoverHandler", false}})do
        object[v[1]] = function(self, btn, x, y, ...)
            if(base[v[1]](self, btn, x, y, ...))then
                basalt.setActiveFrame(self)
            end
        end
    end

    for k,v in pairs({"drawBackgroundBox", "drawForegroundBox", "drawTextBox"})do
        object[v] = function(self, x, y, width, height, symbol)
            local obx, oby = self:getPosition()
            local w, h  = self:getSize()
            height = (y < 1 and (height + y > self:getHeight() and self:getHeight() or height + y - 1) or (height + y > self:getHeight() and self:getHeight() - y + 1 or height))
            width = (x < 1 and (width + x > self:getWidth() and self:getWidth() or width + x - 1) or (width + x > self:getWidth() and self:getWidth() - x + 1 or width))
            basaltDraw[v](max(x + (obx - 1), obx), max(y + (oby - 1), oby), width, height, symbol)
        end
    end

    for k,v in pairs({"setBG", "setFG", "setText"}) do
        object[v] = function(self, x, y, str)
            local obx, oby = self:getPosition()
            local w, h  = self:getSize()
            if (y >= 1) and (y <= h) then
                basaltDraw[v](max(x + (obx - 1), obx), oby + y - 1, sub(str, max(1 - x + 1, 1), max(w - x + 1,1)))
            end
        end
    end


    object.__index = object
    return setmetatable(object, base)
end