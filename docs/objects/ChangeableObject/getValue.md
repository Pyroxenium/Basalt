## getValue

### Description

Gets the value of your object

### Returns

1. `any` The current value of the object

### Usage

* Retrieves the value of a Slider.

```lua
local mainFrame = basalt.createFrame()
local slider = mainFrame:addSlider():setValue(50)
local currentValue = slider:getValue()

basalt.debug("The current value of the slider is:", currentValue)
```
