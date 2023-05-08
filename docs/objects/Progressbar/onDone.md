## onDone

### Description

`onDone(self)`

This is a custom event that gets triggered when the progress is complete.

### Returns

1. `object` The object in use

### Usage

* Add an onDone event to a ProgressBar:

```lua
local basalt = require("basalt")

local main = basalt.createFrame()
local progressBar = main:addProgressBar()
  :setPosition(3, 3)
  :setSize(20, 3)
  :setProgress(50)

local function onProgressDone()
    basalt.debug("Progress is done")
end

progressBar:onDone(onProgressDone)

basalt.autoUpdate()
```

In this example, a ProgressBar object is created and added to the mainFrame. The setPosition and setSize methods are used to adjust the position and size of the ProgressBar. The setProgress method is used to set the current progress to 50. The onDone method is used to add a custom event that gets triggered when the progress is complete. The custom function, onProgressDone, prints a debug message to the console.