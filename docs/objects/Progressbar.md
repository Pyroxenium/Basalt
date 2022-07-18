Progressbars are objects to visually display the current state of your progression. They always go from 0 to 100 (%) - no matter how big they are. which means if you
want to add some energy progress you have to do simple maths: currentValue / maxValue * 100

Here are all possible functions available for progessbars. Remember progressbar inherits from [Object](objects/Object.md)

## setDirection
Sets the direction in which the bar should be expanding.

#### Parameters: 
1. `number` x direction (0 = left to right, 1 = top to bottom, 2 = right to left and 3 = bottom to top)

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a progressbar and sets the direction from bottom to top
```lua
local mainFrame = basalt.createFrame()
local aProgressbar = mainFrame:addProgressbar()
aProgressbar:setDirection(3)
```
```xml
<frame direction="3"></frame>
```

## setProgress
This is the function you need to call if you want the progression to change.

#### Parameters: 
1. `number` a number from 0 to 100

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a progressbar and sets the current progress to 50
```lua
local mainFrame = basalt.createFrame()
local aProgressbar = mainFrame:addProgressbar()
aProgressbar:setProgress(50)
```

## getProgress
Returns the current progress status

#### Returns:
1. `number` progress (0-100)

#### Usage:
* Creates a progressbar, sets the current progress to 50 and prints the current progress
```lua
local mainFrame = basalt.createFrame()
local aProgressbar = mainFrame:addProgressbar()
aProgressbar:setProgress(50)
basalt.debug(aProgressbar:getProgress())
```

## setProgressBar
This function will change the visual display of your progress bar

#### Parameters: 
1. `number|color` the expanding progress bar color
2. `char` optional - the bar symbol - default is " " (space)
3. `number|color` optional - the bar symbol color

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a progressbar and sets the progressbar color to green
```lua
local mainFrame = basalt.createFrame()
local aProgressbar = mainFrame:addProgressbar()
aProgressbar:setProgressBar(colors.green, colors.yellow, colors.red)
```
```xml
<progressbar progressColor="green" progressSymbol="yellow" progressSymbolColor="red" />
```

## setBackgroundSymbol
Will change the default background symbol (default is " " - space)

#### Parameters: 
1. `char` the background symbol

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a progressbar and sets the progressbar background symbol to X
```lua
local mainFrame = basalt.createFrame()
local aProgressbar = mainFrame:addProgressbar()
aProgressbar:setBackgroundSymbol("X")
```
```xml
<progressbar backgroundSymbol="X" />
```

# Events

## onProgressDone
`onProgressDone(self)`<br>
A custom event which gets triggered as soon as the progress reaches 100.

Here is a example on how to add a onProgressDone event to your progressbar:

```lua
local basalt = require("Basalt")

local mainFrame = basalt.createFrame()
local aProgressbar = mainFrame:addProgressbar()

function progressDone()
  basalt.debug("The Progressbar reached 100%!")
end
aProgressbar:onProgressDone(progressDone)
```

Here is also a example how this is done with xml:

```lua
local basalt = require("Basalt")

local mainFrame = basalt.createFrame()

basalt.setVariable("progressDone", function()
  basalt.debug("The Progressbar reached 100%!")
end)
```
```xml
<progressbar onDone="progressDone" />
```

