## onGetFocus

### Description

`onGetFocus(self)`

The onGetFocus event is triggered when the object gains focus, which occurs when the object is clicked.

### Returns

1. `object` The object in use

### Usage

* Add an onGetFocus event to a textbox:

```lua
local basalt = require("basalt")

local main = basalt.createFrame()
local textbox = main:addTextbox()
  :setPosition(3,3)
  :setSize(12,3)

function textboxOnGetFocus()
  basalt.debug("Textbox gained focus!")
end
textbox:onGetFocus(textboxOnGetFocus)
```
