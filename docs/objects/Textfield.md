Textfields are objects, where the user can write something on multiple lines. it act's like the default edit script (without coloring)<br>

Remember textfield inherits from [Object](objects/Object.md)

## getLines
Returns all lines

#### Returns:
1. `table` lines

#### Usage:
* Prints all lines
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aTextfield = mainFrame:addTextfield("myFirstTextfield"):show()
basalt.debug(aTextfield:getLines())
```

## getLine
Returns the line on index position

#### Parameteres:
1. `number` index

#### Returns:
1. `string` line

#### Usage:
* Prints one line
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aTextfield = mainFrame:addTextfield("myFirstTextfield"):show()
basalt.debug(aTextfield:getLine(1))
```

## editLine
Edits the line on index position

#### Parameteres:
1. `number` index
2. `string` text

#### Returns:
1. `object` The object in use

#### Usage:
* Edits the line
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aTextfield = mainFrame:addTextfield("myFirstTextfield"):show()
basalt.debug(aTextfield:editLine(1, "Hello!"))
```

## addLine
Adds a line on index position

#### Parameteres:
1. `number` index
2. `string` text

#### Returns:
1. `object` The object in use

#### Usage:
* Adds a line
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aTextfield = mainFrame:addTextfield("myFirstTextfield"):show()
basalt.debug(aTextfield:addLine(1, "Hello!"))
```

## removeLine
Removes the line on index position

#### Parameteres:
1. `number` index
2. `string` text

#### Returns:
1. `object` The object in use

#### Usage:
* Removes a line
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aTextfield = mainFrame:addTextfield("myFirstTextfield"):show()
basalt.debug(aTextfield:removeLine())
```

## getTextCursor
Gets text cursor position

#### Returns:
1. `number` x position
2. `number` y position
