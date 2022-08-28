## setScrollAmount
Sets the maximum offset it is allowed to scroll

#### Parameters: 
1. `number` maximum y offset

#### Returns:
1. `frame` The frame being used

#### Usage:
* Creates a new base frame and makes it scrollable and sets the maximum amount to 25
```lua
local myFrame = basalt.createFrame():setScrollable():setScrollAmount(25)
```
```xml
<frame scrollAmount="25"></frame>
```