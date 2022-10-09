# onDone

`onDone(self, err)`<br>
This is a custom event which gets triggered as soon as the progress is done.

Here is a example on how to add a onDone event to your progressbar:

```lua
local basalt = require("basalt")

local main = basalt.createFrame()
local aProgressbar = main:addProgressbar()

local function onProgressDone()
    basalt.debug("Progress is done")
end

aProgressbar:onDone(onProgressDone)
```
