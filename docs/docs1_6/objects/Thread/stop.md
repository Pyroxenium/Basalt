## stop
stops the currently running thread

#### Returns:
1. `object` The object in use

#### Usage:
* Stops the current running thread by clicking on a button
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
local aButton = mainFrame:addButton():setText("Stop Thread"):onClick(function() aThread:stop() end)
```