With a program object you are able to open programs like shell or worm or any custom program you've made. There is only 1 thing you have to remember: the program needs at least one os.sleep() or coroutine.yield() somewhere.
<br>
Here is a list of all available functions for programs: <br>
Remember Program inherits from [Object](objects/Object.md)

## getStatus
returns the current status
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aProgram = mainFrame:addProgram("myFirstProgram"):show()
basalt.debug(aProgram:getStatus()) -- returns "running", "normal", "suspended" or "dead" 
```
#### Parameters:-<br>
#### Returns: string "running" - if its running, "normal" - is active but not running (waiting for a event), "suspended" - is suspended or not started, "dead" - has finished or stopped with an error<br>

## execute
executes the given path (-program)
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aProgram = mainFrame:addProgram("myFirstProgram"):show()
aProgram:execute("rom/programs/fun/worm.lua") -- executes worm
```
#### Parameters: string filepath - (the path to the program you want to execute)<br>
#### Returns: self<br>

## stop
gives a terminate event to the program, which means if you are running a shell, and the shell executes a program by itself you have to call stop 2 times to entirely close the running program
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aProgram = mainFrame:addProgram("myFirstProgram"):execute("rom/programs/shell.lua"):show()
mainFrame:addButton("myFirstButton"):setText("close"):onClick(function() aProgram:stop() end):show()

```
#### Parameters:-<br>
#### Returns: self<br>

## pause
pauses the program (prevents the program from receiving events)
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aProgram = mainFrame:addProgram("myFirstProgram"):execute("rom/programs/shell.lua"):show()
mainFrame:addButton("myFirstButton"):setText("close"):onClick(function() aProgram:pause(true) end):show()

```
#### Parameters: boolean pause<br>
#### Returns: self<br>

## isPaused
returns if the program is currently paused
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aProgram = mainFrame:addProgram("myFirstProgram"):execute("rom/programs/shell.lua"):show()
mainFrame:addButton("myFirstButton"):setText("pause"):onClick(function() basalt.debug(aProgram:isPaused()) end):show()

```
#### Parameters: -<br>
#### Returns: boolean isPaused<br>

## injectEvent
injects a event into the program manually
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aProgram = mainFrame:addProgram("myFirstProgram"):execute("rom/programs/shell.lua"):show()
mainFrame:addButton("myFirstButton"):setText("inject"):onClick(function() aProgram:injectEvent("char", "w") end):show()

```
#### Parameters: string event, any parameter, any parameter, any parameter, any parameter, boolean ignorePause<br>
#### Returns: self<br>

## injectEvents
injects a event table into the program manually
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aProgram = mainFrame:addProgram("myFirstProgram"):execute("rom/programs/shell.lua"):show()
--example will follow

```
#### Parameters: string event, any parameter, any parameter, any parameter, any parameter, boolean ignorePause<br>
#### Returns: self<br>

## getQueuedEvents
returns a table of all currently queued events (while pause is active incomming events will go into a queueEvents table) as soon as the program gets unpaused
it will inject these events
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aProgram = mainFrame:addProgram("myFirstProgram"):execute("rom/programs/shell.lua"):show()
mainFrame:addButton("myFirstButton"):setText("inject"):onClick(function() basalt.debug(aProgram:getQueuedEvents()) end):show()

```
#### Parameters: -<br>
#### Returns: table queuedEvents<br>

## updateQueuedEvents
here you can manipulate the queuedEvents table with your own events table
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aProgram = mainFrame:addProgram("myFirstProgram"):execute("rom/programs/shell.lua"):show()
--example will follow

```
#### Parameters: table queuedEvents<br>
#### Returns: self<br>

