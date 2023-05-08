## addItem
Adds a item into the dropdown

#### Parameters: 
1. `string` The entry name
2. `number|color` unique default background color - optional
3. `number|color` unique default text color - optional
4. `any` any value - you could access this later in a :onChange() event (you need to use :getValue()) - optional

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a default dropdown with 3 entries
```lua
local mainFrame = basalt.createFrame()
local aDropdown = mainFrame:addDropdown()
aDropdown:addItem("1. Entry")
aDropdown:addItem("2. Entry",colors.yellow)
aDropdown:addItem("3. Entry",colors.yellow,colors.green)
```
```xml
<dropdown>
  <item><text>1. Entry</text></item>
  <item><text>2. Entry</text><bg>yellow</bg></item>
  <item><text>3. Entry</text><bg>yellow</bg><fg>green</fg></item>
</dropdown>
```