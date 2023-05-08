## onScroll

`onScroll(self, event, direction, x, y)`

The `onScroll` event is triggered when a mouse scroll occurs over the object.

### Returns

1. `object` The object in use

### Usage

* Add an onScroll event to a button:

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
