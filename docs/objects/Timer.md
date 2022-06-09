With timers you can call delayed functions.
<br>
Here is a list of all available functions for timers: <br>

## setTime
sets the time the timer should wait after calling your function
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aTimer = mainFrame:addTimer("myFirstTimer")
aTimer:setTime(5)
```
#### Parameters:number time[, number repeats] - (time in seconds, if repeats is -1 it will call the function infinitly (every x seconds)<br>
#### Returns: self<br>

## start
starts the timer
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aTimer = mainFrame:addTimer("myFirstTimer")
aTimer:setTime(5):start()
```
#### Parameters: -<br>
#### Returns: self<br>

## cancel
stops/cancels the timer
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aTimer = mainFrame:addTimer("myFirstTimer")
aTimer:setTime(5):start()
aTimer:cancel()
```
#### Parameters: -<br>
#### Returns: self<br>


## onCall
adds a function to the timer
```lua
local function timerCall(self)
    basalt.debug("i got called!")
end
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aTimer = mainFrame:addTimer("myFirstTimer")
aTimer:setTime(5):onCall(timerCall):start()

```
#### Parameters: function func<br>
#### Returns: self<br>
