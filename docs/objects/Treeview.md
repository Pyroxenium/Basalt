Treeview objects provide a hierarchical representation of data, allowing users to navigate and interact with items organized in a tree-like structure. They are commonly used in file explorers and other applications that require a hierarchical view of data.

Treeview objects inherit methods from VisualObject and Object. This means that Treeview objects can also use methods from VisualObject and Object.

|   |   |
|---|---|
|[setOffset](objects/Treeview/setOffset.md)|Sets the offset for the tree view
|[getOffset](objects/Treeview/getOffset.md)|Returns the current offset
|[setScrollable](objects/Treeview/setScrollable.md)|Sets whether the tree view is scrollable
|[setSelectionColor](objects/Treeview/setSelectionColor.md)|Sets the color of the selected item
|[getSelectionColor](objects/Treeview/getSelectionColor.md)|Returns the current selection color
|[isSelectionColorActive](objects/Treeview/isSelectionColorActive.md)|Checks if the selection color is active
|[getRoot](objects/Treeview/getRoot.md)|Returns the root node of the tree view
|[setRoot](objects/Treeview/setRoot.md)|Sets a new root node

## Events

This is a list of all available events for treeviews:

|   |   |
|---|---|
|[onSelect](objects/Treeview/onSelect.md)|Fires when an item is clicked

## Node Methods

|   |   |
|---|---|
|[getChildren](objects/Treeview/getChildren.md)|Returns a table of the node's children
|[getParent](objects/Treeview/getParent.md)|Returns the node's parent
|[addChild](objects/Treeview/addChild.md)|Adds a new child node to the current node
|[setExpanded](objects/Treeview/setExpanded.md)|Sets the expanded state of the node
|[isExpanded](objects/Treeview/isExpanded.md)|Returns whether the node is expanded
|[onSelect](objects/Treeview/onSelectNode.md)|Fires when a node is clicked
|[setExpandable](objects/Treeview/setExpandable.md)|Sets whether the node can be expanded or collapsed
|[isExpandable](objects/Treeview/isExpandable.md)|Returns whether the node is expandable
|[removeChild](objects/Treeview/removeChild.md)|Removes a child node from the current node
|[findChildrenByText](objects/Treeview/findChildrenByText.md)|Finds child nodes with the specified text
|[getText](objects/Treeview/getText.md)|Returns the node's text
|[setText](objects/Treeview/setText.md)|Sets the node's text

## Example

Here's an example of how to create a TreeView object and set its properties:

```lua
local main = basalt.createFrame()
local treeView = main:addTreeView()

local rootNode = treeView:getRoot()
local childNode = rootNode.addChild("Child Node")

childNode.onSelect(function(self)
    basalt.debug("Node selected:", self.getText())
end)
```

This example creates a Treeview object within a main frame, sets its properties, and adds a child node to the root node. When the child node is selected, a debug message will be printed with the node's text.
