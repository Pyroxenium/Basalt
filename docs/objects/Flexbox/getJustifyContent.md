## getJustifyContent

### Description

Returns the current method used for aligning the child objects along the main axis within the Flexbox.

### Returns

1. `string` The method used for aligning the child objects. Possible values are: `flex-start`, `flex-end`, `center`, `space-between`, `space-around`, and `space-evenly`.

### Usage

* Creates a default Flexbox, sets the justify content, and then retrieves it.

```lua
local main = basalt.createFrame()
local flexbox = mainFrame:addFlexbox()
      :setJustifyContent("space-between")
local justifyContent = flexbox:getJustifyContent() -- returns "space-between"
```
