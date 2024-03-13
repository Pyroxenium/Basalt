local tHex = require("tHex")
local sub,find,reverse,rep,insert,len = string.sub,string.find,string.reverse,string.rep,table.insert,string.len

local function splitString(str, delimiter)
    local results = {}
    if str == "" or delimiter == "" then
        return results
    end
    local start = 1
    local delim_start, delim_end = find(str, delimiter, start)
        while delim_start do
            insert(results, sub(str, start, delim_start - 1))
            start = delim_end + 1
            delim_start, delim_end = find(str, delimiter, start)
        end
    insert(results, sub(str, start))
    return results
end

local function removeTags(input)
    return input:gsub("{[^}]+}", "")
end


local function wrapText(str, width)
    str = removeTags(str)
    if(str=="")or(width==0)then
        return {""}
    end
    local uniqueLines = splitString(str, "\n")
    local result = {}
    for k, v in pairs(uniqueLines) do
        if #v == 0 then
            table.insert(result, "")
        else
            while #v > width do
                local last_space = width
                for i = width, 1, -1 do
                    if sub(v, i, i) == " " then
                        last_space = i
                        break
                    end
                end

                if last_space == width then
                    local line = sub(v, 1, last_space - 1) .. "-"
                    table.insert(result, line)
                    v = sub(v, last_space)
                else
                    local line = sub(v, 1, last_space - 1)
                    table.insert(result, line)
                    v = sub(v, last_space + 1)
                end

                if #v <= width then
                    break
                end
            end
            if #v > 0 then
                table.insert(result, v)
            end
        end
    end
    return result
end

--- Coonverts a string with special tags to a table with colors and text
-- @param input The string to convert
-- @return A table with the following structure: { {text = "Hello", color = colors.red}, {text = "World", color = colors.blue} }
local function convertRichText(input)
    local parsedResult = {}
    local currentPosition = 1
    local rawPosition = 1

    while currentPosition <= #input do
        local closestColor, closestBgColor
        local color, bgColor
        local colorEnd, bgColorEnd

        for colorName, _ in pairs(colors) do
            local fgPattern = "{fg:" .. colorName.."}"
            local bgColorPattern = "{bg:" .. colorName.."}"
            local colorStart, colorEndCandidate = input:find(fgPattern, currentPosition)
            local bgColorStart, bgColorEndCandidate = input:find(bgColorPattern, currentPosition)

            if colorStart and (not closestColor or colorStart < closestColor) then
                closestColor = colorStart
                color = colorName
                colorEnd = colorEndCandidate
            end

            if bgColorStart and (not closestBgColor or bgColorStart < closestBgColor) then
                closestBgColor = bgColorStart
                bgColor = colorName
                bgColorEnd = bgColorEndCandidate
            end
        end

        local nextPosition
        if closestColor and (not closestBgColor or closestColor < closestBgColor) then
            nextPosition = closestColor
        elseif closestBgColor then
            nextPosition = closestBgColor
        else
            nextPosition = #input + 1
        end

        local text = input:sub(currentPosition, nextPosition - 1)
        if #text > 0 then
            table.insert(parsedResult, {
                color = nil,
                bgColor = nil,
                text = text,
                position = rawPosition
            })
            rawPosition = rawPosition + #text
            currentPosition = currentPosition + #text
        end

        if closestColor and (not closestBgColor or closestColor < closestBgColor) then
            table.insert(parsedResult, {
                color = color,
                bgColor = nil,
                text = "",
                position = rawPosition,
            })
            currentPosition = colorEnd + 1
        elseif closestBgColor then
            table.insert(parsedResult, {
                color = nil,
                bgColor = bgColor,
                text = "",
                position = rawPosition,
            })
            currentPosition = bgColorEnd + 1
        else
            break
        end
    end

    return parsedResult
end

--- Wrapts text with special color tags, like {fg:red} or {bg:blue} to multiple lines
--- @param text string Text to wrap
--- @param width number Width of the line
--- @return table Table of lines
local function wrapRichText(text, width)
    local colorData = convertRichText(text)
    local formattedLines = {}
    local x, y = 1, 1
    local currentColor, currentBgColor

    local function addFormattedEntry(entry)
        table.insert(formattedLines, {
            x = x,
            y = y,
            text = entry.text,
            color = entry.color or currentColor,
            bgColor = entry.bgColor or currentBgColor
        })
    end

    for _, entry in ipairs(colorData) do
        if entry.color then
            currentColor = entry.color
        elseif entry.bgColor then
            currentBgColor = entry.bgColor
        else
            local words = splitString(entry.text, " ")

            for i, word in ipairs(words) do
                local wordLength = #word

                if i > 1 then
                    if x + 1 + wordLength <= width then
                        addFormattedEntry({ text = " " })
                        x = x + 1
                    else
                        x = 1
                        y = y + 1
                    end
                end

                while wordLength > 0 do
                    local line = word:sub(1, width - x + 1)
                    word = word:sub(width - x + 2)
                    wordLength = #word

                    addFormattedEntry({ text = line })

                    if wordLength > 0 then
                        x = 1
                        y = y + 1
                    else
                        x = x + #line
                    end
                end
            end
        end

        if x > width then
            x = 1
            y = y + 1
        end
    end

    return formattedLines
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
removeTags = removeTags,

wrapText = wrapText,

convertRichText = convertRichText,

--- Writes text with special color tags
--- @param obj object The object to write to
--- @param x number X-Position
--- @param y number Y-Position
--- @param text string The text to write
writeRichText = function(obj, x, y, text)
    local richText = convertRichText(text)
    if(#richText==0)then
        obj:addText(x, y, text)
        return
    end

    local defaultFG, defaultBG = obj:getForeground(), obj:getBackground()
    for _,v in pairs(richText)do
        obj:addText(x+v.position-1, y, v.text)
        if(v.color~=nil)then
            obj:addFG(x+v.position-1, y, tHex[colors[v.color] ]:rep(#v.text))
            defaultFG = colors[v.color]
        else
            obj:addFG(x+v.position-1, y, tHex[defaultFG]:rep(#v.text))
        end
        if(v.bgColor~=nil)then
            obj:addBG(x+v.position-1, y, tHex[colors[v.bgColor] ]:rep(#v.text))
            defaultBG = colors[v.bgColor]
        else
            if(defaultBG~=false)then
                obj:addBG(x+v.position-1, y, tHex[defaultBG]:rep(#v.text))
            end
        end
    end
end,

wrapRichText = wrapRichText,

--- Writes wrapped Text with special tags.
--- @param obj object The object to write to
--- @param x number X-Position
--- @param y number Y-Position
--- @param text string Text
--- @param width number Width
--- @param height number Height
writeWrappedText = function(obj, x, y, text, width, height)
    local wrapped = wrapRichText(text, width)
    for _,v in pairs(wrapped)do
        if(v.y>height)then
            break
        end
        if(v.text~=nil)then
            obj:addText(x+v.x-1, y+v.y-1, v.text)
        end
        if(v.color~=nil)then
            obj:addFG(x+v.x-1, y+v.y-1, tHex[colors[v.color] ]:rep(#v.text))
        end
        if(v.bgColor~=nil)then
            obj:addBG(x+v.x-1, y+v.y-1, tHex[colors[v.bgColor] ]:rep(#v.text))
        end
    end
end,

--- Returns a random UUID.
--- @return string UUID.
uuid = function()
    return string.gsub(string.format('%x-%x-%x-%x-%x', math.random(0, 0xffff), math.random(0, 0xffff), math.random(0, 0xffff), math.random(0, 0x0fff) + 0x4000, math.random(0, 0x3fff) + 0x8000), ' ', '0')
end

}