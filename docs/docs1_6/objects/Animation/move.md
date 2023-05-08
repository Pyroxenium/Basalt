## move
Moves the object which got defined by setObject

#### Parameters: 
1. `number` x coordinate
2. `number` y coordinate
3. `number` duration in seconds
4. `number` time - time when this part should begin (offset to when the animation starts - default 0)
5. `table` object - optional, you could also define the object here

#### Returns: 
1. `animation` Animation in use

#### Usage:
* Takes 2 seconds to move the object from its current position to x15 y3
```lua
local mainFrame = basalt.createFrame()
local testButton = mainFrame:addButton("buttonToAnimate")
local aAnimation = mainFrame:addAnimation():setObject(testButton):move(15,3,2):play()
```
```xml
<animation object="buttonToAnimate" play="true">
<move><x>15</x><y>6</y><duration>2</duration></move>
</animation>
```