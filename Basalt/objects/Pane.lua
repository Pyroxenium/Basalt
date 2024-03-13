return function(name, basalt)
    -- Pane
    local base = basalt.getObject("VisualObject")(name, basalt)
    local objectType = "Pane"

    base:setSize(25, 10)

    local object = {
        getType = function(self)
            return objectType
        end,
    }

    object.__index = object
    return setmetatable(object, base)
end