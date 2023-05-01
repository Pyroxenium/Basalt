## onCall
`onCall(self)`<br>
A custom event which gets triggered as soon as the current timer has finished


Here is a example on how to add a onCall event to your timer:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local aTimer = mainFrame:addTimer()

function call()
  basalt.debug("The timer has finished!")
end
aTimer:onCall(call)
    :setTime(2)
    :start()
```

Here is also a example how this is done with xml:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()

basalt.setVariable("call", function()
  basalt.debug("The timer has finished!")
end)
```
```xml
<timer onCall="call" time="2" start="true"/>
```