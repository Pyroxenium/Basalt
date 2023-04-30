## getFrameCount

### Description

Returns the total number of frames in the image object.

### Returns

1. `number` The total number of frames in the image object.

### Usage

* Creates a new image object, loads a bimg image, and retrieves the frame count

```lua
local mainFrame = basalt.createFrame()
local aImage = mainFrame:addImage():loadImage("test.bimg")
local frameCount = aImage:getFrameCount()
basalt.debug(frameCount)
```
