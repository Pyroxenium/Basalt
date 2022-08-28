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

