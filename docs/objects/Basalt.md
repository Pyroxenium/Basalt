Before you can access Basalt, you need to add the following code on top of your file:

`local basalt = require("Basalt")`

Now you are able to access the following methods:

## basalt.createFrame
Create a base-frame (main frame)
#### Parameters: 
1. `string` name

#### Returns: 
1. `frame` object

#### Usage:
* Create and show a frame with id "myFirstFrame"
```lua
local mainFrame = basalt.createFrame("myFirstFrame")
```

## basalt.removeFrame
Removes a base frame

#### Parameters: 
1. `string` name

#### Usage:
* Removes the previously created frame with id "myFirstFrame" 
```lua
local mainFrame = basalt.createFrame("myFirstFrame")
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
basalt.createFrame("myFirstFrame"):hide()
basalt.getFrame("myFirstFrame"):show()
```

## basalt.getActiveFrame
Returns the currently active base frame

#### Returns: 
1. `frame` The current frame

#### Usage:
* Displays the active frame name in the debug console
```lua
basalt.createFrame()
basalt.debug(basalt.getActiveFrame():getName()) -- returns the uuid
```

## basalt.autoUpdate
Starts the draw and event handler until basalt.stopUpdate() is called

#### Usage:
* Enable the basalt updates, otherwise the screen will not continue to update
```lua
local mainFrame = basalt.createFrame()
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
local mainFrame = basalt.createFrame()
local aButton = mainFrame:addButton():setPosition(2,2)
while true do
    basalt.update(os.pullEventRaw())
end
```

## basalt.stopUpdate
Stops the automatic draw and event handler which got started by basalt.autoUpdate()

#### Usage:
* When the quit button is clicked, the button stops basalt auto updates
```lua
local mainFrame = basalt.createFrame()
local aButton = mainFrame:addButton():setPosition(2,2):setText("Stop Basalt!")
aButton:onClick(function()
basalt.stopUpdate()
end)
basalt.autoUpdate()
```

## basalt.isKeyDown
Checks if the user is currently holding a key

#### Parameters: 
1. `number` key code (use the keys table for that)

#### Returns: 
1. `boolean` true or false

#### Usage:
* Shows a debug message with true or false if the left ctrl key is down, as soon as you click on the button.
```lua
local mainFrame = basalt.createFrame()
local aButton = mainFrame:addButton():setPosition(2,2):setText("Check Ctrl")
aButton:onClick(function() 
    basalt.debug(basalt.isKeyDown(keys.leftCtrl))
end)
basalt.autoUpdate()
```

## basalt.debug
creates a label with some information on the main frame on the bottom left, if you click on that label it will open a log view for you. See it as the new print for debugging

You can also edit the default debug Label (change position, change color or whatever you want) by accessing the variable basalt.debugLabel
which returns the debug Label.

Also basalt.debugFrame and basalt.debugList are available.

#### Parameters: 
1. `...` (multiple parameters are possible, like print does)

#### Usage:
* Prints "Hello! ^-^" to the debug console
```lua
basalt.debug("Hello! ", "^-^")
```

## basalt.setTheme
Sets the base theme of the project! Make sure to cover all existing objects, otherwise it will result in errors. A good example is [theme](https://github.com/Pyroxenium/Basalt/blob/master/Basalt/theme.lua)

#### Parameters: 
1. `table` theme layout look into [theme](https://github.com/Pyroxenium/Basalt/blob/master/Basalt/theme.lua) for a example

#### Usage:
* Sets the default theme of basalt.
```lua
basalt.setTheme({
    ButtonBG = colors.yellow,
    ButtonText = colors.red,
    ...,
})
```

## basalt.setVariable
This stores a variable which you're able to access via xml. You are also able to add a function, which then gets called by object events created in XML.

#### Parameters: 
1. `string` a key name
1. `any` any variable

#### Usage:
* Adds a function to basalt.
```lua
basalt.setVariable("clickMe", function()
    basalt.debug("I got clicked")
end)
```
```xml
<button onClick="clickMe" text="Click me" />
```

## basalt.schedule
Schedules a function which gets called in a coroutine. After the coroutine is finished it will get destroyed immediatly. It's something like threads, but with some limits.

#### Parameters: 
1. `function` a function which should get executed

#### Returns: 
1. `function` it returns the function which you have to execute in order to start the coroutine

#### Usage:
* Creates a schedule which switches the color between red and gray
```lua
local mainFrame = basalt.createFrame()
local aButton = mainFrame:addButton():setText("Click me")
aButton:onClick(basalt.schedule(function(self)
    self:setBackground(colors.red)
    os.sleep(0.1)
    self:setBackground(colors.gray)
    os.sleep(0.1)
    self:setBackground(colors.red)
    os.sleep(0.1)
    self:setBackground(colors.gray)
    os.sleep(0.1)
    self:setBackground(colors.red)
    os.sleep(0.1)
    self:setBackground(colors.gray)
end))
```
