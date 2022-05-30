# Dropdown

Dropdowns are objects where you can create endless entrys the user can click on a button and it opens a "list" where the user can choose a entry

Here is a example of how to create a standard dropdown:

````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aDropdown = mainFrame:addDropdown("myFirstDropdown"):show()
````

Here are all possible functions available for dropdowns: <br>
Remember dropdown inherits from [object](https://github.com/NoryiE/basalt/wiki/Object):

## addItem
Adds a item to the dropdown

````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aDropdown = mainFrame:addDropdown("myFirstDropdown"):show()
aDropdown:addItem("1. Entry")
aDropdown:addItem("2. Entry",colors.yellow)
aDropdown:addItem("3. Entry",colors.yellow,colors.green)
````
**parameters:** string text, number bgcolor, number fgcolor, any ... - (text is the displayed text, bgcolor and fgcolors the colors of background/text and args (...) is something dynamic, you wont see them but if you require some more information per item you can use that)<br>
**returns:** self<br>

## removeItem
Removes a item from the dropdown

````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aDropdown = mainFrame:addDropdown("myFirstDropdown"):show()
aDropdown:addItem("1. Entry")
aDropdown:addItem("2. Entry",colors.yellow)
aDropdown:addItem("3. Entry",colors.yellow,colors.green)
aDropdown:removeItem(2)
````
**parameters:** number index<br>
**returns:** self<br>

## editItem
Edits a item on the dropdown

````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aDropdown = mainFrame:addDropdown("myFirstDropdown"):show()
aDropdown:addItem("1. Entry")
aDropdown:addItem("2. Entry",colors.yellow)
aDropdown:addItem("3. Entry",colors.yellow,colors.green)
aDropdown:editItem(3,"3. Edited Entry",colors.yellow,colors.green)
````
**parameters:** number index, string text, number bgcolor, number fgcolor, any ...<br>
**returns:** self<br>

## setScrollable
Makes the dropdown scrollable

````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aDropdown = mainFrame:addDropdown("myFirstDropdown"):show()
aDropdown:addItem("1. Entry")
aDropdown:addItem("2. Entry",colors.yellow)
aDropdown:addItem("3. Entry",colors.yellow,colors.green)
aDropdown:setScrollable(true)
````
**parameters:** boolean isScrollable<br>
**returns:** self<br>

## selectItem
selects a item in the dropdown (same as a player would click on a item)

````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aDropdown = mainFrame:addDropdown("myFirstDropdown"):show()
aDropdown:addItem("1. Entry")
aDropdown:addItem("2. Entry",colors.yellow)
aDropdown:addItem("3. Entry",colors.yellow,colors.green)
aDropdown:selectItem(1)
````
**parameters:** number index<br>
**returns:** self<br>

## clear
clears the entire list (dropdown)

````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aDropdown = mainFrame:addDropdown("myFirstDropdown"):show()
aDropdown:addItem("1. Entry")
aDropdown:addItem("2. Entry",colors.yellow)
aDropdown:addItem("3. Entry",colors.yellow,colors.green)
aDropdown:clear()
````
**parameters:** -<br>
**returns:** self<br>

## getItemIndex
returns the item index of the currently selected item

````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aDropdown = mainFrame:addDropdown("myFirstDropdown"):show()
aDropdown:addItem("1. Entry")
aDropdown:addItem("2. Entry",colors.yellow)
aDropdown:addItem("3. Entry",colors.yellow,colors.green)
aDropdown:getItemIndex()
````
**parameters:** -<br>
**returns:** number index<br>

## setSelectedItem
Sets the background of the item which is currently selected

````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aDropdown = mainFrame:addDropdown("myFirstDropdown"):show()
aDropdown:addItem("1. Entry")
aDropdown:addItem("2. Entry",colors.yellow)
aDropdown:addItem("3. Entry",colors.yellow,colors.green)
aDropdown:setSelectedItem(colors.green, colors.blue)
````
**parameters:** number bgcolor, number fgcolor, boolean isActive (isActive means if different colors for selected item should be used)<br>
**returns:** self<br>

## setOffset
sets the dropdown offset (will automatically change if scrolling is active)

````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aDropdown = mainFrame:addDropdown("myFirstDropdown"):show()
aDropdown:addItem("1. Entry")
aDropdown:addItem("2. Entry",colors.yellow)
aDropdown:addItem("3. Entry",colors.yellow,colors.green)
aDropdown:setOffset(3)
````
**parameters:** number offsetValue<br>
**returns:** self<br>

## getOffset
returns the current offset

````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aDropdown = mainFrame:addDropdown("myFirstDropdown"):show()
aDropdown:addItem("1. Entry")
aDropdown:addItem("2. Entry",colors.yellow)
aDropdown:addItem("3. Entry",colors.yellow,colors.green)
aDropdown:getOffset()
````
**parameters:** -<br>
**returns:** number offsetValue<br>

## getOffset
returns the current offset

````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aDropdown = mainFrame:addDropdown("myFirstDropdown"):show()
aDropdown:addItem("1. Entry")
aDropdown:addItem("2. Entry",colors.yellow)
aDropdown:addItem("3. Entry",colors.yellow,colors.green)
aDropdown:getOffset()
````
**parameters:** -<br>
**returns:** number offsetValue<br>

## setDropdownSize
sets the dropdown size (if you click on the button)

````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aDropdown = mainFrame:addDropdown("myFirstDropdown"):show()
aDropdown:addItem("1. Entry")
aDropdown:addItem("2. Entry",colors.yellow)
aDropdown:addItem("3. Entry",colors.yellow,colors.green)
aDropdown:setDropdownSize(12, 4)
````
**parameters:** number width, number height<br>
**returns:** self<br>