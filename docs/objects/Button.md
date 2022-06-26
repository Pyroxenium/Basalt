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
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local button = mainFrame:addButton("myFirstButton"):setText("Click me!"):show()
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
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local button = mainFrame:addButton("myFirstButton")
       :setText("Click me!")
       :setHorizontalAlign("right")
       :show()
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
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local button = mainFrame:addButton("myFirstButton")
       :setText("Click me!")
       :setHorizontalAlign("right")
       :setVerticalAlign("bottom")
       :show()
```

# Example
This is a example on how you would create a fully working button:
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aButton = mainFrame:addButton("myFirstButton"):setText("Click"):show()

aButton:onClick(function(self,event,button,x,y)
  if(event=="mouse_click")and(button==1)then
    basalt.debug("Left mousebutton got clicked!")
  end
end)
```
