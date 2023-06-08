local Reactive = require("reactivePrimitives")
local XMLParser = require("xmlParser")

local Layout = {
    fromXML = function(text)
        local nodes = XMLParser.parseText(text)
        local script = nil
        for index, node in ipairs(nodes) do
            if (node.tag == "script") then
                script = node.value
                table.remove(nodes, index)
                break
            end
        end
        return {
            nodes = nodes,
            script = script
        }
    end
}

local executeScript = function(script, env)
    return load(script, nil, "t", env)()
end

local registerFunctionEvent = function(object, event, script, env)
    event(object, function(...)
        local success, msg = pcall(function()
            Reactive.transaction(load(script, nil, "t", env))
        end)
        if not success then
            error("XML Error: "..msg)
        end
    end)
end

return {
    basalt = function(basalt)
        local object = {
            observable = Reactive.observable,
            derived = Reactive.derived,
            effect = Reactive.effect,
            transaction = Reactive.transaction,
            untracked = Reactive.untracked,

            layout = function(path)
                if (not fs.exists(path)) then
                    error("Can't open file " .. path)
                end
                local f = fs.open(path, "r")
                local text = f.readAll()
                f.close()
                return Layout.fromXML(text)
            end,

            createObjectsFromXMLNode = function(node, env)
                local layout = env[node.tag]
                if (layout ~= nil) then
                    local props = {}
                    for prop, expression in pairs(node.attributes) do
                        props[prop] = load("return " .. expression, nil, "t", env)
                    end
                    return basalt.createObjectsFromLayout(layout, props)
                end
            
                local objectName = node.tag:gsub("^%l", string.upper)
                local object = basalt:createObject(objectName, node.attributes["id"])
                for attribute, expression in pairs(node.attributes) do
                    if (attribute:sub(1, 2) == "on") then
                        registerFunctionEvent(object, object[attribute], expression .. "()", env)
                    else
                        Reactive.effect(function()
                            local value = load("return " .. expression, nil, "t", env)()
                            if(colors[value]~=nil)then value = colors[value] end
                            object:setProperty(attribute, value)
                        end)
                    end
                end
                for _, child in ipairs(node.children) do
                    local childObjects = basalt.createObjectsFromXMLNode(child, env)
                    for _, childObject in ipairs(childObjects) do
                        object:addChild(childObject)
                    end
                end
                return {object}
            end,

            createObjectsFromLayout = function(layout, props)
                local env = _ENV
                env.props = {}
                local updateFns = {}
                for prop, getFn in pairs(props) do
                    updateFns[prop] = basalt.derived(function()
                        return getFn()
                    end)
                end
                setmetatable(env.props, {
                    __index = function(_, k)
                        return updateFns[k]()
                    end
                })
                if (layout.script ~= nil) then
                    Reactive.transaction(function()
                        executeScript(layout.script, env)
                    end)
                end
                local objects = {}
                for _, node in ipairs(layout.nodes) do
                    local _objects = basalt.createObjectsFromXMLNode(node, env)
                    for _, object in ipairs(_objects) do
                        table.insert(objects, object)
                    end
                end
                return objects
            end
        }
        return object
    end,

    Container = function(base, basalt)
        local object = {
            loadLayout = function(self, path, props)
                local wrappedProps = {}
                if (props == nil) then
                    props = {}
                end
                for prop, value in pairs(props) do
                    wrappedProps[prop] = function()
                        return value
                    end
                end
                local layout = basalt.layout(path)
                local objects = basalt.createObjectsFromLayout(layout, wrappedProps)
                for _, object in ipairs(objects) do
                    self:addChild(object)
                end
                return self
            end
        }
        return object
    end
}