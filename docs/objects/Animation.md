With animations, you can create a beautiful experience for users while interacting with objects.<br>
For now the animation class is very basic, it will be expanded in the future, but we have to say you can already do almost everything you can imagine!

Right now animation is a class which makes use of the timer event.<br>
You can find more information below:

## add
Adds a new function to an animation
#### Parameters:
1. `function` The function containing animation logic

#### Returns:
1. `animation` Animation in use


#### Usage:
* This will set the button position to 3,3, waits 1 second, then sets position to 4,4, waits 2 seconds, and then sets the position to 5,5
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local testButton = mainFrame:addButton("myTestButton"):show()
local aAnimation = mainFrame:addAnimation("anim1"):add(function() testButton:setPosition(3,3) end):wait(1):add(function() testButton:setPosition(1,1,"r") end):wait(2):add(function() testButton:setPosition(1,1,"r") end)
aAnimation:play()
```

## wait
Sets a wait timer for the next function after the previous function got executed, no wait timer calls the next function immediately
#### Parameters: 
1. `number` The length of delay between the functions _(in seconds)_

#### Returns: 
1. `animation` Animation in use

#### Usage:
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local testButton = mainFrame:addButton("myTestButton"):show()
local aAnimation = mainFrame:addAnimation("anim1"):add(function() testButton:setPosition(3,3) end):wait(1):add(function() testButton:setPosition(1,1,"r") end):wait(2):add(function() testButton:setPosition(1,1,"r") end)

aAnimation:play()
```

## play
Plays the animation
#### Parameters: 
1. `boolean` Whether it will loop forever, will most likely be replaced with a count in the future

#### Returns: 
1. `animation` Animation in use

#### Usage:
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local testButton = mainFrame:addButton("myTestButton"):show()
local aAnimation = mainFrame:addAnimation("anim1"):add(function() testButton:setBackground(colors.black) end):wait(1):add(function() testButton:setBackground(colors.gray) end):wait(1):add(function() testButton:setBackground(colors.lightGray) end)

aAnimation:play() -- changes the background color of that button from black to gray and then to lightGray 
```

## cancel
Cancels the animation

#### Returns: 
1. `animation` Animation in use

#### Usage:

```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local testButton = mainFrame:addButton("myTestButton"):show()
local aAnimation = mainFrame:addAnimation("anim1"):add(function() testButton:setBackground(colors.black) end):wait(1):add(function() aAnimation:cancel() end):wait(1):add(function() testButton:setBackground(colors.lightGray) end)

aAnimation:play()
```
