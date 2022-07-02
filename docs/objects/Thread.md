Threads are being executed simultaneously.
<br>

## start
starts a new thread and executes the function
#### Parameters: 
1. `function` the function which should be executed

#### Returns:
1. `object` The object in use

#### Usage:
* Starts a new thread
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aThread = mainFrame:addThread("myFirstThread"):show()
local function randomThreadFunction()
    while true do
        basalt.debug("Thread is active")
        os.sleep(1) -- a sleep/coroutine.yield() or pullEvent is required otherwise we will never come back to the main program (error)
    end
end
aThread:start(randomThreadfunction)
```

## stop
stops the thread

#### Returns:
1. `object` The object in use

#### Usage:
* Stops the current running thread by clicking on a button
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aThread = mainFrame:addThread("myFirstThread"):show()
local function randomThreadFunction()
    while true do
        basalt.debug("Thread is active")
        os.sleep(1) -- a sleep/coroutine.yield() or pullEvent is required otherwise we will never come back to the main program (error)
    end
end
aThread:start(randomThreadfunction)
local aButton = mainFrame:addButton("myFirstButton"):setText("Stop Thread"):onClick(function() aThread:stop() end):show()
```

## getStatus
gets the current thread status

#### Returns:
1. `string` current status - ("running", "normal", "suspended", "dead")

#### Usage:
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aThread = mainFrame:addThread("myFirstThread"):show()
basalt.debug(aThread:getStatus())
```
