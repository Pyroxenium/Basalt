## usePalette

### Description

Changes the palette colors of the image, if the bimg image has palette metadata.

### Parameter

1. `boolean` if the image should change the palette

### Returns

1. `object` The object in use

### Usage

* Creates an image and enables the use of the palette.

```lua
local mainFrame = basalt.createFrame()
local aImage = mainFrame:addImage():loadImage("test_with_palette.bimg"):usePalette(true)
```
