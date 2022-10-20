# Object - Event

## onGetFocus

`onGetFocus(self)`

This event gets triggered as soon as the object is the currently focused object.

```lua
local basalt = require("basalt")

local main = basalt.createFrame()
local aButton = main:addButton()
    :setPosition(3,3)
    :onGetFocus(
        function(self) 
            basalt.debug("Welcome back!") 
        end
    )
```
