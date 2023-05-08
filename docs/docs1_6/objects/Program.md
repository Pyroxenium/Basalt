Program objects are here for opening other executable programs in your main program. You can execute worms, shell or any custom program you've made.

[Object](objects/Object.md) methods also apply for programs.

|   |   |
|---|---|
|[getStatus](objects/Program/getStatus.md)|Returns the current program status
|[execute](objects/Program/execute.md)|Executes a program
|[stop](objects/Program/stop.md)|Stops the currently running program
|[pause](objects/Program/pause.md)|Pauses the currently running program
|[isPaused](objects/Program/isPaused.md)|Returns if the program is paused
|[injectEvent](objects/Program/injectEvent.md)|Injects a event into the program
|[injectEvents](objects/Program/injectEvents.md)|Injects a table of events
|[getQueuedEvents](objects/Program/getQueuedEvents.md)|Returns currently queued events
|[setEnviroment](objects/Program/setEnviroment.md)|Changes the default enviroment to a custom one

# Events

This is a list of all available events for programs:

|   |   |
|---|---|
|[onError](objects/Program/onError.md)|Fires when a program errors
|[onDone](objects/Program/onDone.md)|Fires when a program has finished
