Hello! This page contains some tips on how to create cool designs with Basalt

To understand this page, it is recommended to familiarize yourself with [Animations](../objects/Animation.md) as animations are important for creating complex designs

Let us begin with simple things:

## Recolor objects

Let's create a Button:

```lua
local basalt = require("Basalt")
local mainFrame = basalt.createFrame():setBackground(colors.black):show()
local aButton = mainFrame:addButton():setSize(10, 3):setText("Beautiful"):setBackground(colors.gray):show()
```

Here lets make use of the event system:<br>
```lua
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
```

## Fade In/Out Objects
instead of recoloring we are also able to slowly reposition the button, something like fade in:<br>
```lua
local buttonAnimation = mainFrame:addAnimation()
local function fadeButtonIn(btn)
    if(btn.x < 5)then
        btn:setPosition(1,0,"r")
    else
        buttonAnimation:cancel() -- here you cancel the loop
    end
end

buttonAnimation:wait(0.1):add(function() fadeButtonIn(aButton) end):play(true) -- with play(true) you will create a infinite loop
```
This is also possible with entire frames and its children objects. So keep that in mind if you want to create something like a bigger panel to the right or a menu bar

## How To use XML
Here is a example on how to create a cool looking frame by using xml:
```xml
<frame width="parent.w/2" bg="gray" scrollable="true" importantScroll="true">
    <button x="2" y="2" width="parent.w-2" bg="black" fg="lightGray" text="Example Button 1!"/>
    <button x="2" y="6" width="parent.w-2" bg="black" fg="lightGray" text="Example Button 2!"/>
    <button x="2" y="10" width="parent.w-2" bg="black" fg="lightGray" text="Example Button 3!"/>
    <button x="2" y="14" width="parent.w-2" bg="black" fg="lightGray" text="Example Button 4!"/>
    <button x="2" y="18" width="parent.w-2" bg="black" fg="lightGray" text="Example Button 5!"/>
    <button x="2" y="22" width="parent.w-2" bg="black" fg="lightGray" text="Example Button 6!"/>
    <button x="2" y="26" width="parent.w-2" bg="black" fg="lightGray" text="Example Button 7!"/>
</frame>
<frame x="parent.w/2+1" width="parent.w/2+1" bg="black">
    <textfield bg="gray" x="2" y="2" width="parent.w-2">
        <lines>
            <line>This is line 1.</line>
            <line>And this is line 2.</line>
        </lines>
    </textfield>
    <label anchor="bottomLeft" x="2" y="0" text="I love labels!" fg="lightGray"/>
</frame>
```
in your lua code you just have to add this layout to your frame:
```lua
local basalt = require("Basalt")

basalt.createFrame():addLayout("example.xml")
basalt.autoUpdate()
```
