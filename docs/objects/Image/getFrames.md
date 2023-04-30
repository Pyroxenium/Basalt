## getFrames

### Description

Retrieves a table containing all the frames in the image object..

### Returns

1. `table` A table containing all the frames in the image object.

### Usage

* Creates a new image object, loads a bimg image, and retrieves all the frames.

```lua
local mainFrame = basalt.createFrame()
local aImage = mainFrame:addImage():loadImage("test.bimg")
local frames = aImage:getFrames()
```
