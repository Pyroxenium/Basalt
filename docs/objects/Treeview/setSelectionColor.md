## setSelectionColor

### Description

Sets the background and foreground colors for the selected node in the Treeview object. Optionally, you can also specify if the selection color should be active or not.

### Parameters

1. `color` The background color for the selected node.
2. `color` The foreground color for the selected node.
3. `boolean` (optional) A boolean value indicating whether the selection color should be active (true) or not (false). Default value is true.

### Returns

1. `object` The object in use

### Usage

* Creates a Treeview and sets the selection colors:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local treeview = mainFrame:addTreeview()
  :setSelectionColor(colors.blue, colors.white)

basalt.autoUpdate()
```

In this example, a Treeview object is created and added to the mainFrame. The setSelectionColor method is used to set the background color to blue, the foreground color to white, and the selection color to active.
