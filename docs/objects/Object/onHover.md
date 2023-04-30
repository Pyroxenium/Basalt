## onHover

### Description

`onHover(self, event, button, x, y)`

The onHover event is triggered when the mouse is moved over the object. This event is only available in [CraftOS-PC](https://www.craftos-pc.cc).

### Returns

1. `object` The object in use

### Usage

* Add an onHover event to a button:

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
