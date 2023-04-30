Radios are objects which you can freely place, and the user is then able to select a single item.

If you want to access values inside items this is how the table for single items is made (just a example):

```lua
item = {
  text="1. Entry", 
  bgCol=colors.black, 
  fgCol=colors.white
  args = {}
}
```

Remember Radios also inherits from [Object](objects/Object.md)

## addItem
Adds a item to the radio

#### Parameters: 
1. `string` The entry name
2. `number` x position
3. `number` y position
2. `number|color` unique default background color - optional
3. `number|color` unique default text color - optional
4. `any` any value - you could access this later in a :onChange() event (you need to use :getValue()) - optional

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a default radio with 3 entries
```lua
local mainFrame = basalt.createFrame()
local aRadio = mainFrame:addRadio()
aRadio:addItem("1. Entry",5,2)
aRadio:addItem("2. Entry",5,4,colors.yellow)
aRadio:addItem("3. Entry",5,6,colors.yellow,colors.green)
```
```xml
<radio>
  <item><text>1. Entry</text><x>5</x><y>2</y></item>
  <item><text>2. Entry</text><x>5</x><y>4</y><bg>yellow</bg></item>
  <item><text>3. Entry</text><x>5</x><y>6</y><bg>yellow</bg><fg>green</fg></item>
</radio>
```

## removeItem
Removes a item from the radio

#### Parameters: 
1. `number` The index which should get removed

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a default radio with 3 entries and removes the second one.
```lua
local mainFrame = basalt.createFrame()
local aRadio = mainFrame:addRadio()
aRadio:addItem("1. Entry",5,2)
aRadio:addItem("2. Entry",5,4,colors.yellow)
aRadio:addItem("3. Entry",5,6,colors.yellow,colors.green)
aRadio:removeItem(2)
```

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

## getItemCount
Returns the current item count

#### Returns:
1. `number` The item radio count

#### Usage:
* Creates a default radio with 3 entries and prints the current item count.
```lua
local mainFrame = basalt.createFrame()
local aRadio = mainFrame:addRadio()
aRadio:addItem("1. Entry",5,2)
aRadio:addItem("2. Entry",5,4,colors.yellow)
aRadio:addItem("3. Entry",5,6,colors.yellow,colors.green)
basalt.debug(aRadio:getItemCount())
```

## getAll
Returns all items as table

#### Returns:
1. `table` All items

#### Usage:
* Creates a default menubar with 3 entries and prints a table.
```lua
local mainFrame = basalt.createFrame()
local aRadio = mainFrame:addRadio()
aRadio:addItem("1. Entry",5,2)
aRadio:addItem("2. Entry",5,4,colors.yellow)
aRadio:addItem("3. Entry",5,6,colors.yellow,colors.green)
basalt.debug(aRadio:getAll())
```

## selectItem
selects a item in the radio (same as a player would click on a item)

#### Parameters: 
1. `number` The index which should get selected

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a default radio with 3 entries and selects the second entry.
```lua
local mainFrame = basalt.createFrame()
local aRadio = mainFrame:addRadio()
aRadio:addItem("1. Entry",5,2)
aRadio:addItem("2. Entry",5,4,colors.yellow)
aRadio:addItem("3. Entry",5,6,colors.yellow,colors.green)
aRadio:selectItem(2)
```

## clear
Removes all items.

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a default radio with 3 entries and removes them immediatley. Which makes no sense.
```lua
local mainFrame = basalt.createFrame()
local aRadio = mainFrame:addRadio()
aRadio:addItem("1. Entry",5,2)
aRadio:addItem("2. Entry",5,4,colors.yellow)
aRadio:addItem("3. Entry",5,6,colors.yellow,colors.green)
aRadio:clear()
```

## getItemIndex
returns the item index of the currently selected item

#### Returns:
1. `number` The current index

#### Usage:
* Creates a default radio with 3 entries selects the second entry and prints the currently selected index.
```lua
local mainFrame = basalt.createFrame()
local aRadio = mainFrame:addRadio()
aRadio:addItem("1. Entry",5,2)
aRadio:addItem("2. Entry",5,4,colors.yellow)
aRadio:addItem("3. Entry",5,6,colors.yellow,colors.green)
aRadio:selectItem(2)
basalt.debug(aRadio:getItemIndex())
```

## setSelectedItem
Sets the background and the foreground of the item which is currently selected

#### Parameters: 
1. `number|color` The background color which should be used
2. `number|color` The text color which should be used

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a default radio with 4 entries and sets the selection background color to green.
```lua
local mainFrame = basalt.createFrame()
local aRadio = mainFrame:addRadio()
aRadio:addItem("1. Entry",5,2)
aRadio:addItem("2. Entry",5,4,colors.yellow)
aRadio:addItem("3. Entry",5,6,colors.yellow,colors.green)
aRadio:addItem("4. Entry",5,8)
aRadio:setSelectedItem(colors.green, colors.red)
```
```xml
<radio selectionBG="green" selectionFG="red">
  <item><text>1. Entry</text><x>5</x><y>2</y></item>
  <item><text>2. Entry</text><x>5</x><y>4</y><bg>yellow</bg></item>
  <item><text>3. Entry</text><x>5</x><y>6</y><bg>yellow</bg><fg>green</fg></item>
</radio>
```