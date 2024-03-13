## getOffset

### Description

Retrieves the current offset within a Textfield object, providing information about the current viewable portion of the text.

### Returns

1. `number` The current horizontal offset within the Textfield.
2. `number` The current vertical offset within the Textfield.

### Usage

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local aTextfield = mainFrame:addTextfield()

-- Assume the Textfield has been scrolled previously
local xOffset, yOffset = aTextfield:getOffset()
basalt.debug("Horizontal Offset: "..xOffset)
basalt.debug("Vertical Offset: "..yOffset)

basalt.autoUpdate()
```
