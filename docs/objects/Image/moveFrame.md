## moveFrame

### Description

Moves a frame from one index to another within the image object. This method is useful when working with bimg format images and animations, allowing you to reorder frames in the animation sequence.

### Parameters

1. `number` fromIndex - The current index of the frame you want to move.
2. `number` toIndex - The new index where you want to move the frame.

### Returns

1. `object` The object in use

### Usage

* Creates a new image object, loads a bimg image, and moves the frame at index 1 to index 3.

```lua
local mainFrame = basalt.createFrame()
local aImage = mainFrame:addImage():loadImage("test.bimg")
aImage:moveFrame(1, 3)
```
