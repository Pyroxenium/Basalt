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
