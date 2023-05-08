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