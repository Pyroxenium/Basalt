## onKeyUp

### Description

`onKeyUp(self, event, key)`

The onKeyUp event is triggered when a key is released on the keyboard.

### Returns

1. `object` The object in use

### Usage

* Add an onKeyUp event to an object:

```lua
local basalt = require("basalt")

local main = basalt.createFrame()
local input = main:addInput()
  :setPosition(3,3)
  :setSize(12,1)

function inputnOnKeyUp(self, event, key)
  basalt.debug("Key released: " .. key)
end
input:onKeyUp(inputnOnKey)
```
