return function(name, basalt)
    local base = basalt.getObject("ChangeableObject")(name, basalt)
    base:setType("ProgressBar")

    base:setZ(5)
    base:setValue(false)
    base:setSize(25, 3)

    base:addProperty("Progress", "number", 0, false, function(self, value)
        local progress = self:getProgress()
        if (value >= 0) and (value <= 100) and (progress ~= value) then
            self:setValue(progress)
            if (progress == 100) then
                self:progressDoneHandler()
            end
            return value
        end
        return progress
    end)
    base:addProperty("Direction", "number", 0)
    base:addProperty("ActiveBarSymbol", "string", " ")
    base:addProperty("ActiveBarColor", "color", colors.black)
    base:addProperty("ActiveBarSymbolColor", "color", colors.white)
    base:combineProperty("ProgressBar", "ActiveBarColor", "ActiveBarSymbol", "ActiveBarSymbolColor")
    base:addProperty("BackgroundSymbol", "char", "")

    local object = {
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
                local w,h = self:getSize()
                local p = self:getProperties()
                local activeBarColor, activeBarSymbol, activeBarSymbolCol = self:getActiveBarColor(), self:getActiveBarSymbol(), self:getActiveBarSymbolColor()
                activeBarColor = activeBarColor or colors.red
                activeBarSymbol = activeBarSymbol or " "
                activeBarSymbolCol = activeBarSymbolCol or colors.white
                if(p.Background~=nil)then self:addBackgroundBox(1, 1, w, h, p.Background) end
                if(p.BgSymbol~="")then self:addTextBox(1, 1, w, h, p.BgSymbol) end
                if(p.Foreground~=nil)then self:addForegroundBox(1, 1, w, h, p.Foreground) end
                if (p.Direction == 1) then
                    self:addBackgroundBox(1, 1, w, h / 100 * p.Progress, activeBarColor)
                    self:addForegroundBox(1, 1, w, h / 100 * p.Progress, activeBarSymbolCol)
                    self:addTextBox(1, 1, w, h / 100 * p.Progress, activeBarSymbol)
                elseif (p.Direction == 3) then
                    self:addBackgroundBox(1, 1 + math.ceil(h - h / 100 * p.Progress), w, h / 100 * p.Progress, activeBarColor)
                    self:addForegroundBox(1, 1 + math.ceil(h - h / 100 * p.Progress), w, h / 100 * p.Progress, activeBarSymbolCol)
                    self:addTextBox(1, 1 + math.ceil(h - h / 100 * p.Progress), w, h / 100 * p.Progress, activeBarSymbol)
                elseif (p.Direction == 2) then
                    self:addBackgroundBox(1 + math.ceil(w - w / 100 * p.Progress), 1, w / 100 * p.Progress, h, activeBarColor)
                    self:addForegroundBox(1 + math.ceil(w - w / 100 * p.Progress), 1, w / 100 * p.Progress, h, activeBarSymbolCol)
                    self:addTextBox(1 + math.ceil(w - w / 100 * p.Progress), 1, w / 100 * p.Progress, h, activeBarSymbol)
                else
                    self:addBackgroundBox(1, 1, math.ceil( w / 100 * p.Progress), h, activeBarColor)
                    self:addForegroundBox(1, 1, math.ceil(w / 100 * p.Progress), h, activeBarSymbolCol)
                    self:addTextBox(1, 1, math.ceil(w / 100 * p.Progress), h, activeBarSymbol)
                end
            end)
        end,

    }

    object.__index = object
    return setmetatable(object, base)
end
