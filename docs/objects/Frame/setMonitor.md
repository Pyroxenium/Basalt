## setMonitor
You can set base frames as monitor frames, don't try to use setMonitor on sub frames

#### Parameters: 
1. `string|table` The monitor name ("right", "left",... "monitor_1", "monitor_2",...) OR a table to create multi-monitors (see example)
2. `number` optional - a number between 0.5 to 5 which sets the monitor scale

#### Returns:
1. `frame` The frame being used

#### Usage:
* Creates a new monitor frame, you can use to show objects on a monitor.
```lua
local mainFrame = basalt.createFrame()
local monitorFrame = basalt.createFrame():setMonitor("right")
monitorFrame:addLabel():setText("Hellooo!")
```
```xml
<frame monitor="right"></frame>
```

* Here is a example on how to create mutlimonitors. You always have to start on the top left of your screen and go to the bottom right, which means in this example
monitor_1 is always your most top left monitor while monitor_6 is your most bottom right monitor.

Table structure:
local monitors = {
    [y1] = {x1,x2,x3},
    [y2] = {x1,x2,x3}
    ...
}

```lua
local monitors = {
    {"monitor_1", "monitor_2", "monitor_3"},
    {"monitor_4", "monitor_5", "monitor_6"}
}

local mainFrame = basalt.createFrame()
local monitorFrame = basalt.createFrame():setMonitor(monitors)
monitorFrame:addLabel():setText("Hellooo!")
```