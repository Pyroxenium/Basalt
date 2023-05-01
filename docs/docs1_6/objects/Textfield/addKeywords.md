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