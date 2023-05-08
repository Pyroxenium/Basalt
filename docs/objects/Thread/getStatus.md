## getStatus

### Description

Returns the current status of the Thread object.

### Returns

1. `string` current status - One of the following: "running", "normal", "suspended", "dead"

### Usage

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local aThread = mainFrame:addThread()

local status = aThread:getStatus()
basalt.debug("Current thread status: " .. status)

basalt.autoUpdate()
```

In this example, a Thread object is created and added to the mainFrame. The `getStatus` method is called to get the current status of the Thread object. The status is then printed to the console using the `basalt.debug` function.
