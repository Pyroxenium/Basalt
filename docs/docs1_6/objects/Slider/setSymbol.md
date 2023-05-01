## setSymbol
Changes the slider symbol, default is " "

#### Parameters: 
1. `string` symbol

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a new slider and changes the symbol to X
```lua
local mainFrame = basalt.createFrame()
local slider = mainFrame:addSlider():setSymbol("X")
```
```xml
<slider symbol="X" />
```