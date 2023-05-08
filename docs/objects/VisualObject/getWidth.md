## getWidth

### Description

Returns the object's width.

### Returns

1. `number` width

### Usage

* Prints the width of a button to the debug console

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local aButton = mainFrame:addButton():setSize(10, 3)
local w = aButton:getWidth()
basalt.debug("Button width: " .. w) -- prints "Button width: 10"
```
