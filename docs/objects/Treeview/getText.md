## getText

### Description

The `getText` method allows you to retrieve the text value of a node within a Treeview object. This can be useful when you need to access the text content of a node for various purposes, such as displaying the node's text or for comparison with other nodes.

### Returns

1. `string` The text value of the node

### Usage

* Creates a Treeview, adds a child node to the root node, and retrieves the text value of the child node:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local treeview = mainFrame:addTreeview()

local rootNode = treeview:getRoot()
local childNode = rootNode.addChild("Child Node 1")

-- Get the text value of the child node
local childNodeText = childNode.getText()

basalt.autoUpdate()
```

In this example, a Treeview object is created and added to the mainFrame. The `getRoot` method is used to access the root node, and a child node is added to it using the `addChild` method. The `getText` method is then called on the child node to retrieve its text value.
