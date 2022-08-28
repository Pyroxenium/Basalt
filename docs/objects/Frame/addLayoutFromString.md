## addLayoutFromString
Adds a new XML Layout as string into your frame.

#### Parameters: 
1. `string` xml

#### Returns:
1. `frame` The frame being used

#### Usage:
* Creates a new base frame and adds the mainframe.xml layout
```lua
local myFrame = basalt.createFrame():addLayoutFromString("<button x='12' y='5' bg='black' />")
```