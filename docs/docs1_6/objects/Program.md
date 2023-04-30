
Program objects are here for opening other executable programs in your main program. You can execute worms, shell or any custom program you've made. 
<br>
Remember Program inherits from [Object](objects/Object.md)


## getStatus
returns the current process status

#### Returns:
1. `string` current status ("running", "normal, "suspended", or "dead")

#### Usage:
* Prints current status
```lua
local mainFrame = basalt.createFrame()
local aProgram = mainFrame:addProgram()
basalt.debug(aProgram:getStatus())
```

## execute
Executes the given path or program

#### Parameters: 
1. `string|function` the path to your file as string, or function which should be called

#### Returns:
1. `object` The object in use

#### Usage:
* Executes worm
```lua
local mainFrame = basalt.createFrame()
local aProgram = mainFrame:addProgram()
aProgram:execute("rom/programs/fun/worm.lua") -- executes worm
```
```xml
<program path="rom/programs/fun/worm.lua" execute="true" />
```

## stop
Stops a currently running program

#### Returns:
1. `object` The object in use

#### Usage:
* Stops worm by clicking a button
```lua
local mainFrame = basalt.createFrame()
local aProgram = mainFrame:addProgram()
aProgram:execute("rom/programs/fun/worm.lua") -- executes worm
mainFrame:addButton():setText("Pause"):onClick(function() aProgram:stop() end):show()
```

## pause
pauses the current program (prevents the program from receiving events)

#### Parameters: 
1. `boolean` true, false or nothing

#### Returns:
1. `object` The object in use

#### Usage:
* Pauses worm by clicking a button
```lua
local mainFrame = basalt.createFrame():show()
local aProgram = mainFrame:addProgram():execute("rom/programs/shell.lua"):show()
mainFrame:addButton():setText("Pause"):onClick(function() aProgram:pause(true) end):show()
```

## isPaused
returns if the program is paused

#### Returns:
1. `boolean` pause status

#### Usage:
* Prints the pause status of the program
```lua
local mainFrame = basalt.createFrame():show()
local aProgram = mainFrame:addProgram():execute("rom/programs/shell.lua"):show()
basalt.debug(aProgram:isPaused())
```

## injectEvent
injects a event into the program manually. For example you could inject w a s and d for worm, by clicking buttons.

#### Parameters: 
1. `string` event
2. `any` parameter
3. `any` parameter
4. `any` parameter
5. `any` parameter
6. `boolean` if this is true, the injected event will be executed even if the program is paused

#### Returns:
1. `object` The object in use

#### Usage:
* injects a event by clicking a button
```lua
local mainFrame = basalt.createFrame():show()
local aProgram = mainFrame:addProgram():execute("rom/programs/shell.lua"):show()
mainFrame:addButton():setText("inject"):onClick(function() aProgram:injectEvent("char", "w") end):show()
```

## injectEvents
Injects multiple events

#### Parameters: 
1. `table` a table, items should be {event="event", args={para1, para2, para3, para4}}

#### Returns:
1. `object` The object in use

#### Usage:
* injects a multiple char events by clicking a button

```lua
local mainFrame = basalt.createFrame():show()
local aProgram = mainFrame:addProgram():execute("rom/programs/shell.lua"):show()

local events = {
{event="char", args={"h"}},
{event="char", args={"e"}},
{event="char", args={"y"}}
}
mainFrame:addButton():setText("inject"):onClick(function() aProgram:injectEvents(events) end):show()
```


## getQueuedEvents
If the program is paused, incomming events will be inserted into a queued events table. As soon as the program is unpaused, the queued events table will be empty

#### Returns:
1. `table` a table - {event="event", args={"a", "b",...}}

#### Usage:
* prints the queued events table
```lua
local mainFrame = basalt.createFrame():show()
local aProgram = mainFrame:addProgram():execute("rom/programs/shell.lua"):show()
mainFrame:addButton():setText("inject"):onClick(function() basalt.debug(aProgram:getQueuedEvents()) end):show()
```

## updateQueuedEvents
Here you can manipulate the queued events table

#### Parameters: 
1. `table` a table, items should be {event="event", args={para1, para2, para3, para4}}

#### Returns:
1. `object` The object in use

```lua
local mainFrame = basalt.createFrame():show()
local aProgram = mainFrame:addProgram():execute("rom/programs/shell.lua"):show()

mainFrame:addButton():setText("inject"):onClick(function() 
local events = aProgram:getQueuedEvents()
table.insert(events,1,{event="char", args={"w"}}
aProgram:updateQueuedEvents(events) 
end):show()
```

