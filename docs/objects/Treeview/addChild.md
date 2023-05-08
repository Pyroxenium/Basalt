## addChild

### Description

The `addChild` method adds a new child node to a specified node within a Treeview object.

### Parameters

1. `string` The text of the new child node.
2. `boolean` Whetever the child node is expandable

### Returns

1. `node` The newly created child node

### Usage

* Creates a Treeview, adds a child node to the root node:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local treeview = mainFrame:addTreeview()

local rootNode = treeview:getRoot()
local childNode = rootNode.addChild("Child Node")

basalt.autoUpdate()
```

In this example, a Treeview object is created and added to the mainFrame. The `getRoot` method is used to access the root node, and a new child node is added to it using the `addChild` method.
