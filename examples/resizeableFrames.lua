-- Hello, here is a small example on how to create resizeable frames, the default anchor (where you have to click on) will be bottom right.

local basalt = require("basalt")

local main = basalt.createFrame()

local sub = main:addFrame() -- the frame we want to resize
    :setPosition(3,3)
    :setSize(25,8)
    :setMovable()
    :setBorder(colors.black)

sub:addLabel() -- the new way to create a bar on the top
    :setText("Topbar")
    :setSize("parent.w",1)
    :setBackground(colors.black)
    :setForeground(colors.lightGray)

sub:addButton()
    :setAnchor("bottomRight")
    :setPosition(1, 1)
    :setText("/")
    :setSize(1,1)
    :onDrag(function(self, button, x, y, xOffset, yOffset)
        local w, h = sub:getSize()
        if(w-xOffset>5)and(h-yOffset>3)then -- dont allow it to be smaller than w5 and h3
            sub:setSize(-xOffset, -yOffset, true) -- x-/yOffset is always -1 0 or 1, true means add the value to the current size instead of set it
        end
    end)

sub:addButton() -- just a random button to show dynamic values
    :setPosition(2,3)
    :setBackground(colors.black)
    :setForeground(colors.lightGray)
    :setSize("parent.w-2", 3) -- parent.w means get the parent's width which is the sub frame in this case, -2 means remove 2 from it's result. You could also use * / % or even math.random(12)


basalt.autoUpdate()