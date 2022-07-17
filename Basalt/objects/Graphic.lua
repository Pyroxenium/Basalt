local Object = require("Object")
local geometric = require("geometricPoints")
local tHex = require("tHex")
local xmlValue = require("utils").getValueFromXML

local sub,len,max,min = string.sub,string.len,math.max,math.min

return function(name)
    -- Graphic
    local base = Object(name)
    local objectType = "Graphic"
    base:setZIndex(2)

    local graphicObjects = {}
    local graphic = {}
    local shrinkedGraphic = {}
    local isGraphicShrinked = false
    local xOffset, yOffset = 0, 0
    local dragable = false
    local xMouse,yMouse
    local w, h = 40, 15
    local canvasSizeChanged = false

    local tColourLookup = {}
    for n=1,16 do
        tColourLookup[ string.byte( "0123456789abcdef",n,n ) ] = 2^(n-1)
    end

    local function stringToTable(str)
        local t = {}
        for i = 1, #str do
            t[i] = str:sub(i, i)
        end
        return t
    end

    local function setBG(x, y, width, height, colorStr)
        if (y >= 1) and (y <= height) then
            if (x + len(colorStr) > 0) and (x <= width) then
                local oldCache = graphic[y]
                local newCache
                local nEnd = x + #colorStr - 1

                if (x < 1) then
                    colorStr = sub(colorStr, 1 - x + 1, width - x + 1)
                elseif (nEnd > width) then
                    colorStr = sub(colorStr, 1, width - x + 1)
                end

                if (x > 1) then
                    newCache = sub(oldCache, 1, x - 1) .. colorStr
                else
                    newCache = colorStr
                end
                if nEnd < width then
                    newCache = newCache .. sub(oldCache, nEnd + 1, width)
                end
                graphic[y] = newCache
            end
        end
    end

    local function redrawCanvasSize()
        local w,h = w,h
        if(isGraphicShrinked)then w = w*2 h = h*3 end
        for y=1,h do
            if(graphic[y]~=nil)then
                if(w>graphic[y]:len())then
                    graphic[y] = graphic[y]..(tHex[base.bgColor]):rep(w-graphic[y]:len())
                else
                    graphic[y] = graphic[y]:sub(1,w)
                end
            else
                graphic[y] = (tHex[base.bgColor]):rep(w)
            end
        end
    end
    redrawCanvasSize()
    

    local function shrink()    
        local function parseLine( tImageArg, sLine )
            local tLine = {}
            for x=1,sLine:len() do
                tLine[x] = tColourLookup[ string.byte(sLine,x,x) ] or 0
            end
            table.insert( tImageArg, tLine )
        end
        function parseImage( sRawData )
            if type( sRawData ) ~= "string" then
                error( "bad argument #1 (expected string, got " .. type( sRawData ) .. ")" )
            end
            local tImage = {}
            for sLine in ( sRawData .. "\n" ):gmatch( "(.-)\n" ) do
                parseLine( tImage, sLine )
            end
            return tImage
        end

        local rawImg = ""      
        for y=1,#graphic do
            if(y==#graphic)then
                rawImg = rawImg..graphic[y]
            else
                rawImg = rawImg..graphic[y].."\n"
            end
        end
        local img = parseImage(rawImg)
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

        local results, width, height, bgCol = { {}, {}, {} }, 0, #img + #img % 3, base.bgColor or colors.black
        for i = 1, #img do
            if #img[i] > width then
                width = #img[i]
            end
        end

        for y = 0, height - 1, 3 do
            local cRow, tRow, bRow, counter = {}, {}, {}, 1

            for x = 0, width - 1, 2 do
                -- Grab a 2x3 chunk:
                local pattern, totals = {}, {}

                for yy = 1, 3 do
                    for xx = 1, 2 do
                        pattern[#pattern + 1] = (img[y + yy] and img[y + yy][x + xx]) and (img[y + yy][x + xx] == 0 and bgCol or img[y + yy][x + xx]) or bgCol
                        totals[pattern[#pattern]] = totals[pattern[#pattern]] and (totals[pattern[#pattern]] + 1) or 1
                    end
                end

                cRow[counter], tRow[counter], bRow[counter] = colsToChar(pattern, totals)
                counter = counter + 1
            end

            results[1][#results[1] + 1], results[2][#results[2] + 1], results[3][#results[3] + 1] = table.concat(cRow), table.concat(tRow), table.concat(bRow)
        end

        results.width, results.height = #results[1][1], #results[1]

        shrinkedGraphic = results
    end

    local function redraw()
        local w,h = w,h
        if(isGraphicShrinked)then w = w*2 h = h*3 end
        for k,v in pairs(graphicObjects)do
            for a,b in pairs(v[1])do
                setBG(b.x, b.y, w, h, v[2])
            end
        end
        if(isGraphicShrinked)then
            shrink()
        end
    end

    local object = {
        init = function(self)
            self.bgColor = self.parent:getTheme("GraphicBG")
        end,

        getType = function(self)
            return objectType
        end;

        setSize = function(self, width, height, rel)
            base.setSize(self, width, height, rel)
            if not(canvasSizeChanged)then
                w = width
                h = height
                redrawCanvasSize()
            end
            redraw()
            return self
        end,

        setOffset = function(self, x, y)
            xOffset = x or xOffset
            yOffset = y or yOffset
            return self
        end,

        setCanvasSize = function(self, width, height)
            w,h = width,height
            canvasSizeChanged = true
            redrawCanvasSize()
            return self
        end,

        clearCanvas = function(self)
            graphicObjects = {}
            graphic = {}
            redrawCanvasSize()
        end,

        getOffset = function(self)
            return xOffset,yOffset
        end,

        setValuesByXMLData = function(self, data)
            base.setValuesByXMLData(self, data)
            if(xmlValue("text", data)~=nil)then self:setText(xmlValue("text", data)) end
            if(xmlValue("xOffset", data)~=nil)then self:setOffset(xmlValue("xOffset", data), yOffset) end
            if(xmlValue("yOffset", data)~=nil)then self:setOffset(xOffset, xmlValue("yOffset", data)) end
            if(xmlValue("wCanvas", data)~=nil)then w = xmlValue("wCanvas", data) end
            if(xmlValue("hCanvas", data)~=nil)then h = xmlValue("hCanvas", data) end
            if(xmlValue("shrink", data)~=nil)then if(xmlValue("shrink", data))then self:shrink() end end
            if(xmlValue("dragable", data)~=nil)then if(xmlValue("dragable", data))then dragable = true end end
            if(data["ellipse"]~=nil)then
                local tab = data["ellipse"]
                if(tab.properties~=nil)then tab = {tab} end
                for k,v in pairs(tab)do
                    local col = colors[xmlValue("color", v)]
                    local rad1 = xmlValue("radius", v)
                    local rad2 = xmlValue("radius2", v)
                    local x = xmlValue("x", v)
                    local y = xmlValue("y", v)
                    local filled = xmlValue("filled", v)
                    self:addEllipse(col, rad1, rad2, x, y, filled)
                end
            end
            if(data["circle"]~=nil)then
                local tab = data["circle"]
                if(tab.properties~=nil)then tab = {tab} end
                for k,v in pairs(tab)do
                    local col = colors[xmlValue("color", v)]
                    local rad = tonumber(xmlValue("radius", v))
                    local x = tonumber(xmlValue("x", v))
                    local y = tonumber(xmlValue("y", v))
                    local filled = xmlValue("filled", v)
                    self:addCircle(col, rad, x, y, filled)
                end
            end
            if(data["line"]~=nil)then
                local tab = data["line"]
                if(tab.properties~=nil)then tab = {tab} end
                for k,v in pairs(tab)do
                    local col = colors[xmlValue("color", v)]
                    local x = tonumber(xmlValue("x", v))
                    local x2 = tonumber(xmlValue("x2", v))
                    local y = tonumber(xmlValue("y", v))
                    local y2 = tonumber(xmlValue("y2", v))
                    self:addLine(col, x, y, x2, y2)
                end
            end

            if(data["rectangle"]~=nil)then
                local tab = data["rectangle"]
                if(tab.properties~=nil)then tab = {tab} end
                for k,v in pairs(tab)do
                    local col = colors[xmlValue("color", v)]
                    local x = tonumber(xmlValue("x", v))
                    local x2 = tonumber(xmlValue("x2", v))
                    local y = tonumber(xmlValue("y", v))
                    local y2 = tonumber(xmlValue("y2", v))
                    local filled = xmlValue("filled", v)=="true" and true or false
                    self:addRectangle(col, x, y, x2, y2, filled)
                end
            end
            if(data["triangle"]~=nil)then
                local tab = data["triangle"]
                if(tab.properties~=nil)then tab = {tab} end
                for k,v in pairs(tab)do
                    local col = colors[xmlValue("color", v)]
                    local x = tonumber(xmlValue("x", v))
                    local x2 = tonumber(xmlValue("x2", v))
                    local x3 = tonumber(xmlValue("x2", v))
                    local y = tonumber(xmlValue("y", v))
                    local y2 = tonumber(xmlValue("y2", v))
                    local y3 = tonumber(xmlValue("y3", v))
                    local filled = xmlValue("filled", v)
                    self:addTriangle(col, x, y, x2, y2, x3, y3, filled)
                end
            end

            return self
        end,

        addCircle = function(self, color, rad, x, y, filled)
            local col = tHex[color]
            table.insert(graphicObjects, {geometric.circle(x or 1, y or 1, rad, filled), tHex[color]})
            redraw()
            return self
        end;

        addEllipse = function(self, color, rad, rad2, x, y, filled)
            table.insert(graphicObjects, {geometric.ellipse(x or 1, y or 1, rad, rad2, filled), tHex[color]})
            redraw()
            return self
        end;

        addLine = function(self, color, x1, y1, x2, y2)
            table.insert(graphicObjects, {geometric.line(x1 or 1, y1 or 1, x2 or 1, y2 or 1), tHex[color]})
            redraw()
            return self
        end;

        addTriangle = function(self, color, x1, y1, x2, y2, x3, y3, filled)
            table.insert(graphicObjects, {geometric.triangle(x1 or 1, y1 or 1, x2 or 1, y2 or 1, x3 or 1, y3 or 1, filled), tHex[color]})
            redraw()
            return self
        end;

        addRectangle = function(self, color, x1, y1, x2, y2, filled)
            table.insert(graphicObjects, {geometric.rectangle(x1 or 1, y1 or 1, x2 or 1, y2 or 1, filled), tHex[color]})
            redraw()
            return self
        end;

        shrink = function(self)
            isGraphicShrinked = true
            redrawCanvasSize()
            shrink()
            return self
        end,

        setDragable = function(self, drag)
            dragable = drag == true and true or false
            return self
        end,

        mouseHandler = function(self, event, button, x, y)
            if(base.mouseHandler(self, event, button, x, y))then
                if(dragable)then
                    if(event=="mouse_click")then
                        xMouse,yMouse = x,y
                    end

                    if(event=="mouse_drag")then
                        if(xMouse~=nil)and(yMouse~=nil)then
                            xOffset = max(min(xOffset+xMouse-x, w-self:getWidth()),0)
                            xMouse = x
                            yOffset = max(min(yOffset+yMouse-y, h-self:getHeight()),0)
                            yMouse = y
                        end
                    end
                end
                return true
            end
            return false
        end,

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    local w,h = self:getSize()
                    if(self.bgColor~=false)then 
                        self.parent:drawBackgroundBox(obx, oby, w, h, self.bgColor)
                    end
                    if (isGraphicShrinked) then
                        -- this is copy pasted (and slightly changed) from blittle by Bomb Bloke: http://www.computercraft.info/forums2/index.php?/topic/25354-cc-176-blittle-api/
                        local t, tC, bC = shrinkedGraphic[1], shrinkedGraphic[2], shrinkedGraphic[3]
                        for i = 1, shrinkedGraphic.height do
                            local x, y = obx+xOffset, oby + i - 1 + yOffset
                            if(y>oby-1)and(y<=oby+h-1)and(x<=w+obx)then
                                local tI = t[i]
                                local xpos,substart,subend = max(x, obx), max(1 - x + 1, 1), min(w - (x-obx), w)
                                if type(tI) == "string" then
                                    self.parent:setText(xpos, y, sub(tI, substart, subend))
                                    self.parent:setFG(xpos, y, sub(tC[i], substart, subend))
                                    self.parent:setBG(xpos, y, sub(bC[i], substart, subend))
                                elseif type(tI) == "table" then
                                    self.parent:setText(xpos, y, sub(tI[2], substart, subend))
                                    self.parent:setFG(xpos, y, sub(tC[i], substart, subend))
                                    self.parent:setBG(xpos, y, sub(bC[i], substart, subend))
                                end
                            end
                        end
                    else
                        for i = 1, #graphic do
                            local x, y = obx+xOffset, oby + i - 1 + yOffset
                            if(y>oby-1)and(y<=oby+h-1)and(x<=w+obx)then
                                local xpos,substart,subend = max(x, obx), max(1 - x + 1, 1), min(w - (x-obx), w)
                                self.parent:setBG(xpos, y, sub(graphic[i],substart,subend))
                            end
                        end
                    end
                end
                self:setVisualChanged(false)
            end
        end;
    }

    return setmetatable(object, base)
end