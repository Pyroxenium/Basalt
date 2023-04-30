## setBg

### Description

Sets or modifies the background color of a specified position in the currently active frame of the image object.

### Parameters

1. `string` backgroundColor - The color of the background at the specified position.
2. `number` x - The x-coordinate of the text position.
3. `number` y - The y-coordinate of the text position.

### Returns

1. `object` The object in use

### Usage

* Creates a new image object, adds a frame, and sets the background color in the active frame.

```lua
local mainFrame = basalt.createFrame()
local aImage = mainFrame:addImage():addFrame():setBg(1, 1, "000000")
```
