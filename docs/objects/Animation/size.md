## size
Changes the size on the object which got defined by setObject

#### Parameters: 
1. `number` width
2. `number` height
3. `number` duration in seconds
4. `number` time - time when this part should begin (offset to when the animation starts - default 0)
5. `table` object - optional, you could also define the object here

#### Returns: 
1. `animation` Animation in use

#### Usage:
```lua
local mainFrame = basalt.createFrame()
local testButton = mainFrame:addButton("buttonToAnimate")
local aAnimation = mainFrame:addAnimation():setObject(testButton):size(15,3,1):play()
```
```xml
<animation object="buttonToAnimate" play="true">
<offset><w>15</w><h>3</h><duration>1</duration></offset>
</animation>
```