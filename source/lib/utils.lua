local tHex = { -- copy paste is a very important feature
    [colors.white] = "0",
    [colors.orange] = "1",
    [colors.magenta] = "2",
    [colors.lightBlue] = "3",
    [colors.yellow] = "4",
    [colors.lime] = "5",
    [colors.pink] = "6",
    [colors.gray] = "7",
    [colors.lightGray] = "8",
    [colors.cyan] = "9",
    [colors.purple] = "a",
    [colors.blue] = "b",
    [colors.brown] = "c",
    [colors.green] = "d",
    [colors.red] = "e",
    [colors.black] = "f",
}

local function getTextHorizontalAlign(text, width, textAlign)
    text = string.sub(text, 1, width)
    local offset = width - string.len(text)
    if (textAlign == "right") then
        text = string.rep(" ", offset) .. text
    elseif (textAlign == "center") then
        text = string.rep(" ", math.floor(offset / 2)) .. text .. string.rep(" ", math.floor(offset / 2))
        text = text .. (string.len(text) < width and " " or "")
    else
        text = text .. string.rep(" ", offset)
    end
    return text
end

local function getTextVerticalAlign(h, textAlign)
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
    return offset
end

local function rpairs(t)
    return function(t, i)
        i = i - 1
        if i ~= 0 then
            return i, t[i]
        end
    end, t, #t + 1
end