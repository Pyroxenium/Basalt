## getImage

### Description

Returns the current image of the image object in its internal format. This is useful if you need to access the raw image data for manipulation or analysis purposes.

### Returns

1. `table` The current image in the image object

### Usage

* Creates a new image object, loads an image, and gets the current image

```lua
local mainFrame = basalt.createFrame()
local aImage = mainFrame:addImage():loadImage("test.bimg")
local currentImage = aImage:getImage()
```
