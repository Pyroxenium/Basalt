# Textfield

Textfields are objects, where the user can write something on multiple lines. it act's like the default edit script (without coloring)<br>
Here is a example of how to create a default textfield:

````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aTextfield = mainFrame:addTextfield("myFirstTextfield"):show()
````

This will create a default textfield with the size 10 width and 4 height on position 1 1 (relative to its parent frame), the default background is colors.gray, the default text color is colors.black and the default zIndex is 5.

A list of all possible functions available for textfields. Remember textfield inherits from [object](https://github.com/NoryiE/NyoUI/wiki/Object):


## getLines
returns all lines
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aTextfield = mainFrame:addTextfield("myFirstTextfield"):show()
basalt.debug(aTextfield:getLines())
````
**parameters:** -<br>
**returns:** table lines<br>

## getLine
returns the line on index position
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aTextfield = mainFrame:addTextfield("myFirstTextfield"):show()
basalt.debug(aTextfield:getLine(2))
````
**parameters:** number index<br>
**returns:** string line<br>

## editLine
edits line on index position
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aTextfield = mainFrame:addTextfield("myFirstTextfield"):show()
aTextfield:editLine(2, "hellow")
````
**parameters:** number index, string text<br>
**returns:** self<br>

## addLine
adds a line on index position (if index is nil it just adds the line on the bottom)
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aTextfield = mainFrame:addTextfield("myFirstTextfield"):show()
aTextfield:addLine("hellow")
````
**parameters:** string text, number index<br>
**returns:** self<br>

## removeLine
removes the line on index position
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aTextfield = mainFrame:addTextfield("myFirstTextfield"):show()
aTextfield:removeLine(1)
````
**parameters:** number index<br>
**returns:** self<br>

## getTextCursor
returns the cursor position
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aTextfield = mainFrame:addTextfield("myFirstTextfield"):show()
basalt.debug(aTextfield:getTextCursor())
````
**parameters:** -<br>
**returns:** number x, number y<br>