With animations, you can create a beautiful experience for users while interacting with objects.<br>
For now the animation class is very basic, it will be expanded in the future, but we have to say you can already do almost everything you can imagine!

Right now animation is a class which makes use of the timer event.<br>
You can find more information below:

`The animation object is still a WIP and the way you use it right now could change in the future!`

## add
Adds a new function to an animation
#### Parameters:
1. `function` The function containing animation logic

#### Returns:
1. `animation` Animation in use


#### Usage:
* This will set the button position to 3,3, waits 1 second, then sets position to 4,4, waits 2 seconds, and then sets the position to 5,5
```lua
local mainFrame = basalt.createFrame():show()
local testButton = mainFrame:addButton():show()
local aAnimation = mainFrame:addAnimation():add(function() testButton:setPosition(3,3) end):wait(1):add(function() testButton:setPosition(1,1,"r") end):wait(2):add(function() testButton:setPosition(1,1,"r") end)
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
local mainFrame = basalt.createFrame():show()
local testButton = mainFrame:addButton():show()
local aAnimation = mainFrame:addAnimation():add(function() testButton:setPosition(3,3) end):wait(1):add(function() testButton:setPosition(1,1,"r") end):wait(2):add(function() testButton:setPosition(1,1,"r") end)

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
local mainFrame = basalt.createFrame():show()
local testButton = mainFrame:addButton():show()
local aAnimation = mainFrame:addAnimation():add(function() testButton:setBackground(colors.black) end):wait(1):add(function() testButton:setBackground(colors.gray) end):wait(1):add(function() testButton:setBackground(colors.lightGray) end)

aAnimation:play() -- changes the background color of that button from black to gray and then to lightGray 
```

## cancel
Cancels the animation

#### Returns: 
1. `animation` Animation in use

#### Usage:

```lua
local mainFrame = basalt.createFrame():show()
local testButton = mainFrame:addButton():show()
local aAnimation = mainFrame:addAnimation():add(function() testButton:setBackground(colors.black) end):wait(1):add(function() aAnimation:cancel() end):wait(1):add(function() testButton:setBackground(colors.lightGray) end)

aAnimation:play()
```


## setObject
Sets the object which the animation should reposition/resize

#### Parameters: 
1. `table` object

#### Returns: 
1. `animation` Animation in use

#### Usage:

```lua
local mainFrame = basalt.createFrame():show()
local testButton = mainFrame:addButton():show()
local aAnimation = mainFrame:addAnimation():setObject(testButton)
```

## move
Moves the object which got defined by setObject

#### Parameters: 
1. `number` x coordinate
2. `number` y coordinate
1. `number` time in seconds
1. `number` frames (how fluid it should look like)
1. `table` object - optional, you could also define the object here

#### Returns: 
1. `animation` Animation in use

#### Usage:

```lua
local mainFrame = basalt.createFrame():show()
local testButton = mainFrame:addButton():show()
local aAnimation = mainFrame:addAnimation():setObject(testButton):move(15,3,1,5):play()
```

## move
Moves the object which got defined by setObject

#### Parameters: 
1. `number` x coordinate
2. `number` y coordinate
1. `number` time in seconds
1. `number` frames (how fluid it should look like)
1. `table` object - optional, you could also define the object here

#### Returns: 
1. `animation` Animation in use

#### Usage:

```lua
local mainFrame = basalt.createFrame():show()
local testButton = mainFrame:addButton():show()
local aAnimation = mainFrame:addAnimation():setObject(testButton):move(15,3,1,5):play()
```

## offset
Changes the offset on the object which got defined by setObject

#### Parameters: 
1. `number` x offset
2. `number` y offset
1. `number` time in seconds
1. `number` frames (how fluid it should look like)
1. `table` object - optional, you could also define the object here

#### Returns: 
1. `animation` Animation in use

#### Usage:

```lua
local mainFrame = basalt.createFrame():show()
local subFrame = mainFrame:addFrame():show()
local aAnimation = mainFrame:addAnimation():setObject(subFrame):offset(1,12,1,5):play()
```

## size
Changes the size on the object which got defined by setObject

#### Parameters: 
1. `number` width
2. `number` height
1. `number` time in seconds
1. `number` frames (how fluid it should look like)
1. `table` object - optional, you could also define the object here

#### Returns: 
1. `animation` Animation in use

#### Usage:

```lua
local mainFrame = basalt.createFrame():show()
local testButton = mainFrame:addButton():show()
local aAnimation = mainFrame:addAnimation():setObject(testButton):size(15,3,1,5):play()
```

## textColoring
Changes the text colors of an object

#### Parameters: 
1. `color|number` multiple colors

#### Returns: 
1. `animation` Animation in use

#### Usage:

```lua
local mainFrame = basalt.createFrame():show()
local testButton = mainFrame:addButton():show()
local aAnimation = mainFrame:addAnimation():setObject(testButton):textColoring(colors.black, colors.gray, colors.lightGray):play()
```
