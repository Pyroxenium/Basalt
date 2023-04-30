## getX

### Description

Returns the object's x-coordinate.

### Returns

1. `number` x position

### Usage

* Prints the x-coordinate of a button to the debug console

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local aButton = mainFrame:addButton():setPosition(5, 8)
local x = aButton:getX()
basalt.debug("Button x-coordinate: " .. x) -- prints "Button x-coordinate: 5"
```
