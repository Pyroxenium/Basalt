# Object - Event

## onRelease

`onRelease(self, event, button, x, y)`

The computercraft event which triggers this method is `mouse_up`.

The difference between onRelease and :onClickUp is that :onRelease is called even when the mouse is no longer over the object, while :onClickUp is only called when the mouse is over the object.

Here is a example on how to add a onRelease event to your button:

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
button:onRelease(buttonOnRelease)
```
