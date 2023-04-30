## addTextBox

### Description

Adds a custom text box to the object within the draw function. The text box is displayed at the specified coordinates relative to the object and has the specified width and height.

### Parameters

1. `number` x-coordinate
2. `number` y-coordinate
3. `number` width
4. `number` height
5. `string` The text to be displayed in the box

### Returns

1. `object` The object in use

### Usage

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()

local function drawCustomTextBox(self)
  self:addTextBox(1, 1, 10, 5, "#")
end

mainFrame:addDraw("customTextBox", drawCustomTextBox)
```

In this example, a custom draw function named `drawCustomTextBox` is created. Within the function, `addTextBox` is used to add a text box with the text "#" at the position (1, 1) relative to the object, with a width of 10 and a height of 5. The `addDraw` function is then used to add the custom draw function to the main frame.
