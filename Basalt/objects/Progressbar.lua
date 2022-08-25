local Object = require("Object")
local xmlValue = require("utils").getValueFromXML

return function(name)
    -- Checkbox
    local base = Object(name)
    local objectType = "Progressbar"

    local progress = 0

    base:setZIndex(5)
    base:setValue(false)
    base.width = 25
    base.height = 1

    local activeBarColor
    local activeBarSymbol = ""
    local activeBarSymbolCol = colors.white
    local bgBarSymbol = ""
    local direction = 0

    local object = {
        init = function(self)
            self.bgColor = self.parent:getTheme("ProgressbarBG")
            self.fgColor = self.parent:getTheme("ProgressbarText")
            activeBarColor = self.parent:getTheme("ProgressbarActiveBG")
        end,
        getType = function(self)
            return objectType
        end;

        setValuesByXMLData = function(self, data)
            base.setValuesByXMLData(self, data)
            if(xmlValue("direction", data)~=nil)then direction = xmlValue("direction", data) end
            if(xmlValue("progressColor", data)~=nil)then activeBarColor = colors[xmlValue("progressColor", data)] end
            if(xmlValue("progressSymbol", data)~=nil)then activeBarSymbol = xmlValue("progressSymbol", data) end
            if(xmlValue("backgroundSymbol", data)~=nil)then bgBarSymbol = xmlValue("backgroundSymbol", data) end
            if(xmlValue("progressSymbolColor", data)~=nil)then activeBarSymbolCol = colors[xmlValue("progressSymbolColor", data)] end
            if(xmlValue("onDone", data)~=nil)then self:generateXMLEventFunction(self.onProgressDone, xmlValue("onDone", data)) end
            return self
        end,

        setDirection = function(self, dir)
            direction = dir
            self:updateDraw()
            return self
        end;

        setProgressBar = function(self, color, symbol, symbolcolor)
            activeBarColor = color or activeBarColor
            activeBarSymbol = symbol or activeBarSymbol
            activeBarSymbolCol = symbolcolor or activeBarSymbolCol
            self:updateDraw()
            return self
        end;

        setBackgroundSymbol = function(self, symbol)
            bgBarSymbol = symbol:sub(1, 1)
            self:updateDraw()
            return self
        end;

        setProgress = function(self, value)
            if (value >= 0) and (value <= 100) and (progress ~= value) then
                progress = value
                self:setValue(progress)
                if (progress == 100) then
                    self:progressDoneHandler()
                end
            end
            self:updateDraw()
            return self
        end;

        getProgress = function(self)
            return progress
        end;

        onProgressDone = function(self, f)
            self:registerEvent("progress_done", f)
            return self
        end;

        progressDoneHandler = function(self)
            self:sendEvent("progress_done", self)
        end;

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    local w,h = self:getSize()
                    if(self.bgColor~=false)then self.parent:drawBackgroundBox(obx, oby, w, h, self.bgColor) end
                    if(bgBarSymbol~="")then self.parent:drawTextBox(obx, oby, w, h, bgBarSymbol) end
                    if(self.fgColor~=false)then self.parent:drawForegroundBox(obx, oby, w, h, self.fgColor) end
                    if (direction == 1) then
                        self.parent:drawBackgroundBox(obx, oby, w, h / 100 * progress, activeBarColor)
                        self.parent:drawForegroundBox(obx, oby, w, h / 100 * progress, activeBarSymbolCol)
                        self.parent:drawTextBox(obx, oby, w, h / 100 * progress, activeBarSymbol)
                    elseif (direction == 2) then
                        self.parent:drawBackgroundBox(obx, oby + math.ceil(h - h / 100 * progress), w, h / 100 * progress, activeBarColor)
                        self.parent:drawForegroundBox(obx, oby + math.ceil(h - h / 100 * progress), w, h / 100 * progress, activeBarSymbolCol)
                        self.parent:drawTextBox(obx, oby + math.ceil(h - h / 100 * progress), w, h / 100 * progress, activeBarSymbol)
                    elseif (direction == 3) then
                        self.parent:drawBackgroundBox(obx + math.ceil(w - w / 100 * progress), oby, w / 100 * progress, h, activeBarColor)
                        self.parent:drawForegroundBox(obx + math.ceil(w - w / 100 * progress), oby, w / 100 * progress, h, activeBarSymbolCol)
                        self.parent:drawTextBox(obx + math.ceil(w - w / 100 * progress), oby, w / 100 * progress, h, activeBarSymbol)
                    else
                        self.parent:drawBackgroundBox(obx, oby, w / 100 * progress, h, activeBarColor)
                        self.parent:drawForegroundBox(obx, oby, w / 100 * progress, h, activeBarSymbolCol)
                        self.parent:drawTextBox(obx, oby, w / 100 * progress, h, activeBarSymbol)
                    end
                end
            end
        end,

    }

    return setmetatable(object, base)
end