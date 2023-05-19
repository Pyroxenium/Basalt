## setJustifyContent

### Description

Determines how the children are aligned along the main axis

### Parameters

1. `string` One of ("flex-start", "flex-end", "center", "space-between", "space-around", "space-evenly") - default is flex-start. Works the same as the property of the same name in [CSS flexboxes](https://css-tricks.com/snippets/css/a-guide-to-flexbox/#aa-flexbox-properties)

### Returns

1. `object` The object in use

### Usage

* Creates a default flexbox and sets the justify content to space-between.

```lua
local main = basalt.createFrame()
local flexbox = mainFrame:addFlexbox()
      :setJustifyContent("space-between")
```
