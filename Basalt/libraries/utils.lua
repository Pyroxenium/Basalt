local sub,find,reverse,rep,insert,len = string.sub,string.find,string.reverse,string.rep,table.insert,string.len

local function splitString(str, delimiter)
    local result = {}
    if str == "" or delimiter == "" then
        return result
    end
    local start = 1
    local delim_start, delim_end = find(str, delimiter, start)
        while delim_start do
            insert(result, sub(str, start, delim_start - 1))
            start = delim_end + 1
            delim_start, delim_end = find(str, delimiter, start)
        end
    insert(result, sub(str, start))
    return result
end

return {
getTextHorizontalAlign = function(text, width, textAlign, replaceChar)
    text = sub(text, 1, width)
    local offset = width - len(text)
    if (textAlign == "right") then
        text = rep(replaceChar or " ", offset) .. text
    elseif (textAlign == "center") then
        text = rep(replaceChar or " ", math.floor(offset / 2)) .. text .. rep(replaceChar or " ", math.floor(offset / 2))
        text = text .. (len(text) < width and (replaceChar or " ") or "")
    else
        text = text .. rep(replaceChar or " ", offset)
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

orderedTable = function(t)
    local newTable = {}
    for _, v in pairs(t) do
        newTable[#newTable+1] = v
    end
    return newTable
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

wrapText = function(str, width)
    local uniqueLines = splitString(str, "\n")
    local result = {}
    for k,v in pairs(uniqueLines)do
        if(#v==0)then table.insert(result, "") end
        while #v > width do
            local last_space = find(reverse(sub(v, 1, width)), " ")
            if not last_space then
                last_space = width
            else
                last_space = width - last_space --+ 1
            end
            local line = sub(v, 1, last_space)
            table.insert(result, line)
            v = sub(v, last_space + 1)
        end
        if #v > 0 then
            table.insert(result, v)
        end
    end
    return result
end,

uuid = function()
    return string.gsub(string.format('%x-%x-%x-%x-%x', math.random(0, 0xffff), math.random(0, 0xffff), math.random(0, 0xffff), math.random(0, 0x0fff) + 0x4000, math.random(0, 0x3fff) + 0x8000), ' ', '0')
end

}