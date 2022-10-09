You question yourself how you can execute your own logic while basalt is also active? There are multiple ways of doing that:

## Parallel

Using parallel.waitForAll or parallel.waitForAny

```lua
local basalt = require("basalt")

local main = basalt.createFrame() -- we need a base frame
main:addButton() -- just a button
    :onClick(function()
        basalt.debug("Button got clicked")
    end)

local function yourCustomHandler()
    while true do
        -- add your logic here
        os.sleep(1) -- you need something which calls coroutine.yield(), yes os.sleep() does that and os.pullEvent() too
    end
end

parallel.waitForAll(basalt.autoUpdate, yourCustomHandler) -- here it will handle your function (yourCustomHandler) and basalt's handlers at the same time using parallel's API
```

[Here (tweaked.cc)](https://tweaked.cc/module/parallel.html) you can find out more about the parallel API.

## Threads

Using basalt's thread implementation.

```lua
local basalt = require("basalt")

local main = basalt.createFrame() -- we need a base frame
main:addButton() -- just a button
    :onClick(function()
        basalt.debug("Button got clicked")
    end)

local thread = mainFrame:addThread() -- here we create a thread

local function yourCustomHandler()
    while true do
        -- add your logic here
        os.sleep(1) -- you need something which calls coroutine.yield(), yes os.sleep() does that and os.pullEvent() too
    end
end
thread:start(yourCustomHandler) -- here we start the thread and pass the function which you want to run.
```

## Timers

Using basalt's implementation of timers.
Remember, timers don't run asynchronly which means if you're using sleep somewhere this will freeze basalt's event system too.

```lua
local basalt = require("basalt")

local main = basalt.createFrame() -- we need a base frame
main:addButton() -- just a button
    :onClick(function()
        basalt.debug("Button got clicked")
    end)

local timer = mainFrame:addTimer() -- here we will create the timer object

local function yourCustomHandler()
    -- add your logic here
end
timer:onCall(yourCustomHandler)
     :setTime(1, -1)
     :start() -- this will call your function every second until you :cancel() the timer
```

## Schedule

Using basalt's schedule implementation.

```lua
local basalt = require("basalt")

local main = basalt.createFrame() -- we need a base frame
main:addButton() -- just a button
    :onClick(function()
        basalt.debug("Button got clicked")
    end)

local yourCustomHandler = basalt.schedule(function() -- create a new schedule task
    -- add your logic here
end)

yourCustomHandler() -- execute the schedule task

```
