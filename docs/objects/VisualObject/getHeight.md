## getHeight

### Description

Returns the object's height.

### Returns

1. `number` height

### Usage

* Prints the height of a button to the debug console

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local aButton = mainFrame:addButton():setSize(10, 3)
local h = aButton:getHeight()
basalt.debug("Button height: " .. h) -- prints "Button height: 3"
```
