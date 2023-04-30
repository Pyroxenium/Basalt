## addForegroundBox

### Description

Adds a custom foreground box to the object within the draw function. The box is displayed at the specified coordinates relative to the object and has the specified width and height.

### Parameters

1. `number` x-coordinate
2. `number` y-coordinate
3. `number` width
4. `number` height
5. `number|color` The foreground color

### Returns

1. `object` The object in use

### Usage

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()

local function drawCustomForegroundBox(self)
  self:addForegroundBox(1, 1, 10, 5, colors.blue)
end

mainFrame:addDraw("customForegroundBox", drawCustomForegroundBox)
```

n this example, a custom draw function named `drawCustomForegroundBox` is created. Within the function, `addForegroundBox` is used to add a foreground box with a colors.blue foreground color at the position (1, 1) relative to the object, with a width of 10 and a height of 5. The `addDraw` function is then used to add the custom draw function to the main frame.
