## addPostDraw

### Description

Adds a custom drawing function to the object's postDrawQueue. Functions in the postDrawQueue are executed after the main drawing functions. This allows users to create custom graphical representations that will be drawn in front of the main elements.

### Parameters

1. `string` Name (ID) - must be unique
2. `function` The function to be executed, containing the custom drawing code
3. `number` Optional - Position, determines the order or priority of the drawing
4. `boolean` Optional - Whether the drawing should be rendered immediately or not, default is `true`

### Returns

1. `object` The object in use

### Usage

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()

local function customPostDrawing()
  -- Custom drawing code goes here
end

mainFrame:addPreDraw("uniqueID", customPostDrawing)
```

In this example, a custom drawing function is added to the main frame's postDrawQueue. The custom drawing code should be placed inside the `customPostDrawing` function. The drawing is given a unique ID, a position of 1, and rendered immediately.
