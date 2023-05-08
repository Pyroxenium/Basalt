## setFocusedObject

### Description

Sets the focused object within the container. When an object is focused, it will receive keyboard events. Only one object can be focused at a time within a container.

### Parameters

1. `object` object - The object to set as the focused object.

### Returns

1. `object` The object in use

### Usage

```lua
local main = basalt.createFrame()
local container = main:addFrame()
local inputField1 = container:addInput("inputField1")
    :setPosition(2, 2)
local inputField2 = container:addInput("inputField2")
    :setPosition(2, 4)

main:addButton()
    :setPosition(2, 6)
    :setText("Focus on inputField1")
    :onClick(function()
        local focused = container:setFocusedObject(inputField1)
        if focused then
            basalt.debug("InputField1 is now focused!")
        else
            basalt.debug("Failed to set focus on InputField1!")
        end
    end)

basalt.autoUpdate()
```
