## addTexture

### Description

Adds a texture to an object. A texture is a bimg image, stored on your computer.

### Parameters

1. `string` Path to your bimg file
2. `boolean` Optional - If the bimg image has animations, set this to true to be able to play it (default is false)

### Returns

1. `object` The object in use

### Usage

* Adds a texture to a frame:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()

mainFrame:addTexture("path/to/texture.bimg", true)
```
