local basaltEvent = require("basaltEvent")
local utils = require("utils")
local uuid = utils.uuid

local unpack,sub = table.unpack,string.sub

return function(name, basalt)
    name = name or uuid()
    assert(basalt~=nil, "Unable to find basalt instance! ID: "..name)

    -- Base object
    local objectType = "Object" -- not changeable
    local isEnabled,initialized = true,false

    local eventSystem = basaltEvent()
    local activeEvents = {}

    local parent
    
    local object = {
        init = function(self)
            if(initialized)then return false end
            initialized = true
            return true
        end,

        load = function(self)
        end,

        getType = function(self)
            return objectType
        end,
        isType = function(self, t)
            return objectType==t
        end,
        
        getName = function(self)
            return name
        end,

        getParent = function(self)
            return parent
        end,

        setParent = function(self, newParent, noRemove)
            if(noRemove)then parent = newParent return self end
            if (newParent.getType ~= nil and newParent:isType("Container")) then
                self:remove()
                newParent:addObject(self)
                if (self.show) then
                    self:show()
                end
                parent = newParent
            end
            return self
        end,

        updateEvents = function(self)
            for k,v in pairs(activeEvents)do
                parent:removeEvent(k, self)
                if(v)then
                    parent:addEvent(k, self)
                end
            end
            return self
        end,

        listenEvent = function(self, event, active)
            if(parent~=nil)then
                if(active)or(active==nil)then
                    activeEvents[event] = true
                    parent:addEvent(event, self)
                elseif(active==false)then
                    activeEvents[event] = false
                    parent:removeEvent(event, self)
                end
            end
            return self
        end,

        getZIndex = function(self)
            return 1
        end,

        enable = function(self)
            isEnabled = true
            return self
        end,

        disable = function(self)
            isEnabled = false
            return self
        end,

        isEnabled = function(self)
            return isEnabled
        end,

        remove = function(self)
            if (parent ~= nil) then
                parent:removeObject(self)
            end
            self:updateDraw()
            return self
        end,

        getBaseFrame = function(self)
            if(parent~=nil)then
                return parent:getBaseFrame()
            end
            return self
        end,

        onEvent = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("other_event", v)
                end
            end
            return self
        end,

        getEventSystem = function(self)
            return eventSystem
        end,

        registerEvent = function(self, event, func)
            if(parent~=nil)then
                parent:addEvent(event, self)
            end
            return eventSystem:registerEvent(event, func)
        end,

        removeEvent = function(self, event, index)
            if(eventSystem:getEventCount(event)<1)then
                if(parent~=nil)then
                    parent:removeEvent(event, self)
                end
            end
            return eventSystem:removeEvent(event, index)
        end,

        sendEvent = function(self, event, ...)
            return eventSystem:sendEvent(event, self, ...)
        end,

        onClick = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("mouse_click", v)
                end
            end
            return self
        end,

        onClickUp = function(self, ...)
                for _,v in pairs(table.pack(...))do
                    if(type(v)=="function")then
                        self:registerEvent("mouse_up", v)
                    end
                end
            return self
        end,

        onRelease = function(self, ...)
                for _,v in pairs(table.pack(...))do
                    if(type(v)=="function")then
                        self:registerEvent("mouse_release", v)
                    end
                end
            return self
        end,

        onScroll = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("mouse_scroll", v)
                end
            end
            return self
        end,

        onHover = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("mouse_hover", v)
                end
            end
            return self
        end,

        onLeave = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("mouse_leave", v)
                end
            end
            return self
        end,

        onDrag = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("mouse_drag", v)
                end
            end
            return self
        end,

        onKey = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("key", v)
                end
            end
            return self
        end,

        onChar = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("char", v)
                end
            end
            return self
        end,

        onKeyUp = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("key_up", v)
                end
            end
            return self
        end,
        }

    object.__index = object
    return object
end