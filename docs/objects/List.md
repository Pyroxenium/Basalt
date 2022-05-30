# List

Lists are objects where you can create endless entrys and the user can choose one of them

Here is a example of how to create a standard list:

````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aList = mainFrame:addList("myFirstList"):show()
````

This will create a default list with the size 8 width and 5 height on position 1 1 (relative to its parent frame), the default background is colors.lightGray, the default text color is colors.black and the default zIndex is 5. The default horizontal text align is "center", default symbol is ">"

Here are all possible functions available for lists. Remember list inherit from [object](/objects/Object):

## addItem
Adds a item to the list

````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aList = mainFrame:addList("myFirstList"):show()
aList:addItem("1. Entry")
aList:addItem("2. Entry",colors.yellow)
aList:addItem("3. Entry",colors.yellow,colors.green)
````
**parameters:** string text, number bgcolor, number fgcolor, any ... - (text is the displayed text, bgcolor and fgcolors the colors of background/text and args (...) is something dynamic, you wont see them but if you require some more information per item you can use that)<br>
**returns:** self<br>

## removeItem
Removes a item from the list

````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aList = mainFrame:addList("myFirstList"):show()
aList:addItem("1. Entry")
aList:addItem("2. Entry",colors.yellow)
aList:addItem("3. Entry",colors.yellow,colors.green)
aList:removeItem(2)
````
**parameters:** number index<br>
**returns:** self<br>

## editItem
Edits a item on the list

````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aList = mainFrame:addList("myFirstList"):show()
aList:addItem("1. Entry")
aList:addItem("2. Entry",colors.yellow)
aList:addItem("3. Entry",colors.yellow,colors.green)
aList:editItem(3,"3. Edited Entry",colors.yellow,colors.green)
````
**parameters:** number index, string text, number bgcolor, number fgcolor, any ...<br>
**returns:** self<br>

## setScrollable
Makes the list scrollable

````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aList = mainFrame:addList("myFirstList"):show()
aList:addItem("1. Entry")
aList:addItem("2. Entry",colors.yellow)
aList:addItem("3. Entry",colors.yellow,colors.green)
aList:setScrollable(true)
````
**parameters:** boolean isScrollable<br>
**returns:** self<br>

## selectItem
selects a item in the list (same as a player would click on a item)

````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aList = mainFrame:addList("myFirstList"):show()
aList:addItem("1. Entry")
aList:addItem("2. Entry",colors.yellow)
aList:addItem("3. Entry",colors.yellow,colors.green)
aList:selectItem(1)
````
**parameters:** number index<br>
**returns:** self<br>

## clear
clears the entire list

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
local aList = mainFrame:addList("myFirstList"):show()
aList:addItem("1. Entry")
aList:addItem("2. Entry",colors.yellow)
aList:addItem("3. Entry",colors.yellow,colors.green)
aList:setSelectedItem(colors.green, colors.blue)
````
**parameters:** number bgcolor, number fgcolor, boolean isActive (isActive means if different colors for selected item should be used)<br>
**returns:** self<br>

## setOffset
sets the list offset (will automatically change if scrolling is active)

````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aList = mainFrame:addList("myFirstList"):show()
aList:addItem("1. Entry")
aList:addItem("2. Entry",colors.yellow)
aList:addItem("3. Entry",colors.yellow,colors.green)
aList:setOffset(3)
````
**parameters:** number offsetValue<br>
**returns:** self<br>

## getOffset
returns the current offset

````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aList = mainFrame:addList("myFirstList"):show()
aList:addItem("1. Entry")
aList:addItem("2. Entry",colors.yellow)
aList:addItem("3. Entry",colors.yellow,colors.green)
aList:getOffset()
````
**parameters:** -<br>
**returns:** number offsetValue<br>