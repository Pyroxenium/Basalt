## getLines

### Description

Returns all lines in a Textfield object as a table.

### Returns

1. `table` lines - A table containing all the lines in the Textfield

### Usage

* Retrieves and prints all lines in a Textfield:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local aTextfield = mainFrame:addTextfield()

aTextfield:addLine("Hello, world!", 1)
aTextfield:addLine("This is a test.", 2)

local allLines = aTextfield:getLines()
basalt.debug(allLines)

basalt.autoUpdate()
```

In this example, a Textfield object is created and added to the mainFrame. Two lines with content "Hello, world!" and "This is a test." are added at index positions 1 and 2, respectively. The `getLines` method is then called to retrieve all lines in the Textfield as a table, which is then printed using `basalt.debug`.
