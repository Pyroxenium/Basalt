Lists are objects where you can create endless entries, and the user is able to select one of them

If you want to access values inside items this is how the table for single items is made (just a example):

```lua
item = {
  text="1. Entry", 
  bgCol=colors.black, 
  fgCol=colors.white
  args = {}
}
```

Remember Lists also inherits from [Object](objects/Object.md)

## addItem
Adds a item into the list

#### Parameters: 
1. `string` The entry name
2. `number|color` unique default background color - optional
3. `number|color` unique default text color - optional
4. `any` any value - you could access this later in a :onChange() event (you need to use :getValue()) - optional

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a default list with 3 entries
```lua
local mainFrame = basalt.createFrame()
local aList = mainFrame:addList()
aList:addItem("1. Entry")
aList:addItem("2. Entry",colors.yellow)
aList:addItem("3. Entry",colors.yellow,colors.green)
```
```xml
<list>
  <item><text>1. Entry</text></item>
  <item><text>2. Entry</text><bg>yellow</bg></item>
  <item><text>3. Entry</text><bg>yellow</bg><fg>green</fg></item>
</list>
```

## removeItem
Removes a item from the list

#### Parameters: 
1. `number` The index which should get removed

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a default list with 3 entries and removes the second one.
```lua
local mainFrame = basalt.createFrame()
local aList = mainFrame:addList()
aList:addItem("1. Entry")
aList:addItem("2. Entry",colors.yellow)
aList:addItem("3. Entry",colors.yellow,colors.green)
aList:removeItem(2)
```

## editItem
Edits a item from the list

#### Parameters: 
1. `number` The index which should be edited
2. `string` The new item name
3. `number` the new item background color - optional
4. `number` The new item text color - optional
5. `any` New additional information - optional

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a default list with 3 entries and changes the second one.
```lua
local mainFrame = basalt.createFrame()
local aList = mainFrame:addList()
aList:addItem("1. Entry")
aList:addItem("2. Entry",colors.yellow)
aList:addItem("3. Entry",colors.yellow,colors.green)
aList:editItem(2, "Still 2. Entry", colors.red)
```

## getItem
Returns a item by index

#### Parameters: 
1. `number` The index which should be returned

#### Returns:
1. `table` The item table example: {text="1. Entry", bgCol=colors.black, fgCol=colors.white}

#### Usage:
* Creates a default list with 3 entries and edits the second one.
```lua
local mainFrame = basalt.createFrame()
local aList = mainFrame:addList()
aList:addItem("1. Entry")
aList:addItem("2. Entry",colors.yellow)
aList:addItem("3. Entry",colors.yellow,colors.green)
basalt.debug(aList:getItem(2).text)
```

## getItemCount
Returns the current item count

#### Returns:
1. `number` The item list count

#### Usage:
* Creates a default list with 3 entries and prints the current item count.
```lua
local mainFrame = basalt.createFrame()
local aList = mainFrame:addList()
aList:addItem("1. Entry")
aList:addItem("2. Entry",colors.yellow)
aList:addItem("3. Entry",colors.yellow,colors.green)
basalt.debug(aList:getItemCount())
```

## getAll
Returns all items as table

#### Returns:
1. `table` All items

#### Usage:
* Creates a default menubar with 3 entries and prints a table.
```lua
local mainFrame = basalt.createFrame()
local aList = mainFrame:addList()
aList:addItem("1. Entry")
aList:addItem("2. Entry",colors.yellow)
aList:addItem("3. Entry",colors.yellow,colors.green)
basalt.debug(aList:getAll())
```

## selectItem
selects a item in the list (same as a player would click on a item)

#### Parameters: 
1. `number` The index which should get selected

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a default list with 3 entries and selects the second entry.
```lua
local mainFrame = basalt.createFrame()
local aList = mainFrame:addList()
aList:addItem("1. Entry")
aList:addItem("2. Entry",colors.yellow)
aList:addItem("3. Entry",colors.yellow,colors.green)
aList:selectItem(2)
```

## clear
Removes all items.

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a default list with 3 entries and removes them immediatley. Which makes no sense.
```lua
local mainFrame = basalt.createFrame()
local aList = mainFrame:addList()
aList:addItem("1. Entry")
aList:addItem("2. Entry",colors.yellow)
aList:addItem("3. Entry",colors.yellow,colors.green)
aList:clear()
```

## getItemIndex
returns the item index of the currently selected item

#### Returns:
1. `number` The current index

#### Usage:
* Creates a default list with 3 entries selects the second entry and prints the currently selected index.
```lua
local mainFrame = basalt.createFrame()
local aList = mainFrame:addList()
aList:addItem("1. Entry")
aList:addItem("2. Entry",colors.yellow)
aList:addItem("3. Entry",colors.yellow,colors.green)
aList:selectItem(2)
basalt.debug(aList:getItemIndex())
```

## setSelectedItem
Sets the background and the foreground of the item which is currently selected

#### Parameters: 
1. `number|color` The background color which should be used
2. `number|color` The text color which should be used

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a default list with 4 entries and sets the selection background color to green.
```lua
local mainFrame = basalt.createFrame()
local aList = mainFrame:addList()
aList:addItem("1. Entry")
aList:addItem("2. Entry",colors.yellow)
aList:addItem("3. Entry",colors.yellow,colors.green)
aList:addItem("4. Entry")
aList:setSelectedItem(colors.green, colors.red)
```
```xml
<list selectionBG="green" selectionFG="red">
  <item><text>1. Entry</text></item>
  <item><text>2. Entry</text><bg>yellow</bg></item>
  <item><text>2. Entry</text><bg>yellow</bg><fg>green</fg></item>
</list>
```

## setOffset
Sets the offset of the list (the same as you would scroll) - default is 0

#### Parameters: 
1. `number` The offset value

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a default list with 6 entries and sets the offset to 3.
```lua
local mainFrame = basalt.createFrame()
local aList = mainFrame:addList()
      :addItem("1. Entry")
      :addItem("2. Entry")
      :addItem("3. Entry")
      :addItem("4. Entry")
      :addItem("5. Entry")
      :addItem("6. Entry")
      :setOffset(3)
```
```xml
<list offset="3">
  <item><text>1. Entry</text></item>
  <item><text>2. Entry</text></item>
  <item><text>3. Entry</text></item>
  <item><text>4. Entry</text></item>
  <item><text>5. Entry</text></item>
  <item><text>6. Entry</text></item>
</list>
```

## getOffset
Returns the current index offset

#### Returns:
1. `number` offset value

#### Usage:
* Creates a default list with 6 entries and sets the offset to 3, also prints the current offset.
```lua
local mainFrame = basalt.createFrame()
local aList = mainFrame:addList()
      :addItem("1. Entry")
      :addItem("2. Entry")
      :addItem("3. Entry")
      :addItem("4. Entry")
      :addItem("5. Entry")
      :addItem("6. Entry")
      :setOffset(3)
basalt.debug(aList:getOffset())
```
