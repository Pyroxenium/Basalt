# Object - Event

## onLoseFocus

`onLoseFocus(self)`

This event gets triggered as soon as the object loses its focus.

```lua
local basalt = require("basalt")

local main = basalt.createFrame()
local aButton = main:addButton()
    :setPosition(3,3)
    :onLoseFocus(
        function(self) 
            basalt.debug("Please come back...") 
        end
    )
```
