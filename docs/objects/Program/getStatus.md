## getStatus

### Description

Returns the current process status.

### Returns

1. `string` The current status ("running", "normal", "suspended", or "dead")

### Usage

* Print the current status:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local aProgram = mainFrame:addProgram()

local status = aProgram:getStatus()
basalt.debug("The current status of the program is:", status)
```

In this example, a Program object is created and added to the mainFrame. The getStatus method is then used to retrieve the current status of the Program, which is printed to the console as a debug message.
