local utils = require("utils")
local tHex = require("tHex")

return function(name, basalt)
    local base = basalt.getObject("ChangeableObject")(name, basalt)
    base:setType("List")

    local list = {}

    base:setSize(16, 8)
    base:setZ(5)

    base:addProperty("SelectionBackground", "color", colors.black)
    base:addProperty("SelectionForeground", "color", colors.lightGray)
    base:combineProperty("SelectionColor", "SelectionBackground", "SelectionForeground")
    base:addProperty("selectionColorActive", "boolean", true)
    base:addProperty("textAlign", {"left", "center", "right"}, "left")
    base:addProperty("scrollable", "boolean", true)
    base:addProperty("offset", "number", 0)

    local object = {
        init = function(self)
            self:listenEvent("mouse_click")
            self:listenEvent("mouse_drag")
            self:listenEvent("mouse_scroll")
            return base.init(self)
        end,

        getBase = function(self)
            return base
        end,

        addItem = function(self, text, bgCol, fgCol, ...)
            table.insert(list, { text = text, bgCol = bgCol or self:getBackground(), fgCol = fgCol or self:getForeground(), args = { ... } })
            if (#list <= 1) then
                self:setValue(list[1], false)
            end
            self:updateDraw()
            return self
        end,

        setOptions = function(self, ...)
            list = {}
            for k,v in pairs(...)do
                if(type(v)=="string")then
                    table.insert(list, { text = v, bgCol = self:getBackground(), fgCol = self:getForeground(), args = {} })
                else
                    table.insert(list, { text = v[1], bgCol = v[2] or self:getBackground(), fgCol = v[3] or self:getForeground(), args = v[4] or {} })
                end
            end
            self:setValue(list[1], false)
            self:updateDraw()
            return self
        end,

        removeItem = function(self, index)
            if(type(index)=="number")then
                table.remove(list, index)
            elseif(type(index)=="table")then
                for k,v in pairs(list)do
                    if(v==index)then
                        table.remove(list, k)
                        break
                    end
                end
            end
            self:updateDraw()
            return self
        end,

        getItem = function(self, index)
            return list[index]
        end,

        getAll = function(self)
            return list
        end,

        getOptions = function(self)
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

        scrollHandler = function(self, dir, x, y)
            if(base.scrollHandler(self, dir, x, y))then
                local scrollable = self:getScrollable()
                if(scrollable)then
                    local offset = self:getOffset()
                    local w,h = self:getSize()
                    offset = offset + dir
                    if (offset < 0) then
                        offset = 0
                    end
                    if (dir >= 1) then
                        if (#list > h) then
                            if (offset > #list - h) then
                                offset = #list - h
                            end
                            if (offset >= #list) then
                                offset = #list - 1
                            end
                        else
                            offset = offset - 1
                        end
                    end
                    self:setOffset(offset)
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
                    local offset = self:getOffset()
                    for n = 1, h do
                        if (list[n + offset] ~= nil) then
                            if (obx <= x) and (obx + w > x) and (oby + n - 1 == y) then
                                self:setValue(list[n + offset])
                                self:selectHandler()
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

        onSelect = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("select_item", v)
                end
            end
            return self
        end,

        selectHandler = function(self)
            self:sendEvent("select_item", self:getValue())
        end,

        draw = function(self)
            base.draw(self)
            self:addDraw("list", function()
                local w, h = self:getSize()
                local offset = self:getOffset()
                local selectionColorActive = self:getSelectionColorActive()
                local itemSelectedBG = self:getSelectionBackground()
                local itemSelectedFG = self:getSelectionForeground()
                local activeObject = self:getValue()
                for n = 1, h do
                    if list[n + offset] then
                        local t = list[n + offset].text
                        local fg, bg = list[n + offset].fgCol, list[n + offset].bgCol
                        if list[n + offset] == activeObject and selectionColorActive then
                            fg, bg = itemSelectedFG, itemSelectedBG
                        end
                        self:addText(1, n, t:sub(1, w))
                        self:addFg(1, n, tHex[fg]:rep(w))
                        self:addBg(1, n, tHex[bg]:rep(w))
                    end
                end
            end)
        end,
    }

    object.__index = object
    return setmetatable(object, base)
end