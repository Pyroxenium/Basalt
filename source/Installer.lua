--[[
To install basalt copy paste the following line to your computer:
 
pastebin run ESs1mg7P
 
---------------------------------------------
Hi, this is the installer for the UI Framework basalt!
currently its just a single file. In the near future i will split my project into multiple files and "compile" it to one single file on your computer.
You are curious what basalt is? check out my github wiki: https://github.com/NoryiE/Basalt/wiki/
----------------------------------------------
]]
local args = {...}
 
local defaultFilePath = args[1] or "basalt.lua"
 
shell.run("wget https://raw.githubusercontent.com/Pyroxenium/Basalt/master/basalt.lua "..defaultFilePath)