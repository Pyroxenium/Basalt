## wait
Sets a wait timer for the next function after the previous function got executed, no wait timer calls the next function immediately
#### Parameters: 
1. `number` The length of delay between the functions _(in seconds)_

#### Returns: 
1. `animation` Animation in use

#### Usage:
```lua
local mainFrame = basalt.createFrame()
local testButton = mainFrame:addButton()
local aAnimation = mainFrame:addAnimation():add(function() testButton:setPosition(3,3) end):wait(1):add(function() testButton:setPosition(1,1,"r") end):wait(2):add(function() testButton:setPosition(1,1,"r") end)

aAnimation:play()
```