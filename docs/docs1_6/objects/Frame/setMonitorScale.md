## setMonitorScale
Changes the scale on the the monitor which the frame is attached to

#### Parameters: 
1. `number` A number from 0.5 to 5

#### Returns:
1. `frame` The frame being used

#### Usage:
* Creates a new base frame, sets the frame as a monitor frame and changes the monitor scale
```lua
local myFrame = basalt.createFrame()setMonitor("left"):setMonitorScale(2)
myFrame:addLabel("Monitor scale is bigger")
```
