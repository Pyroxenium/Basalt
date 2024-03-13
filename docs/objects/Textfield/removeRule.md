## removeRule

### Description

Removes an existing rule for special coloring in a Textfield object. This allows you to remove the coloring applied to text matching a specific pattern.

### Parameteres

1. `string` pattern - The Lua pattern used to match the text for which the rule was applied.

### Returns

1. `object` The object in use

### Usage

* Removes the rule for coloring all numbers in a Textfield object

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local aTextfield = mainFrame:addTextfield()

aTextfield:removeRule("%d") -- Removes the rule for coloring numbers

basalt.autoUpdate()
```
