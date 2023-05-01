The button object is for creating buttons If you click on them, they should execute something. You decide what should happen when clicking on them. 

[Object](objects/Object.md) methods also apply for buttons.

|   |   |
|---|---|
|[setText](objects/Button/setText.md)|Changes the button text
|[setHorizontalAlign](objects/Button/setHorizontalAlign.md)|Changes the horizontal text position
|[setVerticalAlign](objects/Button/setVerticalAlign.md)|Changes the vertical text position


# Example
This is a example on how you would create a fully working button:
```lua
local main = basalt.createFrame()
local aButton = main:addButton():setText("Click")

aButton:onClick(function(self,event,button,x,y)
  if(event=="mouse_click")and(button==1)then
    basalt.debug("Left mousebutton got clicked!")
  end
end)
```

and this would be the xml way:
```lua
basalt.setVariable("buttonClick", function(self,event,button,x,y)
  if(event=="mouse_click")and(button==1)then
    basalt.debug("Left mousebutton got clicked!")
  end
end)

local main = basalt.createFrame():addLayout("example.xml")
```
```xml
<button onClick="buttonClick" text="Click" />
```