After downloading the project, you can finally start creating your own program and using Basalt. The first thing you will want to use in your program is always:

```lua
local basalt = require("basalt")
```

It doesn't matter if you are using the source folder or the minified/packed version of Basalt. Both can be found using require("basalt") without the .lua extension.

To actually start using Basalt, you should include the following line at the bottom of your program:

```lua
basalt.autoUpdate()
```

This will start the event listener and the draw handler.

## Example

Here is a fully functional example of how a program could look:

```lua
local basalt = require("basalt") --> Load the Basalt framework into the variable "basalt"

--> Now we want to create a base frame, we call the variable "main" - by default everything you create is visible (you don't need to use :show())
local main = basalt.createFrame()

local button = mainFrame:addButton() --> Here we add our first button
button:setPosition(4, 4) -- Of course we want to change the default position of our button
button:setSize(16, 3) -- And the default size.
button:setText("Click me!") --> This method displays what the text of our button should look like

local function buttonClick() --> Let us create a function we want to call when the button gets clicked 
    basalt.debug("I got clicked!")
end

-- Now we just need to register the function to the button's onClick event handlers, this is how we can achieve that:
button:onClick(buttonClick)


basalt.autoUpdate() -- As soon as we call basalt.autoUpdate, the event and draw handlers will listen for any incoming events (and draw if necessary)
```

If you're like us and strive for succinct and beautiful code, here is a cleaner implementation of the code above:

```lua
local basalt = require("basalt")

local main = basalt.createFrame()
local button = main --> Basalt returns an instance of the object on most methods, to make use of "call-chaining"
        :addButton() --> This is an example of call chaining
        :setPosition(4,4) 
        :setText("Click me!")
        :onClick(
            function() 
                basalt.debug("I got clicked!") 
            end)

basalt.autoUpdate()
```
