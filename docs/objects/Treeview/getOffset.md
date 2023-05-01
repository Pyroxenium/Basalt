## setOffset

### Description

Returns the current x and y offset values for the Treeview object. These values determine the indentation of the nodes within the TreeView object on both axes.

### Returns

1. `number` The current x offset value of the Treeview object.
2. `number` The current y offset value of the Treeview object.

### Usage

* Creates a Treeview, sets the x and y offsets, and retrieves the current offset values:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local treeview = mainFrame:addTreeview()
  :setOffset(2, 3)

local offsetX, offsetY = treeview:getOffset()
basalt.debug("Treeview x offset:", offsetX)
basalt.debug("Treeview y offset:", offsetY)

basalt.autoUpdate()
```

In this example, a Treeview object is created and added to the mainFrame. The `setOffset` method is used to set the x and y indentation of the nodes within the TreeView object to 2 pixels and 3 pixels, respectively. The `getOffset` method is then called to retrieve the current x and y offset values, which are printed to the debug console.
