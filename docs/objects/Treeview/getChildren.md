## getChildren

### Description

The `getChildren` method returns a table containing all the children nodes of a specified node within a Treeview object.

### Returns

1. `table` A table containing all the children nodes of the specified node

### Usage

* Creates a Treeview, adds a child node, and retrieves its children:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local treeview = mainFrame:addTreeview()

local rootNode = treeview:getRoot()
local childNode1 = rootNode.addChild("Child Node 1")
local childNode2 = rootNode.addChild("Child Node 2")

local children = rootNode.getChildren()

basalt.debug("Children count:", #children)

basalt.autoUpdate()
```

In this example, a Treeview object is created and added to the mainFrame. The `getRoot` method is used to access the root node, and two new child nodes are added to it using the `addChild` method. The `getChildren` method is then used to retrieve a table containing all the children nodes of the root node, and the number of children is printed to the console using `basalt.debug`.
