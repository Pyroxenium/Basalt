## setMonitor

### Description

Associates the MonitorFrame with an in-game monitor. The content of the MonitorFrame will be displayed on the specified monitor.

### Parameters

1. `string|table` the monitor object or name

### Returns

1. `object` The object in use

### Usage

* Creates a MonitorFrame and associates it with a monitor:

```lua
local basalt = require("basalt")

local monitor = peripheral.wrap("top") -- Assuming a monitor is on the top side
local monitorFrame = basalt.addMonitor()
monitorFrame:setMonitor(monitor)

basalt.autoUpdate()
```

or

```lua
local basalt = require("basalt")

local monitorFrame = basalt.addMonitor()
monitorFrame:setMonitor("top")

basalt.autoUpdate()
```
