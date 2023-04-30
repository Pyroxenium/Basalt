The image object is for adding more advanced backgrounds.
It also provides a :shrink() function, where you can shrink the images to smaller ones. This functionallity is fully provided by the blittle library created by Bomb Bloke. I did not ask for permission to add it into the framework. If the creator wants me to remove the blittle part, just text me on discord!

The image object is still not done. in the future i will provide more image formats.

Remember image inherits from [Object](objects/Object.md)

## loadImage
loads a default .nfp file into the object. 

#### Parameters: 
1. `string` the absolute file path

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a default image and loads a test.nfp file
```lua
local mainFrame = basalt.createFrame():show()
local aImage = mainFrame:addImage():loadImage("test.nfp")
```
```xml
<image path="test.nfp" />
```

## shrink
Shrinks the current image into a blittle image.

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a default image and loads a test.nfp file
```lua
local mainFrame = basalt.createFrame()
local aImage = mainFrame:addImage():loadImage("test.nfp"):shrink()
```
```xml
<image path="test.nfp" shrink="true" />
```
