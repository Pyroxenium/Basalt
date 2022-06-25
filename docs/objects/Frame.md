<a href="https://i.imgur.com/aikc0K1.png"><img src="https://i.imgur.com/aikc0K1.png" height="500" /></a>

Frames are like containers, but are also normal objects. 
In other words, you can add other objects _(even frames)_ to a frame; if the frame itself is visible
all sub-objects _(if they are set as visible)_ are also visible. A better description will follow.

## basalt.createFrame
Creates a new non-parent frame - in most cases it is the first thing you'll need.

#### Parameters:
1. `string` name (should be unique)

#### Returns:
1. `frame | nil` The frame created by createFrame, or `nil` if there is already a frame with the given name.

#### Usage:
* Create a frame with an id "myFirstFrame", stored in a variable named frame
```lua
local myFrame = basalt.createFrame("myFirstFrame")
```

## addFrame
Creates a child frame on the frame, the same as [basalt.createFrame](https://github.com/Pyroxenium/Basalt/wiki/Frame#basaltcreateframe) except the frames are given a parent-child relationship automatically

#### Parameters:
1. `string` name (should be unique)

#### Returns:
1. `frame | nil` The frame created by addFrame, or `nil` if there is already a child frame with the given name.<br>

#### Usage:
* Create a frame with id "myFirstFrame" then create a child of that frame, named "myFirstSubFrame"
```lua
local mainFrame = basalt.createFrame("myFirstFrame")
local myFrame = mainFrame:addFrame("myFirstSubFrame")
```

## setBar
Sets the text, background, and foreground of the upper bar of the frame, accordingly.

#### Parameters:
1. `string` The title text to set the bar to
2. `number` The background color
2. `number` The foreground color

#### Returns:
1. `frame` The frame being used

#### Usage:
* Set the title to "My first frame!", with a background of black and a foreground of light gray.
```lua
frame:setBar("My first Frame!", colors.black, colors.lightGray)
```
* Store the frame, use the named frame variable after assigning.
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local myFrame = MainFrame:addFrame("myFirstSubFrame")
myFrame:setBar("My first Frame!")
myFrame:show()
```
* This abuses the call-chaining that Basalt uses.
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local myFrame = mainFrame:addFrame("myFirstSubFrame"):setBar("My first Frame!"):show()
```

## setBarTextAlign
Sets the frame's bar-text alignment

#### Parameters: 
1. `string` Can be supplied with "left", "center", or "right"

#### Returns: 
1. `frame` The frame being used

#### Usage:
* Set the title of myFrame to "My first frame!", and align it to the right.
```lua
local mainFrame = myFrame:setBar("My first Frame!"):setBarTextAlign("right")
```

## showBar
Toggles the frame's upper bar

#### Parameters: 
1. `boolean | nil` Whether the frame's bar is visible or if supplied `nil`, is automatically visible

#### Returns:
1. `frame` The frame being used

#### Usage:
* Sets myFrame to have a bar titled "Hello World!" and subsequently displays it.
```lua
local mainFrame = myFrame:setBar("Hello World!"):showBar()
```

## setMonitor
Sets this frame as a monitor frame

#### Parameters: 
1. `string` The monitor name ("right", "left",... "monitor_1", "monitor_2",...)

#### Returns:
1. `frame` The frame being used

#### Usage:
* Creates a new monitor frame, you can use to show objects on a monitor.
```lua
local mainFrame = basalt.createFrame("mainFrame"):show()
local monitorFrame = basalt.createFrame("mainFrame"):setMonitor("right"):show()
monitorFrame:setBar("Monitor 1"):showBar()
```
## getObject 
Returns a child object of the frame

#### Parameters: 
1. `string` The name of the child object

#### Returns: 
1. `object | nil` The object with the supplied name, or `nil` if there is no object present with the given name 

#### Usage:
* Adds a button with id "myFirstButton", then retrieves it again through the frame object
```lua
myFrame:addButton("myFirstButton")
local aButton = myFrame:getObject("myFirstButton")
```

## removeObject 
Removes a child object from the frame

#### Parameters:
1. `string` The name of the child object

#### Returns: 
1. `boolean` Whether the object with the given name was properly removed

#### Usage:
* Adds a button with the id "myFirstButton", then removes it with the aforementioned id
```lua
myFrame:addButton("myFirstButton")
myFrame:removeObject("myFirstButton")
```

## setFocusedObject 
Sets the currently focused object

#### Parameters: 
1. `object` The child object to focus on

#### Returns: 
1. `frame` The frame being used

#### Usage:
* Creates button with id "myFirstButton", sets the focused object to the previously mentioned button
```lua
local aButton = myFrame:addButton("myFirstButton")
myFrame:setFocusedObject(aButton)
```
## removeFocusedObject 
Removes the focus of the supplied object

#### Parameters: 
1. `object` The child object to remove focus from

#### Returns: 
1. `frame` The frame being used

#### Usage:
* Creates a button with id "myFirstButton", then removes the focus from that button
```lua
local aButton = myFrame:addButton("myFirstButton")
myFrame:removeFocusedObject(aButton)
```

## getFocusedObject
Gets the currently focused object
#### Returns: 
1. `object` The currently focused object

#### Usage:
* Gets the currently focused object from the frame, storing it in a variable
```lua
local focusedObject = myFrame:getFocusedObject()
```
## setMovable

Sets whether the frame can be moved. _In order to move the frame click and drag the upper bar of the frame_
#### Parameters: 
1. `boolean` Whether the object is movable

#### Returns:
1. `frame` The frame being used

#### Usage:
* Creates a frame with id "myFirstFrame" and makes it movable
```lua
local myFrame = basalt.createFrame("myFirstFrame"):setMovable(true)
```

## setOffset
Sets the frame's coordinate offset. The frame's child objects will receive the frame's coordinate offset. For example, when using a scrollbar, if you use its value to add an offset to a frame, you will get a scrollable frame.
Objects are also able to ignore the offset by using :ignoreOffset() (For example, you may want to ignore the offset on the scrollbar itself)

The function can be supplied negative offsets

#### Parameters: 
1. `number` The x direction offset (+/-)
2. `number` The y direction offset (+/-)

#### Returns:
1. `frame` The frame being used

#### Usage:
* Creates "myFirstFrame" with an x offset of 5 and a y offset of 3
```lua
local myFrame = basalt.createFrame("myFirstFrame"):setOffset(5, 3)
```
* Creates "myFirstFrame" with an x offset of 5 and a y offset of -5 (Meaning if you added a button with y position 5, it would be at y position 0)
```lua
local myFrame = basalt.createFrame("myFirstFrame"):setOffset(5, -5)
```
