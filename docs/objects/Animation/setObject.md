## setObject
Sets the object which the animation should reposition/resize

#### Parameters: 
1. `table` object

#### Returns: 
1. `animation` Animation in use

#### Usage:

```lua
local mainFrame = basalt.createFrame()
local testButton = mainFrame:addButton()
local aAnimation = mainFrame:addAnimation():setObject(testButton)
```

```lua
local mainFrame = basalt.createFrame()
local testButton = mainFrame:addButton("buttonToAnimate")
```
```xml
<animation object="buttonToAnimate" />
```