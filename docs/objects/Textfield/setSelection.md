## setSelection

### Description

Changes the color when selecting text.

### Parameteres

1. `number|color` foreground color - The text color.
2. `number|color` background color - ´The background color.

### Returns

1. `object` The object in use

### Usage

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local aTextfield = mainFrame:addTextfield()

aTextfield:setSelection(colors.white, colors.blue)

basalt.autoUpdate()
```
