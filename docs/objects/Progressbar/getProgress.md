## getProgress

### Description

Returns the current progress status

### Returns

1. `number` progress (0-100)

### Usage

* Creates a ProgressBar, sets the current progress to 50, and prints the current progress:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local progressBar = mainFrame:addProgressBar()
  :setPosition(3, 3)
  :setSize(20, 3)
  :setProgress(50)

local currentProgress = progressBar:getProgress()
basalt.debug("Current progress:", currentProgress)
```

In this example, a ProgressBar object is created and added to the mainFrame. The setPosition and setSize methods are used to adjust the position and size of the ProgressBar. The setProgress method is used to set the current progress to 50. Finally, the getProgress method is used to retrieve the current progress value, which is then printed to the console.
