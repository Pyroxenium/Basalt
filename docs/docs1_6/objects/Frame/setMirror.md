## setMirror
mirrors this frame to another peripheral monitor object.

#### Parameters: 
1. `string` The monitor name ("right", "left",... "monitor_1", "monitor_2",...)

#### Returns:
1. `frame` The frame being used

#### Usage:
* Creates mirror of your main frame to a monitor on the left side.
```lua
local mainFrame = basalt.createFrame():setMirror("left")
```
```xml
<frame mirror="left"></frame>
```