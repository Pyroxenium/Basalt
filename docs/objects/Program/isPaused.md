## isPaused

### Description

Returns whether the program is paused or not.

### Returns

1. `boolean` The pause status of the program

### Usage

* Print the pause status of the program:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local aProgram = mainFrame:addProgram():execute("rom/programs/shell.lua")
local pausedStatus = aProgram:isPaused()

basalt.debug("Is the program paused?", pausedStatus)
```

In this example, a Program object is created, added to the mainFrame, and the "rom/programs/shell.lua" script is executed. The `isPaused` method is then called to determine whether the program is paused or not, and the result is printed to the console.
