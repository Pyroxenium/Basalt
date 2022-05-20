local function Example(name) -- you can call this function how you want, doesn't matter
    local base = Object(name) -- this will load the base object class, it is necessary if you want to make a visual object, otherwise you dont need that.
    local objectType = "Example" -- here is the object type, make sure it is the same as the file name - this way you can also make sure its unique

     -- here you could set some default values, but its not necessary, it doesn't matter if you call the functions or change the values directly, maybe i should change that
     --i guess its better if you call functions base:setBackground, base:setSize and so on.
    base.width = 3
    base.height = 1
    base.bgColor = colors.lightGray
    base.fgColor = colors.gray
    base:setValue(false)
    base:setZIndex(5) -- if you want to change the zIndex always use the function

    local object = { -- here you start your unique object class, please always make sure a getType exists!
        getType = function(self)
            return objectType
        end;


        mouseClickHandler = function(self, event, button, x, y) -- this is your extended mouseClickHandler, if you want something to happen if the user clicks on that
            if (base.mouseClickHandler(self, event, button, x, y)) then -- here you access the base class mouseClickHandler it will return true if the user really clicks on the object
                local obx, oby = self:getAbsolutePosition(self:getAnchorPosition()) --getAnchorPosition is obviously for returning the x and y coords changed by the anchor system, absolute position explains itself i guess
                if ((event == "mouse_click") or (event == "mouse_drag")) and (button == 1) then
                    --here you can create your logic
                end
                return true -- please always return true if base.mouseClickHandler also returns true, otherwise your object wont get focused.
            end
        end;

        draw = function(self) -- if your object is visual, you will need a draw function
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    --self.parent:setBackground(obx, oby, self.width, self.height, self.bgColor) -- changes the background color of that object
                    --self.parent:setForeground(obx, oby, self.width, self.height, self.fgColor) -- changes the foreground (textcolor) color of that object
                    --self.parent:writeText(obx, oby, "Some Text", self.bgColor, self.fgColor) -- writes something on the screen, also able to change its bgcolor and fgcolor

                    --the draw functions always gets called after something got visually changed. I am always redrawing the entire screen, but only if something has changed.
                end
            end
        end;
    }

    return setmetatable(object, base) -- required
end