Here i will explain to you how you can add some coloring to your buttons in certain events. This is not only for buttons possible but also for all the other visual objects

But first, i want to explain to you that you can also add the same event-type multiple times:
```lua
local function buttonColoring(self, event, button, x, y)
-- here you can add some coloring for your button - for example:
    self:setBackground(colors.black)
end
local function buttonLogic(self, event, button, x, y)
-- here you can add some logic for your button
    basalt.debug("Some logic")
end
local button = main:addButton()
button:onClick(buttonColoring):onClick(buttonLogic) -- yes this would work, if not its a bug!
```
This means you can create a function wich handles only the coloring side of your button, and if your button also needs some logic you just create another function for that and add it to your button.


Now let's create a function where we pass a button object as an argument on which we set up the coloring
```lua
local basalt = require("basalt")
local main = basalt.createFrame()
local button = main:addButton()
            :setPosition(3,3)
            :setSize(12,3)
            :setText("Click me")
            :setBackground(colors.gray)
            :setForeground(colors.black)

local button2 = main:addButton()
            :setPosition(25,3)
            :setSize(16,3)
            :setText("Another Btn")
            :setBackground(colors.gray)
            :setForeground(colors.black)

local function setupButtonColoring(self, event, button, x, y)
    self:onClick(function() 
        self:setBackground(colors.black) 
        self:setForeground(colors.lightGray) 
    end)
    self:onClickUp(function() 
        self:setBackground(colors.gray) 
        self:setForeground(colors.black) 
    end)
    self:onLoseFocus(function() 
        self:setBackground(colors.gray) 
        self:setForeground(colors.black) 
    end)
end

setupButtonColoring(button)
setupButtonColoring(button2)

basalt.autoUpdate()
```

Now you got a button which changes the color when you click on it.


There is also another way of doing it, but this is time based, which means it does not check if the user is holding the mousebutton down.
```lua
local basalt = require("basalt")

local main = basalt.createFrame()
local button = main:addButton()
    :setPosition(3,3)
    :setSize(12,3)
    :setText("Click me")
    :setBackground(colors.gray)
    :setForeground(colors.black)

button:onClick(basalt.schedule(function()
    button:setBackground(colors.black)
    sleep(0.5)
    button:setBackground(colors.gray)
    end))
```

Here you are using basalt.schedule, which will start the function in a coroutine