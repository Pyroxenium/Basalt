local Object = require("Object")
local _OBJECTS = require("loadObjects")

local BasaltDraw = require("basaltDraw")
local utils = require("utils")
local layout = require("layout")
local uuid = utils.uuid
local rpairs = utils.rpairs
local xmlValue = utils.getValueFromXML

local sub,min,max = string.sub,math.min,math.max

return function(name, parent, pTerm, basalt)
    -- Frame
    local base = Object(name)
    local objectType = "Frame"
    local objects = {}
    local objZIndex = {}
    local object = {}
    local variables = {}
    local theme = {}
    local termObject = pTerm or term.current()

    local monSide = ""
    local isMonitor = false
    local monitorAttached = false
    local dragXOffset = 0
    local dragYOffset = 0
    local isScrollable = false
    local minScroll = 0
    local maxScroll = 10
    local mirrorActive = false
    local mirrorAttached = false
    local mirrorSide = ""
    local importantScroll = false

    base:setZIndex(10)

    local basaltDraw = BasaltDraw(termObject)

    local cursorBlink = false
    local xCursor = 1
    local yCursor = 1
    local cursorColor = colors.white

    local xOffset, yOffset = 0, 0

    local lastXMLReferences = {}

    local function xmlDefaultValues(data, obj)
        if(obj~=nil)then
            obj:setValuesByXMLData(data)
        end
    end

    local function addXMLObjectType(tab, f, self)
        if(tab~=nil)then
            if(tab.properties~=nil)then tab = {tab} end

            for k,v in pairs(tab)do
                local obj = f(self, v["@id"] or uuid())
                table.insert(lastXMLReferences, obj)
                xmlDefaultValues(v, obj)
            end
        end
    end

    local function duplicateTerm(term1, term2)
        local both = {}
        setmetatable(both, {
            __index = function(_, k)
                if (type(term1[k]) == "function") then
                    return function(...)
                        pcall(term1[k], ...)
                        return term2[k](...)
                    end
                else
                    return term1[k]
                end
            end,
            __call = function(_, f, ...)
                pcall(term2[f], ...)
                return term1[f](...)
            end,
            __newindex = function(_, k, v)
                term1[k] = v
                term2[k] = v
            end
        })
        return both
    end

    if (parent ~= nil) then
        base.parent = parent
        base.width, base.height = parent:getSize()
        base.bgColor = parent:getTheme("FrameBG")
        base.fgColor = parent:getTheme("FrameText")
        print(parent:getTheme("FrameBG"))
    else
        base.width, base.height = termObject.getSize()
        base.bgColor = basalt.getTheme("BasaltBG")
        base.fgColor = basalt.getTheme("BasaltText")
    end

    local function getObject(name)
        for _, value in pairs(objects) do
            for _, b in pairs(value) do
                if (b:getName() == name) then
                    return b
                end
            end
        end
    end
    local function getDeepObject(name)
        local o = getObject(name)
        if(o~=nil)then return o end
        for _, value in pairs(objects) do
            for _, b in pairs(value) do
                if (b:getType() == "Frame") then
                    local oF = b:getDeepObject(name)
                    if(oF~=nil)then return oF end
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
        if(obj.init~=nil)then
            obj:init()
        end
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
            if (basalt.getFocusedObject() ~= nil) then
                basalt.getFocusedObject():loseFocusHandler()
                basalt.setFocusedObject(nil)
            end
            if(obj~=nil)then
                basalt.setFocusedObject(obj)
                obj:getFocusHandler()
            end
            return self
        end;

        getVariable = function(self, name)
            return basalt.getVariable(name)
        end,

        setSize = function(self, w, h, rel)
            base.setSize(self, w, h, rel)
            for _, index in pairs(objZIndex) do
                if (objects[index] ~= nil) then
                    for _, value in pairs(objects[index]) do
                        if (value.eventHandler ~= nil) then
                            value:sendEvent("basalt_resize", value, self)
                        end
                    end
                end
            end
            return self
        end;

        setTheme = function(self, _theme)
            theme = _theme
            return self
        end,

        getTheme = function(self, name)
            return theme[name] or (self.parent~=nil and self.parent:getTheme(name) or basalt.getTheme(name))
        end,

        setPosition = function(self, x, y, rel)
            base.setPosition(self, x, y, rel)
            for _, index in pairs(objZIndex) do
                if (objects[index] ~= nil) then
                    for _, value in pairs(objects[index]) do
                        if (value.eventHandler ~= nil) then
                            value:sendEvent("basalt_reposition", value, self)
                        end
                    end
                end
            end
            return self
        end;

        getBasaltInstance = function(self)
            return basalt
        end,

        setOffset = function(self, xO, yO)
            xOffset = xO ~= nil and math.floor(xO < 0 and math.abs(xO) or -xO) or xOffset
            yOffset = yO ~= nil and math.floor(yO < 0 and math.abs(yO) or -yO) or yOffset
            return self
        end;

        getOffset = function(self) -- internal
            return xOffset, yOffset
        end;

        removeFocusedObject = function(self)
            if (basalt.getFocusedObject() ~= nil) then
                basalt.getFocusedObject():loseFocusHandler()
            end
            basalt.setFocusedObject(nil)
            return self
        end;

        getFocusedObject = function(self)
            return basalt.getFocusedObject()
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

        setScrollable = function(self, scrollable)
            isScrollable = scrollable and true or false
            return self
        end,

        setImportantScroll = function(self, imp)
            importantScroll = imp and true or false
            return self
        end,

        setMaxScroll = function(self, max)
            maxScroll = max or maxScroll
            return self
        end,

        setMinScroll = function(self, min)
            minScroll = min or minScroll
            return self
        end,

        show = function(self)
            base.show(self)
            if(self.parent==nil)then
                basalt.setActiveFrame(self)
                if(isMonitor)then
                    basalt.setMonitorFrame(monSide, self)
                else
                    basalt.setMainFrame(self)
                end
            end
            return self;
        end;

        hide = function (self)
            base.hide(self)
            if(self.parent==nil)then
                if(activeFrame == self)then activeFrame = nil end
                if(isMonitor)then
                    if(basalt.getMonitorFrame(monSide) == self)then
                        basalt.setActiveFrame(nil)
                    end
                else
                    if(basalt.getMainFrame() == self)then
                        basalt.setMainFrame(nil)
                    end
                end
            end
            return self
        end;

        addLayout = function(self, file)
            if(file~=nil)then
                if(fs.exists(file))then
                    local f = fs.open(file, "r")
                    local data = layout:ParseXmlText(f.readAll())
                    f.close()
                    lastXMLReferences = {}
                    self:setValuesByXMLData(data)
                end
            end
            return self
        end,

        getLastLayout = function(self)
            return lastXMLReferences
        end,

        addLayoutFromString = function(self, str)
            if(str~=nil)then
                local data = layout:ParseXmlText(str)
                self:setValuesByXMLData(data)
            end
            return self
        end,
        
        setValuesByXMLData = function(self, data)
            base.setValuesByXMLData(self, data)

            if(xmlValue("moveable", data)~=nil)then if(xmlValue("moveable", data))then self:setMoveable(true) end end
            if(xmlValue("scrollable", data)~=nil)then if(xmlValue("scrollable", data))then self:setScrollable(true) end end
            if(xmlValue("monitor", data)~=nil)then self:setMonitor(xmlValue("monitor", data)):show() end
            if(xmlValue("mirror", data)~=nil)then self:setMirror(xmlValue("mirror", data)) end
            if(xmlValue("bar", data)~=nil)then if(xmlValue("bar", data))then self:showBar(true) else self:showBar(false) end end
            if(xmlValue("barText", data)~=nil)then self.barText = xmlValue("barText", data) end
            if(xmlValue("barBG", data)~=nil)then self.barBackground = colors[xmlValue("barBG", data)] end
            if(xmlValue("barFG", data)~=nil)then self.barTextcolor = colors[xmlValue("barFG", data)] end
            if(xmlValue("barAlign", data)~=nil)then self.barTextAlign = xmlValue("barAlign", data) end
            if(xmlValue("layout", data)~=nil)then self:addLayout(xmlValue("layout", data)) end
            if(xmlValue("xOffset", data)~=nil)then self:setOffset(xmlValue("xOffset", data), yOffset) end
            if(xmlValue("yOffset", data)~=nil)then self:setOffset(yOffset, xmlValue("yOffset", data)) end
            if(xmlValue("maxScroll", data)~=nil)then self:setMaxScroll(xmlValue("maxScroll", data)) end
            if(xmlValue("minScroll", data)~=nil)then self:setMaxScroll(xmlValue("minScroll", data)) end
            if(xmlValue("importantScroll", data)~=nil)then self:setImportantScroll(xmlValue("importantScroll", data)) end


            for k,v in pairs(_OBJECTS)do
                if(k~="Animation")then
                    addXMLObjectType(data[string.lower(k)], self["add"..k], self)
                end
            end
            addXMLObjectType(data["animation"], self.addAnimation, self)
            addXMLObjectType(data["frame"], self.addFrame, self)
            return self
        end,

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

        setMirror = function(self, side)
            mirrorSide = side
            if(mirror~=nil)then
                basaltDraw.setMirror(mirror)
            end
            mirrorActive = true
            return self
        end,

        removeMirror = function(self)
            mirror = nil
            mirrorActive = false
            basaltDraw.setMirror(nil)
            return self
        end,

        setMonitor = function(self, side)
            if(side~=nil)and(side~=false)then
                if(peripheral.getType(side)=="monitor")then
                    termObject = peripheral.wrap(side)
                    monitorAttached = true
                end
                if(self.parent~=nil)then
                    self.parent:removeObject(self)
                end
                isMonitor = true
            else
                termObject = parentTerminal
                isMonitor = false
                if(basalt.getMonitorFrame(monSide)==self)then
                    basalt.setMonitorFrame(monSide, nil)
                end
            end
            basaltDraw = BasaltDraw(termObject)
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
            local focusedObject = basalt.getFocusedObject()
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
                        basaltDraw = BasaltDraw(termObject)
                    end
                end
                if(event == "peripheral_detach")and(p1==monSide)then
                    monitorAttached = false
                end
            end
            if(mirrorActive)then
                if(peripheral.getType(mirrorSide)=="monitor")then
                    mirrorAttached = true
                    basaltDraw.setMirror(peripheral.wrap(mirrorSide))
                end
                if(event == "peripheral_detach")and(p1==mirrorSide)then
                    monitorAttached = false
                end
                if(event=="monitor_touch")then
                    self:mouseHandler(event, p1, p2, p3, p4)
                end
            end
            if (event == "terminate") then
                termObject.setCursorPos(1, 1)
                termObject.clear()
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
                    self:setPosition(x + dragXOffset - (parentX - 1) + xO, y + dragYOffset - (parentY - 1) + yO)
                end
                if (event == "mouse_up") then
                    self.drag = false
                end
                return true
            end

            local objX, objY = self:getAbsolutePosition(self:getAnchorPosition())
            local yOff = false
            if(objY-1 == y)and(self:getBorder("top"))then
                y = y+1
                yOff = true
            end

            if (base.mouseHandler(self, event, button, x, y)) then
                local fx, fy = self:getAbsolutePosition(self:getAnchorPosition())
                fx = fx + xOffset;fy = fy + yOffset;
                if(isScrollable)and(importantScroll)then
                    if(event=="mouse_scroll")then
                        if(button>0)or(button<0)then
                            yOffset = max(min(yOffset-button, -minScroll),-maxScroll)
                        end
                    end
                end
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
                        local fx, fy = self:getAbsolutePosition(self:getAnchorPosition())
                        if (x >= fx) and (x <= fx + self:getWidth() - 1) and (y == fy) and (event == "mouse_click") then
                            self.drag = true
                            dragXOffset = fx - x
                            dragYOffset = yOff and 1 or 0
                        end
                    end
                    if(isScrollable)and(not importantScroll)then
                        if(event=="mouse_scroll")then
                            if(button>0)or(button<0)then
                                yOffset = max(min(yOffset-button, -minScroll),-maxScroll)
                            end
                        end
                    end
                if (basalt.getFocusedObject() ~= nil) then
                    basalt.getFocusedObject():loseFocusHandler()
                    basalt.setFocusedObject(nil)
                end
                return true
            end
            return false
        end;

        setText = function(self, x, y, text)
            local obx, oby = self:getAnchorPosition()
            if (y >= 1) and (y <= self:getHeight()) then
                if (self.parent ~= nil) then
                    self.parent:setText(max(x + (obx - 1), obx), oby + y - 1, sub(text, max(1 - x + 1, 1), max(self:getWidth() - x + 1,1)))
                else
                    basaltDraw.setText(max(x + (obx - 1), obx), oby + y - 1, sub(text, max(1 - x + 1, 1), max(self:getWidth() - x + 1,1)))
                end
            end
        end;

        setBG = function(self, x, y, bgCol)
            local obx, oby = self:getAnchorPosition()
            if (y >= 1) and (y <= self:getHeight()) then
                if (self.parent ~= nil) then
                    self.parent:setBG(max(x + (obx - 1), obx), oby + y - 1, sub(bgCol, max(1 - x + 1, 1), max(self:getWidth() - x + 1,1)))
                else
                    basaltDraw.setBG(max(x + (obx - 1), obx), oby + y - 1, sub(bgCol, max(1 - x + 1, 1), max(self:getWidth() - x + 1,1)))
                end
            end
        end;

        setFG = function(self, x, y, fgCol)
            local obx, oby = self:getAnchorPosition()
            if (y >= 1) and (y <= self:getHeight()) then
                if (self.parent ~= nil) then
                    self.parent:setFG(max(x + (obx - 1), obx), oby + y - 1, sub(fgCol, max(1 - x + 1, 1), max(self:getWidth() - x + 1,1)))
                else
                    basaltDraw.setFG(max(x + (obx - 1), obx), oby + y - 1, sub(fgCol, max(1 - x + 1, 1), max(self:getWidth() - x + 1,1)))
                end
            end
        end;

        writeText = function(self, x, y, text, bgCol, fgCol)
            local obx, oby = self:getAnchorPosition()
            if (y >= 1) and (y <= self:getHeight()) then
                if (self.parent ~= nil) then
                    self.parent:writeText(max(x + (obx - 1), obx), oby + y - 1, sub(text, max(1 - x + 1, 1), self:getWidth() - x + 1), bgCol, fgCol)
                else
                    basaltDraw.writeText(max(x + (obx - 1), obx), oby + y - 1, sub(text, max(1 - x + 1, 1), max(self:getWidth() - x + 1,1)), bgCol, fgCol)
                end
            end
        end;

        drawBackgroundBox = function(self, x, y, width, height, bgCol)
            local obx, oby = self:getAnchorPosition()
            
            height = (y < 1 and (height + y > self:getHeight() and self:getHeight() or height + y - 1) or (height + y > self:getHeight() and self:getHeight() - y + 1 or height))
            width = (x < 1 and (width + x > self:getWidth() and self:getWidth() or width + x - 1) or (width + x > self:getWidth() and self:getWidth() - x + 1 or width))
            if (self.parent ~= nil) then
                self.parent:drawBackgroundBox(max(x + (obx - 1), obx), max(y + (oby - 1), oby), width, height, bgCol)
            else
                basaltDraw.drawBackgroundBox(max(x + (obx - 1), obx), max(y + (oby - 1), oby), width, height, bgCol)
            end
        end;

        drawTextBox = function(self, x, y, width, height, symbol)
            local obx, oby = self:getAnchorPosition()
            height = (y < 1 and (height + y > self:getHeight() and self:getHeight() or height + y - 1) or (height + y > self:getHeight() and self:getHeight() - y + 1 or height))
            width = (x < 1 and (width + x > self:getWidth() and self:getWidth() or width + x - 1) or (width + x > self:getWidth() and self:getWidth() - x + 1 or width))
            if (self.parent ~= nil) then
                self.parent:drawTextBox(max(x + (obx - 1), obx), max(y + (oby - 1), oby), width, height, sub(symbol,1,1))
            else
                basaltDraw.drawTextBox(max(x + (obx - 1), obx), max(y + (oby - 1), oby), width, height, sub(symbol,1,1))
            end
        end;

        drawForegroundBox = function(self, x, y, width, height, fgCol)
            local obx, oby = self:getAnchorPosition()
            height = (y < 1 and (height + y > self:getHeight() and self:getHeight() or height + y - 1) or (height + y > self:getHeight() and self:getHeight() - y + 1 or height))
            width = (x < 1 and (width + x > self:getWidth() and self:getWidth() or width + x - 1) or (width + x > self:getWidth() and self:getWidth() - x + 1 or width))
            if (self.parent ~= nil) then
                self.parent:drawForegroundBox(max(x + (obx - 1), obx), max(y + (oby - 1), oby), width, height, fgCol)
            else
                basaltDraw.drawForegroundBox(max(x + (obx - 1), obx), max(y + (oby - 1), oby), width, height, fgCol)
            end
        end;

        draw = function(self)
            if(isMonitor)and not(monitorAttached)then return false end;
            if (self:getVisualChanged()) then
                if (base.draw(self)) then
                    local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
                    local anchx, anchy = self:getAnchorPosition()
                    local w,h = self:getSize()
                    if (self.parent ~= nil) then
                        if(self.bgColor~=false)then
                            self.parent:drawBackgroundBox(anchx, anchy, w, h, self.bgColor)
                            self.parent:drawTextBox(anchx, anchy, w, h, " ")
                        end
                        if(self.bgColor~=false)then self.parent:drawForegroundBox(anchx, anchy, w, h, self.fgColor) end
                    else
                        if(self.bgColor~=false)then
                            basaltDraw.drawBackgroundBox(anchx, anchy, w, h, self.bgColor)
                            basaltDraw.drawTextBox(anchx, anchy, w, h, " ")
                        end
                        if(self.fgColor~=false)then basaltDraw.drawForegroundBox(anchx, anchy, w, h, self.fgColor) end
                    end
                    termObject.setCursorBlink(false)
                    if (self.barActive) then
                        if (self.parent ~= nil) then
                            self.parent:writeText(anchx, anchy, utils.getTextHorizontalAlign(self.barText, w, self.barTextAlign), self.barBackground, self.barTextcolor)
                        else
                            basaltDraw.writeText(anchx, anchy, utils.getTextHorizontalAlign(self.barText, w, self.barTextAlign), self.barBackground, self.barTextcolor)
                        end
                        if(self:getBorder("left"))then
                            if (self.parent ~= nil) then
                                self.parent:drawBackgroundBox(anchx-1, anchy, 1, 1, self.barBackground)
                                if(self.bgColor~=false)then
                                    self.parent:drawBackgroundBox(anchx-1, anchy+1, 1, h-1, self.bgColor)
                                end
                            end
                        end
                        if(self:getBorder("top"))then
                            if (self.parent ~= nil) then
                                self.parent:drawBackgroundBox(anchx-1, anchy-1, w+1, 1, self.barBackground)
                            end
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
            basaltDraw.update()
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
        getDeepObject = function(self, name)
            return getDeepObject(name)
        end,

        addFrame = function(self, name)
            local obj = basalt.newFrame(name, self, nil, basalt)
            return addObject(obj)
        end;
    }
    for k,v in pairs(_OBJECTS)do
        object["add"..k] = function(self, name)
            return addObject(v(name or uuid(), self))
        end
    end
    setmetatable(object, base)
    return object
end