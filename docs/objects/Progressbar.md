Progressbars are objects that visually display the current state of your progress. They always represent progress as a percentage (0 to 100%), regardless of their size. To represent progress in other units, you need to perform a simple conversion: currentValue / maxValue * 100.

In addition to the Object and VisualObject methods, Progressbar objects have the following methods:

|   |   |
|---|---|
|[setDirection](objects/Progressbar/setDirection.md)|Sets the progress direction
|[setProgress](objects/Progressbar/setProgress.md)|Sets the current progress
|[getProgress](objects/Progressbar/getProgress.md)|Returns the current progress
|[setProgressBar](objects/Progressbar/setProgressBar.md)|Changes the progress design
|[setBackgroundSymbol](objects/Progressbar/setBackgroundSymbol.md)|Sets the background symbol

## Events

This is a list of all available events for progressbars:

|   |   |
|---|---|
|[onDone](objects/Progressbar/onDone.md)|Fires when progress has reached 100%

## Example

Here's an example of how to create a Progressbar object and set its properties:

```lua
local mainFrame = basalt.createFrame()
local progressBar = mainFrame:addProgressbar()

progressBar:setDirection("right")
progressBar:setProgress(50)
progressBar:setProgressBar(colors.blue)

progressBar:onDone(function()
  basalt.log("Progress completed")
end)
```

This example demonstrates how to create a Progressbar object, set its direction, progress, design, and background symbol, and handle the onDone event.
