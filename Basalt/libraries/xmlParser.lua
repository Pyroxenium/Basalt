local XMLNode = {
    new = function(name)
        return {
            value = nil,
            name = name,
            children = {},
            attributes = {},

            addChild = function(self, child)
                if self[child.name] ~= nil then
                    if type(self[child.name].name) == "function" then
                        local tempTable = {}
                        table.insert(tempTable, self[child.name])
                        self[child.name] = tempTable
                    end
                    table.insert(self[child.name], child)
                else
                    self[child.name] = child
                end
                table.insert(self.children, child)
            end,

            addAttribute = function(self, name, value)
                self.attributes[name] = value
            end
        }
    end
}

local parseAttributes = function(node, s)
    -- Parse "" style attributes
    local _, _ = string.gsub(s, "(%w+)=([\"'])(.-)%2", function(attribute, _, value)
        node:addAttribute(attribute, "\"" .. value .. "\"")
    end)
    -- Parse {} style attributes
    local _, _ = string.gsub(s, "(%w+)={(.-)}", function(attribute, expression)
        node:addAttribute(attribute, expression)
    end)
end

local XMLParser = {
    xmlValue = function(name, tab)
        local var
        if(type(tab)~="table")then return end
        if(tab[name]~=nil)then
            if(type(tab[name])=="table")then
                if(tab[name].value~=nil)then
                    var = tab[name].value
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
    end,

    parseText = function(xmlText)
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
                local lVal = (top.value or "") .. text
                stack[#stack].value = lVal
            end
            if empty == "/" then -- empty element tag
                local lNode = XMLNode.new(label)
                parseAttributes(lNode, xarg)
                top:addChild(lNode)
            elseif c == "" then -- start tag
                local lNode = XMLNode.new(label)
                parseAttributes(lNode, xarg)
                table.insert(stack, lNode)
                top = lNode
            else -- end tag
                local toclose = table.remove(stack) -- remove top

                top = stack[#stack]
                if #stack < 1 then
                    error("XMLParser: nothing to close with " .. label)
                end
                if toclose.name ~= label then
                    error("XMLParser: trying to close " .. toclose.name .. " with " .. label)
                end
                top:addChild(toclose)
            end
            i = j + 1
        end
        local text = string.sub(xmlText, i);
        if #stack > 1 then
            error("XMLParser: unclosed " .. stack[#stack].name)
        end
        return top
    end
}

return XMLParser
