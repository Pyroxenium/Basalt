## setFocusedObject 
Sets the currently focused object

#### Parameters: 
1. `object` The child object to focus on

#### Returns: 
1. `frame` The frame being used

#### Usage:
* Creates a new button, sets the focused object to the previously mentioned button
```lua
local aButton = myFrame:addButton()
myFrame:setFocusedObject(aButton)
```