local function Frame(name, parent)
    -- Frame
    local base = Object(name)
    local objectType = "Frame"
    local objects = {}
    local objZIndex = {}
    local object = {}
    local focusedObject
    local termObject = parentTerminal

    local monitors = {}
    local isMonitor = false

    base:setZIndex(10)

    local drawHelper = basaltDrawHelper(termObject)

    local cursorBlink = false
    local xCursor = 1
    local yCursor = 1
    local cursorColor = colors.white

    local xOffset, yOffset = 0, 0

    if (parent ~= nil) then
        base.parent = parent
        base.width, base.height = parent.w, parent.h
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
            for _, index in pairs(objZIndex) do
                for _, value in pairs(objects[index]) do
                    if (value == obj) then
                        if (focusedObject ~= nil) then
                            focusedObject:loseFocusHandler()
                        end
                        focusedObject = obj
                        focusedObject:getFocusHandler()
                    end
                end
            end
            return self
        end;

        setOffset = function(self, xO, yO)
            xOffset = xO ~= nil and math.floor(xO < 0 and math.abs(xO) or -xO) or xOffset
            yOffset = yO ~= nil and math.floor(yO < 0 and math.abs(yO) or -yO) or yOffset
            return self
        end;

        getFrameOffset = function(self)
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

        show = function(self)
            base:show()
            if (self.parent == nil)and not(isMonitor) then
                activeFrame = self
            end
            return self
        end;

        setCursor = function(self, _blink, _xCursor, _yCursor, color)
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
            return self
        end;

        setMoveable = function(self, moveable)
            self.isMoveable = moveable or not self.isMoveable
            self:setVisualChanged()
            return self;
        end;


        addMonitor = function(self, mon)
            local screen = peripheral.wrap(mon)
            monitors[mon] = {monitor=mon, frame=basalt.createFrame(self:getName().."_monitor_"..mon)}
            monitors[mon].frame:setDisplay(screen):setFrameAsMonitor()
            monitors[mon].frame:setSize(screen:getSize())
            return monitors[mon].frame
        end;

        setMonitorScale = function(self, scale, fullSize) -- 1,2,3,4,5,6,7,8,9,10
            if(isMonitor)then
                termObject.setTextScale(scale*0.5)
                if(fullSize)then
                    self:setSize(termObject:getSize())
                end
            end
            return self, isMonitor
        end;

        setFrameAsMonitor = function(self, isMon)
            isMonitor = isMon or true
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

        setDisplay = function(self, drawTerm)
            termObject = drawTerm
            drawHelper = basaltDrawHelper(termObject)
            return self
        end;

        getDisplay = function(self)
            return termObject
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
                if (focusedObject.keyHandler ~= nil) then
                    if (focusedObject:keyHandler(event, key)) then
                        return true
                    end
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
            if (event == "terminate") then
                termObject.clear()
                termObject.setCursorPos(1, 1)
                basalt.stop()
            end
        end;

        mouseClickHandler = function(self, event, button, x, y)
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
                    self:setPosition(x + self.xToRem - (parentX - 1) + xO, y - (parentY - 1) + yO)
                end
                if (event == "mouse_up") then
                    self.drag = false
                end
                return true
            end

            if (base.mouseClickHandler(self, event, button, x, y)) then
                local fx, fy = self:getAbsolutePosition(self:getAnchorPosition())
                if(event~="monitor_touch") or (isMonitor)then
                    for _, index in pairs(objZIndex) do
                        if (objects[index] ~= nil) then
                            for _, value in rpairs(objects[index]) do
                                if (value.mouseClickHandler ~= nil) then
                                    if (value:mouseClickHandler(event, button, x + xO, y + yO)) then
                                        return true
                                    end
                                end
                            end
                        end
                    end
                elseif not(isMonitor)then
                    for _,v in pairs(monitors)do
                        if(button==v.monitor)then
                            v.frame:mouseClickHandler(event, button, x, y)
                        end
                    end
                end

                if (self.isMoveable) then
                    if (x >= fx) and (x <= fx + self.width - 1) and (y == fy) and (event == "mouse_click") then
                        self.drag = true
                        self.xToRem = fx - x
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
                    self.parent:setText(math.max(x + (obx - 1), obx) - (self.parent.x - 1), oby + y - 1 - (self.parent.y - 1), sub(text, math.max(1 - x + 1, 1), self.width - x + 1))
                else
                    drawHelper.setText(math.max(x + (obx - 1), obx), oby + y - 1, sub(text, math.max(1 - x + 1, 1), self.width - x + 1))
                end
            end
        end;

        setBG = function(self, x, y, bgCol)
            local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
            if (y >= 1) and (y <= self.height) then
                if (self.parent ~= nil) then
                    self.parent:setBG(math.max(x + (obx - 1), obx) - (self.parent.x - 1), oby + y - 1 - (self.parent.y - 1), sub(bgCol, math.max(1 - x + 1, 1), self.width - x + 1))
                else
                    drawHelper.setBG(math.max(x + (obx - 1), obx), oby + y - 1, sub(bgCol, math.max(1 - x + 1, 1), self.width - x + 1))
                end
            end
        end;

        setFG = function(self, x, y, fgCol)
            local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
            if (y >= 1) and (y <= self.height) then
                if (self.parent ~= nil) then
                    self.parent:setFG(math.max(x + (obx - 1), obx) - (self.parent.x - 1), oby + y - 1 - (self.parent.y - 1), sub(fgCol, math.max(1 - x + 1, 1), self.width - x + 1))
                else
                    drawHelper.setFG(math.max(x + (obx - 1), obx), oby + y - 1, sub(fgCol, math.max(1 - x + 1, 1), self.width - x + 1))
                end
            end
        end;

        writeText = function(self, x, y, text, bgCol, fgCol)
            local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
            if (y >= 1) and (y <= self.height) then
                if (self.parent ~= nil) then
                    self.parent:writeText(math.max(x + (obx - 1), obx) - (self.parent.x - 1), oby + y - 1 - (self.parent.y - 1), sub(text, math.max(1 - x + 1, 1), self.width - x + 1), bgCol, fgCol)
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
                self.parent:drawBackgroundBox(math.max(x + (obx - 1), obx) - (self.parent.x - 1), math.max(y + (oby - 1), oby) - (self.parent.y - 1), width, height, bgCol)
            else
                drawHelper.drawBackgroundBox(math.max(x + (obx - 1), obx), math.max(y + (oby - 1), oby), width, height, bgCol)
            end
        end;

        drawTextBox = function(self, x, y, width, height, symbol)
            local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
            height = (y < 1 and (height + y > self.height and self.height or height + y - 1) or (height + y > self.height and self.height - y + 1 or height))
            width = (x < 1 and (width + x > self.width and self.width or width + x - 1) or (width + x > self.width and self.width - x + 1 or width))
            if (self.parent ~= nil) then
                self.parent:drawTextBox(math.max(x + (obx - 1), obx) - (self.parent.x - 1), math.max(y + (oby - 1), oby) - (self.parent.y - 1), width, height, symbol:sub(1, 1))
            else
                drawHelper.drawTextBox(math.max(x + (obx - 1), obx), math.max(y + (oby - 1), oby), width, height, symbol:sub(1, 1))
            end
        end;

        drawForegroundBox = function(self, x, y, width, height, fgCol)
            local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
            height = (y < 1 and (height + y > self.height and self.height or height + y - 1) or (height + y > self.height and self.height - y + 1 or height))
            width = (x < 1 and (width + x > self.width and self.width or width + x - 1) or (width + x > self.width and self.width - x + 1 or width))
            if (self.parent ~= nil) then
                self.parent:drawForegroundBox(math.max(x + (obx - 1), obx) - (self.parent.x - 1), math.max(y + (oby - 1), oby) - (self.parent.y - 1), width, height, fgCol)
            else
                drawHelper.drawForegroundBox(math.max(x + (obx - 1), obx), math.max(y + (oby - 1), oby), width, height, fgCol)
            end
        end;

        draw = function(self)
            if (self:getVisualChanged()) then
                if (base.draw(self)) then
                    for _,v in pairs(monitors)do
                        v.frame:draw()
                    end
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
                    parentTerminal.setCursorBlink(false)
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
                drawHelper.update()
            end
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
            obj.name = name
            obj.bgColor = self.bgColor
            obj.fgColor = self.fgColor
            return addObject(obj)
        end;

        addCheckbox = function(self, name)
            local obj = Checkbox(name)
            obj.name = name
            return addObject(obj)
        end;

        addInput = function(self, name)
            local obj = Input(name)
            obj.name = name
            return addObject(obj)
        end;

        addProgram = function(self, name)
            local obj = Program(name)
            obj.name = name
            return addObject(obj)
        end;

        addTextfield = function(self, name)
            local obj = Textfield(name)
            obj.name = name
            return addObject(obj)
        end;

        addList = function(self, name)
            local obj = List(name)
            obj.name = name
            return addObject(obj)
        end;

        addDropdown = function(self, name)
            local obj = Dropdown(name)
            obj.name = name
            return addObject(obj)
        end;

        addRadio = function(self, name)
            local obj = Radio(name)
            obj.name = name
            return addObject(obj)
        end;

        addTimer = function(self, name)
            local obj = Timer(name)
            obj.name = name
            return addObject(obj)
        end;

        addAnimation = function(self, name)
            local obj = Animation(name)
            obj.name = name
            return addObject(obj)
        end;

        addSlider = function(self, name)
            local obj = Slider(name)
            obj.name = name
            return addObject(obj)
        end;

        addScrollbar = function(self, name)
            local obj = Scrollbar(name)
            obj.name = name
            return addObject(obj)
        end;

        addMenubar = function(self, name)
            local obj = Menubar(name)
            obj.name = name
            return addObject(obj)
        end;

        addThread = function(self, name)
            local obj = Thread(name)
            obj.name = name
            return addObject(obj)
        end;

        addPane = function(self, name)
            local obj = Pane(name)
            obj.name = name
            return addObject(obj)
        end;

        addImage = function(self, name)
            local obj = Image(name)
            obj.name = name
            return addObject(obj)
        end;

        addProgressbar = function(self, name)
            local obj = Progressbar(name)
            obj.name = name
            return addObject(obj)
        end;

        addFrame = function(self, name)
            local obj = Frame(name, self)
            obj.name = name
            return addObject(obj)
        end;
    }
    setmetatable(object, base)
    if (parent == nil) then
        table.insert(frames, object)
    end
    return object
end