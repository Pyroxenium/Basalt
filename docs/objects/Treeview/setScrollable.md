## setScrollable

### Description

Sets the scrollability of the Treeview object. If set to `true`, the Treeview will be scrollable; if set to `false`, it will not be scrollable.
Default: `true`

### Parameters

1. `boolean` A boolean value indicating whether the Treeview should be scrollable (true) or not (false).

### Returns

1. `object` The object in use

### Usage

* Creates a Treeview and sets it to be scrollable:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local treeview = mainFrame:addTreeview()
  :setScrollable(true)

basalt.autoUpdate()
```

In this example, a Treeview object is created and added to the mainFrame. The `setScrollable` method is used to set the Treeview object as scrollable by passing the true boolean value.
