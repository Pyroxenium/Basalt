local utils = require("utils")
local tHex = require("tHex")

return function(name, basalt)
    local base = basalt.getObject("List")(name, basalt)
    local objectType = "Dropdown"

    base:setSize(12, 1)
    base:setZIndex(6)

    local itemSelectedBG = colors.black
    local itemSelectedFG = colors.lightGray
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
        end,

        isType = function(self, t)
            return objectType==t or base.isType~=nil and base.isType(t) or false
        end,

        load = function(self)
            self:listenEvent("mouse_click", self)
            self:listenEvent("mouse_up", self)
            self:listenEvent("mouse_scroll", self)
            self:listenEvent("mouse_drag", self)
        end,

        setOffset = function(self, yOff)
            yOffset = yOff
            self:updateDraw()
            return self
        end,

        getOffset = function(self)
            return yOffset
        end,

        setDropdownSize = function(self, width, height)
            dropdownW, dropdownH = width, height
            self:updateDraw()
            return self
        end,

        getDropdownSize = function(self)
            return dropdownW, dropdownH
        end,

        mouseHandler = function(self, button, x, y)
            if (isOpened) then
                local obx, oby = self:getAbsolutePosition()
                if(button==1)then
                    local list = self:getAll()
                    if (#list > 0) then
                        for n = 1, dropdownH do
                            if (list[n + yOffset] ~= nil) then
                                if (obx <= x) and (obx + dropdownW > x) and (oby + n == y) then
                                    self:setValue(list[n + yOffset])
                                    self:updateDraw()
                                    local val = self:sendEvent("mouse_click", self, "mouse_click", dir, x, y)
                                    if(val==false)then return val end
                                    return true
                                end
                            end
                        end
                    end
                end
            end
            local base = base:getBase()
            if (base.mouseHandler(self, button, x, y)) then
                isOpened = true
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
                local obx, oby = self:getAbsolutePosition()
                if(button==1)then
                    local list = self:getAll()
                    if (#list > 0) then
                        for n = 1, dropdownH do
                            if (list[n + yOffset] ~= nil) then
                                if (obx <= x) and (obx + dropdownW > x) and (oby + n == y) then
                                    isOpened = false
                                    self:updateDraw()
                                    local val = self:sendEvent("mouse_up", self, "mouse_up", dir, x, y)
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
                local list = self:getAll()
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
                local val = self:sendEvent("mouse_scroll", self, "mouse_scroll", dir, x, y)
                if(val==false)then return val end
                self:updateDraw()
                return true
            end
        end,

        draw = function(self)
            base.draw(self)
            self:setDrawState("list", false)
            self:addDraw("dropdown", function()
                local obx, oby = self:getPosition()
                local w,h = self:getSize()
                local val = self:getValue()
                local list = self:getAll()
                local bgCol, fgCol = self:getBackground(), self:getForeground()
                local text = utils.getTextHorizontalAlign((val~=nil and val.text or ""), w, align):sub(1, w - 1)  .. (isOpened and openedSymbol or closedSymbol)
                self:addBlit(1, 1, text, tHex[fgCol]:rep(#text), tHex[bgCol]:rep(#text))

                if (isOpened) then
                    self:addTextBox(1, 2, dropdownW, dropdownH, " ")
                    self:addBackgroundBox(1, 2, dropdownW, dropdownH, bgCol)
                    self:addForegroundBox(1, 2, dropdownW, dropdownH, fgCol)
                    for n = 1, dropdownH do
                        if (list[n + yOffset] ~= nil) then
                            local t =utils.getTextHorizontalAlign(list[n + yOffset].text, dropdownW, align)
                            if (list[n + yOffset] == val) then
                                if (selectionColorActive) then
                                    self:addBlit(1, n+1, t, tHex[itemSelectedFG]:rep(#t), tHex[itemSelectedBG]:rep(#t))
                                else
                                    self:addBlit(1, n+1, t, tHex[list[n + yOffset].fgCol]:rep(#t), tHex[list[n + yOffset].bgCol]:rep(#t))
                                end
                            else
                                self:addBlit(1, n+1, t, tHex[list[n + yOffset].fgCol]:rep(#t), tHex[list[n + yOffset].bgCol]:rep(#t))
                            end
                        end
                    end
                end
            end)
        end,
    }

    object.__index = object
    return setmetatable(object, base)
end