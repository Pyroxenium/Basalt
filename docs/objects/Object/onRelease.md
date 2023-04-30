## onRelease

### Description

`onRelease(self, event, button, x, y)`

The `onRelease` event is triggered when the mouse button is released. The main difference between `onRelease` and `onClickUp` is that `onRelease` is called even when the mouse is no longer over the object, while `onClickUp` is only called when the mouse is over the object.

### Returns

1. `object` The object in use

### Usage

* Add an onRelease event to a button:

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
