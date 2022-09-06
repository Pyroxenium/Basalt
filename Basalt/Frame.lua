local Object = require("Object")
local _OBJECTS = require("loadObjects")
local BasaltDraw = require("basaltDraw")
local utils = require("utils")
local layout = require("layout")
local basaltMon = require("basaltMon")
local uuid = utils.uuid
local rpairs = utils.rpairs
local xmlValue = utils.getValueFromXML
local tableCount = utils.tableCount

local sub,min,max = string.sub,math.min,math.max

return function(name, parent, pTerm, basalt)
    -- Frame
    local base = Object(name)
    local objectType = "Frame"
    local objects = {}
    local objZIndex = {}
    local object = {}
    local events = {}
    local eventZIndex = {}
    local variables = {}
    local theme = {}
    local dynamicValues = {}
    local dynValueId = 0
    local termObject = pTerm or term.current()

    local monSide = ""
    local isMonitor = false
    local isGroupedMonitor = false
    local monitorAttached = false
    local dragXOffset = 0
    local dragYOffset = 0
    local isScrollable = false
    local scrollAmount = 0
    local mirrorActive = false
    local mirrorAttached = false
    local mirrorSide = ""
    local isMovable = false
    local isDragging =false

    local focusedObjectCache
    local focusedObject
    local autoSize = true
    local autoScroll = true
    local initialized = false

    local activeEvents = {}

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

    local function removeEvents(self, obj)
        for a, b in pairs(events) do
            for c, d in pairs(b) do
                for key, value in pairs(d) do
                    if (value == obj) then
                        table.remove(events[a][c], key)
                        if(self.parent~=nil)then
                            if(tableCount(events[a])<=0)then
                                self.parent:removeEvent(a, self)
                            end
                        end
                    end
                end
            end
        end
    end

    local function removeObject(self, obj)
        for a, b in pairs(objects) do
            for key, value in pairs(b) do
                if(type(obj)=="string")then
                    if (value:getName() == obj) then
                        table.remove(objects[a], key)
                        removeEvents(object, value)
                        self:updateDraw()
                        return true;
                    end
                else
                    if (value == obj) then
                        table.remove(objects[a], key)
                        removeEvents(object, value)
                        self:updateDraw()
                        return true;
                    end
                end
            end
        end
        return false
    end

    local function getEvent(self, event, name)
        for _, value in pairs(events[event]) do
            for _, b in pairs(value) do
                if (b:getName() == name) then
                    return b
                end
            end
        end
    end

    local function addEvent(self, event, obj)
        local zIndex = obj:getZIndex()
        if(events[event]==nil)then events[event] = {} end
        if(eventZIndex[event]==nil)then eventZIndex[event] = {} end
        if (getEvent(self, event, obj.name) ~= nil) then
            return nil
        end
        if(self.parent~=nil)then
            self.parent:addEvent(event, self)
        end
        activeEvents[event] = true
        if (events[event][zIndex] == nil) then
            for x = 1, #eventZIndex[event] + 1 do
                if (eventZIndex[event][x] ~= nil) then
                    if (zIndex == eventZIndex[event][x]) then
                        break
                    end
                    if (zIndex > eventZIndex[event][x]) then
                        table.insert(eventZIndex[event], x, zIndex)
                        break
                    end
                else
                    table.insert(eventZIndex[event], zIndex)
                end
            end
            if (#eventZIndex[event] <= 0) then
                table.insert(eventZIndex[event], zIndex)
            end
            events[event][zIndex] = {}
        end
        table.insert(events[event][zIndex], obj)
        return obj
    end

    local function removeEvent(self, event, obj)
        if(events[event]~=nil)then
            for a, b in pairs(events[event]) do
                for key, value in pairs(b) do
                    if (value == obj) then
                        table.remove(events[event][a], key)
                        if(#events[event][a]<=0)then
                            events[event][a] = nil
                            if(self.parent~=nil)then
                                if(tableCount(events[event])<=0)then
                                    activeEvents[event] = false
                                    self.parent:removeEvent(event, self)
                                end
                            end
                        end
                        return true;
                    end
                end
            end
        end
        return false
    end

    local function stringToNumber(str)
        local ok, err = pcall(load("return " .. str))
        if not(ok)then error(str.." is not a valid dynamic code") end
        return load("return " .. str)()
    end

    local function newDynamicValue(_, obj, str)
        for k,v in pairs(dynamicValues)do
            if(v[2]==str)and(v[4]==obj)then
                return v
            end
        end
        dynValueId = dynValueId + 1
        dynamicValues[dynValueId] = {0, str, {}, obj, dynValueId}
        return dynamicValues[dynValueId]
    end

    local function dynValueGetObjects(obj, str)
        local names = {}
        local t = {}
        for v in str:gmatch("%a+%.x") do
            local name = v:gsub("%.x", "")
            if(name~="self")and(name~="parent")then 
                table.insert(names, name) end
        end
        for v in str:gmatch("%w+%.y") do
            local name = v:gsub("%.y", "")
            if(name~="self")and(name~="parent")then table.insert(names, name) end
        end
        for v in str:gmatch("%a+%.w") do
            local name = v:gsub("%.w", "")
            if(name~="self")and(name~="parent")then 
                table.insert(names, name) 
            
            end
        end
        for v in str:gmatch("%a+%.h") do
            local name = v:gsub("%.h", "")
            if(name~="self")and(name~="parent")then 
                table.insert(names, name) end
        end
        for k,v in pairs(names)do
            t[v] = getObject(v)
            if(t[v]==nil)then
                error("Dynamic Values - unable to find object "..v)
            end
        end
        t["self"] = obj
        t["parent"] = obj:getParent()
        return t
    end

    local function dynValueObjectToNumber(str, objList)
        local newStr = str
        for v in str:gmatch("%w+%.x") do
            newStr = newStr:gsub(v, objList[v:gsub("%.x", "")]:getX())
        end
        for v in str:gmatch("%w+%.y") do
            newStr = newStr:gsub(v, objList[v:gsub("%.y", "")]:getY())
        end
        for v in str:gmatch("%w+%.w") do
            newStr = newStr:gsub(v, objList[v:gsub("%.w", "")]:getWidth())
        end
        for v in str:gmatch("%w+%.h") do
            newStr = newStr:gsub(v, objList[v:gsub("%.h", "")]:getHeight())
        end
        return newStr
    end


    local function recalculateDynamicValues(self)
        if(#dynamicValues>0)then
            for n=1,dynValueId do
                if(dynamicValues[n]~=nil)then
                    local numberStr
                    if(#dynamicValues[n][3]<=0)then dynamicValues[n][3] = dynValueGetObjects(dynamicValues[n][4], dynamicValues[n][2]) end
                    numberStr = dynValueObjectToNumber(dynamicValues[n][2], dynamicValues[n][3])
                    dynamicValues[n][1] = stringToNumber(numberStr)
                    if(dynamicValues[n][4]:getType()=="Frame")then
                        dynamicValues[n][4]:recalculateDynamicValues()
                    end
                end
            end
            for _, index in pairs(objZIndex) do
                if (objects[index] ~= nil) then
                    for _, value in pairs(objects[index]) do
                        if (value.eventHandler ~= nil) then
                            value:eventHandler("dynamicValueEvent", self)
                        end
                    end
                end
            end
        end
    end

    local function getDynamicValue(id)
        return dynamicValues[id][1]
    end

    local function calculateMaxScroll(self)
        for _, value in pairs(objects) do
            for _, b in pairs(value) do
                if(b.getHeight~=nil)and(b.getY~=nil)then
                    local h, y = b:getHeight(), b:getY()
                    if (h + y - self:getHeight() > scrollAmount) then
                        scrollAmount = max(h + y - self:getHeight(), 0)
                    end
                end
            end
        end
    end


    local function focusSystem(self)
        if(focusedObject~=focusedObjectCache)then
            if(focusedObject~=nil)then
                focusedObject:loseFocusHandler()
            end
            if(focusedObjectCache~=nil)then
                focusedObjectCache:getFocusHandler()
            end
            focusedObject = focusedObjectCache
        end
    end

    object = {
        barActive = false,
        barBackground = colors.gray,
        barTextcolor = colors.black,
        barText = "New Frame",
        barTextAlign = "left",

        addEvent = addEvent,
        removeEvent = removeEvent,
        removeEvents = removeEvents,
        getEvent = getEvent,

        newDynamicValue = newDynamicValue,
        recalculateDynamicValues = recalculateDynamicValues,
        getDynamicValue = getDynamicValue,

        getType = function(self)
            return objectType
        end;

        setFocusedObject = function(self, obj)
            focusedObjectCache = obj
            focusSystem(self)
            return self
        end;

        getVariable = function(self, name)
            return basalt.getVariable(name)
        end,

        setSize = function(self, w, h, rel)
            base.setSize(self, w, h, rel)
            if(self.parent==nil)then
                basaltDraw = BasaltDraw(termObject)
            end
            for _, index in pairs(objZIndex) do
                if (objects[index] ~= nil) then
                    for _, value in pairs(objects[index]) do
                        if (value.eventHandler ~= nil) then
                            value:eventHandler("basalt_resize", value, self)
                        end
                    end
                end
            end
            self:recalculateDynamicValues()
            autoSize = false
            return self
        end;

        setTheme = function(self, _theme, col)
            if(type(_theme)=="table")then
                theme = _theme
            elseif(type(_theme)=="string")then
                theme[_theme] = col
            end
            self:updateDraw()
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
                            value:eventHandler("basalt_reposition", value, self)
                        end
                    end
                end
            end
            self:recalculateDynamicValues()
            return self
        end;

        getBasaltInstance = function(self)
            return basalt
        end,

        setOffset = function(self, xO, yO)
            xOffset = xO ~= nil and math.floor(xO < 0 and math.abs(xO) or -xO) or xOffset
            yOffset = yO ~= nil and math.floor(yO < 0 and math.abs(yO) or -yO) or yOffset
            self:updateDraw()
            return self
        end;

        getOffsetInternal = function(self)
            return xOffset, yOffset
        end;

        getOffset = function(self)
            return xOffset < 0 and math.abs(xOffset) or -xOffset, yOffset < 0 and math.abs(yOffset) or -yOffset
        end;

        removeFocusedObject = function(self)
                focusedObjectCache = nil
                focusSystem(self)
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
                local obx, oby = self:getAbsolutePosition(self:getAnchorPosition(self:getX(), self:getY(), true))
                cursorBlink = _blink or false
                if (_xCursor ~= nil) then
                    xCursor = obx + _xCursor - 1
                end
                if (_yCursor ~= nil) then
                    yCursor = oby + _yCursor - 1
                end
                cursorColor = color or cursorColor
                if (cursorBlink) then
                    termObject.setTextColor(cursorColor)
                    termObject.setCursorPos(xCursor, yCursor)
                    termObject.setCursorBlink(cursorBlink)
                else
                    termObject.setCursorBlink(false)
                end
            end
            return self
        end;

        setMovable = function(self, movable)
            if(self.parent~=nil)then
                isMovable = movable or not isMovable
                self.parent:addEvent("mouse_click", self)
                activeEvents["mouse_click"] = true
                self.parent:addEvent("mouse_up", self)
                activeEvents["mouse_up"] = true
                self.parent:addEvent("mouse_drag", self)
                activeEvents["mouse_drag"] = true
            end
            return self;
        end;

        setScrollable = function(self, scrollable)
            isScrollable = (scrollable or scrollable==nil) and true or false
            if(self.parent~=nil)then
                self.parent:addEvent("mouse_scroll", self)
            end
            activeEvents["mouse_scroll"] = true
            return self
        end,

        setScrollAmount = function(self, max)
            scrollAmount = max or scrollAmount
            autoScroll = false
            return self
        end,


        getScrollAmount = function(self)
            return autoScroll and scrollAmount or calculateMaxScroll(self)
        end,

        show = function(self)
            base.show(self)
            if(self.parent==nil)then
                basalt.setActiveFrame(self)
                if(isMonitor)and not(isGroupedMonitor)then
                    basalt.setMonitorFrame(monSide, self)
                elseif(isGroupedMonitor)then
                    basalt.setMonitorFrame(self:getName(), self, monSide)
                else
                    basalt.setMainFrame(self)
                end
            end
            return self;
        end;

        hide = function (self)
            base.hide(self)
            if(self.parent==nil)then
                if(activeFrame == self)then activeFrame = nil end -- bug activeFrame always nil
                if(isMonitor)and not(isGroupedMonitor)then
                    if(basalt.getMonitorFrame(monSide) == self)then
                        basalt.setActiveFrame(nil)
                    end
                elseif(isGroupedMonitor)then
                    if(basalt.getMonitorFrame(self:getName()) == self)then
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
            if(xmlValue("movable", data)~=nil)then if(xmlValue("movable", data))then self:setMovable(true) end end
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
            if(xmlValue("scrollAmount", data)~=nil)then self:setScrollAmount(xmlValue("scrollAmount", data)) end

            local objectList = data:children()
            
            for k,v in pairs(objectList)do
                if(v.___name~="animation")then
                    local name = v.___name:gsub("^%l", string.upper)
                    if(_OBJECTS[name]~=nil)then
                        addXMLObjectType(v, self["add"..name], self)
                    end
                end
            end
            
            addXMLObjectType(data["frame"], self.addFrame, self)
            addXMLObjectType(data["animation"], self.addAnimation, self)
            return self
        end,

        showBar = function(self, showIt) -- deprecated
            self.barActive = showIt or not self.barActive
            self:updateDraw()
            return self
        end;

        setBar = function(self, text, bgCol, fgCol) -- deprecated
            self.barText = text or ""
            self.barBackground = bgCol or self.barBackground
            self.barTextcolor = fgCol or self.barTextcolor
            self:updateDraw()
            return self
        end;

        setBarTextAlign = function(self, align) -- deprecated
            self.barTextAlign = align or "left"
            self:updateDraw()
            return self
        end;

        setMirror = function(self, side)
            if(self.parent~=nil)then error("Frame has to be a base frame in order to attach a mirror.") end
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

        setMonitorScale = function(self, scale)
            if(isMonitor)then
                termObject.setTextScale(scale)
            end
            return self
        end,

        setMonitor = function(self, side, scale)
            if(side~=nil)and(side~=false)then
                if(type(side)=="string")then
                    if(peripheral.getType(side)=="monitor")then
                        termObject = peripheral.wrap(side)
                        monitorAttached = true
                    end
                    if(self.parent~=nil)then
                        self.parent:removeObject(self)
                    end
                    isMonitor = true
                    basalt.setMonitorFrame(side, self)
                elseif(type(side)=="table")then
                    termObject = basaltMon(side)
                    monitorAttached = true
                    isMonitor = true
                    isGroupedMonitor = true
                    basalt.setMonitorFrame(self:getName(), self, true)
                end
            else
                termObject = parentTerminal
                isMonitor = false
                isGroupedMonitor = false
                if(type(monSide)=="string")then
                    if(basalt.getMonitorFrame(monSide)==self)then
                        basalt.setMonitorFrame(monSide, nil)
                    end
                else
                    if(basalt.getMonitorFrame(self:getName())==self)then
                        basalt.setMonitorFrame(self:getName(), nil)
                    end
                end
            end
            if(scale~=nil)then termObject.setTextScale(scale) end
            basaltDraw = BasaltDraw(termObject)
            self:setSize(termObject.getSize())
            autoSize = true
            monSide = side or nil
            self:updateDraw()
            return self;
        end;

        loseFocusHandler = function(self)
            base.loseFocusHandler(self)
            if(focusedObject~=nil)then focusedObject:loseFocusHandler() focusedObject = nil end
        end;

        getFocusHandler = function(self)
            base.getFocusHandler(self)
            if (self.parent ~= nil) then
                if(isMovable)then
                    self.parent:removeEvents(self)
                    self.parent:removeObject(self)
                    self.parent:addObject(self)
                    for k,v in pairs(activeEvents)do
                        if(v)then
                            self.parent:addEvent(k, self)
                        end
                    end
                    self:updateDraw()
                end
            end
            if(focusedObject~=nil)then focusedObject:getFocusHandler() end
        end;

        eventHandler = function(self, event, p1, p2, p3, p4)
            base.eventHandler(self, event, p1, p2, p3, p4)
            if(events["other_event"]~=nil)then
                for _, index in ipairs(eventZIndex["other_event"]) do
                    if (events["other_event"][index] ~= nil) then
                        for _, value in rpairs(events["other_event"][index]) do
                            if (value.eventHandler ~= nil) then
                                if (value:eventHandler(event, p1, p2, p3, p4)) then
                                    return true
                                end
                            end
                        end
                    end
                end
            end
            if(autoSize)and not(isMonitor)then
                if(self.parent==nil)then
                    if(event=="term_resize")then
                        self:setSize(termObject.getSize())
                        autoSize = true
                    end
                end
            end
            if(isMonitor)then
                if(autoSize)then
                    if(event=="monitor_resize")then
                        if(type(monSide)=="string")then
                            self:setSize(termObject.getSize())
                        elseif(type(monSide)=="table")then
                            for k,v in pairs(monSide)do
                                for a,b in pairs(v)do
                                    if(p1==b)then
                                        self:setSize(termObject.getSize())
                                    end
                                end
                            end
                        end
                        autoSize = true
                        self:updateDraw()
                    end
                end
                if(event == "peripheral")and(p1==monSide)then
                    if(peripheral.getType(monSide)=="monitor")then
                        monitorAttached = true
                        termObject = peripheral.wrap(monSide)
                        basaltDraw = BasaltDraw(termObject)
                        self:updateDraw()
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
                if(event=="monitor_touch")and(mirrorSide==p1)then
                    self:mouseHandler(1, p2, p3, true)
                end
            end
            if (event == "terminate")and(self.parent==nil)then
                basalt.stop()
            end
        end,

        mouseHandler = function(self, button, x, y, _, side)
            if(isGroupedMonitor)then
                if(termObject.calculateClick~=nil)then
                    x, y = termObject.calculateClick(side, x, y)
                end
            end
            if(base.mouseHandler(self, button, x, y))then
                if(events["mouse_click"]~=nil)then
                    self:setCursor(false)
                    for _, index in ipairs(eventZIndex["mouse_click"]) do
                        if (events["mouse_click"][index] ~= nil) then
                            for _, value in rpairs(events["mouse_click"][index]) do
                                if (value.mouseHandler ~= nil) then
                                    if (value:mouseHandler(button, x, y)) then
                                        focusSystem(self)
                                        return true
                                    end
                                end
                            end
                        end
                    end
                end
                if (isMovable) then
                    local fx, fy = self:getAbsolutePosition(self:getAnchorPosition())
                    if (x >= fx) and (x <= fx + self:getWidth() - 1) and (y == fy)then
                        isDragging = true
                        dragXOffset = fx - x
                        dragYOffset = yOff and 1 or 0
                    end
                end
                self:removeFocusedObject()
                return true
            end
            return false
        end,

        mouseUpHandler = function(self, button, x, y)
            if (isDragging) then
                isDragging = false
            end
            if(base.mouseUpHandler(self, button, x, y))then
                if(events["mouse_up"]~=nil)then
                    for _, index in ipairs(eventZIndex["mouse_up"]) do
                        if (events["mouse_up"][index] ~= nil) then
                            for _, value in rpairs(events["mouse_up"][index]) do
                                if (value.mouseUpHandler ~= nil) then
                                    if (value:mouseUpHandler(button, x, y)) then
                                        focusSystem(self)
                                        return true
                                    end
                                end
                            end
                        end
                    end
                end
                focusSystem(self)
                return true
            end
            return false
        end,

        scrollHandler = function(self, dir, x, y)
            if(base.scrollHandler(self, dir, x, y))then
                if(events["mouse_scroll"]~=nil)then
                    for _, index in pairs(eventZIndex["mouse_scroll"]) do
                        if (events["mouse_scroll"][index] ~= nil) then
                            for _, value in rpairs(events["mouse_scroll"][index]) do
                                if (value.scrollHandler ~= nil) then
                                    if (value:scrollHandler(dir, x, y)) then
                                        focusSystem(self)
                                        return true
                                    end
                                end
                            end
                        end
                    end
                end
                local cache = yOffset
                if(isScrollable)then
                    calculateMaxScroll(self)
                    if(dir>0)or(dir<0)then
                        yOffset = max(min(yOffset-dir, 0),-scrollAmount)
                        self:updateDraw()
                    end
                end
                self:removeFocusedObject()
                if(yOffset==cache)then return false end
                return true
            end
            return false
        end,

        dragHandler = function(self, button, x, y)
            if (isDragging) then
                local xO, yO = self.parent:getOffsetInternal()
                xO = xO < 0 and math.abs(xO) or -xO
                yO = yO < 0 and math.abs(yO) or -yO
                local parentX = 1
                local parentY = 1
                if (self.parent ~= nil) then
                    parentX, parentY = self.parent:getAbsolutePosition(self.parent:getAnchorPosition())
                end
                self:setPosition(x + dragXOffset - (parentX - 1) + xO, y + dragYOffset - (parentY - 1) + yO)
                self:updateDraw()
                return true
            end
            if(self:isVisible())and(self:isEnabled())then
                if(events["mouse_drag"]~=nil)then
                    for _, index in ipairs(eventZIndex["mouse_drag"]) do
                        if (events["mouse_drag"][index] ~= nil) then
                            for _, value in rpairs(events["mouse_drag"][index]) do
                                if (value.dragHandler ~= nil) then
                                    if (value:dragHandler(button, x, y)) then
                                        focusSystem(self)
                                        return true
                                    end
                                end
                            end
                        end
                    end
                end
            end
            focusSystem(self)
            base.dragHandler(self, button, x, y)
            return false
        end,

        keyHandler = function(self, key, isHolding)
            if (self:isFocused())or(self.parent==nil)then
                local val = self:getEventSystem():sendEvent("key", self, "key", key)
                if(val==false)then return false end
                if(events["key"]~=nil)then
                    for _, index in pairs(eventZIndex["key"]) do
                        if (events["key"][index] ~= nil) then
                            for _, value in rpairs(events["key"][index]) do
                                if (value.keyHandler ~= nil) then
                                    if (value:keyHandler(key, isHolding)) then
                                        return true
                                    end
                                end
                            end
                        end
                    end
                end
            end
            return false
        end,

        keyUpHandler = function(self, key)
            if (self:isFocused())or(self.parent==nil)then
                local val = self:getEventSystem():sendEvent("key_up", self, "key_up", key)
                if(val==false)then return false end
                if(events["key_up"]~=nil)then
                    for _, index in pairs(eventZIndex["key_up"]) do
                        if (events["key_up"][index] ~= nil) then
                            for _, value in rpairs(events["key_up"][index]) do
                                if (value.keyUpHandler ~= nil) then
                                    if (value:keyUpHandler(key)) then
                                        return true
                                    end
                                end
                            end
                        end
                    end
                end
            end
            return false
        end,

        charHandler = function(self, char)
            if (self:isFocused())or(self.parent==nil)then
                local val = self:getEventSystem():sendEvent("char", self, "char", char)
                if(val==false)then return false end
                if(events["char"]~=nil)then
                    for _, index in pairs(eventZIndex["char"]) do
                        if (events["char"][index] ~= nil) then
                            for _, value in rpairs(events["char"][index]) do
                                if (value.charHandler ~= nil) then
                                    if (value:charHandler(char)) then
                                        return true
                                    end
                                end
                            end
                        end
                    end
                end
            end
            return false
        end,

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

        draw = function(self, force)
            if(isMonitor)and not(monitorAttached)then return false end;
            if(self.parent==nil)then if(self:getDraw()==false)then return false end end
            if (base.draw(self))then
                local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
                local anchx, anchy = self:getAnchorPosition()
                local w,h = self:getSize()
                if (self.parent == nil) then
                    if(self.bgColor~=false)then
                        basaltDraw.drawBackgroundBox(anchx, anchy, w, h, self.bgColor)
                        basaltDraw.drawTextBox(anchx, anchy, w, h, " ")
                    end
                    if(self.fgColor~=false)then basaltDraw.drawForegroundBox(anchx, anchy, w, h, self.fgColor) end
                end
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
            end
        end;

        updateTerm = function(self)
            if(isMonitor)and not(monitorAttached)then return false end;
            basaltDraw.update()
        end;

        addObject = function(self, obj)
            return addObject(obj)
        end;

        removeObject = removeObject,

        getObject = function(self, obj)
            return getObject(obj)
        end;
        getDeepObject = function(self, name)
            return getDeepObject(name)
        end,

        addFrame = function(self, name)
            local obj = basalt.newFrame(name or uuid(), self, nil, basalt)
            return addObject(obj)
        end,

        init = function(self)
            if not(initialized)then
                if (parent ~= nil) then
                    base.width, base.height = parent:getSize()
                    self:setBackground(parent:getTheme("FrameBG"))
                    self:setForeground(parent:getTheme("FrameText"))
                else
                    base.width, base.height = termObject.getSize()
                    self:setBackground(basalt.getTheme("BasaltBG"))
                    self:setForeground(basalt.getTheme("BasaltText"))
                end
                initialized = true
            end
        end,
    }
    for k,v in pairs(_OBJECTS)do
        object["add"..k] = function(self, name)
            return addObject(v(name or uuid(), self))
        end
    end
    setmetatable(object, base)
    return object
end
