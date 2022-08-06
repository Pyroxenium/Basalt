local bot_id = "" -- put the bot id between the ""!
local servers = { -- setup the server/channels here, look at the example.
    [""] = {
        "",
    },

    --[[ Example:
    ["SERVER_ID"] = {
        "CHANNEL_ID",
        "CHANNEL_ID",
        "CHANNEL_ID",
    },
    ["SERVER_ID"] = {
        "CHANNEL_ID",
        "CHANNEL_ID",
        "CHANNEL_ID",
    },
    ]]
}

if(bot_id=="")then
    error("Please setup the bot id and servers/channels first!")
end

--Basalt configurated installer
local filePath = "basalt.lua" --here you can change the file path default: basalt.lua
if not(fs.exists(filePath))then
    shell.run("pastebin run ESs1mg7P packed true "..filePath:gsub(".lua", "")) -- this is an alternative to the wget command
end
local basalt = require(filePath:gsub(".lua", "")) -- here you can change the variablename in any variablename you want default: basalt

local main = basalt.createFrame():setBackground(colors.lightGray)
local loginFrame = main:addFrame():setBackground(colors.lightGray)
local messageFrameList = main:addFrame():setPosition("parent.w+1", 1):setBackground(colors.black):setScrollable(true):setImportantScroll(true)

local refreshRate = 2
local messageFrames = {}
local availableGuilds = {}

local channel_id = ""
for k,v in pairs(servers)do
    if(v[1]~=nil)then
        channel_id = v[1]
    end
    break
end

local function getAllGuilds(bot)
    local content = http.get("https://discord.com/api/users/@me/guilds", {["Content-Type"] = "application/json", ["Authorization"] = "Bot "..bot})
    if(content~=nil)then
        return textutils.unserializeJSON(content.readAll())
    end
end

local function getAllChannels(bot, guild)
    local content = http.get("https://discord.com/api/guilds/"..guild.."/channels", {["Content-Type"] = "application/json", ["Authorization"] = "Bot "..bot})
    if(content~=nil)then
        local t = {}
        for k,v in pairs(textutils.unserializeJSON(content.readAll()))do
            table.insert(t, v.position, v)
        end
        return t
    end
end

local splitString = function(str, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for v in string.gmatch(str, "([^"..sep.."]+)") do
            table.insert(t, v)
    end
    if(#t==0)then table.insert(t,str) end
    return t
end

local function createText(str, width)
    local uniqueLines = splitString(str, "\n")
    local lines = {}
    for k,v in pairs(uniqueLines)do
        local line = ""
        local words = splitString(v, " ")
        for a,b in pairs(words)do
            if(#line+#b <= width)then
                line = line=="" and b or line.." "..b
                if(a==#words)then table.insert(lines, line) end
            else
                table.insert(lines, line)
                line = b:sub(1,width)
                if(a==#words)then table.insert(lines, line) end
            end
        end
    end
    return lines
end

local maxOffset = 0
local autoOffset = true
local function newMessage(position, msg, username, sendTime)
    local lines = createText(msg, messageFrameList:getWidth()-5)
    if(messageFrames[position]==nil)then
        if(messageFrames[position-1]~=nil)then
            messageFrames[position] = messageFrameList:addFrame("message"..tostring(position)):setPosition(2, "message"..(position-1)..".y + message"..(position-1)..".h")
        else
            messageFrames[position] = messageFrameList:addFrame("message"..tostring(position)):setPosition(2, 1)
        end
        messageFrames[position]:addLabel("title")
        messageFrames[position]:addLabel("body")
    end
        maxOffset = maxOffset + #lines+3
        if(autoOffset)then
            messageFrameList:setOffset(0, maxOffset - messageFrameList:getHeight()+1)
        end
        messageFrames[position]:setSize("parent.w-1", #lines+3):setBackground(colors.black)
        messageFrames[position]:getObject("title"):setSize("parent.w-2", 1):setPosition(2,1):setText(username):setForeground(colors.lightGray):setBackground(colors.gray)
        messageFrames[position]:getObject("body"):setSize("parent.w-2", #lines+1):setPosition(2,3):setText(msg):setForeground(colors.lightGray)
end

local function updateDiscordMessages(channel, bot)
    if(channel~=nil)and(bot~=nil)then
        currentMessages = {}
        local content = http.get("https://discord.com/api/channels/"..channel.."/messages?limit=25", {["Content-Type"] = "application/json", ["Authorization"] = "Bot "..bot})
        if(content~=nil)then
            local t = textutils.unserializeJSON(content.readAll())
            local tR  = {}
            for i=#t, 1, -1 do
                tR[#tR+1] = t[i]
            end
            for k,v in pairs(tR)do
                newMessage(k, v.content, v.author.username, v.time)
            end
        end
    end
end

local animations = {}

local function offsetAnimation(obj, x, y, t)
    if(animations[obj:getName()]~=nil)then animations[obj:getName()]:cancel() end
    animations[obj:getName()] = main:addAnimation():setAutoDestroy(true):setObject(obj):offset(x, y, t or 1):play()
end

local function positionAnimation(obj, x, y, t)
    if(animations[obj:getName()]~=nil)then animations[obj:getName()]:cancel() end
    animations[obj:getName()] = main:addAnimation():setAutoDestroy(true):setObject(obj):move(x, y, t or 1):play()
end

local sideBar = messageFrameList:addFrame():setPosition(-18, 1):setSize(20, "parent.h"):setZIndex(17):ignoreOffset():setScrollable(true):setImportantScroll(true)
sideBar:addButton():setText("Back"):setForeground(colors.lightGray):setBackground(colors.black):setPosition(3,2):setSize("parent.w - 4", 3):onClick(function()
    offsetAnimation(main, 0, 0)
    positionAnimation(sideBar, -18, 1)
end)
sideBar:addLabel():setText("Channels:"):setForeground(colors.black):setPosition(2,6)
sideBar:onClick(function(self, event)
    if(event=="mouse_click")then
        positionAnimation(self, 1, 1)
        messageFrameList:setImportantScroll(false)
    end
end)
sideBar:onLoseFocus(function()
    positionAnimation(sideBar, -18, 1)
    messageFrameList:setImportantScroll(true)
end)


local newTextFrame = messageFrameList:addFrame():setSize("parent.w - 4", 10):setPosition(3, 1):setZIndex(16):ignoreOffset():setBackground(colors.gray):setAnchor("bottomLeft")
local msgInfo = newTextFrame:addLabel():setText("Click here to write a message")

local messageField = newTextFrame:addTextfield():setSize("parent.w-2", "parent.h-4"):setPosition(2,3):setBackground(colors.lightGray)
newTextFrame:onClick(function(self, event)
    if(event=="mouse_click")then
        positionAnimation(self, 3, -8, 0.5)
        messageFrameList:setImportantScroll(false)
        msgInfo:setText("New Message:")
    end
end)

messageFrameList:onScroll(function()
    local xO, yO = messageFrameList:getOffset()
    messageFrameList:getMaxScroll()
    if(yO==messageFrameList:getMaxScroll())then
        autoOffset = true
    else
        autoOffset = false
    end
end)

local function messageBoxLoseFocus()
    positionAnimation(newTextFrame, 3, 1, 0.5)
    messageFrameList:setImportantScroll(true)
    msgInfo:setText("Click here to write a message")
    messageField:clear()
end

newTextFrame:addButton():setText("Cancel"):setAnchor("bottomLeft"):setBackground(colors.black):setForeground(colors.lightGray):setSize(12,1):setPosition(2,1):onClick(function()
    messageBoxLoseFocus()
end)

newTextFrame:onLoseFocus(messageBoxLoseFocus)

loginFrame:addLabel():setAnchor("center"):setPosition(-2, -1):setText("Username:")
local nameInput = loginFrame:addInput():setAnchor("center"):setPosition(3,0):setBackground(colors.black):setForeground(colors.lightGray):setSize(16,1):setDefaultText("Username...", colors.gray)

local serverList = loginFrame:addList():setPosition(3, 6):setSize(16, 10)
local channelRadio = sideBar:addRadio():setForeground(colors.black):setBackground(colors.gray):setSelectedItem(colors.gray, colors.lightGray):setActiveSymbol(" ")
local channelObjects = {}
local updateChannels = basalt.shedule(function()
    if(bot_id~=nil)then
        for k,v in pairs(channelObjects)do
            sideBar:removeObject(v)
        end
        channelObjects = {}
        if(serverList:getValue().args~=nil)then
            local y = 8
            local maxScroll = 2
            for k,v in pairs(servers[serverList:getValue().args[1]])do
                local content = http.get("https://discord.com/api/channels/"..v, {["Content-Type"] = "application/json", ["Authorization"] = "Bot "..bot_id})
                local channel = textutils.unserializeJSON(content.readAll())
                if(channel~=nil)then
                    channelRadio:addItem("#"..channel.name,1, y, nil,nil,v)
                    y = y + 1
                    maxScroll = maxScroll + 1
                end
            end
        end
    end
end)

serverList:onChange(updateChannels)
basalt.shedule(function()
    if(bot_id~=nil)then
        for k,v in pairs(servers)do
            local content = http.get("https://discord.com/api/guilds/"..k, {["Content-Type"] = "application/json", ["Authorization"] = "Bot "..bot_id})
            local guild = textutils.unserializeJSON(content.readAll())
            if(guild~=nil)then
                serverList:addItem(guild.name,nil,nil,k)
            end
        end
    end
end)()

updateChannels()



channelRadio:onChange(function(self)
    local val = self:getValue()
    if(val~=nil)and(val.args[1]~=nil)then
        channel_id = val.args[1]
    end
end)

loginFrame:addButton():setAnchor("bottomRight"):setPosition(-10, -2):setSize(11,3):setText("Login"):onClick(function()
    offsetAnimation(main, main:getWidth(), 0)
end)
loginFrame:addLabel():setPosition(3, 5):setText("Servers:")



local function sendDiscordMessage(msg, channel, bot)
    if(channel~=nil)and(bot~=nil)then
        if(nameInput:getValue()~="")then
            msg = string.gsub(msg, "\n", "\\n")
            http.post("https://discord.com/api/channels/"..channel.."/messages", '{ "content": "['..nameInput:getValue()..']: '..msg..'" }', {["Content-Type"] = "application/json", ["Authorization"] = "Bot "..bot}) 
        end
    end
end

newTextFrame:addButton():setText("Send"):setAnchor("bottomRight"):setBackground(colors.black):setForeground(colors.lightGray):setSize(12,1):setPosition(-11,1)
    :onClick(function()
        local msg = table.concat(messageField:getLines(), "\n")
        if(#msg>0)then
            sendDiscordMessage(msg, channel_id, bot_id)
        end
        messageBoxLoseFocus()
    end)

local function refreshMessages()
    while true do
        maxOffset = 0
        updateDiscordMessages(channel_id, bot_id)
        maxOffset = maxOffset - messageFrameList:getHeight()+1
        messageFrameList:setMaxScroll(maxOffset)
        sleep(refreshRate)
    end
end

local thread = main:addThread():start(refreshMessages)

basalt.autoUpdate()
