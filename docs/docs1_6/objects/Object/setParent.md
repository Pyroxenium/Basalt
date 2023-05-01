# Object

## setParent

Sets the parent frame of the object

### Parameters

1. `frame` The to-be parent frame

### Returns

1. `object` The object in use

### Usage

* Sets the parent frame of the random frame, adding it to the main frame when the button is clicked"

```lua
local mainFrame = basalt.createFrame()
local aRandomFrame = basalt.createFrame()
local aButton = mainFrame:addButton():onClick(
        function() 
            aRandomFrame:setParent(mainFrame) 
        end
)
```
