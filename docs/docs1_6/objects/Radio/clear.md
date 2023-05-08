## clear
Removes all items.

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a default radio with 3 entries and removes them immediatley. Which makes no sense.
```lua
local mainFrame = basalt.createFrame()
local aRadio = mainFrame:addRadio()
aRadio:addItem("1. Entry",5,2)
aRadio:addItem("2. Entry",5,4,colors.yellow)
aRadio:addItem("3. Entry",5,6,colors.yellow,colors.green)
aRadio:clear()
```