# Object

## setFocus  

Sets the object to be the focused object.
If you click on an object, it's normally automatically the focused object. For example, if you call :show() on a frame, and you want this particular frame to be in
the foreground, you should also use :setFocus()

### Returns

1. `object` The object in use

### Usage

* Sets the button to the focused object

```lua
local mainFrame = basalt.createFrame()
local aButton = mainFrame:addButton():setFocus()
```
