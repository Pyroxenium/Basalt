# Animation

With animations you can create a beautiful experience for users while interacting with objects.<br>
For now the animation class is very basic, i will expand it in the future, but i have to say already now you can do almost everything you can imagine!

Right now animation is a class which makes use of the timer event<br>
Here are all possible functions available for animations:

## add
adds a new function to your animation
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local testButton = mainFrame:addButton("myTestButton"):show()
local aAnimation = mainFrame:addAnimation("anim1"):add(function() testButton:setPosition(3,3) end):wait(1):add(function() testButton:setPosition(1,1,"r") end):wait(2):add(function() testButton:setPosition(1,1,"r") end)

aAnimation:play() -- this will set the button position to 3,3, waits 1 sec., sets it to 4,4, waits 2 sec. and then sets the position to 5,5
````
**parameters:** function<br>
**returns:** self<br>

## wait
sets a wait timer for the next function after the previous function got executed, no wait timer calls the next function immediatly
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local testButton = mainFrame:addButton("myTestButton"):show()
local aAnimation = mainFrame:addAnimation("anim1"):add(function() testButton:setPosition(3,3) end):wait(1):add(function() testButton:setPosition(1,1,"r") end):wait(2):add(function() testButton:setPosition(1,1,"r") end)

aAnimation:play() -- this will set the button position to 3,3, waits 1 sec., sets it to 4,4, waits 2 sec. and then sets the position to 5,5
````
**parameters:** timer - how long we should wait to call the next function<br>
**returns:** self<br>

## play
starts to play the animation
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local testButton = mainFrame:addButton("myTestButton"):show()
local aAnimation = mainFrame:addAnimation("anim1"):add(function() testButton:setBackground(colors.black) end):wait(1):add(function() testButton:setBackground(colors.gray) end):wait(1):add(function() testButton:setBackground(colors.lightGray) end)

aAnimation:play() -- changes the background color of that button from black to gray and then to lightGray
````
**parameters:** [endlessloop] - bool if it should loop forever - will change that to loopcount in the future<br>
**returns:** self<br>

## cancel
cancels the animation
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local testButton = mainFrame:addButton("myTestButton"):show()
local aAnimation = mainFrame:addAnimation("anim1"):add(function() testButton:setBackground(colors.black) end):wait(1):add(function() aAnimation:cancel() end):wait(1):add(function() testButton:setBackground(colors.lightGray) end)

aAnimation:play()
````
**parameters:** -<br>
**returns:** self<br>