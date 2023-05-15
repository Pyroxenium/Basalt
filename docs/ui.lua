local installerPath = "https://basalt.madefor.cc/install.lua"
local installer

local main = basalt.createFrame():setTheme({FrameBG = colors.lightGray, FrameFG=colors.black})

-- Frames for pages
local pages = {
    main:addScrollableFrame():setSize("parent.w", "parent.h"), -- Main page
    main:addFrame():setSize("parent.w", "parent.h"):hide(), -- Install page
    main:addFrame():setSize("parent.w", "parent.h"):hide(), -- Install setup objects page
    main:addFrame():setSize("parent.w", "parent.h"):hide(), -- Install setup plugins page
    main:addFrame():setSize("parent.w", "parent.h"):hide(), -- Installing process page
    main:addFrame():setSize("parent.w", "parent.h"):hide(), -- Add Object page
    main:addFrame():setSize("parent.w", "parent.h"):hide(), -- Add Plugin page
    main:addFrame():setSize("parent.w", "parent.h"):hide(), -- Add Programs page
}

-- Useful functions
local function switchPage(id)
    for _,v in pairs(pages)do
        v:hide()
    end
    pages[id]:show()
end

local function downloadInstaller()
    if(fs.exists("install.lua"))then
        local f = fs.open("install.lua", "r")
        if(f~=nil)then
            installer = load(f.readAll())()
            f.close()
            return
        end
    end
    local file = http.get(installerPath)
    if(file)then
        installer = load(file.readAll())()
        file.close()
    else
        error("Failed to download installer!")
    end
end

--Actual installing page--------------------
local installingList = pages[5]:addList():setPosition(2, 2):setSize("parent.w - 2", "parent.h - 6")
local doneBtn = pages[5]:addButton():setText("Done"):setSize(12, 3):setPosition(2, "parent.h - 3"):onClick(function()
    switchPage(1)
end):hide()
pages[5]:addButton():setText("Back"):setSize(12, 3):setPosition(2, "parent.h - 3"):onClick(function()
    switchPage(2)
end)
--------------------------------------------


-- Main Page--------------------------------
pages[1]:addButton():setText("Install Basalt"):setSize("parent.w/2", 3):setPosition("parent.w / 2 - self.w/2", 3):onClick(function()
    switchPage(2)
end)
pages[1]:addButton():setText("Install Objects"):setSize("parent.w/2", 3):setPosition("parent.w / 2 - self.w/2", 7):onClick(function()
    switchPage(6)
end)
pages[1]:addButton():setText("Install Plugins"):setSize("parent.w/2", 3):setPosition("parent.w / 2 - self.w/2", 11):onClick(function()
    switchPage(7)
end)
pages[1]:addButton():setText("Install Programs"):setSize("parent.w/2", 3):setPosition("parent.w / 2 - self.w/2", 15):onClick(function()
    switchPage(8)
end)
--------------------------------------------



-- Setup Objects Page-----------------------
pages[3]:addButton():setText("Back"):setSize(12, 3):setPosition(2, "parent.h - 3"):onClick(function()
    switchPage(2)
end)

local availableObjects
local lastSelection
local doubleClickTimer = 0
local usedObjects = pages[3]:addList():setPosition(2, 2):setSize("parent.w / 2 - 6", "parent.h - 6"):onSelect(function(self, _, item)
    if(lastSelection==item)then
        if(doubleClickTimer>os.clock())then
            doubleClickTimer = 0
            availableObjects:addItem(item.text, nil, nil, item.args[1])
            self:removeItem(item)
        else
            doubleClickTimer = os.clock() + 0.4
        end
    else
        doubleClickTimer = os.clock() + 0.4
    end
    lastSelection = item
end)
availableObjects = pages[3]:addList():setPosition("parent.w - self.w", 2):setSize("parent.w / 2 - 6", "parent.h - 6"):onSelect(function(self, _, item)
    if(lastSelection==item)then
        if(doubleClickTimer>os.clock())then
            doubleClickTimer = 0
            usedObjects:addItem(item.text, nil, nil, item.args[1])
            self:removeItem(item)
        else
            doubleClickTimer = os.clock() + 0.4
        end
    else
        doubleClickTimer = os.clock() + 0.4
    end
    lastSelection = item
end)
local fetching = false
pages[3]:addButton():setText("Fetch Objects"):setPosition("parent.w - 15", "parent.h - 3"):setSize(15, 3):onClick(basalt.schedule(function(self)
    if(fetching)then return end
    fetching = true
    self:setText("Fetching...")
    if(installer==nil)then
        downloadInstaller()
    end
    installer.printStatus = false
    local objects = installer.getBasaltObjectList()
    local avObjects = installer.getAdditionalObjectList()
    usedObjects:clear()
    availableObjects:clear()
    for _,v in pairs(objects)do
        usedObjects:addItem(v.name, nil, nil, v.url)
    end
    if(avObjects~=nil)then
        for _,v in pairs(avObjects)do
            availableObjects:addItem(v.name, nil, nil, v.url)
        end
    end
    self:setText("Fetch Objects")
    fetching = false
end))

pages[3]:addButton():setText(">"):setPosition("parent.w / 2 - 1", 3):setSize(3, 1):onClick(function()
    local item = usedObjects:getValue()
    if(item==nil)then return end
    availableObjects:addItem(item.text, nil, nil, item.args[1])
    usedObjects:removeItem(item)
end)

pages[3]:addButton():setText("<"):setPosition("parent.w / 2 - 1", 5):setSize(3, 1):onClick(function()
    local item = availableObjects:getValue()
    if(item==nil)then return end
    usedObjects:addItem(item.text, nil, nil, item.args[1])
    availableObjects:removeItem(item)
end)
--------------------------------------------


----Setup Plugins Page----------------------
pages[4]:addButton():setText("Back"):setSize(12, 3):setPosition(2, "parent.h - 3"):onClick(function()
    switchPage(2)
end)

local availablePlugins
local lastSelection
local doubleClickTimer = 0
local usedPlugins = pages[4]:addList():setPosition(2, 2):setSize("parent.w / 2 - 6", "parent.h - 6"):onSelect(function(self, _, item)
    if(lastSelection==item)then
        if(doubleClickTimer>os.clock())then
            doubleClickTimer = 0
            availablePlugins:addItem(item.text, nil, nil, item.args[1])
            self:removeItem(item)
        else
            doubleClickTimer = os.clock() + 0.4
        end
    else
        doubleClickTimer = os.clock() + 0.4
    end
    lastSelection = item
end)
availablePlugins = pages[4]:addList():setPosition("parent.w - self.w", 2):setSize("parent.w / 2 - 6", "parent.h - 6"):onSelect(function(self, _, item)
    if(lastSelection==item)then
        if(doubleClickTimer>os.clock())then
            doubleClickTimer = 0
            usedPlugins:addItem(item.text, nil, nil, item.args[1])
            self:removeItem(item)
        else
            doubleClickTimer = os.clock() + 0.4
        end
    else
        doubleClickTimer = os.clock() + 0.4
    end
    lastSelection = item
end)
local fetching = false
pages[4]:addButton():setText("Fetch Plugins"):setPosition("parent.w - 15", "parent.h - 3"):setSize(15, 3):onClick(basalt.schedule(function(self)
    if(fetching)then return end
    fetching = true
    self:setText("Fetching...")
    if(installer==nil)then
        downloadInstaller()
    end
    installer.printStatus = false
    local plugins = installer.getBasaltPluginList()
    local avPlugins = installer.getAdditionalPluginList()
    usedPlugins:clear()
    availablePlugins:clear()
    for _,v in pairs(plugins)do
        usedPlugins:addItem(v.name, nil, nil, v.url)
    end
    if(avPlugins~=nil)then
        for _,v in pairs(avPlugins)do
            availablePlugins:addItem(v.name, nil, nil, v.url)
        end
    end
    self:setText("Fetch Plugins")
    fetching = false
end))

pages[4]:addButton():setText(">"):setPosition("parent.w / 2 - 1", 3):setSize(3, 1):onClick(function()
    local item = usedPlugins:getValue()
    if(item==nil)then return end
    availablePlugins:addItem(item.text, nil, nil, item.args[1])
    usedPlugins:removeItem(item)
end)

pages[4]:addButton():setText("<"):setPosition("parent.w / 2 - 1", 5):setSize(3, 1):onClick(function()
    local item = availablePlugins:getValue()
    if(item==nil)then return end
    usedPlugins:addItem(item.text, nil, nil, item.args[1])
    availablePlugins:removeItem(item)
end)
--------------------------------------------


----Installer Page--------------------------
pages[2]:addButton():setText("Back"):setSize(12, 3):setPosition(2, "parent.h - 3"):onClick(function()
    switchPage(1)
end)

pages[2]:addLabel():setText("Installer"):setPosition(3, 2)
pages[2]:addLabel():setText("File name:"):setPosition(3, 4)

local fName = pages[2]:addInput():setPosition(3, 5):setSize("parent.w/2-5", 1):setDefaultText("basalt.lua", colors.gray)
local setupObjects = pages[2]:addButton():setText("Setup Objects"):setSize("parent.w/3-2", 3):setPosition("parent.w - self.w", 2):onClick(function()
    switchPage(3)
end)

local setupPlugins = pages[2]:addButton():setText("Setup Plugins"):setSize("parent.w/3-2", 3):setPosition("parent.w - self.w", 6):onClick(function()
    switchPage(4)
end)

pages[2]:addLabel():setText("Branch:"):setPosition(3, 7)

local branch = pages[2]:addDropdown():setPosition(3, 8):setSize("parent.w/2-5", 1):addItem("master"):addItem("dev"):setDropdownSize(16, 2)

pages[2]:addLabel():setText("Version:"):setPosition(3, 10)
local version = pages[2]:addDropdown():addItem("Single File"):addItem("Release"):addItem("Source"):setPosition(3, 11):setSize("parent.w/2-5", 1):setDropdownSize(16, 3)
local minified = pages[2]:addCheckbox():setText("Minified"):setPosition(3, 14):setBackground(colors.black):setForeground(colors.lightGray)
local release = pages[2]:addDropdown():setPosition(3, 14):setSize(16, 1):setDropdownSize(16, 3):hide()

version:onChange(function(self)
    if(self:getValue().text=="Single File")then
        minified:show()
        fName:setDefaultText("basalt.lua", colors.gray)
    else
        minified:hide()
    end
    if(self:getValue().text=="Source")then
        fName:setDefaultText("basalt", colors.gray)
    end
    if(self:getValue().text=="Release")then
        release:show()
        setupObjects:hide()
        setupPlugins:hide()
        fName:setDefaultText("basalt.lua", colors.gray)
        if(#release:getAll()<=0)then
            basalt.schedule(function()
                if(installer==nil)then
                    downloadInstaller()
                end
                installer.printStatus = false
                local releases = installer.getReleases()
                for _,v in pairs(releases)do
                    release:addItem(v.name, nil, nil, v.url)
                end
            end)()
        end
    else
        release:hide()
        setupObjects:show()
        setupPlugins:show()
    end
end)

local function installBasalt()
    doneBtn:hide()
    installer.printStatus = function(text)
        installingList:addItem(text)
    end
    local fileName = fName:getValue()
    if(fileName=="")then
        fileName = "basalt.lua"
        if(version:getValue().text=="Source")then
            fileName = "basalt"
        end
    end

    local objectList = {}
    if(usedObjects:getItemCount()<=0)and(availableObjects:getItemCount()<=0)then
        for _,v in pairs(installer.getBasaltObjectList())do
            table.insert(objectList, {name=v.name, url=v.url})
        end
    else
        for _,v in pairs(usedObjects:getAll())do
            table.insert(objectList, {name=v.text, url=v.args[1]})
        end
    end

    local pluginList = {}
    if(usedPlugins:getItemCount()<=0)and(availablePlugins:getItemCount()<=0)then
        for _,v in pairs(installer.getBasaltPluginList())do
            table.insert(pluginList, {name=v.name, url=v.url})
        end
    else
        for _,v in pairs(usedPlugins:getAll())do
            table.insert(pluginList, {name=v.text, url=v.args[1]})
        end
    end

    if(version:getValue().text=="Single File")then
        installer.downloadCustomBasalt({objects = objectList, plugins = pluginList}, "packed", fileName, branch:getValue().text, minified:getValue())
    end
    if(version:getValue().text=="Release")then
        installer.downloadRelease(fileName, release:getValue().args[1])
    end
    if(version:getValue().text=="Source")then
        installer.downloadCustomBasalt({objects = objectList, plugins = pluginList}, "source", fileName, branch:getValue().text)
    end

    doneBtn:show()
end

pages[2]:addButton():setText("Install"):setSize(12, 3):setPosition("parent.w - 12", "parent.h - 3"):onClick(function()
    switchPage(5)
    installingList:clear()
    installingList:addItem("Preparing to install...")
    if(installer==nil)then
        installingList:addItem("Downloading installer...")
    end
    basalt.schedule(function()
        downloadInstaller()
        installingList:addItem("Installer downloaded successfully!")
        installingList:addItem("Installing Basalt...")
        installBasalt()
    end)()
end)
--------------------------------------------


----Add objects page-----------------------
pages[6]:addButton():setText("Back"):setSize(12, 3):setPosition(2, "parent.h - 3"):onClick(function()
    switchPage(1)
end)

pages[6]:addLabel():setText("Add Objects"):setPosition(3, 2)

pages[6]:addLabel():setText("Path:"):setPosition(3, 4)
local installPath = pages[6]:addInput():setPosition(3, 5):setSize(16, 1):setDefaultText("objects", colors.gray)

local additionalObjectsList = pages[6]:addList():setPosition("parent.w - self.w", 7):setSize("parent.w/2 - 4", "parent.h - 11")
local addingObjectsList = pages[6]:addList():setPosition(2, 7):setSize("parent.w/2 - 4", "parent.h - 11")

additionalObjectsList:onSelect(function(self, _, item)
    if(lastSelection==item)then
        if(doubleClickTimer>os.clock())then
            doubleClickTimer = 0
            addingObjectsList:addItem(item.text, nil, nil, item.args[1])
            self:removeItem(item)
        else
            doubleClickTimer = os.clock() + 0.4
        end
    else
        doubleClickTimer = os.clock() + 0.4
    end
    lastSelection = item
end)

addingObjectsList:onSelect(function(self, _, item)
    if(lastSelection==item)then
        if(doubleClickTimer>os.clock())then
            doubleClickTimer = 0
            additionalObjectsList:addItem(item.text, nil, nil, item.args[1])
            self:removeItem(item)
        else
            doubleClickTimer = os.clock() + 0.4
        end
    else
        doubleClickTimer = os.clock() + 0.4
    end
    lastSelection = item
end)

pages[6]:addButton():setText("<"):setSize(3, 1):setPosition("parent.w / 2 - self.w / 2 + 1", 7):onClick(function()
    local item = additionalObjectsList:getValue()
    if(item==nil)then return end
    if(item.args==nil)then return end
    addingObjectsList:addItem(item.text, nil, nil, item.args[1])
    additionalObjectsList:removeItem(item)
    lastSelection = nil
    additionalObjectsList:selectItem(nil)
end)

pages[6]:addButton():setText(">"):setSize(3, 1):setPosition("parent.w / 2 - self.w / 2 + 1", 9):onClick(function()
    local item = addingObjectsList:getValue()
    if(item==nil)then return end
    if(item.args==nil)then return end
    additionalObjectsList:addItem(item.text, nil, nil, item.args[1])
    addingObjectsList:removeItem(item)
    lastSelection = nil
    addingObjectsList:selectItem(nil)
end)

pages[6]:addButton():setText("Fetch Objects"):setSize(15, 3):setPosition(15, "parent.h - 3"):onClick(basalt.schedule(function(self)
    self:setText("Fetching...")
    additionalObjectsList:clear()
    addingObjectsList:clear()
    if(installer==nil)then
        downloadInstaller()
    end
    local objects = installer.getAdditionalObjectList()
    for _,v in pairs(objects)do
        additionalObjectsList:addItem(v.name, nil, nil, "https://raw.githubusercontent.com/Pyroxenium/BasaltAdditions/main/objects/"..v.name)
    end
    self:setText("Fetch Objects")
end))

local successFrame = pages[6]:addMovableFrame():setPosition("parent.w / 2 - self.w / 2", 3):setSize(20, 6):setBackground(colors.gray):setForeground(colors.lightGray):setBorder(colors.black):hide()
successFrame:addLabel():setText("Download finished!"):setPosition(2, 2)
successFrame:addButton():setText("OK"):setPosition(8, 5):setSize(6, 1):setBackground(colors.black):setForeground(colors.lightGray):onClick(function()
    successFrame:hide()
end)

pages[6]:addButton():setText("Download"):setSize(14, 3):setPosition("parent.w - 14", "parent.h - 3"):onClick(basalt.schedule(function(self)
    self:setText("Downloading...")
    local items = addingObjectsList:getAll()
    local path = installPath:getValue()
    if(path=="")then
        path = "objects"
    end
    if not(fs.exists(path))then
        fs.makeDir(path)
    end
    for _,v in pairs(items)do
        installer.downloadAdditionalObject(v.text, path.."/"..v.text)
    end
    self:setText("Download")
    successFrame:show()
end))
--------------------------------------------

----Add plugins page------------------------
pages[7]:addButton():setText("Back"):setSize(12, 3):setPosition(2, "parent.h - 3"):onClick(function()
    switchPage(1)
end)

pages[7]:addLabel():setText("Add Plugins"):setPosition(3, 2)

pages[7]:addLabel():setText("Path:"):setPosition(3, 4)
local installPath2 = pages[7]:addInput():setPosition(3, 5):setSize(16, 1):setDefaultText("plugins", colors.gray)

local additionalPluginsList = pages[7]:addList():setPosition("parent.w - self.w", 7):setSize("parent.w/2 - 4", "parent.h - 11")
local addingPluginsList = pages[7]:addList():setPosition(2, 7):setSize("parent.w/2 - 4", "parent.h - 11")

additionalPluginsList:onSelect(function(self, _, item)
    if(lastSelection==item)then
        if(doubleClickTimer>os.clock())then
            doubleClickTimer = 0
            addingPluginsList:addItem(item.text, nil, nil, item.args[1])
            self:removeItem(item)
        else
            doubleClickTimer = os.clock() + 0.4
        end
    else
        doubleClickTimer = os.clock() + 0.4
    end
    lastSelection = item
end)

addingPluginsList:onSelect(function(self, _, item)
    if(lastSelection==item)then
        if(doubleClickTimer>os.clock())then
            doubleClickTimer = 0
            additionalPluginsList:addItem(item.text, nil, nil, item.args[1])
            self:removeItem(item)
        else
            doubleClickTimer = os.clock() + 0.4
        end
    else
        doubleClickTimer = os.clock() + 0.4
    end
    lastSelection = item
end)

pages[7]:addButton():setText("<"):setSize(3, 1):setPosition("parent.w / 2 - self.w / 2 + 1", 7):onClick(function()
    local item = additionalPluginsList:getValue()
    if(item==nil)then return end
    if(item.args==nil)then return end
    addingPluginsList:addItem(item.text, nil, nil, item.args[1])
    additionalPluginsList:removeItem(item)
    lastSelection = nil
    additionalPluginsList:selectItem(nil)
end)

pages[7]:addButton():setText(">"):setSize(3, 1):setPosition("parent.w / 2 - self.w / 2 + 1", 9):onClick(function()
    local item = addingPluginsList:getValue()
    if(item==nil)then return end
    if(item.args==nil)then return end
    additionalPluginsList:addItem(item.text, nil, nil, item.args[1])
    addingPluginsList:removeItem(item)
    lastSelection = nil
    addingPluginsList:selectItem(nil)
end)

pages[7]:addButton():setText("Fetch Plugins"):setSize(15, 3):setPosition(15, "parent.h - 3"):onClick(basalt.schedule(function(self)
    self:setText("Fetching...")
    additionalPluginsList:clear()
    addingPluginsList:clear()
    if(installer==nil)then
        downloadInstaller()
    end
    local plugins = installer.getAdditionalPluginList()
    for _,v in pairs(plugins)do
        additionalPluginsList:addItem(v.name, nil, nil, "https://raw.githubusercontent.com/Pyroxenium/BasaltAdditions/main/plugins/"..v.name)
    end
    self:setText("Fetch Plugins")
end))

local successFrame2 = pages[7]:addMovableFrame():setPosition("parent.w / 2 - self.w / 2", 3):setSize(20, 6):setBackground(colors.gray):setForeground(colors.lightGray):setBorder(colors.black):hide()

successFrame2:addLabel():setText("Download finished!"):setPosition(2, 2)

successFrame2:addButton():setText("OK"):setPosition(8, 5):setSize(6, 1):setBackground(colors.black):setForeground(colors.lightGray):onClick(function()
    successFrame2:hide()
end)

pages[7]:addButton():setText("Download"):setSize(14, 3):setPosition("parent.w - 14", "parent.h - 3"):onClick(basalt.schedule(function(self)
    self:setText("Downloading...")
    local items = addingPluginsList:getAll()
    local path = installPath2:getValue()
    if(path=="")then
        path = "plugins"
    end
    if not(fs.exists(path))then
        fs.makeDir(path)
    end
    for _,v in pairs(items)do
        installer.downloadAdditionalPlugin(v.text, path.."/"..v.text)
    end
    self:setText("Download")
    successFrame2:show()
end))
--------------------------------------------

----Add programs page-----------------------
pages[8]:addButton():setText("Back"):setSize(12, 3):setPosition(2, "parent.h - 3"):onClick(function()
    switchPage(1)
end)

pages[8]:addLabel():setText("Add Programs"):setPosition(3, 2)

pages[8]:addLabel():setText("Path:"):setPosition(3, 4)
local installPath3 = pages[8]:addInput():setPosition(3, 5):setSize(16, 1):setDefaultText("programs", colors.gray)

local additionalProgramsList = pages[8]:addList():setPosition("parent.w - self.w", 7):setSize("parent.w/2 - 4", "parent.h - 11")
local addingProgramsList = pages[8]:addList():setPosition(2, 7):setSize("parent.w/2 - 4", "parent.h - 11")

additionalProgramsList:onSelect(function(self, _, item)
    if(lastSelection==item)then
        if(doubleClickTimer>os.clock())then
            doubleClickTimer = 0
            installer.downloadAdditionalProgram(item.args[1], installPath3:getValue().."/"..item.text)
            self:removeItem(item)
        else
            doubleClickTimer = os.clock() + 0.4
        end
    else
        doubleClickTimer = os.clock() + 0.4
    end
    lastSelection = item
end)

addingProgramsList:onSelect(function(self, _, item)
    if(lastSelection==item)then
        if(doubleClickTimer>os.clock())then
            doubleClickTimer = 0
            additionalProgramsList:addItem(item.text, nil, nil, item.args[1])
            self:removeItem(item)
        else
            doubleClickTimer = os.clock() + 0.4
        end
    else
        doubleClickTimer = os.clock() + 0.4
    end
    lastSelection = item
end)

pages[8]:addButton():setText("<"):setSize(3, 1):setPosition("parent.w / 2 - self.w / 2 + 1", 7):onClick(function()
    local item = additionalProgramsList:getValue()
    if(item==nil)then return end
    if(item.args==nil)then return end
    addingProgramsList:addItem(item.text, nil, nil, item.args[1])
    additionalProgramsList:removeItem(item)
    lastSelection = nil
    additionalProgramsList:selectItem(nil)
end)

pages[8]:addButton():setText(">"):setSize(3, 1):setPosition("parent.w / 2 - self.w / 2 + 1", 9):onClick(function()
    local item = addingProgramsList:getValue()
    if(item==nil)then return end
    if(item.args==nil)then return end
    additionalProgramsList:addItem(item.text, nil, nil, item.args[1])
    addingProgramsList:removeItem(item)
    lastSelection = nil
    addingProgramsList:selectItem(nil)
end)

pages[8]:addButton():setText("Fetch Programs"):setSize(15, 3):setPosition(15, "parent.h - 3"):onClick(basalt.schedule(function(self)
    self:setText("Fetching...")
    additionalProgramsList:clear()
    if(installer==nil)then
        downloadInstaller()
    end
    local programs = installer.getAdditionalProgramList()
    if(programs~=nil)then
        for _,v in pairs(programs)do
            additionalProgramsList:addItem(v.name, nil, nil, "https://raw.githubusercontent.com/Pyroxenium/BasaltAdditions/main/programs/"..v.name)
        end
    end
    self:setText("Fetch Programs")
end))

local successFrame3 = pages[8]:addMovableFrame():setPosition("parent.w / 2 - self.w / 2", 3):setSize(20, 6):setBackground(colors.gray):setForeground(colors.lightGray):setBorder(colors.black):hide()

successFrame3:addLabel():setText("Download finished!"):setPosition(2, 2)

successFrame3:addButton():setText("OK"):setPosition(8, 5):setSize(6, 1):setBackground(colors.black):setForeground(colors.lightGray):onClick(function()
    successFrame3:hide()
end)

pages[8]:addButton():setText("Download"):setSize(14, 3):setPosition("parent.w - 14", "parent.h - 3"):onClick(basalt.schedule(function(self)
    self:setText("Downloading...")
    local items = addingProgramsList:getAll()
    local path = installPath3:getValue()
    if(path=="")then
        path = "programs"
    end
    if not(fs.exists(path))then
        fs.makeDir(path)
    end
    for _,v in pairs(items)do
        installer.downloadProgram(v.text, path.."/"..v.text)
    end
    self:setText("Download")
    successFrame3:show()
end))

basalt.autoUpdate()