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