## removeFocusedObject 
Removes the focus of the supplied object

#### Parameters: 
1. `object` The child object to remove focus from

#### Returns: 
1. `frame` The frame being used

#### Usage:
* Creates a new button then removes the focus from that button when clicking on it
```lua
local aButton = myFrame:addButton():setFocus():onClick(function() 
    myFrame:removeFocusedObject(aButton)
end)
```