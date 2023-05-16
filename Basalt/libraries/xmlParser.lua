local XMLNode = {}

XMLNode.new = function(name)
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

local XMLParser = {}

function XMLParser.XmlValue(name, tab)
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

function XMLParser:ToXmlString(value)
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

function XMLParser:FromXmlString(value)
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

function XMLParser:ParseProps(node, s)
    string.gsub(s, "(%w+)=([\"'])(.-)%2", function(w, _, a)
        node:addProperty(w, self:FromXmlString(a))
    end)
end

function XMLParser:ParseReactiveProps(node, s)
    string.gsub(s, "(%w+)={(.-)}", function(w, a)
        node:addReactiveProperty(w, a)
    end)
end

function XMLParser:ParseXmlText(xmlText)
    local stack = {}
    local top = XMLNode.new()
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
            local lNode = XMLNode.new(label)
            self:ParseProps(lNode, xarg)
            self:ParseReactiveProps(lNode, xarg)
            top:addChild(lNode)
        elseif c == "" then -- start tag
            local lNode = XMLNode.new(label)
            self:ParseProps(lNode, xarg)
            self:ParseReactiveProps(lNode, xarg)
            table.insert(stack, lNode)
    top = lNode
        else -- end tag
            local toclose = table.remove(stack) -- remove top

            top = stack[#stack]
            if #stack < 1 then
                error("XMLParser: nothing to close with " .. label)
            end
            if toclose:name() ~= label then
                error("XMLParser: trying to close " .. toclose.name .. " with " .. label)
            end
            top:addChild(toclose)
        end
        i = j + 1
    end
    local text = string.sub(xmlText, i);
    if #stack > 1 then
        error("XMLParser: unclosed " .. stack[#stack]:name())
    end
    return top
end

return XMLParser
