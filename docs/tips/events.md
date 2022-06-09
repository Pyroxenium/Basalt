
## Short way of adding functions to events
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

## Using isKeyDown for shortcuts
there is also a function with which you can check if the user is holding a key down, it is called `basalt.isKeyDown()`. It's especially useful for click events.
Let us say you want a button to execute something, but if you are holding ctrl down, something in the execution should get changed. This is how you would
achieve that:

```lua
button:onClick(function()
  if(basalt.isKeyDown(keys.leftCtrl)then
    basalt.debug("Ctrl is down!")
  else
    basalt.debug("Ctrl is up!")
  end
end)
```

Make sure to always use the available `keys` table: https://computercraft.info/wiki/Keys_(API)
