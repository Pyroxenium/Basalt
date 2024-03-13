return function()
    local events = {}

    local event = {
        registerEvent = function(self, _event, func)
            if (events[_event] == nil) then
                events[_event] = {}
            end
            table.insert(events[_event], func)
        end,

        removeEvent = function(self, _event, index)
            events[_event][index[_event]] = nil
        end,

        hasEvent = function(self, _event)
            return events[_event]~=nil
        end,
        
        getEventCount = function(self, _event)
            return events[_event]~=nil and #events[_event] or 0
        end,

        getEvents = function(self)
            local t = {}
            for k,v in pairs(events)do
                table.insert(t, k)
            end
            return t
        end,

        clearEvent = function(self, _event)
            events[_event] = nil
        end,

        clear = function(self, _event)
            events = {}
        end,

        sendEvent = function(self, _event, ...)
            local returnValue
            if (events[_event] ~= nil) then
                for _, value in pairs(events[_event]) do
                    local val = value(...)
                    if(val==false)then
                        returnValue = val
                    end
                end
            end
            return returnValue
        end,
    }
    event.__index = event
    return event
end