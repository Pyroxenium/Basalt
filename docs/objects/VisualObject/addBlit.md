## addBlit

### Description

Adds custom text, background, and foreground to the object within the draw function. The text, background, and foreground are displayed at the specified coordinates relative to the object.

### Parameters

1. `number` x-coordinate
2. `number` y-coordinate
3. `string` The text to display
4. `string` The foreground color
5. `string` The background color

### Returns

1. `object` The object in use

### Usage

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()

local function drawCustomBlit(self)
  self:addBlit(1, 1, "Hello", "22222", "66666")
end

mainFrame:addDraw("customBlit", drawCustomBlit)
```

In this example, a custom draw function named `drawCustomBlit` is created. Within the function, `addBlit` is used to add text "Hello", a background color, and a foreground color at the position (1, 1) relative to the object. The `addDraw` function is then used to add the custom draw function to the main frame.
