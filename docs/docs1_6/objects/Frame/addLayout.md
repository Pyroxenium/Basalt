## addLayout
Adds a new XML Layout into your frame.

#### Parameters: 
1. `string` Path to your layout

#### Returns:
1. `frame` The frame being used

#### Usage:
* Creates a new base frame and adds the mainframe.xml layout
```lua
local myFrame = basalt.createFrame():addLayout("mainframe.xml")
```
```xml
<frame layout="mainframe.xml"></frame>
```