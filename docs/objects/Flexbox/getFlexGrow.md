## getFlexGrow

### Description

The `getFlexGrow` method retrieves the grow factor of a child object within the Flexbox container. This value determines how much of the remaining space along the main axis the child should take up, in relation to the other children.

### Returns

1. `number` The grow factor of the child object.

### Usage

* Creates a default Flexbox, adds some objects to it, sets the flexGrow for the first object, and then retrieves this value.

```lua
local main = basalt.createFrame()
local flexbox = mainFrame:addFlexbox()
local object1 = flexbox:addButton()
object1:setFlexGrow(1) -- this object will grow to take up remaining space
basalt.debug(object1:getFlexGrow()) -- prints 1
```
