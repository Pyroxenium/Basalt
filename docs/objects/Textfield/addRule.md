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