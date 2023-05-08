## isSelectionColorActive

### Description

Checks if the selection color is active for the Treeview object.

### Returns

1. `boolean` A boolean value indicating whether the selection color is active (`true`) or not (`false`).

### Usage

* Creates a Treeview, sets the selection colors, and checks if the selection color is active:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local treeview = mainFrame:addTreeview()
  :setSelectionColor(colors.blue, colors.white)

local active = treeview:isSelectionColorActive()

basalt.debug("Selection color active:", active)

basalt.autoUpdate()
```

In this example, a Treeview object is created and added to the mainFrame. The `setSelectionColor` method is used to set the background color to blue and the foreground color to white. The `isSelectionColorActive` method is then used to check if the selection color is active.
