## removeChild

### Description

Removes an object from the container by its ID. If the object is not a direct child of the container, this method will not remove it.

### Parameters

1. `string` id - The ID of the object you want to retrieve.

### Returns

1. `boolean` true if the object was removed

### Usage

```lua
local main = basalt.createFrame()
local container = main:addFrame("container")
local button = container:addButton("removableButton")
    :setPosition(2, 2)
    :setText("Remove me")

main:addButton()
    :setPosition(2, 4)
    :setText("Remove the button above")
    :onClick(function()
        local removed = container:removeChild("removableButton")
        if removed then
            basalt.debug("Button removed!")
        else
            basalt.debug("Button not found!")
        end
    end)

basalt.autoUpdate()
```
