## getRoot

### Description

Retrieves the root node of the Treeview object.

### Returns

1. `node` The root node of the Treeview object

### Usage

* Creates a Treeview and retrieves its root node:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local treeview = mainFrame:addTreeview()

local rootNode = treeview:getRoot()

basalt.debug("Root node:", rootNode)

basalt.autoUpdate()
```

In this example, a Treeview object is created and added to the mainFrame. The `getRoot` method is used to retrieve the root node of the Treeview object.
