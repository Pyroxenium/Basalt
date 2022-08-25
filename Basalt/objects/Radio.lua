local Object = require("Object")
local utils = require("utils")
local xmlValue = utils.getValueFromXML

return function(name)
    local base = Object(name)
    local objectType = "Radio"
    base.width = 8
    base:setZIndex(5)

    local list = {}
    local itemSelectedBG
    local itemSelectedFG
    local boxSelectedBG
    local boxSelectedFG
    local boxNotSelectedBG
    local boxNotSelectedFG
    local selectionColorActive = true
    local symbol = "\7"
    local align = "left"

    local object = {
        getType = function(self)
            return objectType
        end;

        setValuesByXMLData = function(self, data)
            base.setValuesByXMLData(self, data)
            if(xmlValue("selectionBG", data)~=nil)then itemSelectedBG = colors[xmlValue("selectionBG", data)] end
            if(xmlValue("selectionFG", data)~=nil)then itemSelectedFG = colors[xmlValue("selectionFG", data)] end
            if(xmlValue("boxBG", data)~=nil)then boxSelectedBG = colors[xmlValue("boxBG", data)] end
            if(xmlValue("inactiveBoxBG", data)~=nil)then boxNotSelectedBG = colors[xmlValue("inactiveBoxBG", data)] end
            if(xmlValue("inactiveBoxFG", data)~=nil)then boxNotSelectedFG = colors[xmlValue("inactiveBoxFG", data)] end
            if(xmlValue("boxFG", data)~=nil)then boxSelectedFG = colors[xmlValue("boxFG", data)] end
            if(xmlValue("symbol", data)~=nil)then symbol = xmlValue("symbol", data) end
            if(data["item"]~=nil)then
                local tab = data["item"]
                if(tab.properties~=nil)then tab = {tab} end
                for k,v in pairs(tab)do
                    self:addItem(xmlValue("text", v), xmlValue("x", v), xmlValue("y", v), colors[xmlValue("bg", v)], colors[xmlValue("fg", v)])
                end
            end
            return self
        end,

        addItem = function(self, text, x, y, bgCol, fgCol, ...)
            table.insert(list, { x = x or 1, y = y or 1, text = text, bgCol = bgCol or self.bgColor, fgCol = fgCol or self.fgColor, args = { ... } })
            if (#list == 1) then
                self:setValue(list[1])
            end
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

        editItem = function(self, index, text, x, y, bgCol, fgCol, ...)
            table.remove(list, index)
            table.insert(list, index, { x = x or 1, y = y or 1, text = text, bgCol = bgCol or self.bgColor, fgCol = fgCol or self.fgColor, args = { ... } })
            self:updateDraw()
            return self
        end;

        selectItem = function(self, index)
            self:setValue(list[index] or {})
            self:updateDraw()
            return self
        end;

        setActiveSymbol = function(self, sym)
            symbol = sym:sub(1,1)
            self:updateDraw()
            return self
        end,

        setSelectedItem = function(self, bgCol, fgCol, boxBG, boxFG, active)
            itemSelectedBG = bgCol or itemSelectedBG
            itemSelectedFG = fgCol or itemSelectedFG
            boxSelectedBG = boxBG or boxSelectedBG
            boxSelectedFG = boxFG or boxSelectedFG
            selectionColorActive = active~=nil and active or true
            self:updateDraw()
            return self
        end;

        mouseHandler = function(self, button, x, y)
            if (#list > 0) then
                local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
                for _, value in pairs(list) do
                    if (obx + value.x - 1 <= x) and (obx + value.x - 1 + value.text:len() + 1 >= x) and (oby + value.y - 1 == y) then
                        self:setValue(value)
                        local val = self:getEventSystem():sendEvent("mouse_click", self, "mouse_click", button, x, y)
                        if(val==false)then return val end
                        if(self.parent~=nil)then
                            self.parent:setFocusedObject(self)
                        end
                        self:updateDraw()
                        return true
                    end
                end
            end
            return false
        end;

        draw = function(self)
            if (self.parent ~= nil) then
                local obx, oby = self:getAnchorPosition()
                for _, value in pairs(list) do
                    if (value == self:getValue()) then
                        if (align == "left") then
                            self.parent:writeText(value.x + obx - 1, value.y + oby - 1, symbol, boxSelectedBG, boxSelectedFG)
                            self.parent:writeText(value.x + 2 + obx - 1, value.y + oby - 1, value.text, itemSelectedBG, itemSelectedFG)
                        end
                    else
                        self.parent:drawBackgroundBox(value.x + obx - 1, value.y + oby - 1, 1, 1, boxNotSelectedBG or self.bgColor)
                        self.parent:writeText(value.x + 2 + obx - 1, value.y + oby - 1, value.text, value.bgCol, value.fgCol)
                    end
                end
                return true
            end
        end,

        init = function(self)
            self.bgColor = self.parent:getTheme("MenubarBG")
            self.fgColor = self.parent:getTheme("MenubarFG")
            itemSelectedBG = self.parent:getTheme("SelectionBG")
            itemSelectedFG = self.parent:getTheme("SelectionText")
            boxSelectedBG = self.parent:getTheme("MenubarBG")
            boxSelectedFG = self.parent:getTheme("MenubarText")
            self.parent:addEvent("mouse_click", self)
        end,
    }

    return setmetatable(object, base)
end