## setWrap

### Description

Determines whether the child objects should wrap onto the next line when there isn't enough room along the main axis. The default value is 'nowrap'.

### Parameters

1. `string` If set to `wrap`, the child objects will wrap onto the next line when they run out of space. If set to `nowrap`, they will not.

### Returns

1. `object` The object in use

### Usage

* Creates a default Flexbox and sets the wrapping to `wrap`.

```lua
local main = basalt.createFrame()
local flexbox = mainFrame:addFlexbox()
      :setWrap("wrap")
```

If the contents of the Flexbox exceed its size, they will automatically move to the next line, creating a wrapping effect. This is particularly useful when designing responsive layouts that adapt to different screen sizes or window dimensions.
