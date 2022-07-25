local basaltEvent = require("basaltEvent")
local utils = require("utils")
local split = utils.splitString
local numberFromString = utils.numberFromString
local xmlValue = utils.getValueFromXML

return function(name)
    -- Base object
    local objectType = "Object" -- not changeable
    local object = {}
    local zIndex = 1
    local value
    local anchor = "topLeft"
    local ignOffset = false
    local isVisible = true

    local shadow = false
    local borderLeft = false
    local borderTop = false
    local borderRight = false
    local borderBottom = false

    local shadowColor = colors.black
    local borderColor = colors.black
    local isEnabled = true
    local isDragging = false
    local dragStartX, dragStartY, dragXOffset, dragYOffset = 0, 0, 0, 0

    local visualsChanged = true

    local eventSystem = basaltEvent()

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

        enable = function(self)
            isEnabled = true
            return self
        end;

        disable = function(self)
            isEnabled = false
            return self
        end;

        generateXMLEventFunction = function(self, func, val)
            local createF = function(str)
                if(str:sub(1,1)=="#")then
                    local o = self:getBaseFrame():getDeepObject(str:sub(2,str:len()))
                    if(o~=nil)and(o.internalObjetCall~=nil)then
                        func(self,function()o:internalObjetCall()end)
                    end
                else
                    func(self,self:getBaseFrame():getVariable(str))
                end
            end
            if(type(val)=="string")then
                createF(val)
            elseif(type(val)=="table")then
                for k,v in pairs(val)do
                    createF(v)
                end
            end
            return self
        end,

        setValuesByXMLData = function(self, data)
            local baseFrame = self:getBaseFrame()
            if(xmlValue("x", data)~=nil)then self:setPosition(xmlValue("x", data), self.y) end
            if(xmlValue("y", data)~=nil)then self:setPosition(self.x, xmlValue("y", data)) end
            if(xmlValue("width", data)~=nil)then self:setSize(xmlValue("width", data), self.height) end
            if(xmlValue("height", data)~=nil)then self:setSize(self.width, xmlValue("height", data)) end
            if(xmlValue("bg", data)~=nil)then self:setBackground(colors[xmlValue("bg", data)]) end
            if(xmlValue("fg", data)~=nil)then self:setForeground(colors[xmlValue("fg", data)]) end
            if(xmlValue("value", data)~=nil)then self:setValue(colors[xmlValue("value", data)]) end
            if(xmlValue("visible", data)~=nil)then if(xmlValue("visible", data))then self:show() else self:hide() end end
            if(xmlValue("enabled", data)~=nil)then if(xmlValue("enabled", data))then self:enable() else self:disable() end end
            if(xmlValue("zIndex", data)~=nil)then self:setZIndex(xmlValue("zIndex", data)) end
            if(xmlValue("anchor", data)~=nil)then self:setAnchor(xmlValue("anchor", data)) end
            if(xmlValue("shadow", data)~=nil)then if(xmlValue("shadow", data))then self:showShadow(true) end end
            if(xmlValue("shadowColor", data)~=nil)then self:setShadow(colors[xmlValue("shadowColor", data)]) end
            if(xmlValue("border", data)~=nil)then if(xmlValue("border", data))then borderLeft,borderTop,borderRight,borderBottom = true,true,true,true end end
            if(xmlValue("borderLeft", data)~=nil)then if(xmlValue("borderLeft", data))then borderLeft = true else borderLeft = false end end
            if(xmlValue("borderTop", data)~=nil)then if(xmlValue("borderTop", data))then borderTop = true else borderTop = false end end
            if(xmlValue("borderRight", data)~=nil)then if(xmlValue("borderRight", data))then borderRight = true else borderRight = false end end
            if(xmlValue("borderBottom", data)~=nil)then if(xmlValue("borderBottom", data))then borderBottom = true else borderBottom = false end end
            if(xmlValue("borderColor", data)~=nil)then self:setBorder(colors[xmlValue("borderColor", data)]) end
            if(xmlValue("ignoreOffset", data)~=nil)then if(xmlValue("ignoreOffset", data))then self:ignoreOffset(true) end end
            if(xmlValue("onClick", data)~=nil)then self:generateXMLEventFunction(self.onClick, xmlValue("onClick", data)) end
            if(xmlValue("onClickUp", data)~=nil)then self:generateXMLEventFunction(self.onClickUp, xmlValue("onClickUp", data)) end
            if(xmlValue("onScroll", data)~=nil)then self:generateXMLEventFunction(self.onScroll, xmlValue("onScroll", data)) end
            if(xmlValue("onDrag", data)~=nil)then self:generateXMLEventFunction(self.onDrag, xmlValue("onDrag", data)) end
            if(xmlValue("onKey", data)~=nil)then self:generateXMLEventFunction(self.onKey, xmlValue("onKey", data)) end
            if(xmlValue("onKeyUp", data)~=nil)then self:generateXMLEventFunction(self.onKeyUp, xmlValue("onKeyUp", data)) end
            if(xmlValue("onChange", data)~=nil)then self:generateXMLEventFunction(self.onChange, xmlValue("onChange", data)) end
            if(xmlValue("onResize", data)~=nil)then self:generateXMLEventFunction(self.onResize, xmlValue("onResize", data)) end
            if(xmlValue("onReposition", data)~=nil)then self:generateXMLEventFunction(self.onReposition, xmlValue("onReposition", data)) end
            if(xmlValue("onEvent", data)~=nil)then self:generateXMLEventFunction(self.onEvent, xmlValue("onEvent", data)) end
            if(xmlValue("onGetFocus", data)~=nil)then self:generateXMLEventFunction(self.onGetFocus, xmlValue("onGetFocus", data)) end
            if(xmlValue("onLoseFocus", data)~=nil)then self:generateXMLEventFunction(self.onLoseFocus, xmlValue("onLoseFocus", data)) end
            if(xmlValue("onBackgroundKey", data)~=nil)then self:generateXMLEventFunction(self.onBackgroundKey, xmlValue("onBackgroundKey", data)) end
            if(xmlValue("onBackgroundKeyUp", data)~=nil)then self:generateXMLEventFunction(self.onBackgroundKeyUp, xmlValue("onBackgroundKeyUp", data)) end
            
            return self
        end,

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

        getObjectReferencesForDynVal = function(self, str)
            
        end,

        setPosition = function(self, xPos, yPos, rel)
            if(type(xPos)=="number")then
                self.x = rel and self:getX()+xPos or xPos
            end
            if(type(yPos)=="number")then
                self.y = rel and self:getY()+yPos or yPos
            end
            if(self.parent~=nil)then
                if(type(xPos)=="string")then
                    self.x = self.parent:newDynamicValue(self, xPos)
                end
                if(type(yPos)=="string")then
                    self.y = self.parent:newDynamicValue(self, yPos)
                end
                self.parent:recalculateDynamicValues()
            end
            eventSystem:sendEvent("basalt_reposition", self)
            visualsChanged = true
            return self
        end;

        getX = function(self)
            return type(self.x) == "number" and self.x or math.floor(self.x[1]+0.5)
        end;

        getY = function(self)
            return type(self.y) == "number" and self.y or math.floor(self.y[1]+0.5)
        end;

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
            if(self.parent~=nil)then
                if(type(width)=="string")then
                    self.width = self.parent:newDynamicValue(self, width)
                end
                if(type(height)=="string")then
                    self.height = self.parent:newDynamicValue(self, height)
                end
                self.parent:recalculateDynamicValues()
            end
            eventSystem:sendEvent("basalt_resize", self)
            visualsChanged = true
            return self
        end;

        getHeight = function(self)
            return type(self.height) == "number" and self.height or math.floor(self.height[1]+0.5)
        end;

        getWidth = function(self)
            return type(self.width) == "number" and self.width or math.floor(self.width[1]+0.5)
        end;

        getSize = function(self)
            return self:getWidth(), self:getHeight()
        end;

        calculateDynamicValues = function(self)
            if(type(self.width)=="table")then self.width:calculate() end
            if(type(self.height)=="table")then self.height:calculate() end
            if(type(self.x)=="table")then self.x:calculate() end
            if(type(self.y)=="table")then self.y:calculate() end
            return self
        end,

        setBackground = function(self, color)
            self.bgColor = color or false
            visualsChanged = true
            return self
        end;

        getBackground = function(self)
            return self.bgColor
        end;

        setForeground = function(self, color)
            self.fgColor = color or false
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
            borderColor = color
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
                local fx, fy = self.parent:getAbsolutePosition()
                x = fx + x - 1
                y = fy + y - 1
            end
            return x, y
        end;

        getAnchorPosition = function(self, x, y, ignOff)
            if (x == nil) then
                x = self:getX()
            end
            if (y == nil) then
                y = self:getY()
            end
            if(self.parent~=nil)then
            local pw,ph = self.parent:getSize()
                if (anchor == "top") then
                    x = math.floor(pw/2) + x - 1
                elseif(anchor == "topRight") then
                    x = pw + x - 1
                elseif(anchor == "right") then
                    x = pw + x - 1
                    y = math.floor(ph/2) + y - 1
                elseif(anchor == "bottomRight") then
                    x = pw + x - 1
                    y = ph + y - 1
                elseif(anchor == "bottom") then
                    x = math.floor(pw/2) + x - 1
                    y = ph + y - 1
                elseif(anchor == "bottomLeft") then
                    y = ph + y - 1
                elseif(anchor == "left") then
                    y = math.floor(ph/2) + y - 1
                elseif(anchor == "center") then
                    x = math.floor(pw/2) + x - 1
                    y = math.floor(ph/2) + y - 1
                end

                local xO, yO = self.parent:getOffsetInternal()
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
            if(isEnabled)then
                for _,v in pairs(table.pack(...))do
                    if(type(v)=="function")then
                        self:registerEvent("mouse_drag", v)
                    end
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

        onReposition = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("basalt_reposition", v)
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
            if(isEnabled)and(isVisible)then
                local objX, objY = self:getAbsolutePosition(self:getAnchorPosition())
                local w, h = self:getSize()
                local yOff = false
                
                if(objY-1 == y)and(self:getBorder("top"))then
                    y = y+1
                    yOff = true
                end
                if(event=="mouse_up")then
                    isDragging = false
                end

                if(isDragging)and(event=="mouse_drag")then 
                    local xO, yO, parentX, parentY = 0, 0, 1, 1
                    if (self.parent ~= nil) then
                        xO, yO = self.parent:getOffsetInternal()
                        xO = xO < 0 and math.abs(xO) or -xO
                        yO = yO < 0 and math.abs(yO) or -yO
                        parentX, parentY = self.parent:getAbsolutePosition(self.parent:getAnchorPosition())
                    end
                    local dX, dY = x + dragXOffset - (parentX - 1) + xO, y + dragYOffset - (parentY - 1) + yO
                    local val = eventSystem:sendEvent(event, self, event, button, dX, dY, dragStartX, dragStartY, x, y)
                end 


                if (objX <= x) and (objX + w > x) and (objY <= y) and (objY + h > y) then
                    if(event=="mouse_click")then 
                        isDragging = true 
                        dragStartX, dragStartY = x, y 
                        dragXOffset, dragYOffset = objX - x, objY - y
                    end
                    if(event~="mouse_drag")then
                        if(event~="mouse_up")then
                            if (self.parent ~= nil) then
                                self.parent:setFocusedObject(self)
                            end
                        end
                        local val = eventSystem:sendEvent(event, self, event, button, x, y)
                        if(val~=nil)then return val end
                    end
                    return true
                end
            end
            return false
        end;

        keyHandler = function(self, event, key)
            if(isEnabled)then
                if (self:isFocused()) then
                    local val = eventSystem:sendEvent(event, self, event, key)
                    if(val~=nil)then return val end
                    return true
                end
            end
            return false
        end;

        backgroundKeyHandler = function(self, event, key)
                if(isEnabled)then
                local val = eventSystem:sendEvent("background_"..event, self, event, key)
                if(val~=nil)then return val end
            end
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