## getChild

### Description

Retrieves an object from the container by its ID.

### Parameters

1. `string` id - The ID of the object you want to retrieve.

### Returns

1. `object` The object with the specified ID, or nil if no object with that ID is found.

### Usage

```lua
local main = basalt.createFrame()
local button = main:addButton("myButton")
    :setPosition(2, 2)
    :setText("My Button")

-- Get the button object by its ID
local retrievedButton = main:getChild("myButton")
if retrievedButton then
    basalt.debug("Button found!")
end

basalt.autoUpdate()
```
