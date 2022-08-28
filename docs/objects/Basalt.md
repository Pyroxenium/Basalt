This is the UI Manager and the first thing you want to access.
Before you can access Basalt, you need to add the following code on top of your file:

`local basalt = require("basalt")`

require loads the UI Framework into your project.

Now you are able to access the following list of methods:

|   |   |
|---|---|
|[createFrame](objects/Basalt/createFrame.md)|Creates a new base frame
|[removeFrame](objects/Basalt/removeFrame.md)|Removes a previously created base frame
|[getFrame](objects/Basalt/getFrame.md)|Returns a frame object by it's id
|[getActiveFrame](objects/Basalt/getActiveFrame.md)|Returns the currently active base frame
|[autoUpdate](objects/Basalt/autoUpdate.md)|Starts the event and draw listener
|[update](objects/Basalt/update.md)|Starts the event and draw listener once
|[stopUpdate](objects/Basalt/stopUpdate.md)|Stops the currently active event and draw listener
|[isKeyDown](objects/Basalt/isKeyDown.md)|Returns if the key is held down
|[debug](objects/Basalt/debug.md)|Writes something into the debug console
|[log](objects/Basalt/log.md)|Writes something into the log file
|[setTheme](objects/Basalt/setTheme.md)|Changes the base theme of basalt
|[setVariable](objects/Basalt/setVariable.md)|Sets a variable which you can access via XML
|[schedule](objects/Basalt/schedule.md)|Schedules a new task

# Examples

Here is a lua example on how to create a empty base frame and start basalt's listener.
```lua
local basalt = require("basalt") -- we load the UI Framework into our project

local main = basalt.createFrame() -- we create a base frame - on that frame we are able to add object's

-- here we would add additional object's

basalt.autoUpdate() -- we start listening to incoming events and draw stuff on the screen
```