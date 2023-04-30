## getShadow

### Description

Returns the current shadow color of the object.

### Returns

1. `number|boolean` Shadow color or false if no shadow is set

### Usage

* Prints the shadow color of a frame to the debug console

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local subFrame = mainFrame:addMovableFrame()
        :setSize(18,6)
        :setShadow(colors.green)

basalt.debug(subFrame:getShadow()) -- returns colors.green or false if no shadow is set
```
