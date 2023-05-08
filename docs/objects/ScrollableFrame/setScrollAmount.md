## setScrollAmount

### Description

The setScrollAmount method allows you to set the maximum allowed scroll value. This value determines how far the content of the ScrollableFrame can be scrolled.

### Parameters

1. `number` The maximum scroll value

### Returns

1. `object` The object in use

### Usage

* Set the scrolling direction for a ScrollableFrame

```lua
local mainFrame = basalt.createFrame()
local scrollableFrame = mainFrame:addScrollableFrame()

scrollableFrame:setScrollAmount(10)
```

By setting the scroll amount, you can control how much the content of the ScrollableFrame can be scrolled, ensuring that the user can only view a specific range of content at a time.
