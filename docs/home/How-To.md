# How-To

After downloading the project, you can start creating your own program and use Basalt. The first thing you want to include in your program is always:

```lua
local basalt = require("basalt")
```

It doesn't matter if you're using the source folder or the minified/packed version of Basalt. Both can be found by using require("basalt") without .lua.

To run Basalt, you should use:

```lua
basalt.autoUpdate()
```

This should be placed at the bottom of your program. basalt.autoUpdate() starts the event listener and the draw handler.

## Example

Here's a fully working example of how a program could look like:

```lua
local basalt = require("basalt") --> Load the Basalt framework into the variable called "basalt"

--> Now we want to create a base frame, we call the variable "main" - by default everything you create is visible. (you don't need to use :show())
local main = basalt.createFrame()

local button = main:addButton() --> Here we add our first button
button:setPosition(4, 4) -- We want to change the default position of our button
button:setSize(16, 3) -- And the default size.
button:setText("Click me!") --> This method sets the text displayed on our button

local function buttonClick() --> Create a function we want to call when the button gets clicked 
    basalt.debug("I got clicked!")
end

-- Now we just need to register the function to the button's onClick event handlers, this is how we can achieve that:
button:onClick(buttonClick)

basalt.autoUpdate() -- As soon as we call basalt.autoUpdate, the event and draw handlers will listen to any incoming events (and draw if necessary)
```

If you strive for succinct and beautiful code, here's a cleaner implementation of the code above:

```lua
local basalt = require("basalt")

local main = basalt.createFrame()
local button = main --> Basalt returns an instance of the object on most methods, to make use of "call-chaining"
        :addButton() --> This is an example of call chaining
        :setPosition(4, 4)
        :setText("Click me!")
        :onClick(
            function()
                basalt.debug("I got clicked!")
            end)

basalt.autoUpdate()
```
