## setBarType
Changes the slider to be vertical or horizontal, default is horizontal

#### Parameters: 
1. `string` vertical or horizontal

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a new slider and changes the bar type to horizontal
```lua
local mainFrame = basalt.createFrame()
local slider = mainFrame:addSlider():setBarType("vertical")
```
```xml
<slider barType="vertical" />
```