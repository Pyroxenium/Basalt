return function(name, basalt)
    -- Pane
    local base = basalt.getObject("VisualObject")(name, basalt)
    base:setType("Pane")

    base:setSize(25, 10)

    local object = {}

    object.__index = object
    return setmetatable(object, base)
end