## onLeave

### Description

`onLeave(self, event, button, x, y)`

The onLeave event is triggered when the mouse pointer leaves the object. The event is based on the mouse_move event, which is only available in [CraftOS-PC](https://www.craftos-pc.cc).

### Returns

1. `object` The object in use

### Usage

* Add an onLeave event to a button:

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
