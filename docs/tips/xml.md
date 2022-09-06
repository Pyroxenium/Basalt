This is a basic guide on how to create a UI with XML.

In XML you are not able to create logic, but you could refer to logic - i will show you how.
But first i will show you how you are able to create some basic XML design.

First we will need a .lua file - we need to process the XML stuff, and this is only possible in lua.
So let's create a lua file:

```lua
local basalt = require("basalt") -- as always we will need basalt

local main = basalt.createFrame() -- and atleast 1 base frame is needed

basalt.autoUpdate() -- starting the event and draw handler is also needed
```

The code above you are just not able to do in XML, you are not able to create base frames and you are also not able to start the event/draw handlers.
This can only be done in Lua.

In Basalt XML Code will always be loaded into frames. Which means all the objects created in XML are always childrens of that particular frame. Here is a example to show what i mean:

Lua:
```lua
local basalt = require("basalt")
local main = basalt.createFrame():addLayout("example.xml")
basalt.autoUpdate()
```

XML:
```xml
<button x="5" y="3" text="Hello" />
```

This would be exactly the same like if you would use the following lua code:
```lua
local basalt = require("basalt")
local main = basalt.createFrame()
main:addButton():setPosition(5, 3):setText("Hello")
basalt.autoUpdate()
```

You can also add a layout multiple times, or create multiple frames and always use the same layout. For example a design layout for more frames and then you could also use
a unique layout for each frame. I wont show you a example, you just have to use :addLayout multiple times on different frames.

Another thing is, you could add/load XML files IN XML:
example.xml:
```xml
<frame layout="anotherExample.xml" />
```

anotherExample.xml:
```xml
<button x="2" y="3" width="parent.w - 2" text="Greetings" />
```

# Events

Using events in XML is also pretty simple. For that basalt has a function called basalt.setVariable. This is to store functions or other things which you can access via
XML. Obviously the logic you want to add has to be done in lua, here:

Lua:
```lua
local basalt = require("basalt")

basalt.setVariable("buttonClick", function()
    basalt.debug("i got clicked!")
end)

local main = basalt.createFrame():addLayout("example.xml")
basalt.autoUpdate()
```

And then you just have to link your function in your XML file:
```xml
<button x="2" y="3" width="parent.w - 2" text="Greetings" onClick="buttonClick" />
```

This is pretty simple! BUT there is one thing you shouldn't forget: In Lua you always have to create the function's before you want to access it, which means
always use basalt.setVariable before you use frame:addLayout() - otherwise basalt is not able to find the function