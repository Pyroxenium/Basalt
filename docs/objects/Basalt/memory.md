## memory

### Description

Returns the amount of memory used by Basalt in bytes. This can be useful for monitoring your application's memory usage and performance.

### Returns

1. `number` The amount of memory used by Basalt in bytes.

### Usage

* Display the memory usage in the debug console

```lua
local memoryUsage = basalt.memory()
basalt.debug("Memory usage: ", memoryUsage, " bytes")
```
