Buttons are objects, which execute something by clicking on them.<br>

Remember button also inherits from [Object](objects/Object.md)

## setText
Sets the displayed button text
#### Parameters: 
1. `string` the text the button should show

#### Returns:
1. `object` The object in use

#### Usage:
* Creates a button with "Click me!" as text.
```lua
local mainFrame = basalt.createFrame()
local button = mainFrame:addButton():setText("Click me!")
```
```xml
<button text="Click me!" />
```

## setHorizontalAlign
Sets the horizontal align of the button text

#### Parameters: 
1. `string` the position as string ("left", "center", "right") - default is center.

#### Returns:
1. `object` The object in use

#### Usage:
* Sets the button's horizontal text align to right. 
```lua
local mainFrame = basalt.createFrame()
local button = mainFrame:addButton()
       :setText("Click me!")
       :setHorizontalAlign("right")
```
```xml
<button text="Click me!" horizontalAlign="right" />
```

## setVerticalAlign
Sets the vertical align of the button text

#### Parameters: 
1. `string` the position as string ("top", "center", "bottom") - default is center.

#### Returns:
1. `object` The object in use

#### Usage:
* Sets the button's horizontal text align to right and the vertical text align to bottom. 
```lua
local mainFrame = basalt.createFrame()
local button = mainFrame:addButton()
       :setText("Click me!")
       :setHorizontalAlign("right")
       :setVerticalAlign("bottom")
```
```xml
<button text="Click me!" horizontalAlign="right" verticalAlign="bottom" />
```

# Example
This is a example on how you would create a fully working button:
```lua
local mainFrame = basalt.createFrame()
local aButton = mainFrame:addButton():setText("Click")

aButton:onClick(function(self,event,button,x,y)
  if(event=="mouse_click")and(button==1)then
    basalt.debug("Left mousebutton got clicked!")
  end
end)
```

and this would be the xml way to do it:
```lua
local mainFrame = basalt.createFrame():addLayout("example.xml")

basalt.setVariable("buttonClick", function(self,event,button,x,y)
  if(event=="mouse_click")and(button==1)then
    basalt.debug("Left mousebutton got clicked!")
  end
end)
```
```xml
<button onClick="buttonClick" text="Click" />
```