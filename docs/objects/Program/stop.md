## stop

### Description

Stops a currently running program

### Returns

1. `object` The object in use

### Usage

* Stops a running program by clicking a button:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local aProgram = mainFrame:addProgram()

aProgram:execute("rom/programs/fun/worm.lua") -- Executes the worm program

local stopButton = mainFrame:addButton()
  :setText("Stop")
  :setPosition(5, 5)
  :setSize(10, 3)
  :onClick(function()
    aProgram:stop() -- Stop the program when the button is clicked
  end)

basalt.autoUpdate()
```

In this example, a Program object is created and added to the mainFrame. The worm program is executed using the `execute` method. A button with the text "Stop" is added to the mainFrame, and when clicked, it will stop the running worm program using the `stop` method.
