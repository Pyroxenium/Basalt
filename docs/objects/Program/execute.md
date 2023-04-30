## execute

### Description

Executes the given path or program

### Parameters

1. `string|function` The path to your file as a string, or a function that should be called

### Returns

1. `object` The object in use

### Usage

* Execute a custom program:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local aProgram = mainFrame:addProgram()

function customProgram()
    while true do
        print("This is a custom program!")
        sleep(1)
    end
end

aProgram:execute(customProgram) -- Executes the custom program
```

In this example, a Program object is created and added to the mainFrame. The execute method is then used to execute a custom function called customProgram. The custom program simply prints a debug message to the console.

* Executing worms:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local aProgram = mainFrame:addProgram()

aProgram:execute("rom/programs/fun/worm.lua") -- Executes the custom program
```

* Xml version of worms:

```xml
<program path="rom/programs/fun/worm.lua" execute="true" />
```
