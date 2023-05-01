## getItemCount
Returns the current item count

#### Returns:
1. `number` The item radio count

#### Usage:
* Creates a default radio with 3 entries and prints the current item count.
```lua
local mainFrame = basalt.createFrame()
local aRadio = mainFrame:addRadio()
aRadio:addItem("1. Entry",5,2)
aRadio:addItem("2. Entry",5,4,colors.yellow)
aRadio:addItem("3. Entry",5,6,colors.yellow,colors.green)
basalt.debug(aRadio:getItemCount())
```