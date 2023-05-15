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

        getDirection = function(self)
            return direction
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

        setActiveBarColor = function(self, color)
            return self:setProgressBar(color, nil, nil)
        end,

        getActiveBarColor = function(self)
            return activeBarColor
        end,

        setActiveBarSymbol = function(self, symbol)
            return self:setProgressBar(nil, symbol, nil)
        end,

        getActiveBarSymbol = function(self)
            return activeBarSymbol
        end,

        setActiveBarSymbolColor = function(self, symbolColor)
            return self:setProgressBar(nil, nil, symbolColor)
        end,

        getActiveBarSymbolColor = function(self)
            return activeBarSymbolCol
        end,

        setBackgroundSymbol = function(self, symbol)
            bgBarSymbol = symbol:sub(1, 1)
            self:updateDraw()
            return self
        end,

        getBackgroundSymbol = function(self)
            return bgBarSymbol
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
            self:sendEvent("progress_done")
        end,

        draw = function(self)
            base.draw(self)
            self:addDraw("progressbar", function()
                local obx, oby = self:getPosition()
                local w,h = self:getSize()
                local bgCol,fgCol = self:getBackground(), self:getForeground()
                if(bgCol~=false)then self:addBackgroundBox(1, 1, w, h, bgCol) end
                if(bgBarSymbol~="")then self:addTextBox(1, 1, w, h, bgBarSymbol) end
                if(fgCol~=false)then self:addForegroundBox(1, 1, w, h, fgCol) end
                if (direction == 1) then
                    self:addBackgroundBox(1, 1, w, h / 100 * progress, activeBarColor)
                    self:addForegroundBox(1, 1, w, h / 100 * progress, activeBarSymbolCol)
                    self:addTextBox(1, 1, w, h / 100 * progress, activeBarSymbol)
                elseif (direction == 3) then
                    self:addBackgroundBox(1, 1 + math.ceil(h - h / 100 * progress), w, h / 100 * progress, activeBarColor)
                    self:addForegroundBox(1, 1 + math.ceil(h - h / 100 * progress), w, h / 100 * progress, activeBarSymbolCol)
                    self:addTextBox(1, 1 + math.ceil(h - h / 100 * progress), w, h / 100 * progress, activeBarSymbol)
                elseif (direction == 2) then
                    self:addBackgroundBox(1 + math.ceil(w - w / 100 * progress), 1, w / 100 * progress, h, activeBarColor)
                    self:addForegroundBox(1 + math.ceil(w - w / 100 * progress), 1, w / 100 * progress, h, activeBarSymbolCol)
                    self:addTextBox(1 + math.ceil(w - w / 100 * progress), 1, w / 100 * progress, h, activeBarSymbol)
                else
                    self:addBackgroundBox(1, 1, math.ceil( w / 100 * progress), h, activeBarColor)
                    self:addForegroundBox(1, 1, math.ceil(w / 100 * progress), h, activeBarSymbolCol)
                    self:addTextBox(1, 1, math.ceil(w / 100 * progress), h, activeBarSymbol)
                end
            end)
        end,

    }

    object.__index = object
    return setmetatable(object, base)
end