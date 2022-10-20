# Object - Event

## onHover

`onHover(self, event, button, x, y)`

The computercraft event which triggers this method is `mouse_move` - only available in [CraftOS-PC](https://www.craftos-pc.cc).

Here is a example on how to add a onHover event to your button:

```lua
local basalt = require("basalt")

local main = basalt.createFrame()
local button = main:addButton()
  :setPosition(3,3)
  :setSize(12,3)
  :setText("Hover")

function buttonOnHover()
  basalt.debug("The mouse hovers over the button!")
end
button:onHover(buttonOnHover)
```
