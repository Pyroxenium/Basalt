local utils = require("utils")
local uuid = utils.uuid

local function newNode(name)
    local node = {}
    node.___value = nil
    node.___name = name
    node.___children = {}
    node.___props = {}

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
        table.insert(self.___props, { name = name, value = self[name] })
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
            top:addChild(lNode)
        elseif c == "" then -- start tag
            local lNode = newNode(label)
            self:ParseArgs(lNode, xarg)
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

function XmlParser:loadFile(xmlFilename, base)
    if not base then
        base = ""
    end

    local path = fs.combine(base, xmlFilename)
    local hFile, err = io.open(path, "r");

    if hFile and not err then
        local xmlText = hFile:read("*a"); -- read file content
        io.close(hFile);
        return self:ParseXmlText(xmlText), nil;
    else
        print(err)
        return nil
    end
end

local function xmlValue(name, tab)
    local var
    if(type(tab)~="table")then return end
    if(tab[name]~=nil)then
        if(type(tab[name])=="table")then
            if(tab[name].value~=nil)then
                var = tab[name]:value()
            end
        end
    end
    if(var==nil)then var = tab["@"..name] end

    if(var=="true")then 
        var = true 
    elseif(var=="false")then 
        var = false
    elseif(tonumber(var)~=nil)then 
        var = tonumber(var)
    end
    return var
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
    if(data:sub(1,1)=="$")then
        local data = data:sub(2)
        event(self, self:getBasalt():getVariable(data))
    else
        event(self, load(data, nil, "t", scripts.env))
    end
end

return { 
    VisualObject = function(base, basalt)

        local object = {
            setValuesByXMLData = function(self, data, scripts)
                local x, y = self:getPosition()
                local w, h = self:getSize()
                if(xmlValue("x", data)~=nil)then x = xmlValue("x", data) end
                if(xmlValue("y", data)~=nil)then y = xmlValue("y", data) end
                if(xmlValue("width", data)~=nil)then w = xmlValue("width", data) end
                if(xmlValue("height", data)~=nil)then h = xmlValue("height", data) end
                if(xmlValue("background", data)~=nil)then self:setBackground(colors[xmlValue("background", data)]) end

                if(xmlValue("script", data)~=nil)then 
                    if(scripts[1]==nil)then
                        scripts[1] = {}
                    end
                    table.insert(scripts[1], xmlValue("script", data))
                end

                local events = {"onClick", "onClickUp", "onHover", "onScroll", "onDrag", "onKey", "onKeyUp", "onRelease", "onChar", "onGetFocus", "onLoseFocus", "onResize", "onReposition", "onEvent", "onLeave"}
                for k,v in pairs(events)do
                    if(xmlValue(v, data)~=nil)then 
                        registerFunctionEvent(self, xmlValue(v, data), self[v], scripts)
                    end
                end
                self:setPosition(x, y)
                self:setSize(w, h)

                return self
            end,
        }
        return object
    end,

    ChangeableObject = function(base, basalt)
        local object = {
            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
                if(xmlValue("value", data)~=nil)then self:setValue(xmlValue("value", data)) end
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
                    table.insert(lastXMLReferences, obj)
                    xmlDefaultValues(v, obj, scripts)
                end
            end
        end

        local object = {                       
            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
                local xOffset, yOffset = self:getOffset()
                if(xmlValue("layout", data)~=nil)then self:addLayout(xmlValue("layout", data)) end
                if(xmlValue("xOffset", data)~=nil)then xOffset = xmlValue("xOffset", data) end
                self:setOffset(xOffset, yOffset)
    
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
                    table.insert(lastXMLReferences, obj)
                    xmlDefaultValues(v, obj, scripts)
                end
            end
        end

        local object = { 
            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
                local xOffset, yOffset = self:getOffset()
                if(xmlValue("layout", data)~=nil)then self:addLayout(xmlValue("layout", data)) end
                if(xmlValue("xOffset", data)~=nil)then xOffset = xmlValue("xOffset", data) end
                if(xmlValue("yOffset", data)~=nil)then yOffset = xmlValue("yOffset", data) end
                self:setOffset(xOffset, yOffset)
    
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

    Button = function(base, basalt)
        local object = { 
            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
                if(xmlValue("text", data)~=nil)then self:setText(xmlValue("text", data)) end
                if(xmlValue("horizontalAlign", data)~=nil)then self:setHorizontalAlign(xmlValue("horizontalAlign", data)) end
                if(xmlValue("verticalAlign", data)~=nil)then self:setText(xmlValue("verticalAlign", data)) end                
                return self
            end,
        }
        return object
    end,

    Label = function(base, basalt)
        local object = { 
            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
                if(xmlValue("text", data)~=nil)then self:setText(xmlValue("text", data)) end
                if(xmlValue("align", data)~=nil)then self:setTextAlign(xmlValue("align", data)) end
                return self
            end,
        }
        return object
    end,

    Input = function(base, basalt)
        local object = { 
            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
                local defaultText, defaultFG, defaultBG = self:getDefaultText()
                if(xmlValue("defaultText", data)~=nil)then defaultText = xmlValue("defaultText", data) end   
                if(xmlValue("defaultFG", data)~=nil)then defaultFG = xmlValue("defaultFG", data) end   
                if(xmlValue("defaultBG", data)~=nil)then defaultBG = xmlValue("defaultBG", data) end   
                self:setDefaultText(defaultText, defaultFG, defaultBG)
                if(xmlValue("offset", data)~=nil)then self:setOffset(xmlValue("offset", data)) end
                if(xmlValue("textOffset", data)~=nil)then self:setTextOffset(xmlValue("textOffset", data)) end
                if(xmlValue("text", data)~=nil)then self:setValue(xmlValue("text", data)) end
                if(xmlValue("inputLimit", data)~=nil)then self:setInputLimit(xmlValue("inputLimit", data)) end
                return self
            end,
        }
        return object
    end,

    Image = function(base, basalt)
        local object = { 
            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
                local xOffset, yOffset = self:getOffset()
                if(xmlValue("xOffset", data)~=nil)then xOffset = xmlValue("xOffset", data) end
                if(xmlValue("yOffset", data)~=nil)then yOffset = xmlValue("yOffset", data) end
                self:setOffset(xOffset, yOffset)
                if(xmlValue("path", data)~=nil)then self:loadImage(xmlValue("path", data)) end
                if(xmlValue("usePalette", data)~=nil)then self:usePalette(xmlValue("usePalette", data)) end
                if(xmlValue("play", data)~=nil)then self:play(xmlValue("play", data)) end
                return self
            end,
        }
        return object
    end,

    Checkbox = function(base, basalt)
        local object = { 
            setValuesByXMLData = function(self, dat, scriptsa)
                base.setValuesByXMLData(self, data, scripts)
                local activeSymbol, inactiveSymbol = self:getSymbol()
                if(xmlValue("text", data)~=nil)then self:setText(xmlValue("text", data)) end
                if(xmlValue("checked", data)~=nil)then self:setChecked(xmlValue("checked", data)) end
                if(xmlValue("textPosition", data)~=nil)then self:setTextPosition(xmlValue("textPosition", data)) end
                if(xmlValue("activeSymbol", data)~=nil)then activeSymbol = xmlValue("activeSymbol", data) end
                if(xmlValue("inactiveSymbol", data)~=nil)then inactiveSymbol = xmlValue("inactiveSymbol", data) end
                self:setSymbol(activeSymbol, inactiveSymbol)
                return self
            end,
        }
        return object
    end,

    Program = function(base, basalt)
        local object = { 
            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
                if(xmlValue("execute", data)~=nil)then self:execute(xmlValue("execute", data)) end
                return self
            end,
        }
        return object
    end,

    Progressbar = function(base, basalt)
        local object = { 
            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
                local activeBarColor, activeBarSymbol, activeBarSymbolCol = self:getProgressBar()
                if(xmlValue("direction", data)~=nil)then self:setDirection(xmlValue("direction", data)) end
                if(xmlValue("activeBarColor", data)~=nil)then activeBarColor = colors[xmlValue("activeBarColor", data)] end
                if(xmlValue("activeBarSymbol", data)~=nil)then activeBarSymbol = xmlValue("activeBarSymbol", data) end
                if(xmlValue("activeBarSymbolColor", data)~=nil)then activeBarSymbolCol = colors[xmlValue("activeBarSymbolColor", data)] end
                if(xmlValue("backgroundSymbol", data)~=nil)then self:setBackgroundSymbol(xmlValue("backgroundSymbol", data)) end
                if(xmlValue("progress", data)~=nil)then self:setProgress(xmlValue("progress", data)) end
                return self
            end,
        }
        return object
    end,

    Slider = function(base, basalt)
        local object = { 
            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
                if(xmlValue("symbol", data)~=nil)then self:setSymbol(xmlValue("symbol", data)) end
                if(xmlValue("symbolColor", data)~=nil)then self:setSymbolColor(xmlValue("symbolColor", data)) end
                if(xmlValue("index", data)~=nil)then self:setIndex(xmlValue("index", data)) end
                if(xmlValue("maxValue", data)~=nil)then self:setIndex(xmlValue("maxValue", data)) end
                if(xmlValue("barType", data)~=nil)then self:setBarType(xmlValue("barType", data)) end
                return self
            end,
        }
        return object
    end,

    Scrollbar = function(base, basalt)
        local object = { 
            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
                if(xmlValue("symbol", data)~=nil)then self:setSymbol(xmlValue("symbol", data)) end
                if(xmlValue("symbolColor", data)~=nil)then self:setSymbolColor(xmlValue("symbolColor", data)) end
                if(xmlValue("symbolSize", data)~=nil)then self:setSymbolSize(xmlValue("symbolSize", data)) end
                if(xmlValue("scrollAmount", data)~=nil)then self:setScrollAmount(xmlValue("scrollAmount", data)) end
                if(xmlValue("index", data)~=nil)then self:setIndex(xmlValue("index", data)) end
                if(xmlValue("maxValue", data)~=nil)then self:setIndex(xmlValue("maxValue", data)) end
                if(xmlValue("barType", data)~=nil)then self:setBarType(xmlValue("barType", data)) end
                return self
            end,
        }
        return object
    end,

    MonitorFrame = function(base, basalt)
        local object = { 
            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
                if(xmlValue("monitor", data)~=nil)then self:setSymbol(xmlValue("monitor", data)) end                
                return self
            end,
        }
        return object
    end,

    Switch = function(base, basalt)
        local object = { 
            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
                if(xmlValue("symbol", data)~=nil)then self:setSymbol(xmlValue("symbol", data)) end
                if(xmlValue("activeBackground", data)~=nil)then self:setActiveBackground(xmlValue("activeBackground", data)) end
                if(xmlValue("inactiveBackground", data)~=nil)then self:setInactiveBackground(xmlValue("inactiveBackground", data)) end
                return self
            end,
        }
        return object
    end,

    Textfield = function(base, basalt)
        local object = { 
            setValuesByXMLData = function(self, data, scripts)
            base.setValuesByXMLData(self, data, scripts)
            local bgSel, fgSel = self:getSelection()
            local xOffset, yOffset = self:getOffset()
            if(xmlValue("bgSelection", data)~=nil)then bgSel = xmlValue("bgSelection", data) end
            if(xmlValue("fgSelection", data)~=nil)then fgSel = xmlValue("fgSelection", data) end
            if(xmlValue("xOffset", data)~=nil)then xOffset = xmlValue("xOffset", data) end
            if(xmlValue("yOffset", data)~=nil)then yOffset = xmlValue("yOffset", data) end
            self:setSelection(fgSel, bgSel)
            self:setOffset(xOffset, yOffset)


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
                base.setValuesByXMLData(self, data, scripts)
                if(xmlValue("start", data)~=nil)then self:start(load(xmlValue("start", data), nil, "t", scripts.env)) end
                return self
            end,
        }
        return object
    end,

    Timer = function(base, basalt)
        local object = { 
            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
                if(xmlValue("start", data)~=nil)then self:start(xmlValue("start", data)) end
                if(xmlValue("time", data)~=nil)then self:setTime(xmlValue("time", data)) end

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
            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
                local selBg, selFg = self:getSelectionColor()
                if(xmlValue("align", data)~=nil)then self:setTextAlign(xmlValue("align", data)) end
                if(xmlValue("offset", data)~=nil)then self:setOffset(xmlValue("offset", data)) end
                if(xmlValue("selectionBg", data)~=nil)then selBg = xmlValue("selectionBg", data) end
                if(xmlValue("selectionFg", data)~=nil)then selFg = xmlValue("selectionFg", data) end
                self:setSelectionColor(selBg, selFg)

                if(xmlValue("scrollable", data)~=nil)then self:setScrollable(xmlValue("scrollable", data)) end                

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
            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
                local w, h = self:getDropdownSize()
                if(xmlValue("dropdownWidth", data)~=nil)then w = xmlValue("dropdownWidth", data) end
                if(xmlValue("dropdownHeight", data)~=nil)then h = xmlValue("dropdownHeight", data) end
                self:setDropdownSize(w, h)                
                return self
            end,
        }
        return object
    end,

    Radio = function(base, basalt)
        local object = { 
            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
                local selBg, selFg = self:getBoxSelectionColor()
                local defBg, defFg = self:setBoxDefaultColor()
                
                if(xmlValue("selectionBg", data)~=nil)then selBg = xmlValue("selectionBg", data) end
                if(xmlValue("selectionFg", data)~=nil)then selFg = xmlValue("selectionFg", data) end
                self:setBoxSelectionColor(selBg, selFg)

                if(xmlValue("defaultBg", data)~=nil)then defBg = xmlValue("defaultBg", data) end
                if(xmlValue("defaultFg", data)~=nil)then defFg = xmlValue("defaultFg", data) end
                self:setBoxDefaultColor(defBg, defFg)

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
            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
                if(xmlValue("space", data)~=nil)then self:setSpace(xmlValue("space", data)) end
                if(xmlValue("scrollable", data)~=nil)then self:setScrollable(xmlValue("scrollable", data)) end
                return self
            end,
        }
        return object
    end,

    Graph = function(base, basalt)
        local object = { 
            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
                local symbol, symbolCol = self:getGraphSymbol()
                if(xmlValue("maxEntries", data)~=nil)then self:setMaxEntries(xmlValue("maxEntries", data)) end
                if(xmlValue("type", data)~=nil)then self:setGraphType(xmlValue("type", data)) end
                if(xmlValue("minValue", data)~=nil)then self:setMinValue(xmlValue("minValue", data)) end
                if(xmlValue("maxValue", data)~=nil)then self:setMaxValue(xmlValue("maxValue", data)) end
                if(xmlValue("symbol", data)~=nil)then symbol = xmlValue("symbol", data) end
                if(xmlValue("symbolColor", data)~=nil)then symbolCol = xmlValue("symbolColor", data) end
                self:setGraphSymbol(symbol, symbolCol)
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
            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
                local selBg, selFg = self:getSelectionColor()
                local xOffset, yOffset = self:getOffset()
                if(xmlValue("space", data)~=nil)then self:setSpace(xmlValue("space", data)) end
                if(xmlValue("scrollable", data)~=nil)then self:setScrollable(xmlValue("scrollable", data)) end
                if(xmlValue("selectionBg", data)~=nil)then selBg = xmlValue("selectionBg", data) end
                if(xmlValue("selectionFg", data)~=nil)then selFg = xmlValue("selectionFg", data) end
                self:setSelectionColor(selBg, selFg)
                if(xmlValue("xOffset", data)~=nil)then xOffset = xmlValue("xOffset", data) end
                if(xmlValue("yOffset", data)~=nil)then yOffset = xmlValue("yOffset", data) end
                self:setOffset(xOffset, yOffset)
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