## getSize

### Description

Returns the object's size

### Returns

1. `number` width
2. `number` height

### Usage

* Prints the width and height of a button to the debug console

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local aButton = mainFrame:addButton():setSize(10, 3)
local w, h = aButton:getSize()
basalt.debug("Button position: w=" .. w .. ", h=" .. h) -- prints "Button position: w=10, h=3"
```
