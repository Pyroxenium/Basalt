# Thread

Threads are "functions" you can execute simultaneously. Ofc the reality is, i am just using coroutine for that. But it works pretty good AND is very easy to use.
<br>
Here is a list of all available functions for threads: <br>

## start
starts a new thread and executes the function
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aThread = mainFrame:addThread("myFirstThread"):show()
local function randomThreadFunction()
    while true do
        basalt.debug("Thread is active")
        os.sleep(1) -- a sleep/coroutine.yield() or pullEvent is required otherwise we will never come back to the main program (error)
    end
end
aThread:start(randomThreadfunction)
````
**parameters:**function func<br>
**returns:** self<br>

## getStatus
gets the thread status
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aThread = mainFrame:addThread("myFirstThread"):show()
basalt.debug(aThread:getStatus()) -- returns "running", "normal", "suspended" or "dead"
````
**parameters:** -<br>
**returns:** string "running" - if its running, "normal" - is active but not running (waiting for a event), "suspended" - is suspended<br>

## stop
stops the thread
````lua
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

````
**parameters:** -<br>
**returns:** self<br>