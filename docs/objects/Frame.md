# Frames

<a href="https://i.imgur.com/aikc0K1.png"><img src="https://i.imgur.com/aikc0K1.png" height="500" /></a>

Frames are like containers, but are also normal objects.
In other words, you can add other objects _(even frames)_ to a frame; if the frame itself is visible
all sub-objects _(if they are set as visible)_ are also visible. A better description will follow.

## basalt.createFrame
Creates a new non-parent frame - in most cases it is the first thing you need.

````lua
local myFirstFrame = basalt.createFrame("myFirstFrame")
````
**Parameters:** <br>
1. string name (should be unique)<br>
**returns:** new frame object<br>

## addFrame
The same as basalt.createFrame, but it will have a parent frame
````lua
frame:addFrame("myFirstFrame")
````
**Parameters:** string name (should be unique)<br>
**returns:** new frame object<br>
Example:
````lua
local mainFrame = basalt.createFrame("myFirstFrame")
local aFrame = mainFrame:addFrame("myFirstSubFrame")
````
## setBar
Changes the frame bar
````lua
frame:setBar("My first Frame!", colors.gray, colors.lightGray)
````
**Parameters:** string text, number bgcolor, number fgcolor<br>
**returns:** self<br>
Example:
````lua
local mainFrame = basalt.createFrame("myFirstFrame")
local aFrame = MainFrame:addFrame("myFirstSubFrame")
aFrame:setBar("My first Frame!")
````
or:
````lua
local mainFrame = basalt.createFrame("myFirstFrame")
local aFrame = mainFrame:addFrame("myFirstSubFrame"):setBar("My first Frame!")
````

## setBarTextAlign
Sets the bar text alignment
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):setBar("My first Frame!"):setBarTextAlign("right")
````
**Parameters:** string value - ("left", "center", "right"))<br>
**returns:** self<br>



## showBar
shows/hides the bar on top where you will see the title if its active
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):setBar("Hello World!"):showBar()
````
**Parameters:** bool visible (no Parameters = true)<br>
**returns:** self<br>

## isModifierActive -- DISABLED this function will work very soon
returns true if user is currently holding a key down
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):isModifierActive("shift")
````
**Parameters:** int or string - int can be any os.queueEvent("key") key, or instead of int you can use the following strings: "shift", "ctrl", "alt"<br>
**returns:** boolean - if the user is holding the key down<br>

**Example:**
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):setSize(20,8):show()
local aLabel = mainFrame:addLabel("myFirstLabel"):setText("shift inactive")
mainFrame:addButton("myFirstButton"):setText("Click"):onClick(function()
if(mainFrame:isModifierActive("shift")then
    aLabel:setText("shift is active yay")
else
    aLabel:setText("shift is not active ohno")
end)
````

## getObject
returns a children object
````lua
local mainFrame = basalt.createFrame("myFirstFrame")
mainFrame:addButton("myFirstButton")
local aButton = mainFrame:getObject("myFirstButton")
````
**Parameters:** string name (has to be a children)<br>
**returns:** any object<br>

## removeObject
removes the object
````lua
local mainFrame = basalt.createFrame("myFirstFrame")
mainFrame:addButton("myFirstButton")
mainFrame:removeObject("myFirstButton")
````
**Parameters:** string name (has to be a children)<br>
**returns:** any object<br>

## setFocusedObject
changes the currently focused object
````lua
local mainFrame = basalt.createFrame("myFirstFrame")
local aButton = mainFrame:addButton("myFirstButton")
mainFrame:setFocusedObject(aButton)
````
**Parameters:** any object (has to be a children)<br>
**returns:** self<br>
## removeFocusedObject
removes the focus of the currently focused object
````lua
local mainFrame = basalt.createFrame("myFirstFrame")
local aButton = mainFrame:addButton("myFirstButton")
mainFrame:removeFocusedObject(aButton)
````
**Parameters:** any object (has to be a children)<br>
**returns:** self<br>

## getFocusedObject
gets the currently focused object
````lua
local mainFrame = basalt.createFrame("myFirstFrame")
local aButton = mainFrame:addButton("myFirstButton")
local focusedObject = mainFrame:getFocusedObject()
````
**Parameters:** -<br>
**returns:** object<br>

## setMovable


## setMoveable
##### _Deprecated in favor of setMovable_

sets if the frame should be moveable or not (to move the frame you need to drag it on the top bar)

````lua
local mainFrame = basalt.createFrame("myFirstFrame"):setMoveable(true)
````
**Parameters:** bool moveable<br>
**returns:** self<br>

## setOffset
sets the frame's coordinate offset, they will get added to their children objects. For example, if you use the scrollbar and you use its value to add a offset to a frame, you will get a scrollable frame.
objects are also able to ignore the offset by using :ignoreOffset() (maybe your scrollbar if its a children of the frame should ignore offset)

````lua
local mainFrame = basalt.createFrame("myFirstFrame"):setOffset(5, 3)
````
**Parameters:** number x, number y (offset in x direction and offset in y direction, also doesn't matter if its a negative value or positive<br>
**returns:** self<br>
