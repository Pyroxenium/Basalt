## setMaxValue

### Description

The default maximum value is always the width (if horizontal) or height (if vertical). If you change the max value, the bar will always calculate the value based on its width or height. For example, if you set the max value to 100, the height is 10 and it is a vertical bar, this means if the bar is on top, the value is 10; if the bar goes one below, it is 20 and so on.

### Parameters

1. `number` maximum

### Returns

1. `object` The object in use

### Usage

* Creates a new slider and changes the max value to 20:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local slider = mainFrame:addSlider()
  :setPosition(3, 3)
  :setSize(1, 10)
  :setMaxValue(20)

basalt.autoUpdate()
```

In this example, a Slider object is created and added to the mainFrame. The getPosition, setSize, and setMaxValue methods are used to adjust the position, size, and maximum value of the Slider. The slider's maximum value is set to 20.

```xml
<slider maxValue="20" />
```
