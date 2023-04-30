## addLine

### Description

Adds a line to a Textfield object at a specified index position.

### Parameteres

1. `string` text - The text you want to add as a new line
2. `number` Optional - The position at which the new line should be added

### Returns

1. `object` The object in use

### Usage

* Adds a line

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame("myFirstFrame")
local aTextfield = mainFrame:addTextfield("myFirstTextfield")

aTextfield:addLine("Hello, world!", 1)

basalt.autoUpdate()
```

In this example, a Textfield object is created and added to the mainFrame. The addLine method is then called to add a new line containing the text "Hello, world!" at the specified index position (1 in this case).

```xml
<textfield>
    <lines>
        <line>Hello!</line>
    </lines>
</textfield>
```
