## getFrame

### Description

Retrieves a frame from the image object at the specified index.

### Parameters

1. `number` index - The index of the frame to retrieve.

### Returns

1. `table` The frame at the specified index in bimg format.

### Usage

* Creates a new image object, loads a bimg image, and retrieves the frame at index 2.

```lua
local mainFrame = basalt.createFrame()
local aImage = mainFrame:addImage():loadImage("test.bimg")
local frame = aImage:getFrame(2)
```
