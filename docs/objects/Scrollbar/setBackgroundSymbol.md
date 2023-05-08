## setBackgroundSymbol

### Description

Changes the symbol in the background, default is "\127"

### Parameters

1. `string` symbol

### Return

1. `object` The object in use

### Usage

* Creates a new scrollbar and changes the background symbol to X

```lua
local main = basalt.createFrame()
local scrollbar = main:addScrollbar():setBackgroundSymbol("X")
```

```xml
<scrollbar backgroundSymbol="X" />
```
