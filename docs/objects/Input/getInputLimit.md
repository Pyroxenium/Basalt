## getInputLimit

### Description

Returns the character limit set for the Input object.

### Returns

1. `number` character limit

### Usage

* Creates a default input and sets the character limit to 8. Prints the current limit.

```lua
local mainFrame = basalt.createFrame()
local aInput = mainFrame:addInput():setInputLimit(8)
basalt.debug(aInput:getInputLimit())
```
