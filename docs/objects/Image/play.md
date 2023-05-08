## play

### Description

Plays a bimg animation. This can only work if the bimg has more than 1 frame.

### Parameters

1. `boolean` If the image animation should play

### Returns

1. `object` The object in use

### Usage

* Creates an image and plays the animation.

```lua
local mainFrame = basalt.createFrame()
local aImage = mainFrame:addImage():loadImage("animated_bimg.bimg"):play(true)
```
