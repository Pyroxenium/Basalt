## setSymbol
Changes the checkbox symbol, default is "\42"

#### Parameters: 
1. `string` symbol

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a new checkbox and changes the symbol to o
```lua
local main = basalt.createFrame()
local checkbox = main:addCheckbox():setSymbol("o")
```
```xml
<checkbox symbol="o" />
```