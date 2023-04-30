## getY

### Description

Returns the object's y-coordinate.

### Returns

1. `number` y position

### Usage

* Prints the y-coordinate of a button to the debug console

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local aButton = mainFrame:addButton():setPosition(5, 8)
local y = aButton:getY()
basalt.debug("Button y-coordinate: " .. y) -- prints "Button y-coordinate: 5"
```
