## addMode
Adds a new easing curve into the available easing list. Checkout the animation object if you want to know how this works.

#### Parameters: 

1. `string` - The name of the curve you want to use.
2. `functon` - The function to call

#### Returns: 

1. `animation` Animation in use

#### Usage:

* Creates a new curve

```lua
local mainFrame = basalt.createFrame()
local testButton = mainFrame:addButton("buttonToAnimate")
local aAnimation = mainFrame:addAnimation():setObject(testButton)

local function easeInBack(t) -- t is the time from 0 to 1
    local c1 = 1.70158;
    local c3 = c1 + 1
    return c3*t^3-c1*t^2
end

aAnimation:addMode("coolEaseInBack", easeInBack)
aAnimation:setMode("coolEaseInBack"):move(15,3,2):play()
```
