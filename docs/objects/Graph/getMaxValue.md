## getMaxValue

### Description

Returns the current maximum value of the graph.

### Returns

1. `number` maxValue - The current maximum value of the graph.

### Usage

* Gets the maximum value of the graph

```lua
local mainFrame = basalt.createFrame()
local aGraph = mainFrame:addGraph()
local maxValue = aGraph:getMaxValue()
basalt.debug("Max value:", maxValue)
```
