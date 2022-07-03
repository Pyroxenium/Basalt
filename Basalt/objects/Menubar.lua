local Object = require("Object")
local theme = require("theme")
local utils = require("utils")
local tHex = require("tHex")

return function(name)
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
    local space = 1
    local scrollable = false

    local function maxScroll()
        local mScroll = 0
        local xPos = 0
        for n = 1, #list do
            if (xPos + list[n].text:len() + space * 2 > object.width) then
                if(xPos < object.width)then
                    mScroll = mScroll + (list[n].text:len() + space * 2-(object.width - xPos))
                else
                    mScroll = mScroll + list[n].text:len() + space * 2
                end
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

        setPositionOffset = function(self, offset)
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

        getPositionOffset = function(self)
            return itemOffset
        end;

        setScrollable = function(self, scroll)
            scrollable = scroll
            if(scroll==nil)then scrollable = true end
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

        mouseHandler = function(self, event, button, x, y)
            if(base.mouseHandler(self, event, button, x, y))then
                local objX, objY = self:getAbsolutePosition(self:getAnchorPosition())
                if (objX <= x) and (objX + self.width > x) and (objY <= y) and (objY + self.height > y) and (self:isVisible()) then
                    if (self.parent ~= nil) then
                        self.parent:setFocusedObject(self)
                    end
                    if (event == "mouse_click") or (event == "monitor_touch") then
                        local xPos = 0
                        for n = 1, #list do
                            if (list[n] ~= nil) then
                                if (objX + xPos <= x + itemOffset) and (objX + xPos + list[n].text:len() + (space*2) > x + itemOffset) and (objY == y) then
                                    self:setValue(list[n])
                                    self:getEventSystem():sendEvent(event, self, event, 0, x, y, list[n])
                                end
                                xPos = xPos + list[n].text:len() + space * 2
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
                    self:setVisualChanged(true)
                    return true
                end
            end
            return false
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    if(self.bgColor~=false)then
                        self.parent:drawBackgroundBox(obx, oby, self.width, self.height, self.bgColor)
                    end
                    local text = ""
                    local textBGCol = ""
                    local textFGCol = ""
                    for _, v in pairs(list) do
                        local newItem = (" "):rep(space) .. v.text .. (" "):rep(space)
                        text = text .. newItem
                        if(v == self:getValue())then
                            textBGCol = textBGCol .. tHex[itemSelectedBG or v.bgCol or self.bgColor]:rep(newItem:len())
                            textFGCol = textFGCol .. tHex[itemSelectedFG or v.FgCol or self.fgColor]:rep(newItem:len())
                        else
                            textBGCol = textBGCol .. tHex[v.bgCol or self.bgColor]:rep(newItem:len())
                            textFGCol = textFGCol .. tHex[v.FgCol or self.fgColor]:rep(newItem:len())
                        end
                    end

                    self.parent:setText(obx, oby, text:sub(itemOffset+1, self.width+itemOffset))
                    self.parent:setBG(obx, oby, textBGCol:sub(itemOffset+1, self.width+itemOffset))
                    self.parent:setFG(obx, oby, textFGCol:sub(itemOffset+1, self.width+itemOffset))
                end
                self:setVisualChanged(false)
            end
        end;
    }

    return setmetatable(object, base)
end