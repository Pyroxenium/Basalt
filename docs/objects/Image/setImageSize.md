## setImageSize

### Description

Sets the size of the image object. This can be useful when you need to scale an image to fit a specific area.

### Parameters

1. `number` width - The desired width of the image object
2. `number` height - The desired height of the image object

### Returns

1. `object` The object in use

### Usage

* Creates an image and sets its size to 10x5

```lua
local mainFrame = basalt.createFrame()
local aImage = mainFrame:addImage():loadImage("test.nfp"):setImageSize(10, 5)
```
