local function Menubar(name)
    local base = Object(name)
    local objectType = "Menubar"
    local object = {}

    base.width = 30
    base.height = 1
    base.bgColor = colors.gray
    base.fgColor = colors.lightGray
    base:setZIndex(5)

    local list = {}
    local itemSelectedBG = theme.selectionBG
    local itemSelectedFG = theme.selectionFG
    local selectionColorActive = true
    local align = "left"
    local itemOffset = 0
    local space = 2
    local scrollable = false

    local function maxScroll()
        local mScroll = 0
        local xPos = 1
        for n = 1, #list do
            if (xPos + list[n].text:len() + space * 2 > object.w) then
                mScroll = mScroll + list[n].text:len() + space * 2
            end
            xPos = xPos + list[n].text:len() + space * 2

        end
        return mScroll
    end

    object = {
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

        setSpace = function(self, _space)
            space = _space or space
            return self
        end;

        setButtonOffset = function(self, offset)
            itemOffset = offset or 0
            if (itemOffset < 0) then
                itemOffset = 0
            end

            local mScroll = maxScroll()
            if (itemOffset > mScroll) then
                itemOffset = mScroll
            end
            return self
        end;

        setScrollable = function(self, scroll)
            scrollable = scroll
            return self
        end;

        removeItem = function(self, index)
            table.remove(list, index)
            return self
        end;

        getItem = function(self, index)
            return list[index]
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

        mouseClickHandler = function(self, event, button, x, y)
            local objX, objY = self:getAbsolutePosition(self:getAnchorPosition())
            if (objX <= x) and (objX + self.width > x) and (objY <= y) and (objY + self.height > y) and (self:isVisible()) then
                if (self.parent ~= nil) then
                    self.parent:setFocusedObject(self)
                end
                if (event == "mouse_click") or (event == "monitor_touch") then
                    local xPos = 1
                    for n = 1 + itemOffset, #list do
                        if (list[n] ~= nil) then
                            if (xPos + list[n].text:len() + space * 2 <= self.width) then
                                if (objX + (xPos - 1) <= x) and (objX + (xPos - 1) + list[n].text:len() + space * 2 > x) and (objY == y) then
                                    self:setValue(list[n])
                                    self:getEventSystem():sendEvent("mouse_click", self, "mouse_click", 0, x, y, list[n])
                                end
                                xPos = xPos + list[n].text:len() + space * 2
                            else
                                break
                            end
                        end
                    end

                end
                if (event == "mouse_scroll") and (scrollable) then
                    itemOffset = itemOffset + button
                    if (itemOffset < 0) then
                        itemOffset = 0
                    end
                    local mScroll = maxScroll()

                    if (itemOffset > mScroll) then
                        itemOffset = mScroll
                    end
                end
                return true
            end
            return false
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    self.parent:drawBackgroundBox(obx, oby, self.width, self.height, self.bgColor)
                    local xPos = 0
                    for _, value in pairs(list) do
                        if (xPos + value.text:len() + space * 2 <= self.width) then
                            if (value == self:getValue()) then
                                self.parent:writeText(obx + (xPos - 1) + (-itemOffset), oby, getTextHorizontalAlign((" "):rep(space) .. value.text .. (" "):rep(space), value.text:len() + space * 2, align), itemSelectedBG or value.bgCol, itemSelectedFG or value.fgCol)
                            else
                                self.parent:writeText(obx + (xPos - 1) + (-itemOffset), oby, getTextHorizontalAlign((" "):rep(space) .. value.text .. (" "):rep(space), value.text:len() + space * 2, align), value.bgCol, value.fgCol)
                            end
                            xPos = xPos + value.text:len() + space * 2
                        else
                            if (xPos < self.width + itemOffset) then
                                if (value == self:getValue()) then
                                    self.parent:writeText(obx + (xPos - 1) + (-itemOffset), oby, getTextHorizontalAlign((" "):rep(space) .. value.text .. (" "):rep(space), value.text:len() + space * 2, align):sub(1, self.width + itemOffset - xPos), itemSelectedBG or value.bgCol, itemSelectedFG or value.fgCol)
                                else
                                    self.parent:writeText(obx + (xPos - 1) + (-itemOffset), oby, getTextHorizontalAlign((" "):rep(space) .. value.text .. (" "):rep(space), value.text:len() + space * 2, align):sub(1, self.width + itemOffset - xPos), value.bgCol, value.fgCol)
                                end
                                xPos = xPos + value.text:len() + space * 2
                            end
                        end
                    end
                end
            end
        end;
    }

    return setmetatable(object, base)
end