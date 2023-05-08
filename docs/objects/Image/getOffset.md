## getOffset

### Description

Gets the image's current coordinate offset. The offset values represent the distance the image has been moved relative to its original position.

### Returns

1. `number` offsetX - The x direction offset (+/-)
2. `number` offsetY - The y direction offset (+/-)

### Usage

* Creates a new image object, loads the image, sets an offset, and retrieves the current offset values.

```lua
local mainFrame = basalt.createFrame()
local aImage = mainFrame:addImage():loadImage("test.bimg"):setOffset(5, 3)

local offsetX, offsetY = aImage:getOffset()
basalt.debug("Offset X: ", offsetX)
basalt.debug("Offset Y: ", offsetY)
```
