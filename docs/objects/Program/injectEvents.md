## injectEvents

### Description

Injects multiple events into the program.

### Parameters

1. `table` ... - A table containing an "event" key and an "args" key. The "event" key should have a string value, and the "args" key should have a table value containing the parameters for the event.

### Returns

1. `object` The object in use

### Usage

* injects a multiple char events by clicking a button

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local aProgram = mainFrame:addProgram():execute("rom/programs/shell.lua")

local function injectEventsOnClick()
    aProgram:injectEvents(
  {event="char", args={"h"}},
  {event="char", args={"e"}},
  {event="char", args={"y"}})
end

mainFrame:addButton()
  :setText("Inject 'hey'")
  :onClick(injectEventsOnClick)
```
