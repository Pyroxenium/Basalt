# Object

## setZIndex

Sets the z-index. Higher value means higher draw/event priority. You can also add multiple objects to the same z-index, if so the last added object will have the highest priority.

### Parameters

1. `number` z-index

### Returns

1. `object` The object in use

### Usage

* Sets the buttons z-index to `1` and the labels z-index to `2`

```lua
local mainFrame = basalt.createFrame()
local aButton = mainFrame:addButton():setZIndex(1):setPosition(2,2)
local aLabel = mainFrame:addButton():setZIndex(2):setPosition(2,2):setText("I am a label!")
```

```xml
<button x="2" y="2" zIndex="1" />
<label x="2" y="2" text="I am a label!" zIndex="2" />
```
