## resizeImage
This method is used to resize a bimg image. It takes two parameters: the new width, and the new height. It is important to note that resizing images can result in a loss of quality, as the original pixel data is being transformed and resampled to fit the new dimensions. This is especially noticeable when increasing the size of an image, as new pixels must be generated to fill in the gaps. As a result, it is generally recommended to use the original image at its full size whenever possible, rather than resizing it.

#### Parameters: 

1. `number` the new width
2. `number` the new height

#### Returns:
1. `object` The object in use

#### Usage:

* Creates a new image object, loads the image and changes it's size.

```lua
local mainFrame = basalt.createFrame()
local aImage = mainFrame:addImage():loadImage("test.bimg"):resizeImage(40, 20)
```
