## editLine

### Description

Edits the content of a line at the specified index position in a Textfield object.

### Parameteres

1. `number` index - The position of the line you want to edit
2. `string` text - The new content you want to set for the line

### Returns

1. `object` The object in use

### Usage

* Edits the content of a line at a specific index:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local aTextfield = mainFrame:addTextfield()

aTextfield:addLine("Original text", 1)
aTextfield:editLine(1, "Hello!")

basalt.autoUpdate()
```

In this example, a Textfield object is created and added to the mainFrame. A line with the content "Original text" is added at index position 1. The `editLine` method is then called to update the content of the line at index 1 to "Hello!".
