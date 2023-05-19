## setFlexBasis

### Description

The `setFlexBasis` method sets the initial main size of a child object within the Flexbox container. This value represents the starting point for further calculations. If the Flexbox has a direction of 'row', the flex basis is akin to the width. For 'column', it's akin to height.

### Parameters

1. `number` Flex basis. Currently only numbers available.

### Returns

1. `object` The object in use

### Usage

* Creates a default Flexbox, adds some objects to it, and sets the flex basis for the first object.

```lua
local main = basalt.createFrame()
local flexbox = mainFrame:addFlexbox()
local object1 = flexbox:addButton()
object1:setFlexBasis(10) -- this object will have an initial size of 10 pixels along the main axis
```
