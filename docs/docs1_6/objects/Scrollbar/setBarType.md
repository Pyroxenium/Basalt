## setBarType
Changes the scrollbar to be vertical or horizontal, default is vertical

#### Parameters: 
1. `string` vertical or horizontal

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a new scrollbar and changes the bar type to horizontal
```lua
local main = basalt.createFrame()
local scrollbar = main:addScrollbar():setBarType("horizontal")
```
```xml
<scrollbar barType="horizontal" />
```