Here we will talk about mouse events and how you can manipulate them. There are 2 possible mouse events you can add to almost every visual object.

# onClick
`onClick(self, button, x, y)`
The computercraft event which triggers this method is `mouse_click` and `monitor_touch`.
Any visual object can register onClick events.

Here is a example on how to add a onClick event to your button:

```lua
local basalt = dofile("basalt.lua")

local mainFrame = basalt.createFrame("myMainFrame"):show()
local button = mainFrame:addButton("myButton"):setPosition(3,3):setSize(12,3):setText("Click"):show()

function buttonOnClick()
  basalt.debug("Button got clicked!")
end
button:onClick(buttonOnClick())
```

# onClickUp
`onClickUp(self, button, x, y)`
The computercraft event which triggers this method is `mouse_up`.
Any visual object can register onClickUp events.

Here is a example on how to add a onClickUp event to your button:

```lua
local basalt = dofile("basalt.lua")

local mainFrame = basalt.createFrame("myMainFrame"):show()
local button = mainFrame:addButton("myButton"):setPosition(3,3):setSize(12,3):setText("Click"):show()

function buttonOnClick()
  basalt.debug("Button got clicked!")
end
button:onClick(buttonOnClick)

function buttonOnRelease()
  basalt.debug("Button got released!")
end
button:onClickUp(buttonOnRelease)
```

# onScroll
`onScroll(self, direction, x, y)`
The computercraft event which triggers this method is `mouse_scroll`.
Any visual object can register a onScroll events.

Here is a example on how to add a onScroll event to your button:

```lua
local basalt = dofile("basalt.lua")

local mainFrame = basalt.createFrame("myMainFrame"):show()
local button = mainFrame:addButton("myButton"):setPosition(3,3):setSize(12,3):setText("Click"):show()

function buttonOnScroll()
  basalt.debug("Someone scrolls on me!")
end
button:onScroll(buttonOnScroll)
```

# Beginner Tips

## 1
Not everyone knows that a function (or in other words a method) does not need to have a name. Instead of a function name you are also able to add the function itself as a argument.

Both do the exact same thing:
```lua
local function clickButton()
  basalt.debug("I got clicked!")
end
button:onClick(clickButton)
```

```lua
button:onClick(function()
  basalt.debug("I got clicked!")
end)
```

## 2
there is also a function with which you can check if the user is holding a key down, it is called `basalt.isKeyDown()`. It's especially useful for click events.
Let us say you want a button to execute something, but if you are holding ctrl down, something in the execution should get changed. This is how you would
achieve that:

```lua
button:onClick(function()
  if(basalt.isKeyDown(keys.LeftCtrl)then
    basalt.debug("Ctrl is down!")
  else
    basalt.debug("Ctrl is up!")
  end
end)
```

