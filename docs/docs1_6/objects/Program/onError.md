# onError

`onError(self, err)`<br>
This is a custom event which gets triggered as soon as the program catched a error.

Here is a example on how to add a onError event to your program:

```lua
local basalt = require("basalt")

local main = basalt.createFrame()
local aProgram = main:addProgram():execute("rom/programs/shell.lua")

local function onProgramError(self, err)
local errFrame = main:addFrame()
    :setSize(30, 10)
    :setPosition("parent.w / 2 - self.w / 2", "parent.h / 2 - self.h / 2")

errFrame:addLabel()
    :setPosition(2, 3)
    :setSize("parent.w - 2", "parent.h - 3")
    :setText(err)

errFrame:addButton()
    :setPosition("parent.w", 1)
    :setSize(1, 1)
    :setText("X")
    :onClick(function()
        errFrame:remove()
    end)
end

aProgram:onError(onProgramError)
```
