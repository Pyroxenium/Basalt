## isType

### Description

Checks if the object is of a specific type or inherits from a specific parent class

This method is used to check if the object is of a specific type or inherits from a specific parent class, such as 'Button', 'Label', 'List', etc.

### Parameters

1. `object` The type name you want to check

### Returns

1. `boolean` Returns true if the object is of the specified type or inherits from it, otherwise false

### Usage

* Creates a default button and checks if it is of type 'Button'.

```lua
local mainFrame = basalt.createFrame()
local aButton = mainFrame:addButton():setText("My Button")
basalt.debug(aButton:isType('Button'))
```
