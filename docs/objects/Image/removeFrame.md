## removeFrame

### Description

Removes a frame from the image object at the specified index.

### Parameters

1. `number` index - The index of the frame to remove.

### Returns

1. `object` The object in use

### Usage

* Creates a new image object, loads a bimg image, and removes the frame at index 2.

```lua
local mainFrame = basalt.createFrame()
local aImage = mainFrame:addImage():loadImage("test.bimg")
aImage:removeFrame(2)
```
