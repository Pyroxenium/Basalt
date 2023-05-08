Dynamic Values is a way to position or size your object based on the position/size of other objects. This makes it pretty easy to create programs where the terminal size
doesn't matter.

A dynamic value is always a string, and you can add anything you want in there. Here are some examples:<br>
"5 + 2"<br>
"(5 + 2) * 3"<br>
"math.floor(5+2.2)"<br>
"objectid.x + objectid.y + objectid.w + objectid+h"<br>
"parent.w"<br>
"self.w"<br>

Parent always refers to it's parent object, self always refers to itself.

## Positioning
Here i will show you a example on how to position a button next to another button, doesn't matter which size it has.

```lua
local basalt = require("basalt")

local main = basalt.createFrame()

local button = main:addButton("firstBtn")
    :setBackground(colors.black)
    :setForeground(colors.lightGray)
    :setPosition(2, 2)
local button2 = main:addButton()
    :setBackground(colors.black)
    :setForeground(colors.lightGray)
    :setPosition("firstBtn.w + firstBtn.x + 2", "firstBtn.y")

basalt.autoUpdate()
```
Now, you can move the first button and the second button would also move. Doesn't matter how.

## Sizing
This is a example on how you can create buttons where the size is always based on it's parent frame
```lua
local basalt = require("basalt")

local main = basalt.createFrame()

local button = main:addButton("firstBtn")
    :setBackground(colors.black)
    :setForeground(colors.lightGray)
    :setPosition(2, 2)
    :setSize("parent.w - 2", 3)
local button2 = main:addButton()
    :setBackground(colors.black)
    :setForeground(colors.lightGray)
    :setPosition(2, "firstBtn.y + firstBtn.h + 1")
    :setSize("parent.w - 2", 3)

basalt.autoUpdate()
```