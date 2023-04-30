local utils = require("utils")
local tHex = require("tHex")

return function(name, basalt)
    local base = basalt.getObject("List")(name, basalt)
    local objectType = "Radio"

    base:setSize(1, 1)
    base:setZIndex(5)

    local list = {}
    local boxSelectedBG = colors.black
    local boxSelectedFG = colors.green
    local boxNotSelectedBG = colors.black
    local boxNotSelectedFG = colors.red
    local selectionColorActive = true
    local symbol = "\7"
    local align = "left"

    local object = {
        getType = function(self)
            return objectType
        end,

        addItem = function(self, text, x, y, bgCol, fgCol, ...)
            base.addItem(self, text, bgCol, fgCol, ...)
            table.insert(list, { x = x or 1, y = y or #list * 2 })
            return self
        end,

        removeItem = function(self, index)
            base.removeItem(self, index)
            table.remove(list, index)
            return self
        end,

        clear = function(self)
            base.clear(self)
            list = {}
            return self
        end,

        editItem = function(self, index, text, x, y, bgCol, fgCol, ...)
            base.editItem(self, index, text, bgCol, fgCol, ...)
            table.remove(list, index)
            table.insert(list, index, { x = x or 1, y = y or 1 })
            return self
        end,

        setBoxSelectionColor = function(self, bg, fg)
            boxSelectedBG = bg
            boxSelectedFG = fg
            return self
        end,

        getBoxSelectionColor = function(self)
            return boxSelectedBG, boxSelectedFG
        end,

        setBoxDefaultColor = function(self, bg, fg)
            boxNotSelectedBG = bg
            boxNotSelectedFG = fg
            return self
        end,

        getBoxDefaultColor = function(self)
            return boxNotSelectedBG, boxNotSelectedFG
        end,

        mouseHandler = function(self, button, x, y, ...)
            if (#list > 0) then
                local obx, oby = self:getAbsolutePosition()
                local baseList = self:getAll()
                for k, value in pairs(baseList) do
                    if (obx + list[k].x - 1 <= x) and (obx + list[k].x - 1 + value.text:len() + 1 >= x) and (oby + list[k].y - 1 == y) then
                        self:setValue(value)
                        local val = self:sendEvent("mouse_click", self, "mouse_click", button, x, y, ...)
                        self:updateDraw()
                        if(val==false)then return val end
                        return true
                    end
                end
            end
        end,

        draw = function(self)
            self:addDraw("radio", function()
                local itemSelectedBG, itemSelectedFG = self:getSelectionColor()
                local baseList = self:getAll()
                for k, value in pairs(baseList) do
                    if (value == self:getValue()) then
                        self:addBlit(list[k].x, list[k].y, symbol, tHex[boxSelectedFG], tHex[boxSelectedBG])
                        self:addBlit(list[k].x + 2, list[k].y, value.text, tHex[itemSelectedFG]:rep(#value.text), tHex[itemSelectedBG]:rep(#value.text))
                    else
                        self:addBackgroundBox(list[k].x, list[k].y, 1, 1, boxNotSelectedBG or colors.black)
                        self:addBlit(list[k].x + 2, list[k].y, value.text, tHex[value.fgCol]:rep(#value.text), tHex[value.bgCol]:rep(#value.text))
                    end
                end
                return true
            end)
        end,
    }

    object.__index = object
    return setmetatable(object, base)
end