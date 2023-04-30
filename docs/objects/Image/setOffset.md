## setOffset

### Description

Sets the image's coordinate offset. The offset moves the image relative to its original position. It can be used to adjust the position of the image without affecting its layout within the container.

### Parameters

1. `number` offsetX - The x direction offset (+/-)
2. `number` offsetY - The y direction offset (+/-)

### Returns

1. `object` The object in use

### Usage

* Creates a new image object, loads the image, and sets an offset of 5 in the x direction and 3 in the y direction.

```lua
local mainFrame = basalt.createFrame()
local aImage = mainFrame:addImage():loadImage("test.bimg"):setOffset(5, 3)
```
