return function(name, basalt)
    local base = basalt.getObject("ChangeableObject")(name, basalt)
    local objectType = "Progressbar"

    local progress = 0

    base:setZIndex(5)
    base:setValue(false)
    base:setSize(25, 3)

    local activeBarColor = colors.black
    local activeBarSymbol = ""
    local activeBarSymbolCol = colors.white
    local bgBarSymbol = ""
    local direction = 0

    local object = {
        getType = function(self)
            return objectType
        end,

        setDirection = function(self, dir)
            direction = dir
            self:updateDraw()
            return self
        end,

        setProgressBar = function(self, color, symbol, symbolcolor)
            activeBarColor = color or activeBarColor
            activeBarSymbol = symbol or activeBarSymbol
            activeBarSymbolCol = symbolcolor or activeBarSymbolCol
            self:updateDraw()
            return self
        end,

        getProgressBar = function(self)
            return activeBarColor, activeBarSymbol, activeBarSymbolCol
        end,

        setBackgroundSymbol = function(self, symbol)
            bgBarSymbol = symbol:sub(1, 1)
            self:updateDraw()
            return self
        end,

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
        end,

        getProgress = function(self)
            return progress
        end,

        onProgressDone = function(self, f)
            self:registerEvent("progress_done", f)
            return self
        end,

        progressDoneHandler = function(self)
            self:sendEvent("progress_done", self)
        end,

        draw = function(self)
            base.draw(self)
            self:addDraw("progressbar", function()
                local obx, oby = self:getPosition()
                local w,h = self:getSize()
                local bgCol,fgCol = self:getBackground(), self:getForeground()
                if(bgCol~=false)then self:addBackgroundBox(obx, oby, w, h, bgCol) end
                if(bgBarSymbol~="")then self:addTextBox(obx, oby, w, h, bgBarSymbol) end
                if(fgCol~=false)then self:addForegroundBox(obx, oby, w, h, fgCol) end
                if (direction == 1) then
                    self:addBackgroundBox(obx, oby, w, h / 100 * progress, activeBarColor)
                    self:addForegroundBox(obx, oby, w, h / 100 * progress, activeBarSymbolCol)
                    self:addTextBox(obx, oby, w, h / 100 * progress, activeBarSymbol)
                elseif (direction == 2) then
                    self:addBackgroundBox(obx, oby + math.ceil(h - h / 100 * progress), w, h / 100 * progress, activeBarColor)
                    self:addForegroundBox(obx, oby + math.ceil(h - h / 100 * progress), w, h / 100 * progress, activeBarSymbolCol)
                    self:addTextBox(obx, oby + math.ceil(h - h / 100 * progress), w, h / 100 * progress, activeBarSymbol)
                elseif (direction == 3) then
                    self:addBackgroundBox(obx + math.ceil(w - w / 100 * progress), oby, w / 100 * progress, h, activeBarColor)
                    self:addForegroundBox(obx + math.ceil(w - w / 100 * progress), oby, w / 100 * progress, h, activeBarSymbolCol)
                    self:addTextBox(obx + math.ceil(w - w / 100 * progress), oby, w / 100 * progress, h, activeBarSymbol)
                else
                    self:addBackgroundBox(obx, oby, w / 100 * progress, h, activeBarColor)
                    self:addForegroundBox(obx, oby, w / 100 * progress, h, activeBarSymbolCol)
                    self:addTextBox(obx, oby, w / 100 * progress, h, activeBarSymbol)
                end
            end)
        end,

    }

    object.__index = object
    return setmetatable(object, base)
end