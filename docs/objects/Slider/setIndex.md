## setIndex

### Description

Changes the current index of the slider to your choice. For example, you could create a button which scrolls up to 1 by using setIndex(1).

### Parameters

1. `number` the index

### Returns

1. `object` The object in use

### Usage

* Creates a new slider and changes the index to 1 as soon as the button got clicked:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local slider = mainFrame:addSlider()
  :setPosition(3, 3)
  :setSize(1, 10)
  :setMaxValue(20)

local button = mainFrame:addButton()
  :setPosition(3, 14)
  :setText("Set to 1")
  :onClick(function()
      slider:setIndex(1)
  end)

basalt.autoUpdate()
```

In this example, a Slider object is created and added to the mainFrame. The getPosition, setSize, and setMaxValue methods are used to adjust the position, size, and maximum value of the Slider. A button is added to the mainFrame to change the index of the Slider to 1 when clicked.

```xml
<slider index="2" />
```
