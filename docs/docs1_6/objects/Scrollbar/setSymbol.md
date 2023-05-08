## setSymbol
Changes the scrollbar symbol, default is " "

#### Parameters: 
1. `string` symbol

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a new scrollbar and changes the symbol to X
```lua
local main = basalt.createFrame()
local scrollbar = main:addScrollbar():setSymbol("X")
```
```xml
<scrollbar symbol="X" />
```