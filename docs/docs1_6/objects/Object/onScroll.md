# Object - Event

## onScroll

`onScroll(self, event, direction, x, y)`

The computercraft event which triggers this method is `mouse_scroll`.

Here is a example on how to add a onScroll event to your button:

```lua
local basalt = require("basalt")

local main = basalt.createFrame()
local button = main:addButton()
  :setPosition(3,3)
  :setSize(12,3)
  :setText("Click")

function buttonOnScroll(self, direction, x, y)
  basalt.debug("Someone scrolls on me!")
end
button:onScroll(buttonOnScroll)
```
