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
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aProgressbar = mainFrame:addProgressbar("myFirstProgressbar"):show()
aProgressbar:setDirection(3)
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
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aProgressbar = mainFrame:addProgressbar("myFirstProgressbar"):show()
aProgressbar:setProgress(50)
```

## getProgress
Returns the current progress status


#### Returns:
1. `number` progress (0-100)

#### Usage:
* Creates a progressbar, sets the current progress to 50 and prints the current progress
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aProgressbar = mainFrame:addProgressbar("myFirstProgressbar"):show()
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
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aProgressbar = mainFrame:addProgressbar("myFirstProgressbar"):show()
aProgressbar:setProgressBar(colors.green)
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
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aProgressbar = mainFrame:addProgressbar("myFirstProgressbar"):show()
aProgressbar:setBackgroundSymbol("X")
```

# Events

# onProgressDone
`onProgressDone(self)`<br>
A custom event which gets triggered as soon as the progress reaches 100.

Here is a example on how to add a onProgressDone event to your progressbar:

```lua
local basalt = dofile("basalt.lua")

local mainFrame = basalt.createFrame("myMainFrame"):show()
local aProgressbar = mainFrame:addProgressbar("myFirstProgressbar"):show()

function progressDone()
  basalt.debug("The Progressbar reached 100%!")
end
aProgressbar:onProgressDone(progressDone)
```
