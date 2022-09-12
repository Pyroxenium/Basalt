## changeBackground
Changes the background color while the animation is running

#### Parameters: 
1. `number` duration in seconds
2. `number` time - time when this part should begin (offset to when the animation starts - default 0)
3. `...` multiple color numbers - example: colors.red, colors.yellow, colors.green

#### Returns: 
1. `animation` Animation in use

#### Usage:

```lua
local mainFrame = basalt.createFrame()
local testButton = mainFrame:addButton("buttonToAnimate")
local aAnimation = mainFrame:addAnimation():setObject(testButton):changeTextColor(2, 0, colors.red, colors.yellow, colors.green):play()
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