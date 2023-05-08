## animatePosition

### Description

Animates the position of an object within a specified time frame.

### Parameters

1. `number` x-coordinate
2. `number` y-coordinate
3. `number` Duration of the animation in seconds
4. `number` Optional - offset in seconds
5. `string` Optional - Animation mode
6. `function` Optional - callback function, called when the animation is completed

### Returns

1. `object` The object in use

### Usage

* Animates the position of a button within 2 seconds to the coordinates (5, 5):

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local aButton = mainFrame:addButton():setPosition(2, 3)

aButton:animatePosition(5, 5, 2, 0, "linear", function()
  basalt.debug("Animation completed!")
end)
```
