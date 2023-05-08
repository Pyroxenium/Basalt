## setExpanded

### Description

The `setExpanded` method sets the expanded state of a specified node within a Treeview object. When a node is expanded, its children nodes are displayed. If a node is collapsed, its children nodes are hidden.

### Parameters

1. `boolean` The expanded state to set for the node (true for expanded, false for collapsed)

### Returns

1. `object` The object in use

### Usage

* Creates a Treeview, adds a child node to the root node, and sets the expanded state to false:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local treeview = mainFrame:addTreeview()

local rootNode = treeview:getRoot()
local childNode = rootNode.addChild("Child Node")

rootNode.setExpanded(false)

basalt.autoUpdate()
```

In this example, a Treeview object is created and added to the mainFrame. The `getRoot` method is used to access the root node, and a new child node is added to it using the `addChild` method. The `setExpanded` method is then used to set the expanded state of the root node to false, hiding its children nodes.
