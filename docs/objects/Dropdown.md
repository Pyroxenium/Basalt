Dropdowns are objects where you can create endless entrys the user can click on a button and it opens a "list" where the user can choose a entry

Here is a example of how to create a standard dropdown:

```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aDropdown = mainFrame:addDropdown("myFirstDropdown"):show()
```

Here are all possible functions available for dropdowns: <br>
Remember Dropdown also inherits from [Object](objects/Object.md)

## addItem
Adds a item to the dropdown

```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aDropdown = mainFrame:addDropdown("myFirstDropdown"):show()
aDropdown:addItem("1. Entry")
aDropdown:addItem("2. Entry",colors.yellow)
aDropdown:addItem("3. Entry",colors.yellow,colors.green)
```
#### Parameters: string text, number bgcolor, number fgcolor, any ... - (text is the displayed text, bgcolor and fgcolors the colors of background/text and args (...) is something dynamic, you wont see them but if you require some more information per item you can use that)<br>
#### Returns: self<br>

## removeItem
Removes a item from the dropdown

```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aDropdown = mainFrame:addDropdown("myFirstDropdown"):show()
aDropdown:addItem("1. Entry")
aDropdown:addItem("2. Entry",colors.yellow)
aDropdown:addItem("3. Entry",colors.yellow,colors.green)
aDropdown:removeItem(2)
```
#### Parameters: number index<br>
#### Returns: self<br>

## editItem
Edits a item on the dropdown

```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aDropdown = mainFrame:addDropdown("myFirstDropdown"):show()
aDropdown:addItem("1. Entry")
aDropdown:addItem("2. Entry",colors.yellow)
aDropdown:addItem("3. Entry",colors.yellow,colors.green)
aDropdown:editItem(3,"3. Edited Entry",colors.yellow,colors.green)
```
#### Parameters: number index, string text, number bgcolor, number fgcolor, any ...<br>
#### Returns: self<br>

## setScrollable
Makes the dropdown scrollable

```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aDropdown = mainFrame:addDropdown("myFirstDropdown"):show()
aDropdown:addItem("1. Entry")
aDropdown:addItem("2. Entry",colors.yellow)
aDropdown:addItem("3. Entry",colors.yellow,colors.green)
aDropdown:setScrollable(true)
```
#### Parameters: boolean isScrollable<br>
#### Returns: self<br>

## selectItem
selects a item in the dropdown (same as a player would click on a item)

```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aDropdown = mainFrame:addDropdown("myFirstDropdown"):show()
aDropdown:addItem("1. Entry")
aDropdown:addItem("2. Entry",colors.yellow)
aDropdown:addItem("3. Entry",colors.yellow,colors.green)
aDropdown:selectItem(1)
```
#### Parameters: number index<br>
#### Returns: self<br>

## clear
clears the entire list (dropdown)

```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aDropdown = mainFrame:addDropdown("myFirstDropdown"):show()
aDropdown:addItem("1. Entry")
aDropdown:addItem("2. Entry",colors.yellow)
aDropdown:addItem("3. Entry",colors.yellow,colors.green)
aDropdown:clear()
```
#### Parameters: -<br>
#### Returns: self<br>

## getItemIndex
returns the item index of the currently selected item

```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aDropdown = mainFrame:addDropdown("myFirstDropdown"):show()
aDropdown:addItem("1. Entry")
aDropdown:addItem("2. Entry",colors.yellow)
aDropdown:addItem("3. Entry",colors.yellow,colors.green)
aDropdown:getItemIndex()
```
#### Parameters: -<br>
#### Returns: number index<br>

## setSelectedItem
Sets the background of the item which is currently selected

```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aDropdown = mainFrame:addDropdown("myFirstDropdown"):show()
aDropdown:addItem("1. Entry")
aDropdown:addItem("2. Entry",colors.yellow)
aDropdown:addItem("3. Entry",colors.yellow,colors.green)
aDropdown:setSelectedItem(colors.green, colors.blue)
```
#### Parameters: number bgcolor, number fgcolor, boolean isActive (isActive means if different colors for selected item should be used)<br>
#### Returns: self<br>

## setOffset
sets the dropdown offset (will automatically change if scrolling is active)

```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aDropdown = mainFrame:addDropdown("myFirstDropdown"):show()
aDropdown:addItem("1. Entry")
aDropdown:addItem("2. Entry",colors.yellow)
aDropdown:addItem("3. Entry",colors.yellow,colors.green)
aDropdown:setOffset(3)
```
#### Parameters: number offsetValue<br>
#### Returns: self<br>

## getOffset
returns the current offset

```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aDropdown = mainFrame:addDropdown("myFirstDropdown"):show()
aDropdown:addItem("1. Entry")
aDropdown:addItem("2. Entry",colors.yellow)
aDropdown:addItem("3. Entry",colors.yellow,colors.green)
aDropdown:getOffset()
```
#### Parameters: -<br>
#### Returns: number offsetValue<br>

## getOffset
returns the current offset

```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aDropdown = mainFrame:addDropdown("myFirstDropdown"):show()
aDropdown:addItem("1. Entry")
aDropdown:addItem("2. Entry",colors.yellow)
aDropdown:addItem("3. Entry",colors.yellow,colors.green)
aDropdown:getOffset()
```
#### Parameters: -<br>
#### Returns: number offsetValue<br>

## setDropdownSize
sets the dropdown size (if you click on the button)

```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aDropdown = mainFrame:addDropdown("myFirstDropdown"):show()
aDropdown:addItem("1. Entry")
aDropdown:addItem("2. Entry",colors.yellow)
aDropdown:addItem("3. Entry",colors.yellow,colors.green)
aDropdown:setDropdownSize(12, 4)
```
#### Parameters: number width, number height<br>
#### Returns: self<br>