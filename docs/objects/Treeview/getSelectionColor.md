## getSelectionColor

### Description

Retrieves the background and foreground colors for the selected node in the Treeview object.

### Returns

1. `color` The background color for the selected node.
2. `color` The foreground color for the selected node.

### Usage

* Creates a Treeview, sets the selection colors, and retrieves them:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local treeview = mainFrame:addTreeview()
  :setSelectionColor(colors.blue, colors.white)

local bgColor, fgColor, active = treeview:getSelectionColor()

basalt.debug("Background color:", bgColor)
basalt.debug("Foreground color:", fgColor)

basalt.autoUpdate()
```

In this example, a Treeview object is created and added to the mainFrame. The `setSelectionColor` method is used to set the background color to blue and the foreground color to white. The `getSelectionColor` method is then used to retrieve the selection colors.
