## onLoseFocus

### Description

`onLoseFocus(self)`

The onLoseFocus event is triggered when the object loses focus, which occurs when another object is clicked.

### Returns

1. `object` The object in use

### Usage

* Add an onLoseFocus  event to a textbox:

```lua
local basalt = require("basalt")

local main = basalt.createFrame()
local textbox = main:addTextbox()
  :setPosition(3,3)
  :setSize(12,3)

function textboxOnLoseFocus()
  basalt.debug("Textbox lost focus!")
end
textbox:onLoseFocus(textboxOnLoseFocus)
```
