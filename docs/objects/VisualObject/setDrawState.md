## setDrawState

### Description

Sets the state of a custom drawing function, determining whether it should be rendered or not.

### Parameters

1. `string` Name (ID) of the drawing function
2. `boolean` State - `true` for rendering the drawing, `false` to disable rendering

### Returns

1. `object` The object in use

### Usage

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()

local function customDrawing()
  -- Custom drawing code goes here
end

mainFrame:addDraw("uniqueID", customDrawing, 1, true)
mainFrame:setDrawState("uniqueID", false) -- Disables rendering of the custom drawing
```

In this example, a custom drawing function is added to the main frame's drawQueue, and its state is then set to `false`, disabling its rendering. To enable rendering, set the state to `true`.
