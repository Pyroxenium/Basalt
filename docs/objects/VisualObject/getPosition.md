## getPosition

### Description

Returns the object's position

### Returns

1. `number` x position
2. `number` y position

### Usage

* Prints the x and y coordinates of a button to the debug console

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local aButton = mainFrame:addButton():setPosition(5, 8)
local x, y = aButton:getPosition()
basalt.debug("Button position: x=" .. x .. ", y=" .. y) -- prints "Button position: x=5, y=8"
```
