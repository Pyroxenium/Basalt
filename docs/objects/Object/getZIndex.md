## getZIndex

### Description

Returns the Z-index of the object

The Z-index determines the order of overlapping objects. Objects with higher Z-index values will be displayed above objects with lower Z-index values.

### Returns

1. `object` The current Z-index value

### Usage

* Creates a default button and gets its Z-index value.

```lua
local mainFrame = basalt.createFrame()
local aButton = mainFrame:addButton():setText("My Button")
local zIndex = aButton:getZIndex()
basalt.debug(zIndex) -- Prints the Z-index value
```
