## getParent

### Description

Returns the parent of the object

This method is used to get the parent of the object, which is the object that contains it.

### Returns

1. `object` The parent object, or nil if the object has no parent

### Usage

* Creates a default frame with a button and gets the parent of the button.

```lua
local mainFrame = basalt.createFrame()
local aButton = mainFrame:addButton():setText("My Button")
local parent = aButton:getParent()
basalt.debug(parent) -- The parent object (mainFrame) will be output
```
