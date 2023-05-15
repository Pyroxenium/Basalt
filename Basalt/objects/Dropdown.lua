local utils = require("utils")
local tHex = require("tHex")

return function(name, basalt)
    local base = basalt.getObject("List")(name, basalt)
    local objectType = "Dropdown"

    base:setSize(12, 1)
    base:setZIndex(6)

    local selectionColorActive = true
    local align = "left"
    local yOffset = 0

    local dropdownW = 0
    local dropdownH = 0
    local autoSize = true
    local closedSymbol = "\16"
    local openedSymbol = "\31"
    local isOpened = false

    local object = {
        getType = function(self)
            return objectType
        end,

        isType = function(self, t)
            return objectType==t or base.isType~=nil and base.isType(t) or false
        end,

        load = function(self)
            self:listenEvent("mouse_click", self)
            self:listenEvent("mouse_up", self)
            self:listenEvent("mouse_scroll", self)
            self:listenEvent("mouse_drag", self)
        end,

        setOffset = function(self, yOff)
            yOffset = yOff
            self:updateDraw()
            return self
        end,

        getOffset = function(self)
            return yOffset
        end,

        addItem = function(self, t, ...)
            base.addItem(self, t, ...)
            if(autoSize)then
                dropdownW = math.max(dropdownW, #t)
                dropdownH = dropdownH + 1
            end
            return self
        end,

        removeItem = function(self, index)
            base.removeItem(self, index)
            if(autoSize)then
                dropdownW = 0
                dropdownH = 0
                for n = 1, #list do
                    dropdownW = math.max(dropdownW, #list[n].text)
                end
                dropdownH = #list
            end
        end,

        isOpened = function(self)
            return isOpened
        end,

        setOpened = function(self, open)
            isOpened = open
            self:updateDraw()
            return self
        end,

        setDropdownSize = function(self, width, height)
            dropdownW, dropdownH = width, height
            autoSize = false
            self:updateDraw()
            return self
        end,

        setDropdownWidth = function(self, width)
            return self:setDropdownSize(width, dropdownH)
        end,

        setDropdownHeight = function(self, height)
            return self:setDropdownSize(dropdownW, height)
        end,

        getDropdownSize = function(self)
            return dropdownW, dropdownH
        end,

        getDropdownWidth = function(self)
            return dropdownW
        end,

        getDropdownHeight = function(self)
            return dropdownH
        end,

        mouseHandler = function(self, button, x, y, isMon)
            if (isOpened) then
                local obx, oby = self:getAbsolutePosition()
                if(button==1)then
                    local list = self:getAll()
                    if (#list > 0) then
                        for n = 1, dropdownH do
                            if (list[n + yOffset] ~= nil) then
                                if (obx <= x) and (obx + dropdownW > x) and (oby + n == y) then
                                    self:setValue(list[n + yOffset])
                                    self:updateDraw()
                                    local val = self:sendEvent("mouse_click", self, "mouse_click", button, x, y)
                                    if(val==false)then return val end
                                    if(isMon)then
                                        basalt.schedule(function()
                                            sleep(0.1)
                                            self:mouseUpHandler(button, x, y)
                                        end)()
                                    end
                                    return true
                                end
                            end
                        end
                    end
                end
            end
            local base = base:getBase()
            if (base.mouseHandler(self, button, x, y)) then
                isOpened = not isOpened
                self:getParent():setImportant(self)
                self:updateDraw()
                return true
            else
                if(isOpened)then 
                    self:updateDraw()
                    isOpened = false
                end 
                return false
            end
        end,

        mouseUpHandler = function(self, button, x, y)
            if (isOpened) then
                local obx, oby = self:getAbsolutePosition()
                if(button==1)then
                    local list = self:getAll()
                    if (#list > 0) then
                        for n = 1, dropdownH do
                            if (list[n + yOffset] ~= nil) then
                                if (obx <= x) and (obx + dropdownW > x) and (oby + n == y) then
                                    isOpened = false
                                    self:updateDraw()
                                    local val = self:sendEvent("mouse_up", self, "mouse_up", button, x, y)
                                    if(val==false)then return val end
                                    return true
                                end
                            end
                        end
                    end
                end
            end
        end,

        dragHandler = function(self, btn, x, y)
            if(base.dragHandler(self, btn, x, y))then
                isOpened = true
            end
        end,

        scrollHandler = function(self, dir, x, y)
            if(isOpened)then
                local xPos, yPos = self:getAbsolutePosition()
                if(x >= xPos)and(x <= xPos + dropdownW)and(y >= yPos)and(y <= yPos + dropdownH)then
                    self:setFocus()
                end
            end
            if (isOpened)and(self:isFocused()) then
                local xPos, yPos = self:getAbsolutePosition()
                if(x < xPos)or(x > xPos + dropdownW)or(y < yPos)or(y > yPos + dropdownH)then
                    return false
                end
                if(#self:getAll() <= dropdownH)then return false end

                local list = self:getAll()
                yOffset = yOffset + dir
                if (yOffset < 0) then
                    yOffset = 0
                end
                if (dir == 1) then
                    if (#list > dropdownH) then
                        if (yOffset > #list - dropdownH) then
                            yOffset = #list - dropdownH
                        end
                    else
                        yOffset = math.min(#list - 1, 0)
                    end
                end
                local val = self:sendEvent("mouse_scroll", self, "mouse_scroll", dir, x, y)
                if(val==false)then return val end
                self:updateDraw()
                return true
            end
        end,

        draw = function(self)
            base.draw(self)
            self:setDrawState("list", false)
            self:addDraw("dropdown", function()
                local obx, oby = self:getPosition()
                local w,h = self:getSize()
                local val = self:getValue()
                local list = self:getAll()
                local bgCol, fgCol = self:getBackground(), self:getForeground()
                local text = utils.getTextHorizontalAlign((val~=nil and val.text or ""), w, align):sub(1, w - 1)  .. (isOpened and openedSymbol or closedSymbol)
                self:addBlit(1, 1, text, tHex[fgCol]:rep(#text), tHex[bgCol]:rep(#text))

                if (isOpened) then
                    self:addTextBox(1, 2, dropdownW, dropdownH, " ")
                    self:addBackgroundBox(1, 2, dropdownW, dropdownH, bgCol)
                    self:addForegroundBox(1, 2, dropdownW, dropdownH, fgCol)
                    for n = 1, dropdownH do
                        if (list[n + yOffset] ~= nil) then
                            local t =utils.getTextHorizontalAlign(list[n + yOffset].text, dropdownW, align)
                            if (list[n + yOffset] == val) then
                                if (selectionColorActive) then
                                    local itemSelectedBG, itemSelectedFG = self:getSelectionColor()
                                    self:addBlit(1, n+1, t, tHex[itemSelectedFG]:rep(#t), tHex[itemSelectedBG]:rep(#t))
                                else
                                    self:addBlit(1, n+1, t, tHex[list[n + yOffset].fgCol]:rep(#t), tHex[list[n + yOffset].bgCol]:rep(#t))
                                end
                            else
                                self:addBlit(1, n+1, t, tHex[list[n + yOffset].fgCol]:rep(#t), tHex[list[n + yOffset].bgCol]:rep(#t))
                            end
                        end
                    end
                end
            end)
        end,
    }

    object.__index = object
    return setmetatable(object, base)
end