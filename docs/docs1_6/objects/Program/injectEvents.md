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