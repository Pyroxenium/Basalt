## setTextureMode

### Description

Sets the texture mode for an object. The texture mode determines how the texture is displayed on the object. Available modes are "default", "center", and "right".

### Parameters

1. `string` Texture mode ("default", "center", or "right")

### Returns

1. `object` The object in use

### Usage

* Sets the texture mode of a frame to "center":

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()

mainFrame:addTexture("path/to/texture.bimg", true)
mainFrame:setTextureMode("center")
```
