## addDraw

### Description

Adds a custom drawing function to the object, allowing users to create their own graphical representations using code.

### Parameters

1. `string` Name (ID) - must be unique
2. `function` The function to be executed, containing the custom drawing code
3. `number` Optional - Position, determines the order or priority of the drawing
4. `number` Optional - Determines if the drawing should be added to the preDrawQueue, postDrawQueue, or drawQueue. `1` = drawQueue, `2` = preDrawQueue, `3` = postDrawQueue (default is drawQueue)
5. `boolean` Optional - Whether the drawing should be rendered immediately or not, default is `true`

### Returns

1. `object` The object in use

### Usage

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()

local function customDrawing()
  -- Custom drawing code goes here
end

mainFrame:addDraw("uniqueID", customDrawing)
```

In this example, a custom drawing function is added to the main frame. The custom drawing code should be placed inside the `customDrawing` function. The drawing is given a unique ID, a position of 1, added to the drawQueue, and rendered immediately.
