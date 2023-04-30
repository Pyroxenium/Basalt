## getTextCursor

### Description

Gets the current text cursor position within the Textfield object.

### Returns

1. `number` x position - The X (horizontal) position of the text cursor
2. `number` y position - The Y (vertical) position of the text cursor

### Usage

* Retrieves and prints the text cursor position in a Textfield:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame():show()
local aTextfield = mainFrame:addTextfield():show()

local x, y = aTextfield:getTextCursor()
basalt.debug("Text cursor position: X:", x, "Y:", y)

basalt.autoUpdate()
```

In this example, a Textfield object is created and added to the mainFrame. The `getTextCursor` method is then called to retrieve the current text cursor position as X and Y coordinates, which are then printed using `basalt.debug`.
