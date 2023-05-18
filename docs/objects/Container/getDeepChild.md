## getDeepChild

### Description

Retrieves an object from the container or its descendants by its ID. This method searches recursively through all child containers to find the object.

### Parameters

1. `string` id - The ID of the object you want to retrieve.

### Returns

1. `object` The object with the specified ID, or nil if no object with that ID is found.

### Usage

```lua
local main = basalt.createFrame()
local container = main:addFrame("container")
local button = container:addButton("myButton")
    :setPosition(2, 2)
    :setText("My Button")
-- Get the button object by its ID, searching through all containers
local retrievedButton = main:getDeepChild("myButton")
if retrievedButton then
    basalt.debug("Button found!")
end

basalt.autoUpdate()
```
