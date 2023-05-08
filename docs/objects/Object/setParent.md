## setParent

### Description

Sets the parent of the object

This method is used to change the parent of the object, assigning it to a new containing object.

### Parameters

1. `object` The new parent object

### Returns

1. `object` The object in use

### Usage

* Creates two frames and a button, then sets the parent of the button to the second frame

```lua
local mainFrame = basalt.createFrame()
local secondFrame = basalt.createFrame()
local aButton = mainFrame:addButton():setText("My Button")
aButton:setParent(secondFrame) -- Sets the parent of aButton to secondFrame
```
