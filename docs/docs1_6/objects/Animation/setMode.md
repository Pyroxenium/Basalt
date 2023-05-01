## setMode
Changes the easing curve. If you want to test them, here is a interesting website: https://easings.co

#### Parameters: 
1. `string` - The name of the curve you want to use.

#### Returns: 
1. `animation` Animation in use

#### Usage:
* Takes 2 seconds to move the object from its current position to x15 y3
```lua
local mainFrame = basalt.createFrame()
local testButton = mainFrame:addButton("buttonToAnimate")
local aAnimation = mainFrame:addAnimation():setObject(testButton):setMode("easeInBounce"):move(15,3,2):play()
```

## Easing Curve List

Here is a list of all available easing curves:

|   |   |   |
|---|---|---|
|linear||
|easIn|easeOut|easeInOut
|easeInSine|easeOutSine|easeInOutSine
|easeInBack|easeOutBack|easeInOutBack
|easeInCubic|easeOutCubic|easeInOutCubic
|easeInElastic|easeOutElastic|easeInOutElastic
|easeInExpo|easeOutExpo|easeInOutExpo
|easeInBack|easeOutBack|easeInOutBack
|easeInQuad|easeOutQuad|easeInOutQuad
|easeInQuint|easeOutQuint|easeInOutQuint
|easeInQuart|easeOutQuart|easeInOutQuart
|easeInCirc|easeOutCirc|easeInOutCirc
|easeInBounce|easeOutBounce|easeInOutBounce
