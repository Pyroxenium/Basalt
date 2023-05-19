A Flexbox is a layout container designed to facilitate the creation of flexible and responsive UI designs. It allows you to efficiently arrange and align its child elements within it.

The Flexbox Container is still a WIP and i will add more methods from the CSS Flexbox Implementation.

In addition to the methods inherited from ScrollableFrame, Frame, Container, VisualObject and Object, Flexbox has the following methods:

|   |   |
|---|---|
|[setSpacing](objects/Flexbox/setSpacing.md)|Defines the gap between child objects within the Flexbox
|[getSpacing](objects/Flexbox/getSpacing.md)|Returns the current gap size between child objects
|[setDirection](objects/Flexbox/setDirection.md)|Sets the direction for the arrangement of child objects (row/column)
|[getDirection](objects/Flexbox/getDirection.md)|Returns the currently set arrangement direction of child objects
|[setJustifyContent](objects/Flexbox/setJustifyContent.md)|Sets the alignment of child objects along the main axis (flex-start, center, flex-end, space-between, space-around, space-evenly)
|[getJustifyContent](objects/Flexbox/getJustifyContent.md)|Returns the current alignment setting for child objects along the main axis
|[setWrap](objects/Flexbox/setWrap.md)|Determines if child objects should wrap onto the next line when they run out of space
|[getWrap](objects/Flexbox/getWrap.md)|Returns the current wrapping behavior for child objects
|[updateLayout](objects/Flexbox/updateLayout.md)|Manually triggers a layout update for the Flexbox
|[addBreak](objects/Flexbox/addBreak.md)|Introduces a line break within the Flexbox, forcing subsequent child objects to the next line

Child objects added via the Flexbox have the following additional methods:

|   |   |
|---|---|
|[getFlexGrow](objects/Flexbox/getFlexGrow.md)|Returns the flex grow factor of the child object
|[setFlexGrow](objects/Flexbox/setFlexGrow.md)|Sets the flex grow factor of the child object
|[getFlexShrink](objects/Flexbox/getFlexShrink.md)|Returns the flex shrink factor of the child object
|[setFlexShrink](objects/Flexbox/setFlexShrink.md)|Sets the flex shrink factor of the child object
|[getFlexBasis](objects/Flexbox/getFlexBasis.md)|Returns the flex basis of the child object
|[setFlexBasis](objects/Flexbox/setFlexBasis.md)|Sets the flex basis of the child object

### Example

Here's an example of how to create a Flexbox object:

```lua
local main = basalt.createFrame()
local main = basalt.createFrame()
local flexbox = main:addFlexbox()
  :setDirection("column")
  :setJustifyContent("space-between")
  :setSpacing(5)
  :setWrap("wrap")

flexbox:addButton()
```

Alternatively, you can create a flexbox using an XML layout:

```xml
<flexbox direction="column" justifyContent="space-between" spacing="1" wrap="wrap">
```
