## shrink

### Description

The shrink method allows you to create a Blit-Image version of a standard Image object. By using this method, the resulting image will only retain the background (BG) data, and both foreground (FG) and text information will be lost.

Shrinking the image is calculated by pixelbox, a algorithm created by 9551Dev. You can find his awesome work [here](https://github.com/9551-Dev/apis/blob/main/pixelbox_lite.lua)!

### Returns

1. `object` The object in use

### Usage

* Creates a default image and loads a nfp files and shrinks the image

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local image = mainFrame:addImage:loadImage("path/to/your/image.nfp")

image:shrink()
```
