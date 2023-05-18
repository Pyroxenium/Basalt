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
local main = basalt.createFrame()
local subFrame = main:addFrame():setSize(30, 15)
local scrollbar = main:addScrollbar():setPosition(31, 1):setSize(1, 15):setScrollAmount(10)

scrollbar:onChange(function(self, _, value)
  subFrame:setOffset(0, value-1)
end)
```
