Dropdowns are objects where the user can click on a button, this will open a list where the user can choose from.

If you want to access values inside items this is how the table for single items is made (just a example):

```lua
item = {
  text="1. Entry", 
  bgCol=colors.black, 
  fgCol=colors.white
  args = {}
}
```

Remember Dropdown also inherits from [Object](objects/Object.md)

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

## removeItem
Removes a item from the dropdown

#### Parameters: 
1. `number` The index which should get removed

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a default dropdown with 3 entries and removes the second one.
```lua
local mainFrame = basalt.createFrame()
local aDropdown = mainFrame:addDropdown()
aDropdown:addItem("1. Entry")
aDropdown:addItem("2. Entry",colors.yellow)
aDropdown:addItem("3. Entry",colors.yellow,colors.green)
aDropdown:removeItem(2)
```

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

## getItem
Returns a item by index

#### Parameters: 
1. `number` The index which should be returned

#### Returns:
1. `table` The item table example: {text="1. Entry", bgCol=colors.black, fgCol=colors.white}

#### Usage:
* Creates a default dropdown with 3 entries and edits the second one.
```lua
local mainFrame = basalt.createFrame()
local aDropdown = mainFrame:addDropdown()
aDropdown:addItem("1. Entry")
aDropdown:addItem("2. Entry",colors.yellow)
aDropdown:addItem("3. Entry",colors.yellow,colors.green)
basalt.debug(aDropdown:getItem(2).text)
```

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

## getAll
Returns all items as table

#### Returns:
1. `table` All items

#### Usage:
* Creates a default menubar with 3 entries and prints a table.
```lua
local mainFrame = basalt.createFrame()
local aDropdown = mainFrame:addDropdown()
aDropdown:addItem("1. Entry")
aDropdown:addItem("2. Entry",colors.yellow)
aDropdown:addItem("3. Entry",colors.yellow,colors.green)
basalt.debug(aDropdown:getAll())
```

## selectItem
selects a item in the dropdown (same as a player would click on a item)

#### Parameters: 
1. `number` The index which should get selected

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a default dropdown with 3 entries and selects the second entry.
```lua
local mainFrame = basalt.createFrame()
local aDropdown = mainFrame:addDropdown()
aDropdown:addItem("1. Entry")
aDropdown:addItem("2. Entry",colors.yellow)
aDropdown:addItem("3. Entry",colors.yellow,colors.green)
aDropdown:selectItem(2)
```

## clear
Removes all items.

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a default dropdown with 3 entries and removes them immediatley. Which makes no sense.
```lua
local mainFrame = basalt.createFrame()
local aDropdown = mainFrame:addDropdown()
aDropdown:addItem("1. Entry")
aDropdown:addItem("2. Entry",colors.yellow)
aDropdown:addItem("3. Entry",colors.yellow,colors.green)
aDropdown:clear()
```

## getItemIndex
returns the item index of the currently selected item

#### Returns:
1. `number` The current index

#### Usage:
* Creates a default dropdown with 3 entries selects the second entry and prints the currently selected index.
```lua
local mainFrame = basalt.createFrame()
local aDropdown = mainFrame:addDropdown()
aDropdown:addItem("1. Entry")
aDropdown:addItem("2. Entry",colors.yellow)
aDropdown:addItem("3. Entry",colors.yellow,colors.green)
aDropdown:selectItem(2)
basalt.debug(aDropdown:getItemIndex())
```

## setSelectedItem
Sets the background and the foreground of the item which is currently selected

#### Parameters: 
1. `number|color` The background color which should be used
2. `number|color` The text color which should be used

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a default dropdown with 4 entries and sets the selection background color to green.
```lua
local mainFrame = basalt.createFrame()
local aDropdown = mainFrame:addDropdown()
aDropdown:addItem("1. Entry")
aDropdown:addItem("2. Entry",colors.yellow)
aDropdown:addItem("3. Entry",colors.yellow,colors.green)
aDropdown:addItem("4. Entry")
aDropdown:setSelectedItem(colors.green, colors.red)
```
```xml
<dropdown selectionBG="green" selectionFG="red">
  <item><text>1. Entry</text></item>
  <item><text>2. Entry</text><bg>yellow</bg></item>
  <item><text>2. Entry</text><bg>yellow</bg><fg>green</fg></item>
</dropdown>
```

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

## getOffset
Returns the current index offset

#### Returns:
1. `number` offset value

#### Usage:
* Creates a default dropdown with 6 entries and sets the offset to 3, also prints the current offset.
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
basalt.debug(aDropdown:getOffset())
```

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

