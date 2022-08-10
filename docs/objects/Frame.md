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
* Create a new main frame and adds a child frame to it
```lua
local mainFrame = basalt.createFrame()
local myFrame = mainFrame:addFrame()
```
```xml
<frame></frame>
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
local mainFrame = basalt.createFrame()
local myFrame = MainFrame:addFrame()
myFrame:setBar("My first Frame!")
```
* This abuses the call-chaining that Basalt uses.
```lua
local mainFrame = basalt.createFrame()
local myFrame = mainFrame:addFrame():setBar("My first Frame!")
```
```xml
<frame barText="My first Frame!" barBG="black" barFG="lightGray"></frame>
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
myFrame:setBar("My first Frame!"):setBarTextAlign("right")
```
```xml
<frame barAlign="right"></frame>
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
myFrame:setBar("Hello World!"):showBar()
```
```xml
<frame bar="true"></frame>
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
local mainFrame = basalt.createFrame()
local monitorFrame = basalt.createFrame():setMonitor("right")
monitorFrame:setBar("Monitor 1"):showBar()
```
```xml
<frame monitor="right"></frame>
```

## setMirror
mirrors this frame to another peripheral monitor object.

#### Parameters: 
1. `string` The monitor name ("right", "left",... "monitor_1", "monitor_2",...)

#### Returns:
1. `frame` The frame being used

#### Usage:
* Creates mirror of your main frame to a monitor on the left side.
```lua
local mainFrame = basalt.createFrame():setMirror("left")
```
```xml
<frame mirror="left"></frame>
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
* Creates a new button, sets the focused object to the previously mentioned button
```lua
local aButton = myFrame:addButton()
myFrame:setFocusedObject(aButton)
```

## removeFocusedObject 
Removes the focus of the supplied object

#### Parameters: 
1. `object` The child object to remove focus from

#### Returns: 
1. `frame` The frame being used

#### Usage:
* Creates a new button then removes the focus from that button when clicking on it
```lua
local aButton = myFrame:addButton():setFocus():onClick(function() 
    myFrame:removeFocusedObject(aButton)
end)
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
local myFrame = basalt.createFrame():setMovable(true)
```
```xml
<frame moveable="true"></frame>
```

## setOffset
Sets the frame's coordinate offset. The frame's child objects will receive the frame's coordinate offset. For example, when using a scrollbar, if you use its value to add an offset to a frame, you will get a scrollable frame.
Objects are also able to ignore the offset by using :ignoreOffset() (For example, you may want to ignore the offset on the scrollbar itself)

The function can also be supplied with negative values

#### Parameters: 
1. `number` The x direction offset (+/-)
2. `number` The y direction offset (+/-)

#### Returns:
1. `frame` The frame being used

#### Usage:
* Creates a new base frame with x offset of 5 and a y offset of 3
```lua
local myFrame = basalt.createFrame():setOffset(5, 3)
```
* Creates with x offset of 5 and a y offset of -5 (Meaning if you added a button with y position 5, it would be at y position 0)
```lua
local myFrame = basalt.createFrame():setOffset(5, -5)
```
```xml
<frame xOffset="5" yOffset="-5"></frame>
```

## addLayout
Adds a new XML Layout into your frame.

#### Parameters: 
1. `string` Path to your layout

#### Returns:
1. `frame` The frame being used

#### Usage:
* Creates a new base frame and adds the mainframe.xml layout
```lua
local myFrame = basalt.createFrame():addLayout("mainframe.xml")
```
```xml
<frame layout="mainframe.xml"></frame>
```

## addLayoutFromString
Adds a new XML Layout as string into your frame.

#### Parameters: 
1. `string` xml

#### Returns:
1. `frame` The frame being used

#### Usage:
* Creates a new base frame and adds the mainframe.xml layout
```lua
local myFrame = basalt.createFrame():addLayoutFromString("<button x='12' y='5' bg='black' />")
```

## getLastLayout
returns a table of all objects this frame has created via xml (useful if you'd like to access all of them for some reason)

#### Returns:
1. `table` table with objects 

## setTheme
Sets the default theme of that frame children objects always try to get the theme of its parent frame, if it does not exist it goes to its parent parent frame, and so on until it reaches the basalt managers theme - which is sotred in theme.lua (Please checkout [theme](https://github.com/Pyroxenium/Basalt/blob/master/Basalt/theme.lua) for how it could look like.

#### Parameters: 
1. `table` theme layout look into [theme](https://github.com/Pyroxenium/Basalt/blob/master/Basalt/theme.lua) for a example

#### Returns:
1. `frame` The frame being used

#### Usage:
* Creates a new base frame and adds a new theme which only changes the default color of buttons.
```lua
local myFrame = basalt.createFrame():setTheme({
    ButtonBG = colors.yellow,
    ButtonText = colors.red,
})
```

## setScrollable
Makes the frame scrollable with mousewheel.

#### Parameters: 
1. `bool` scrollable or not

#### Returns:
1. `frame` The frame being used

#### Usage:
* Creates a new base frame and makes it scrollable
```lua
local myFrame = basalt.createFrame():setScrollable()
```
```xml
<frame scrollable="true"></frame>
```

## setMinScroll
Sets the minimum offset it is allowed to scroll (default 0)

#### Parameters: 
1. `number` minimum y offset

#### Returns:
1. `frame` The frame being used

#### Usage:
* Creates a new base frame and makes it scrollable and sets the minimum amount to -5
```lua
local myFrame = basalt.createFrame():setScrollable():setMinScroll(-5)
```
```xml
<frame minScroll="-5"></frame>
```

## setMaxScroll
Sets the maximum offset it is allowed to scroll (default 10)

#### Parameters: 
1. `number` maximum y offset

#### Returns:
1. `frame` The frame being used

#### Usage:
* Creates a new base frame and makes it scrollable and sets the maximum amount to 25
```lua
local myFrame = basalt.createFrame():setScrollable():setMaxScroll(25)
```
```xml
<frame maxScroll="25"></frame>
```

## setImportantScroll
By default if you hovering your mouse over children objects, you wont scroll the frame, if you set this to true the frame scrolling becomes more important

#### Parameters: 
1. `bool` important or not

#### Returns:
1. `frame` The frame being used

#### Usage:
* Creates a new base frame and makes it scrollable and defines it as important
```lua
local myFrame = basalt.createFrame():setScrollable():setImportantScroll(true)
```
```xml
<frame importantScroll="true"></frame>
```

# XML Example

*This is how you would implement frames via xml:
```xml
<frame>
    <frame width="parent.w * 0.5" bg="red">
        <button x="2" y="2" width="17" text="Example Button!"/>
    </frame>
    <frame x="parent.w * 0.5 + 1" width="parent.w * 0.5 +1" bg="black">
        <textfield bg="green" x="2" width="parent.w-2" />
    </frame>
</frame>
```
