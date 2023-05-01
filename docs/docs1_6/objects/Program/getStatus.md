## getStatus
returns the current process status

#### Returns:
1. `string` current status ("running", "normal, "suspended", or "dead")

#### Usage:
* Prints current status
```lua
local mainFrame = basalt.createFrame()
local aProgram = mainFrame:addProgram()
basalt.debug(aProgram:getStatus())
```