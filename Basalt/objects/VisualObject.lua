local utils = require("utils")
local tHex = require("tHex")

local sub, find, insert = string.sub, string.find, table.insert

local function split(str, d)
    local result = {}
    if str == "" then
        return result
    end
    d = d or " "
    local start = 1
    local delim_start, delim_end = find(str, d, start)
        while delim_start do
            insert(result, {x=start, value=sub(str, start, delim_start - 1)})
            start = delim_end + 1
            delim_start, delim_end = find(str, d, start)
        end
    insert(result, {x=start, value=sub(str, start)})
    return result
end

return function(name, basalt)
    local base = basalt.getObject("Object")(name, basalt)
    base:setType("VisualObject")

    local ignOffset,isHovered,isClicked,isDragging = false,false,false,false

    local dragStartX, dragStartY = 0, 0

    local parent

    local preDrawQueue = {}
    local drawQueue = {}
    local postDrawQueue = {}

    local renderObject = {}

    base:addProperty("Visible", "boolean", true, false, function(self, val)
        self:setProperty("Enabled", val)
    end)
    base:addProperty("Transparent", "boolean", false)
    base:addProperty("Background", "color", colors.black)
    base:addProperty("BgSymbol", "char", "")
    base:addProperty("BgSymbolColor", "color", colors.red)
    base:addProperty("Foreground", "color", colors.white)
    base:addProperty("X", "number", 1, false, function(self, val)
        local y = self:getProperty("Y")
        if (parent ~= nil) then
            parent:customEventHandler("basalt_FrameReposition", self, val, y)
        end
        self:repositionHandler(val, y)
    end)
    base:addProperty("Y", "number", 1, false, function(self, val)
        local x = self:getProperty("X")
        if (parent ~= nil) then
            parent:customEventHandler("basalt_FrameReposition", self, x, val)
        end
        self:repositionHandler(x, val)
    end)
    base:addProperty("Width", "number", 1, false, function(self, val)
        local height = self:getProperty("Height")
        if (parent ~= nil) then
            parent:customEventHandler("basalt_FrameResize", self, val, height)
        end
        self:resizeHandler(val, height)
    end)
    base:addProperty("Height", "number", 1, false, function(self, val)
        local width = self:getProperty("Width")
        if (parent ~= nil) then
            parent:customEventHandler("basalt_FrameResize", self, width, val)
        end
        self:resizeHandler(width, val)
    end)
    base:addProperty("IgnoreOffset", "boolean", false, false)
    base:combineProperty("Position", "X", "Y")
    base:combineProperty("Size", "Width", "Height")

    base:setProperty("Clicked", false)
    base:setProperty("Hovered", false)
    base:setProperty("Dragging", false)
    base:setProperty("Focused", false)

    local object = {
        getBase = function(self)
            return base
        end,

        getBasalt = function(self)
            return basalt
        end,

        show = function(self)
            self:setVisible(true)
            return self
        end,

        hide = function(self)
            self:setVisible(false)
            return self
        end,

        isVisible = function(self)
            return self:getVisible()
        end,

        setParent = function(self, newParent, noRemove)
            parent = newParent
            base.setParent(self, newParent, noRemove)
            return self
        end,

        setFocus = function(self)
            if (parent ~= nil) then
                parent:setFocusedChild(self)
            end
            return self
        end,

        updateDraw = function(self)
            if (parent ~= nil) then
                parent:updateDraw()
            end
            return self
        end,

        getAbsolutePosition = function(self, x, y)
            if (x == nil) or (y == nil) then
                x, y = self:getPosition()
            end

            if (parent ~= nil) then
                local fx, fy = parent:getAbsolutePosition()
                x = fx + x - 1
                y = fy + y - 1
            end
            return x, y
        end,

        getRelativePosition = function(self, x, y)
            if (x == nil) or (y == nil) then
                x, y = 1, 1
            end

            if (parent ~= nil) then
                local xO, yO = self:getAbsolutePosition()
                x = xO - x + 1
                y = yO - y + 1
            end
            return x, y
        end,

        isCoordsInObject = function(self, x, y)
            if(self:getVisible())and(self:getEnabled())then
                if(x==nil)or(y==nil)then return false end
                local objX, objY = self:getAbsolutePosition()
                local w, h = self:getSize()
                if (objX <= x) and (objX + w > x) and (objY <= y) and (objY + h > y) then
                    return true
                end
            end
            return false
        end,

        onGetFocus = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("get_focus", v)
                end
            end
            return self
        end,

        onLoseFocus = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("lose_focus", v)
                end
            end
            return self
        end,

        isFocused = function(self)
            if (parent ~= nil) then
                return parent:getFocused() == self
            end
            return true
        end,

        resizeHandler = function(self, ...)
            if(self:isEnabled())then
                local val = self:sendEvent("basalt_resize", ...)
                if(val==false)then return false end
            end
            return true
        end,

        repositionHandler = function(self, ...)
            if(self:isEnabled())then
                local val = self:sendEvent("basalt_reposition", ...)
                if(val==false)then return false end
            end
            return true
        end,

        onResize = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("basalt_resize", v)
                end
            end
            return self
        end,

        onReposition = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("basalt_reposition", v)
                end
            end
            return self
        end,

        mouseHandler = function(self, button, x, y, isMon)
            if(self:isCoordsInObject(x, y))then
                local objX, objY = self:getAbsolutePosition()
                local val = self:sendEvent("mouse_click", button, x - (objX-1), y - (objY-1), x, y, isMon)
                if(val==false)then return false end
                if(parent~=nil)then
                    parent:setFocusedChild(self)
                end
                isClicked = true
                isDragging = true
                self:setProperty("Dragging", true)
                self:setProperty("Clicked", true)
                dragStartX, dragStartY = x, y
                return true
            end
        end,

        mouseUpHandler = function(self, button, x, y)
            isDragging = false
            if(isClicked)then
                local objX, objY = self:getAbsolutePosition()
                local val = self:sendEvent("mouse_release", button, x - (objX-1), y - (objY-1), x, y)
                isClicked = false
                self:setProperty("Clicked", false)
                self:setProperty("Dragging", false)
            end
            if(self:isCoordsInObject(x, y))then
                local objX, objY = self:getAbsolutePosition()
                local val = self:sendEvent("mouse_up", button, x - (objX-1), y - (objY-1), x, y)
                if(val==false)then return false end
                return true
            end
        end,

        dragHandler = function(self, button, x, y)
            if(isDragging)then 
                local objX, objY = self:getAbsolutePosition()
                local val = self:sendEvent("mouse_drag", button, x - (objX-1), y - (objY-1), dragStartX-x, dragStartY-y, x, y)
                dragStartX, dragStartY = x, y 
                if(val~=nil)then return val end
                if(parent~=nil)then
                    parent:setFocusedChild(self)
                end
                return true
            end

            if(self:isCoordsInObject(x, y))then
                dragStartX, dragStartY = x, y
            end
        end,

        scrollHandler = function(self, dir, x, y)
            if(self:isCoordsInObject(x, y))then
                local objX, objY = self:getAbsolutePosition()
                local val = self:sendEvent("mouse_scroll", dir, x - (objX-1), y - (objY-1))
                if(val==false)then return false end
                if(parent~=nil)then
                    parent:setFocusedChild(self)
                end
                return true
            end
        end,

        hoverHandler = function(self, x, y, stopped)
            if(self:isCoordsInObject(x, y))then
                local val = self:sendEvent("mouse_hover", x, y, stopped)
                if(val==false)then return false end
                isHovered = true
                self:setProperty("Hovered", true)
                return true
            end
            if(isHovered)then
                local val = self:sendEvent("mouse_leave", x, y, stopped)
                if(val==false)then return false end
                isHovered = false
                self:setProperty("Hovered", false)
            end
        end,

        keyHandler = function(self, key, isHolding)
            if(self:isEnabled())and(self:getVisible())then
                if (self:isFocused()) then
                local val = self:sendEvent("key", key, isHolding)
                if(val==false)then return false end
                return true
                end
            end
        end,

        keyUpHandler = function(self, key)
            if(self:isEnabled())and(self:getVisible())then
                if (self:isFocused()) then
                    local val = self:sendEvent("key_up", key)
                if(val==false)then return false end
                return true
                end
            end
        end,

        charHandler = function(self, char)
            if(self:isEnabled())and(self:getVisible())then
                if(self:isFocused())then
                local val = self:sendEvent("char", char)
                if(val==false)then return false end
                return true
                end
            end
        end,

        getFocusHandler = function(self)
            local val = self:sendEvent("get_focus")
            self:setProperty("Focused", true)
            if(val~=nil)then return val end
            return true
        end,

        loseFocusHandler = function(self)
            isDragging = false
            self:setProperty("Dragging", false)
            self:setProperty("Focused", false)
            local val = self:sendEvent("lose_focus")
            if(val~=nil)then return val end
            return true
        end,

        addDraw = function(self, name, f, pos, typ, active)
            local queue = (typ==nil or typ==1) and drawQueue or typ==2 and preDrawQueue or typ==3 and postDrawQueue
            pos = pos or #queue+1
            if(name~=nil)then
                for k,v in pairs(queue)do
                    if(v.name==name)then 
                        table.remove(queue, k)
                        break
                    end
                end
                local t = {name=name, f=f, pos=pos, active=active~=nil and active or true}
                table.insert(queue, pos, t)
            end
            self:updateDraw()
            return self
        end,

        addPreDraw = function(self, name, f, pos, typ)
            self:addDraw(name, f, pos, 2)
            return self
        end,

        addPostDraw = function(self, name, f, pos, typ)
            self:addDraw(name, f, pos, 3)
            return self
        end,

        setDrawState = function(self, name, state, typ)
            local queue = (typ==nil or typ==1) and drawQueue or typ==2 and preDrawQueue or typ==3 and postDrawQueue
            for k,v in pairs(queue)do
                if(v.name==name)then
                    v.active = state
                    break
                end
            end
            self:updateDraw()
            return self
        end,

        getDrawId = function(self, name, typ)
            local queue = typ==1 and drawQueue or typ==2 and preDrawQueue or typ==3 and postDrawQueue or drawQueue
            for k,v in pairs(queue)do
                if(v.name==name)then 
                    return k
                end
            end
        end,

        addText = function(self, x, y, text)
            local obj = self:getParent() or self
            local xPos,yPos = self:getPosition()
            local transparent = self:getTransparent()
            if(parent~=nil)then
                local xO, yO = parent:getOffset()
                xPos = ignOffset and xPos or xPos - xO
                yPos = ignOffset and yPos or yPos - yO
            end
            if not(transparent)then
                obj:setText(x+xPos-1, y+yPos-1, text)
                return
            end
            local t = split(text, "\0")
            for k,v in pairs(t)do
                if(v.value~="")and(v.value~="\0")then
                    obj:setText(x+v.x+xPos-2, y+yPos-1, v.value)
                end
            end
        end,

        addBg = function(self, x, y, bg, noText)
            local obj = parent or self
            local xPos,yPos = self:getPosition()
            local transparent = self:getTransparent()
            if(parent~=nil)then
                local xO, yO = parent:getOffset()
                xPos = ignOffset and xPos or xPos - xO
                yPos = ignOffset and yPos or yPos - yO
            end
            if not(transparent)then
                obj:setBg(x+xPos-1, y+yPos-1, bg)
                return
            end
            local t = split(bg)
            for _,v in pairs(t)do
                if(v.value~="")and(v.value~=" ")then
                    if(noText~=true)then
                        obj:setText(x+v.x+xPos-2, y+yPos-1, (" "):rep(#v.value))
                        obj:setBg(x+v.x+xPos-2, y+yPos-1, v.value)
                    else
                        table.insert(renderObject, {x=x+v.x-1,y=y,bg=v.value})
                        obj:setBg(x+xPos-1, y+yPos-1, v.value)
                    end
                end
            end
        end,

        addFg = function(self, x, y, fg)
            local obj = parent or self
            local xPos,yPos = self:getPosition()
            local transparent = self:getTransparent()
            if(parent~=nil)then
                local xO, yO = parent:getOffset()
                xPos = ignOffset and xPos or xPos - xO
                yPos = ignOffset and yPos or yPos - yO
            end
            if not(transparent)then
                obj:setFg(x+xPos-1, y+yPos-1, fg)
                return
            end
            local t = split(fg)
            for _,v in pairs(t)do
                if(v.value~="")and(v.value~=" ")then
                    obj:setFg(x+v.x+xPos-2, y+yPos-1, v.value)
                end
            end
        end,

        addBlit = function(self, x, y, t, fg, bg)
            local obj = parent or self
            local xPos,yPos = self:getPosition()
            local transparent = self:getTransparent()
            if(parent~=nil)then
                local xO, yO = parent:getOffset()
                xPos = ignOffset and xPos or xPos - xO
                yPos = ignOffset and yPos or yPos - yO
            end
            if not(transparent)then
                obj:blit(x+xPos-1, y+yPos-1, t, fg, bg)
                return
            end
            local _text = split(t, "\0")
            local _fg = split(fg)
            local _bg = split(bg)
            for _,v in pairs(_text)do
                if(v.value~="")or(v.value~="\0")then
                    obj:setText(x+v.x+xPos-2, y+yPos-1, v.value)
                end
            end
            for _,v in pairs(_bg)do
                if(v.value~="")or(v.value~=" ")then
                    obj:setBg(x+v.x+xPos-2, y+yPos-1, v.value)
                end
            end
            for _,v in pairs(_fg)do
                if(v.value~="")or(v.value~=" ")then
                    obj:setFg(x+v.x+xPos-2, y+yPos-1, v.value)
                end
            end
        end,

        addTextBox = function(self, x, y, w, h, text)
            local obj = parent or self
            local xPos,yPos = self:getPosition()
            if(parent~=nil)then
                local xO, yO = parent:getOffset()
                xPos = ignOffset and xPos or xPos - xO
                yPos = ignOffset and yPos or yPos - yO
            end
            obj:drawTextBox(x+xPos-1, y+yPos-1, w, h, text)
        end,

        addForegroundBox = function(self, x, y, w, h, col)
            local obj = parent or self
            local xPos,yPos = self:getPosition()
            if(parent~=nil)then
                local xO, yO = parent:getOffset()
                xPos = ignOffset and xPos or xPos - xO
                yPos = ignOffset and yPos or yPos - yO
            end
            obj:drawForegroundBox(x+xPos-1, y+yPos-1, w, h, col)
        end,

        addBackgroundBox = function(self, x, y, w, h, col)
            local obj = parent or self
            local xPos,yPos = self:getPosition()
            if(parent~=nil)then
                local xO, yO = parent:getOffset()
                xPos = ignOffset and xPos or xPos - xO
                yPos = ignOffset and yPos or yPos - yO
            end
            obj:drawBackgroundBox(x+xPos-1, y+yPos-1, w, h, col)
        end,

        render = function(self)
            if (self:getVisible())then
                self:redraw()
            end
        end,

        redraw = function(self)
            for k,v in pairs(preDrawQueue)do
                if (v.active)then
                    v.f(self)
                end
            end
            for k,v in pairs(drawQueue)do
                if (v.active)then
                    v.f(self)
                end
            end
            for k,v in pairs(postDrawQueue)do
                if (v.active)then
                    v.f(self)
                end
            end
            return true
        end,

        draw = function(self)
            self:addDraw("base", function()
                local w,h = self:getSize()
                local bgColor = self:getBackground()
                local bgSymbol = self:getBgSymbol()
                local bgSymbolColor = self:getBgSymbolColor()
                local fgColor = self:getForeground()
                if(bgColor~=nil)then
                    self:addTextBox(1, 1, w, h, " ")
                    self:addBackgroundBox(1, 1, w, h, bgColor)
                end
                if(bgSymbol~=nil)and(bgSymbol~="")then
                    self:addTextBox(1, 1, w, h, bgSymbol)
                    self:addForegroundBox(1, 1, w, h, bgSymbolColor)
                end
                if(fgColor~=nil)then
                    self:addForegroundBox(1, 1, w, h, fgColor)
                end
            end, 1)
        end,
    }

    object.__index = object
    return setmetatable(object, base)
end