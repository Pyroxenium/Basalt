## selectFrame
The selectFrame method allows you to change the current frame of an image object. It takes a single parameter, the index of the frame you want to display.

#### Parameters:

1. `number` the frame index

#### Returns:

1. `object` The object in use

#### Usage:

* Creates a default image and loads a test.nfp file

```lua
local mainFrame = basalt.createFrame()
local aImage = mainFrame:addImage():loadImage("test.bimg"):selectFrame(2)
```
