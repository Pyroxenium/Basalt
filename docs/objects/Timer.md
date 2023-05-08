Timers are objects that allow you to execute code after a specified delay. Unlike Threads, Timers do not use coroutines for concurrency. They are designed to run a function once after the delay has passed.

In addition to the Object methods, Timers have the following methods:

|   |   |
|---|---|
|[setTime](objects/Timer/setTime.md)|Sets the time the timer should wait before calling your function
|[start](objects/Timer/start.md)|Starts the timer
|[cancel](objects/Timer/cancel.md)|Cancels the timer

## Events

|   |   |
|---|---|
|[onCall](objects/Timer/onCall.md)|A custom event which gets triggered as soon as the current timer has finished

## Example

Here's an example of how to create and use a Timer object:

```lua
-- Function that will be executed after the timer delay
local function delayedTask()
  basalt.debug("This message will be displayed after a 5-second delay")
end

-- Create a new Timer object
local main = basalt.createFrame()
local myTimer = main:addTimer()

myTimer:onCall(delayedTask)

-- Set the time delay and start the timer
myTimer:setTime(5)
myTimer:start()

-- Optionally cancel the timer (not needed in this example, as the timer will finish on its own)
-- myTimer:cancel()
```