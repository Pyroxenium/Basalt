You question yourself how you can execute your own logic while basalt is also active? There are multiple ways of doing that:

## Method 1:
Using parallel.waitForAll

```lua
local basalt = dofile("basalt.lua")

local mainFrame = basalt.createFrame("mainFrame"):show()-- lets create a frame and a button without functionality
mainFrame:addButton("aButton"):onClick(function() end):show()

local function yourCustomHandler()
    while true do
        -- add your logic here
        os.sleep(1) -- you need something which calls coroutine.yield(), yes os.sleep does that os.pullEvent() aswell
    end
end

parallel.waitForAll(basalt.autoUpdate, yourCustomHandler) -- here it will handle your function (yourCustomHandler) and basalts handlers at the time
```
You can read [here (tweaked.cc)](https://tweaked.cc/module/parallel.html) what exactly parallel.waitForAll() does

## Method 2:
Using threads

```lua
local basalt = dofile("basalt.lua")

local mainFrame = basalt.createFrame("mainFrame"):show()-- lets create a frame, a button without functionality and a thread
mainFrame:addButton("aButton"):onClick(function() end):show()
local thread = mainFrame:addThread("customHandlerExecutingThread")

local function yourCustomHandler()
    while true do
        -- add your logic here
        os.sleep(1) -- you need something which calls coroutine.yield(), yes os.sleep does that os.pullEvent() aswell
    end
end
thread:start(yourCustomHandler) -- this will create a coroutine and starts the coroutine, os.sleep does the rest, so you just have to call start once.
```

## Method 3:
Using timers

```lua
local basalt = dofile("basalt.lua")

local mainFrame = basalt.createFrame("mainFrame"):show()-- lets create a frame, a button without functionality and a timer
mainFrame:addButton("aButton"):onClick(function() end):show()
local timer = mainFrame:addTimer("customHandlerExecutingTimer")

local function yourCustomHandler()
    -- add your logic here
end
timer:onCall(yourCustomHandler):setTime(1, -1):start() -- this will call your function every second until you :cancel() the timer
```