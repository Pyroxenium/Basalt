## updateQueuedEvents

### Description

Manipulate the queued events table.

### Parameters

1. `table`  A table with queued events: {event="event", args={"a", "b",...}}

### Returns

1. `object` The object in use

### Usage

* Update the queued events table:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local aProgram = mainFrame:addProgram():execute("rom/programs/shell.lua")

local function updateQueuedEvents()
  local events = aProgram:getQueuedEvents()
  table.insert(events, 1, {event="char", args={"w"}})
  aProgram:updateQueuedEvents(events)
end

mainFrame:addButton():setText("Update Queued Events"):onClick(updateQueuedEvents)
```

In this example, a button is created to update the queued events table of a Program. When the button is clicked, the updateQueuedEvents function is executed, which retrieves the current queued events, inserts a new event, and then updates the queued events table in the Program object.
