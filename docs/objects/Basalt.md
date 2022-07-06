To start using Basalt you have to do the following line of code:

`local basalt = require("Basalt")`

remember you need the basalt.lua file on your computer!

Now you are able to use the following functions:

## basalt.createFrame
Create a base-frame (main frame)
#### Parameters: 
1. `string` name

#### Returns: 
1. `frame` object

#### Usage:
* Create and show a frame with id "myFirstFrame"
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
```

## basalt.removeFrame
Removes a base frame

#### Parameters: 
1. `string` name

#### Usage:
* Removes the previously created frame with id "myFirstFrame" 
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
basalt.removeFrame("myFirstFrame")
```

## basalt.getFrame
Returns a base frame with the given name
#### Parameters: 
1. `string` name

#### Returns: 
1. `frame` object

#### Usage:
* Creates, fetches and shows the "myFirstFrame" object
```lua
basalt.createFrame("myFirstFrame")
basalt.getFrame("myFirstFrame"):show()
```


## basalt.getActiveFrame
Returns the currently active base frame

#### Returns: 
1. `frame` The current frame

#### Usage:
* Displays the active frame name in the debug console
```lua
basalt.createFrame("myFirstFrame"):show()
basalt.debug(basalt.getActiveFrame():getName()) -- returns myFirstFrame
```

## basalt.autoUpdate
Starts the draw and event handler until basalt.stopUpdate() is called

#### Usage:
* Enable the basalt updates, otherwise the screen will not continue to update
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
basalt.autoUpdate()
```


## basalt.update
Calls the draw and event handler once - this gives more flexibility about which events basalt should process. For example you could filter the terminate event.

#### Parameters: 
1. `string` The event to be received 
2. `...` Additional event variables to capture

#### Usage:
* Creates and starts a custom update cycle
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aButton = mainFrame:addButton("myButton"):setPosition(2,2):show()

while true do
        basalt.update(os.pullEventRaw())
end
```

## basalt.stopUpdate
Stops the automatic draw and event handler which got started by basalt.autoUpdate()

#### Usage:
* When the quit button is clicked, the button stops basalt auto updates
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aButton = mainFrame:addButton("myButton"):setPosition(2,2):setText("Stop Basalt!"):show()

aButton:onClick(function()
basalt.stopUpdate()
end)

basalt.autoUpdate()
```


## basalt.debug
creates a label with some information on the main frame on the bottom left, if you click on that label it will open a log view for you. See it as the new print for debugging

You can also edit the default debug Label (change position, change color or whatever you want) by accessing the variable basalt.debugLabel
which returns the debug Label.

Also basalt.debugFrame and basalt.debugList are available.

#### Parameters: 
1. `...` (multiple parameters are possible, like print does)<br>

#### Usage:
* Prints "Hello! ^-^" to the debug console
```lua
basalt.debug("Hello! ", "^-^")
```

