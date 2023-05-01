## getProgress
Returns the current progress status

#### Returns:
1. `number` progress (0-100)

#### Usage:
* Creates a progressbar, sets the current progress to 50 and prints the current progress
```lua
local mainFrame = basalt.createFrame()
local aProgressbar = mainFrame:addProgressbar()
aProgressbar:setProgress(50)
basalt.debug(aProgressbar:getProgress())
```