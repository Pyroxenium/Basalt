## log

### Description

Writes a message to the log file. This can be useful for debugging errors or keeping a record of events in your application. Log files are automatically removed when you start your program again.

### Parameters

1. `string` The text to write into the log file
2. `string` - The type or category of the log message

### Usage

* Writes "Hello!" into the log file

```lua
basalt.log("Hello!")
```

This should result in a file called `basaltLog.txt`. In the file it should say `[Basalt][Debug]: Hello!`.

* Writes "Config file missing" into the log file, with "WARNING" as the prefix.

```lua
basalt.log("Config file is missing", "WARNING")
```

This should result in a file called `basaltLog.txt`. In the file, it should say `[Basalt][WARNING]: Config file is missing`.
