## onClickUp

### Description

`onClickUp(self, event, button, x, y)`

The onClickUp event is triggered when a mouse click is released on the object.

### Returns

1. `object` The object in use

### Usage

* Add an onClickUp event to a button:

```lua
local basalt = require("basalt")

local main = basalt.createFrame()
local button = main:addButton()
  :setPosition(3,3)
  :setSize(12,3)
  :setText("Click")

function buttonOnClickUp()
  basalt.debug("Button click released!")
end
button:onClickUp(buttonOnClickUp)
```
