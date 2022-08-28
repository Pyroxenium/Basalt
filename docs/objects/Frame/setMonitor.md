## setMonitor
Sets this frame as a monitor frame

#### Parameters: 
1. `string` The monitor name ("right", "left",... "monitor_1", "monitor_2",...)

#### Returns:
1. `frame` The frame being used

#### Usage:
* Creates a new monitor frame, you can use to show objects on a monitor.
```lua
local mainFrame = basalt.createFrame()
local monitorFrame = basalt.createFrame():setMonitor("right")
monitorFrame:setBar("Monitor 1"):showBar()
```
```xml
<frame monitor="right"></frame>
```