## setText

### Description

The `setText` method allows you to change the text value of a node within a Treeview object. This can be useful when you need to update the text content of a node due to changes in your application's data or based on user input.

### Parameters

1. `string` The new text value for the node.

### Returns

1. `node` The node in use

### Usage

* Creates a Treeview, adds a child node to the root node, and updates the text value of the child node:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local treeview = mainFrame:addTreeview()

local rootNode = treeview:getRoot()
local childNode = rootNode.addChild("Child Node 1")

-- Update the text value of the child node
childNode.setText("Updated Child Node 1")

basalt.autoUpdate()
```

In this example, a Treeview object is created and added to the mainFrame. The `getRoot` method is used to access the root node, and a child node is added to it using the `addChild` method. The `setText` method is then called on the child node to update its text value.
