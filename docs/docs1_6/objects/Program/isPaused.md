## isPaused
returns if the program is paused

#### Returns:
1. `boolean` pause status

#### Usage:
* Prints the pause status of the program
```lua
local mainFrame = basalt.createFrame():show()
local aProgram = mainFrame:addProgram():execute("rom/programs/shell.lua"):show()
basalt.debug(aProgram:isPaused())
```