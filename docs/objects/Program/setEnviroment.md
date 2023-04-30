## setEnviroment

### Description

Changes the default environment to a custom environment

### Parameters

1. `table` - Enviroment table

### Returns

1. `object` object in use

### Usage

* Set a custom environment for a program:

```lua
local basalt = require("basalt")

local mainFrame = basalt.createFrame()
local aProgram = mainFrame:addProgram()

local customEnvironment = {
    print = function(...)
        local args = {...}
        basalt.debug("Custom print:", unpack(args))
    end
}

aProgram:setEnvironment(customEnvironment) -- Set the custom environment
aProgram:execute(function()
    print("Hello, World!")
end)
```

In this example, a Program object is created and added to the mainFrame. A custom environment table is created with a custom `print` function. The custom environment is then set for the program using the `setEnvironment` method. When the program is executed, it will use the custom `print` function from the custom environment instead of the default print function.
