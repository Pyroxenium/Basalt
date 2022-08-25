local Object = require("Object")
local xmlValue = require("utils").getValueFromXML

return function(name)
    -- Image
    local base = Object(name)
    local objectType = "Image"
    base:setZIndex(2)
    local image
    local shrinkedImage
    local imageGotShrinked = false

    local function shrink()
        -- shrinkSystem is copy pasted (and slightly changed) from blittle by Bomb Bloke: http://www.computercraft.info/forums2/index.php?/topic/25354-cc-176-blittle-api/
        local relations = { [0] = { 8, 4, 3, 6, 5 }, { 4, 14, 8, 7 }, { 6, 10, 8, 7 }, { 9, 11, 8, 0 }, { 1, 14, 8, 0 }, { 13, 12, 8, 0 }, { 2, 10, 8, 0 }, { 15, 8, 10, 11, 12, 14 },
                            { 0, 7, 1, 9, 2, 13 }, { 3, 11, 8, 7 }, { 2, 6, 7, 15 }, { 9, 3, 7, 15 }, { 13, 5, 7, 15 }, { 5, 12, 8, 7 }, { 1, 4, 7, 15 }, { 7, 10, 11, 12, 14 } }

        local colourNum, exponents, colourChar = {}, {}, {}
        for i = 0, 15 do
            exponents[2 ^ i] = i
        end
        do
            local hex = "0123456789abcdef"
            for i = 1, 16 do
                colourNum[hex:sub(i, i)] = i - 1
                colourNum[i - 1] = hex:sub(i, i)
                colourChar[hex:sub(i, i)] = 2 ^ (i - 1)
                colourChar[2 ^ (i - 1)] = hex:sub(i, i)

                local thisRel = relations[i - 1]
                for i = 1, #thisRel do
                    thisRel[i] = 2 ^ thisRel[i]
                end
            end
        end

        local function getBestColourMatch(usage)
            local lastCol = relations[exponents[usage[#usage][1]]]

            for j = 1, #lastCol do
                local thisRelation = lastCol[j]
                for i = 1, #usage - 1 do
                    if usage[i][1] == thisRelation then
                        return i
                    end
                end
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
            for key, value in pairs(totals) do
                usage[#usage + 1] = { key, value }
            end

            if #usage > 1 then
                -- Reduce the chunk to two colours:
                while #usage > 2 do
                    table.sort(usage, function(a, b)
                        return a[2] > b[2]
                    end)
                    local matchToInd, usageLen = getBestColourMatch(usage), #usage
                    local matchFrom, matchTo = usage[usageLen][1], usage[matchToInd][1]
                    for i = 1, 6 do
                        if pattern[i] == matchFrom then
                            pattern[i] = matchTo
                            usage[matchToInd][2] = usage[matchToInd][2] + 1
                        end
                    end
                    usage[usageLen] = nil
                end

                -- Convert to character. Adapted from oli414's function:
                -- http://www.computercraft.info/forums2/index.php?/topic/25340-cc-176-easy-drawing-characters/
                local data = 128
                for i = 1, #pattern - 1 do
                    if pattern[i] ~= pattern[6] then
                        data = data + 2 ^ (i - 1)
                    end
                end
                return string.char(data), colourChar[usage[1][1] == pattern[6] and usage[2][1] or usage[1][1]], colourChar[pattern[6]]
            else
                -- Solid colour character:
                return "\128", colourChar[pattern[1]], colourChar[pattern[1]]
            end
        end

        local results, width, height, bgCol = { {}, {}, {} }, 0, #image + #image % 3, base.bgColor or colors.black
        for i = 1, #image do
            if #image[i] > width then
                width = #image[i]
            end
        end

        for y = 0, height - 1, 3 do
            local cRow, tRow, bRow, counter = {}, {}, {}, 1

            for x = 0, width - 1, 2 do
                -- Grab a 2x3 chunk:
                local pattern, totals = {}, {}

                for yy = 1, 3 do
                    for xx = 1, 2 do
                        pattern[#pattern + 1] = (image[y + yy] and image[y + yy][x + xx]) and (image[y + yy][x + xx] == 0 and bgCol or image[y + yy][x + xx]) or bgCol
                        totals[pattern[#pattern]] = totals[pattern[#pattern]] and (totals[pattern[#pattern]] + 1) or 1
                    end
                end

                cRow[counter], tRow[counter], bRow[counter] = colsToChar(pattern, totals)
                counter = counter + 1
            end

            results[1][#results[1] + 1], results[2][#results[2] + 1], results[3][#results[3] + 1] = table.concat(cRow), table.concat(tRow), table.concat(bRow)
        end

        results.width, results.height = #results[1][1], #results[1]

        shrinkedImage = results
    end

    local object = {
        init = function(self)
            self.bgColor = self.parent:getTheme("ImageBG")
        end,
        getType = function(self)
            return objectType
        end;

        loadImage = function(self, path)
            image = paintutils.loadImage(path)
            imageGotShrinked = false
            self:updateDraw()
            return self
        end;


        shrink = function(self)
            shrink()
            imageGotShrinked = true
            self:updateDraw()
            return self
        end;

        setValuesByXMLData = function(self, data)
            base.setValuesByXMLData(self, data)
            if(xmlValue("shrink", data)~=nil)then if(xmlValue("shrink", data))then self:shrink() end end
            if(xmlValue("path", data)~=nil)then self:loadImage(xmlValue("path", data)) end
            return self
        end,

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    if (image ~= nil) then
                        local obx, oby = self:getAnchorPosition()
                        local w,h = self:getSize()
                        if (imageGotShrinked) then
                            -- this is copy pasted (and slightly changed) from blittle by Bomb Bloke: http://www.computercraft.info/forums2/index.php?/topic/25354-cc-176-blittle-api/
                            local t, tC, bC = shrinkedImage[1], shrinkedImage[2], shrinkedImage[3]
                            for i = 1, shrinkedImage.height do
                                local tI = t[i]
                                if type(tI) == "string" then
                                    self.parent:setText(obx, oby + i - 1, tI)
                                    self.parent:setFG(obx, oby + i - 1, tC[i])
                                    self.parent:setBG(obx, oby + i - 1, bC[i])
                                elseif type(tI) == "table" then
                                    self.parent:setText(obx, oby + i - 1, tI[2])
                                    self.parent:setFG(obx, oby + i - 1, tC[i])
                                    self.parent:setBG(obx, oby + i - 1, bC[i])
                                end
                            end
                        else
                            for yPos = 1, math.min(#image, h) do
                                local line = image[yPos]
                                for xPos = 1, math.min(#line, w) do
                                    if line[xPos] > 0 then
                                        self.parent:drawBackgroundBox(obx + xPos - 1, oby + yPos - 1, 1, 1, line[xPos])
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end,
    }

    return setmetatable(object, base)
end