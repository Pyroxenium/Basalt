## addText

### Description

Adds custom text to the object within the draw function. The text is displayed at the specified coordinates relative to the object.

### Parameters

1. `number` x-coordinate
2. `number` y-coordinate
3. `string` The text to be displayed

### Returns

1. `object` The object in use

### Usage

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()

local function drawCustomText(self)
  self:addText(2, 3, "Custom Text")
end

mainFrame:addDraw("customText", drawCustomText)
```

In this example, a custom draw function named `drawCustomText` is created. Within the function, `addText` is used to add the text "Custom Text" at the position (2, 3) relative to the object. The `addDraw` function is then used to add the custom draw function to the main frame.
