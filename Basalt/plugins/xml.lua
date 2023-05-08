local utils = require("utils")
local uuid = utils.uuid
local xmlValue = utils.xmlValue

local function newNode(name)
    local node = {}
    node.___value = nil
    node.___name = name
    node.___children = {}
    node.___props = {}
    node.___dynProps = {}

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

    function node:dynamicProperties() return self.___dynProps end
    function node:numDynamicProperties() return #self.___dynProps end
    function node:addDynamicProperty(name, value)
        self.___dynProps[name] = value
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

function XmlParser:ParseArgs(node, s)
    string.gsub(s, "(%w+)=([\"'])(.-)%2", function(w, _, a)
        node:addProperty(w, self:FromXmlString(a))
    end)
end

function XmlParser:ParseDynamicArgs(node, s)
    string.gsub(s, "(%w+)={(.-)}", function(w, a)
        node:addDynamicProperty(w, a)
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
            self:ParseArgs(lNode, xarg)
            self:ParseDynamicArgs(lNode, xarg)
            top:addChild(lNode)
        elseif c == "" then -- start tag
            local lNode = newNode(label)
            self:ParseArgs(lNode, xarg)
            self:ParseDynamicArgs(lNode, xarg)
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

local function executeScript(scripts)
    for k,v in pairs(scripts)do
        if(k~="env")then
            for a,b in pairs(v)do
                load(b, nil, "t", scripts.env)()
            end
        end
    end
end

local function registerFunctionEvent(self, data, event, scripts)
    local eventEnv = scripts.env
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

return {
    VisualObject = function(base, basalt)

        local object = {
            updateValue = function(self, name, value)
                if (value == null) then return end
                local x, y = self:getPosition()
                local w, h = self:getSize()
                if (name == "x") then
                    self:setPosition(value, y)
                elseif (name == "y") then
                    self:setPosition(x, value)
                elseif (name == "width") then
                    self:setSize(value, h)
                elseif (name == "height") then
                    self:setSize(w, value)
                elseif (name == "background") then
                    self:setBackground(colors[value])
                elseif (name == "foreground") then
                    self:setForeground(colors[value])
                end
            end,

            updateSpecifiedValuesByXMLData = function(self, data, valueNames)
                for _, name in ipairs(valueNames) do
                    local value = xmlValue(name, data)
                    if (value ~= nil) then
                        self:updateValue(name, value)
                    end
                end
            end,

            setValuesByXMLData = function(self, data, scripts)
                scripts.env[self:getName()] = self
                for k,v in pairs(data:dynamicProperties()) do
                    local sharedVariable = string.sub(v, 8, -1)
                    local sharedObservers = scripts.env.sharedObservers
                    if (sharedObservers[sharedVariable]) == nil then
                        sharedObservers[sharedVariable] = {}
                    end
                    table.insert(
                        sharedObservers[sharedVariable],
                        function(val)
                            self:updateValue(k, val)
                        end
                    )
                end

                self:updateSpecifiedValuesByXMLData(data, {
                    "x",
                    "y",
                    "width",
                    "height",
                    "background",
                    "foreground"
                })


                if(xmlValue("script", data)~=nil)then
                    if(scripts[1]==nil)then
                        scripts[1] = {}
                    end
                    table.insert(scripts[1], xmlValue("script", data))
                end

                local events = {"onClick", "onClickUp", "onHover", "onScroll", "onDrag", "onKey", "onKeyUp", "onRelease", "onChar", "onGetFocus", "onLoseFocus", "onResize", "onReposition", "onEvent", "onLeave"}
                for _,v in pairs(events)do
                    if(xmlValue(v, data)~=nil)then 
                        registerFunctionEvent(self, xmlValue(v, data), self[v], scripts)
                    end
                end

                return self
            end,
        }
        return object
    end,

    ChangeableObject = function(base, basalt)
        local object = {
            updateValue = function(self, name, value)
                if (value == null) then return end
                base.updateValue(self, name, value)
                if (name == "value") then
                    self:setValue(value)
                end
            end,

            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
                self:updateSpecifiedValuesByXMLData(data, {
                    "value"
                })
                if(xmlValue("onChange", data)~=nil)then
                    registerFunctionEvent(self, xmlValue("onChange", data), self.onChange, scripts)
                end
                return self
            end,
        }
        return object
    end,

    BaseFrame = function(base, basalt)
        local lastXMLReferences = {}

        local function xmlDefaultValues(data, obj, scripts)
            if(obj~=nil)then
                obj:setValuesByXMLData(data, scripts)
            end
        end

        local function addXMLObjectType(tab, f, self, scripts)
            if(tab~=nil)then
                if(tab.properties~=nil)then tab = {tab} end
                for k,v in pairs(tab)do
                    local obj = f(self, v["@id"] or uuid())
                    lastXMLReferences[obj:getName()] = obj
                    xmlDefaultValues(v, obj, scripts)
                end
            end
        end

        local object = {
            updateValue = function(self, name, value)
                if (value == null) then return end
                base.updateValue(self, name, value)
                local xOffset, yOffset = self:getOffset()
                if (name == "layout") then
                    self:setLayout(value)
                elseif (name == "xOffset") then
                    self:setOffset(value, yOffset)
                end
            end,

            setValuesByXMLData = function(self, data, scripts)
                lastXMLReferences = {}
                base.setValuesByXMLData(self, data, scripts)
                self:updateSpecifiedValuesByXMLData(data, {
                    "layout",
                    "xOffset"
                })
    
                local objectList = data:children()
                local _OBJECTS = basalt.getObjects()
                
                for k,v in pairs(objectList)do
                    if(v.___name~="animation")then
                        local name = v.___name:gsub("^%l", string.upper)
                        if(_OBJECTS[name]~=nil)then
                            addXMLObjectType(v, self["add"..name], self, scripts)
                        end
                    end
                end
                
                addXMLObjectType(data["animation"], self.addAnimation, self, scripts)
                return self
            end,

            getXMLElements = function(self)
                return lastXMLReferences
            end,

            loadLayout = function(self, path)
                if(fs.exists(path))then
                    local scripts = {}
                    scripts.env = _ENV
                    scripts.env.basalt = basalt
                    scripts.env.shared = {}
                    scripts.env.sharedObservers = {}
                    local shared = {}
                    setmetatable(scripts.env.shared, {
                        __index = function(_, k)
                            return shared[k]
                        end,
                        __newindex = function(_, k, v)
                            local observers = scripts.env.sharedObservers[k]
                            if observers ~= nil then
                                for _,observer in pairs(observers) do
                                    observer(v)
                                end
                            end
                            shared[k] = v
                        end
                    })
                    local f = fs.open(path, "r")
                    local data = XmlParser:ParseXmlText(f.readAll())
                    f.close()
                    lastXMLReferences = {}
                    self:setValuesByXMLData(data, scripts)
                    executeScript(scripts)
                end
                return self
            end,

        }
        return object
    end,

    Frame = function(base, basalt)
        local lastXMLReferences = {}

        local function xmlDefaultValues(data, obj, scripts)
            if(obj~=nil)then
                obj:setValuesByXMLData(data, scripts)
            end
        end

        local function addXMLObjectType(tab, f, self, scripts)
            if(tab~=nil)then
                if(tab.properties~=nil)then tab = {tab} end
                for k,v in pairs(tab)do
                    local obj = f(self, v["@id"] or uuid())
                    lastXMLReferences[obj:getName()] = obj
                    xmlDefaultValues(v, obj, scripts)
                end
            end
        end

        local object = {
            updateValue = function(self, name, value)
                if (value == null) then return end
                base.updateValue(self, name, value)
                local xOffset, yOffset = self:getOffset()
                if (name == "layout") then
                    self:setLayout(value)
                elseif (name == "xOffset") then
                    self:setOffset(value, yOffset)
                elseif (name == "yOffset") then
                    self:setOffset(xOffset, value)
                end
            end,

            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
                self:updateSpecifiedValuesByXMLData(data, {
                    "layout",
                    "xOffset",
                    "yOffset"
                })
    
                local objectList = data:children()
                local _OBJECTS = basalt.getObjects()
                
                for k,v in pairs(objectList)do
                    if(v.___name~="animation")then
                        local name = v.___name:gsub("^%l", string.upper)
                        if(_OBJECTS[name]~=nil)then
                            addXMLObjectType(v, self["add"..name], self, scripts)
                        end
                    end
                end
                
                addXMLObjectType(data["animation"], self.addAnimation, self, scripts)
                return self
            end,

            getXMLElements = function(self)
                return lastXMLReferences
            end,

            loadLayout = function(self, path)
                if(fs.exists(path))then
                    local scripts = {}
                    scripts.env = _ENV
                    scripts.env.basalt = basalt
                    scripts.env.main = self
                    scripts.env.shared = {}
                    local f = fs.open(path, "r")
                    local data = XmlParser:ParseXmlText(f.readAll())
                    f.close()
                    lastXMLReferences = {}
                    self:setValuesByXMLData(data, scripts)
                    executeScript(scripts)
                end
                return self
            end,
        }
        return object
    end,

    Flexbox = function(base, basalt)
        local object = {
            updateValue = function(self, name, value)
                if (value == null) then return end
                base.updateValue(self, name, value)
                if (name == "flexDirection") then
                    self:setFlexDirection(value)
                elseif (name == "justifyContent") then
                    self:setJustifyContent(value)
                elseif (name == "spacing") then
                    self:setSpacing(value)
                end
            end,

            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
                self:updateSpecifiedValuesByXMLData(data, {
                    "flexDirection",
                    "justifyContent",
                    "spacing"
                })
                return self
            end,
        }
        return object
    end,

    Button = function(base, basalt)
        local object = {
            updateValue = function(self, name, value)
                if (value == null) then return end
                base.updateValue(self, name, value)
                if (name == "text") then
                    self:setText(value)
                elseif (name == "horizontalAlign") then
                    self:setHorizontalAlign(value)
                elseif (name == "verticalAlign") then
                    self:setVerticalAlign(value)
                end
            end,

            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
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
            updateValue = function(self, name, value)
                if (value == null) then return end
                base.updateValue(self, name, value)
                if (name == "text") then
                    self:setText(value)
                elseif (name == "align") then
                    self:setAlign(value)
                end
            end,

            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
                self:updateSpecifiedValuesByXMLData(data, {
                    "text",
                    "align"
                })
                return self
            end,
        }
        return object
    end,

    Input = function(base, basalt)
        local object = {
            updateValue = function(self, name, value)
                if (value == null) then return end
                base.updateValue(self, name, value)
                local defaultText, defaultFG, defaultBG = self:getDefaultText()
                if (name == "defaultText") then
                    self:setDefaultText(value, defaultFG, defaultBG)
                elseif (name == "defaultFG") then
                    self:setDefaultText(defaultText, value, defaultBG)
                elseif (name == "defaultBG") then
                    self:setDefaultText(defaultText, defaultFG, value)
                elseif (name == "offset") then
                    self:setOffset(value)
                elseif (name == "textOffset") then
                    self:setTextOffset(value)
                elseif (name == "text") then
                    self:setText(value)
                elseif (name == "inputLimit") then
                    self:setInputLimit(value)
                end
            end,

            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
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
            updateValue = function(self, name, value)
                if (value == null) then return end
                base.updateValue(self, name, value)
                local xOffset, yOffset = self:getOffset()
                if (name == "xOffset") then
                    self:setOffset(value, yOffset)
                elseif (name == "yOffset") then
                    self:setOffset(xOffset, value)
                elseif (name == "path") then
                    self:loadImage(value)
                elseif (name == "usePalette") then
                    self:usePalette(value)
                elseif (name == "play") then
                    self:play(value)
                end
            end,

            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
                local xOffset, yOffset = self:getOffset()
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
            updateValue = function(self, name, value)
                if (value == null) then return end
                base.updateValue(self, name, value)
                local activeSymbol, inactiveSymbol = self:getSymbol()
                if (name == "text") then
                    self:setText(value)
                elseif (name == "checked") then
                    self:setChecked(value)
                elseif (name == "textPosition") then
                    self:setTextPosition(value)
                elseif (name == "activeSymbol") then
                    self:setSymbol(value, inactiveSymbol)
                elseif (name == "inactiveSymbol") then
                    self:setSymbol(activeSymbol, value)
                end
            end,

            setValuesByXMLData = function(self, dat, scriptsa)
                base.setValuesByXMLData(self, data, scripts)
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
            updateValue = function(self, name, value)
                if (value == null) then return end
                base.updateValue(self, name, value)
                if (name == "execute") then
                    self:execute(value)
                end
            end,

            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
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
            updateValue = function(self, name, value)
                if (value == null) then return end
                base.updateValue(self, name, value)
                local activeBarColor, activeBarSymbol, activeBarSymbolCol = self:getProgressBar()
                if (name == "direction") then
                    self:setDirection(value)
                elseif (name == "activeBarColor") then
                    self:setProgressBar(value, activeBarSymbol, activeBarSymbolCol)
                elseif (name == "activeBarSymbol") then
                    self:setProgressBar(activeBarColor, value, activeBarSymbolCol)
                elseif (name == "activeBarSymbolColor") then
                    self:setProgressBar(activeBarColor, activeBarSymbol, value)
                elseif (name == "backgroundSymbol") then
                    self:setBackgroundSymbol(value)
                elseif (name == "progress") then
                    self:setProgress(value)
                end
            end,

            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
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
            updateValue = function(self, name, value)
                if (value == null) then return end
                base.updateValue(self, name, value)
                if (name == "symbol") then
                    self:setSymbol(value)
                elseif (name == "symbolColor") then
                    self:setSymbolColor(value)
                elseif (name == "index") then
                    self:setIndex(value)
                elseif (name == "maxValue") then
                    self:setMaxValue(value)
                elseif (name == "barType") then
                    self:setBarType(value)
                end
            end,

            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
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
            updateValue = function(self, name, value)
                if (value == null) then return end
                base.updateValue(self, name, value)
                if (name == "symbol") then
                    self:setSymbol(value)
                elseif (name == "symbolColor") then
                    self:setSymbolColor(value)
                elseif (name == "symbolSize") then
                    self:setSymbolSize(value)
                elseif (name == "scrollAmount") then
                    self:setScrollAmount(value)
                elseif (name == "index") then
                    self:setIndex(value)
                elseif (name == "maxValue") then
                    self:setMaxValue(value)
                elseif (name == "barType") then
                    self:setBarType(value)
                end
            end,

            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
                self:updateSpecifiedValuesByXMLData(data, {
                    "symbol",
                    "symbolColor",
                    "symbolSize",
                    "scrollAmount",
                    "index",
                    "maxValue",
                    "barType"
                })
                return self
            end,
        }
        return object
    end,

    MonitorFrame = function(base, basalt)
        local object = {
            updateValue = function(self, name, value)
                if (value == null) then return end
                base.updateValue(self, name, value)
                if (name == "monitor") then
                    self:setMonitor(value)
                end
            end,

            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
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
            updateValue = function(self, name, value)
                if (value == null) then return end
                base.updateValue(self, name, value)
                if (name == "symbol") then
                    self:setSymbol(value)
                elseif (name == "activeBackground") then
                    self:setActiveBackground(value)
                elseif (name == "inactiveBackground") then
                    self:setInactiveBackground(value)
                end
            end,

            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
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
            updateValue = function(self, name, value)
                if (value == null) then return end
                base.updateValue(self, name, value)
                local fgSel, bgSel = self:getSelection()
                local xOffset, yOffset = self:getOffset()
                if (name == "bgSelection") then
                    self:setSelection(fgSel, value)
                elseif (name == "fgSelection") then
                    self:setSelection(value, bgSel)
                elseif (name == "xOffset") then
                    self:setOffset(value, yOffset)
                elseif (name == "yOffset") then
                    self:setOffset(xOffset, value)
                end
            end,

            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
                self:updateSpecifiedValuesByXMLData(data, {
                    "bgSelection",
                    "fgSelection",
                    "xOffset",
                    "yOffset"
                })


                if(data["lines"]~=nil)then
                    local l = data["lines"]["line"]
                    if(l.properties~=nil)then l = {l} end
                    for k,v in pairs(l)do
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
            setValuesByXMLData = function(self, data, scripts)
                if(xmlValue("start", data)~=nil)then
                    local f = load(xmlValue("start", data), nil, "t", scripts.env)
                    self:start(f)
                end
                return self
            end,
        }
        return object
    end,

    Timer = function(base, basalt)
        local object = {
            updateValue = function(self, name, value)
                if (value == null) then return end
                base.updateValue(self, name, value)
                if (name == "start") then
                    self:start(value)
                elseif (name == "time") then
                    self:setTime(value)
                end
            end,

            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
                self:updateSpecifiedValuesByXMLData(data, {
                    "start",
                    "time"
                })

                if(xmlValue("onCall", data)~=nil)then 
                    registerFunctionEvent(self, xmlValue("onCall", data), self.onCall, scripts)
                end
                return self
            end,
        }
        return object
    end,

    List = function(base, basalt)
        local object = {
            updateValue = function(self, name, value)
                if (value == null) then return end
                base.updateValue(self, name, value)
                local selBg, selFg = self:getSelectionColor()
                if (name == "align") then
                    self:setTextAlign(value)
                elseif (name == "offset") then
                    self:setOffset(value)
                elseif (name == "selectionBg") then
                    self:setSelectionColor(value, selFg)
                elseif (name == "selectionFg") then
                    self:setSelectionColor(selBg, value)
                elseif (name == "scrollable") then
                    self:setScrollable(value)
                end
            end,

            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
                self:updateSpecifiedValuesByXMLData(data, {
                    "align",
                    "offset",
                    "selectionBg",
                    "selectionFg",
                    "scrollable"
                })

                if(data["item"]~=nil)then
                    local tab = data["item"]
                    if(tab.properties~=nil)then tab = {tab} end
                    for k,v in pairs(tab)do
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
            updateValue = function(self, name, value)
                if (value == null) then return end
                base.updateValue(self, name, value)
                local w, h = self:getDropdownSize()
                if (name == "dropdownWidth") then
                    self:setDropdownSize(value, h)
                elseif (name == "dropdownHeight") then
                    self:setDropdownSize(w, value)
                end
            end,

            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
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
            updateValue = function(self, name, value)
                if (value == null) then return end
                base.updateValue(self, name, value)
                local selBg, selFg = self:getBoxSelectionColor()
                local defBg, defFg = self:setBoxDefaultColor()
                if (name == "selectionBg") then
                    self:setBoxSelectionColor(value, selFg)
                elseif (name == "selectionFg") then
                    self:setBoxSelectionColor(selBg, value)
                elseif (name == "defaultBg") then
                    self:setBoxDefaultColor(value, defFg)
                elseif (name == "defaultFg") then
                    self:setBoxDefaultColor(defBg, value)
                end
            end,

            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
                self:updateSpecifiedValuesByXMLData(data, {
                    "selectionBg",
                    "selectionFg",
                    "defaultBg",
                    "defaultFg"
                })

                if(data["item"]~=nil)then
                    local tab = data["item"]
                    if(tab.properties~=nil)then tab = {tab} end
                    for k,v in pairs(tab)do
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
            updateValue = function(self, name, value)
                if (value == null) then return end
                base.updateValue(self, name, value)
                if (name == "space") then
                    self:setSpace(value)
                elseif (name == "scrollable") then
                    self:setScrollable(value)
                end
            end,

            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
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
            updateValue = function(self, name, value)
                if (value == null) then return end
                base.updateValue(self, name, value)
                local symbol, symbolCol = self:getGraphSymbol()
                if (name == "maxEntries") then
                    self:setMaxEntries(value)
                elseif (name == "type") then
                    self:setType(value)
                elseif (name == "minValue") then
                    self:setMinValue(value)
                elseif (name == "maxValue") then
                    self:setMaxValue(value)
                elseif (name == "symbol") then
                    self:setGraphSymbol(value, symbolCol)
                elseif (name == "symbolColor") then
                    self:setGraphSymbol(symbol, value)
                end
            end,

            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
                self:updateSpecifiedValuesByXMLData(data, {
                    "maxEntries",
                    "type",
                    "minValue",
                    "maxValue",
                    "symbol",
                    "symbolColor"
                })
                if(data["item"]~=nil)then
                    local tab = data["item"]
                    if(tab.properties~=nil)then tab = {tab} end
                    for k,v in pairs(tab)do
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
            updateValue = function(self, name, value)
                if (value == null) then return end
                base.updateValue(self, name, value)
                local selBg, selFg = self:getSelectionColor()
                local xOffset, yOffset = self:getOffset()
                if (name == "space") then
                    self:setSpace(value)
                elseif (name == "scrollable") then
                    self:setScrollable(value)
                elseif (name == "selectionBg") then
                    self:setSelectionColor(value, selFg)
                elseif (name == "selectionFg") then
                    self:setSelectionColor(selBg, value)
                elseif (name == "xOffset") then
                    self:setOffset(value, yOffset)
                elseif (name == "yOffset") then
                    self:setOffset(xOffset, value)
                end
            end,

            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
                local selBg, selFg = self:getSelectionColor()
                local xOffset, yOffset = self:getOffset()
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
                        for k,v in pairs(tab)do
                            local n = node:addNode(xmlValue("text", v), colors[xmlValue("bg", v)], colors[xmlValue("fg", v)])
                            addNode(n, v)
                        end
                    end
                end
                if(data["node"]~=nil)then
                    local tab = data["node"]
                    if(tab.properties~=nil)then tab = {tab} end
                    for k,v in pairs(tab)do
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
