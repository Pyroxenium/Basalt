## setImage
Sets a new image

#### Parameter:

1. `table` A table in bimg or nfp format.
1. `string` The format in which the image should be loaded (nfp or bimg)

#### Usage:

* Creates a default image and loads a test.nfp file

```lua
local mainFrame = basalt.createFrame()

local bimg = {
    [1] = {
        {"Hello", "fffff", "33333"}
    }
}

local aImage = mainFrame:addImage():setImage(bimg)
```
