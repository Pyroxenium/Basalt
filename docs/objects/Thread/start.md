## start

starts a new thread and executes the function

### Parameters

1. `function` the function which should be executed

### Returns

1. `object` The object in use

### Usage
* Starts a new thread

```lua
local mainFrame = basalt.createFrame()
local aThread = mainFrame:addThread()
local function randomThreadFunction()
    while true do
        basalt.debug("Thread is active")
        os.sleep(1) -- a sleep/coroutine.yield() or pullEvent is required otherwise we will never come back to the main program (error)
    end
end
aThread:start(randomThreadfunction)
```

you are also able to start threads via xml:

```lua
    basalt.setVariable("myThread", function() while true do os.sleep(1) end end)
```

```xml
<thread thread="myThread" start="true"/>
```