## onChange

### Description

`onChange(self, event, value)`

The onChange event is triggered when the value of a ChangeableObject, such as a Slider, is changed by the user.

### Returns

1. `object` The object in use

### Usage

* Add an onChange event to a Slider:

```lua
local basalt = require("basalt")

local main = basalt.createFrame()
local slider = main:addSlider()
  :setPosition(3,3)
  :setSize(12,3)
  :setValue(50)

function sliderOnChange(self, event, value)
  basalt.debug("Slider value changed to", value)
end

slider:onChange(sliderOnChange)

basalt.autoUpdate()
```
