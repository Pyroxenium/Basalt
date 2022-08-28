## stop
Stops a currently running program

#### Returns:
1. `object` The object in use

#### Usage:
* Stops worm by clicking a button
```lua
local mainFrame = basalt.createFrame()
local aProgram = mainFrame:addProgram()
aProgram:execute("rom/programs/fun/worm.lua") -- executes worm
mainFrame:addButton():setText("Pause"):onClick(function() aProgram:stop() end):show()
```