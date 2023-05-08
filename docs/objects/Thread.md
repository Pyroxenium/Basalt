Threads are objects that allow you to run code concurrently in the background, without blocking the main program. They use coroutines in the background to achieve this behavior. Threads do not inherit from the VisualObject class, as they are not visible elements.

In addition to the Object methods, Threads have the following methods:

|   |   |
|---|---|
|[start](objects/Thread/start.md)|Starts a new thread and executes the specified function
|[stop](objects/Thread/stop.md)|Stops the currently running thread
|[getStatus](objects/Thread/getStatus.md)|Returns the current thread status

## Example

Here's an example of how to create and use a Thread object:

```lua
-- Function that will be executed in a separate thread
local function backgroundTask()
  for i = 1, 5 do
    basalt.debug("Running in the background:", i)
    os.sleep(1)
  end
end

-- Create a new Thread object
local main = basalt.createFrame()
local myThread = main:addThread()

-- Start the thread
myThread:start(backgroundTask)

-- Optionally stop the thread (not needed in this example, as the thread will finish on its own)
-- myThread:stop()
```
