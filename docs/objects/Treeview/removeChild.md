## removeChild

### Description

The `removeChild` method allows you to remove a child node from its parent node within a Treeview object. This can be useful for managing the hierarchy of nodes in your Treeview and keeping it up to date with the required information.

### Parameters

1. `node` The child node to be removed from its parent node.

### Returns

1. `node` The node in use

### Usage

* Creates a Treeview, adds a child node to the root node, and removes the child node from the root node:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local treeview = mainFrame:addTreeview()

local rootNode = treeview:getRoot()
local childNode = rootNode.addChild("Child Node")

-- Remove the child node from the root node
rootNode.removeChild(childNode)

basalt.autoUpdate()
```

In this example, a Treeview object is created and added to the mainFrame. The `getRoot` method is used to access the root node, and a new child node is added to it using the `addChild` method. The `removeChild` method is then called on the root node with the child node as a parameter, effectively removing the child node from the Treeview.
