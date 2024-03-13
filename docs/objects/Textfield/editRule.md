## addRule

### Description

Edits an existing rule for special coloring in a Textfield object. This allows you to modify the color and/or background color applied to text matching a specific pattern.

### Parameteres

1. `string` pattern - The Lua pattern used to match the text you want to edit the coloring for.
2. `number|color` textColor - The new color you want to apply to the text matching the pattern.
3. `number|color` backgroundColor - (optional) The new background color you want to apply to the text matching the pattern.

### Returns

1. `object` The object in use

### Usage

* Modifies the color of all numbers in a Textfield object.

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local aTextfield = mainFrame:addTextfield()

aTextfield:editRule("%d", colors.red) -- Changes the color of numbers to red

basalt.autoUpdate()
```
