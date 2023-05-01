## play
Plays the animation
#### Parameters: 
1. `boolean` Whether it will loop forever, will most likely be replaced with a count in the future

#### Returns: 
1. `animation` Animation in use

#### Usage:
```lua
local mainFrame = basalt.createFrame()
local testButton = mainFrame:addButton()
local aAnimation = mainFrame:addAnimation():add(function() testButton:setBackground(colors.black) end):wait(1):add(function() testButton:setBackground(colors.gray) end):wait(1):add(function() testButton:setBackground(colors.lightGray) end)

aAnimation:play() -- changes the background color of that button from black to gray and then to lightGray 
```