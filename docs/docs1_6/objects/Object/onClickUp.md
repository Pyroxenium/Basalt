# Object - Event

## onClickUp

`onClickUp(self, event, button, x, y)`

The computercraft event which triggers this method is `mouse_up`.

Here is a example on how to add a onClickUp event to your button:

```lua
local basalt = require("basalt")

local main = basalt.createFrame()
local button = main:addButton()
  :setPosition(3,3)
  :setSize(12,3)
  :setText("Click")

function buttonOnClick(self, button, x, y)
  basalt.debug("Button got clicked!")
end
button:onClick(buttonOnClick)

function buttonOnRelease(self, button, x, y)
  basalt.debug("Button got released!")
end
button:onClickUp(buttonOnRelease)
```
