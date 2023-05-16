local XMLNode = {
    new = function(tag)
        return {
            tag = tag,
            value = nil,
            children = {},
            attributes = {},

            addChild = function(self, child)
                if self[child.tag] ~= nil then
                    if type(self[child.tag].tag) == "function" then
                        local tempTable = {}
                        table.insert(tempTable, self[child.tag])
                        self[child.tag] = tempTable
                    end
                    table.insert(self[child.tag], child)
                else
                    self[child.tag] = child
                end
                table.insert(self.children, child)
            end,

            addAttribute = function(self, tag, value)
                self.attributes[tag] = value
            end
        }
    end
}

local parseAttributes = function(node, s)
    -- Parse "" style string attributes
    local _, _ = string.gsub(s, "(%w+)=([\"'])(.-)%2", function(attribute, _, value)
        node:addAttribute(attribute, "\"" .. value .. "\"")
    end)
    -- Parse {} style computed attributes
    local _, _ = string.gsub(s, "(%w+)={(.-)}", function(attribute, expression)
        node:addAttribute(attribute, expression)
    end)
end

local XMLParser = {
    xmlValue = function(tag, tab)
        local var
        if(type(tab)~="table")then return end
        if(tab[tag]~=nil)then
            if(type(tab[tag])=="table")then
                if(tab[tag].value~=nil)then
                    var = tab[tag].value
                end
            end
        end
        if(var==nil)then var = tab["@"..tag] end

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
                if toclose.tag ~= label then
                    error("XMLParser: trying to close " .. toclose.tag .. " with " .. label)
                end
                top:addChild(toclose)
            end
            i = j + 1
        end
        local text = string.sub(xmlText, i);
        if #stack > 1 then
            error("XMLParser: unclosed " .. stack[#stack].tag)
        end
        return top
    end
}

return XMLParser
