-- this file can download the project or other tools from github

local args = table.pack(...)

-- Creates a filetree based on my github project, ofc you can use this in your projects if you'd like to
local function createTree(page)
    local tree = {}
    local request = http.get(page)
    if not(page)then return end
    for _,v in pairs(textutils.unserialiseJSON(request.readAll()).tree)do
        if(v.type=="blob")then
            table.insert(tree, v.path)
        elseif(v.type=="tree")then
            tree[v.path] = createTree(page.."/"..v.path)
        end
    end
    return tree
end

local function splitString(str, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for v in string.gmatch(str, "([^"..sep.."]+)") do
            table.insert(t, v)
    end
    return t
end

local function download(url, file)
    print("Downloading "..url)
    local httpReq = http.get(url)
        if(httpReq~=nil)then
        local content = httpReq.readAll()
        if not content then
            error("Could not connect to website")
        end
        local f = fs.open(file, "w")
        f.write(content)
        f.close()
    end
end

local function downloadProject(dir, ignoreList)
    local projTree = createTree("https://api.github.com/repos/Pyroxenium/Basalt/git/trees/master:Basalt")
    local projectFiles = {base={}}

    local function isFileInIgnoreList(folder, file)
        if(ignoreList~=nil)then
            if(ignoreList[folder]~=nil)then
                for k,v in pairs(ignoreList[folder])do
                    if(v==file)then
                        return true
                    end
                end
            end
        end
        return false
    end
    for k,v in pairs(projTree)do
        if(k=="objects")then
            projectFiles.objects = {}
            for a,b in pairs(v)do
                if not(isFileInIgnoreList("objects", b))then
                    table.insert(projectFiles.objects, b)
                end
            end
        elseif(k=="libraries")then
            projectFiles.libraries = {}
            for a,b in pairs(v)do
                if not(isFileInIgnoreList("libraries", b))then
                    table.insert(projectFiles.libraries, b)
                end
            end
        else
            table.insert(projectFiles.base, v)
        end
    end

    fs.makeDir(dir)
    fs.makeDir(dir.."/objects")
    fs.makeDir(dir.."/libraries")
    for _,v in pairs(projectFiles["objects"])do
        download("https://raw.githubusercontent.com/Pyroxenium/Basalt/master/Basalt/objects/"..v, dir.."/objects/"..v)
    end
    for _,v in pairs(projectFiles["libraries"])do
        download("https://raw.githubusercontent.com/Pyroxenium/Basalt/master/Basalt/libraries/"..v, dir.."/libraries/"..v)
    end
    for _,v in pairs(projectFiles["base"])do
        download("https://raw.githubusercontent.com/Pyroxenium/Basalt/master/Basalt/"..v, dir.."/"..v)
    end
end

if(#args>0)then
    if(string.lower(args[1])=="bpm")or(string.lower(args[1])=="basaltpackagemanager")then
        download("https://raw.githubusercontent.com/Pyroxenium/Basalt/master/basaltPackageManager.lua", "basaltPackageManager.lua")
        shell.run("basaltPackageManager.lua")
        --shell.run("rm basaltPackageManager.lua")
    end
    if(string.lower(args[1])=="single")then
        downloadProject("Basalt")
        download("https://raw.githubusercontent.com/Pyroxenium/Basalt/master/basaltPackager.lua", "basaltPackager.lua")
        shell.run("basaltPackager.lua "..tostring(args[2] and false or true))
        fs.delete("Basalt")
    end
    if(string.lower(args[1])=="modified")then
        if(args[2]~=nil)then
            local arg = splitString(args[2], ":")
            downloadProject("Basalt", {
                objects = splitString(arg[1], "|"),
                libraries = splitString(arg[2], "|")
            })
        else
            downloadProject("Basalt")
        end
    end
else
    print("Downloading the project...")
    downloadProject("Basalt")
    print("Done!")
end