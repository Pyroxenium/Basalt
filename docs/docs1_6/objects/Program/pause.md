## pause
pauses the current program (prevents the program from receiving events)

#### Parameters: 
1. `boolean` true, false or nothing

#### Returns:
1. `object` The object in use

#### Usage:
* Pauses worm by clicking a button
```lua
local mainFrame = basalt.createFrame():show()
local aProgram = mainFrame:addProgram():execute("rom/programs/shell.lua"):show()
mainFrame:addButton():setText("Pause"):onClick(function() aProgram:pause(true) end):show()
```