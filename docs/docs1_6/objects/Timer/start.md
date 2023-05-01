## start
Starts the timer

#### Returns:
1. `object` The object

```lua
local mainFrame = basalt.createFrame()
local aTimer = mainFrame:addTimer()
aTimer:setTime(2):start()
```
```xml
<timer time="2" start="true"/>
```