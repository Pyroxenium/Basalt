## getActiveFrame

### Description

Returns the index of the currently active frame in the image object.

### Returns

1. `number` The index of the currently active frame in the image object.

### Usage

* Creates a new image object, loads a bimg image, and retrieves the index of the active frame.

```lua
local mainFrame = basalt.createFrame()
local aImage = mainFrame:addImage():loadImage("test.bimg")
local activeFrame = aImage:getActiveFrame()
basalt.debug(activeFrame)
```
