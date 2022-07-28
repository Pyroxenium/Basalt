# Installer

This is just a script which helps you to setup your program to automatically install the Basalt UI Framework, if it doesn't exists. Means, you create your program (which requires basalt) and add this on the top of your program. Now, everytime you execute your program it checks if basalt.lua (or your custom filepath) exists or not, if not it installs it, or if you are using the advanced installer, it asks the user if the program is allowed to install basalt for you.

## Basic Installer
Here is a very basic one which just installs basalt.lua if don't exist:
```lua
--Basalt configurated installer
local filePath = "basalt.lua" --here you can change the file path default: basalt
if not(fs.exists(filePath))then
    shell.run("pastebin run ESs1mg7P packed true "..filePath:gsub(".lua", "")) -- this is an alternative to the wget command
end
local basalt = require(filePath:gsub(".lua", "")) -- here you can change the variablename in any variablename you want default: basalt
```

## Advanced Installer
This is a visual version, it asks the user if he wants to install basalt.lua (if not found)<br>
![](https://raw.githubusercontent.com/Pyroxenium/Basalt/master/docs/_media/installer.png)
```lua
--Basalt configurated installer
local filePath = "basalt.lua" --here you can change the file path default: basalt
if not(fs.exists(filePath))then
    local w,h = term.getSize()
    term.clear()
    local _installerWindow = window.create(term.current(),w/2-8,h/2-3,18,6)
    _installerWindow.setBackgroundColor(colors.gray)
    _installerWindow.setTextColor(colors.black)
    _installerWindow.write(" Basalt Installer ")
    _installerWindow.setBackgroundColor(colors.lightGray)
    for line=2,6,1 do
        _installerWindow.setCursorPos(1,line)
        if(line==3)then
            _installerWindow.write(" No Basalt found! ")
        elseif(line==4)then
            _installerWindow.write(" Install it?      ")
        elseif(line==6)then
            _installerWindow.setTextColor(colors.black)
            _installerWindow.setBackgroundColor(colors.gray)
            _installerWindow.write("Install")
            _installerWindow.setBackgroundColor(colors.lightGray)
            _installerWindow.write(string.rep(" ",5))
            _installerWindow.setBackgroundColor(colors.red)
            _installerWindow.write("Cancel")
        else
            _installerWindow.write(string.rep(" ",18))
        end
    end
    _installerWindow.setVisible(true)
    _installerWindow.redraw()
    while(not(fs.exists(filePath))) do
        local event, p1,p2,p3,p4 = os.pullEvent()
        if(event=="mouse_click")then
            if(p3==math.floor(h/2+2))and(p2>=w/2-8)and(p2<=w/2-2)then
                shell.run("pastebin run ESs1mg7P packed true "..filePath:gsub(".lua", ""))
                _installerWindow.setVisible(false)
                term.clear()
                break
            end
            if(p3==math.floor(h/2+2))and(p2<=w/2+9)and(p2>=w/2+4)then
                _installerWindow.clear()
                _installerWindow.setVisible(false)
                term.setCursorPos(1,1)
                term.clear()
                return
            end
        end
    end
    term.setCursorPos(1,1)
    term.clear()
end

local basalt = require(filePath:gsub(".lua", "")) -- here you can change the variablename in any variablename you want default: basalt
------------------------------
```
