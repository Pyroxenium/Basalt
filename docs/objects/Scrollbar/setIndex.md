## setIndex

### Description

Changes the current index to your choice. For example, you could create a button that scrolls up to index 1 by using setIndex(1).

### Parameters

1. `number` the index

### Returns

1. `object` The object in use

### Usage

* Create a new scrollbar and change the index to 1 when the button is clicked:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local scrollbar = mainFrame:addScrollbar()
  :setPosition(3, 3)
  :setSize(1, 10)
  :setMaxValue(20)

local button = mainFrame:addButton()
  :setPosition(5, 3)
  :setSize(10, 3)
  :setText("Set index to 1")
  :onClick(function()
      scrollbar:setIndex(1)
  end)

basalt.autoUpdate()
```

In this example, a Scrollbar object is created and added to the mainFrame. The setPosition and setSize methods are used to adjust the position and size of the Scrollbar. The setMaxValue method is used to set the maximum value of the Scrollbar. A Button object is also created and added to the mainFrame. The onClick method is used to add a custom event that changes the index of the Scrollbar to 1 when the button is clicked.

```xml
<scrollbar index="2" />
```
