## findChildrenByText

### Description

The `findChildrenByText` method allows you to search for all child nodes within a Treeview object that have a specific text value. This can be useful when you need to find nodes based on their text content, such as for searching or filtering purposes.

### Parameters

1. `string` The text value to search for in the child nodes.

### Returns

1. `table` A table containing all child nodes that have the specified text value.

### Usage

* Creates a Treeview, adds multiple child nodes to the root node, and finds all child nodes with the specified text:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local treeview = mainFrame:addTreeview()

local rootNode = treeview:getRoot()
local childNode1 = rootNode.addChild("Child Node 1")
local childNode2 = rootNode.addChild("Child Node 2")
local childNode3 = rootNode.addChild("Child Node 1")

-- Find all child nodes with the text "Child Node 1"
local foundNodes = rootNode.findChildrenByText("Child Node 1")

basalt.autoUpdate()
```

In this example, a Treeview object is created and added to the mainFrame. The `getRoot` method is used to access the root node, and multiple child nodes are added to it using the `addChild` method. The `findChildrenByText` method is then called on the root node with the text value "Child Node 1" as a parameter, returning a table containing all child nodes with that text value.
