## getBackground

### Description

Returns the current background color

### Returns

1. `number|false` color (returns false if the background is transparent)

### Usage

* Retrieves the background color of an object and prints it to the debug console:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame():setBackground(colors.gray)
local bgColor = mainFrame:getBackground()
basalt.debug(bgColor) -- prints colors.gray
```
