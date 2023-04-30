## setInfinitePlay

### Description

Sets whether the texture animation should play infinitely or not.

### Parameters

1. `boolean` Set to true to make the texture animation loop infinitely, false otherwise

### Returns

1. `object` The object in use

### Usage

* Set to true to make the texture animation loop infinitely, false otherwise

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()

mainFrame:addTexture("path/to/animated_texture.bimg", true)
mainFrame:setInfinitePlay(true)
```
