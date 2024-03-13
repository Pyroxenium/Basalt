## setOffset

### Description

Sets the offset within a Textfield object, allowing you to adjust the viewable portion of the text.

### Parameteres

1. `number` xOffset - The horizontal offset to set within the Textfield
2. `number` yOffset - The vertical offset to set within the Textfield

### Returns

1. `object` The object in use

### Usage

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local aTextfield = mainFrame:addTextfield()

-- Scroll 10 units down vertically
aTextfield:setOffset(0, 10)

basalt.autoUpdate()
```
