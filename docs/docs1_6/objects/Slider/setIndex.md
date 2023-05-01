## setIndex
Changes the current index to your choice, for example you could create a button which scrolls up to 1 by using :setIndex(1)

#### Parameters: 
1. `number` the index

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a new slider and changes the index to 1 as soon as the button got clicked
```lua
local mainFrame = basalt.createFrame()
local slider = mainFrame:addSlider():setMaxValue(20)
local button = mainFrame:addButton(function()
    slider:setIndex(1)
end)
```
```xml
<slider index="2" />
```