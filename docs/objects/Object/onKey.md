## onKey

### Description

`onKey(self, event, key)`

The onKey event is triggered when a key is pressed on the keyboard.

### Returns

1. `object` The object in use

### Usage

* Add an onKey event to an object:

```lua
local basalt = require("basalt")

local main = basalt.createFrame()
local input = main:addInput()
  :setPosition(3,3)
  :setSize(12,1)

function inputnOnKey(self, event, key)
  basalt.debug("Key pressed: " .. key)
end
input:onKey(inputnOnKey)
```
