## getInputType
Gets the current input type

#### Returns:
1. `string` input type

#### Usage:
* Creates a default input and sets it to numbers only. Also prints the current input type to log.
```lua
local mainFrame = basalt.createFrame()
local aInput = mainFrame:addInput():setInputType("number")
basalt.debug(aInput:getInputType())
```