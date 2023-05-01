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