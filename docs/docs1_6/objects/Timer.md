Timers can call your functions delay and repeat it as often as you wish
<br>

## setTime
sets the time the timer should wait after calling your function

#### Parameters: 
1. `number` the time to delay
2. `number` how often it should be repeated -1 is infinite

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

## cancel
Cancels the timer

#### Returns:
1. `object` The object

```lua
local mainFrame = basalt.createFrame()
local aTimer = mainFrame:addTimer()
aTimer:setTime(2):start()
aTimer:cancel()
```

# Events

## onCall
`onCall(self)`<br>
A custom event which gets triggered as soon as the current timer has finished

Here is a example on how to add a onCall event to your timer:

```lua
local basalt = require("Basalt")

local mainFrame = basalt.createFrame()
local aTimer = mainFrame:addTimer()

function call()
  basalt.debug("The timer has finished!")
end
aTimer:onCall(call)
```

Here is also a example how this is done with xml:

```lua
local basalt = require("Basalt")

local mainFrame = basalt.createFrame()

basalt.setVariable("call", function()
  basalt.debug("The timer has finished!")
end)
```
```xml
<progressbar onDone="call" />
```