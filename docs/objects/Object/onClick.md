# onClick
`onClick(self, event, button, x, y)`<br>
The computercraft event which triggers this method is `mouse_click` and `monitor_touch`.

Here is a example on how to add a onClick event to your button:

```lua
local basalt = require("basalt")

local main = basalt.createFrame()
local button = main:addButton()
  :setPosition(3,3)
  :setSize(12,3)
  :setText("Click")

function buttonOnClick()
  basalt.debug("Button got clicked!")
end
button:onClick(buttonOnClick)
```