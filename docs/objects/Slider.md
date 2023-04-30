Sliders are objects that allow users to scroll vertically or horizontally, which in turn changes a value that you can access using the :getValue() method.

Sliders inherit methods from ChangeableObject, which itself inherits methods from VisualObject and Object. This means that Slider objects can also use the setValue, getValue, and onChange event methods from ChangeableObject, as well as methods from VisualObject and Object.

|   |   |
|---|---|
|[setSymbol](objects/Slider/setSymbol.md)|Sets the slider symbol
|[setBackgroundSymbol](objects/Slider/setBackgroundSymbol.md)|Sets the background symbol
|[setBarType](objects/Slider/setBarType.md)|Sets the bar type (vertical or horizontal)
|[setMaxValue](objects/Slider/setMaxValue.md)|Sets the maximum value
|[setIndex](objects/Slider/setIndex.md)|Sets the current index
|[getIndex](objects/Slider/getIndex.md)|Returns the index

## Example

Here's an example of how to create a Slider object and set its properties:

```lua
local mainFrame = basalt.createFrame()
local slider = mainFrame:addSlider()

slider:setBarType("horizontal")
slider:setMaxValue(100)
slider:setIndex(50)

slider:onChange(function(self, event, value)
    basalt.debug("Slider value changed to:", value.text)
end)
```
