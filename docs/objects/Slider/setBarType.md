## setBarType

### Description

Changes the slider to be vertical or horizontal. The default is horizontal.

### Parameters

1. `string`  "vertical" or "horizontal"

### Returns

1. `object` The object in use

### Usage

* Creates a new slider and changes the bar type to vertical:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local slider = mainFrame:addSlider()
  :setPosition(3, 3)
  :setSize(1, 10)
  :setBarType("vertical")

basalt.autoUpdate()
```

In this example, a Slider object is created and added to the mainFrame. The getPosition, setSize, and setBarType methods are used to adjust the position, size, and orientation of the Slider. The slider's orientation is set to "vertical".

```xml
<slider barType="vertical" />
```
