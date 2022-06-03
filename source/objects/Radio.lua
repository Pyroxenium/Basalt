local function Radio(name)
    local base = Object(name)
    local objectType = "Radio"
    base.width = 8
    base.bgColor = theme.listBG
    base.fgColor = theme.listFG
    base:setZIndex(5)

    local list = {}
    local itemSelectedBG = theme.selectionBG
    local itemSelectedFG = theme.selectionFG
    local boxSelectedBG = base.bgColor
    local boxSelectedFG = base.fgColor
    local selectionColorActive = true
    local symbol = "\7"
    local align = "left"

    local object = {
        getType = function(self)
            return objectType
        end;

        addItem = function(self, text, x, y, bgCol, fgCol, ...)
            table.insert(list, { x = x or 1, y = y or 1, text = text, bgCol = bgCol or self.bgColor, fgCol = fgCol or self.fgColor, args = { ... } })
            if (#list == 1) then
                self:setValue(list[1])
            end
            return self
        end;

        getAll = function(self)
            return list
        end;

        removeItem = function(self, index)
            table.remove(list, index)
            return self
        end;

        getItem = function(self, index)
            return list[index]
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

        editItem = function(self, index, text, x, y, bgCol, fgCol, ...)
            table.remove(list, index)
            table.insert(list, index, { x = x or 1, y = y or 1, text = text, bgCol = bgCol or self.bgColor, fgCol = fgCol or self.fgColor, args = { ... } })
            return self
        end;

        selectItem = function(self, index)
            self:setValue(list[index] or {})
            return self
        end;

        setSelectedItem = function(self, bgCol, fgCol, boxBG, boxFG, active)
            itemSelectedBG = bgCol or itemSelectedBG
            itemSelectedFG = fgCol or itemSelectedFG
            boxSelectedBG = boxBG or boxSelectedBG
            boxSelectedFG = boxFG or boxSelectedFG
            selectionColorActive = active
            return self
        end;

        mouseClickHandler = function(self, event, button, x, y)
            local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
            if ((event == "mouse_click")and(button==1))or(event=="monitor_touch") then
                if (#list > 0) then
                    for _, value in pairs(list) do
                        if (obx + value.x - 1 <= x) and (obx + value.x - 1 + value.text:len() + 2 >= x) and (oby + value.y - 1 == y) then
                            self:setValue(value)
                            if (self.parent ~= nil) then
                                self.parent:setFocusedObject(self)
                            end
                            --eventSystem:sendEvent(event, self, event, button, x, y)
                            self:setVisualChanged()
                            return true
                        end
                    end
                end
            end
            return false
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    for _, value in pairs(list) do
                        if (value == self:getValue()) then
                            if (align == "left") then
                                self.parent:writeText(value.x + obx - 1, value.y + oby - 1, symbol, boxSelectedBG, boxSelectedFG)
                                self.parent:writeText(value.x + 2 + obx - 1, value.y + oby - 1, value.text, itemSelectedBG, itemSelectedFG)
                            end
                        else
                            self.parent:drawBackgroundBox(value.x + obx - 1, value.y + oby - 1, 1, 1, self.bgColor)
                            self.parent:writeText(value.x + 2 + obx - 1, value.y + oby - 1, value.text, value.bgCol, value.fgCol)
                        end
                    end
                end
            end
        end;
    }

    return setmetatable(object, base)
end