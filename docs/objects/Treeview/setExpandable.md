## setExpandable

### Description

The `setExpandable` method allows you to control whether a node within a Treeview object can be expanded or collapsed by the user. When a node is set to be expandable, it will show a visual indicator (such as a "+" symbol) when it has child nodes, allowing the user to expand or collapse the node by clicking on the indicator.

### Parameters

1. `boolean` A boolean value indicating whether the node should be expandable (true) or not (false).

### Returns

1. `node` The node in use

### Usage

* Creates a Treeview, adds a child node to the root node, and sets the child node to be expandable:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local treeview = mainFrame:addTreeview()

local rootNode = treeview:getRoot()
local childNode = rootNode.addChild("Expandable Child Node")

childNode.setExpandable(true)

basalt.autoUpdate()
```

In this example, a Treeview object is created and added to the mainFrame. The `getRoot` method is used to access the root node, and a new child node is added to it using the `addChild` method. The `setExpandable` method is then called on the child node with a true parameter, making the node expandable by the user.
