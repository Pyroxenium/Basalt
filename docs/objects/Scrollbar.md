Scrollbars are objects that allow users to scroll vertically or horizontally, which in turn changes a value that you can access using the :getValue() method.

In addition to the Object and VisualObject methods, Scrollbar objects have the following methods:

|   |   |
|---|---|
|[setSymbol](objects/Scrollbar/setSymbol.md)|Sets the scrollbar symbol
|[setBackgroundSymbol](objects/Scrollbar/setBackgroundSymbol.md)|Sets the background symbol
|[setBarType](objects/Scrollbar/setBarType.md)|Sets the bar type (vertical or horizontal)
|[setScrollAmount](objects/Scrollbar/setScrollAmount.md)|Sets the maximum scroll amount
|[setIndex](objects/Scrollbar/setIndex.md)|Sets the current index
|[getIndex](objects/Scrollbar/getIndex.md)|Returns the index

## Example

Here's an example of how to create a Scrollbar object and set its properties:

```lua
local mainFrame = basalt.createFrame()
local scrollbar = mainFrame:addScrollbar()

scrollbar:setBarType("vertical")
scrollbar:setScrollAmount(100)
scrollbar:setIndex(50)

scrollbar:onChange(function(self, event, value)
  basalt.debug("Scrollbar value changed to:", value.text)
end)
```
