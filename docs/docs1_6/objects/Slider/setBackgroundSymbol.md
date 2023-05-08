## setBackgroundSymbol
Changes the symbol in the background, default is "\140"

#### Parameters: 
1. `string` symbol

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a new slider and changes the background symbol to X
```lua
local mainFrame = basalt.createFrame()
local slider = mainFrame:addSlider():setBackgroundSymbol("X")
```
```xml
<slider backgroundSymbol="X" />
```