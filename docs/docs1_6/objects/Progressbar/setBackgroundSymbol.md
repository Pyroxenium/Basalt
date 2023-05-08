## setBackgroundSymbol
This will change the background symbol (default is " " - space)

#### Parameters: 
1. `char` the background symbol

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a progressbar and sets the progressbar background symbol to X
```lua
local mainFrame = basalt.createFrame()
local aProgressbar = mainFrame:addProgressbar()
aProgressbar:setBackgroundSymbol("X")
```
```xml
<progressbar backgroundSymbol="X" />
```