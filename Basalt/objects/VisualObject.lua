local utils = require("utils")
local tHex = require("tHex")

local sub, find, insert = string.sub, string.find, table.insert

return function(name, basalt)   
    local base = basalt.getObject("Object")(name, basalt)
    -- Base object
    local objectType = "VisualObject" -- not changeable

    local isVisible,ignOffset,isHovered,isClicked,isDragging = true,false,false,false,false
    local zIndex = 1

    local x, y, width, height = 1,1,1,1
    local dragStartX, dragStartY, dragXOffset, dragYOffset = 0, 0, 0, 0

    local bgColor,fgColor, transparency = colors.black, colors.white, false
    local parent

    local preDrawQueue = {}
    local drawQueue = {}
    local postDrawQueue = {}

    local renderObject = {}

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


    local object = {
        getType = function(self)
            return objectType
        end,

        getBase = function(self)
            return base
        end,  
      
        isType = function(self, t)
            return objectType==t or base.isType~=nil and base.isType(t) or false
        end,

        getBasalt = function(self)
            return basalt
        end,

        show = function(self)
            isVisible = true
            self:updateDraw()
            return self
        end,

        hide = function(self)
            isVisible = false
            self:updateDraw()
            return self
        end,

        isVisible = function(self)
            return isVisible
        end,

        setVisible = function(self, _isVisible)
            isVisible = _isVisible or not isVisible
            self:updateDraw()
            return self
        end,

        setTransparency = function(self, _transparency)
            transparency = _transparency~= nil and _transparency or true
            self:updateDraw()
            return self
        end,

        setParent = function(self, newParent, noRemove)
            base.setParent(self, newParent, noRemove)
            parent = newParent
            return self
        end,

        setFocus = function(self)
            if (parent ~= nil) then
                parent:setFocusedObject(self)
            end
            return self
        end,

        setZIndex = function(self, index)
            zIndex = index
            if (parent ~= nil) then
                parent:updateZIndex(self, zIndex)
                self:updateDraw()
            end            
            return self
        end,

        getZIndex = function(self)
            return zIndex
        end,

        updateDraw = function(self)
            if (parent ~= nil) then
                parent:updateDraw()
            end
            return self
        end,

        setPosition = function(self, xPos, yPos, rel)
            local curX, curY
            if(type(xPos)=="number")then
                x = rel and x+xPos or xPos
            end
            if(type(yPos)=="number")then
                y = rel and y+yPos or yPos
            end
            if(parent~=nil)then parent:customEventHandler("basalt_FrameReposition", self) end
            if(self:getType()=="Container")then parent:customEventHandler("basalt_FrameReposition", self) end
            self:updateDraw()
            return self
        end,

        getX = function(self)
            return x
        end,

        getY = function(self)
            return y
        end,

        getPosition = function(self)
            return x, y
        end,

        setSize = function(self, newWidth, newHeight, rel)
            if(type(newWidth)=="number")then
                width = rel and width+newWidth or newWidth
            end
            if(type(newHeight)=="number")then
                height = rel and height+newHeight or newHeight
            end
            if(parent~=nil)then 
                parent:customEventHandler("basalt_FrameResize", self)
                if(self:getType()=="Container")then parent:customEventHandler("basalt_FrameResize", self) end
            end
            self:updateDraw()
            return self
        end,

        getHeight = function(self)
            return height
        end,

        getWidth = function(self)
            return width
        end,

        getSize = function(self)
            return width, height
        end,

        setBackground = function(self, color)
            bgColor = color
            self:updateDraw()
            return self
        end,

        getBackground = function(self)
            return bgColor
        end,

        setForeground = function(self, color)
            fgColor = color or false
            self:updateDraw()
            return self
        end,

        getForeground = function(self)
            return fgColor
        end,

        getAbsolutePosition = function(self, x, y)
            -- relative position to absolute position
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

        ignoreOffset = function(self, ignore)
            ignOffset = ignore
            if(ignore==nil)then ignOffset = true end
            return self
        end,

        isCoordsInObject = function(self, x, y)
            if(isVisible)and(self:isEnabled())then
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
                return parent:getFocusedObject() == self
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
                local val = self:sendEvent("mouse_click", self, button, x - (objX-1), y - (objY-1), x, y, isMon)
                if(val==false)then return false end
                if(parent~=nil)then
                    parent:setFocusedObject(self)
                end
                isClicked = true
                isDragging = true
                dragStartX, dragStartY = x, y 
                return true
            end
        end,

        mouseUpHandler = function(self, button, x, y)
            isDragging = false
            if(isClicked)then
                local objX, objY = self:getAbsolutePosition()
                local val = self:sendEvent("mouse_release", self, "mouse_release", button, x - (objX-1), y - (objY-1), x, y)
                isClicked = false
            end
            if(self:isCoordsInObject(x, y))then
                local objX, objY = self:getAbsolutePosition()
                local val = self:sendEvent("mouse_up", self, button, x - (objX-1), y - (objY-1), x, y)
                if(val==false)then return false end
                return true
            end
        end,

        dragHandler = function(self, button, x, y)
            if(isDragging)then 
                local objX, objY = self:getAbsolutePosition()
                local val = self:sendEvent("mouse_drag", self, button, x - (objX-1), y - (objY-1), dragStartX-x, dragStartY-y, x, y)
                dragStartX, dragStartY = x, y 
                if(val~=nil)then return val end
                if(parent~=nil)then
                    parent:setFocusedObject(self)
                end
                return true
            end

            if(self:isCoordsInObject(x, y))then
                local objX, objY = self:getAbsolutePosition()
                dragStartX, dragStartY = x, y 
                dragXOffset, dragYOffset = objX - x, objY - y
            end
        end,

        scrollHandler = function(self, dir, x, y)
            if(self:isCoordsInObject(x, y))then
                local objX, objY = self:getAbsolutePosition()
                local val = self:sendEvent("mouse_scroll", self, "mouse_scroll", dir, x - (objX-1), y - (objY-1))
                if(val==false)then return false end
                if(parent~=nil)then
                    parent:setFocusedObject(self)
                end
                return true
            end
        end,

        hoverHandler = function(self, x, y, stopped)
            if(self:isCoordsInObject(x, y))then
                local val = self:sendEvent("mouse_hover", self, "mouse_hover", x, y, stopped)
                if(val==false)then return false end
                isHovered = true
                return true
            end
            if(isHovered)then
                local val = self:sendEvent("mouse_leave", self, "mouse_leave", x, y, stopped)
                if(val==false)then return false end
                isHovered = false
            end
        end,

        keyHandler = function(self, key, isHolding)
            if(self:isEnabled())and(isVisible)then
                if (self:isFocused()) then
                local val = self:sendEvent("key", self, "key", key, isHolding)
                if(val==false)then return false end
                return true
                end
            end
        end,

        keyUpHandler = function(self, key)
            if(self:isEnabled())and(isVisible)then
                if (self:isFocused()) then
                    local val = self:sendEvent("key_up", self, "key_up", key)
                if(val==false)then return false end
                return true
                end
            end
        end,

        charHandler = function(self, char)
            if(self:isEnabled())and(isVisible)then
                if(self:isFocused())then
                local val = self:sendEvent("char", self, "char", char)
                if(val==false)then return false end
                return true
                end
            end
        end,

        eventHandler = function(self, event, ...)
            local val = self:sendEvent("other_event", self, event, ...)
            if(val~=nil)then return val end
        end,

        customEventHandler = function(self, event, ...)
            local val = self:sendEvent("custom_event", self, event, ...)
            if(val~=nil)then return val end
            return true
        end,

        getFocusHandler = function(self)
            local val = self:sendEvent("get_focus", self)
            if(val~=nil)then return val end
            return true
        end,

        loseFocusHandler = function(self)
            isDragging = false
            local val = self:sendEvent("lose_focus", self)
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
            if(parent~=nil)then
                local xO, yO = parent:getOffset()
                xPos = ignOffset and xPos or xPos - xO
                yPos = ignOffset and yPos or yPos - yO
            end
            if not(transparency)then
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

        addBG = function(self, x, y, bg, noText)
            local obj = parent or self
            local xPos,yPos = self:getPosition()
            if(parent~=nil)then
                local xO, yO = parent:getOffset()
                xPos = ignOffset and xPos or xPos - xO
                yPos = ignOffset and yPos or yPos - yO
            end
            if not(transparency)then
                obj:setBG(x+xPos-1, y+yPos-1, bg)
                return
            end
            local t = split(bg)
            for k,v in pairs(t)do
                if(v.value~="")and(v.value~=" ")then
                    if(noText~=true)then
                        obj:setText(x+v.x+xPos-2, y+yPos-1, (" "):rep(#v.value))
                        obj:setBG(x+v.x+xPos-2, y+yPos-1, v.value)
                    else
                        table.insert(renderObject, {x=x+v.x-1,y=y,bg=v.value})
                        obj:setBG(x+xPos-1, y+yPos-1, fg)
                    end
                end
            end
        end,

        addFG = function(self, x, y, fg)
            local obj = parent or self
            local xPos,yPos = self:getPosition()
            if(parent~=nil)then
                local xO, yO = parent:getOffset()
                xPos = ignOffset and xPos or xPos - xO
                yPos = ignOffset and yPos or yPos - yO
            end
            if not(transparency)then
                obj:setFG(x+xPos-1, y+yPos-1, fg)
                return
            end
            local t = split(fg)
            for k,v in pairs(t)do
                if(v.value~="")and(v.value~=" ")then
                    obj:setFG(x+v.x+xPos-2, y+yPos-1, v.value)
                end
            end
        end,

        addBlit = function(self, x, y, t, fg, bg)
            local obj = parent or self
            local xPos,yPos = self:getPosition()
            if(parent~=nil)then
                local xO, yO = parent:getOffset()
                xPos = ignOffset and xPos or xPos - xO
                yPos = ignOffset and yPos or yPos - yO
            end
            if not(transparency)then
                obj:blit(x+xPos-1, y+yPos-1, t, fg, bg)
                return
            end
            local _text = split(t, "\0")
            local _fg = split(fg)
            local _bg = split(bg)
            for k,v in pairs(_text)do
                if(v.value~="")or(v.value~="\0")then
                    obj:setText(x+v.x+xPos-2, y+yPos-1, v.value)
                end
            end
            for k,v in pairs(_bg)do
                if(v.value~="")or(v.value~=" ")then
                    obj:setBG(x+v.x+xPos-2, y+yPos-1, v.value)
                end
            end
            for k,v in pairs(_fg)do
                if(v.value~="")or(v.value~=" ")then
                    obj:setFG(x+v.x+xPos-2, y+yPos-1, v.value)
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
            if (isVisible)then
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
                if(bgColor~=false)then
                    self:addTextBox(1, 1, w, h, " ")
                    self:addBackgroundBox(1, 1, w, h, bgColor)
                end
                if(fgColor~=false)then
                    self:addForegroundBox(1, 1, w, h, fgColor)
                end
            end, 1)
        end,
    }
    object.__index = object
    return setmetatable(object, base)
end