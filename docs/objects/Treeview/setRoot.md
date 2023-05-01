## setRoot

### Description

Sets a new root node for the Treeview object. This can be useful if you want to replace the current root node with a child node or an entirely new node.

### Parameters

1. `node` The new root node for the Treeview object. This should be a valid Treeview node object.

### Returns

1. `object` The object in use

### Usage

* Creates a Treeview, adds a child node, and then sets the child node as the new root node:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local treeview = mainFrame:addTreeview()

local childNode = treeview:getRoot().addChild("New Child")
treeview:setRoot(childNode)

basalt.autoUpdate()
```

In this example, a Treeview object is created and added to the mainFrame. The `getRoot` method is used to access the root node, and a new child node is added to it with the `addChild` method. Then, the `setRoot` method is used to set the new child node as the root node of the Treeview object.
