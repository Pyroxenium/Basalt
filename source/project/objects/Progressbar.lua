local function Progressbar(name)
    -- Checkbox
    local base = Object(name)
    local objectType = "Progressbar"

    local progress = 0

    base:setZIndex(5)
    base:setValue(false)
    base.width = 25
    base.height = 1
    base.bgColor = theme.CheckboxBG
    base.fgColor = theme.CheckboxFG

    local activeBarColor = colors.black
    local activeBarSymbol = ""
    local activeBarSymbolCol = colors.white
    local bgBarSymbol = ""
    local direction = 0

    local object = {

        getType = function(self)
            return objectType
        end;

        setDirection = function(self, dir)
            direction = dir
            return self
        end;

        setProgressBar = function(self, color, symbol, symbolcolor)
            activeBarColor = color or activeBarColor
            activeBarSymbol = symbol or activeBarSymbol
            activeBarSymbolCol = symbolcolor or activeBarSymbolCol
            return self
        end;

        setBackgroundSymbol = function(self, symbol)
            bgBarSymbol = symbol:sub(1, 1)
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
                    self.parent:drawBackgroundBox(obx, oby, self.width, self.height, self.bgColor)
                    self.parent:drawForegroundBox(obx, oby, self.width, self.height, self.fgColor)
                    self.parent:drawTextBox(obx, oby, self.width, self.height, bgBarSymbol)
                    if (direction == 1) then
                        self.parent:drawBackgroundBox(obx, oby, self.width, self.height / 100 * progress, activeBarColor)
                        self.parent:drawForegroundBox(obx, oby, self.width, self.height / 100 * progress, activeBarSymbolCol)
                        self.parent:drawTextBox(obx, oby, self.width, self.height / 100 * progress, activeBarSymbol)
                    elseif (direction == 2) then
                        self.parent:drawBackgroundBox(obx, oby + math.ceil(self.height - self.height / 100 * progress), self.width, self.height / 100 * progress, activeBarColor)
                        self.parent:drawForegroundBox(obx, oby + math.ceil(self.height - self.height / 100 * progress), self.width, self.height / 100 * progress, activeBarSymbolCol)
                        self.parent:drawTextBox(obx, oby + math.ceil(self.height - self.height / 100 * progress), self.width, self.height / 100 * progress, activeBarSymbol)
                    elseif (direction == 3) then
                        self.parent:drawBackgroundBox(obx + math.ceil(self.width - self.width / 100 * progress), oby, self.width / 100 * progress, self.height, activeBarColor)
                        self.parent:drawForegroundBox(obx + math.ceil(self.width - self.width / 100 * progress), oby, self.width / 100 * progress, self.height, activeBarSymbolCol)
                        self.parent:drawTextBox(obx + math.ceil(self.width - self.width / 100 * progress), oby, self.width / 100 * progress, self.height, activeBarSymbol)
                    else
                        self.parent:drawBackgroundBox(obx, oby, self.width / 100 * progress, self.height, activeBarColor)
                        self.parent:drawForegroundBox(obx, oby, self.width / 100 * progress, self.height, activeBarSymbolCol)
                        self.parent:drawTextBox(obx, oby, self.width / 100 * progress, self.height, activeBarSymbol)
                    end
                end
                self:setVisualChanged(false)
            end
        end;

    }

    return setmetatable(object, base)
end