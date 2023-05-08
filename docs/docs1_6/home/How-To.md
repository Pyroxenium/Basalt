# How-To

After downloading the project you can finally start creating your own program and use basalt. The first thing you want to use in your program is always:

```lua
local basalt = require("basalt")
```

It doesn't matter if you're using the source folder or the minified/packed version of basalt. Both can be found by using require("basalt") without .lua.

Also to really run basalt you should use

```lua
basalt.autoUpdate()
```

somewhere on the bottom of your program. basalt.autoUpdate() starts the event listener and the draw handler.

## Example

Here is a fully working example of how a program could look like:

```lua
local basalt = require("basalt") --> Load the basalt framework into the variable called "basalt"

--> Now we want to create a base frame, we call the variable "main" - by default everything you create is visible. (you don't need to use :show())
local main = basalt.createFrame()

local button = main:addButton() --> Here we add our first button
button:setPosition(4, 4) -- of course we want to change the default position of our button
button:setSize(16, 3) -- and the default size.
button:setText("Click me!") --> This method displays what the text of our button should look like

local function buttonClick() --> Let us create a function we want to call when the button gets clicked 
    basalt.debug("I got clicked!")
end

-- Now we just need to register the function to the buttons onClick event handlers, this is how we can achieve that:
button:onClick(buttonClick)


basalt.autoUpdate() -- As soon as we call basalt.autoUpdate, the event and draw handlers will listen to any incomming events (and draw if necessary)
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
