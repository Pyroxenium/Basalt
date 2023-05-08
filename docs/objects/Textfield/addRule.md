## addRule

### Description

Adds a new rule for special coloring in a Textfield object. This allows you to apply a specific color and/or background color to text matching a provided pattern.

### Parameteres

1. `string` pattern - A Lua pattern for matching the text you want to color. You can find more information about Lua patterns [here](https://riptutorial.com/lua/example/20315/lua-pattern-matching).
2. `number|color` textColor - The color you want to apply to the text matching the pattern
3. `number|color` backgroundColor - (optional) The background color you want to apply to the text matching the pattern

### Returns

1. `object` The object in use

### Usage

* Changes the color of all numbers in a Textfield object

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local aTextfield = mainFrame:addTextfield()

aTextfield:addRule("%d", colors.lightBlue)

basalt.autoUpdate()
```

In this example, a Textfield object is created and added to the mainFrame. The `addRule` method is called to add a rule that highlights all numbers with a light blue color. The pattern used for matching numbers is `%d`.

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
