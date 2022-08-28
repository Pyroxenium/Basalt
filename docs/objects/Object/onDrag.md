# onDrag
`onDrag(self, event, button, x, y, xOffset, yOffset)`<br>
The computercraft event which triggers this method is `mouse_drag`.

Here is a example on how to add a onDrag event to your button:

```lua
local basalt = require("basalt")

local main = basalt.createFrame()
local button = main:addButton()
  :setPosition(3,3)
  :setSize(12,3)
  :setText("Click")

function buttonOnDrag(self, button, x, y, xOffset, yOffset)
  basalt.debug("Someone drags me (i know i wont reposition myself)!")
end
button:onDrag(buttonOnDrag)
```
