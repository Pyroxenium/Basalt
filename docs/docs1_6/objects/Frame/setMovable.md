## setMovable
Sets whether the frame can be moved. _In order to move the frame click and drag the upper bar of the frame_

#### Parameters: 
1. `boolean` Whether the object is movable

#### Returns:
1. `frame` The frame being used

#### Usage:
* Creates a frame with id "myFirstFrame" and makes it movable
```lua
local myFrame = basalt.createFrame():setMovable(true)
```
```xml
<frame moveable="true"></frame>
```