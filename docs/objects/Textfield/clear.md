## clear

### Description

Clears the entire content of a Textfield object, removing all text currently displayed within it.

### Returns

1. `object ` The object in use

### Usage

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local aTextfield = mainFrame:addTextfield()

-- Assume there is some content in the Textfield
aTextfield:clear() -- Clear the entire content

basalt.autoUpdate()
```
