## changeBackground
Changes the background color while the animation is running

#### Parameters: 
1. `table` multiple color numbers - example: {colors.red, colors.yellow, colors.green}
2. `number` duration in seconds
3. `number` time - time when this part should begin (offset to when the animation starts - default 0)

#### Returns: 
1. `animation` Animation in use

#### Usage:

```lua
local mainFrame = basalt.createFrame()
local testButton = mainFrame:addButton("buttonToAnimate")
local aAnimation = mainFrame:addAnimation():setObject(testButton):changeTextColor({colors.red, colors.yellow, colors.green}, 2):play()
```
```xml
<animation object="buttonToAnimate" play="true">
    <background>
        <color>red</color>
        <color>yellow</color>
        <color>green</color>
        <duration>2</duration>
    </background>
</animation>
```