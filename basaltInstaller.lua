
local args = table.pack(...)


local function downloadProject(dir)
    local function split(inputstr, sep)
        if sep == nil then
           sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
           table.insert(t, str)
        end
        return t
     end
    shell.run("wget https://raw.githubusercontent.com/Pyroxenium/Basalt/master/projectFiles.txt .projectFiles.txt")
    local projectFiles = {}
    local pFile = fs.open(".projectFiles.txt", "r")

    for line in pFile.readLine do
        local t = split(line, "/")
        if(#t>1)then
            if(projectFiles[t[1]]==nil)then projectFiles[t[1]] = {} end
            table.insert(projectFiles[t[1]], t[2])
        else
            if(projectFiles["default"]==nil)then projectFiles["default"] = {} end
            table.insert(projectFiles["default"], line)
        end
    end
    pFile.close()
    shell.run("rm .projectFiles.txt")
    fs.makeDir(dir)
    fs.makeDir(dir.."/objects")
    fs.makeDir(dir.."/libraries")
    for k,v in pairs(projectFiles["objects"])do
        shell.run("wget https://raw.githubusercontent.com/Pyroxenium/Basalt/master/Basalt/objects/"..v.." "..dir.."/objects/"..v)
    end
    for k,v in pairs(projectFiles["libraries"])do
        shell.run("wget https://raw.githubusercontent.com/Pyroxenium/Basalt/master/Basalt/libraries/"..v.." "..dir.."/libraries/"..v)
    end
    for k,v in pairs(projectFiles["default"])do
        shell.run("wget https://raw.githubusercontent.com/Pyroxenium/Basalt/master/Basalt/"..v.." "..dir.."/"..v)
    end
end

if(#args>0)then
    if(string.lower(args[1])=="bpm")or(string.lower(args[1])=="basaltpackagemanager")then
        shell.run("wget https://raw.githubusercontent.com/Pyroxenium/Basalt/master/basaltPackageManager.lua basaltPackageManager.lua")
    end
    if(string.lower(args[1])=="single")then
        downloadProject("Basalt")
        shell.run("wget https://raw.githubusercontent.com/Pyroxenium/Basalt/master/basaltPackager.lua basaltPackager.lua")
        shell.run("basaltPackager.lua "..tostring(args[2] and false or true))
        fs.delete("Basalt")
    end
else
    downloadProject("Basalt")
end