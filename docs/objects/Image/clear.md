## clear

### Description

Clears all frames from the image object.

### Returns

1. `object` The object in use

### Usage

* Creates a new image object, loads a bimg image, and clears all frames.

```lua
local mainFrame = basalt.createFrame()
local aImage = mainFrame:addImage():loadImage("test.bimg")
aImage:clear()
```
