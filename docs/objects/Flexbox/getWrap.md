## getWrap

### Description

Returns the current setting for whether the child objects should wrap onto the next line if there isn't enough room on the main axis within the Flexbox.

### Returns

1. `string` returns `nowrap` or `wrap`

### Usage

* Creates a default Flexbox, sets the wrap, and then retrieves it.

```lua
local main = basalt.createFrame()
local flexbox = mainFrame:addFlexbox()
      :setWrap("wrap")
local wrapSetting = flexbox:getWrap() -- returns wrap
```
