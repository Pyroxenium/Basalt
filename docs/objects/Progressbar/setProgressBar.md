## setProgressBar

### Description

This function will change the visual display of your progress bar

### Parameters

1. `number|color` the expanding progress bar color
2. `char` optional - the bar symbol - default is " " (space)
3. `number|color` optional - the bar symbol color

### Returns

1. `object` The object in use

### Usage

* Creates a ProgressBar and sets the ProgressBar color to green, the symbol to "-", and the symbol color to yellow:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local progressBar = mainFrame:addProgressBar()
  :setPosition(3, 3)
  :setSize(20, 3)
  :setProgress(50)
  :setProgressBar(colors.green, "-", colors.yellow)

basalt.autoUpdate()
```

In this example, a ProgressBar object is created and added to the mainFrame. The setPosition, setSize, and setProgress methods are used to adjust the position, size, and progress of the ProgressBar. The setProgressBar method is used to change the progress bar color to green, the symbol to "-", and the symbol color to yellow.

```xml
<progressbar progressColor="green" progressSymbol="yellow" progressSymbolColor="red" />
```
