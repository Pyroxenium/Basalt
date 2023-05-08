## onSelect

### Description

`onSelect(self, node)`

The `onSelect` event is triggered when a node in the Treeview object is clicked by the user. You can use this event to handle user interaction with the Treeview nodes.

### Returns

1. `object` The object in use

### Usage

* Creates a Treeview and handles the onSelect event:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local treeview = mainFrame:addTreeview()

local rootNode = treeview:getRoot()
local childNode = rootNode:addChild("New Child")

treeview:onSelect(function(self, node)
    basalt.debug("Selected node:", node:getText())
end)

basalt.autoUpdate()
```
