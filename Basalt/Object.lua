local basaltEvent = require("basaltEvent")
local split = require("utils").splitString
local numberFromString = require("utils").numberFromString

return function(name)
    -- Base object
    local objectType = "Object" -- not changeable
    local object = {}
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

    local eventSystem = basaltEvent()

    local dynamicValue = {}
    local dynamicValueResult = {}

    local function replacePercentage(str, parentValue)
        local _fullStr = str
        for v in _fullStr:gmatch("%d+%%") do
            local pValue = v:gsub("%%", "")
            print(str)
            str = str:gsub(v.."%", parentValue / 100 * math.max(math.min(tonumber(pValue),100),0))
        end
        return str
    end

    local function fToNumber(str, fTable)
        for k,v in pairs(fTable)do
            if(type(v)=="function")then
                local nmb = v()
                for _ in str:gmatch("f"..k)do
                    str = string.gsub(str, "f"..k, nmb)
                end
            end
        end
        str = str:gsub("f%d+", "")
        return str
    end

    local calcDynamicValue = function(newDValue)
        local val = dynamicValue[newDValue][1]
        if(val~=nil)then
            if(type(val)=="string")then
                if(dynamicValue[newDValue][3]~=nil)then
                    dynamicValueResult[newDValue] = numberFromString(replacePercentage(fToNumber(val, dynamicValue[newDValue][3]), dynamicValue[newDValue][2]() or 1))
                else
                    dynamicValueResult[newDValue] = numberFromString(replacePercentage(val, dynamicValue[newDValue][2]() or 1))
                end
            end
        end
    end

    object = {
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


            if(type(xPos)=="number")then
                self.x = rel and self.x+xPos or xPos
            end
            if(type(yPos)=="number")then
                self.y = rel and self.y+yPos or yPos
            end
            if(type(xPos)=="string")or(type(xPos)=="table")then
                dynamicValue.x = {xPos, function() return self:getParent():getX() end}
            end
            if(type(yPos)=="string")or(type(yPos)=="table")then
                dynamicValue.y = {yPos, function() return self:getParent():getY() end}
            end
            self:recalculateDynamicValue()
            eventSystem:sendEvent("basalt_reposition", self)
            visualsChanged = true
            return self
        end;

        getX = function(self)
            return dynamicValue.x or self.x
        end,

        getY = function(self)
            return dynamicValue.y or self.y
        end,

        getPosition = function(self)
            return self:getX(), self:getY()
        end;

        getVisibility = function(self)
            return isVisible
        end;

        setVisibility = function(self, _isVisible)
            isVisible = _isVisible or not isVisible
            visualsChanged = true
            return self
        end;

        setSize = function(self, width, height, rel)
            if(type(width)=="number")then
                self.width = rel and self.width+width or width
            end
            if(type(height)=="number")then
                self.height = rel and self.height+height or height
            end
            if(type(width)=="string")then
                dynamicValue.width = {width, function() return self:getParent():getWidth() end}
            end
            if(type(width)=="table")then
                dynamicValue.width = {width[1], function() return self:getParent():getWidth() end}
                table.remove(width, 1)
                dynamicValue.width[3] = width
            end
            if(type(height)=="string")then
                dynamicValue.height = {height, function() return self:getParent():getHeight() end}
            end
            if(type(height)=="table")then
                dynamicValue.height = {height[1], function() return self:getParent():getHeight() end}
                table.remove(height, 1)
                dynamicValue.height[3] = height
            end
            self:recalculateDynamicValue()
            eventSystem:sendEvent("basalt_resize", self)
            visualsChanged = true
            return self
        end;

        getHeight = function(self)
            return dynamicValueResult["height"] or self.height
        end;

        getWidth = function(self)
            return dynamicValueResult["width"] or self.width
        end;

        getSize = function(self)
            return self:getWidth(), self:getHeight()
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
                    local w,h = self:getSize()
                    if(shadow)then                        
                        self.parent:drawBackgroundBox(x+1, y+h, w, 1, shadowColor)
                        self.parent:drawBackgroundBox(x+w, y+1, 1, h, shadowColor)
                        self.parent:drawForegroundBox(x+1, y+h, w, 1, shadowColor)
                        self.parent:drawForegroundBox(x+w, y+1, 1, h, shadowColor)
                    end
                    if(borderLeft)then
                        self.parent:drawTextBox(x-1, y, 1, h, "\149")
                        self.parent:drawForegroundBox(x-1, y, 1, h, borderColor)
                        if(self.bgColor~=false)then self.parent:drawBackgroundBox(x-1, y, 1, h, self.bgColor) end
                    end
                    if(borderLeft)and(borderTop)then
                        self.parent:drawTextBox(x-1, y-1, 1, 1, "\151")
                        self.parent:drawForegroundBox(x-1, y-1, 1, 1, borderColor)
                        if(self.bgColor~=false)then self.parent:drawBackgroundBox(x-1, y-1, 1, 1, self.bgColor) end
                    end
                    if(borderTop)then
                        self.parent:drawTextBox(x, y-1, w, 1, "\131")
                        self.parent:drawForegroundBox(x, y-1, w, 1, borderColor)
                        if(self.bgColor~=false)then self.parent:drawBackgroundBox(x, y-1, w, 1, self.bgColor) end
                    end
                    if(borderTop)and(borderRight)then
                        self.parent:drawTextBox(x+w, y-1, 1, 1, "\149")
                        self.parent:drawForegroundBox(x+w, y-1, 1, 1, borderColor)
                    end
                    if(borderRight)then
                        self.parent:drawTextBox(x+w, y, 1, h, "\149")
                        self.parent:drawForegroundBox(x+w, y, 1, h, borderColor)
                    end
                    if(borderRight)and(borderBottom)then
                        self.parent:drawTextBox(x+w, y+h, 1, 1, "\129")
                        self.parent:drawForegroundBox(x+w, y+h, 1, 1, borderColor)
                    end
                    if(borderBottom)then
                        self.parent:drawTextBox(x, y+h, w, 1, "\131")
                        self.parent:drawForegroundBox(x, y+h, w, 1, borderColor)
                    end
                    if(borderBottom)and(borderLeft)then
                        self.parent:drawTextBox(x-1, y+h, 1, 1, "\131")
                        self.parent:drawForegroundBox(x-1, y+h, 1, 1, borderColor)
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
            if(self.parent~=nil)then
                local xO, yO = self.parent:getOffset()
                if not(ignOffset or ignOff) then
                    return x+xO, y+yO
                end
            end
            return x, y
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

        recalculateDynamicValue = function(self, special)
            if(special==nil)then
                for k in pairs(dynamicValue)do
                    calcDynamicValue(k)
                end
            else
                calcDynamicValue(special)
            end
            return self
        end,

        onResize = function(self, ...)
            self:recalculateValues()
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
            local w, h = self:getSize()
            local yOff = false
            if(objY-1 == y)and(self:getBorder("top"))then
                y = y+1
                yOff = true
            end

            if (objX <= x) and (objX + w > x) and (objY <= y) and (objY + h > y) and (isVisible) then
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