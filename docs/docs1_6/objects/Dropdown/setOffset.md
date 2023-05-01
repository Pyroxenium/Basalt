## setOffset
Sets the offset of the dropdown (the same as you would scroll) - default is 0

#### Parameters: 
1. `number` The offset value

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a default dropdown with 6 entries and sets the offset to 3.
```lua
local mainFrame = basalt.createFrame()
local aDropdown = mainFrame:addDropdown()
      :addItem("1. Entry")
      :addItem("2. Entry")
      :addItem("3. Entry")
      :addItem("4. Entry")
      :addItem("5. Entry")
      :addItem("6. Entry")
      :setOffset(3)
```
```xml
<dropdown offset="3">
  <item><text>1. Entry</text></item>
  <item><text>2. Entry</text></item>
  <item><text>3. Entry</text></item>
  <item><text>4. Entry</text></item>
  <item><text>5. Entry</text></item>
  <item><text>6. Entry</text></item>
</dropdown>
```