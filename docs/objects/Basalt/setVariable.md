## setVariable

### Description

This method stores a variable that you can access via XML. You can also add a function, which is then called by object events created in XML.

### Parameters

1. `string` key - A key name to store the variable.
2. `any` value - Any variable to store under the key.

### Usage

* Adds a reusable function to Basalt.

```lua
basalt.setVariable("clickMe", function()
    basalt.debug("I got clicked")
end)

```

```xml
<button onClick="clickMe" text="Click me" />
```
