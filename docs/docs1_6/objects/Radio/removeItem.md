## removeItem
Removes a item from the radio

#### Parameters: 
1. `number` The index which should get removed

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a default radio with 3 entries and removes the second one.
```lua
local mainFrame = basalt.createFrame()
local aRadio = mainFrame:addRadio()
aRadio:addItem("1. Entry",5,2)
aRadio:addItem("2. Entry",5,4,colors.yellow)
aRadio:addItem("3. Entry",5,6,colors.yellow,colors.green)
aRadio:removeItem(2)
```