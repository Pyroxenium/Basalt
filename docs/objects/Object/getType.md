## getType

### Description

Returns the type of the object

This method is used to get the type of the object, such as 'Button', 'Label', 'List', etc.

### Returns

1. `object` The type of the object

### Usage

* Creates a default button and prints its type.

```lua
local mainFrame = basalt.createFrame()
local aButton = mainFrame:addButton():setText("My Button")
basalt.debug(aButton:getType())
```
