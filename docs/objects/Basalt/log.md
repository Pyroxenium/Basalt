## basalt.log
This writes something into a file. The main goal is to make debugging errors easier. Lets say you'r program is crashing and
you don't know why, you could use basalt.log

The log files will automatically removed after you start your program again

#### Parameters: 
1. `string` The text to write into the log file
2. `string` - optional (default: "Debug") - the type to write

#### Usage:
* Writes "Hello!" into the log file
```lua
basalt.log("Hello!")
```
