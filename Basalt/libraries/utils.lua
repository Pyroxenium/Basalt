local sub,find,reverse = string.sub,string.find,string.reverse

local function splitString(str, delimiter)
    local result = {}
    if str == "" or delimiter == "" then
        return result
        end
    local start = 1
    local delim_start, delim_end = find(str, delimiter, start)
    while delim_start do
        table.insert(result, sub(str, start, delim_start - 1))
        start = delim_end + 1
        delim_start, delim_end = find(str, delimiter, start)
    end
    table.insert(result, sub(str, start))
    return result
end

local relations = {[0] = {8, 4, 3, 6, 5}, {4, 14, 8, 7}, {6, 10, 8, 7}, {9, 11, 8, 0}, {1, 14, 8, 0}, {13, 12, 8, 0}, {2, 10, 8, 0}, {15, 8, 10, 11, 12, 14},
		{0, 7, 1, 9, 2, 13}, {3, 11, 8, 7}, {2, 6, 7, 15}, {9, 3, 7, 15}, {13, 5, 7, 15}, {5, 12, 8, 7}, {1, 4, 7, 15}, {7, 10, 11, 12, 14}}

local colourNum, exponents, colourChar = {}, {}, {}
for i = 0, 15 do exponents[2^i] = i end
do
	local hex = "0123456789abcdef"
	for i = 1, 16 do
		colourNum[hex:sub(i, i)] = i - 1
		colourNum[i - 1] = hex:sub(i, i)
		colourChar[hex:sub(i, i)] = 2 ^ (i - 1)
		colourChar[2 ^ (i - 1)] = hex:sub(i, i)
		
		local thisRel = relations[i - 1]
		for i = 1, #thisRel do thisRel[i] = 2 ^ thisRel[i] end
	end
end

local function getBestColourMatch(usage)
	local lastCol = relations[exponents[usage[#usage][1]]]

	for j = 1, #lastCol do
		local thisRelation = lastCol[j]
		for i = 1, #usage - 1 do if usage[i][1] == thisRelation then return i end end
	end
	
	return 1
end

local function colsToChar(pattern, totals)
	if not totals then
		local newPattern = {}
		totals = {}
		for i = 1, 6 do
			local thisVal = pattern[i]
			local thisTot = totals[thisVal]
			totals[thisVal], newPattern[i] = thisTot and (thisTot + 1) or 1, thisVal
		end
		pattern = newPattern
	end
	
	local usage = {}
	for key, value in pairs(totals) do usage[#usage + 1] = {key, value} end
	
	if #usage > 1 then
		-- Reduce the chunk to two colours:
		while #usage > 2 do
			table.sort(usage, function (a, b) return a[2] > b[2] end)
			local matchToInd, usageLen = getBestColourMatch(usage), #usage
			local matchFrom, matchTo = usage[usageLen][1], usage[matchToInd][1]
			for i = 1, 6 do if pattern[i] == matchFrom then
				pattern[i] = matchTo
				usage[matchToInd][2] = usage[matchToInd][2] + 1
			end end
			usage[usageLen] = nil
		end

		-- Convert to character. Adapted from oli414's function:
		-- http://www.computercraft.info/forums2/index.php?/topic/25340-cc-176-easy-drawing-characters/
		local data = 128
		for i = 1, #pattern - 1 do if pattern[i] ~= pattern[6] then data = data + 2^(i-1) end end
		return string.char(data), colourChar[usage[1][1] == pattern[6] and usage[2][1] or usage[1][1]], colourChar[pattern[6]]
	else
		-- Solid colour character:
		return "\128", colourChar[pattern[1]], colourChar[pattern[1]]
	end
end

return {
getTextHorizontalAlign = function(text, width, textAlign, replaceChar)
    text = sub(text, 1, width)
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
    local result = {}
    for k,v in pairs(uniqueLines)do
        if(#v==0)then table.insert(result, "") end
        while #v > width do
            local last_space = find(reverse(sub(v, 1, width)), " ")
            if not last_space then
                last_space = width
            else
                last_space = width - last_space + 1
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

array = function(arraysize, hashsize)
    return load("return {" .. ("nil,"):rep(arraysize) .. ("[0]=nil,"):rep(hashsize) .. "}")()
end,

shrink = function(image, bgCol)
	local results, width, height, bgCol = {{}, {}, {}}, 0, #image + #image % 3, bgCol or colours.black
	for i = 1, #image do if #image[i] > width then width = #image[i] end end
	
	for y = 0, height - 1, 3 do
		local cRow, tRow, bRow, counter = {}, {}, {}, 1
		
		for x = 0, width - 1, 2 do
			-- Grab a 2x3 chunk:
			local pattern, totals = {}, {}
			
			for yy = 1, 3 do for xx = 1, 2 do
				pattern[#pattern + 1] = (image[y + yy] and image[y + yy][x + xx]) and (image[y + yy][x + xx] == 0 and bgCol or image[y + yy][x + xx]) or bgCol
				totals[pattern[#pattern]] = totals[pattern[#pattern]] and (totals[pattern[#pattern]] + 1) or 1
			end end
			
			cRow[counter], tRow[counter], bRow[counter] = colsToChar(pattern, totals)
			counter = counter + 1
		end
		
		results[1][#results[1] + 1], results[2][#results[2] + 1], results[3][#results[3] + 1] = table.concat(cRow), table.concat(tRow), table.concat(bRow)
	end
	
	results.width, results.height = #results[1][1], #results[1]
	
	return results
end,
}