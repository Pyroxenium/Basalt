## setOffset
Sets the frame's coordinate offset. The frame's child objects will receive the frame's coordinate offset. For example, when using a scrollbar, if you use its value to add an offset to a frame, you will get a scrollable frame.
Objects are also able to ignore the offset by using :ignoreOffset() (For example, you may want to ignore the offset on the scrollbar itself)

The function can also be supplied with negative values

#### Parameters: 
1. `number` The x direction offset (+/-)
2. `number` The y direction offset (+/-)

#### Returns:
1. `frame` The frame being used

#### Usage:
* Creates a new base frame with x offset of 5 and a y offset of 3
```lua
local myFrame = basalt.createFrame():setOffset(5, 3)
```
* Creates with x offset of 5 and a y offset of -5 (Meaning if you added a button with y position 5, it would be at y position 0)
```lua
local myFrame = basalt.createFrame():setOffset(5, -5)
```
```xml
<frame xOffset="5" yOffset="-5"></frame>
```