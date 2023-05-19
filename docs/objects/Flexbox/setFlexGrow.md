## setFlexGrow

### Description

The `setFlexGrow` method sets the grow factor of a child object within the Flexbox container. This determines how much of the remaining space along the main axis the child should take up, in relation to the other children. A larger grow factor means the child will take up more of the remaining space.

### Parameters

1. `number` The grow factor for the child object. This should be a non-negative number. A value of 0 means the child will not grow beyond its initial size. Default is 0.

### Returns

1. `object` The object in use

### Usage

* Creates a default Flexbox, adds some objects to it, and sets the flexGrow for the first object.

```lua
local main = basalt.createFrame()
local flexbox = mainFrame:addFlexbox()
local object1 = flexbox:addButton()
object1:setFlexGrow(1) -- this object will grow to take up remaining space
local object2 = flexbox:addButton() -- this object will not grow
```
