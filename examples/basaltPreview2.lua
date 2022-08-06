local basalt = require("Basalt")

basalt.setVariable("buttonColor", basalt.schedule(function(self) 
    self:setBackground(colors.black)
    self:setForeground(colors.lightGray)
    os.sleep(0.1)
    self:setBackground(colors.gray)
    self:setForeground(colors.black)
end))

local main

basalt.setVariable("ex1", function()
    main:addAnimation():setObject(main):setAutoDestroy():offset(0,0,1):play()
end)

basalt.setVariable("ex1Top", function()
    local example1 = main:getDeepObject("example1")
    example1:addAnimation():setObject(example1):setAutoDestroy():offset(0,0,1):play()
end)

basalt.setVariable("ex2", function()
    main:addAnimation():setObject(main):setAutoDestroy():offset(main:getWidth(),0,1):play()
end)

basalt.setVariable("p1", function()
    local example2 = main:getDeepObject("example2")
    example2:addAnimation():setObject(example2):setAutoDestroy():offset(0,0,1):play()
end)

basalt.setVariable("p2", function()
    local example2 = main:getDeepObject("example2")
    example2:addAnimation():setObject(example2):setAutoDestroy():offset(0,example2:getHeight(),1):play()
end)

basalt.setVariable("p3", function()
    local example2 = main:getDeepObject("example2")
    example2:addAnimation():setObject(example2):setAutoDestroy():offset(0,example2:getHeight()*2,1):play()
end)

basalt.setVariable("ex3", function()
    main:addAnimation():setObject(main):setAutoDestroy():offset(main:getWidth()*2,0,1):play()
end)

basalt.setVariable("e1", function()
    local example3 = main:getDeepObject("example3")
    example3:addAnimation():setObject(example3):setAutoDestroy():offset(0,0,1):play()
end)

basalt.setVariable("e2", function()
    local example3 = main:getDeepObject("example3")
    example3:addAnimation():setObject(example3):setAutoDestroy():offset(0,example3:getHeight(),1):play()
end)

basalt.setVariable("e3", function()
    local example3 = main:getDeepObject("example3")
    example3:addAnimation():setObject(example3):setAutoDestroy():offset(0,example3:getHeight()*2,1):play()
end)

basalt.setVariable("ex4", function()
    main:addAnimation():setObject(main):setAutoDestroy():offset(main:getWidth()*3,0,1):play()
end)

basalt.setVariable("progressChange", function(self)
    main:getDeepObject("progressLabel"):setText(self:getValue().."%")
end)

basalt.setVariable("pauseP2", function()
    main:getDeepObject("program2"):pause()
end)

basalt.setVariable("pauseP3", function()
    main:getDeepObject("program3"):pause()
end)

basalt.setVariable("startAnimation", function()
    main:getDeepObject("animation1"):play()
end)

basalt.setVariable("disableStartButton", function()
    main:getDeepObject("animationButton"):disable()
end)

basalt.setVariable("enableStartButton", function()
    main:getDeepObject("animationButton"):enable()
end)

basalt.setVariable("onTextfieldFocus", function()
    main:getDeepObject("coolTextfield"):setForeground(colors.lightGray)
    main:getDeepObject("textfieldAnimLoseFocus"):cancel()
    main:getDeepObject("textfieldAnimFocus"):play()
end)

basalt.setVariable("onTextfieldLoseFocus", function()
    main:getDeepObject("coolTextfield"):setForeground(colors.gray)
    main:getDeepObject("textfieldAnimFocus"):cancel()
    main:getDeepObject("textfieldAnimLoseFocus"):play()
end)

basalt.setVariable("makeButtonVisible", function()
    main:getDeepObject("showAnimBtn1"):show()
    main:getDeepObject("showAnimBtn2"):show()
    main:getDeepObject("showAnimBtn3"):show()
end)

basalt.setVariable("dragPosition", function(ob, ev, bt, x, y, dragStartX, dragStartY, mouseX, mouseY)
    ob:setPosition(x, y)
end)


local function inject(prog, key)
    local events = prog:getQueuedEvents()
    table.insert(events, 1, {event="key", args = {key}})
    prog:injectEvents(events)
    prog:updateQueuedEvents({})
end

basalt.setVariable("p3Up", function()
    local program = main:getDeepObject("program3")
    inject(program, keys.w)
end)

basalt.setVariable("p3Down", function()
    local program = main:getDeepObject("program3")
    inject(program, keys.s)
end)

basalt.setVariable("p3Left", function()
    local program = main:getDeepObject("program3")
    inject(program, keys.a)
end)

basalt.setVariable("p3Right", function()
    local program = main:getDeepObject("program3")
    inject(program, keys.d)
end)

basalt.setVariable("noDrag", function(self)
    return false
end)

basalt.setVariable("openSidebar", function(self)
    main:addAnimation():setObject(main:getDeepObject("sidebar")):setAutoDestroy():move(-12,1,1):play()
end)
basalt.setVariable("closeSidebar", function(self)
    main:addAnimation():setObject(main:getDeepObject("sidebar")):setAutoDestroy():move(2,1,1):play()
end)

basalt.setVariable("progressTheProgressbar", function()
    os.sleep(1)
    local progressbar = main:getDeepObject("progressBar")
    local progress = 0
    while true do
        progressbar:setProgress(progress)
        progress = progress+0.25
        os.sleep(1)
    end
end)

main = basalt.createFrame():addLayout("basaltPreview2.xml")

basalt.autoUpdate()
