## addKeywords

### Description

Adds keywords for special coloring in a Textfield object. This allows you to highlight specific words with a chosen color.

### Parameteres

1. `number|color` color - The color you want to apply to the keywords
2. `table` keywords - A list of keywords that should be colored, for example: {"if", "else", "then", "while", "do", "hello"}

### Returns

1. `object` The object in use

### Usage

* Changes the color of specific words to purple in a Textfield object:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local aTextfield = mainFrame:addTextfield()

aTextfield:addKeywords(colors.purple, {"if", "else", "then", "while", "do", "hello"})

basalt.autoUpdate()
```

In this example, a Textfield object is created and added to the mainFrame. The addKeywords method is called to add a list of keywords to be highlighted in purple color. The specified keywords are "if", "else", "then", "while", "do", and "hello".

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
