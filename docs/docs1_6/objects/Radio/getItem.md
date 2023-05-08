## getItem
Returns a item by index

#### Parameters: 
1. `number` The index which should be returned

#### Returns:
1. `table` The item table example: {text="1. Entry", bgCol=colors.black, fgCol=colors.white}

#### Usage:
* Creates a default radio with 3 entries and edits the second one.
```lua
local mainFrame = basalt.createFrame()
local aRadio = mainFrame:addRadio()
aRadio:addItem("1. Entry",5,2)
aRadio:addItem("2. Entry",5,4,colors.yellow)
aRadio:addItem("3. Entry",5,6,colors.yellow,colors.green)
basalt.debug(aRadio:getItem(2).text)
```