## setDropdownSize
Sets the size of the opened dropdown

#### Parameters: 
1. `number` The width value
2. `number` The height value

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a default dropdown, adds 3 entries and sets the dropdown size to 15w, 8h
```lua
local mainFrame = basalt.createFrame()
local aDropdown = mainFrame:addDropdown():setDropdownSize(15,8)
aDropdown:addItem("1. Entry")
aDropdown:addItem("2. Entry")
aDropdown:addItem("3. Entry")
```
```xml
<dropdown dropdownWidth="15" dropdownHeight="8">
  <item><text>1. Entry</text></item>
  <item><text>2. Entry</text></item>
  <item><text>3. Entry</text></item>
</dropdown>
```