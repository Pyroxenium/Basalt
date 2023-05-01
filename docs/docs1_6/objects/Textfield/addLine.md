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