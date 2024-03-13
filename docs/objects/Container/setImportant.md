## setImportant

### Description

Sets the specified object as "important" within the container. This means the object will be reordered on the same z-index level, making it more important than other objects on the same level. This can be useful when you want to prioritize event handling or drawing order for specific objects.

### Parameters

1. `string|object` The object ID or object to set as important

### Returns

1. `object` the object in use

### Usage

```lua
local main = basalt.createFrame()
local container = main:addFrame()
local inputField1 = container:addInput()
    :setPosition(2, 2)
local inputField2 = container:addInput()
    :setPosition(2, 4)

inputField1:onKey(function(event, key)
    basalt.debug("InputField1 received key press: ", key)
end)

inputField2:onKey(function(event, key)
    basalt.debug("InputField2 received key press: ", key)
end)

container:setImportant(inputField1)

basalt.autoUpdate()
```
