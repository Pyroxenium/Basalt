## setOffset

### Description

Sets the x and y offset values for the Treeview object, determining the indentation of the nodes within the Treeview object on both axes.

### Parameters

1. `number` the x offset value to set for the Treeview object.
2. `number` the y offset value to set for the Treeview object.

### Returns

1. `object` The object in use

### Usage

* Creates a Treeview and sets the x and y offsets to 2 pixels and 3 pixels, respectively:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local treeview = mainFrame:addTreeview()
  :setOffset(2, 3)

basalt.autoUpdate()
```

In this example, the `setOffset` method is used to set the x and y indentation of the nodes within the TreeView object to 2 pixels and 3 pixels, respectively. This causes the nodes to be drawn 2 pixels from the left edge and 3 pixels from the top edge of the TreeView object.
