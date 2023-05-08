## setMaxValue
the default max value is always the width (if horizontal) or height (if vertical), if you change the max value the bar will always calculate the value based on its width or height - example: you set the max value to 100, the height is 10 and it is a vertical bar, this means if the bar is on top, the value is 10, if the bar goes one below, it is 20 and so on.

#### Parameters: 
1. `number` maximum

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a new scrollbar and changes the max value to 20
```lua
local main = basalt.createFrame()
local scrollbar = main:addScrollbar():setMaxValue(20)
```
```xml
<scrollbar maxValue="20" />
```