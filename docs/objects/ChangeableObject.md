The ChangeableObject class is a subclass of VisualObject and Object that provides additional methods for handling changes to objects.

In addition to the Object and VisualObject methods, changeableObjects also have the following methods:

|   |   |
|---|---|
|[setValue](objects/Button/setText.md)|Changes the button text
|[getValue](objects/Button/setHorizontalAlign.md)|Changes the horizontal text position
|[onChange](objects/Button/setVerticalAlign.md)|Changes the vertical text position

# Example

Here's an example of how to create a fully functional button using the Button object:

```lua
local main = basalt.createFrame()
local aButton = main:addButton():setText("Click")

aButton:onClick(function(self,event,button,x,y)
  if(event=="mouse_click")and(button==1)then
    basalt.debug("Left mousebutton got clicked!")
  end
end)
```

Alternatively, you can create a button using an XML layout:

```xml
<button onClick="buttonClick" text="Click">
  <onClick>
    if(event=="mouse_click")and(button==1)then
      basalt.debug("Left mousebutton got clicked!")
    end
  </onClick>
</button>
```

In these examples, a button is created with the text "Click". When the left mouse button is clicked on the button, the message "Left mouse button got clicked!" is printed.
