## setProgress
This is the function you need to call if you want the progression to change.

#### Parameters: 
1. `number` a number from 0 to 100

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a progressbar and sets the current progress to 50
```lua
local mainFrame = basalt.createFrame()
local aProgressbar = mainFrame:addProgressbar()
aProgressbar:setProgress(50)
```