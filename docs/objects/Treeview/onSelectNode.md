## onSelect

### Description

The `onSelect` event is triggered when a node within a Treeview object is clicked or selected by the user. This event allows you to define custom behavior or actions that should be executed when the node is selected.

### Parameters

1. `function` The callback function that will be executed when the node is selected. This function receives one argument:
    * `node`: The node that was selected.

### Returns

1. `node` The node in use

### Usage

* Creates a Treeview, adds a child node to the root node, and checks if the root node is expanded:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local treeview = mainFrame:addTreeview()

local rootNode = treeview:getRoot()
local childNode = rootNode.addChild("Child Node")

childNode.onSelect(function(node)
  basalt.debug("Node selected:", node.getText())
end)

basalt.autoUpdate()
```

In this example, a Treeview object is created and added to the mainFrame. The `getRoot` method is used to access the root node, and a new child node is added to it using the `addChild` method. The `onSelect` event is then assigned to the child node with a callback function that will display the text of the selected node using `basalt.debug` when the node is clicked or selected.
