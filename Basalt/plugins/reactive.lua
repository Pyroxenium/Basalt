local XMLParser = require("xmlParser")
local utils = require("utils")
local uuid = utils.uuid

local function maybeExecuteScript(nodeTree, renderContext)
    for _, node in ipairs(nodeTree.children) do
        if (node.tag == "script") then
            return load(node.value, nil, "t", renderContext.env)()
        end
    end
end

local function registerFunctionEvent(self, event, script, renderContext)
    local eventEnv = renderContext.env
    event(self, function(...)
        eventEnv.event = {...}
        local success, msg = pcall(load(script, nil, "t", eventEnv))
        if not success then
            error("XML Error: "..msg)
        end
    end)
end

local function registerFunctionEvents(self, node, events, renderContext)
    for _, event in pairs(events) do
        local expression = node.attributes[event]
        if (expression ~= nil) then
            registerFunctionEvent(self, self[event], expression .. "()", renderContext)
        end
    end
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
            layout = function(path)
                return {
                    path = path,
                }
            end,

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
            end
        }
        return object
    end,

    VisualObject = function(base, basalt)

        local object = {
            setValuesByXMLData = function(self, node, renderContext)
                renderContext.env[self:getName()] = self
                for attribute, expression in pairs(node.attributes) do
                    local update = function()
                        local value = load("return " .. expression, nil, "t", renderContext.env)()
                        self:setProperty(attribute, value)
                    end
                    basalt.effect(update)
                end
                registerFunctionEvents(self, node, {
                    "onClick",
                    "onClickUp",
                    "onHover",
                    "onScroll",
                    "onDrag",
                    "onKey",
                    "onKeyUp",
                    "onRelease",
                    "onChar",
                    "onGetFocus",
                    "onLoseFocus",
                    "onResize",
                    "onReposition",
                    "onEvent",
                    "onLeave"
                }, renderContext)
                return self
            end,
        }
        return object
    end,

    ChangeableObject = function(base, basalt)
        local object = {
            setValuesByXMLData = function(self, node, renderContext)
                base.setValuesByXMLData(self, node, renderContext)
                registerFunctionEvent(self, node, {
                    "onChange"
                }, renderContext)
                return self
            end,
        }
        return object
    end,

    Container = function(base, basalt)
        local lastXMLReferences = {}

        local function xmlDefaultValues(node, obj, renderContext)
            if (obj~=nil) then
                obj:setValuesByXMLData(node, renderContext)
            end
        end

        local function addXMLObjectType(node, addFn, self, renderContext)
            if (node ~= nil) then
                if (node.attributes ~= nil) then
                    node = {node}
                end
                for _, v in pairs(node) do
                    local obj = addFn(self, v["@id"] or uuid())
                    lastXMLReferences[obj:getName()] = obj
                    xmlDefaultValues(v, obj, renderContext)
                end
            end
        end

        local function insertChildLayout(self, layout, node, renderContext)
            local updateFns = {}
            for prop, expression in pairs(node.attributes) do
                updateFns[prop] = basalt.derived(function()
                    return load("return " .. expression, nil, "t", renderContext.env)()
                end)
            end
            local props = {}
            setmetatable(props, {
                __index = function(_, k)
                    return updateFns[k]()
                end
            })
            self:loadLayout(layout.path, props)
        end

        local object = {
            setValuesByXMLData = function(self, node, renderContext)
                lastXMLReferences = {}
                base.setValuesByXMLData(self, node, renderContext)

                local _OBJECTS = basalt.getObjects()

                for _, child in pairs(node.children) do
                    local tagName = child.tag
                    if (tagName == "animation") then
                        addXMLObjectType(child, self.addAnimation, self, renderContext)
                    else
                        local layout = renderContext.env[tagName]
                        local objectKey = tagName:gsub("^%l", string.upper)
                        if (layout ~= nil) then
                            insertChildLayout(self, layout, child, renderContext)
                        elseif (_OBJECTS[objectKey] ~= nil) then
                            local addFn = self["add" .. objectKey]
                            addXMLObjectType(child, addFn, self, renderContext)
                        end
                    end
                end
            end,

            loadLayout = function(self, path, props)
                if(fs.exists(path))then
                    local renderContext = {}
                    renderContext.env = _ENV
                    renderContext.env.props = props
                    local f = fs.open(path, "r")
                    local nodeTree = XMLParser.parseText(f.readAll())
                    f.close()
                    lastXMLReferences = {}
                    maybeExecuteScript(nodeTree, renderContext)
                    self:setValuesByXMLData(nodeTree, renderContext)
                end
                return self
            end,

            getXMLElements = function(self)
                return lastXMLReferences
            end,
        }
        return object
    end
}
