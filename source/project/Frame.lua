local function Frame(name, parent)
    -- Frame
    local base = Object(name)
    local objectType = "Frame"
    local objects = {}
    local objZIndex = {}
    local object = {}
    local termObject = parentTerminal

    local monSide = ""
    local isMonitor = false
    local monitorAttached = false
    local dragOffset = 0

    base:setZIndex(10)

    local drawHelper = basaltDrawHelper(termObject)

    local cursorBlink = false
    local xCursor = 1
    local yCursor = 1
    local cursorColor = colors.white

    local xOffset, yOffset = 0, 0

    if (parent ~= nil) then
        base.parent = parent
        base.width, base.height = parent:getSize()
        base.bgColor = theme.FrameBG
        base.fgColor = theme.FrameFG
    else
        base.width, base.height = termObject.getSize()
        base.bgColor = theme.basaltBG
        base.fgColor = theme.basaltFG
    end

    local function getObject(name)
        for _, value in pairs(objects) do
            for _, b in pairs(value) do
                if (b.name == name) then
                    return value
                end
            end
        end
    end

    local function addObject(obj)
        local zIndex = obj:getZIndex()
        if (getObject(obj.name) ~= nil) then
            return nil
        end
        if (objects[zIndex] == nil) then
            for x = 1, #objZIndex + 1 do
                if (objZIndex[x] ~= nil) then
                    if (zIndex == objZIndex[x]) then
                        break
                    end
                    if (zIndex > objZIndex[x]) then
                        table.insert(objZIndex, x, zIndex)
                        break
                    end
                else
                    table.insert(objZIndex, zIndex)
                end
            end
            if (#objZIndex <= 0) then
                table.insert(objZIndex, zIndex)
            end
            objects[zIndex] = {}
        end
        obj.parent = object
        table.insert(objects[zIndex], obj)
        return obj
    end

    local function removeObject(obj)
        for a, b in pairs(objects) do
            for key, value in pairs(b) do
                if (value == obj) then
                    table.remove(objects[a], key)
                    return true;
                end
            end
        end
        return false
    end

    object = {
        barActive = false,
        barBackground = colors.gray,
        barTextcolor = colors.black,
        barText = "New Frame",
        barTextAlign = "left",
        isMoveable = false,

        getType = function(self)
            return objectType
        end;

        setFocusedObject = function(self, obj)
            if (focusedObject ~= nil) then
                focusedObject:loseFocusHandler()
                focusedObject = nil
            end
            if(obj~=nil)then
                focusedObject = obj
                obj:getFocusHandler()
            end
            return self
        end;

        setOffset = function(self, xO, yO)
            xOffset = xO ~= nil and math.floor(xO < 0 and math.abs(xO) or -xO) or xOffset
            yOffset = yO ~= nil and math.floor(yO < 0 and math.abs(yO) or -yO) or yOffset
            return self
        end;

        getFrameOffset = function(self) -- internal
            return xOffset, yOffset
        end;

        removeFocusedObject = function(self)
            if (focusedObject ~= nil) then
                focusedObject:loseFocusHandler()
            end
            focusedObject = nil
            return self
        end;

        getFocusedObject = function(self)
            return focusedObject
        end;

        setCursor = function(self, _blink, _xCursor, _yCursor, color)
            if(self.parent~=nil)then
                local obx, oby = self:getAnchorPosition()
                self.parent:setCursor(_blink or false, (_xCursor or 0)+obx-1, (_yCursor or 0)+oby-1, color or cursorColor)
            else
                local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
                cursorBlink = _blink or false
                if (_xCursor ~= nil) then
                    xCursor = obx + _xCursor - 1
                end
                if (_yCursor ~= nil) then
                    yCursor = oby + _yCursor - 1
                end
                cursorColor = color or cursorColor
                self:setVisualChanged()
            end
            return self
        end;

        setMoveable = function(self, moveable)
            self.isMoveable = moveable or not self.isMoveable
            self:setVisualChanged()
            return self;
        end;

        show = function(self)
            base.show(self)
            if(self.parent==nil)then
                activeFrame = self;
                if(isMonitor)then
                    monFrames[monSide] = self;
                else
                    mainFrame = self;
                end
            end
            return self;
        end;

        hide = function (self)
            base.hide(self)
            if(self.parent==nil)then
                if(activeFrame == self)then activeFrame = nil end
                if(isMonitor)then
                    if(monFrames[monSide] == self)then
                        monFrames[monSide] = nil;
                    end
                else
                    if(mainFrame == self)then
                        mainFrame = nil;
                    end
                end
            end
            return self
        end;
        

        showBar = function(self, showIt)
            self.barActive = showIt or not self.barActive
            self:setVisualChanged()
            return self
        end;

        setBar = function(self, text, bgCol, fgCol)
            self.barText = text or ""
            self.barBackground = bgCol or self.barBackground
            self.barTextcolor = fgCol or self.barTextcolor
            self:setVisualChanged()
            return self
        end;

        setBarTextAlign = function(self, align)
            self.barTextAlign = align or "left"
            self:setVisualChanged()
            return self
        end;

        setMonitor = function(self, side)
            if(side~=nil)or(side~=false)then
                if(peripheral.getType(side)=="monitor")then
                    termObject = peripheral.wrap(side)
                    monitorAttached = true
                end
                isMonitor = true
            else
                termObject = parentTerminal
                isMonitor = false
                if(monFrames[monSide]==self)then
                    monFrames[monSide] = nil
                end
            end
            drawHelper = basaltDrawHelper(termObject)
            monSide = side or nil
            return self;
        end;

        getVisualChanged = function(self)
            local changed = base.getVisualChanged(self)
            for _, index in pairs(objZIndex) do
                if (objects[index] ~= nil) then
                    for _, value in pairs(objects[index]) do
                        if (value.getVisualChanged ~= nil and value:getVisualChanged()) then
                            changed = true
                        end
                    end
                end
            end
            return changed
        end;

        loseFocusHandler = function(self)
            base.loseFocusHandler(self)
        end;

        getFocusHandler = function(self)
            base.getFocusHandler(self)
            if (self.parent ~= nil) then
                self.parent:removeObject(self)
                self.parent:addObject(self)
            end
        end;

        keyHandler = function(self, event, key)
            if (focusedObject ~= nil) then
                if(focusedObject~=self)then
                    if (focusedObject.keyHandler ~= nil) then
                        if (focusedObject:keyHandler(event, key)) then
                            return true
                        end
                    end
                else
                    base.keyHandler(self, event, key)
                end
            end
            return false
        end;

        backgroundKeyHandler = function(self, event, key)
            base.backgroundKeyHandler(self, event, key)
            for _, index in pairs(objZIndex) do
                if (objects[index] ~= nil) then
                    for _, value in pairs(objects[index]) do
                        if (value.backgroundKeyHandler ~= nil) then
                            value:backgroundKeyHandler(event, key)
                        end
                    end
                end
            end
        end;

        eventHandler = function(self, event, p1, p2, p3, p4)
            base.eventHandler(self, event, p1, p2, p3, p4)
            for _, index in pairs(objZIndex) do
                if (objects[index] ~= nil) then
                    for _, value in pairs(objects[index]) do
                        if (value.eventHandler ~= nil) then
                            value:eventHandler(event, p1, p2, p3, p4)
                        end
                    end
                end
            end
            if(isMonitor)then
                if(event == "peripheral")and(p1==monSide)then
                    if(peripheral.getType(monSide)=="monitor")then
                        monitorAttached = true
                        termObject = peripheral.wrap(monSide)
                        drawHelper = basaltDrawHelper(termObject)
                    end
                end
                if(event == "peripheral_detach")and(p1==monSide)then
                    monitorAttached = false
                end
            end
            if (event == "terminate") then
                termObject.clear()
                termObject.setCursorPos(1, 1)
                basalt.stop()
            end
        end;

        mouseHandler = function(self, event, button, x, y)
            local xO, yO = self:getOffset()
            xO = xO < 0 and math.abs(xO) or -xO
            yO = yO < 0 and math.abs(yO) or -yO
            if (self.drag) then
                if (event == "mouse_drag") then
                    local parentX = 1;
                    local parentY = 1
                    if (self.parent ~= nil) then
                        parentX, parentY = self.parent:getAbsolutePosition(self.parent:getAnchorPosition())
                    end
                    self:setPosition(x + dragOffset - (parentX - 1) + xO, y - (parentY - 1) + yO)
                end
                if (event == "mouse_up") then
                    self.drag = false
                end
                return true
            end

            if (base.mouseHandler(self, event, button, x, y)) then
                local fx, fy = self:getAbsolutePosition(self:getAnchorPosition())
                fx = fx + xOffset;fy = fy + yOffset;
                    for _, index in pairs(objZIndex) do
                        if (objects[index] ~= nil) then
                            for _, value in rpairs(objects[index]) do
                                if (value.mouseHandler ~= nil) then
                                    if (value:mouseHandler(event, button, x, y)) then
                                        return true
                                    end
                                end
                            end
                        end
                    end

                if (self.isMoveable) then
                    if (x >= fx) and (x <= fx + self.width - 1) and (y == fy) and (event == "mouse_click") then
                        self.drag = true
                        dragOffset = fx - x
                    end
                end
                if (focusedObject ~= nil) then
                    focusedObject:loseFocusHandler()
                    focusedObject = nil
                end
                return true
            end
            return false
        end;

        setText = function(self, x, y, text)
            local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
            if (y >= 1) and (y <= self.height) then
                if (self.parent ~= nil) then
                    local parentX, parentY = self.parent:getAnchorPosition()
                    self.parent:setText(math.max(x + (obx - 1), obx) - (parentX - 1), oby + y - 1 - (parentY - 1), sub(text, math.max(1 - x + 1, 1), self.width - x + 1))
                else
                    drawHelper.setText(math.max(x + (obx - 1), obx), oby + y - 1, sub(text, math.max(1 - x + 1, 1), self.width - x + 1))
                end
            end
        end;

        setBG = function(self, x, y, bgCol)
            local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
            if (y >= 1) and (y <= self.height) then
                if (self.parent ~= nil) then
                    local parentX, parentY = self.parent:getAnchorPosition()
                    self.parent:setBG(math.max(x + (obx - 1), obx) - (parentX - 1), oby + y - 1 - (parentY - 1), sub(bgCol, math.max(1 - x + 1, 1), self.width - x + 1))
                else
                    drawHelper.setBG(math.max(x + (obx - 1), obx), oby + y - 1, sub(bgCol, math.max(1 - x + 1, 1), self.width - x + 1))
                end
            end
        end;

        setFG = function(self, x, y, fgCol)
            local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
            if (y >= 1) and (y <= self.height) then
                if (self.parent ~= nil) then
                    local parentX, parentY = self.parent:getAnchorPosition()
                    self.parent:setFG(math.max(x + (obx - 1), obx) - (parentX - 1), oby + y - 1 - (parentY - 1), sub(fgCol, math.max(1 - x + 1, 1), self.width - x + 1))
                else
                    drawHelper.setFG(math.max(x + (obx - 1), obx), oby + y - 1, sub(fgCol, math.max(1 - x + 1, 1), self.width - x + 1))
                end
            end
        end;

        writeText = function(self, x, y, text, bgCol, fgCol)
            local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
            if (y >= 1) and (y <= self.height) then
                if (self.parent ~= nil) then
                    local parentX, parentY = self.parent:getAnchorPosition()
                    self.parent:writeText(math.max(x + (obx - 1), obx) - (parentX - 1), oby + y - 1 - (parentY - 1), sub(text, math.max(1 - x + 1, 1), self.width - x + 1), bgCol, fgCol)
                else
                    drawHelper.writeText(math.max(x + (obx - 1), obx), oby + y - 1, sub(text, math.max(1 - x + 1, 1), self.width - x + 1), bgCol, fgCol)
                end
            end
        end;

        drawBackgroundBox = function(self, x, y, width, height, bgCol)
            local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
            height = (y < 1 and (height + y > self.height and self.height or height + y - 1) or (height + y > self.height and self.height - y + 1 or height))
            width = (x < 1 and (width + x > self.width and self.width or width + x - 1) or (width + x > self.width and self.width - x + 1 or width))
            if (self.parent ~= nil) then
                local parentX, parentY = self.parent:getAnchorPosition()
                self.parent:drawBackgroundBox(math.max(x + (obx - 1), obx) - (parentX - 1), math.max(y + (oby - 1), oby) - (parentY - 1), width, height, bgCol)
            else
                drawHelper.drawBackgroundBox(math.max(x + (obx - 1), obx), math.max(y + (oby - 1), oby), width, height, bgCol)
            end
        end;

        drawTextBox = function(self, x, y, width, height, symbol)
            local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
            height = (y < 1 and (height + y > self.height and self.height or height + y - 1) or (height + y > self.height and self.height - y + 1 or height))
            width = (x < 1 and (width + x > self.width and self.width or width + x - 1) or (width + x > self.width and self.width - x + 1 or width))
            if (self.parent ~= nil) then
                local parentX, parentY = self.parent:getAnchorPosition()
                self.parent:drawTextBox(math.max(x + (obx - 1), obx) - (parentX - 1), math.max(y + (oby - 1), oby) - (parentY - 1), width, height, symbol:sub(1, 1))
            else
                drawHelper.drawTextBox(math.max(x + (obx - 1), obx), math.max(y + (oby - 1), oby), width, height, symbol:sub(1, 1))
            end
        end;

        drawForegroundBox = function(self, x, y, width, height, fgCol)
            local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
            height = (y < 1 and (height + y > self.height and self.height or height + y - 1) or (height + y > self.height and self.height - y + 1 or height))
            width = (x < 1 and (width + x > self.width and self.width or width + x - 1) or (width + x > self.width and self.width - x + 1 or width))
            if (self.parent ~= nil) then
                local parentX, parentY = self.parent:getAnchorPosition()
                self.parent:drawForegroundBox(math.max(x + (obx - 1), obx) - (parentX - 1), math.max(y + (oby - 1), oby) - (parentY - 1), width, height, fgCol)
            else
                drawHelper.drawForegroundBox(math.max(x + (obx - 1), obx), math.max(y + (oby - 1), oby), width, height, fgCol)
            end
        end;

        draw = function(self)
            if(isMonitor)and not(monitorAttached)then return false end;
            if (self:getVisualChanged()) then
                if (base.draw(self)) then
                    local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
                    local anchx, anchy = self:getAnchorPosition()
                    if (self.parent ~= nil) then
                        self.parent:drawBackgroundBox(anchx, anchy, self.width, self.height, self.bgColor)
                        self.parent:drawForegroundBox(anchx, anchy, self.width, self.height, self.fgColor)
                        self.parent:drawTextBox(anchx, anchy, self.width, self.height, " ")
                    else
                        drawHelper.drawBackgroundBox(obx, oby, self.width, self.height, self.bgColor)
                        drawHelper.drawForegroundBox(obx, oby, self.width, self.height, self.fgColor)
                        drawHelper.drawTextBox(obx, oby, self.width, self.height, " ")
                    end
                    termObject.setCursorBlink(false)
                    if (self.barActive) then
                        if (self.parent ~= nil) then
                            self.parent:writeText(anchx, anchy, getTextHorizontalAlign(self.barText, self.width, self.barTextAlign), self.barBackground, self.barTextcolor)
                        else
                            drawHelper.writeText(obx, oby, getTextHorizontalAlign(self.barText, self.width, self.barTextAlign), self.barBackground, self.barTextcolor)
                        end
                    end

                    for _, index in rpairs(objZIndex) do
                        if (objects[index] ~= nil) then
                            for _, value in pairs(objects[index]) do
                                if (value.draw ~= nil) then
                                    value:draw()
                                end
                            end
                        end
                    end

                    if (cursorBlink) then
                        termObject.setTextColor(cursorColor)
                        termObject.setCursorPos(xCursor, yCursor)
                        if (self.parent ~= nil) then
                            termObject.setCursorBlink(self:isFocused())
                        else
                            termObject.setCursorBlink(cursorBlink)
                        end
                    end
                    self:setVisualChanged(false)
                end
            end
        end;

        drawUpdate = function(self)
            if(isMonitor)and not(monitorAttached)then return false end;
            drawHelper.update()
        end;

        addObject = function(self, obj)
            return addObject(obj)
        end;

        removeObject = function(self, obj)
            return removeObject(obj)
        end;

        getObject = function(self, obj)
            return getObject(obj)
        end;

        addButton = function(self, name)
            local obj = Button(name)
            obj.name = name
            return addObject(obj)
        end;

        addLabel = function(self, name)
            local obj = Label(name)
            obj.bgColor = self.bgColor
            obj.fgColor = self.fgColor
            return addObject(obj)
        end;

        addCheckbox = function(self, name)
            local obj = Checkbox(name)
            return addObject(obj)
        end;

        addInput = function(self, name)
            local obj = Input(name)
            return addObject(obj)
        end;

        addProgram = function(self, name)
            local obj = Program(name)
            return addObject(obj)
        end;

        addTextfield = function(self, name)
            local obj = Textfield(name)
            return addObject(obj)
        end;

        addList = function(self, name)
            local obj = List(name)
            obj.name = nam
            return addObject(obj)
        end;

        addDropdown = function(self, name)
            local obj = Dropdown(name)
            return addObject(obj)
        end;

        addRadio = function(self, name)
            local obj = Radio(name)
            return addObject(obj)
        end;

        addTimer = function(self, name)
            local obj = Timer(name)
            return addObject(obj)
        end;

        addAnimation = function(self, name)
            local obj = Animation(name)
            return addObject(obj)
        end;

        addSlider = function(self, name)
            local obj = Slider(name)
            return addObject(obj)
        end;

        addScrollbar = function(self, name)
            local obj = Scrollbar(name)
            return addObject(obj)
        end;

        addMenubar = function(self, name)
            local obj = Menubar(name)
            return addObject(obj)
        end;

        addThread = function(self, name)
            local obj = Thread(name)
            return addObject(obj)
        end;

        addPane = function(self, name)
            local obj = Pane(name)
            return addObject(obj)
        end;

        addImage = function(self, name)
            local obj = Image(name)
            return addObject(obj)
        end;

        addProgressbar = function(self, name)
            local obj = Progressbar(name)
            return addObject(obj)
        end;

        addSwitch = function(self, name)
            local obj = Switch(name)
            return addObject(obj)
        end;

        addFrame = function(self, name)
            local obj = Frame(name, self)
            return addObject(obj)
        end;
    }
    setmetatable(object, base)
    return object
end