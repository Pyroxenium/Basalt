## setDirection

### Description

Sets the direction in which the children will be placed

### Parameters

1. `string` One of ("row", "column") - default is row

### Returns

1. `object` The object in use

### Usage

* Creates a default flexbox and sets the flex direction to column.

```lua
local main = basalt.createFrame()
local flexbox = mainFrame:addFlexbox()
      :setDirection("column")
```
