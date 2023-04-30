local utils = require("utils")
local tHex = require("tHex")

return function(name, basalt)
    local base = basalt.getObject("ChangeableObject")(name, basalt)
    local objectType = "List"

    local list = {}
    local itemSelectedBG = colors.black
    local itemSelectedFG = colors.lightGray
    local selectionColorActive = true
    local textAlign = "left"
    local yOffset = 0
    local scrollable = true

    base:setSize(16, 8)
    base:setZIndex(5)

    local object = {
        init = function(self)
            local parent = self:getParent()
            self:listenEvent("mouse_click")
            self:listenEvent("mouse_drag")
            self:listenEvent("mouse_scroll")
            return base.init(self)
        end,

        getBase = function(self)
            return base
        end,

        setTextAlign = function(self, align)
            textAlign = align
            return self
        end,

        getTextAlign = function(self)
            return textAlign
        end,

        getBase = function(self)
            return base
        end,  

        getType = function(self)
            return objectType
        end,

        isType = function(self, t)
            return objectType==t or base.isType~=nil and base.isType(t) or false
        end,

        addItem = function(self, text, bgCol, fgCol, ...)
            table.insert(list, { text = text, bgCol = bgCol or self:getBackground(), fgCol = fgCol or self:getForeground(), args = { ... } })
            if (#list <= 1) then
                self:setValue(list[1], false)
            end
            self:updateDraw()
            return self
        end,

        setOffset = function(self, yOff)
            yOffset = yOff
            self:updateDraw()
            return self
        end,

        getOffset = function(self)
            return yOffset
        end,

        removeItem = function(self, index)
            table.remove(list, index)
            self:updateDraw()
            return self
        end,

        getItem = function(self, index)
            return list[index]
        end,

        getAll = function(self)
            return list
        end,

        getItemIndex = function(self)
            local selected = self:getValue()
            for key, value in pairs(list) do
                if (value == selected) then
                    return key
                end
            end
        end,

        clear = function(self)
            list = {}
            self:setValue({}, false)
            self:updateDraw()
            return self
        end,

        getItemCount = function(self)
            return #list
        end,

        editItem = function(self, index, text, bgCol, fgCol, ...)
            table.remove(list, index)
            table.insert(list, index, { text = text, bgCol = bgCol or self:getBackground(), fgCol = fgCol or self:getForeground(), args = { ... } })
            self:updateDraw()
            return self
        end,

        selectItem = function(self, index)
            self:setValue(list[index] or {}, false)
            self:updateDraw()
            return self
        end,

        setSelectionColor = function(self, bgCol, fgCol, active)
            itemSelectedBG = bgCol or self:getBackground()
            itemSelectedFG = fgCol or self:getForeground()
            selectionColorActive = active~=nil and active or true
            self:updateDraw()
            return self
        end,

        getSelectionColor = function(self)
            return itemSelectedBG, itemSelectedFG
        end,

        isSelectionColorActive = function(self)
            return selectionColorActive
        end,

        setScrollable = function(self, scroll)
            scrollable = scroll
            if(scroll==nil)then scrollable = true end
            self:updateDraw()
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
                local obx, oby = self:getAbsolutePosition()
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
            base.draw(self)
            self:addDraw("list", function()
                local parent = self:getParent()
                local obx, oby = self:getPosition()
                local w, h = self:getSize()
                for n = 1, h do
                    if list[n + yOffset] then
                        local t = list[n + yOffset].text
                        local fg, bg = list[n + yOffset].fgCol, list[n + yOffset].bgCol
                        if list[n + yOffset] == self:getValue() and selectionColorActive then
                            fg, bg = itemSelectedFG, itemSelectedBG
                        end
                        self:addBlit(1, n, t, tHex[fg]:rep(#t), tHex[bg]:rep(#t))
                    end
                end
            end)
        end,
    }

    object.__index = object
    return setmetatable(object, base)
end