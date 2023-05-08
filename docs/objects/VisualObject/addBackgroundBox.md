## addBackgroundBox

### Description

Adds a custom background box to the object within the draw function. The box is displayed at the specified coordinates relative to the object and has the specified width and height.

### Parameters

1. `number` x-coordinate
2. `number` y-coordinate
3. `number` width
4. `number` height
5. `number|color` The background color

### Returns

1. `object` The object in use

### Usage

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()

local function drawCustomBackgroundBox(self)
  self:addBackgroundBox(1, 1, 10, 5, colors.red)
end

mainFrame:addDraw("customBackgroundBox", drawCustomBackgroundBox)
```

In this example, a custom draw function named `drawCustomBackgroundBox` is created. Within the function, `addBackgroundBox` is used to add a background box with a colors.red background color at the position (1, 1) relative to the object, with a width of 10 and a height of 5. The `addDraw` function is then used to add the custom draw function to the main frame.
