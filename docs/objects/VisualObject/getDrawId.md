## getDrawId

### Description

Returns the ID of a custom drawing function.

### Parameters

1. `string` Name (ID) of the drawing function

### Returns

1. `number` Index of the drawing function in the corresponding queue (drawQueue, preDrawQueue, or postDrawQueue)

### Usage

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()

local function customDrawing()
  -- Custom drawing code goes here
end

mainFrame:addDraw("uniqueID", customDrawing, 1, true)
local drawIndex = mainFrame:getDrawId("uniqueID")

basalt.debug("Custom drawing index: " .. drawIndex)
```

In this example, a custom drawing function is added to the main frame's drawQueue. The `getDrawId` function is then used to retrieve the index of the drawing function in the corresponding queue. The index is then printed to the debug console.
