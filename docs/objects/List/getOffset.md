## getOffset
Returns the current index offset

#### Returns:
1. `number` offset value

#### Usage:
* Creates a default dropdown with 6 entries and sets the offset to 3, also prints the current offset.
```lua
local mainFrame = basalt.createFrame()
local aList = mainFrame:addList()
      :addItem("1. Entry")
      :addItem("2. Entry")
      :addItem("3. Entry")
      :addItem("4. Entry")
      :addItem("5. Entry")
      :addItem("6. Entry")
      :addItem("7. Entry")
      :addItem("8. Entry")
      :setOffset(3)
basalt.debug(aList:getOffset())
```