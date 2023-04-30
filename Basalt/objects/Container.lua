local utils = require("utils")
local tableCount = utils.tableCount

return function(name, basalt)
    local base = basalt.getObject("VisualObject")(name, basalt)
    local objectType = "Container"

    local elements = {}

    local events = {}

    local container = {}
    local activeEvents = {}

    local focusedObject
    local sorted = true
    local objId, evId = 0, 0

    local objSort = function(a, b)
        if a.zIndex == b.zIndex then
            return a.objId < b.objId
        else
            return a.zIndex < b.zIndex
        end
    end
    local evSort = function(a, b)
        if a.zIndex == b.zIndex then
            return a.evId > b.evId
        else
            return a.zIndex > b.zIndex
        end
    end

    local function getObject(self, name)
        if(type(name)=="table")then name = name:getName() end
        for i, v in ipairs(elements) do
            if v.element:getName() == name then
                return v.element
            end
        end    
    end

    local function getDeepObject(self, name)
        local o = getObject(name)
        if(o~=nil)then return o end
        for _, value in pairs(objects) do            
            if (b:getType() == "Container") then
                local oF = b:getDeepObject(name)
                if(oF~=nil)then return oF end
            end
        end
    end

    local function addObject(self, element, el2)
        if (getObject(element:getName()) ~= nil) then
            return
        end
        objId = objId + 1
        local zIndex = element:getZIndex()
        table.insert(elements, {element = element, zIndex = zIndex, objId = objId})
        sorted = false
        element:setParent(self, true)
        if(element.init~=nil)then element:init() end
        if(element.load~=nil)then element:load() end
        if(element.draw~=nil)then element:draw() end
        return element
    end

    local function updateZIndex(self, element, newZ)
        objId = objId + 1
        evId = evId + 1
        for k,v in pairs(elements)do
            if(v.element==element)then
                v.zIndex = newZ
                v.objId = objId
                break
            end
        end
        for k,v in pairs(events)do
            for a,b in pairs(v)do
                if(b.element==element)then
                    b.zIndex = newZ
                    b.evId = evId
                end
            end
        end
        sorted = false
        self:updateDraw()
    end

    local function removeObject(self, element)
        if(type(element)=="string")then element = getObject(element:getName()) end
        if(element==nil)then return end
        for i, v in ipairs(elements) do
            if v.element == element then
                table.remove(elements, i)
                return true
            end
        end
        sorted = false
    end

    local function removeEvents(self, element)
        local parent = self:getParent()
        for a, b in pairs(events) do
            for c, d in pairs(b) do
                if(d.element == element)then
                    table.remove(events[a], c)
                end
            end
            if(tableCount(events[a])<=0)then
                activeEvents[a] = false
                if(parent~=nil)then
                    parent:removeEvent(a, self)
                end
            end
        end
        sorted = false
    end

    local function getEvent(self, event, name)
        if(type(name)=="table")then name = name:getName() end
        if(events[event]~=nil)then
            for _, obj in pairs(events[event]) do
                if (obj.element:getName() == name) then
                    return obj
                end
            end
        end
    end

    local function addEvent(self, event, element)
        if (getEvent(self, event, element:getName()) ~= nil) then
            return
        end
        local zIndex = element:getZIndex() 
        evId = evId + 1
        if(events[event]==nil)then events[event] = {} end
        table.insert(events[event], {element = element, zIndex = zIndex, evId = evId})
        sorted = false
        self:listenEvent(event)
        return element
    end

    local function removeEvent(self, event, element)
        local parent = self:getParent()
        if(events[event]~=nil)then
            for a, b in pairs(events[event]) do
                if(b.element == element)then
                    table.remove(events[event], a)
                end
            end
            if(tableCount(events[event])<=0)then
                self:listenEvent(event, false)
            end
        end
        sorted = false
    end

    local function getObjects(self)
        self:sortElementOrder()
        return elements
    end

    container = {
        getType = function()
            return objectType
        end,

        getBase = function(self)
            return base
        end,  
        
        isType = function(self, t)
            return objectType==t or base.isType~=nil and base.isType(t) or false
        end,
        
        setSize = function(self, ...)
            base.setSize(self, ...)
            self:customEventHandler("basalt_FrameResize")
            return self
        end,

        setPosition = function(self, ...)
            base.setPosition(self, ...)
            self:customEventHandler("basalt_FrameReposition")
            return self
        end,

        searchObjects = function(self, name)
            local t = {}
            for k,v in pairs(elements)do
                if(string.find(k:getName(), name))then
                    table.insert(t, v)
                end
            end
            return t
        end,

        getObjectsByType = function(self, t)
            local t = {}
            for k,v in pairs(elements)do
                if(v:isType(t))then
                    table.insert(t, v)
                end
            end
            return t
        end,

        setImportant = function(self, element)
            objId = objId + 1
            evId = evId + 1
            for a, b in pairs(events) do
                for c, d in pairs(b) do
                    if(d.element == element)then
                        d.evId = evId
                        table.remove(events[a], c)
                        table.insert(events[a], d)
                        break
                    end
                end
            end
            for i, v in ipairs(elements) do
                if v.element == element then
                    v.objId = objId
                    table.remove(elements, i)
                    table.insert(elements, v)
                    break
                end
            end
            if(self.updateDraw~=nil)then
                self:updateDraw()
            end
            sorted = false
        end,

        sortElementOrder = function(self)
            if(sorted)then return end
            table.sort(elements, objSort)
            for a, b in pairs(events) do
                table.sort(events[a], evSort)
            end
            sorted = true
        end,

        removeFocusedObject = function(self)
            if(focusedObject~=nil)then
                if(getObject(self, focusedObject)~=nil)then
                    focusedObject:loseFocusHandler()
                end
            end
            focusedObject = nil
            return self
        end,

        setFocusedObject = function(self, obj)
            if(focusedObject~=obj)then
                if(focusedObject~=nil)then
                    if(getObject(self, focusedObject)~=nil)then
                        focusedObject:loseFocusHandler()
                    end
                end
                if(obj~=nil)then
                    if(getObject(self, obj)~=nil)then
                        obj:getFocusHandler()
                    end
                end
                focusedObject = obj
                return true
            end
            return false
        end,

        getFocusedObject = function(self)
            return focusedObject
        end,
        
        getObject = getObject,
        getObjects = getObjects,
        getDeepObject = getDeepObject,
        addObject = addObject,
        removeObject = removeObject,
        getEvent = getEvent,
        addEvent = addEvent,
        removeEvent = removeEvent,
        updateZIndex = updateZIndex,

        listenEvent = function(self, event, active)
            base.listenEvent(self, event, active)
            activeEvents[event] = active~=nil and active or true
            if(events[event]==nil)then events[event] = {} end
            return self
        end,

        customEventHandler = function(self, ...)
            base.customEventHandler(self, ...)
            for _, o in pairs(elements) do
                if (o.element.customEventHandler ~= nil) then
                    o.element:customEventHandler(...)
                end
            end
        end,

        loseFocusHandler = function(self)
            base.loseFocusHandler(self)
            if(focusedObject~=nil)then focusedObject:loseFocusHandler() focusedObject = nil end
        end,

        getBasalt = function(self)
            return basalt
        end,

        setPalette = function(self, col, ...)
            local parent = self:getParent()
            parent:setPalette(col, ...)
            return self
        end,

        eventHandler = function(self, ...)            
            if(base.eventHandler~=nil)then
                base.eventHandler(self, ...)
                if(events["other_event"]~=nil)then
                    self:sortElementOrder()
                    for _, obj in ipairs(events["other_event"]) do
                        if (obj.element.eventHandler ~= nil) then
                            obj.element.eventHandler(obj.element, ...)
                        end
                    end
                end
            end
        end,
    }

    for k,v in pairs({mouse_click={"mouseHandler", true},mouse_up={"mouseUpHandler", false},mouse_drag={"dragHandler", false},mouse_scroll={"scrollHandler", true},mouse_hover={"hoverHandler", false}})do
        container[v[1]] = function(self, btn, x, y, ...)
            if(base[v[1]]~=nil)then
                if(base[v[1]](self, btn, x, y, ...))then
                    if(events[k]~=nil)then
                        self:sortElementOrder()
                        for _, obj in ipairs(events[k]) do
                            if (obj.element[v[1]] ~= nil) then
                                local xO, yO = 0, 0
                                if(self.getOffset~=nil)then
                                    xO, yO = self:getOffset()
                                end
                                if (obj.element[v[1]](obj.element, btn, x+xO, y+yO, ...)) then      
                                    return true
                                end
                            end
                        end
                    if(v[2])then
                        self:removeFocusedObject()
                    end
                    return true
                    end
                end
            end
        end
    end

    for k,v in pairs({key="keyHandler",key_up="keyUpHandler",char="charHandler"})do
        container[v] = function(self, ...)
            if(base[v]~=nil)then
                if(base[v](self, ...))then
                    if(events[k]~=nil)then  
                        self:sortElementOrder()                  
                        for _, obj in ipairs(events[k]) do
                            if (obj.element[v] ~= nil) then
                                if (obj.element[v](obj.element, ...)) then
                                    return true
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    for k,v in pairs(basalt.getObjects())do
        container["add"..k] = function(self, name)
            return addObject(self, v(name, basalt))
        end
    end

    container.__index = container
    return setmetatable(container, base)
end