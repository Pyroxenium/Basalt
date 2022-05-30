This is the base class of all visual objects. This means, if you create a button, label, frame or something else visual (no timers, threads or animations) the following list can be used:

## show
shows the object (only if the parent frame is already visible)
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local button = mainFrame:addButton("myFirstButton")
button:show()
````
**parameters:** -<br>
**returns:** self<br>

## hide
hides the object 
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local button = mainFrame:addButton("myFirstButton"):setText("Close"):onClick(function() mainFrame:hide() end)
button:show()
````
**parameters:** -<br>
**returns:** self<br>

## setPosition
Changes the position relative to its parent frame
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):setPosition(2,3)
````
**parameters:** number x, number y[, boolean relative], if relative is set to true it will add/remove instead of set x, y<br>
**returns:** self<br>



## setBackground
Changes the object background color
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):setBackground(colors.lightGray)
````
**parameters:** number color<br>
**returns:** self<br>

## setForeground
Changes the object text color
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):setForeground(colors.black)
````
**parameters:** number color<br>
**returns:** self<br>

## setSize
Changes the object size
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):setSize(15,5)
````
**parameters:** number width, number length<br>
**returns:** self<br>

## setFocus    
sets the object to be the focused object.
If you click on a object, it's normaly automatically the focused object. As example, if you :show() a frame and you want this particular frame to be in
the foreground, you have to use :setFocus()
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aButton = mainFrame:addButton("myFirstButton"):setFocus():show()
````
**parameters:** -<br>
**returns:** self<br>

## setZIndex
changes the z index (higher z index do have higher draw/event priority) 10 is more important than 5 or 1. You are also able to add multiple objects to the same z index, which means if you create a couple of buttons, you set their z index to 10, everything below 10 is less important, everything above 10 is more important. On the same z index: the last object which gets created is the most important one.
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aButton = mainFrame:addButton("myFirstButton"):setZIndex(1):show()
````
**parameters:** number index<br>
**returns:** self<br>

## setParent
changes the frame parent of that object
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aRandomFrame = basalt.createFrame("aRandomFrame"):show()
local aButton = mainFrame:addButton("myFirstButton"):onClick(function() aRandomFrame:setParent(mainFrame) end):show()
````
**parameters:** frame object<br>
**returns:** self<br>

## isFocused
returns if the object is currently the focused object of the parent frame

````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aButton = mainFrame:addButton("myFirstButton"):show()
basalt.debug(aButton:isFocused()) -- shows true or false as a debug message
````
**parameters:** -<br>
**returns:** boolean<br>

## getAnchorPosition
converts the x,y coordinates into the anchor coordinates of that object

````lua
local mainFrame = basalt.createFrame("myFirstFrame"):setSize(15,15):show()
local aButton = mainFrame:addButton("myFirstButton"):setAnchor("right","bottom"):setSize(8,1):setPosition(1,1):show()
basalt.debug(aButton:getAnchorPosition()) -- returns 7,14 (framesize - own size) instead of 1,1
````
**parameters:** number x, number y - or nothing (if nothing it uses the object's x, y)<br>
**returns:** number x, number y (converted)<br>

## setAnchor
sets the anchor of that object

````lua
local mainFrame = basalt.createFrame("myFirstFrame"):setAnchor("right"):show()
local aButton = mainFrame:addButton("myFirstButton"):setAnchor("bottom","right"):setSize(8,1):setPosition(1,1):show()
````
**parameters:** string sides - ("left", "right", "top", "bottom") you can stack positions like so ..:setAnchor("right", "bottom")<br>
**returns:** self<br>

## getAbsolutePosition
converts the relative coordinates into absolute coordinates
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):setPosition(3,3):show()
local aButton = mainFrame:addButton("myFirstButton"):setSize(8,1):setPosition(4,2):show()
basalt.debug(aButton:getAbsolutePosition()) -- returns 7,5 (frame coords + own coords) instead of 4,2
````
**parameters:** number x, number y - or nothing (if nothing it uses the object's x, y)<br>
**returns:** self<br>

## setTextAlign
sets the text align of the object (for example buttons)
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aButton = mainFrame:addButton("myFirstButton"):setSize(12,3):setTextAlign("right", "center"):setText("Dont't..."):show()
````
**parameters:** string horizontal, string vertical - ("left", "center", "right")<br>
**returns:** self<br>

## setValue
sets the value of that object (input, label, checkbox, textfield, scrollbar,...)
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aCheckbox = mainFrame:addCheckbox("myFirstCheckbox"):setValue(true):show()
````
**parameters:** any value<br>
**returns:** self<br>

## getValue
returns the currently saved value
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aCheckbox = mainFrame:addCheckbox("myFirstCheckbox"):setValue(true):show()
basalt.debug(aCheckbox:getValue()) -- returns true
````
**parameters:**-<br>
**returns:** any value<br>

## getHeight/getWidth
returns the height or width
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aButton = mainFrame:addButton("myFirstButton"):setSize(5,8):show()
basalt.debug(aButton:getHeight()) -- returns 8
````
**parameters:**-<br>
**returns:** number height/width<br>

## isVisible
returns if the object is currently visible
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aButton = mainFrame:addButton("myFirstButton"):setSize(5,8):show()
basalt.debug(aButton:isVisible()) -- returns true
````
**parameters:**-<br>
**returns:** boolean<br>

## getName
returns the given name of that object
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
basalt.debug(mainFrame:getName()) -- returns myFirstFrame
````
**parameters:**-<br>
**returns:** string name<br>

# Object Events
These object events are available for all objects, if a object got some unique events, you can see them in their own category

## onClick
creates a mouse_click event
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aButton = mainFrame:addButton("myFirstButton"):setSize(10,3):onClick(function(self,event,button,x,y) basalt.debug("Hellooww UwU") end):show()
````
**parameters:** function func<br>
**returns:** self<br>

## onClickUp
creates a click_up event
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aButton = mainFrame:addButton("myFirstButton"):setSize(10,3):onClickUp(function(self,event,button,x,y) basalt.debug("Byeeeee UwU") end):show()
````
**parameters:** function func<br>
**returns:** self<br>

## onMouseDrag
creates a mouse_drag event
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aButton = mainFrame:addButton("myFirstButton"):setSize(10,3):onClickUp(function(self,event,button,x,y) basalt.debug("Byeeeee UwU") end):show()
````
**parameters:** function func<br>
**returns:** self<br>

## onChange
creates a change event (fires as soon as the value gets changed)
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aCheckbox = mainFrame:addCheckbox("myFirstCheckbox"):onChange(function(self) basalt.debug("i got changed into "..self:getValue()) end):show()
````
**parameters:** function func<br>
**returns:** self<br>

## onKey
creates a key(board) - event can be key or char
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):onKey(function(self,event,key) basalt.debug("you clicked "..key) end):show()
````
**parameters:** function func<br>
**returns:** self<br>

## onLoseFocus
creates a lose focus event
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):onLoseFocus(function(self) basalt.debug("please come back..") end):show()
````
**parameters:** function func<br>
**returns:** self<br>

## onGetFocus
creates a get focus event
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):onGetFocus(function(self) basalt.debug("thanks!") end):show()
````
**parameters:** function func<br>
**returns:** self<br>