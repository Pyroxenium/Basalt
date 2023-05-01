# Basalt

## setMouseMoveThrottle

This feature is only available for [CraftOS-PC](https://www.craftos-pc.cc).

CraftOS-PC has a builtin mouse_move event, which is disabled by default. By using this method it will also enable the event for you. Remember - basalt does not disable the event after closing the program, which means the event stays active. If you want to disable the event please use config.set("mouse_move_throttle", -1) in your lua prompt or your program.

Sidenote: a very low amount can make the program laggy - because it litterally spams the mouse_move event. So use it carefully.

### Parameters

1. `number` A number in miliseconds.

### Usage

```lua
local basalt = require("basalt")
basalt.setMouseMoveThrottle(50)
```
