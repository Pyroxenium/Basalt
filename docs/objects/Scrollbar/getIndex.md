## getIndex

### Description

Returns the current index

### Returns

1. `number` index

### Usage

* Create a new scrollbar and get the current index:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local scrollbar = mainFrame:addScrollbar()
  :setPosition(3, 3)
  :setSize(1, 10)

local index = scrollbar:getIndex()
basalt.debug("Current index: " .. index)

basalt.autoUpdate()
```

In this example, a Scrollbar object is created and added to the mainFrame. The getPosition and setSize methods are used to adjust the position and size of the Scrollbar. The getIndex method is called to retrieve the current index of the Scrollbar, and the result is printed using basalt.debug.
