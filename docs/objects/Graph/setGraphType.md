## setGraphType

### Description

Sets the type of the graph to scatter, line, or bar. Default: line.

### Parameters

1. `number` graphType - The type of the graph ("scatter", "line", or "bar").

### Returns

1. `object` The object in use

### Usage

* Sets the graph type to a line graph

```lua
local mainFrame = basalt.createFrame()
local aGraph = mainFrame:addGraph():setGraphType("scatter")
```
