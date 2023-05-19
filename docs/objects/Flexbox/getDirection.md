## getDirection

### Description

Returns the current direction in which the child objects are arranged within the Flexbox.

### Returns

1. `string` The direction in which the child objects are arranged. Possible values are: row, column.

### Usage

* Creates a default Flexbox, sets the direction, and then retrieves it.

```lua
local main = basalt.createFrame()
local flexbox = mainFrame:addFlexbox()
      :setDirection("column")
local direction = flexbox:getDirection() -- returns "column"
```
