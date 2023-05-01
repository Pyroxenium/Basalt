## editItem
Edits a item from the radio

#### Parameters: 
1. `number` The index which should be edited
2. `string` The new item name
3. `number` the new x position
4. `number` the new y position
3. `number|color` the new item background color - optional
4. `number|color` The new item text color - optional
5. `any` New additional information - optional

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a default radio with 3 entries and changes the second one.
```lua
local mainFrame = basalt.createFrame()
local aRadio = mainFrame:addRadio()
aRadio:addItem("1. Entry",5,2)
aRadio:addItem("2. Entry",5,4,colors.yellow)
aRadio:addItem("3. Entry",5,6,colors.yellow,colors.green)
aRadio:editItem(2, "Still 2. Entry", 5, 4, colors.red)
```