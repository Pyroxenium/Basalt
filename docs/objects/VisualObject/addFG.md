## addFG

### Description

Adds a custom foreground to the object within the draw function. The foreground is displayed at the specified coordinates relative to the object.

### Parameters

1. `number` x-coordinate
2. `number` y-coordinate
3. `string` The foreground color as string

### Returns

1. `object` The object in use

### Usage

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()

local function drawCustomForeground(self)
  self:addFG(1, 1, "777777")
end

mainFrame:addDraw("customForeground", drawCustomForeground)
```

In this example, a custom draw function named `drawCustomForeground` is created. Within the function, `addFG` is used to add a foreground at the position (1, 1) relative to the object. The `addDraw` function is then used to add the custom draw function to the main frame.
