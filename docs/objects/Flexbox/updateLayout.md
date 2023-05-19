## updateLayout

### Description

The `updateLayout` method forces the Flexbox container to manually update its layout. This is particularly useful in situations where dynamic changes occur within the Flexbox and you want to ensure that the layout correctly reflects these changes.

By default this is not necessarily required. Because the flexbox automatically updates it's layout.

### Returns

1. `object` The object in use

### Usage

* Creates a default Flexbox, adds an object to it, and then forces a manual layout update.

```lua
local main = basalt.createFrame()
local flexbox = mainFrame:addFlexbox()
flexbox:addObject(myObject)
flexbox:updateLayout() -- forces a manual update of the layout
```
