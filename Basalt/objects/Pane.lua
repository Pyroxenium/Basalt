local Object = require("Object")
local log = require("basaltLogs")

return function(name)
    -- Pane
    local base = Object(name)
    local objectType = "Pane"

    local object = {
        getType = function(self)
            return objectType
        end;

        setBackground = function(self, col, sym, symC)
            base.setBackground(self, col, sym, symC)
            return self
        end,

        init = function(self)
            if(base.init(self))then
                self.bgColor = self.parent:getTheme("PaneBG")
                self.fgColor = self.parent:getTheme("PaneBG")
            end
        end,
    }

    return setmetatable(object, base)
end