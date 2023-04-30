## injectEvent

### Description

Injects an event into the program manually. For example, you could inject "w", "a", "s", and "d" for the worm game by clicking buttons.

### Parameters

1. `string` event
2. `boolean` if this is true, the injected event will be executed even if the program is paused
3. `any` ... parameters

### Returns

1. `object` The object in use

### Usage

* Inject an event by clicking a button

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local aProgram = mainFrame:addProgram():execute("rom/programs/shell.lua")

local function injectEventOnClick()
    aProgram:injectEvent("char", false, "w")
end

mainFrame:addButton()
  :setText("Inject W")
  :onClick(injectEventOnClick)
```

In this example, a Program object is created, added to the mainFrame, and the "rom/programs/shell.lua" script is executed. A button is then added to the mainFrame that, when clicked, injects the "char" event with a parameter of "w" into the Program.
