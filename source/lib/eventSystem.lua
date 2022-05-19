local function BasaltEvents()

    local events = {}
    local index = {}

    local event = {
        registerEvent = function(self, _event, func)
            if (events[_event] == nil) then
                events[_event] = {}
                index[_event] = 1
            end
            events[_event][index[_event]] = func
            index[_event] = index[_event] + 1
            return index[_event] - 1
        end;

        removeEvent = function(self, _event, index)
            events[_event][index[_event]] = nil
        end;

        sendEvent = function(self, _event, ...)
            if (events[_event] ~= nil) then
                for _, value in pairs(events[_event]) do
                    value(...)
                end
            end
        end;
    }
    event.__index = event
    return event
end