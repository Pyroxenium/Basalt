local splitString = function(str, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for v in string.gmatch(str, "([^"..sep.."]+)") do
            table.insert(t, v)
    end
    return t
end

return {
getTextHorizontalAlign = function(text, width, textAlign, replaceChar)
    text = string.sub(text, 1, width)
    local offset = width - string.len(text)
    if (textAlign == "right") then
        text = string.rep(replaceChar or " ", offset) .. text
    elseif (textAlign == "center") then
        text = string.rep(replaceChar or " ", math.floor(offset / 2)) .. text .. string.rep(replaceChar or " ", math.floor(offset / 2))
        text = text .. (string.len(text) < width and (replaceChar or " ") or "")
    else
        text = text .. string.rep(replaceChar or " ", offset)
    end
    return text
end,

getTextVerticalAlign = function(h, textAlign)
    local offset = 0
    if (textAlign == "center") then
        offset = math.ceil(h / 2)
        if (offset < 1) then
            offset = 1
        end
    end
    if (textAlign == "bottom") then
        offset = h
    end
    if(offset<1)then offset=1 end
    return offset
end,

rpairs = function(t)
    return function(t, i)
        i = i - 1
        if i ~= 0 then
            return i, t[i]
        end
    end, t, #t + 1
end,

tableCount = function(t)
    local n = 0
    if(t~=nil)then
        for k,v in pairs(t)do
            n = n + 1
        end
    end
    return n
end,

splitString = splitString,

createText = function(str, width)
    local uniqueLines = splitString(str, "\n")
    local lines = {}
    for k,v in pairs(uniqueLines)do
        local line = ""
        local words = splitString(v, " ")
        for a,b in pairs(words)do
            if(#line+#b <= width)then
                line = line=="" and b or line.." "..b
                if(a==#words)then table.insert(lines, line) end
            else
                table.insert(lines, line)
                line = b:sub(1,width)
                if(a==#words)then table.insert(lines, line) end
            end
        end
    end
    return lines
end,

getValueFromXML = function(name, tab)
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
end,

numberFromString = function(str)
    return load("return " .. str)()
end,

uuid = function()
    local random = math.random
    local function uuid()
        local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
        return string.gsub(template, '[xy]', function (c)
            local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
            return string.format('%x', v)
        end)
    end
    return uuid()
end,
}