Here I want to explain to you how you would create a button with the default color gray, and as long as the user is clicking on the button it will change its color to black (the default frame-background is lightGray).

To make this possible the button needs 1 onClick event, 1 onClickUp event and 1 onLoseFocus event.

Very interesting sidetip: events can hold multiple functions!<br>
**Example snippet:**
```lua
local function buttonColoring()
-- here you can add some coloring for your button
end
local function buttonLogic()
-- here you can add some logic for your button
end
local button = mainFrame:addButton("ExampleButton"):show()
button:onClick(buttonColoring):onClick(buttonLogic) -- yes this would work, if not its a bug!
```

This means you can create a function wich handles only the coloring side of your button, and if your button also needs some logic you just create your own unique function for that and add it to your button.

With this knowledge we create now a function where we pass a button-object as parameter and this will setup the coloring of our button:

**Example snippet:**
```lua
local basalt = dofile("basalt.lua")
local mainFrame = basalt.createFrame("mainFrame"):show()
local button = mainFrame:addButton("firstButton"):setPosition(3,3):setSize(12,3):setText("Click me"):setBackground(colors.gray):setForeground(colors.black):show()

local button2 = mainFrame:addButton("secondButton"):setPosition(25,3):setSize(16,3):setText("Another Btn"):setBackground(colors.gray):setForeground(colors.black):show()

local function setupButtonColoring(btn)
btn:onClick(function() btn:setBackground(colors.black) btn:setForeground(colors.lightGray) end)
btn:onClickUp(function() btn:setBackground(colors.gray) btn:setForeground(colors.black) end)
btn:onLoseFocus(function() btn:setBackground(colors.gray) btn:setForeground(colors.black) end)
end
setupButtonColoring(button)
setupButtonColoring(button2)

basalt.autoUpdate()
```

Now you've got a function which sets your buttons up.