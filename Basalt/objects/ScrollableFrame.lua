local max,min,sub,rep = math.max,math.min,string.sub,string.rep

local tHex = require("tHex")

return function(name, basalt)
    local base = basalt.getObject("Frame")(name, basalt)
    base:setType("ScrollableFrame")

    base:addProperty("AutoCalculate", "boolean", true)
    base:addProperty("Direction", {"vertical", "horizontal"}, "vertical")
    base:addProperty("Scrollbar", "boolean", false)
    base:addProperty("ScrollbarSymbolBackground", "number", colors.black)
    base:addProperty("ScrollbarSymbolForeground", "number", colors.black)
    base:addProperty("ScrollbarSymbol", "char", " ")
    base:combineProperty("ScrollbarFront", "ScrollbarSymbol", "ScrollbarSymbolBackground", "ScrollbarSymbolForeground")
    base:addProperty("ScrollbarBackgroundSymbol", "char", "\127")
    base:addProperty("ScrollbarBackground", "number", colors.gray)
    base:addProperty("ScrollbarForeground", "number", colors.black)
    base:combineProperty("ScrollbarBack", "ScrollbarBackgroundSymbol", "ScrollbarBackground", "ScrollbarForeground")
    base:addProperty("ScrollbarArrowForeground", "number", colors.lightGray)
    base:addProperty("ScrollbarArrowBackground", "number", colors.black)
    base:combineProperty("ScrollbarArrowColor", "ScrollbarArrowBackground", "ScrollbarArrowForeground")

    base:addProperty("ScrollAmount", "number", 0, false, function(self, value)
        self:setAutoCalculate(false)
    end)
    base:addProperty("ScrollSpeed", "number", 1)

    local function getHorizontalScrollAmount(self)
        local amount = 0
        local children = self:getChildren()
        for _, b in pairs(children) do
            if(b.element.getWidth~=nil)and(b.element.getX~=nil)then
                local w, x = b.element:getWidth(), b.element:getX()
                local width = self:getWidth()
                if(b.element:getType()=="Dropdown")then
                    if(b.element:isOpened())then
                        local dropdownW = b.element:getDropdownSize()
                        if (dropdownW + x - width >= amount) then
                            amount = max(dropdownW + x - width, 0)
                        end
                    end
                end

                if (w + x - width >= amount) then
                    amount = max(w + x - width, 0)
                end
            end
        end
        return amount
    end

    local function getVerticalScrollAmount(self)
        local amount = 0
        local children = self:getChildren()
        for _, b in pairs(children) do
            if(b.element.getHeight~=nil)and(b.element.getY~=nil)then
                local h, y = b.element:getHeight(), b.element:getY()
                local height = self:getHeight()
                if(b.element:getType()=="Dropdown")then
                    if(b.element:isOpened())then
                        local _,dropdownH = b.element:getDropdownSize()
                        if (dropdownH + y - height >= amount) then
                            amount = max(dropdownH + y - height, 0)
                        end
                    end
                end
                if (h + y - height >= amount) then
                    amount = max(h + y - height, 0)
                end
            end
        end
        return amount
    end

    local function scrollHandler(self, dir)
        local xO, yO = self:getOffset()
        local scrollAmn
        local direction = self:getDirection()
        local calculateScrollAmount = self:getAutoCalculate()
        local manualScrollAmount = self:getScrollAmount()
        local scrollSpeed = self:getScrollSpeed()
        if(direction=="horizontal")then
            scrollAmn = calculateScrollAmount and getHorizontalScrollAmount(self) or manualScrollAmount
            self:setOffset(min(scrollAmn, max(0, xO + dir * scrollSpeed)), yO)
        elseif(direction=="vertical")then
            scrollAmn = calculateScrollAmount and getVerticalScrollAmount(self) or manualScrollAmount
            self:setOffset(xO, min(scrollAmn, max(0, yO + dir * scrollSpeed)))
        end
        self:updateDraw()
    end

    local function scrollWithMouse(self, x, y)
        local direction = self:getDirection()
        local scrollAmn
        local calculateScrollAmount = self:getAutoCalculate()
        local manualScrollAmount = self:getScrollAmount()

        if(direction=="horizontal") then
            if(y==self:getHeight()) then
                if(x>1)and(x<self:getWidth())then
                    scrollAmn = calculateScrollAmount and getHorizontalScrollAmount(self) or manualScrollAmount
                    self:setOffset(math.floor(x / self:getWidth() * scrollAmn), 0)
                end
            end
        elseif(direction=="vertical") then
            if(x==self:getWidth()) then
                if(y>1)and(y<self:getHeight())then
                    scrollAmn = calculateScrollAmount and getVerticalScrollAmount(self) or manualScrollAmount
                    self:setOffset(0, math.floor(y / self:getHeight() * scrollAmn))
                end
                if(y==1)then
                    scrollHandler(self, -1)
                end
                if(y==self:getHeight())then
                    scrollHandler(self, 1)
                end
            end
        end
    end


    local object = {
        getBase = function(self)
            return base
        end,

        load = function(self)
            base.load(self)
            self:listenEvent("mouse_scroll")
            self:listenEvent("mouse_drag")
            self:listenEvent("mouse_click")
            self:listenEvent("mouse_up")
        end,

        removeChildren = function(self)
            base.removeChildren(self)
            self:listenEvent("mouse_scroll")
            self:listenEvent("mouse_drag")
            self:listenEvent("mouse_click")
            self:listenEvent("mouse_up")
        end,

        scrollHandler = function(self, dir, x, y)
            if(base:getBase().scrollHandler(self, dir, x, y))then
                self:sortChildren()
                for _, obj in ipairs(self:getEvents("mouse_scroll")) do
                    if (obj.element.scrollHandler ~= nil) then
                        local xO, yO = 0, 0
                        if(self.getOffset~=nil)then
                            xO, yO = self:getOffset()
                        end
                        if(obj.element:getIgnoreOffset())then
                            xO, yO = 0, 0
                        end
                        if (obj.element.scrollHandler(obj.element, dir, x+xO, y+yO)) then
                            return true
                        end
                    end
                end
                scrollHandler(self, dir)
                self:clearFocusedChild()
                return true
            end
        end,

        mouseHandler = function(self, btn, x, y)
            if(base:getBase().mouseHandler(self, btn, x, y))then
                local obX, obY = self:getAbsolutePosition()
                scrollWithMouse(self, x-obX+1, y-obY+1)
                return true
            end
        end,

        dragHandler = function(self, btn, x, y)
            if(base:getBase().dragHandler(self, btn, x, y))then
                local obX, obY = self:getAbsolutePosition()
                scrollWithMouse(self, x-obX+1, y-obY+1)
                return true
            end
        end,

        draw = function(self)
            base.draw(self)
            self:addDraw("scrollableFrameScrollbar", function()
                if(self:getScrollbar())then
                    local xO, yO = self:getOffset()
                    local p = self:getProperties()
                    local width, height = p.Width, p.Height
                    if(p.Direction=="vertical")then
                        local scrollAmount = getVerticalScrollAmount(self)
                        local scrollBarHeight = max(1, math.floor(height * height / (height + scrollAmount)))
                        local scrollBarY = yO * (height - scrollBarHeight) / scrollAmount

                        local bgSymbol, bgColor, bgFgColor = self:getScrollbarBack()
                        local fgSymbol, fgColor, fgFgColor = self:getScrollbarFront()
                        local arrowBg, arrowFg = self:getScrollbarArrowColor()
                        
                        bgColor = tHex[bgColor]
                        fgColor = tHex[fgColor]
                        bgFgColor = tHex[bgFgColor]
                        fgFgColor = tHex[fgFgColor]
                        arrowBg = tHex[arrowBg]
                        arrowFg = tHex[arrowFg]

                        for y=2, height-1 do
                            local char = bgSymbol
                            local bg = bgColor
                            local fg = bgFgColor
                            if(y>=scrollBarY)and(y<=scrollBarY+scrollBarHeight)then
                                char = fgSymbol
                                bg = fgColor
                                fg = fgFgColor
                            end
                            self:blit(width, y, char, fg, bg)
                        end
                        self:blit(width, 1, "\30", arrowFg, arrowBg)
                        self:blit(width, height, "\31", arrowFg, arrowBg)
                    elseif(p.Direction=="horizontal")then
                        local scrollAmount = getHorizontalScrollAmount(self)
                        local scrollBarWidth = max(1, math.floor(width * width / (width + scrollAmount)))
                        local scrollBarX = xO * (width - scrollBarWidth) / scrollAmount

                        local bgSymbol, bgColor, bgFgColor = self:getScrollbarBack()
                        local fgSymbol, fgColor, fgFgColor = self:getScrollbarFront()
                        local arrowBg, arrowFg = self:getScrollbarArrowColor()
                        
                        bgColor = tHex[bgColor]
                        fgColor = tHex[fgColor]
                        bgFgColor = tHex[bgFgColor]
                        fgFgColor = tHex[fgFgColor]
                        arrowBg = tHex[arrowBg]
                        arrowFg = tHex[arrowFg]

                        for x=2, width-1 do
                            local char = bgSymbol
                            local bg = bgColor
                            local fg = bgFgColor
                            if(x>=scrollBarX)and(x<=scrollBarX+scrollBarWidth)then
                                char = fgSymbol
                                bg = fgColor
                                fg = fgFgColor
                            end
                            self:blit(x, height, char, fg, bg)
                        end
                        self:blit(1, height, "\17", arrowFg, arrowBg)
                        self:blit(width, height, "\16", arrowFg, arrowBg)
                    end
                end
            end)
        end,
    }

    object.__index = object
    return setmetatable(object, base)
end