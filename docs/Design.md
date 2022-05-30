Hi! Here i will give you some tips on how to create cool designs with NyoUI

First of all, you have to check out animations, because animations are very important for creating cool designs

Let us begin with simple things:

# Recolor objects

Let us create the Button:<br>
````lua
local NyoUI = dofile("NyoUI.lua")
local mainFrame = NyoUI.createFrame("myFirstFrame"):setBackground(colors.black):show()
local aButton = mainFrame:addButton("myFirstButton"):setSize(10,3):setText("Beautiful"):setBackground(colors.gray):show()
````

Here lets make use of the event system:<br>
````lua
local function changeButtonColor(self,event,typ,x,y)
    if(event=="mouse_click")then
        self:setBackground(colors.lightGray)
    end
    if(event=="mouse_up")then
        self:setBackground(colors.gray)
    end
end

local function buttonLogic()
    -- here you can do some logic when button gets the mouse_up event
end

aButton:onClick(changeButtonColor) -- button color change on click
aButton:onClickUp(changeButtonColor) -- button color change on click up
aButton:onClickUp(buttonLogic) -- button logic on click up
aButton:onLoseFocus(function(self) self:setBackground(colors.gray) end) -- if user is clicking on the button and dragging out of button size this event will change the bg color back to gray
````

# fade in/out objects
instead of recoloring we are also able to slowly reposition the button, something like fade in:<br>
````lua
local buttonAnimation = mainFrame:addAnimation("buttonFadeAnim")
local function fadeButtonIn(btn)
    if(btn.x < 5)then
        btn:setPosition(1,0,"r")
    else
        buttonAnimation:cancel() -- here you cancel the loop
    end
end

buttonAnimation:wait(0.1):add(function() fadeButtonIn(aButton) end):play(true) -- with play(true) you will create a infinite loop
````
This is also possible with entire frames and its children objects. So keep that in mind if you want to create something like a bigger panel to the right or a menu bar

WIP