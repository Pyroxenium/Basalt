# Basalt

## log

This writes something into a file. The main goal is to make debugging errors easier. Lets say you'r program is crashing and you don't know why, you could use basalt.log The log files will automatically removed after you start your program again.

### Parameters

1. `string` The text to write into the log file
2. `string` - optional (default: "Debug") - the type to write

### Usage

* Writes "Hello!" into the log file

```lua
basalt.log("Hello!")
```

This should result in there beeing a file called `basaltLog.txt`. In the file it should say `[Basalt][Debug]: Hello!`.

* Writes "Config file missing" into the log file, with warning as prefix.

```lua
basalt.log("Config file is missing", "WARNING")
```

This should result in there beeing a file called `basaltLog.txt`. In the file it should say `[Basalt][WARNING]: Config file is missing`.
