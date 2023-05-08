## animateOffset

### Description

Animates the offset of an object within a specified time frame.

### Parameters

1. `number` x-offset
2. `number` y-offset
3. `number` Duration of the animation in seconds
4. `number` Optional - offset in seconds
5. `string` Optional - Animation mode
6. `function` Optional - callback function, called when the animation is completed

### Returns

1. `object` The object in use

### Usage

* Animates the offset of a frame to an x-offset of 3 and a y-offset of 4 within 2 seconds:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local aFrame = mainFrame:addFrame():setPosition(2, 3)

aFrame:animateOffset(3, 4, 2, 0, "linear", function()
  basalt.debug("Animation completed!")
end)
```
