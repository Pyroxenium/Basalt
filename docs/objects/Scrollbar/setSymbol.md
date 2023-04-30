## setSymbol

### Description

Changes the scrollbar symbol. The default symbol is " " (space).

### Parameters

1. `string` The symbol you want to set for the scrollbar

### Returns

1. `object` The object in use

### Usage

* Create a new scrollbar and change the symbol to X:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local scrollbar = mainFrame:addScrollbar()
  :setPosition(3, 3)
  :setSize(1, 10)
  :setSymbol("X")

basalt.autoUpdate()
```

In this example, a Scrollbar object is created and added to the mainFrame. The setPosition and setSize methods are used to adjust the position and size of the Scrollbar. The setSymbol method is used to set the symbol of the Scrollbar to "X".

```xml
<scrollbar symbol="X" />
```
