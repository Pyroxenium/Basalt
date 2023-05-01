# Basalt

## removeFrame

Removes the base frame by it's id. **This only works for base-frames.**

### Parameters

1. `string` id - ID of the base-frame.

### Usage

* Removes the previously created frame with id "secondBaseFrame"
The frame id is gotten from a frame variable's `:getName()`

```lua
local main = basalt.createFrame("firstBaseFrame")
local main2 = basalt.createFrame("secondBaseFrame")
main:addButton()
    :setText("Remove")
    :onClick(function()
        basalt.removeFrame(main2:getName())
    end)
```

* Removes the previously created frame with id "secondBaseFrame", without frame stored in variable
The frame id is the frame's name

```lua
local main = basalt.createFrame("firstBaseFrame")
local main2 = basalt.createFrame("secondBaseFrame")
main:addButton()
    :setText("Remove")
    :onClick(function()
        basalt.removeFrame("secondBaseFrame")
    end)
```
