## setFlexShrink

### Description

The `setFlexShrink` method sets the shrink factor of a child object within the Flexbox container. This value determines how much the child should shrink relative to the rest of the objects in the flex container, if necessary.

### Parameters

1. `number` The shrink factor of the child object. The default is 0. A higher value will cause the object to shrink more.

### Returns

1. `object` The object in use

### Usage

* Creates a default Flexbox, adds some objects to it, and sets the flexShrink for the first object.

```lua
local main = basalt.createFrame()
local flexbox = mainFrame:addFlexbox()
local object1 = flexbox:addButton()
object1:setFlexShrink(2) -- this object will shrink twice as much as the others if necessary
```
