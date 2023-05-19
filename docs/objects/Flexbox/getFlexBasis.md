## getFlexBasis

### Description

The `getFlexBasis` method retrieves the initial main size of a child object within the Flexbox container. This value represents the starting point for further calculations. If the Flexbox has a direction of 'row', the flex basis is akin to the width. For 'column', it's akin to height.

### Returns

1. `number` The current flex basis of the object

### Usage

* Creates a default Flexbox, adds some objects to it, sets the flex basis for the first object, and retrieves it.

```lua
local main = basalt.createFrame()
local flexbox = mainFrame:addFlexbox()
local object1 = flexbox:addButton()
object1:setFlexBasis(10) -- this object will have an initial size of 50 pixels along the main axis
basalt.debug(object1:getFlexBasis()) -- prints: 50
```
