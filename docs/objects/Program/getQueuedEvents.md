## getQueuedEvents

### Description

If the program is paused, incoming events will be inserted into a queued events table. As soon as the program is unpaused, the queued events table will be empty.

### Returns

1. `table`  A table with queued events: {event="event", args={"a", "b",...}}

### Usage

* Print the queued events table:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local aProgram = mainFrame:addProgram():execute("rom/programs/shell.lua")

local function printQueuedEvents()
  local queuedEvents = aProgram:getQueuedEvents()
  basalt.debug(queuedEvents)
end

mainFrame:addButton():setText("Show Queued Events"):onClick(printQueuedEvents)
```
