## addFrame

### Description

Adds a new frame to the image object. This is useful for creating animations with the image object by adding multiple frames that can be played in sequence.

### Parameters

1. `number` index - The index of the frame.
2. `table` frame - A table in bimg format representing a single frame of the animation.

### Returns

1. `object` The object in use

### Usage

* Adds a new frame to an existing image object's animation.

```lua
local mainFrame = basalt.createFrame()
local aImage = mainFrame:addImage():loadImage("test.bimg")

local frameToAdd = {
        {"Hello", "fffff", "33333"}
    }

aImage:addFrame(2, frameToAdd)
```
