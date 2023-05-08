## add
Adds a new function to an animation
#### Parameters:
1. `function` The function containing animation logic

#### Returns:
1. `animation` Animation in use


#### Usage:
* This will set the button position to 3,3, waits 1 second, then sets position to 4,4, waits 2 seconds, and then sets the position to 5,5
```lua
local mainFrame = basalt.createFrame()
local testButton = mainFrame:addButton()
local aAnimation = mainFrame:addAnimation():add(function() testButton:setPosition(3,3) end):wait(1):add(function() testButton:setPosition(1,1,"r") end):wait(2):add(function() testButton:setPosition(1,1,"r") end)
aAnimation:play()
```