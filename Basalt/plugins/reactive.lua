local XMLParser = require("xmlParser")
local utils = require("utils")
local uuid = utils.uuid

local function maybeExecuteScript(data, renderContext)
    local script = XMLParser.XmlValue('script', data)
    if (script ~= nil) then
        load(script, nil, "t", renderContext.env)()
    end
end

local function registerFunctionEvent(self, data, event, renderContext)
    local eventEnv = renderContext.env
    if(data:sub(1,1)=="$")then
        local data = data:sub(2)
        event(self, self:getBasalt().getVariable(data))
    else
        event(self, function(...)
            eventEnv.event = {...}
            local success, msg = pcall(load(data, nil, "t", eventEnv))
            if not success then
                error("XML Error: "..msg)
            end
        end)
    end
end

local function registerFunctionEvents(self, data, events, renderContext)
    for _, event in pairs(events) do
        local expression = data.attributes[event]
        if (expression ~= nil) then
            registerFunctionEvent(self, expression .. "()", self[event], renderContext)
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
            setValuesByXMLData = function(self, data, renderContext)
                renderContext.env[self:getName()] = self
                for attribute, expression in pairs(data.attributes) do
                    local update = function()
                        local value = load("return " .. expression, nil, "t", renderContext.env)()
                        self:setProperty(attribute, value)
                    end
                    basalt.effect(update)
                end
                registerFunctionEvents(self, data, {
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
            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                registerFunctionEvent(self, data, {
                    "onChange"
                }, renderContext)
                return self
            end,
        }
        return object
    end,

    Container = function(base, basalt)
        local lastXMLReferences = {}

        local function xmlDefaultValues(data, obj, renderContext)
            if (obj~=nil) then
                obj:setValuesByXMLData(data, renderContext)
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
            setValuesByXMLData = function(self, data, renderContext)
                lastXMLReferences = {}
                base.setValuesByXMLData(self, data, renderContext)

                local _OBJECTS = basalt.getObjects()

                for _, childNode in pairs(data.children) do
                    local tagName = childNode.name
                    if (tagName ~= "animation") then
                        local layout = renderContext.env[tagName]
                        local objectKey = tagName:gsub("^%l", string.upper)
                        if (layout ~= nil) then
                            insertChildLayout(self, layout, childNode, renderContext)
                        elseif (_OBJECTS[objectKey] ~= nil) then
                            local addFn = self["add" .. objectKey]
                            addXMLObjectType(childNode, addFn, self, renderContext)
                        end
                    end
                end
                
                addXMLObjectType(data["animation"], self.addAnimation, self, renderContext)
                return self
            end,

            loadLayout = function(self, path, props)
                if(fs.exists(path))then
                    local renderContext = {}
                    renderContext.env = _ENV
                    renderContext.env.props = props
                    local f = fs.open(path, "r")
                    local data = XMLParser:ParseXmlText(f.readAll())
                    f.close()
                    lastXMLReferences = {}
                    maybeExecuteScript(data, renderContext)
                    self:setValuesByXMLData(data, renderContext)
                end
                return self
            end,

            getXMLElements = function(self)
                return lastXMLReferences
            end,
        }
        return object
    end,

    Textfield = function(base, basalt)
        local object = {
            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                if(data["lines"]~=nil)then
                    local l = data["lines"]["line"]
                    if(l.attributes~=nil)then l = {l} end
                    for _,v in pairs(l)do
                        self:addLine(v.value)
                    end
                end
                if(data["keywords"]~=nil)then
                    for k,v in pairs(data["keywords"])do
                        if(colors[k]~=nil)then
                            local entry = v
                            if(entry.attributes~=nil)then entry = {entry} end
                            local tab = {}
                            for a,b in pairs(entry)do
                                local keywordList = b["keyword"]
                                if(b["keyword"].attributes~=nil)then keywordList = {b["keyword"]} end
                                for c,d in pairs(keywordList)do
                                    table.insert(tab, d.value)
                                end
                            end
                            self:addKeywords(colors[k], tab)
                        end
                    end
                end
                if(data["rules"]~=nil)then
                    if(data["rules"]["rule"]~=nil)then
                        local tab = data["rules"]["rule"]
                        if(data["rules"]["rule"].attributes~=nil)then tab = {data["rules"]["rule"]} end
                        for k,v in pairs(tab)do

                            if(XMLParser.XmlValue("pattern", v)~=nil)then
                                self:addRule(XMLParser.XmlValue("pattern", v), colors[XMLParser.XmlValue("fg", v)], colors[XMLParser.XmlValue("bg", v)])
                            end
                        end
                    end
                end
                return self
            end,
        }
        return object
    end,

    Thread = function(base, basalt)
        local object = {
            setValuesByXMLData = function(self, data, renderContext)
                local script = XMLParser.XmlValue("start", data)~=nil
                if(script~=nil)then
                    local f = load(script, nil, "t", renderContext.env)
                    self:start(f)
                end
                return self
            end,
        }
        return object
    end,

    Timer = function(base, basalt)
        local object = {
            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                registerFunctionEvents(self, data, {
                    "onCall"
                }, renderContext)
                return self
            end,
        }
        return object
    end,

    List = function(base, basalt)
        local object = {
            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                if(data["item"]~=nil)then
                    local tab = data["item"]
                    if(tab.attributes~=nil)then tab = {tab} end
                    for _,v in pairs(tab)do
                        if(self:getType()~="Radio")then
                            self:addItem(XMLParser.XmlValue("text", v), colors[XMLParser.XmlValue("bg", v)], colors[XMLParser.XmlValue("fg", v)])
                        end
                    end
                end
                return self
            end,
        }
        return object
    end,

    Dropdown = function(base, basalt)
        local object = {
            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                return self
            end,
        }
        return object
    end,

    Radio = function(base, basalt)
        local object = {
            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                if(data["item"]~=nil)then
                    local tab = data["item"]
                    if(tab.attributes~=nil)then tab = {tab} end
                    for _,v in pairs(tab)do
                        self:addItem(XMLParser.XmlValue("text", v), XMLParser.XmlValue("x", v), XMLParser.XmlValue("y", v), colors[XMLParser.XmlValue("bg", v)], colors[XMLParser.XmlValue("fg", v)])
                    end
                end
                return self
            end,
        }
        return object
    end,

    Graph = function(base, basalt)
        local object = {
            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                if(data["item"]~=nil)then
                    local tab = data["item"]
                    if(tab.attributes~=nil)then tab = {tab} end
                    for _,_ in pairs(tab)do
                        self:addDataPoint(XMLParser.XmlValue("value"))
                    end
                end
                return self
            end,
        }
        return object
    end,

    Treeview = function(base, basalt)
        local object = {
            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                local function addNode(node, data)
                    if(data["node"]~=nil)then
                        local tab = data["node"]
                        if(tab.attributes~=nil)then tab = {tab} end
                        for _,v in pairs(tab)do
                            local n = node:addNode(XMLParser.XmlValue("text", v), colors[XMLParser.XmlValue("bg", v)], colors[XMLParser.XmlValue("fg", v)])
                            addNode(n, v)
                        end
                    end
                end
                if(data["node"]~=nil)then
                    local tab = data["node"]
                    if(tab.attributes~=nil)then tab = {tab} end
                    for _,v in pairs(tab)do
                        local n = self:addNode(XMLParser.XmlValue("text", v), colors[XMLParser.XmlValue("bg", v)], colors[XMLParser.XmlValue("fg", v)])
                        addNode(n, v)
                    end
                end


                return self
            end,
        }
        return object
    end,

}
