## getIndex

### Description

Returns the current index of the Slider object.

### Returns

1. `number` index

### Usage

* Creates a new slider and prints the current index:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local slider = mainFrame:addSlider()
  :setPosition(3, 3)
  :setSize(1, 10)
  :setMaxValue(20)

basalt.debug(slider:getIndex())

basalt.autoUpdate()
```

In this example, a Slider object is created and added to the mainFrame. The getPosition, setSize, and setMaxValue methods are used to adjust the position, size, and maximum value of the Slider. The current index of the slider is then printed using the basalt.debug function.
