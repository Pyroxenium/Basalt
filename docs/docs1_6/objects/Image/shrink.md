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
