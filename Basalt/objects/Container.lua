local utils = require("utils")
local tableCount = utils.tableCount

return function(name, basalt)
    local base = basalt.getObject("VisualObject")(name, basalt)
    local objectType = "Container"

    local children = {}

    local events = {}

    local container = {}

    local focusedChild
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

    local function getChildren(self)
        self:sortChildren()
        return children
    end

    local function getChild(self, name)
        if (type(name)=="table") then
            name = name:getName()
        end
        for _, v in ipairs(children) do
            if v.element:getName() == name then
                return v.element
            end
        end
    end

    local function getDeepChild(self, name)
        local maybeChild = getChild(name)
        if (maybeChild ~= nil) then
            return maybeChild
        end
        for _, child in ipairs(children) do            
            if (child:getType() == "Container") then
                local maybeDeepChild = child:getDeepChild(name)
                if (maybeDeepChild ~= nil) then
                    return maybeDeepChild
                end
            end
        end
    end

    local function addChild(self, element)
        if (getChild(element:getName()) ~= nil) then
            return
        end
        objId = objId + 1
        local zIndex = element:getZIndex()
        table.insert(children, {element = element, zIndex = zIndex, objId = objId})
        sorted = false
        element:setParent(self, true)
        for event, _ in pairs(element:getRegisteredEvents()) do
            self:addEvent(event, element)
        end
        if (element.init~=nil) then
            element:init()
        end
        if (element.load~=nil) then
            element:load()
        end
        if (element.draw~=nil) then
            element:draw()
        end
        return element
    end

    local function removeChild(self, element)
        if (type(element)=="string") then
            element = getChild(element:getName())
        end
        if (element==nil) then
            return
        end
        for i, v in ipairs(children) do
            if v.element == element then
                table.remove(children, i)
                return true
            end
        end
        self:removeEvents(element)
        sorted = false
    end

    local function removeChildren(self)
        local parent = self:getParent()
        children = {}
        events = {}
        sorted = false
        objId = 0
        evId = 0
        focusedChild = nil
        parent:removeEvents(self)
    end

    local function updateZIndex(self, element, newZ)
        objId = objId + 1
        evId = evId + 1
        for _,v in pairs(children)do
            if(v.element==element)then
                v.zIndex = newZ
                v.objId = objId
                break
            end
        end
        for _,v in pairs(events)do
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

    local function removeEvents(self, element)
        local parent = self:getParent()
        for a, b in pairs(events) do
            for c, d in pairs(b) do
                if(d.element == element)then
                    table.remove(events[a], c)
                end
            end
            if(tableCount(events[a])<=0)then
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

    local function getEvents(self, event)
        return event~=nil and events[event] or events
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

        searchChildren = function(self, name)
            local results = {}
            for _, child in pairs(children) do
                if (string.find(child.element:getName(), name)) then
                    table.insert(results, child)
                end
            end
            return results
        end,

        getChildrenByType = function(self, type)
            local results = {}
            for _, child in pairs(children) do
                if (child.element:isType(type)) then
                    table.insert(results, child)
                end
            end
            return results
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
            for i, v in ipairs(children) do
                if v.element == element then
                    v.objId = objId
                    table.remove(children, i)
                    table.insert(children, v)
                    break
                end
            end
            if(self.updateDraw~=nil)then
                self:updateDraw()
            end
            sorted = false
        end,

        sortChildren = function(self)
            if (sorted) then
                return
            end
            table.sort(children, objSort)
            for event, _ in pairs(events) do
                table.sort(events[event], evSort)
            end
            sorted = true
        end,

        clearFocusedChild = function(self)
            if(focusedChild~=nil)then
                if(getChild(self, focusedChild)~=nil)then
                    focusedChild:loseFocusHandler()
                end
            end
            focusedChild = nil
            return self
        end,

        setFocusedChild = function(self, obj)
            if(focusedChild~=obj)then
                if(focusedChild~=nil)then
                    if(getChild(self, focusedChild)~=nil)then
                        focusedChild:loseFocusHandler()
                    end
                end
                if(obj~=nil)then
                    if(getChild(self, obj)~=nil)then
                        obj:getFocusHandler()
                    end
                end
                focusedChild = obj
                return true
            end
            return false
        end,

        getFocused = function(self)
            return focusedChild
        end,
        
        getChild = getChild,
        getChildren = getChildren,
        getDeepChildren = getDeepChild,
        addChild = addChild,
        removeChild = removeChild,
        removeChildren = removeChildren,
        getEvents = getEvents,
        getEvent = getEvent,
        addEvent = addEvent,
        removeEvent = removeEvent,
        removeEvents = removeEvents,
        updateZIndex = updateZIndex,

        listenEvent = function(self, event, active)
            base.listenEvent(self, event, active)
            if(events[event]==nil)then events[event] = {} end
            return self
        end,

        customEventHandler = function(self, ...)
            base.customEventHandler(self, ...)
            for _, o in pairs(children) do
                if (o.element.customEventHandler ~= nil) then
                    o.element:customEventHandler(...)
                end
            end
        end,

        loseFocusHandler = function(self)
            base.loseFocusHandler(self)
            if(focusedChild~=nil)then focusedChild:loseFocusHandler() focusedChild = nil end
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
                    self:sortChildren()
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
                        self:sortChildren()
                        for _, obj in ipairs(events[k]) do
                            if (obj.element[v[1]] ~= nil) then
                                local xO, yO = 0, 0
                                if(self.getOffset~=nil)then
                                    xO, yO = self:getOffset()
                                end
                                if(obj.element.getIgnoreOffset~=nil)then
                                    if(obj.element.getIgnoreOffset())then
                                        xO, yO = 0, 0
                                    end
                                end
                                if (obj.element[v[1]](obj.element, btn, x+xO, y+yO, ...)) then      
                                    return true
                                end
                            end
                        end
                    if(v[2])then
                        self:clearFocusedChild()
                    end
                    end
                    return true
                end
            end
        end
    end

    for k,v in pairs({key="keyHandler",key_up="keyUpHandler",char="charHandler"})do
        container[v] = function(self, ...)
            if(base[v]~=nil)then
                if(base[v](self, ...))then
                    if(events[k]~=nil)then
                        self:sortChildren()
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

    for objectName, _ in pairs(basalt.getObjects()) do
        container["add" .. objectName] = function(self, id)
            return self:addChild(basalt:createObject(objectName, id))
        end
    end

    container.__index = container
    return setmetatable(container, base)
end