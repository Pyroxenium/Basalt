## setMaxEntries

### Description

Sets the maximum number of data points that can be stored in the graph.

### Parameters

1. `number` maxEntries - The maximum number of data points

### Returns

1. `object` The object in use

### Usage

* Sets the maximum number of data points in the graph

```lua
local mainFrame = basalt.createFrame()
local aGraph = mainFrame:addGraph()
aGraph:setMaxEntries(100)
```
