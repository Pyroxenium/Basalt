## setMonitorGroup

### Description

Sets the monitor group for the MonitorFrame. This can be used to combine multiple in-game monitors into a single large monitor. The content of the MonitorFrame will be displayed across all monitors in the group.

### Parameters

1. `table` A table containing monitor names connected to the computer, organized by their position in the group.

Table Layout:

```lua
{
    [y1] = {"x1", "x2", "x3"}
    [y2] = {"x1", "x2", "x3"}
}
```

### Returns

1. `object` The object in use

### Usage

* Creates a MonitorFrame and combines two monitors into a single large monitor:

```lua
local basalt = require("basalt")

local monitorFrame = basalt.addMonitor()

local monitorGroup = {
    [1] = {"monitor_1", "monitor_2"},
    [2] = {"monitor_3", "monitor_4"}
}

monitorFrame:setMonitorGroup(monitorGroup)

basalt.autoUpdate()
```
