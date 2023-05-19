## getFlexShrink

### Description

The `getFlexShrink` method retrieves the current shrink factor of a child object within the Flexbox container. This value represents how much the object would shrink compared to other objects in the container, in case there isn't enough space.

### Returns

1. `number` The current shrink factor of the object.

### Usage

* Creates a default Flexbox, adds some objects to it, sets the flexShrink for the first object, and retrieves it.

```lua
local main = basalt.createFrame()
local flexbox = mainFrame:addFlexbox()
local object1 = flexbox:addButton()
object1:setFlexShrink(2) -- this object will shrink twice as much as the others if necessary
basalt.debug(object1:getFlexShrink()) -- prints: 2
```
