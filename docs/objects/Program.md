Program objects allow you to execute other programs within your main application. You can run programs such as worms, shell, or any custom programs you've created. This object also has two unique events: onError and onDone.

In addition to the Object and VisualObject methods, lists also have the following methods:

|   |   |
|---|---|
|[getStatus](objects/Program/getStatus.md)|Returns the current program status
|[execute](objects/Program/execute.md)|Executes a program
|[stop](objects/Program/stop.md)|Stops the currently running program
|[pause](objects/Program/pause.md)|Pauses the currently running program
|[isPaused](objects/Program/isPaused.md)|Returns if the program is paused
|[injectEvent](objects/Program/injectEvent.md)|Injects an event into the program
|[injectEvents](objects/Program/injectEvents.md)|Injects a table of events
|[getQueuedEvents](objects/Program/getQueuedEvents.md)|Returns currently queued events
|[setEnviroment](objects/Program/setEnviroment.md)|Changes the default environment to a custom one

## Events

This is a list of all available events for programs:

|   |   |
|---|---|
|[onError](objects/Program/onError.md)|Fires when a program encounters an error
|[onDone](objects/Program/onDone.md)|Fires when a program has finished executing

Here's an example of how to create a Program object, execute a program, and handle events:

Lua:

```lua
local mainFrame = basalt.createFrame()
local aProgram = mainFrame:addProgram()

aProgram:onError(function(self, event, err)
  basalt.log("An error occurred: " .. err)
end)

aProgram:onDone(function()
  basalt.debug("Program finished successfully")
end)

aProgram:execute("path/to/your/program.lua")
```

This example demonstrates how to create a Program object, execute a program located at "path/to/your/program", and handle the onError and onDone events.
