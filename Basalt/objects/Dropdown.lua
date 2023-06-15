local utils = require("utils")
local tHex = require("tHex")

return function(name, basalt)
    local base = basalt.getObject("List")(name, basalt)
    base:setType("Dropdown")

    base:setSize(12, 1)
    base:setZ(6)

    base:addProperty("Align", {"left", "center", "right"}, "left")
    base:addProperty("AutoSize", "boolean", true)
    base:addProperty("ClosedSymbol", "char", "\16")
    base:addProperty("OpenedSymbol", "char", "\31")
    base:addProperty("Opened", "boolean", false)
    base:addProperty("DropdownWidth", "number", 12)
    base:addProperty("DropdownHeight", "number", 0)
    base:combineProperty("DropdownSize", "DropdownWidth", "DropdownHeight")

    local object = {
        load = function(self)
            self:listenEvent("mouse_click", self)
            self:listenEvent("mouse_up", self)
            self:listenEvent("mouse_scroll", self)
            self:listenEvent("mouse_drag", self)
        end,

        addItem = function(self, t, ...)
            base.addItem(self, t, ...)
            if(self:getAutoSize())then
                local dropdownW, dropdownH = self:getDropdownSize()
                self:setDropdownSize(math.max(dropdownW, #t), dropdownH + 1)
            end
            return self
        end,

        removeItem = function(self, index)
            base.removeItem(self, index)
            local list = self:getAll()
            if(self:getAutoSize())then
                local dropdownW, dropdownH = self:getDropdownSize()
                dropdownW = 0
                dropdownH = 0
                for n = 1, #list do
                    dropdownW = math.max(dropdownW, #list[n].text)
                end
                dropdownH = #list
                self:setDropdownSize(dropdownW, dropdownH)
            end
            return self
        end,

        isOpened = function(self)
            return self:getOpened()
        end,

        mouseHandler = function(self, button, x, y, isMon)
            local isOpened = self:getOpened()
            if (isOpened) then
                local obx, oby = self:getAbsolutePosition()
                if(button==1)then
                    local list = self:getAll()
                    if (#list > 0) then
                        local dropdownW, dropdownH = self:getDropdownSize()
                        local offset = self:getOffset()
                        for n = 1, dropdownH do
                            if (list[n + offset] ~= nil) then
                                if (obx <= x) and (obx + dropdownW > x) and (oby + n == y) then
                                    self:setValue(list[n + offset])
                                    self:selectHandler()
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
                self:setOpened(not isOpened)
                self:getParent():setImportant(self)
                self:updateDraw()
                return true
            else
                if(isOpened)then 
                    self:updateDraw()
                    self:setOpened(false)
                end
                return false
            end
        end,

        mouseUpHandler = function(self, button, x, y)
            local isOpened = self:getOpened()
            if (isOpened) then
                local obx, oby = self:getAbsolutePosition()
                if(button==1)then
                    local list = self:getAll()
                    if (#list > 0) then
                        local dropdownW, dropdownH = self:getDropdownSize()
                        local offset = self:getOffset()
                        for n = 1, dropdownH do
                            if (list[n + offset] ~= nil) then
                                if (obx <= x) and (obx + dropdownW > x) and (oby + n == y) then
                                    self:setOpened(false)
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
                self:setOpened(true)
            end
        end,

        scrollHandler = function(self, dir, x, y)
            local isOpened = self:getOpened()
            local dropdownW, dropdownH = self:getDropdownSize()
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

                local offset = self:getOffset() + dir
                if (offset < 0) then
                    offset = 0
                end
                if (dir == 1) then
                    if (#list > dropdownH) then
                        if (offset > #list - dropdownH) then
                            offset = #list - dropdownH
                        end
                    else
                        offset = math.min(#list - 1, 0)
                    end
                end
                self:setOffset(offset)
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
                local w,h = self:getSize()
                local val = self:getValue()
                local list = self:getAll()
                local bgCol, fgCol = self:getBackground(), self:getForeground()
                local openedSymbol, closedSymbol = self:getOpenedSymbol(), self:getClosedSymbol()
                local align = self:getAlign()
                local dropdownW, dropdownH = self:getDropdownSize()
                local offset = self:getOffset()
                local selectionColorActive = self:getSelectionColorActive()
                local isOpened = self:getOpened()
                local text = utils.getTextHorizontalAlign((val~=nil and val.text or ""), w, align):sub(1, w - 1)  .. (isOpened and openedSymbol or closedSymbol)
                self:addBlit(1, 1, text, tHex[fgCol]:rep(#text), tHex[bgCol]:rep(#text))

                if (isOpened) then
                    self:addTextBox(1, 2, dropdownW, dropdownH, " ")
                    self:addBackgroundBox(1, 2, dropdownW, dropdownH, bgCol)
                    self:addForegroundBox(1, 2, dropdownW, dropdownH, fgCol)
                    for n = 1, dropdownH do
                        if (list[n + offset] ~= nil) then
                            local t =utils.getTextHorizontalAlign(list[n + offset].text, dropdownW, align)
                            if (list[n + offset] == val) then
                                if (selectionColorActive) then
                                    local itemSelectedBG, itemSelectedFG = self:getSelectionColor()
                                    self:addBlit(1, n+1, t, tHex[itemSelectedFG]:rep(#t), tHex[itemSelectedBG]:rep(#t))
                                else
                                    self:addBlit(1, n+1, t, tHex[list[n + offset].fgCol]:rep(#t), tHex[list[n + offset].bgCol]:rep(#t))
                                end
                            else
                                self:addBlit(1, n+1, t, tHex[list[n + offset].fgCol]:rep(#t), tHex[list[n + offset].bgCol]:rep(#t))
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