## onStart
`onStart(self)`<br>
This is a event which gets fired as soon as the animation is started.

```lua
local basalt = require("Basalt")

local mainFrame = basalt.createFrame()
local testButton = mainFrame:addButton("buttonToAnimate")
local aAnimation = mainFrame:addAnimation():setObject(testButton):changeTextColor({colors.red, colors.yellow, colors.green}, 2)
aAnimation:onStart(function()
    basalt.debug("The animation is started")
end)

aAnimation:play()
```
