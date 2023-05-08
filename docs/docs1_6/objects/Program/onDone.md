# onDone

`onDone(self, err)`<br>
This is a custom event which gets triggered as soon as the program has finished.

Here is a example on how to add a onDone event to your program:

```lua
local basalt = require("basalt")

local main = basalt.createFrame()
local aProgram = main:addProgram():execute("rom/programs/shell.lua")

local function onProgramDone()
    basalt.debug("Program has finished")
end

aProgram:onDone(onProgramDone)
```
