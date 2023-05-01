## getParent

### Description

The `getParent` method returns the parent node of a specified node within a Treeview object.

### Returns

1. `node` The parent node of the specified node, or nil if the node is a root node

### Usage

* Creates a Treeview, adds a child node, and retrieves its parent:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local treeview = mainFrame:addTreeview()

local rootNode = treeview:getRoot()
local childNode = rootNode.addChild("Child Node")

local parentNode = childNode.getParent()

basalt.debug("Parent node:", parentNode)

basalt.autoUpdate()
```

In this example, a Treeview object is created and added to the mainFrame. The `getRoot` method is used to access the root node, and a new child node is added to it using the `addChild` method. The `getParent` method is then used to retrieve the parent node of the child node, which is the root node in this case.
