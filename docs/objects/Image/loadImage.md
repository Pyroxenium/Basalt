## loadImage

### Description

This method is used to load an image file into the image object.

### Parameters

1. `string` path - The absolute file path

### Returns

1. `object` The object in use

### Usage

* Creates a default image and loads a test.nfp file

```lua
local mainFrame = basalt.createFrame()
local aImage = mainFrame:addImage():loadImage("test.nfp")
```

```xml
<image path="test.nfp" />
```
