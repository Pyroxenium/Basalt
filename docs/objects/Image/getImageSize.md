## getImageSize

### Description

Returns the current image size

### Returns

1. `number` width - The current width of the image
2. `number` height - The current height of the image object

### Usage

* Gets the size of an image and prints it

```lua
local mainFrame = basalt.createFrame()
local aImage = mainFrame:addImage():loadImage("test.nfp")
local width, height = aImage:getImageSize()
basalt.debug("Image width:", width, "Image height:", height)
```
