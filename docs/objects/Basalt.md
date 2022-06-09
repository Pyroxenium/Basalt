To start using Basalt you have to do the following line of code:

`local basalt = dofile("basalt.lua")`

remember you need the basalt.lua file on your computer!

Now you are able to call all these functions:

## basalt.createFrame
Create a frame without a parent
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
Removes a frame (only possible for non-parent frames)

#### Parameters: 
1. `string` name

#### Usage:
* Removes the previously created frame with id "myFirstFrame" 
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
basalt.removeFrame("myFirstFrame")
```

## basalt.getFrame
With that function you can get frames, but only frames without a parent!
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
Returns the currently active (without a parent) frame

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
Calls the draw and event handler method once

#### Parameters: 
1. `string` The event to be received 
2. `...` Additional event variables to capture

#### Usage:
* Prints "Left Mouse Button clicked!" when clicked
```lua
quitButton:onClick(
        function(obj, event, x, y) 
            if(event == "mouse_click") and (button == 1) then --> The button at index 1 is left
                basalt.debug("Left Mouse Button clicked!")
            end
        end
)
```

## basalt.stopUpdate
Stops the draw and event handler _(including, but not limited to mouse clicks)_

#### Usage:
* When the quit button is clicked, the button stops basalt updates and clears the terminal
```lua
quitButton:onClick(
        function(obj, event)
            if (event == "mouse_click") and (obj == quitButton) then --> The button at index 1 is left
                basalt.stopUpdate()
                term.clear()
            end
        end
)
```


## basalt.debug
creates a label with some information on the main frame on the bottom left, if you click on that label it will open a log view for you see it as the new print for debugging

#### Parameters: 
1. `...` (multiple parameters are possible, like print does)<br>

#### Usage:
* Prints "Hello! ^-^" to the debug console
```lua
basalt.debug("Hello! ^-^")
```

