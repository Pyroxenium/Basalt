local Object = require("Object")
local utils = require("utils")
local xmlValue = utils.getValueFromXML
local tHex = require("tHex")

return function(name)
    local base = Object(name)
    local objectType = "Menubar"
    local object = {}

    base.width = 30
    base.height = 1
    base:setZIndex(5)

    local list = {}
    local itemSelectedBG
    local itemSelectedFG
    local selectionColorActive = true
    local align = "left"
    local itemOffset = 0
    local space = 1
    local scrollable = false

    local function maxScroll()
        local mScroll = 0
        local xPos = 0
        local w = object:getWidth()
        for n = 1, #list do
            if (xPos + list[n].text:len() + space * 2 > w) then
                if(xPos < w)then
                    mScroll = mScroll + (list[n].text:len() + space * 2-(w - xPos))
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
            table.insert(list, { text = tostring(text), bgCol = bgCol or self.bgColor, fgCol = fgCol or self.fgColor, args = { ... } })
            if (#list == 1) then
                self:setValue(list[1])
            end
            self:updateDraw()
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
            self:updateDraw()
            return self
        end;

        setSpace = function(self, _space)
            space = _space or space
            self:updateDraw()
            return self
        end;

        setOffset = function(self, offset)
            itemOffset = offset or 0
            if (itemOffset < 0) then
                itemOffset = 0
            end

            local mScroll = maxScroll()
            if (itemOffset > mScroll) then
                itemOffset = mScroll
            end
            self:updateDraw()
            return self
        end;

        getOffset = function(self)
            return itemOffset
        end;

        setScrollable = function(self, scroll)
            scrollable = scroll
            if(scroll==nil)then scrollable = true end
            return self
        end;

        setValuesByXMLData = function(self, data)
            base.setValuesByXMLData(self, data)
            if(xmlValue("selectionBG", data)~=nil)then itemSelectedBG = colors[xmlValue("selectionBG", data)] end
            if(xmlValue("selectionFG", data)~=nil)then itemSelectedFG = colors[xmlValue("selectionFG", data)] end
            if(xmlValue("scrollable", data)~=nil)then if(xmlValue("scrollable", data))then self:setScrollable(true) else self:setScrollable(false) end end
            if(xmlValue("offset", data)~=nil)then self:setOffset(xmlValue("offset", data)) end
            if(xmlValue("space", data)~=nil)then space = xmlValue("space", data) end
            if(data["item"]~=nil)then
                local tab = data["item"]
                if(tab.properties~=nil)then tab = {tab} end
                for k,v in pairs(tab)do
                    self:addItem(xmlValue("text", v), colors[xmlValue("bg", v)], colors[xmlValue("fg", v)])
                end
            end
            return self
        end,

        removeItem = function(self, index)
            table.remove(list, index)
            self:updateDraw()
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

        mouseHandler = function(self, button, x, y)
            if(base.mouseHandler(self, button, x, y))then
                local objX, objY = self:getAbsolutePosition(self:getAnchorPosition())
                local w,h = self:getSize()
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
                self:updateDraw()
                return true
            end
            return false
        end,

        scrollHandler = function(self, dir, x, y)
            if(base.scrollHandler(self, dir, x, y))then
                if(scrollable)then
                    itemOffset = itemOffset + dir
                    if (itemOffset < 0) then
                        itemOffset = 0
                    end

                    local mScroll = maxScroll()

                    if (itemOffset > mScroll) then
                        itemOffset = mScroll
                    end
                    self:updateDraw()
                end
                return true
            end
            return false
        end,

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    local w,h = self:getSize()
                    if(self.bgColor~=false)then
                        self.parent:drawBackgroundBox(obx, oby, w, h, self.bgColor)
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

                    self.parent:setText(obx, oby, text:sub(itemOffset+1, w+itemOffset))
                    self.parent:setBG(obx, oby, textBGCol:sub(itemOffset+1, w+itemOffset))
                    self.parent:setFG(obx, oby, textFGCol:sub(itemOffset+1, w+itemOffset))
                end
            end
        end,

        init = function(self)
            self.bgColor = self.parent:getTheme("MenubarBG")
            self.fgColor = self.parent:getTheme("MenubarText")
            itemSelectedBG = self.parent:getTheme("SelectionBG")
            itemSelectedFG = self.parent:getTheme("SelectionText")

            self.parent:addEvent("mouse_click", self)
            self.parent:addEvent("mouse_scroll", self)

        end,
    }

    return setmetatable(object, base)
end