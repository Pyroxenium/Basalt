## getLine

### Description

Returns the content of a line at the specified index position in a Textfield object.

### Parameteres

1. `number` index - The position of the line you want to retrieve

### Returns

1. `string` line - The content of the line at the specified index

### Usage

* Retrieves and prints the content of a line at a specific index:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local aTextfield = mainFrame:addTextfield()

aTextfield:addLine("Hello, world!", 1)

local lineContent = aTextfield:getLine(1)
basalt.debug(lineContent)

basalt.autoUpdate()
```

In this example, a Textfield object is created and added to the mainFrame. A line with the content "Hello, world!" is added at index position 1. The `getLine` method is then called to retrieve the content of the line at index 1, which is then printed using `basalt.debug`.
