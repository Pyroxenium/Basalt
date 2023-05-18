## clearFocusedChild

### Description

Clears the focus from the currently focused object within the container. If no object is focused, this method has no effect.

### Returns

1. `object` The object in use

### Usage

```lua
local main = basalt.createFrame()
local container = main:addFrame()
local inputField1 = container:addInputField()
    :setPosition(2, 2)
local inputField2 = container:addInputField()
    :setPosition(2, 4)

container:setFocusedChild(inputField1)

main:addButton()
    :setPosition(2, 6)
    :setText("Remove focus from input fields")
    :onClick(function()
        container:clearFocusedChild()
        basalt.debug("Focus removed from input fields!")
    end)

basalt.autoUpdate()
```
