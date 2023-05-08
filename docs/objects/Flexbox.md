A Flexbox is a layout container that is designed to make it easier to create flexible and responsive UI designs. It allows you to arrange and align its children (elements) within it in a more efficient way.

In addition to the methods inherited from Frame, Container, VisualObject and Object, Flexbox has the following methods:

|   |   |
|---|---|
|[setSpacing](objects/Flexbox/setSpacing.md)|Sets the space between objects
|[getSpacing](objects/Flexbox/getSpacing.md)|Returns the space between objects
|[setFlexDirection](objects/Flexbox/setFlexDirection.md)|Sets the direction in which the children will be placed
|[setJustifyContent](objects/Flexbox/setJustifyContent.md)|Determines how the children are aligned along the main axis
|[setAlignItems](objects/Flexbox/setAlignItems.md)|Determines how the children are aligned along the off axis

### Example

Here's an example of how to create a Flexbox object:

```lua
local main = basalt.createFrame()
local flexbox = main:addFlexbox()
  :setFlexDirection("column")
  :setJustifyContent("space-between")
  :setAlignItems("center")
  :setSpacing(5)
```

Alternatively, you can create a flexbox using an XML layout:

```xml
<flexbox flexDirection="column" justifyContent="space-between" alignItems="center" spacing="5">
```
