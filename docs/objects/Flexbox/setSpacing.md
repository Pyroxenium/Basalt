## setSpacing

### Description

Sets the space between objects

### Parameters

1. `number` Number of pixels of spacing between each object - default is 1

### Returns

1. `object` The object in use

### Usage

* Creates a default flexbox and sets the spacing to 5 pixels.

```lua
local main = basalt.createFrame()
local flexbox = mainFrame:addFlexbox()
      :setSpacing(5)
```
