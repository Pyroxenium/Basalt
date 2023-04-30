## animateSize

### Description

Animates the size of an object within a specified time frame.

### Parameters

1. `number` Width
2. `number` Height
3. `number` Duration of the animation in seconds
4. `number` Optional - offset in seconds
5. `string` Optional - Animation mode
6. `function` Optional - callback function, called when the animation is completed

### Returns

1. `object` The object in use

### Usage

* Animates the size of a button to a width of 10 and a height of 5 within 2 seconds

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local aButton = mainFrame:addButton():setSize(5, 3)

aButton:animateSize(10, 5, 2, 0, "linear", function()
  basalt.debug("Animation completed!")
end)
```
