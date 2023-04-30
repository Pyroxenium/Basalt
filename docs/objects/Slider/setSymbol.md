## setSymbol

### Description

Changes the slider symbol. The default symbol is a space " ".

### Parameters

1. `string` symbol

### Returns

1. `object` The object in use

### Usage

* Creates a new slider and changes the symbol to "X":

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local slider = mainFrame:addSlider()
  :setPosition(3, 3)
  :setSize(1, 10)
  :setSymbol("X")

basalt.autoUpdate()
```

In this example, a Slider object is created and added to the mainFrame. The getPosition, setSize, and setSymbol methods are used to adjust the position, size, and symbol of the Slider. The slider's symbol is set to "X".

```xml
<slider symbol="X" />
```
