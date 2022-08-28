## getItemCount
Returns the current item count

#### Returns:
1. `number` The item list count

#### Usage:
* Creates a default dropdown with 3 entries and prints the current item count.
```lua
local mainFrame = basalt.createFrame()
local aDropdown = mainFrame:addDropdown()
aDropdown:addItem("1. Entry")
aDropdown:addItem("2. Entry",colors.yellow)
aDropdown:addItem("3. Entry",colors.yellow,colors.green)
basalt.debug(aDropdown:getItemCount())
```