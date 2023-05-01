# Object

## setValue

Sets the value of that object (input, label, checkbox, textfield, scrollbar,...)

### Parameters

1. `any` Value to set the object to

### Returns

1. `object` The object in use

### Usage

* Creates a checkbox and ticks it

```lua
local mainFrame = basalt.createFrame()
local aCheckbox = mainFrame:addCheckbox():setValue(true)
```

```xml
<checkbox value="true" />
```
