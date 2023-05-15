local utils = require("utils")
local uuid = utils.uuid
local xmlValue = utils.xmlValue

local function newNode(name)
    local node = {}
    node.___value = nil
    node.___name = name
    node.___children = {}
    node.___props = {}
    node.___reactiveProps = {}

    function node:value() return self.___value end
    function node:setValue(val) self.___value = val end
    function node:name() return self.___name end
    function node:setName(name) self.___name = name end
    function node:children() return self.___children end
    function node:numChildren() return #self.___children end
    function node:addChild(child)
        if self[child:name()] ~= nil then
            if type(self[child:name()].name) == "function" then
                local tempTable = {}
                table.insert(tempTable, self[child:name()])
                self[child:name()] = tempTable
            end
            table.insert(self[child:name()], child)
        else
            self[child:name()] = child
        end
        table.insert(self.___children, child)
    end

    function node:properties() return self.___props end
    function node:numProperties() return #self.___props end
    function node:addProperty(name, value)
        local lName = "@" .. name
        if self[lName] ~= nil then
            if type(self[lName]) == "string" then
                local tempTable = {}
                table.insert(tempTable, self[lName])
                self[lName] = tempTable
            end
            table.insert(self[lName], value)
        else
            self[lName] = value
        end
        table.insert(self.___props, { name = name, value = self[lName] })
    end

    function node:reactiveProperties() return self.___reactiveProps end
    function node:addReactiveProperty(name, value)
        self.___reactiveProps[name] = value
    end

    return node
end

local XmlParser = {}

function XmlParser:ToXmlString(value)
    value = string.gsub(value, "&", "&amp;"); -- '&' -> "&amp;"
    value = string.gsub(value, "<", "&lt;"); -- '<' -> "&lt;"
    value = string.gsub(value, ">", "&gt;"); -- '>' -> "&gt;"
    value = string.gsub(value, "\"", "&quot;"); -- '"' -> "&quot;"
    value = string.gsub(value, "([^%w%&%;%p%\t% ])",
        function(c)
            return string.format("&#x%X;", string.byte(c))
        end);
    return value;
end

function XmlParser:FromXmlString(value)
    value = string.gsub(value, "&#x([%x]+)%;",
        function(h)
            return string.char(tonumber(h, 16))
        end);
    value = string.gsub(value, "&#([0-9]+)%;",
        function(h)
            return string.char(tonumber(h, 10))
        end);
    value = string.gsub(value, "&quot;", "\"");
    value = string.gsub(value, "&apos;", "'");
    value = string.gsub(value, "&gt;", ">");
    value = string.gsub(value, "&lt;", "<");
    value = string.gsub(value, "&amp;", "&");
    return value;
end

function XmlParser:ParseProps(node, s)
    string.gsub(s, "(%w+)=([\"'])(.-)%2", function(w, _, a)
        node:addProperty(w, self:FromXmlString(a))
    end)
end

function XmlParser:ParseReactiveProps(node, s)
    string.gsub(s, "(%w+)={(.-)}", function(w, a)
        node:addReactiveProperty(w, a)
    end)
end

function XmlParser:ParseXmlText(xmlText)
    local stack = {}
    local top = newNode()
    table.insert(stack, top)
    local ni, c, label, xarg, empty
    local i, j = 1, 1
    while true do
        ni, j, c, label, xarg, empty = string.find(xmlText, "<(%/?)([%w_:]+)(.-)(%/?)>", i)
        if not ni then break end
        local text = string.sub(xmlText, i, ni - 1);
        if not string.find(text, "^%s*$") then
            local lVal = (top:value() or "") .. self:FromXmlString(text)
            stack[#stack]:setValue(lVal)
        end
        if empty == "/" then -- empty element tag
            local lNode = newNode(label)
            self:ParseProps(lNode, xarg)
            self:ParseReactiveProps(lNode, xarg)
            top:addChild(lNode)
        elseif c == "" then -- start tag
            local lNode = newNode(label)
            self:ParseProps(lNode, xarg)
            self:ParseReactiveProps(lNode, xarg)
            table.insert(stack, lNode)
    top = lNode
        else -- end tag
            local toclose = table.remove(stack) -- remove top

            top = stack[#stack]
            if #stack < 1 then
                error("XmlParser: nothing to close with " .. label)
            end
            if toclose:name() ~= label then
                error("XmlParser: trying to close " .. toclose.name .. " with " .. label)
            end
            top:addChild(toclose)
        end
        i = j + 1
    end
    local text = string.sub(xmlText, i);
    if #stack > 1 then
        error("XmlParser: unclosed " .. stack[#stack]:name())
    end
    return top
end

local function maybeExecuteScript(data, renderContext)
    local script = xmlValue('script', data)
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
        local expression = data:reactiveProperties()[event]
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
            updateSpecifiedValuesByXMLData = function(self, data, valueNames)
                for _, name in ipairs(valueNames) do
                    local value = xmlValue(name, data)
                    if (value ~= nil) then
                        self:setProperty(name, value)
                    end
                end
            end,

            setValuesByXMLData = function(self, data, renderContext)
                renderContext.env[self:getName()] = self
                for prop, expression in pairs(data:reactiveProperties()) do
                    local update = function()
                        local value = load("return " .. expression, nil, "t", renderContext.env)()
                        self:setProperty(prop, value)
                    end
                    basalt.effect(update)
                end
                self:updateSpecifiedValuesByXMLData(data, {
                    "x",
                    "y",
                    "width",
                    "height",
                    "background",
                    "foreground"
                })
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
                self:updateSpecifiedValuesByXMLData(data, {
                    "value"
                })
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
                if (node.properties ~= nil) then
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
            local props = {}
            for _, prop in ipairs(node:properties()) do
                props[prop.name] = prop.value
            end
            local updateFns = {}
            for prop, expression in pairs(node:reactiveProperties()) do
                updateFns[prop] = basalt.derived(function()
                    return load("return " .. expression, nil, "t", renderContext.env)()
                end)
            end
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
    
                local children = data:children()
                local _OBJECTS = basalt.getObjects()

                for _, childNode in pairs(children) do
                    local tagName = childNode.___name
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
                    local data = XmlParser:ParseXmlText(f.readAll())
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

    BaseFrame = function(base, basalt)
        local object = {
            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                self:updateSpecifiedValuesByXMLData(data, {
                    "xOffset",
                    "yOffset"
                })
                return self
            end,
        }
        return object
    end,

    Frame = function(base, basalt)
        local object = {
            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                self:updateSpecifiedValuesByXMLData(data, {
                    "xOffset",
                    "yOffset"
                })
                return self
            end,
        }
        return object
    end,

    Flexbox = function(base, basalt)
        local object = {
            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                self:updateSpecifiedValuesByXMLData(data, {
                    "flexDirection",
                    "justifyContent",
                    "alignItems",
                    "spacing"
                })
                return self
            end,
        }
        return object
    end,

    Button = function(base, basalt)
        local object = {
            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                self:updateSpecifiedValuesByXMLData(data, {
                    "text",
                    "horizontalAlign",
                    "verticalAlign"
                })
                return self
            end,
        }
        return object
    end,

    Label = function(base, basalt)
        local object = {
            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                self:updateSpecifiedValuesByXMLData(data, {
                    "text",
                    "textAlign"
                })
                return self
            end,
        }
        return object
    end,

    Input = function(base, basalt)
        local object = {
            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                self:updateSpecifiedValuesByXMLData(data, {
                    "defaultText",
                    "defaultFG",
                    "defaultBG",
                    "offset",
                    "textOffset",
                    "text",
                    "inputLimit"
                })
                return self
            end,
        }
        return object
    end,

    Image = function(base, basalt)
        local object = {
            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                self:updateSpecifiedValuesByXMLData(data, {
                    "xOffset",
                    "yOffset",
                    "path",
                    "usePalette",
                    "play"
                })
                return self
            end,
        }
        return object
    end,

    Checkbox = function(base, basalt)
        local object = {
            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                self:updateSpecifiedValuesByXMLData(data, {
                    "text",
                    "checked",
                    "textPosition",
                    "activeSymbol",
                    "inactiveSymbol"
                })
                return self
            end,
        }
        return object
    end,

    Program = function(base, basalt)
        local object = {
            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                self:updateSpecifiedValuesByXMLData(data, {
                    "execute"
                })
                return self
            end,
        }
        return object
    end,

    Progressbar = function(base, basalt)
        local object = {
            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                self:updateSpecifiedValuesByXMLData(data, {
                    "direction",
                    "activeBarColor",
                    "activeBarSymbol",
                    "activeBarSymbolColor",
                    "backgroundSymbol",
                    "progress"
                })
                return self
            end,
        }
        return object
    end,

    Slider = function(base, basalt)
        local object = {
            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                self:updateSpecifiedValuesByXMLData(data, {
                    "symbol",
                    "symbolColor",
                    "index",
                    "maxValue",
                    "barType"
                })
                return self
            end,
        }
        return object
    end,

    Scrollbar = function(base, basalt)
        local object = {
            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                self:updateSpecifiedValuesByXMLData(data, {
                    "symbol",
                    "symbolBG",
                    "symbolFG",
                    "symbolSize",
                    "scrollAmount",
                    "index",
                    "barType"
                })
                return self
            end,
        }
        return object
    end,

    MonitorFrame = function(base, basalt)
        local object = {
            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                self:updateSpecifiedValuesByXMLData(data, {
                    "monitor"
                })
                return self
            end,
        }
        return object
    end,

    Switch = function(base, basalt)
        local object = {
            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                self:updateSpecifiedValuesByXMLData(data, {
                    "symbol",
                    "activeBackground",
                    "inactiveBackground"
                })
                return self
            end,
        }
        return object
    end,

    Textfield = function(base, basalt)
        local object = {
            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                self:updateSpecifiedValuesByXMLData(data, {
                    "selectionBG",
                    "selectionFG",
                    "xOffset",
                    "yOffset"
                })


                if(data["lines"]~=nil)then
                    local l = data["lines"]["line"]
                    if(l.properties~=nil)then l = {l} end
                    for _,v in pairs(l)do
                        self:addLine(v:value())
                    end
                end
                if(data["keywords"]~=nil)then
                    for k,v in pairs(data["keywords"])do
                        if(colors[k]~=nil)then
                            local entry = v
                            if(entry.properties~=nil)then entry = {entry} end
                            local tab = {}
                            for a,b in pairs(entry)do
                                local keywordList = b["keyword"]
                                if(b["keyword"].properties~=nil)then keywordList = {b["keyword"]} end
                                for c,d in pairs(keywordList)do
                                    table.insert(tab, d:value())
                                end
                            end
                            self:addKeywords(colors[k], tab)
                        end
                    end
                end
                if(data["rules"]~=nil)then
                    if(data["rules"]["rule"]~=nil)then
                        local tab = data["rules"]["rule"]
                        if(data["rules"]["rule"].properties~=nil)then tab = {data["rules"]["rule"]} end
                        for k,v in pairs(tab)do

                            if(xmlValue("pattern", v)~=nil)then
                                self:addRule(xmlValue("pattern", v), colors[xmlValue("fg", v)], colors[xmlValue("bg", v)])
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
                local script = xmlValue("start", data)~=nil
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
                self:updateSpecifiedValuesByXMLData(data, {
                    "start",
                    "time"
                })
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
                self:updateSpecifiedValuesByXMLData(data, {
                    "textAlign",
                    "offset",
                    "selectionBg",
                    "selectionFg",
                    "scrollable"
                })

                if(data["item"]~=nil)then
                    local tab = data["item"]
                    if(tab.properties~=nil)then tab = {tab} end
                    for _,v in pairs(tab)do
                        if(self:getType()~="Radio")then
                            self:addItem(xmlValue("text", v), colors[xmlValue("bg", v)], colors[xmlValue("fg", v)])
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
                self:updateSpecifiedValuesByXMLData(data, {
                    "dropdownWidth",
                    "dropdownHeight"
                })
                return self
            end,
        }
        return object
    end,

    Radio = function(base, basalt)
        local object = {
            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                self:updateSpecifiedValuesByXMLData(data, {
                    "selectionBg",
                    "selectionFg",
                    "defaultBg",
                    "defaultFg"
                })

                if(data["item"]~=nil)then
                    local tab = data["item"]
                    if(tab.properties~=nil)then tab = {tab} end
                    for _,v in pairs(tab)do
                        self:addItem(xmlValue("text", v), xmlValue("x", v), xmlValue("y", v), colors[xmlValue("bg", v)], colors[xmlValue("fg", v)])
                    end
                end
                return self
            end,
        }
        return object
    end,

    Menubar = function(base, basalt)
        local object = {
            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                self:updateSpecifiedValuesByXMLData(data, {
                    "space",
                    "scrollable"
                })
                return self
            end,
        }
        return object
    end,

    Graph = function(base, basalt)
        local object = {
            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                self:updateSpecifiedValuesByXMLData(data, {
                    "maxEntries",
                    "graphType",
                    "minValue",
                    "maxValue",
                    "graphSymbol",
                    "graphSymbolColor"
                })
                if(data["item"]~=nil)then
                    local tab = data["item"]
                    if(tab.properties~=nil)then tab = {tab} end
                    for _,_ in pairs(tab)do
                        self:addDataPoint(xmlValue("value"))
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
                self:updateSpecifiedValuesByXMLData(data, {
                    "space",
                    "scrollable",
                    "selectionBg",
                    "selectionFg",
                    "xOffset",
                    "yOffset"
                })
                local function addNode(node, data)
                    if(data["node"]~=nil)then
                        local tab = data["node"]
                        if(tab.properties~=nil)then tab = {tab} end
                        for _,v in pairs(tab)do
                            local n = node:addNode(xmlValue("text", v), colors[xmlValue("bg", v)], colors[xmlValue("fg", v)])
                            addNode(n, v)
                        end
                    end
                end
                if(data["node"]~=nil)then
                    local tab = data["node"]
                    if(tab.properties~=nil)then tab = {tab} end
                    for _,v in pairs(tab)do
                        local n = self:addNode(xmlValue("text", v), colors[xmlValue("bg", v)], colors[xmlValue("fg", v)])
                        addNode(n, v)
                    end
                end


                return self
            end,
        }
        return object
    end,

}
