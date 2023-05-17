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

local function executeScript(script, env)
    return load(script, nil, "t", env)()
end

local function registerFunctionEvent(object, event, script, env)
    event(object, function(...)
        local success, msg = pcall(load(script, nil, "t", env))
        if not success then
            error("XML Error: "..msg)
        end
    end)
end

local currentEffect = nil

local clearEffectDependencies = function(effect)
    for _, dependency in ipairs(effect.dependencies) do
        for index, backlink in ipairs(dependency) do
            if (backlink == effect) then
                table.remove(dependency, index)
            end
        end
    end
    effect.dependencies = {};
end

return {
    basalt = function(basalt)
        local object = {
            reactive = function(initialValue)
                local value = initialValue
                local observerEffects = {}
                local get = function()
                    if (currentEffect ~= nil) then
                        table.insert(observerEffects, currentEffect)
                        table.insert(currentEffect.dependencies, observerEffects)
                    end
                    return value
                end
                local set = function(newValue)
                    value = newValue
                    local observerEffectsCopy = {}
                    for index, effect in ipairs(observerEffects) do
                        observerEffectsCopy[index] = effect
                    end
                    for _, effect in ipairs(observerEffectsCopy) do
                        effect.execute()
                    end
                end
                return get, set
            end,

            untracked = function(getter)
                local parentEffect = currentEffect
                currentEffect = nil
                local value = getter()
                currentEffect = parentEffect
                return value
            end,

            effect = function(effectFn)
                local effect = {dependencies = {}}
                local execute = function()
                    clearEffectDependencies(effect)
                    local parentEffect = currentEffect
                    currentEffect = effect
                    effectFn()
                    currentEffect = parentEffect
                end
                effect.execute = execute
                effect.execute()
            end,

            derived = function(computeFn)
                local getValue, setValue = basalt.reactive();
                basalt.effect(function()
                    setValue(computeFn())
                end)
                return getValue;
            end,

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
                local objects
                local layout = env[node.tag]
                if (layout ~= nil) then
                    local updateFns = {}
                    for prop, expression in pairs(node.attributes) do
                        updateFns[prop] = basalt.derived(function()
                            return load("return " .. expression, nil, "t", env)()
                        end)
                    end
                    local props = {}
                    setmetatable(props, {
                        __index = function(_, k)
                            return updateFns[k]()
                        end
                    })
                    objects = basalt.createObjectsFromLayout(layout, props)
                else
                    local objectName = node.tag:gsub("^%l", string.upper)
                    local object = basalt:createObject(objectName, node.attributes["id"])
                    for attribute, expression in pairs(node.attributes) do
                        if (attribute:sub(1, 2) == "on") then
                            registerFunctionEvent(object, object[attribute], expression .. "()", env)
                        else
                            local update = function()
                                local value = load("return " .. expression, nil, "t", env)()
                                object:setProperty(attribute, value)
                            end
                            basalt.effect(update)
                        end
                    end
                    for _, child in ipairs(node.children) do
                        local childObjects = basalt.createObjectsFromXMLNode(child, env)
                        for _, childObject in ipairs(childObjects) do
                            object:addChild(childObject)
                        end
                    end
                    objects = {object}
                end
                return objects
            end,

            createObjectsFromLayout = function(layout, props)
                local env = _ENV
                env.props = props
                if (layout.script ~= nil) then
                    executeScript(layout.script, env)
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
                if (props == nil) then
                    props = {}
                end
                local layout = basalt.layout(path)
                local objects = basalt.createObjectsFromLayout(layout, props)
                for _, object in ipairs(objects) do
                    self:addChild(object)
                end
                return self
            end
        }
        return object
    end
}
