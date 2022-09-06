## removeFocusedObject 
Removes the currently focused object of that frame

#### Returns: 
1. `frame` The frame being used

#### Usage:
* Creates a new button then removes the focus from that button when clicking on it
```lua
local main = basalt.createFrame()
local input = main:addInput():setFocus()
local aButton = main:addButton():onClick(function() 
    main:removeFocusedObject()
end)
```