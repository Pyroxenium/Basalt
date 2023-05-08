# Object - Event

## onLeave

`onLeave(self, event, button, x, y)`

The computercraft event which triggers this method is `mouse_move` - only available in [CraftOS-PC](https://www.craftos-pc.cc).

Here is a example on how to add a onLeave event to your button:

```lua
local basalt = require("basalt")

local main = basalt.createFrame()
local button = main:addButton()
  :setPosition(3,3)
  :setSize(12,3)
  :setText("Leave")

function buttonOnLeave()
  basalt.debug("The mouse left the button!")
end
button:onLeave(buttonOnLeave)
```
