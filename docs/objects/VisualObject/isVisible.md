## isVisible

Returns whether the object is currently visible or not.

### Returns

1. `boolean` The current visibility state of the object (true for visible, false for hidden)

#### Usage

* Prints the visibility state of an object to the debug console:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local aButton = mainFrame:addButton():setSize(5, 8)
basalt.debug(aButton:isVisible()) -- returns true
```

In this example, the isVisible method is called on aButton, and its visibility state is printed to the debug console. Since the button is visible by default, the output will be true.
