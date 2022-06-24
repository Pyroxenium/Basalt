local function Object(name)
    -- Base object
    local objectType = "Object" -- not changeable
    local value
    local zIndex = 1
    local anchor = "topLeft"
    local ignOffset = false
    local isVisible = false

    local shadow = false
    local borderLeft = false
    local borderTop = false
    local borderRight = false
    local borderBottom = false

    local shadowColor = colors.black
    local borderColor = colors.black

    local visualsChanged = true

    local eventSystem = BasaltEvents()

    local object = {
        x = 1,
        y = 1,
        width = 1,
        height = 1,
        bgColor = colors.black,
        fgColor = colors.white,
        name = name or "Object",
        parent = nil,

        show = function(self)
            isVisible = true
            visualsChanged = true
            return self
        end;

        hide = function(self)
            isVisible = false
            visualsChanged = true
            return self
        end;

        isVisible = function(self)
            return isVisible
        end;

        setFocus = function(self)
            if (self.parent ~= nil) then
                self.parent:setFocusedObject(self)
            end
            return self
        end;

        setZIndex = function(self, index)
            zIndex = index
            if (self.parent ~= nil) then
                self.parent:removeObject(self)
                self.parent:addObject(self)
            end
            return self
        end;

        getZIndex = function(self)
            return zIndex;
        end;

        getType = function(self)
            return objectType
        end;

        getName = function(self)
            return self.name
        end;

        remove = function(self)
            if (self.parent ~= nil) then
                self.parent:removeObject(self)
            end
            return self
        end;

        setParent = function(self, frame)
            if (frame.getType ~= nil and frame:getType() == "Frame") then
                self:remove()
                frame:addObject(self)
                if (self.draw) then
                    self:show()
                end
            end
            return self
        end;

        setValue = function(self, _value)
            if (value ~= _value) then
                value = _value
                visualsChanged = true
                self:valueChangedHandler()
            end
            return self
        end;

        getValue = function(self)
            return value
        end;

        getVisualChanged = function(self)
            return visualsChanged
        end;

        setVisualChanged = function(self, change)
            visualsChanged = change or true
            if(change == nil)then visualsChanged = true end
            return self
        end;


        getEventSystem = function(self)
            return eventSystem
        end;


        getParent = function(self)
            return self.parent
        end;

        setPosition = function(self, xPos, yPos, rel)
            if (rel) then
                self.x, self.y = math.floor(self.x + xPos), math.floor(self.y + yPos)
            else
                self.x, self.y = math.floor(xPos), math.floor(yPos)
            end
            visualsChanged = true
            return self
        end;

        getPosition = function(self)
            return self.x, self.y
        end;

        getVisibility = function(self)
            return isVisible
        end;

        setVisibility = function(self, _isVisible)
            isVisible = _isVisible or not isVisible
            visualsChanged = true
            return self
        end;

        setSize = function(self, width, height)
            self.width, self.height = width, height
            eventSystem:sendEvent("basalt_resize", self)
            visualsChanged = true
            return self
        end;

        getHeight = function(self)
            return self.height
        end;

        getWidth = function(self)
            return self.width
        end;

        getSize = function(self)
            return self.width, self.height
        end;

        setBackground = function(self, color)
            self.bgColor = color
            visualsChanged = true
            return self
        end;

        getBackground = function(self)
            return self.bgColor
        end;

        setForeground = function(self, color)
            self.fgColor = color
            visualsChanged = true
            return self
        end;

        getForeground = function(self)
            return self.fgColor
        end;

        showShadow = function(self, show)
            shadow = show or (not shadow)
            return self
        end;

        setShadow = function(self, color)
            shadowColor = color
            return self
        end;

        isShadowActive = function(self)
            return shadow;
        end;

        showBorder = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(v=="left")then
                    borderLeft = true
                end
                if(v=="top")then
                    borderTop = true
                end
                if(v=="right")then
                    borderRight = true
                end
                if(v=="bottom")then
                    borderBottom = true
                end
            end
            return self
        end;

        setBorder = function(self, color)
            shadowColor = color
            return self
        end;
        
        getBorder = function(self, side)
            if(side=="left")then
                return borderLeft;
            end
            if(side=="top")then
                return borderTop;
            end
            if(side=="right")then
                return borderRight;
            end
            if(side=="bottom")then
                return borderBottom;
            end
        end;

        draw = function(self)
            if (isVisible) then
                if(self.parent~=nil)then
                    local x, y = self:getAnchorPosition()
                    if(shadow)then                        
                        self.parent:drawBackgroundBox(x+1, y+self.height, self.width, 1, shadowColor)
                        self.parent:drawBackgroundBox(x+self.width, y+1, 1, self.height, shadowColor)
                        self.parent:drawForegroundBox(x+1, y+self.height, self.width, 1, shadowColor)
                        self.parent:drawForegroundBox(x+self.width, y+1, 1, self.height, shadowColor)
                    end
                    if(borderLeft)then
                        self.parent:drawTextBox(x-1, y, 1, self.height, "\149")
                        self.parent:drawForegroundBox(x-1, y, 1, self.height, borderColor)
                        if(self.bgColor~=false)then self.parent:drawBackgroundBox(x-1, y, 1, self.height, self.bgColor) end
                    end
                    if(borderLeft)and(borderTop)then
                        self.parent:drawTextBox(x-1, y-1, 1, 1, "\151")
                        self.parent:drawForegroundBox(x-1, y-1, 1, 1, borderColor)
                        if(self.bgColor~=false)then self.parent:drawBackgroundBox(x-1, y-1, 1, 1, self.bgColor) end
                    end
                    if(borderTop)then
                        self.parent:drawTextBox(x, y-1, self.width, 1, "\131")
                        self.parent:drawForegroundBox(x, y-1, self.width, 1, borderColor)
                        if(self.bgColor~=false)then self.parent:drawBackgroundBox(x, y-1, self.width, 1, self.bgColor) end
                    end
                    if(borderTop)and(borderRight)then
                        self.parent:drawTextBox(x+self.width, y-1, 1, 1, "\149")
                        self.parent:drawForegroundBox(x+self.width, y-1, 1, 1, borderColor)
                    end
                    if(borderRight)then
                        self.parent:drawTextBox(x+self.width, y, 1, self.height, "\149")
                        self.parent:drawForegroundBox(x+self.width, y, 1, self.height, borderColor)
                    end
                    if(borderRight)and(borderBottom)then
                        self.parent:drawTextBox(x+self.width, y+self.height, 1, 1, "\129")
                        self.parent:drawForegroundBox(x+self.width, y+self.height, 1, 1, borderColor)
                    end
                    if(borderBottom)then
                        self.parent:drawTextBox(x, y+self.height, self.width, 1, "\131")
                        self.parent:drawForegroundBox(x, y+self.height, self.width, 1, borderColor)
                    end
                    if(borderBottom)and(borderLeft)then
                        self.parent:drawTextBox(x-1, y+self.height, 1, 1, "\131")
                        self.parent:drawForegroundBox(x-1, y+self.height, 1, 1, borderColor)
                    end
                end
                return true
            end
            return false
        end;


        getAbsolutePosition = function(self, x, y)
            -- relative position to absolute position
            if (x == nil) or (y == nil) then
                x, y = self:getAnchorPosition()
            end

            if (self.parent ~= nil) then
                local fx, fy = self.parent:getAbsolutePosition(self.parent:getAnchorPosition())
                x = fx + x - 1
                y = fy + y - 1
            end
            return x, y
        end;

        getAnchorPosition = function(self, x, y, ignOff)
            if (x == nil) then
                x = self.x
            end
            if (y == nil) then
                y = self.y
            end
            if (anchor == "top") then
                x = math.floor(self.parent.width/2) + x - 1
            elseif(anchor == "topRight") then
                x = self.parent.width + x - 1
            elseif(anchor == "right") then
                x = self.parent.width + x - 1
                y = math.floor(self.parent.height/2) + y - 1
            elseif(anchor == "bottomRight") then
                x = self.parent.width + x - 1
                y = self.parent.height + y - 1
            elseif(anchor == "bottom") then
                x = math.floor(self.parent.width/2) + x - 1
                y = self.parent.height + y - 1
            elseif(anchor == "bottomLeft") then
                y = self.parent.height + y - 1
            elseif(anchor == "left") then
                y = math.floor(self.parent.height/2) + y - 1
            elseif(anchor == "center") then
                x = math.floor(self.parent.width/2) + x - 1
                y = math.floor(self.parent.height/2) + y - 1
            end
            local xO, yO = self:getOffset()
            if not(ignOffset or ignOff) then
                return x+xO, y+yO
            end
            return x, y
        end;

        getOffset = function(self)
            if (self.parent ~= nil) then
                return self.parent:getFrameOffset()
            end
            return 0, 0
        end;

        ignoreOffset = function(self, ignore)
            ignOffset = ignore
            if(ignore==nil)then ignOffset = true end
            return self
        end;

        getBaseFrame = function(self)
            if(self.parent~=nil)then
                return self.parent:getBaseFrame()
            end
            return self
        end;
        
        setAnchor = function(self, newAnchor)
            anchor = newAnchor
            visualsChanged = true
            return self
        end;

        getAnchor = function(self)
            return anchor
        end;

        onChange = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("value_changed", v)
                end
            end
            return self
        end;

        onClick = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("mouse_click", v)
                    self:registerEvent("monitor_touch", v)
                end
            end
            return self
        end;

        onClickUp = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("mouse_up", v)
                end
            end
            return self
        end;


        onScroll = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("mouse_scroll", v)
                end
            end
            return self
        end;

        onDrag = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("mouse_drag", v)
                end
            end
            return self
        end;

        onEvent = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("custom_event_handler", v)
                end
            end
            return self
        end;

        onKey = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("key", v)
                    self:registerEvent("char", v)
                end
            end
            return self
        end;

        onResize = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("basalt_resize", v)
                end
            end
            return self
        end;

        onKeyUp = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("key_up", v)
                end
            end
            return self
        end;

        onBackgroundKey = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("background_key", v)
                    self:registerEvent("background_char", v)
                end
            end
            return self
        end;

        onBackgroundKeyUp = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("background_key_up", v)
                end
            end
            return self
        end;

        isFocused = function(self)
            if (self.parent ~= nil) then
                return self.parent:getFocusedObject() == self
            end
            return false
        end;

        onGetFocus = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("get_focus", v)
                end
            end
            return self
        end;

        onLoseFocus = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("lose_focus", v)
                end
            end
            return self
        end;

        registerEvent = function(self, event, func)
            return eventSystem:registerEvent(event, func)
        end;

        removeEvent = function(self, event, index)
            return eventSystem:removeEvent(event, index)
        end;

        sendEvent = function(self, event, ...)
            return eventSystem:sendEvent(event, self, ...)
        end;

        mouseHandler = function(self, event, button, x, y)
            local objX, objY = self:getAbsolutePosition(self:getAnchorPosition())
            local yOff = false
            if(objY-1 == y)and(self:getBorder("top"))then
                y = y+1
                yOff = true
            end

            if (objX <= x) and (objX + self.width > x) and (objY <= y) and (objY + self.height > y) and (isVisible) then
                if (self.parent ~= nil) then
                    self.parent:setFocusedObject(self)
                end
                local val = eventSystem:sendEvent(event, self, event, button, x, y)
                if(val~=nil)then return val end
                return true
            end
            return false
        end;

        keyHandler = function(self, event, key)
            if (self:isFocused()) then
                local val = eventSystem:sendEvent(event, self, event, key)
                if(val~=nil)then return val end
                return true
            end
            return false
        end;

        backgroundKeyHandler = function(self, event, key)
            local val = eventSystem:sendEvent("background_"..event, self, event, key)
            if(val~=nil)then return val end
            return true
        end;

        valueChangedHandler = function(self)
            eventSystem:sendEvent("value_changed", self)
        end;

        eventHandler = function(self, event, p1, p2, p3, p4)
            eventSystem:sendEvent("custom_event_handler", self, event, p1, p2, p3, p4)
        end;

        getFocusHandler = function(self)
            local val = eventSystem:sendEvent("get_focus", self)
            if(val~=nil)then return val end
            return true
        end;

        loseFocusHandler = function(self)
            local val = eventSystem:sendEvent("lose_focus", self)
            if(val~=nil)then return val end
            return true
        end;


    }

    object.__index = object
    return object
end