## isExpandable

### Description

The `isExpandable` method allows you to check if a node within a Treeview object is currently set as expandable or not. If a node is expandable, it means that it can be expanded or collapsed by the user when it has child nodes.

### Returns

1. `boolean` A boolean value indicating whether the node is set as expandable (true) or not (false).

### Usage

* Creates a Treeview, adds a child node to the root node, sets the child node to be expandable, and checks if the child node is expandable:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local treeview = mainFrame:addTreeview()

local rootNode = treeview:getRoot()
local childNode = rootNode.addChild("Expandable Child Node")

childNode.setExpandable(true)

local isExpandable = childNode.isExpandable()

basalt.debug("Is the child node expandable?", isExpandable)

basalt.autoUpdate()
```

In this example, a Treeview object is created and added to the mainFrame. The `getRoot` method is used to access the root node, and a new child node is added to it using the `addChild` method. The `setExpandable` method is then called on the child node with a true parameter, making the node expandable. The `isExpandable` method is used to check if the child node is currently set as expandable.
