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
1. `string` text
2. `number` index

#### Returns:
1. `object` The object in use

#### Usage:
* Adds a line
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aTextfield = mainFrame:addTextfield("myFirstTextfield"):show()
basalt.debug(aTextfield:addLine("Hello!", 1))
```
```xml
<textfield>
    <lines>
        <line>Hello!</line>
    </lines>
</textfield>
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

## addKeywords
Adds keywords for special coloring

#### Parameteres:
1. `number|color` color of your choice
2. `table` a list of keywords which should be colored example: {"if", "else", "then", "while", "do"}

#### Returns:
1. `object` The object in use

#### Usage:
* Changes the color of some words to purple
```lua
local mainFrame = basalt.createFrame()
local aTextfield = mainFrame:addTextfield():addKeywords(colors.purple, {"if", "else", "then", "while", "do", "hello"})
```
```xml
<textfield>
    <keywords>
        <purple>
            <keyword>if</keyword>
            <keyword>else</keyword>
            <keyword>then</keyword>
            <keyword>while</keyword>
            <keyword>do</keyword>
            <keyword>hello</keyword>
        </purple>
    </keywords>
</textfield>
```

## addRule
Adds a new rule for special coloring

#### Parameteres:
1. `string` a pattern - check out this page: (https://riptutorial.com/lua/example/20315/lua-pattern-matching)
2. `number|color` text color
3. `number|color` background color - optional

#### Returns:
1. `object` The object in use

#### Usage:
* Changes the color of all numbers
```lua
local mainFrame = basalt.createFrame()
local aTextfield = mainFrame:addTextfield():addRule("%d", colors.lightBlue)
```
```xml
<textfield>
    <rules>
        <rule>
            <pattern>%d</pattern>
            <fg>lightBlue</fg>
        </rule>
    </rules>
</textfield>
```