## setDirection

### Description

Sets the scrolling direction of the ScrollableFrame object. The direction can be either "vertical" or "horizontal", which determines how the content inside the ScrollableFrame can be scrolled.

### Parameters

1. `string` direction - The scrolling direction to set. Valid values are "vertical" and "horizontal".

### Returns

1. `object` The object in use

### Usage

* Set the scrolling direction for a ScrollableFrame

```lua
local mainFrame = basalt.createFrame()
local scrollableFrame = mainFrame:addScrollableFrame()

scrollableFrame:setDirection("horizontal")
```
