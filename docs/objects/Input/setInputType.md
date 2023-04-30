## setInputType

### Description

Changes the input type of the Input object. The default input type is "text".

### Parameters

1. `string` inputType - The input type to set. Accepted values are "text", "password", and "number".

### Returns

1. `object` The object in use

### Usage

* Creates a default input and sets it to numbers only.

```lua
local mainFrame = basalt.createFrame()
local aInput = mainFrame:addInput():setInputType("number")
```

```xml
<input type="number" />
```
