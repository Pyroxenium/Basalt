## setTime
sets the time the timer should wait before calling your function

#### Parameters: 
1. `number` the time to delay between repetitions
2. `number` how many times it should be repeated -1 is infinite

#### Returns:
1. `object` The object

```lua
local mainFrame = basalt.createFrame()
local aTimer = mainFrame:addTimer()
aTimer:setTime(2)
```
```xml
<timer time="2" repeat="1"/>
```
