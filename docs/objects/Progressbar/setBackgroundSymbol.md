## setBackgroundSymbol

### Description

This will change the background symbol (default is " " - space)

### Parameters

1. `char` the background symbol

### Returns

1. `object` The object in use

### Usage

* Creates a ProgressBar and sets the ProgressBar background symbol to X:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local progressBar = mainFrame:addProgressBar()
  :setPosition(3, 3)
  :setSize(20, 3)
  :setBackgroundSymbol("X")

basalt.autoUpdate()
```

In this example, a ProgressBar object is created and added to the mainFrame. The setPosition and setSize methods are used to adjust the position and size of the ProgressBar. The setBackgroundSymbol method is used to change the background symbol to "X".

```xml
<progressbar backgroundSymbol="X" />
```
