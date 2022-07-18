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
local mainFrame = basalt.createFrame()
local testButton = mainFrame:addButton()
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
local mainFrame = basalt.createFrame()
local testButton = mainFrame:addButton()
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
local mainFrame = basalt.createFrame()
local testButton = mainFrame:addButton()
local aAnimation = mainFrame:addAnimation():add(function() testButton:setBackground(colors.black) end):wait(1):add(function() testButton:setBackground(colors.gray) end):wait(1):add(function() testButton:setBackground(colors.lightGray) end)

aAnimation:play() -- changes the background color of that button from black to gray and then to lightGray 
```

## cancel
Cancels the animation

#### Returns: 
1. `animation` Animation in use

#### Usage:

```lua
local mainFrame = basalt.createFrame()
local testButton = mainFrame:addButton()
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
local mainFrame = basalt.createFrame()
local testButton = mainFrame:addButton()
local aAnimation = mainFrame:addAnimation():setObject(testButton)
```

```lua
local mainFrame = basalt.createFrame()
local testButton = mainFrame:addButton("buttonToAnimate")
```
```xml
<animation object="buttonToAnimate" />
```

## move
Moves the object which got defined by setObject

#### Parameters: 
1. `number` x coordinate
2. `number` y coordinate
3. `number` duration in seconds
4. `number` time - time when this part should begin (offset to when the animation starts - default 0)
5. `table` object - optional, you could also define the object here

#### Returns: 
1. `animation` Animation in use

#### Usage:
* Takes 2 seconds to move the object from its current position to x15 y3
```lua
local mainFrame = basalt.createFrame()
local testButton = mainFrame:addButton("buttonToAnimate")
local aAnimation = mainFrame:addAnimation():setObject(testButton):move(15,3,2):play()
```
```xml
<animation object="buttonToAnimate" play="true">
<move><x>15</x><y>6</y><duration>2</duration></move>
</animation>
```

## offset
Changes the offset on the object which got defined by setObject

#### Parameters: 
1. `number` x offset
2. `number` y offset
3. `number` duration in seconds
4. `number` time - time when this part should begin (offset to when the animation starts - default 0)
5. `table` object - optional, you could also define the object here

#### Returns: 
1. `animation` Animation in use

#### Usage:

```lua
local mainFrame = basalt.createFrame()
local subFrame = mainFrame:addFrame("frameToAnimate")
local aAnimation = mainFrame:addAnimation():setObject(subFrame):offset(1,12,1):play()
```
```xml
<animation object="frameToAnimate" play="true">
<offset><x>1</x><y>12</y><duration>1</duration></offset>
</animation>
```

## size
Changes the size on the object which got defined by setObject

#### Parameters: 
1. `number` width
2. `number` height
3. `number` duration in seconds
4. `number` time - time when this part should begin (offset to when the animation starts - default 0)
5. `table` object - optional, you could also define the object here

#### Returns: 
1. `animation` Animation in use

#### Usage:
```lua
local mainFrame = basalt.createFrame()
local testButton = mainFrame:addButton("buttonToAnimate")
local aAnimation = mainFrame:addAnimation():setObject(testButton):size(15,3,1):play()
```
```xml
<animation object="buttonToAnimate" play="true">
<offset><w>15</w><h>3</h><duration>1</duration></offset>
</animation>
```

## changeText
Changes the text while animation is running

#### Parameters: 
1. `table` multiple text strings - example: {"i", "am", "groot"}
2. `number` duration in seconds
3. `number` time - time when this part should begin (offset to when the animation starts - default 0)

#### Returns: 
1. `animation` Animation in use

#### Usage:

```lua
local mainFrame = basalt.createFrame()
local testButton = mainFrame:addButton("buttonToAnimate")
local aAnimation = mainFrame:addAnimation():setObject(testButton):changeText({"i", "am", "groot"}, 2):play()
```
```xml
<animation object="buttonToAnimate" play="true">
    <text>
        <text>i</text>
        <text>am</text>
        <text>groot</text>
        <duration>2</duration>
    </text>
</animation>
```

## changeTextColor
Changes the text color while the animation is running

#### Parameters: 
1. `table` multiple color numbers - example: {colors.red, colors.yellow, colors.green}
2. `number` duration in seconds
3. `number` time - time when this part should begin (offset to when the animation starts - default 0)

#### Returns: 
1. `animation` Animation in use

#### Usage:

```lua
local mainFrame = basalt.createFrame()
local testButton = mainFrame:addButton("buttonToAnimate")
local aAnimation = mainFrame:addAnimation():setObject(testButton):changeTextColor({colors.red, colors.yellow, colors.green}, 2):play()
```
```xml
<animation object="buttonToAnimate" play="true">
    <textColor>
        <color>red</color>
        <color>yellow</color>
        <color>green</color>
        <duration>2</duration>
    </textColor>
</animation>
```

## changeBackground
Changes the background color while the animation is running

#### Parameters: 
1. `table` multiple color numbers - example: {colors.red, colors.yellow, colors.green}
2. `number` duration in seconds
3. `number` time - time when this part should begin (offset to when the animation starts - default 0)

#### Returns: 
1. `animation` Animation in use

#### Usage:

```lua
local mainFrame = basalt.createFrame()
local testButton = mainFrame:addButton("buttonToAnimate")
local aAnimation = mainFrame:addAnimation():setObject(testButton):changeTextColor({colors.red, colors.yellow, colors.green}, 2):play()
```
```xml
<animation object="buttonToAnimate" play="true">
    <background>
        <color>red</color>
        <color>yellow</color>
        <color>green</color>
        <duration>2</duration>
    </background>
</animation>
```

# Events

## onDone
`onDone(self)`<br>
This is a event which gets fired as soon as the animation has finished.

```lua
local basalt = require("Basalt")

local mainFrame = basalt.createFrame()
local testButton = mainFrame:addButton("buttonToAnimate")
local aAnimation = mainFrame:addAnimation():setObject(testButton):changeTextColor({colors.red, colors.yellow, colors.green}, 2):play()
aAnimation:onDone(function()
    basalt.debug("The animation is done")
end)
```

In XML you are also able to queue multiple animations, like this:

```xml
<animation id="anim2" object="buttonToAnimate">
    <textColor>
        <color>red</color>
        <color>yellow</color>
        <color>green</color>
        <duration>2</duration>
    </textColor>
</animation>
<animation onDone="#anim2" object="buttonToAnimate" play="true">
    <background>
        <color>red</color>
        <color>yellow</color>
        <color>green</color>
        <duration>2</duration>
    </background>
</animation>
```