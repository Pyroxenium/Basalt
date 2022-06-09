Basalt aims to be a relatively small, easy to use framework. 

Accordingly, we have provided an installation script.


Just use the following command in any CC:Tweaked shell:

`pastebin run ESs1mg7P`

This will download `basalt.lua` to your local directory

To load the framework, make use of the following snippet
```lua
--> For those who are unfamiliar with lua, dofile executes the code in the referenced file
local basalt = dofile("basalt.lua")
```



Here is a fully functioning example of Basalt code

```lua
local basalt = dofile("basalt.lua") --> Load the Basalt framework

--> Create the first frame. Please note that Basalt needs at least one active "non-parent" frame to properly supply events
--> When Basalt#createFrame makes use of unique identifiers (commonly referred to as UIDs), meaning that the supplied value must be UNIQUE
--> If the supplied UID is ambiguous, Basalt#createFrame returns a nil value
local mainFrame = basalt.createFrame("mainFrame")

--> Show the frame to the user
mainFrame:show()

local button = mainFrame:addButton("clickableButton") --> Add a button to the mainFrame (With a unique identifier)

--> Set the position of the button, Button#setPosition follows an x, y pattern. 
--> The x value is how far right the object should be from its anchor (negative values from an anchor will travel left)
--> The y value is how far down the object should be from its anchor (negative values from an anchor will travel up)
button:setPosition(4, 4)

button:setText("Click me!") --> Set the text of our button

local function buttonClick() --> This function serves as our click logic 
    basalt.debug("I got clicked!")
end

--> Remember! You cannot supply buttonClick(), that will only supply the result of the function
--> Make sure the button knows which function to call when it's clicked
button:onClick(buttonClick)

button:show() --> Make the button visible, so the user can click it

basalt.autoUpdate() --> Basalt#autoUpdate starts the event listener to detect user input
```
If you're like us and strive for succinct and beautiful code, here is a cleaner implementation of the code above:
```lua
local basalt = dofile("basalt.lua")

local mainFrame = basalt.createFrame("mainFrame"):show()
local button = mainFrame --> Basalt returns an instance of the object on most methods, to make use of "call-chaining"
        :addButton("clickableButton") --> This is an example of call chaining
        :setPosition(4,4) 
        :setText("Click me!")
        :onClick(
            function() 
                basalt.debug("I got clicked!") 
            end)
        :show()

basalt.autoUpdate()
```