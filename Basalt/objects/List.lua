local Object = require("Object")
local utils = require("utils")
local xmlValue = utils.getValueFromXML

return function(name)
    local base = Object(name)
    local objectType = "List"
    base.width = 16
    base.height = 6
    base:setZIndex(5)

    local list = {}
    local itemSelectedBG
    local itemSelectedFG
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
            self:updateDraw()
            return self
        end;

        setOffset = function(self, yOff)
            yOffset = yOff
            self:updateDraw()
            return self
        end;

        getOffset = function(self)
            return yOffset
        end;

        removeItem = function(self, index)
            table.remove(list, index)
            self:updateDraw()
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
            selectionColorActive = active~=nil and active or true
            self:updateDraw()
            return self
        end;

        setScrollable = function(self, scroll)
            scrollable = scroll
            if(scroll==nil)then scrollable = true end
            self:updateDraw()
            return self
        end;

        setValuesByXMLData = function(self, data)
            base.setValuesByXMLData(self, data)
            if(xmlValue("selectionBG", data)~=nil)then itemSelectedBG = colors[xmlValue("selectionBG", data)] end
            if(xmlValue("selectionFG", data)~=nil)then itemSelectedFG = colors[xmlValue("selectionFG", data)]  end
            if(xmlValue("scrollable", data)~=nil)then if(xmlValue("scrollable", data))then self:setScrollable(true) else self:setScrollable(false) end end
            if(xmlValue("offset", data)~=nil)then yOffset = xmlValue("offset", data) end
            if(data["item"]~=nil)then
                local tab = data["item"]
                if(tab.properties~=nil)then tab = {tab} end
                for k,v in pairs(tab)do
                    self:addItem(xmlValue("text", v), colors[xmlValue("bg", v)], colors[xmlValue("fg", v)])
                end
            end
            return self
        end,

        scrollHandler = function(self, dir, x, y)
            if(base.scrollHandler(self, dir, x, y))then
                if(scrollable)then
                    local w,h = self:getSize()
                    yOffset = yOffset + dir
                    if (yOffset < 0) then
                        yOffset = 0
                    end
                    if (dir >= 1) then
                        if (#list > h) then
                            if (yOffset > #list - h) then
                                yOffset = #list - h
                            end
                            if (yOffset >= #list) then
                                yOffset = #list - 1
                            end
                        else
                            yOffset = yOffset - 1
                        end
                    end
                    self:updateDraw()
                end
                return true
            end
            return false
        end,

        mouseHandler = function(self, button, x, y)
            if(base.mouseHandler(self, button, x, y))then
                local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
                local w,h = self:getSize()
                if (#list > 0) then
                    for n = 1, h do
                        if (list[n + yOffset] ~= nil) then
                            if (obx <= x) and (obx + w > x) and (oby + n - 1 == y) then
                                self:setValue(list[n + yOffset])
                                self:updateDraw()
                            end
                        end
                    end
                end
                return true
            end
            return false
        end,

        dragHandler = function(self, button, x, y)
            return self:mouseHandler(button, x, y)
        end,

        touchHandler = function(self, x, y)
            return self:mouseHandler(1, x, y)
        end,

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    local w,h = self:getSize()
                    if(self.bgColor~=false)then
                        self.parent:drawBackgroundBox(obx, oby, w, h, self.bgColor)
                    end
                    for n = 1, h do
                        if (list[n + yOffset] ~= nil) then
                            if (list[n + yOffset] == self:getValue()) then
                                if (selectionColorActive) then
                                    self.parent:writeText(obx, oby + n - 1, utils.getTextHorizontalAlign(list[n + yOffset].text, w, align), itemSelectedBG, itemSelectedFG)
                                else
                                    self.parent:writeText(obx, oby + n - 1, utils.getTextHorizontalAlign(list[n + yOffset].text, w, align), list[n + yOffset].bgCol, list[n + yOffset].fgCol)
                                end
                            else
                                self.parent:writeText(obx, oby + n - 1, utils.getTextHorizontalAlign(list[n + yOffset].text, w, align), list[n + yOffset].bgCol, list[n + yOffset].fgCol)
                            end
                        end
                    end
                end
            end
        end,

        init = function(self)
            self.bgColor = self.parent:getTheme("ListBG")
            self.fgColor = self.parent:getTheme("ListText")
            itemSelectedBG = self.parent:getTheme("SelectionBG")
            itemSelectedFG = self.parent:getTheme("SelectionText")
            self.parent:addEvent("mouse_click", self)
            self.parent:addEvent("mouse_drag", self)
            self.parent:addEvent("mouse_scroll", self)
        end,
    }

    return setmetatable(object, base)
end