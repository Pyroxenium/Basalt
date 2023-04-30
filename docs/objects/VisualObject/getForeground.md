## getForeground

### Description

Returns the current foreground color

### Returns

1. `number|color` color

### Usage

* Retrieves the foreground color of an object and prints it to the debug console:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame():setForeground(colors.red)
local fgColor = mainFrame:getForeground()
basalt.debug(fgColor) -- prints colors.red
```
