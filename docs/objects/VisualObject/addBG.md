## addBG

### Description

Adds a custom background to the object within the draw function. The background is displayed at the specified coordinates relative to the object.

### Parameters

1. `number` x-coordinate
2. `number` y-coordinate
3. `string` The background color as string

### Returns

1. `object` The object in use

### Usage

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()

local function drawCustomBackground(self)
  self:addBG(1, 1, "4444444")
end

mainFrame:addDraw("customBackground", drawCustomBackground)
```

In this example, a custom draw function named `drawCustomBackground` is created. Within the function, `addBG` is used to add a background at the position (1, 1) relative to the object. The `addDraw` function is then used to add the custom draw function to the main frame.
