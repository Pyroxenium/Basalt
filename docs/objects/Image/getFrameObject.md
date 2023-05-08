## getFrameObject

### Description

Retrieves a frame object from the image object at the specified index. This method works with bimg format images and can be used to access and manipulate individual frames.

### Parameters

1. `number` index - The index of the frame to retrieve.

### Returns

1. `object` The frame object at the specified index, with methods to interact and modify the frame.

### Usage

* Creates a new image object, loads a bimg image, and retrieves the frame object at index 2.

```lua
local mainFrame = basalt.createFrame()
local aImage = mainFrame:addImage():loadImage("test.bimg")
local frameObject = aImage:getFrameObject(2)
```
