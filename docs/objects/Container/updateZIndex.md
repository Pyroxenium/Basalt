## updateZIndex

### Description

Updates the z-index of a specified object within the container. This is useful when you need to change the z-index of an object after it has been added to the container.

### Parameters

1. `object` The object whose z-index you want to update.
2. `number` The new z-index value for the object.

### Returns

1. `object` The object in use

### Usage

```lua
local frame = basalt.createFrame()
local button1 = frame:addButton():setZIndex(1)
local button2 = frame:addButton():setZIndex(2)

-- Update button1's z-index to be above button2
frame:updateZIndex(button1, 3)
```
