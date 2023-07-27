## addDataPoint

### Description

Sets a data point in the graph with specified value.

### Parameters

1. `number` value - The value of the data point. (0-100)

### Returns

1. `object` The object in use

### Usage

* Sets a data point in the graph

```lua
local mainFrame = basalt.createFrame()
local aGraph = mainFrame:addGraph()
aGraph:addDataPoint(13)
```
