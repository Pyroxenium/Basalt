## getMaxEntries

### Description

Returns the maximum number of data points that can be stored in the graph.

### Returns

1. `number` maxEntries - The maximum number of data points

### Usage

* Gets the maximum number of data points in the graph

```lua
local mainFrame = basalt.createFrame()
local aGraph = mainFrame:addGraph():setMaxEntries(100)
local maxEntries = aGraph:getMaxEntries()
basalt.debug(maxEntries)
```
