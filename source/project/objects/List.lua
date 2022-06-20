local function List(name)
    local base = Object(name)
    local objectType = "List"
    base.width = 16
    base.height = 6
    base.bgColor = theme.listBG
    base.fgColor = theme.listFG
    base:setZIndex(5)

    local list = {}
    local itemSelectedBG = theme.selectionBG
    local itemSelectedFG = theme.selectionFG
    local selectionColorActive = true
    local align = "left"
    local yOffset = 0
    local scrollable = true

    local object = {
        getType = function(self)
            return objectType
        end;

        addItem = function(self, text, bgCol, fgCol, ...)
            table.insert(list, { text = text, bgCol = bgCol or self.bgColor, fgCol = fgCol or self.fgColor, args = { ... } })
            if (#list == 1) then
                self:setValue(list[1])
            end
            return self
        end;

        setIndexOffset = function(self, yOff)
            yOffset = yOff
            return self
        end;

        getIndexOffset = function(self)
            return yOffset
        end;

        removeItem = function(self, index)
            table.remove(list, index)
            return self
        end;

        getItem = function(self, index)
            return list[index]
        end;

        getAll = function(self)
            return list
        end;

        getItemIndex = function(self)
            local selected = self:getValue()
            for key, value in pairs(list) do
                if (value == selected) then
                    return key
                end
            end
        end;

        clear = function(self)
            list = {}
            self:setValue({})
            return self
        end;

        getItemCount = function(self)
            return #list
        end;

        editItem = function(self, index, text, bgCol, fgCol, ...)
            table.remove(list, index)
            table.insert(list, index, { text = text, bgCol = bgCol or self.bgColor, fgCol = fgCol or self.fgColor, args = { ... } })
            return self
        end;

        selectItem = function(self, index)
            self:setValue(list[index] or {})
            return self
        end;

        setSelectedItem = function(self, bgCol, fgCol, active)
            itemSelectedBG = bgCol or self.bgColor
            itemSelectedFG = fgCol or self.fgColor
            selectionColorActive = active
            return self
        end;

        setScrollable = function(self, scroll)
            scrollable = scroll
            return self
        end;

        mouseHandler = function(self, event, button, x, y)
            local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
            if (obx <= x) and (obx + self.width > x) and (oby <= y) and (oby + self.height > y) and (self:isVisible()) then
                if (((event == "mouse_click") or (event == "mouse_drag"))and(button==1))or(event=="monitor_touch") then
                    if (#list > 0) then
                        for n = 1, self.height do
                            if (list[n + yOffset] ~= nil) then
                                if (obx <= x) and (obx + self.width > x) and (oby + n - 1 == y) then
                                    self:setValue(list[n + yOffset])
                                    self:getEventSystem():sendEvent("mouse_click", self, "mouse_click", 0, x, y, list[n + yOffset])
                                end
                            end
                        end
                    end
                end

                if (event == "mouse_scroll") and (scrollable) then
                    yOffset = yOffset + button
                    if (yOffset < 0) then
                        yOffset = 0
                    end
                    if (button >= 1) then
                        if (#list > self.height) then
                            if (yOffset > #list - self.height) then
                                yOffset = #list - self.height
                            end
                            if (yOffset >= #list) then
                                yOffset = #list - 1
                            end
                        else
                            yOffset = yOffset - 1
                        end
                    end
                end
                self:setVisualChanged()
                return true
            end
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    self.parent:drawBackgroundBox(obx, oby, self.width, self.height, self.bgColor)
                    for n = 1, self.height do
                        if (list[n + yOffset] ~= nil) then
                            if (list[n + yOffset] == self:getValue()) then
                                if (selectionColorActive) then
                                    self.parent:writeText(obx, oby + n - 1, getTextHorizontalAlign(list[n + yOffset].text, self.width, align), itemSelectedBG, itemSelectedFG)
                                else
                                    self.parent:writeText(obx, oby + n - 1, getTextHorizontalAlign(list[n + yOffset].text, self.width, align), list[n + yOffset].bgCol, list[n + yOffset].fgCol)
                                end
                            else
                                self.parent:writeText(obx, oby + n - 1, getTextHorizontalAlign(list[n + yOffset].text, self.width, align), list[n + yOffset].bgCol, list[n + yOffset].fgCol)
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