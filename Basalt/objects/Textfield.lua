local tHex = require("tHex")

local rep,find,gmatch,sub,len = string.rep,string.find,string.gmatch,string.sub,string.len

return function(name, basalt)
    local base = basalt.getObject("ChangeableObject")(name, basalt)
    local objectType = "Textfield"
    local hIndex, wIndex, textX, textY = 1, 1, 1, 1

    local lines = { "" }
    local bgLines = { "" }
    local fgLines = { "" }
    local keyWords = { }
    local rules = { }

    local startSelX,endSelX,startSelY,endSelY

    local selectionBG,selectionFG = colors.lightBlue,colors.black

    base:setSize(30, 12)
    base:setZIndex(5)

    local function isSelected()
        if(startSelX~=nil)and(endSelX~=nil)and(startSelY~=nil)and(endSelY~=nil)then
            return true
        end
        return false
    end

    local function getSelectionCoordinates()
        local sx, ex, sy, ey = startSelX, endSelX, startSelY, endSelY
        if isSelected() then
            if startSelX < endSelX and startSelY <= endSelY then
                sx = startSelX
                ex = endSelX
                if startSelY < endSelY then
                    sy = startSelY
                    ey = endSelY
                else
                    sy = endSelY
                    ey = startSelY
                end
            elseif startSelX > endSelX and startSelY >= endSelY then
                sx = endSelX
                ex = startSelX
                if startSelY > endSelY then
                    sy = endSelY
                    ey = startSelY
                else
                    sy = startSelY
                    ey = endSelY
                end
            elseif startSelY > endSelY then
                sx = endSelX
                ex = startSelX
                sy = endSelY
                ey = startSelY
            end
            return sx, ex, sy, ey
        end
    end

    local function removeSelection(self)
        local sx, ex, sy, ey = getSelectionCoordinates(self)
        local startLine = lines[sy]
        local endLine = lines[ey]
        lines[sy] = startLine:sub(1, sx - 1) .. endLine:sub(ex + 1, endLine:len())
        bgLines[sy] = bgLines[sy]:sub(1, sx - 1) .. bgLines[ey]:sub(ex + 1, bgLines[ey]:len())
        fgLines[sy] = fgLines[sy]:sub(1, sx - 1) .. fgLines[ey]:sub(ex + 1, fgLines[ey]:len())
    
        for i = ey, sy + 1, -1 do
            if i ~= sy then
                table.remove(lines, i)
                table.remove(bgLines, i)
                table.remove(fgLines, i)
            end
        end
    
        textX, textY = sx, sy
        startSelX, endSelX, startSelY, endSelY = nil, nil, nil, nil
        return self
    end

    local function stringGetPositions(str, word)
        local pos = {}
        if(str:len()>0)then
            for w in gmatch(str, word)do
                local s, e = find(str, w)
                if(s~=nil)and(e~=nil)then
                    table.insert(pos,s)
                    table.insert(pos,e)
                    local startL = sub(str, 1, (s-1))
                    local endL = sub(str, e+1, str:len())
                    str = startL..(":"):rep(w:len())..endL
                end
            end
        end
        return pos
    end

    local function updateColors(self, l)
        l = l or textY
        local fgLine = tHex[self:getForeground()]:rep(fgLines[l]:len())
        local bgLine = tHex[self:getBackground()]:rep(bgLines[l]:len())
        for k,v in pairs(rules)do
            local pos = stringGetPositions(lines[l], v[1])
            if(#pos>0)then
                for x=1,#pos/2 do
                    local xP = x*2 - 1
                    if(v[2]~=nil)then
                        fgLine = fgLine:sub(1, pos[xP]-1)..tHex[v[2]]:rep(pos[xP+1]-(pos[xP]-1))..fgLine:sub(pos[xP+1]+1, fgLine:len())
                    end
                    if(v[3]~=nil)then
                        bgLine = bgLine:sub(1, pos[xP]-1)..tHex[v[3]]:rep(pos[xP+1]-(pos[xP]-1))..bgLine:sub(pos[xP+1]+1, bgLine:len())
                    end
                end
            end
        end
        for k,v in pairs(keyWords)do
            for _,b in pairs(v)do
                local pos = stringGetPositions(lines[l], b)
                if(#pos>0)then
                    for x=1,#pos/2 do
                        local xP = x*2 - 1
                        fgLine = fgLine:sub(1, pos[xP]-1)..tHex[k]:rep(pos[xP+1]-(pos[xP]-1))..fgLine:sub(pos[xP+1]+1, fgLine:len())
                    end
                end
            end
        end
        fgLines[l] = fgLine
        bgLines[l] = bgLine
        self:updateDraw()
    end

    local function updateAllColors(self)
        for n=1,#lines do
            updateColors(self, n)
        end
    end

    local object = {
        getType = function(self)
            return objectType
        end;

        setBackground = function(self, bg)
            base.setBackground(self, bg)
            updateAllColors(self)
            return self
        end,

        setForeground = function(self, fg)
            base.setForeground(self, fg)
            updateAllColors(self)
            return self
        end,

        setSelection = function(self, fg, bg)
            selectionFG = fg or selectionFG
            selectionBG = bg or selectionBG
            return self
        end,

        getSelection = function(self)
            return selectionFG, selectionBG
        end,

        getLines = function(self)
            return lines
        end,

        getLine = function(self, index)
            return lines[index]
        end,

        editLine = function(self, index, text)
            lines[index] = text or lines[index]
            updateColors(self, index)
            self:updateDraw()
            return self
        end,

        clear = function(self)
            lines = {""}
            bgLines = {""}
            fgLines = {""}
            startSelX,endSelX,startSelY,endSelY = nil,nil,nil,nil
            hIndex, wIndex, textX, textY = 1, 1, 1, 1
            self:updateDraw()
            return self
        end,

        addLine = function(self, text, index)
            if(text~=nil)then
                local bgColor = self:getBackground()
                local fgColor = self:getForeground()
                if(#lines==1)and(lines[1]=="")then
                    lines[1] = text
                    bgLines[1] = tHex[bgColor]:rep(text:len())
                    fgLines[1] = tHex[fgColor]:rep(text:len())
                    updateColors(self, 1)
                    return self
                end
                if (index ~= nil) then
                    table.insert(lines, index, text)
                    table.insert(bgLines, index, tHex[bgColor]:rep(text:len()))
                    table.insert(fgLines, index, tHex[fgColor]:rep(text:len()))
                else
                    table.insert(lines, text)
                    table.insert(bgLines, tHex[bgColor]:rep(text:len()))
                    table.insert(fgLines, tHex[fgColor]:rep(text:len()))
                end
            end
            updateColors(self, index or #lines)
            self:updateDraw()
            return self
        end;

        addKeywords = function(self, color, tab)
            if(keyWords[color]==nil)then
                keyWords[color] = {}
            end
            for k,v in pairs(tab)do
                table.insert(keyWords[color], v)
            end
            self:updateDraw()
            return self
        end;

        addRule = function(self, rule, fg, bg)
            table.insert(rules, {rule, fg, bg})
            self:updateDraw()
            return self
        end;

        editRule = function(self, rule, fg, bg)
            for k,v in pairs(rules)do
                if(v[1]==rule)then
                    rules[k][2] = fg
                    rules[k][3] = bg
                end
            end
            self:updateDraw()
            return self
        end;

        removeRule = function(self, rule)
            for k,v in pairs(rules)do
                if(v[1]==rule)then
                    table.remove(rules, k)
                end
            end
            self:updateDraw()
            return self
        end,

        setKeywords = function(self, color, tab)
            keyWords[color] = tab
            self:updateDraw()
            return self
        end,

        removeLine = function(self, index)
            if(#lines>1)then
                table.remove(lines, index or #lines)
                table.remove(bgLines, index or #bgLines)
                table.remove(fgLines, index or #fgLines)
            else
                lines = {""}
                bgLines = {""}
                fgLines = {""}
            end
            self:updateDraw()
            return self
        end,

        getTextCursor = function(self)
            return textX, textY
        end,

        getOffset = function(self)
            return wIndex, hIndex
        end,

        setOffset = function(self, xOff, yOff)
            wIndex = xOff or wIndex
            hIndex = yOff or hIndex
            self:updateDraw()
            return self
        end,

        getFocusHandler = function(self)
            base.getFocusHandler(self)
            local obx, oby = self:getPosition()
            self:getParent():setCursor(true, obx + textX - wIndex, oby + textY - hIndex, self:getForeground())
        end,

        loseFocusHandler = function(self)
            base.loseFocusHandler(self)
            self:getParent():setCursor(false)
        end,

        keyHandler = function(self, key)
            if (base.keyHandler(self, event, key)) then
                local parent = self:getParent()
                local obx, oby = self:getPosition()
                local w,h = self:getSize()
                    if (key == keys.backspace) then
                        -- on backspace
                        if(isSelected())then
                            removeSelection(self)
                        else
                            if (lines[textY] == "") then
                                if (textY > 1) then
                                    table.remove(lines, textY)
                                    table.remove(fgLines, textY)
                                    table.remove(bgLines, textY)
                                    textX = lines[textY - 1]:len() + 1
                                    wIndex = textX - w + 1
                                    if (wIndex < 1) then
                                        wIndex = 1
                                    end
                                    textY = textY - 1
                                end
                            elseif (textX <= 1) then
                                if (textY > 1) then
                                    textX = lines[textY - 1]:len() + 1
                                    wIndex = textX - w + 1
                                    if (wIndex < 1) then
                                        wIndex = 1
                                    end
                                    lines[textY - 1] = lines[textY - 1] .. lines[textY]
                                    fgLines[textY - 1] = fgLines[textY - 1] .. fgLines[textY]
                                    bgLines[textY - 1] = bgLines[textY - 1] .. bgLines[textY]
                                    table.remove(lines, textY)
                                    table.remove(fgLines, textY)
                                    table.remove(bgLines, textY)
                                    textY = textY - 1
                                end
                            else
                                lines[textY] = lines[textY]:sub(1, textX - 2) .. lines[textY]:sub(textX, lines[textY]:len())
                                fgLines[textY] = fgLines[textY]:sub(1, textX - 2) .. fgLines[textY]:sub(textX, fgLines[textY]:len())
                                bgLines[textY] = bgLines[textY]:sub(1, textX - 2) .. bgLines[textY]:sub(textX, bgLines[textY]:len())
                                if (textX > 1) then
                                    textX = textX - 1
                                end
                                if (wIndex > 1) then
                                    if (textX < wIndex) then
                                        wIndex = wIndex - 1
                                    end
                                end
                            end
                            if (textY < hIndex) then
                                hIndex = hIndex - 1
                            end
                        end
                        updateColors(self)
                        self:setValue("")
                    elseif (key == keys.delete) then
                        -- on delete
                        if(isSelected())then
                            removeSelection(self)
                        else
                            if (textX > lines[textY]:len()) then
                                if (lines[textY + 1] ~= nil) then
                                    lines[textY] = lines[textY] .. lines[textY + 1]
                                    table.remove(lines, textY + 1)
                                    table.remove(bgLines, textY + 1)
                                    table.remove(fgLines, textY + 1)
                                end
                            else
                                lines[textY] = lines[textY]:sub(1, textX - 1) .. lines[textY]:sub(textX + 1, lines[textY]:len())
                                fgLines[textY] = fgLines[textY]:sub(1, textX - 1) .. fgLines[textY]:sub(textX + 1, fgLines[textY]:len())
                                bgLines[textY] = bgLines[textY]:sub(1, textX - 1) .. bgLines[textY]:sub(textX + 1, bgLines[textY]:len())
                            end
                        end
                        updateColors(self)
                    elseif (key == keys.enter) then
                        if(isSelected())then
                            removeSelection(self)
                        end
                        -- on enter
                        table.insert(lines, textY + 1, lines[textY]:sub(textX, lines[textY]:len()))
                        table.insert(fgLines, textY + 1, fgLines[textY]:sub(textX, fgLines[textY]:len()))
                        table.insert(bgLines, textY + 1, bgLines[textY]:sub(textX, bgLines[textY]:len()))
                        lines[textY] = lines[textY]:sub(1, textX - 1)
                        fgLines[textY] = fgLines[textY]:sub(1, textX - 1)
                        bgLines[textY] = bgLines[textY]:sub(1, textX - 1)
                        textY = textY + 1
                        textX = 1
                        wIndex = 1
                        if (textY - hIndex >= h) then
                            hIndex = hIndex + 1
                        end
                        self:setValue("")
                    elseif (key == keys.up) then
                        startSelX, startSelY, endSelX, endSelY = nil, nil, nil, nil
                        -- arrow up
                        if (textY > 1) then
                            textY = textY - 1
                            if (textX > lines[textY]:len() + 1) then
                                textX = lines[textY]:len() + 1
                            end
                            if (wIndex > 1) then
                                if (textX < wIndex) then
                                    wIndex = textX - w + 1
                                    if (wIndex < 1) then
                                        wIndex = 1
                                    end
                                end
                            end
                            if (hIndex > 1) then
                                if (textY < hIndex) then
                                    hIndex = hIndex - 1
                                end
                            end
                        end
                    elseif (key == keys.down) then
                        startSelX, startSelY, endSelX, endSelY = nil, nil, nil, nil
                        -- arrow down
                        if (textY < #lines) then
                            textY = textY + 1
                            if (textX > lines[textY]:len() + 1) then
                                textX = lines[textY]:len() + 1
                            end
                            if (wIndex > 1) then
                                if (textX < wIndex) then
                                    wIndex = textX - w + 1
                                    if (wIndex < 1) then
                                        wIndex = 1
                                    end
                                end
                            end
                            if (textY >= hIndex + h) then
                                hIndex = hIndex + 1
                            end
                        end
                    elseif (key == keys.right) then
                        startSelX, startSelY, endSelX, endSelY = nil, nil, nil, nil
                        -- arrow right
                        textX = textX + 1
                        if (textY < #lines) then
                            if (textX > lines[textY]:len() + 1) then
                                textX = 1
                                textY = textY + 1
                            end
                        elseif (textX > lines[textY]:len()) then
                            textX = lines[textY]:len() + 1
                        end
                        if (textX < 1) then
                            textX = 1
                        end
                        if (textX < wIndex) or (textX >= w + wIndex) then
                            wIndex = textX - w + 1
                        end
                        if (wIndex < 1) then
                            wIndex = 1
                        end

                    elseif (key == keys.left) then
                        startSelX, startSelY, endSelX, endSelY = nil, nil, nil, nil
                        -- arrow left
                        textX = textX - 1
                        if (textX >= 1) then
                            if (textX < wIndex) or (textX >= w + wIndex) then
                                wIndex = textX
                            end
                        end
                        if (textY > 1) then
                            if (textX < 1) then
                                textY = textY - 1
                                textX = lines[textY]:len() + 1
                                wIndex = textX - w + 1
                            end
                        end
                        if (textX < 1) then
                            textX = 1
                        end
                        if (wIndex < 1) then
                            wIndex = 1
                        end
                    elseif(key == keys.tab)then
                        if(textX % 3 == 0 )then
                            lines[textY] = lines[textY]:sub(1, textX - 1) .. " " .. lines[textY]:sub(textX, lines[textY]:len())
                            fgLines[textY] = fgLines[textY]:sub(1, textX - 1) .. tHex[self:getForeground()] .. fgLines[textY]:sub(textX, fgLines[textY]:len())
                            bgLines[textY] = bgLines[textY]:sub(1, textX - 1) .. tHex[self:getBackground()] .. bgLines[textY]:sub(textX, bgLines[textY]:len())
                            textX = textX + 1
                        end
                        while textX % 3 ~= 0 do
                            lines[textY] = lines[textY]:sub(1, textX - 1) .. " " .. lines[textY]:sub(textX, lines[textY]:len())
                            fgLines[textY] = fgLines[textY]:sub(1, textX - 1) .. tHex[self:getForeground()] .. fgLines[textY]:sub(textX, fgLines[textY]:len())
                            bgLines[textY] = bgLines[textY]:sub(1, textX - 1) .. tHex[self:getBackground()] .. bgLines[textY]:sub(textX, bgLines[textY]:len())
                            textX = textX + 1
                        end
                    end

                if not((obx + textX - wIndex >= obx and obx + textX - wIndex < obx + w) and (oby + textY - hIndex >= oby and oby + textY - hIndex < oby + h)) then
                    wIndex = math.max(1, lines[textY]:len()-w+1)
                    hIndex = math.max(1, textY - h + 1)
                end

                local cursorX = (textX <= lines[textY]:len() and textX - 1 or lines[textY]:len()) - (wIndex - 1)
                if (cursorX > self:getX() + w - 1) then
                    cursorX = self:getX() + w - 1
                end
                local cursorY = (textY - hIndex < h and textY - hIndex or textY - hIndex - 1)
                if (cursorX < 1) then
                    cursorX = 0
                end
                parent:setCursor(true, obx + cursorX, oby + cursorY, self:getForeground())
                self:updateDraw()
                return true
            end
        end,

        charHandler = function(self, char)
            if(base.charHandler(self, char))then
                local parent = self:getParent()
                local obx, oby = self:getPosition()
                local w,h = self:getSize()
                if(isSelected())then
                    removeSelection(self)
                end
                lines[textY] = lines[textY]:sub(1, textX - 1) .. char .. lines[textY]:sub(textX, lines[textY]:len())
                fgLines[textY] = fgLines[textY]:sub(1, textX - 1) .. tHex[self:getForeground()] .. fgLines[textY]:sub(textX, fgLines[textY]:len())
                bgLines[textY] = bgLines[textY]:sub(1, textX - 1) .. tHex[self:getBackground()] .. bgLines[textY]:sub(textX, bgLines[textY]:len())
                textX = textX + 1
                if (textX >= w + wIndex) then
                    wIndex = wIndex + 1
                end
                updateColors(self)
                self:setValue("")

                if not((obx + textX - wIndex >= obx and obx + textX - wIndex < obx + w) and (oby + textY - hIndex >= oby and oby + textY - hIndex < oby + h)) then
                    wIndex = math.max(1, lines[textY]:len()-w+1)
                    hIndex = math.max(1, textY - h + 1)
                end

                local cursorX = (textX <= lines[textY]:len() and textX - 1 or lines[textY]:len()) - (wIndex - 1)
                if (cursorX > self:getX() + w - 1) then
                    cursorX = self:getX() + w - 1
                end
                local cursorY = (textY - hIndex < h and textY - hIndex or textY - hIndex - 1)
                if (cursorX < 1) then
                    cursorX = 0
                end
                parent:setCursor(true, obx + cursorX, oby + cursorY, self:getForeground())
                self:updateDraw()
                return true
            end
        end,

        dragHandler = function(self, button, x, y)
            if (base.dragHandler(self, button, x, y)) then
                local parent = self:getParent()
                local obx, oby = self:getAbsolutePosition()
                local anchx, anchy = self:getPosition()
                local w,h = self:getSize()
                if (lines[y - oby + hIndex] ~= nil) then
                    if anchx <= x - obx + wIndex and anchx + w > x - obx + wIndex then
                        textX = x - obx + wIndex
                        textY = y - oby + hIndex
                
                        if textX > lines[textY]:len() then
                            textX = lines[textY]:len() + 1
                        end

                        endSelX = textX
                        endSelY = textY
                        
                        if textX < wIndex then
                            wIndex = textX - 1
                            if wIndex < 1 then
                                wIndex = 1
                            end
                        end
                        parent:setCursor(not isSelected(), anchx + textX - wIndex, anchy + textY - hIndex, self:getForeground())
                        self:updateDraw()
                    end 
                end
                return true
            end
        end,

        scrollHandler = function(self, dir, x, y)
            if (base.scrollHandler(self, dir, x, y)) then
                local parent = self:getParent()
                local obx, oby = self:getAbsolutePosition()
                local anchx, anchy = self:getPosition()
                local w,h = self:getSize()
                hIndex = hIndex + dir
                if (hIndex > #lines - (h - 1)) then
                    hIndex = #lines - (h - 1)
                end

                if (hIndex < 1) then
                    hIndex = 1
                end

                if (obx + textX - wIndex >= obx and obx + textX - wIndex < obx + w) and (anchy + textY - hIndex >= anchy and anchy + textY - hIndex < anchy + h) then
                    parent:setCursor(not isSelected(), anchx + textX - wIndex, anchy + textY - hIndex, self:getForeground())
                else
                    parent:setCursor(false)
                end
                self:updateDraw()
                return true
            end
        end,

        mouseHandler = function(self, button, x, y)
            if (base.mouseHandler(self, button, x, y)) then
                local parent = self:getParent()
                local obx, oby = self:getAbsolutePosition()
                local anchx, anchy = self:getPosition()
                    if (lines[y - oby + hIndex] ~= nil) then
                        textX = x - obx + wIndex
                        textY = y - oby + hIndex
                        endSelX = nil
                        endSelY = nil
                        startSelX = textX
                        startSelY = textY
                        if (textX > lines[textY]:len()) then
                            textX = lines[textY]:len() + 1
                            startSelX = textX
                        end
                        if (textX < wIndex) then
                            wIndex = textX - 1
                            if (wIndex < 1) then
                                wIndex = 1
                            end
                        end
                        self:updateDraw()
                    end
                parent:setCursor(true, anchx + textX - wIndex, anchy + textY - hIndex, self:getForeground())
                return true
            end
        end,

        mouseUpHandler = function(self, button, x, y)
            if (base.mouseUpHandler(self, button, x, y)) then
                local obx, oby = self:getAbsolutePosition()
                local anchx, anchy = self:getPosition()
                    if (lines[y - oby + hIndex] ~= nil) then
                        endSelX = x - obx + wIndex
                        endSelY = y - oby + hIndex
                        if (endSelX > lines[endSelY]:len()) then
                            endSelX = lines[endSelY]:len() + 1
                        end
                        if(startSelX==endSelX)and(startSelY==endSelY)then
                            startSelX, endSelX, startSelY, endSelY = nil, nil, nil, nil
                        end                            
                        self:updateDraw()
                    end
                return true
            end
        end,

        eventHandler = function(self, event, paste, p2, p3, p4)
            if(base.eventHandler(self, event, paste, p2, p3, p4))then
                if(event=="paste")then
                    if(self:isFocused())then
                        local parent = self:getParent()
                        local fgColor, bgColor = self:getForeground(), self:getBackground()
                        local w, h = self:getSize()
                        lines[textY] = lines[textY]:sub(1, textX - 1) .. paste .. lines[textY]:sub(textX, lines[textY]:len())
                        fgLines[textY] = fgLines[textY]:sub(1, textX - 1) .. tHex[fgColor]:rep(paste:len()) .. fgLines[textY]:sub(textX, fgLines[textY]:len())
                        bgLines[textY] = bgLines[textY]:sub(1, textX - 1) .. tHex[bgColor]:rep(paste:len()) .. bgLines[textY]:sub(textX, bgLines[textY]:len())
                        textX = textX + paste:len()
                        if (textX >= w + wIndex) then
                            wIndex = (textX+1)-w
                        end
                        local anchx, anchy = self:getPosition()
                        parent:setCursor(true, anchx + textX - wIndex, anchy + textY - hIndex, fgColor)
                        updateColors(self)
                        self:updateDraw()
                    end
                end
            end
        end,

        draw = function(self)
            base.draw(self)
            self:addDraw("textfield", function()
                local parent = self:getParent()
                local obx, oby = self:getPosition()
                local w, h = self:getSize()
                local bgColor = tHex[self:getBackground()]
                local fgColor = tHex[self:getForeground()]
        
                for n = 1, h do
                    local text = ""
                    local bg = ""
                    local fg = ""
                    if lines[n + hIndex - 1] then
                        text = lines[n + hIndex - 1]
                        fg = fgLines[n + hIndex - 1]
                        bg = bgLines[n + hIndex - 1]
                    end
        
                    text = sub(text, wIndex, w + wIndex - 1)
                    bg = rep(bgColor, w)
                    fg = rep(fgColor, w)
        
                    self:addText(1, n, text)
                    self:addBG(1, n, bg)
                    self:addFG(1, n, fg)
                    self:addBlit(1, n, text, fg, bg)
                end
        
                if startSelX and endSelX and startSelY and endSelY then
                    local sx, ex, sy, ey = getSelectionCoordinates(self)
                    for n = sy, ey do
                        local line = #lines[n]
                        local xOffset = 0
                        if n == sy and n == ey then
                            xOffset = sx - 1
                            line = line - (sx - 1) - (line - ex)
                        elseif n == ey then
                            line = line - (line - ex)
                        elseif n == sy then
                            line = line - (sx - 1)
                            xOffset = sx - 1
                        end
                        self:addBG(1 + xOffset, n, rep(tHex[selectionBG], line))
                        self:addFG(1 + xOffset, n, rep(tHex[selectionFG], line))
                    end
                end
            end)
        end,

        load = function(self)
            self:listenEvent("mouse_click")
            self:listenEvent("mouse_up")
            self:listenEvent("mouse_scroll")
            self:listenEvent("mouse_drag")
            self:listenEvent("key")
            self:listenEvent("char")
            self:listenEvent("other_event")
        end,
    }

    object.__index = object
    return setmetatable(object, base)
end