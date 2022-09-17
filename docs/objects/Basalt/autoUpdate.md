# Basalt

## autoUpdate

This starts the event and draw handler for you. The listeners will run until you stop them.

### Parameters

1. `boolean` optional - if you use false as the first parameter it would stop the listeners. Using false is a synonym for [`basalt.stopUpdate()`](objects/Basalt/stopUpdate.md).

### Usage

* Enables the basalt listeners, otherwise the screen will not continue to update

```lua
local main = basalt.createFrame()
basalt.autoUpdate()
```
