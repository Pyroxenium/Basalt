## pause

### Description

Pauses the current program (prevents the program from receiving events)

### Parameters

1. `boolean` true, false, or nothing (optional)

### Returns

1. `object` The object in use

### Usage

* Pause a program by clicking a button:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local aProgram = mainFrame:addProgram():execute("rom/programs/shell.lua")

local pauseButton = mainFrame:addButton()
  :setText("Pause")
  :onClick(function() 
    if aProgram:isPaused() then
      aProgram:pause(false)
      pauseButton:setText("Pause")
    else
      aProgram:pause(true)
      pauseButton:setText("Resume")
    end
  end)
```

In this example, a Program object is created, added to the mainFrame, and the "rom/programs/shell.lua" script is executed. A button is then added to the mainFrame, and when clicked, it will toggle the pause state of the program. The button text will change accordingly to indicate whether the program is paused or resumed.
