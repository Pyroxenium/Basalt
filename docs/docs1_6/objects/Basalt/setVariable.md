# Basalt

## setVariable

This stores a variable which you're able to access via xml. You are also able to add a function, which then gets called by object events created in XML.

### Parameters

1. `string` a key name
2. `any` any variable

### Usage

* Adds a function to basalt.

```lua
basalt.setVariable("clickMe", function()
    basalt.debug("I got clicked")
end)

```

```xml
<button onClick="clickMe" text="Click me" />
```
