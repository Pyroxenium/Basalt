local Object = require("Object")
local utils = require("utils")
local xmlValue = require("utils").getValueFromXML

return function(name)
    local base = Object(name)
    local objectType = "Dropdown"
    base.width = 12
    base.height = 1
    base:setZIndex(6)

    local list = {}
    local itemSelectedBG
    local itemSelectedFG
    local selectionColorActive = true
    local align = "left"
    local yOffset = 0

    local dropdownW = 16
    local dropdownH = 6
    local closedSymbol = "\16"
    local openedSymbol = "\31"
    local isOpened = false

    local object = {
        getType = function(self)
            return objectType
        end;

        setValuesByXMLData = function(self, data)
            base.setValuesByXMLData(self, data)
            if(xmlValue("selectionBG", data)~=nil)then itemSelectedBG = colors[xmlValue("selectionBG", data)] end
            if(xmlValue("selectionFG", data)~=nil)then itemSelectedFG = colors[xmlValue("selectionFG", data)]  end
            if(xmlValue("dropdownWidth", data)~=nil)then dropdownW = xmlValue("dropdownWidth", data) end
            if(xmlValue("dropdownHeight", data)~=nil)then dropdownH = xmlValue("dropdownHeight", data) end
            if(xmlValue("offset", data)~=nil)then yOffset = xmlValue("offset", data) end
            if(data["item"]~=nil)then
                local tab = data["item"]
                if(tab.properties~=nil)then tab = {tab} end
                for k,v in pairs(tab)do
                    self:addItem(xmlValue("text", v), colors[xmlValue("bg", v)], colors[xmlValue("fg", v)])
                end
            end
        end,

        setOffset = function(self, yOff)
            yOffset = yOff
            self:updateDraw()
            return self
        end;

        getOffset = function(self)
            return yOffset
        end;

        addItem = function(self, text, bgCol, fgCol, ...)
            table.insert(list, { text = text, bgCol = bgCol or self.bgColor, fgCol = fgCol or self.fgColor, args = { ... } })
            self:updateDraw()
            return self
        end;

        getAll = function(self)
            return list
        end;

        removeItem = function(self, index)
            table.remove(list, index)
            self:updateDraw()
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
            self:updateDraw()
            return self
        end;

        getItemCount = function(self)
            return #list
        end;

        editItem = function(self, index, text, bgCol, fgCol, ...)
            table.remove(list, index)
            table.insert(list, index, { text = text, bgCol = bgCol or self.bgColor, fgCol = fgCol or self.fgColor, args = { ... } })
            self:updateDraw()
            return self
        end;

        selectItem = function(self, index)
            self:setValue(list[index] or {})
            self:updateDraw()
            return self
        end;

        setSelectedItem = function(self, bgCol, fgCol, active)
            itemSelectedBG = bgCol or self.bgColor
            itemSelectedFG = fgCol or self.fgColor
            selectionColorActive = active
            self:updateDraw()
            return self
        end;

        setDropdownSize = function(self, width, height)
            dropdownW, dropdownH = width, height
            self:updateDraw()
            return self
        end,

        mouseHandler = function(self, button, x, y)
            if (isOpened) then
                local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
                if(button==1)then
                    if (#list > 0) then
                        for n = 1, dropdownH do
                            if (list[n + yOffset] ~= nil) then
                                if (obx <= x) and (obx + dropdownW > x) and (oby + n == y) then
                                    self:setValue(list[n + yOffset])
                                    self:updateDraw()
                                    local val = self:getEventSystem():sendEvent("mouse_click", self, "mouse_click", dir, x, y)
                                    if(val==false)then return val end
                                    return true
                                end
                            end
                        end
                    end
                end
            end
            if (base.mouseHandler(self, button, x, y)) then
                isOpened = (not isOpened)
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
                local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
                if(button==1)then
                    if (#list > 0) then
                        for n = 1, dropdownH do
                            if (list[n + yOffset] ~= nil) then
                                if (obx <= x) and (obx + dropdownW > x) and (oby + n == y) then
                                    isOpened = false
                                    self:updateDraw()
                                    local val = self:getEventSystem():sendEvent("mouse_up", self, "mouse_up", dir, x, y)
                                    if(val==false)then return val end
                                    return true
                                end
                            end
                        end
                    end
                end
            end
        end,

        scrollHandler = function(self, dir, x, y)
            if (isOpened)and(self:isFocused()) then
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
                local val = self:getEventSystem():sendEvent("mouse_scroll", self, "mouse_scroll", dir, x, y)
                if(val==false)then return val end
                self:updateDraw()
                return true
            end
        end,

        draw = function(self)
            if (base.draw(self)) then
                local obx, oby = self:getAnchorPosition()
                local w,h = self:getSize()
                if (self.parent ~= nil) then
                    if(self.bgColor~=false)then self.parent:drawBackgroundBox(obx, oby, w, h, self.bgColor) end
                    local val = self:getValue()
                    local text = utils.getTextHorizontalAlign((val~=nil and val.text or ""), w, align):sub(1, w - 1)  .. (isOpened and openedSymbol or closedSymbol)
                    self.parent:writeText(obx, oby, text, self.bgColor, self.fgColor)

                    if (isOpened) then
                        for n = 1, dropdownH do
                            if (list[n + yOffset] ~= nil) then
                                if (list[n + yOffset] == val) then
                                    if (selectionColorActive) then
                                        self.parent:writeText(obx, oby + n, utils.getTextHorizontalAlign(list[n + yOffset].text, dropdownW, align), itemSelectedBG, itemSelectedFG)
                                    else
                                        self.parent:writeText(obx, oby + n, utils.getTextHorizontalAlign(list[n + yOffset].text, dropdownW, align), list[n + yOffset].bgCol, list[n + yOffset].fgCol)
                                    end
                                else
                                    self.parent:writeText(obx, oby + n, utils.getTextHorizontalAlign(list[n + yOffset].text, dropdownW, align), list[n + yOffset].bgCol, list[n + yOffset].fgCol)
                                end
                            end
                        end
                    end
                end
            end
        end,

        init = function(self)
            self.bgColor = self.parent:getTheme("DropdownBG")
            self.fgColor = self.parent:getTheme("DropdownText")
            itemSelectedBG = self.parent:getTheme("SelectionBG")
            itemSelectedFG = self.parent:getTheme("SelectionText")
            if(self.parent~=nil)then
                self.parent:addEvent("mouse_click", self)
                self.parent:addEvent("mouse_up", self)
                self.parent:addEvent("mouse_scroll", self)
            end
        end,
    }

    return setmetatable(object, base)
end