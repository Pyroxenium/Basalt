## setProgress

### Description

This is the function you need to call if you want to change the progress of a ProgressBar.

### Parameters

1. `number` a number from 0 to 100

### Returns

1. `object` The object in use

### Usage

* Creates a ProgressBar and sets the current progress to 50:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local progressBar = mainFrame:addProgressBar()
  :setPosition(3, 3)
  :setSize(20, 3)
  :setProgress(50)

basalt.autoUpdate()
```

In this example, a ProgressBar object is created and added to the mainFrame. The setPosition and setSize methods are used to adjust the position and size of the ProgressBar. The setProgress method is used to set the current progress to 50.
