## getGraphSymbol

### Description

Returns the current symbol used for the graph.

### Returns

1. `string` graphSymbol - The symbol used for the graph line.

### Usage

* Gets the graph symbol

```lua
local mainFrame = basalt.createFrame()
local aGraph = mainFrame:addGraph()
local graphSymbol = aGraph:getGraphSymbol()
basalt.debug(graphSymbol)
```
