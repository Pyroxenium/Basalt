## onChar

### Description

`onChar(self, event, char)`

The onChar event is triggered when a character is typed on the keyboard.

### Returns

1. `object` The object in use

### Usage

* Add an onChar event to an object:

```lua
local basalt = require("basalt")

local main = basalt.createFrame()
local input = main:addInput()
  :setPosition(3,3)
  :setSize(12,1)

function inputOnChar(self, event, char)
  basalt.debug("Character typed: " .. char)
end
input:onChar(inputOnChar)
```
