## isExpanded

### Description

The `isExpanded` method returns the current expanded state of a specified node within a Treeview object. If a node is expanded, its children nodes are displayed. If a node is collapsed, its children nodes are hidden.

### Returns

1. `boolean` The expanded state of the node (true for expanded, false for collapsed)

### Usage

* Creates a Treeview, adds a child node to the root node, and checks if the root node is expanded:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local treeview = mainFrame:addTreeview()

local rootNode = treeview:getRoot()
local childNode = rootNode.addChild("Child Node")

rootNode.setExpanded(true)

if rootNode.isExpanded() then
  basalt.debug("The root node is expanded.")
else
  basalt.debug("The root node is not expanded.")
end

basalt.autoUpdate()
```

In this example, a Treeview object is created and added to the mainFrame. The `getRoot` method is used to access the root node, and a new child node is added to it using the `addChild` method. The `setExpanded` method is then used to set the expanded state of the root node to true. The `isExpanded` method is used to check if the root node is expanded and display the result using `basalt.debug`.
