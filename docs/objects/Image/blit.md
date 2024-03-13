## blit

### Description

Sets or modifies text, foreground and background color.

### Parameters

1. `string` text - The text to be placed at the specified position
1. `string` foreground - A string representing the foreground color
1. `string` background - A string representing the background color
2. `number` x - The x-coordinate of the text position.
3. `number` y - The y-coordinate of the text position.

### Returns

1. `object` The object in use

### Usage

* Creates a new image object, adds a frame, and sets the text in the active frame.

```lua
local mainFrame = basalt.createFrame()
local aImage = mainFrame:addImage():addFrame():blit("Hello", "fffff", "00000", 1, 1)

```
