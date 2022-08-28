## basalt.removeFrame
Removes the base frame by it's id. This only works for base-frames.

#### Parameters: 
1. `string` id

#### Usage:
* Removes the previously created frame with id "myFirstFrame" 
```lua
local main = basalt.createFrame("firstBaseFrame")
local main2 = basalt.createFrame("secondBaseFrame")
main:addButton()
    :setText("Remove")
    :onClick(function()
        basalt.removeFrame(main2:getName()) -- you can use main2:getName() to find out the id or just use "secondBaseFrame"
    end)
```