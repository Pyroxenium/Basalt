local Object = require("Object")
local xmlValue = require("utils").getValueFromXML

return function(name)
    local base = Object(name)
    local objectType = "Switch"

    base.width = 2
    base.height = 1
    base.bgColor = colors.lightGray
    base.fgColor = colors.gray
    base:setValue(false)
    base:setZIndex(5)

    local bgSymbol = colors.black
    local inactiveBG = colors.red
    local activeBG = colors.green

    local object = {
        init = function(self)
            self.bgColor = self.parent:getTheme("SwitchBG")
            self.fgColor = self.parent:getTheme("SwitchText")
            bgSymbol = self.parent:getTheme("SwitchBGSymbol")
            inactiveBG = self.parent:getTheme("SwitchInactive")
            activeBG = self.parent:getTheme("SwitchActive")
        end,
        getType = function(self)
            return objectType
        end;

        setSymbolColor = function(self, symbolColor)
            bgSymbol = symbolColor
            self:setVisualChanged()
            return self
        end;

        setActiveBackground = function(self, bgcol)
            activeBG = bgcol
            self:setVisualChanged()
            return self
        end;

        setInactiveBackground = function(self, bgcol)
            inactiveBG = bgcol
            self:setVisualChanged()
            return self
        end;

        setValuesByXMLData = function(self, data)
            base.setValuesByXMLData(self, data)
            if(xmlValue("inactiveBG", data)~=nil)then inactiveBG = colors[xmlValue("inactiveBG", data)] end
            if(xmlValue("activeBG", data)~=nil)then activeBG = colors[xmlValue("activeBG", data)] end
            if(xmlValue("symbolColor", data)~=nil)then bgSymbol = colors[xmlValue("symbolColor", data)]  end

        end,

        mouseHandler = function(self, event, button, x, y)
            if (base.mouseHandler(self, event, button, x, y)) then
                local obx, oby = self:getAbsolutePosition(self:getAnchorPosition())
                if ((event == "mouse_click") and (button == 1))or(event=="monitor_touch") then
                    self:setValue(not self:getValue())
                end
                return true
            end
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    local w,h = self:getSize()
                    self.parent:drawBackgroundBox(obx, oby, w, h, self.bgColor)
                    if(self:getValue())then
                        self.parent:drawBackgroundBox(obx, oby, 1, h, activeBG)
                        self.parent:drawBackgroundBox(obx+1, oby, 1, h, bgSymbol)
                    else
                        self.parent:drawBackgroundBox(obx, oby, 1, h, bgSymbol)
                        self.parent:drawBackgroundBox(obx+1, oby, 1, h, inactiveBG)
                    end
                end
                self:setVisualChanged(false)
            end
        end;
    }

    return setmetatable(object, base)
end