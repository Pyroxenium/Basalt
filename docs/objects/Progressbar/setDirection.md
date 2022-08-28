## setDirection
Sets the direction in which the bar should be expanding.

#### Parameters: 
1. `number` x direction (0 = left to right, 1 = top to bottom, 2 = right to left and 3 = bottom to top)

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a progressbar and sets the direction from bottom to top
```lua
local mainFrame = basalt.createFrame()
local aProgressbar = mainFrame:addProgressbar()
aProgressbar:setDirection(3)
```
```xml
<frame direction="3"></frame>
```