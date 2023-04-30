## setBackgroundSymbol

### Description

Changes the symbol in the background of the Slider object. The default symbol is "\140".

### Parameters

1. `string` symbol

### Returns

1. `object` The object in use

### Usage

* Creates a new slider and changes the background symbol to X

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local slider = mainFrame:addSlider()
  :setPosition(3, 3)
  :setSize(1, 10)
  :setBackgroundSymbol("X")

basalt.autoUpdate()
```

In this example, a Slider object is created and added to the mainFrame. The getPosition, setSize, and setBackgroundSymbol methods are used to adjust the position, size, and background symbol of the Slider. The slider's background symbol is set to "X".

```xml
<slider backgroundSymbol="X" />
```
