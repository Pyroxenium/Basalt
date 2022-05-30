# Basalt

Basalt is managing all the things.

To start using Basalt you have to do the following line of code:

`local basalt = dofile("basalt.lua")`

remember you need the basalt.lua file on your computer!

Now you are able to call all these functions:

## basalt.createFrame
create a frame without a parent
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
````
**parameters:** string name<br>
**returns:** new frame object<br>

## basalt.removeFrame
removes a frame (only possible for non-parent frames)
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
basalt.removeFrame("myFirstFrame")
````
**parameters:** string name<br>
**returns:**-<br>

## basalt.getFrame
With that function you can get frames, but only frames without a parent!
````lua
basalt.createFrame("myFirstFrame")
basalt.getFrame("myFirstFrame"):show()
````
**parameters:** string name<br>
**returns:** frame object<br>

## basalt.getActiveFrame
returns the currently active (without a parent) frame
````lua
basalt.createFrame("myFirstFrame"):show()
basalt.debug(basalt.getActiveFrame():getName()) -- returns myFirstFrame
````
**parameters:** -<br>
**returns:** frame object<br>

## basalt.autoUpdate
starts the draw and event handler until you use basalt.stopUpdate
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
basalt.autoUpdate()
````
**parameters:** -<br>
**returns:**-<br>

## basalt.update
calls the draw and event handler method once
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
basalt.autoUpdate()
````
**parameters:** string event, ... (you can use some paramters here. you dont have to pass any paramters )<br>
**returns:**-<br>

## basalt.stopUpdate
stops the draw and event handler
````lua
basalt.stopUpdate()
````
**parameters:** -<br>
**returns:**-<br>

## basalt.debug
creates a label with some information on the main frame on the bottom left, if you click on that label it will open a log view for you see it as the new print for debugging
````lua
basalt.debug("Hi i am cute")
````
**parameters:** ... (multiple parameters are possible, like print does)<br>
**returns:**-<br>