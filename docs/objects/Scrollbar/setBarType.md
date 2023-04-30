## setBarType

### Description

Changes the scrollbar orientation between vertical and horizontal. The default orientation is vertical.

### Parameters

1. `string` The orientation you want to set for the scrollbar ("vertical" or "horizontal")

### Returns

1. `object` The object in use

### Usage

* Create a new scrollbar and change the bar type to horizontal:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local scrollbar = mainFrame:addScrollbar()
  :setPosition(3, 3)
  :setSize(10, 1)
  :setBarType("horizontal")

basalt.autoUpdate()
```

In this example, a Scrollbar object is created and added to the mainFrame. The setPosition and setSize methods are used to adjust the position and size of the Scrollbar. The setBarType method is used to set the orientation of the Scrollbar to "horizontal".

```xml
<scrollbar barType="horizontal" />
```
