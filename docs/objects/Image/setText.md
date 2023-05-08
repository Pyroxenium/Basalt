## setText

### Description

Sets or modifies the text at a specified position in the currently active frame of the image object. This allows you to create or modify text within an image directly.

### Parameters

1. `string` text - The text to be placed at the specified position
2. `number` x - The x-coordinate of the text position.
3. `number` y - The y-coordinate of the text position.

### Returns

1. `object` The object in use

### Usage

* Creates a new image object, adds a frame, and sets the text in the active frame.

```lua
local mainFrame = basalt.createFrame()
local aImage = mainFrame:addImage():addFrame():setText("Hello", 1, 1)

```
