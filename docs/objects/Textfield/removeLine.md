## removeLine

### Description

Removes the line at the specified index position within the Textfield object.

### Parameteres

1. `number` index - The index of the line you want to remove

### Returns

1. `object` The object in use

### Usage

* Removes a line

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local aTextfield = mainFrame:addTextfield()

aTextfield:addLine("Line to be removed", 1)
aTextfield:addLine("Line that stays", 2)

basalt.debug("Before removing the line:")
basalt.debug(aTextfield:getLines())
for k,v in pairs(aTextfield:getLines())do
    basalt.debug(v)
end

aTextfield:removeLine(1)

basalt.debug("After removing the line:")
for k,v in pairs(aTextfield:getLines())do
    basalt.debug(v)
end

basalt.autoUpdate()
```

In this example, a Textfield object is created and added to the mainFrame. Two lines are added to the Textfield, then the `removeLine` method is called to remove the first line by specifying its index. The `getLines` method is used to print the lines before and after the removal.
