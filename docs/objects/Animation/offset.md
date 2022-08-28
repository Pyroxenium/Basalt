## offset
Changes the offset on the object which got defined by setObject

#### Parameters: 
1. `number` x offset
2. `number` y offset
3. `number` duration in seconds
4. `number` time - time when this part should begin (offset to when the animation starts - default 0)
5. `table` object - optional, you could also define the object here

#### Returns: 
1. `animation` Animation in use

#### Usage:

```lua
local mainFrame = basalt.createFrame()
local subFrame = mainFrame:addFrame("frameToAnimate")
local aAnimation = mainFrame:addAnimation():setObject(subFrame):offset(1,12,1):play()
```
```xml
<animation object="frameToAnimate" play="true">
<offset><x>1</x><y>12</y><duration>1</duration></offset>
</animation>
```