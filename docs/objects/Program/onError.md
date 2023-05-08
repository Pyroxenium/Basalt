# onError

### Description

`onError(self, err)`

This is a custom event which gets triggered as soon as the program catches an error.

### Returns

1. `object` The object in use

### Usage

* Add an onError event to a program:

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

In this example, a Program object is created, added to the mainFrame, and the "rom/programs/shell.lua" script is executed. The `onError` event is then attached to the program, and it will be triggered when the program catches an error. The event function, `onProgramError`, will create an error Frame displaying the error message and a button to close the error Frame.
