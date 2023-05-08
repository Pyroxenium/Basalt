## getMetadata

### Description

Returns the metadata set in the image

### Parameter

1. `string` the metadata key (for example: title, description, author, creator, data, width, height,...)

### Returns

1. `any` metadata value

### Usage

* Load an image and get the metadata for the "title" key

```lua
local mainFrame = basalt.createFrame()
local aImage = mainFrame:addImage():loadImage("test.bimg")
local title = aImage:getMetadata("title")
```
