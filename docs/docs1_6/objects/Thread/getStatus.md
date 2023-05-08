## getStatus
Returns the current thread status

#### Returns:
1. `string` current status - ("running", "normal", "suspended", "dead")

#### Usage:
```lua
local mainFrame = basalt.createFrame()
local aThread = mainFrame:addThread()
basalt.debug(aThread:getStatus())
```
