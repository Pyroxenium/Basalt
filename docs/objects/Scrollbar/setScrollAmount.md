## setScrollAmount

### Description

The default max value is always the width (if horizontal) or height (if vertical). If you change the max value, the bar will always calculate the value based on its width or height. For example, you set the max value to 100, the height is 10, and it is a vertical bar; this means if the bar is on top, the value is 10, if the bar goes one below, it is 20, and so on.

### Parameters

1. `number` The maximum value

### Returns

1. `object` The object in use

### Usage

* Create a new scrollbar and change the max value to 20:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local scrollbar = mainFrame:addScrollbar()
  :setPosition(3, 3)
  :setSize(1, 10)
  :setScrollAmount(20)

basalt.autoUpdate()
```

In this example, a Scrollbar object is created and added to the mainFrame. The setPosition and setSize methods are used to adjust the position and size of the Scrollbar. The setScrollAmount method is used to set the maximum value of the Scrollbar to 20.

```xml
<scrollbar scrollAmount="20" />
```
