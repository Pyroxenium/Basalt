## onDone

### Description

`onDone(self, err)`

This is a custom event which gets triggered as soon as the program has finished.

### Returns

1. `object` The object in use

### Usage

```lua
local basalt = require("basalt")

local main = basalt.createFrame()
local aProgram = main:addProgram():execute("rom/programs/shell.lua")

local function onProgramDone(self, err)
    if err then
        basalt.debug("Program finished with error:", err)
    else
        basalt.debug("Program has finished successfully")
    end
end

aProgram:onDone(onProgramDone)
```

In this example, a Program object is created, added to the mainFrame, and the "rom/programs/shell.lua" script is executed. The `onDone` event is then attached to the program, and it will be triggered when the program finishes. The event function, `onProgramDone`, will print a debug message indicating whether the program finished successfully or with an error.
