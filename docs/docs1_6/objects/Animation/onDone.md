## onDone
`onDone(self)`<br>
This is a event which gets fired as soon as the animation has finished.

```lua
local basalt = require("Basalt")

local mainFrame = basalt.createFrame()
local testButton = mainFrame:addButton("buttonToAnimate")
local aAnimation = mainFrame:addAnimation():setObject(testButton):changeTextColor({colors.red, colors.yellow, colors.green}, 2):play()
aAnimation:onDone(function()
    basalt.debug("The animation is done")
end)
```

In XML you are also able to queue multiple animations, like this:

```xml
<animation id="anim2" object="buttonToAnimate">
    <textColor>
        <color>red</color>
        <color>yellow</color>
        <color>green</color>
        <duration>2</duration>
    </textColor>
</animation>
<animation onDone="#anim2" object="buttonToAnimate" play="true">
    <background>
        <color>red</color>
        <color>yellow</color>
        <color>green</color>
        <duration>2</duration>
    </background>
</animation>
```