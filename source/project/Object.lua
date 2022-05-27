local function Object(name)
    -- Base object
    local objectType = "Object" -- not changeable
    --[[
    local horizontalAnchor = "left"
    local verticalAnchor = "top"
    local ignYOffset = false
    local ignXOffset = false  ]]
    local value
    local zIndex = 1
    local hanchor = "left"
    local vanchor = "top"
    local ignOffset = false
    local isVisible = false

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

        getZIndex = function(self)
            return zIndex;
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
                self.x, self.y = self.x + xPos, self.y + yPos
            else
                self.x, self.y = xPos, yPos
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
            visualsChanged = true
            return self
        end;

        getHeight = function(self)
            return self.height
        end;

        getWidth = function(self)
            return self.w
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

        draw = function(self)
            if (isVisible) then
                return true
            end
            return false
        end;


        getAbsolutePosition = function(self, x, y)
            -- relative position to absolute position
            if (x == nil) then
                x = self.x
            end
            if (y == nil) then
                y = self.y
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
            if (hanchor == "right") then
                x = self.parent.width - x - self.width + 2
            end
            if (vanchor == "bottom") then
                y = self.parent.height - y - self.height + 2
            end
            local xO, yO = self:getOffset()
            if (ignOffset or ignOff) then
                return x, y
            end
            return x + xO, y + yO
        end;

        getOffset = function(self)
            if (self.parent ~= nil) and (ignOffset == false) then
                return self.parent:getFrameOffset()
            end
            return 0, 0
        end;

        ignoreOffset = function(self, ignore)
            ignOffset = ignore or true
            return self
        end;

        setAnchor = function(self, ...)
            for _, value in pairs(table.pack(...)) do
                if (value == "right") or (value == "left") then
                    hanchor = value
                end
                if (value == "top") or (value == "bottom") then
                    vanchor = value
                end
            end
            visualsChanged = true
            return self
        end;

        getAnchor = function(self)
            return hanchor, vanchor
        end;

        onChange = function(self, func)
            self:registerEvent("value_changed", func)
            return self
        end;

        onClick = function(self, func)
            self:registerEvent("mouse_click", func)
            return self
        end;

        onEvent = function(self, func)
            self:registerEvent("custom_event_handler", func)
            return self
        end;

        onClickUp = function(self, func)
            self:registerEvent("mouse_up", func)
            return self
        end;

        onKey = function(self, func)
            self:registerEvent("key", func)
            self:registerEvent("char", func)
            return self
        end;

        onKeyUp = function(self, func)
            self:registerEvent("key_up", func)
            return self
        end;

        onBackgroundKey = function(self, func)
            self:registerEvent("background_key", func)
            self:registerEvent("background_char", func)
            return self
        end;

        onBackgroundKeyUp = function(self, func)
            self:registerEvent("background_key_up", func)
            return self
        end;

        isFocused = function(self)
            if (self.parent ~= nil) then
                return self.parent:getFocusedObject() == self
            end
            return false
        end;

        onGetFocus = function(self, func)
            self:registerEvent("get_focus", func)
            return self
        end;

        onLoseFocus = function(self, func)
            self:registerEvent("lose_focus", func)
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

        mouseClickHandler = function(self, event, button, x, y)
            local objX, objY = self:getAbsolutePosition(self:getAnchorPosition())
            if (objX <= x) and (objX + self.width > x) and (objY <= y) and (objY + self.height > y) and (isVisible) then
                if (self.parent ~= nil) then
                    self.parent:setFocusedObject(self)
                end
                eventSystem:sendEvent(event, self, event, button, x, y)
                return true
            end
            return false
        end;

        keyHandler = function(self, event, key)
            if (self:isFocused()) then
                eventSystem:sendEvent(event, self, event, key)
                return true
            end
            return false
        end;

        backgroundKeyHandler = function(self, event, key)
            eventSystem:sendEvent("background_" .. event, self, event, key)
        end;

        valueChangedHandler = function(self)
            eventSystem:sendEvent("value_changed", self)
        end;

        eventHandler = function(self, event, p1, p2, p3, p4)
            eventSystem:sendEvent("custom_event_handler", self, event, p1, p2, p3, p4)
        end;

        getFocusHandler = function(self)
            eventSystem:sendEvent("get_focus", self)
        end;

        loseFocusHandler = function(self)
            eventSystem:sendEvent("lose_focus", self)
        end;


    }

    object.__index = object
    return object
end