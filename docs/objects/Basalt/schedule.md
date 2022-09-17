# Basalt

## schedule

Schedules a function which gets called in a coroutine. After the coroutine is finished it will get destroyed immediatly. It's something like threads, but with some limits.
**A guide can be found [here](/tips/logic).**

### Parameters

1. `function` a function which should get executed

### Returns

1. `function` it returns the function which you have to execute in order to start the coroutine

### Usage

* Creates a schedule which switches the color between red and gray

```lua
local mainFrame = basalt.createFrame()
local aButton = mainFrame:addButton():setText("Click me")
aButton:onClick(basalt.schedule(function(self)
    self:setBackground(colors.red)
    os.sleep(0.1)
    self:setBackground(colors.gray)
    os.sleep(0.1)
    self:setBackground(colors.red)
    os.sleep(0.1)
    self:setBackground(colors.gray)
    os.sleep(0.1)
    self:setBackground(colors.red)
    os.sleep(0.1)
    self:setBackground(colors.gray)
end))
```
