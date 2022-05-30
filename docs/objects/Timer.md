# Timer

With timers you can call delayed functions.
<br>
Here is a list of all available functions for timers: <br>

## setTime
sets the time the timer should wait after calling your function
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aTimer = mainFrame:addTimer("myFirstTimer")
aTimer:setTime(5)
````
**parameters:**number time[, number repeats] - (time in seconds, if repeats is -1 it will call the function infinitly (every x seconds)<br>
**returns:** self<br>

## start
starts the timer
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aTimer = mainFrame:addTimer("myFirstTimer")
aTimer:setTime(5):start()
````
**parameters:** -<br>
**returns:** self<br>

## cancel
stops/cancels the timer
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aTimer = mainFrame:addTimer("myFirstTimer")
aTimer:setTime(5):start()
aTimer:cancel()
````
**parameters:** -<br>
**returns:** self<br>


## onCall
adds a function to the timer
````lua
local function timerCall(self)
    basalt.debug("i got called!")
end
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aTimer = mainFrame:addTimer("myFirstTimer")
aTimer:setTime(5):onCall(timerCall):start()

````
**parameters:** function func<br>
**returns:** self<br>