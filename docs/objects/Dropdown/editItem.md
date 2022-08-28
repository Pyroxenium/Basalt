## editItem
Edits a item from the dropdown

#### Parameters: 
1. `number` The index which should be edited
2. `string` The new item name
3. `number` the new item background color - optional
4. `number` The new item text color - optional
5. `any` New additional information - optional

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a default dropdown with 3 entries and edits the second one.
```lua
local mainFrame = basalt.createFrame()
local aDropdown = mainFrame:addDropdown()
aDropdown:addItem("1. Entry")
aDropdown:addItem("2. Entry",colors.yellow)
aDropdown:addItem("3. Entry",colors.yellow,colors.green)
aDropdown:editItem(2, "Still 2. Entry", colors.red)
```