local Object = require("Object")
local tHex = require("tHex")
local xmlValue = require("utils").getValueFromXML
local log = require("basaltLogs")

local rep,find,gmatch,sub,len = string.rep,string.find,string.gmatch,string.sub,string.len

return function(name)
    local base = Object(name)
    local objectType = "Textfield"
    local hIndex, wIndex, textX, textY = 1, 1, 1, 1

    local lines = { " " }
    local bgLines = { "" }
    local fgLines = { "" }
    local keyWords = { }
    local rules = { }

    local startSelX,endSelX,startSelY,endSelY

    local selectionBG,selectionFG = colors.lightBlue,colors.black

    base.width = 30
    base.height = 12
    base:setZIndex(5)

    local function isSelected()
        if(startSelX~=nil)and(endSelX~=nil)and(startSelY~=nil)and(endSelY~=nil)then
            return true
        end
        return false
    end

    local function getSelectionCoordinates()
        local sx,ex,sy,ey
        if(isSelected())then
            if(startSelX>endSelX)then
                sx,ex = endSelX,startSelX
            else
                sx,ex = startSelX,endSelX
            end
            if(startSelY>endSelY)then
                sy,ey = endSelY,startSelY
            else
                sy,ey = startSelY,endSelY
            end
        end
        return sx,ex,sy,ey
    end

    local function getSelection()

    end

    local function removeSelection(self)
        local sx,ex,sy,ey = getSelectionCoordinates(self)
        for n=ey,sy,-1 do
            if(n==sy)or(n==ey)then
                local l = lines[n]
                local b = bgLines[n]
                local f = fgLines[n]
                if(n==sy)and(n==ey)then
                    l = l:sub(1,sx-1)..l:sub(ex+1,l:len())
                    b = b:sub(1,sx-1)..b:sub(ex+1,b:len())
                    f = f:sub(1,sx-1)..f:sub(ex+1,f:len())
                elseif(n==sx)then
                    l = l:sub(1, sx)
                    b = b:sub(1, sx)
                    f = f:sub(1, sx)
                elseif(n==sy)then
                    l = l:sub(ex, l:len())
                    b = b:sub(ex, b:len())
                    f = f:sub(ex, f:len())
                end
                lines[n] = l
                bgLines[n] = b
                fgLines[n] = f
            else
                table.remove(lines, n)
                table.remove(bgLines, n)
                table.remove(fgLines, n)
            end
        end
        textX,textY = startSelX,startSelY
        startSelX,endSelX,startSelY,endSelY = nil,nil,nil,nil
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
        local fgLine = tHex[self.fgColor]:rep(fgLines[l]:len())
        local bgLine = tHex[self.bgColor]:rep(bgLines[l]:len())
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

        setValuesByXMLData = function(self, data)
            base.setValuesByXMLData(self, data)
            if(data["lines"]~=nil)then
                local l = data["lines"]["line"]
                if(l.properties~=nil)then l = {l} end
                for k,v in pairs(l)do
                    self:addLine(v:value())
                end
            end
            if(data["keywords"]~=nil)then
                for k,v in pairs(data["keywords"])do
                    if(colors[k]~=nil)then
                        local entry = v
                        if(entry.properties~=nil)then entry = {entry} end
                        local tab = {}
                        for a,b in pairs(entry)do
                            local keywordList = b["keyword"]
                            if(b["keyword"].properties~=nil)then keywordList = {b["keyword"]} end
                            for c,d in pairs(keywordList)do
                                table.insert(tab, d:value())
                            end
                        end
                        self:addKeywords(colors[k], tab)
                    end
                end
            end
            if(data["rules"]~=nil)then
                if(data["rules"]["rule"]~=nil)then
                    local tab = data["rules"]["rule"]
                    if(data["rules"]["rule"].properties~=nil)then tab = {data["rules"]["rule"]} end
                    for k,v in pairs(tab)do

                        if(xmlValue("pattern", v)~=nil)then
                            self:addRule(xmlValue("pattern", v), colors[xmlValue("fg", v)], colors[xmlValue("bg", v)])
                        end
                    end
                end
            end
        end,

        getLines = function(self)
            return lines
        end;

        getLine = function(self, index)
            return lines[index]
        end;

        editLine = function(self, index, text)
            lines[index] = text or lines[index]
            updateColors(self, index)
            self:updateDraw()
            return self
        end;

        clear = function(self)
            lines = {" "}
            bgLines = {""}
            fgLines = {""}
            startSelX,endSelX,startSelY,endSelY = nil,nil,nil,nil
            hIndex, wIndex, textX, textY = 1, 1, 1, 1
            self:updateDraw()
            return self
        end,

        addLine = function(self, text, index)
            if(text~=nil)then
                if(#lines==1)and(lines[1]=="")then
                    lines[1] = text
                    bgLines[1] = tHex[self.bgColor]:rep(text:len())
                    fgLines[1] = tHex[self.fgColor]:rep(text:len())
                    updateColors(self, 1)
                    return self
                end
                if (index ~= nil) then
                    table.insert(lines, index, text)
                    table.insert(bgLines, index, tHex[self.bgColor]:rep(text:len()))
                    table.insert(fgLines, index, tHex[self.fgColor]:rep(text:len()))
                else
                    table.insert(lines, text)
                    table.insert(bgLines, tHex[self.bgColor]:rep(text:len()))
                    table.insert(fgLines, tHex[self.fgColor]:rep(text:len()))
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
        end;

        setKeywords = function(self, color, tab)
            keyWords[color] = tab
            self:updateDraw()
            return self
        end;

        removeLine = function(self, index)
            if(#lines>1)then
                table.remove(lines, index or #lines)
                table.remove(bgLines, index or #bgLines)
                table.remove(fgLines, index or #fgLines)
            else
                lines = {" "}
                bgLines = {""}
                fgLines = {""}
            end
            self:updateDraw()
            return self
        end;

        getTextCursor = function(self)
            return textX, textY
        end;

        getFocusHandler = function(self)
            base.getFocusHandler(self)
            if (self.parent ~= nil) then
                local obx, oby = self:getAnchorPosition()
                if (self.parent ~= nil) then
                    self.parent:setCursor(true, obx + textX - wIndex, oby + textY - hIndex, self.fgColor)
                end
            end
        end;

        loseFocusHandler = function(self)
            base.loseFocusHandler(self)
            if (self.parent ~= nil) then
                self.parent:setCursor(false)
            end
        end;

        keyHandler = function(self, key)
            if (base.keyHandler(self, event, key)) then
                local obx, oby = self:getAnchorPosition()
                local w,h = self:getSize()
                    if (key == keys.backspace) then
                        -- on backspace
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
                        updateColors(self)
                        self:setValue("")
                    end

                    if (key == keys.delete) then
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
                    end

                    if (key == keys.enter) then
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
                    end

                    if (key == keys.up) then
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
                    end
                    if (key == keys.down) then
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
                    end
                    if (key == keys.right) then
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

                    end
                    if (key == keys.left) then
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
                self.parent:setCursor(true, obx + cursorX, oby + cursorY, self.fgColor)
                self:updateDraw()
                return true
            end
        end,

        charHandler = function(self, char)
            if(base.charHandler(self, char))then
                local obx, oby = self:getAnchorPosition()
                local w,h = self:getSize()
                lines[textY] = lines[textY]:sub(1, textX - 1) .. char .. lines[textY]:sub(textX, lines[textY]:len())
                fgLines[textY] = fgLines[textY]:sub(1, textX - 1) .. tHex[self.fgColor] .. fgLines[textY]:sub(textX, fgLines[textY]:len())
                bgLines[textY] = bgLines[textY]:sub(1, textX - 1) .. tHex[self.bgColor] .. bgLines[textY]:sub(textX, bgLines[textY]:len())
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
                if(isSelected())then
                    removeSelection(self)
                end
                self.parent:setCursor(true, obx + cursorX, oby + cursorY, self.fgColor)
                self:updateDraw()
                return true
            end
        end,

        dragHandler = function(self, button, x, y)
            if (base.dragHandler(self, button, x, y)) then
                local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
                local anchx, anchy = self:getAnchorPosition()
                local w,h = self:getSize()
                if (lines[y - oby + hIndex] ~= nil) then
                    if(anchx+w > anchx + x - (obx+1)+ wIndex)and(anchx < anchx + x - obx+ wIndex)then
                        textX = x - obx + wIndex
                        textY = y - oby + hIndex
                        endSelX = textX
                        endSelY = textY
                        if (textX > lines[textY]:len()) then
                            textX = lines[textY]:len() + 1
                            endSelX = textX
                        end

                        if (textX < wIndex) then
                            wIndex = textX - 1
                            if (wIndex < 1) then
                                wIndex = 1
                            end
                        end
                        self.parent:setCursor(true, anchx + textX - wIndex, anchy + textY - hIndex, self.fgColor)

                        self:updateDraw()
                    end
                end
                return true
            end
        end,

        scrollHandler = function(self, dir, x, y)
            if (base.scrollHandler(self, dir, x, y)) then
                local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
                local anchx, anchy = self:getAnchorPosition()
                local w,h = self:getSize()
                hIndex = hIndex + dir
                if (hIndex > #lines - (h - 1)) then
                    hIndex = #lines - (h - 1)
                end

                if (hIndex < 1) then
                    hIndex = 1
                end

                if (obx + textX - wIndex >= obx and obx + textX - wIndex < obx + w) and (anchy + textY - hIndex >= anchy and anchy + textY - hIndex < anchy + h) then
                    self.parent:setCursor(true, anchx + textX - wIndex, anchy + textY - hIndex, self.fgColor)
                else
                    self.parent:setCursor(false)
                end
                self:updateDraw()
                return true
            end
        end,

        mouseHandler = function(self, button, x, y)
            if (base.mouseHandler(self, button, x, y)) then
                local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
                local anchx, anchy = self:getAnchorPosition()
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
                    if (self.parent ~= nil) then
                        self.parent:setCursor(true, anchx + textX - wIndex, anchy + textY - hIndex, self.fgColor)
                    end
                return true
            end
        end,

        mouseUpHandler = function(self, button, x, y)
            if (base.mouseUpHandler(self, button, x, y)) then
                local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
                local anchx, anchy = self:getAnchorPosition()
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
                        local w, h = self:getSize()
                        lines[textY] = lines[textY]:sub(1, textX - 1) .. paste .. lines[textY]:sub(textX, lines[textY]:len())
                        fgLines[textY] = fgLines[textY]:sub(1, textX - 1) .. tHex[self.fgColor]:rep(paste:len()) .. fgLines[textY]:sub(textX, fgLines[textY]:len())
                        bgLines[textY] = bgLines[textY]:sub(1, textX - 1) .. tHex[self.bgColor]:rep(paste:len()) .. bgLines[textY]:sub(textX, bgLines[textY]:len())
                        textX = textX + paste:len()
                        if (textX >= w + wIndex) then
                            wIndex = (textX+1)-w
                        end
                        local anchx, anchy = self:getAnchorPosition()
                        self.parent:setCursor(true, anchx + textX - wIndex, anchy + textY - hIndex, self.fgColor)
                        updateColors(self)
                        self:updateDraw()
                    end
                end
            end
        end,

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    local w,h = self:getSize()
                    for n = 1, h do
                        local text = ""
                        local bg = ""
                        local fg = ""
                        if (lines[n + hIndex - 1] ~= nil) then
                            text = lines[n + hIndex - 1]
                            fg = fgLines[n + hIndex - 1]
                            bg = bgLines[n + hIndex - 1]
                        end
                        text = text:sub(wIndex, w + wIndex - 1)
                        bg = bg:sub(wIndex, w + wIndex - 1)
                        fg = fg:sub(wIndex, w + wIndex - 1)
                        local space = w - text:len()
                        if (space < 0) then
                            space = 0
                        end
                        text = text .. rep(self.bgSymbol, space)
                        bg = bg .. rep(tHex[self.bgColor], space)
                        fg = fg .. rep(tHex[self.fgColor], space)
                        self.parent:setText(obx, oby + n - 1, text)
                        self.parent:setBG(obx, oby + n - 1, bg)
                        self.parent:setFG(obx, oby + n - 1, fg)
                    end
                    if(startSelX~=nil)and(endSelX~=nil)and(startSelY~=nil)and(endSelY~=nil)then
                        local sx,ex,sy,ey = getSelectionCoordinates(self)
                        for n=sy,ey do
                            local line = lines[n]:len()
                            local xOffset = 0
                            if(n==sy)and(n==ey)then
                                xOffset = sx-1
                                line = line - (sx-1) - (line - ex)
                            elseif(n==ey)then
                                line = line - (line - ex)
                            elseif(n==sy)then
                                line = line-(sx-1)
                                xOffset = sx-1
                            end
                            self.parent:setBG(obx + xOffset, oby + n - 1, rep(tHex[selectionBG], line))
                            self.parent:setFG(obx + xOffset, oby + n - 1, rep(tHex[selectionFG], line))
                        end
                    end
                    if(self:isFocused())then
                        local anchx, anchy = self:getAnchorPosition()
                        --self.parent:setCursor(true, anchx + textX - wIndex, anchy + textY - hIndex, self.fgColor)
                    end
                end
            end
        end,

        init = function(self)
            self.parent:addEvent("mouse_click", self)
            self.parent:addEvent("mouse_up", self)
            self.parent:addEvent("mouse_scroll", self)
            self.parent:addEvent("mouse_drag", self)
            self.parent:addEvent("key", self)
            self.parent:addEvent("char", self)
            self.parent:addEvent("other_event", self)
            if(base.init(self))then
                self.bgColor = self.parent:getTheme("TextfieldBG")
                self.fgColor = self.parent:getTheme("TextfieldText")
            end
        end,
    }

    return setmetatable(object, base)
end