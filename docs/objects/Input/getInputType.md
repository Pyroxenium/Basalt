## getInputType

### Description

Gets the current input type of the Input object.

### Returns

1. `string` inputType - The current input type.

### Usage

* Creates a default input, sets it to accept numbers only, and prints the current input type to the log.

```lua
local mainFrame = basalt.createFrame()
local aInput = mainFrame:addInput():setInputType("number")
basalt.debug(aInput:getInputType())
```
