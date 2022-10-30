-- this file can download the project or other tools from github

local args = table.pack(...)
local installer = {printStatus=true}
installer.githubPath = "https://raw.githubusercontent.com/Pyroxenium/Basalt/"

local function printStatus(...)
    if(installer.printStatus)then
        print(...)
    elseif(type(installer.printStatus)=="function")then
        installer.printStatus(...)
    end
end

function installer.get(url)
    local httpReq = http.get(url, _G._GIT_API_KEY and {Authorization = "token ".._G._GIT_API_KEY})
    printStatus("Downloading "..url)
    if(httpReq~=nil)then
        local content = httpReq.readAll()
        if not content then
            error("Could not connect to website")
        end
        return content
    end
end

local basaltDataCache
function installer.getBasaltData()
    if(basaltDataCache~=nil)then return basaltDataCache end
    local content
    printStatus("Downloading basalt data...")
    if(fs.exists("basaltdata.json"))then
        content = fs.open("basaltdata.json", "r")
    else
        content = installer.get("https://basalt.madefor.cc/basaltdata.json")
    end
    if(content~=nil)then
        content = content.readAll()
        basaltDataCache = textutils.unserializeJSON(content)
        printStatus("Successfully downloaded basalt data!")
        return basaltDataCache
    end
end

-- Creates a filetree based on my github project, ofc you can use this in your projects if you'd like to
function installer.createTree(page, branch, dirName)
    dirName = dirName or ""
    printStatus("Receiving file tree for "..dirName~="" and dirName or "Basalt")
    local tree = {}
    local request = http.get(page, _G._GIT_API_KEY and {Authorization = "token ".._G._GIT_API_KEY})
    if not(page)then return end
    if(request==nil)then error("API rate limit exceeded. It will be available again in a couple of hours.") end
    for _,v in pairs(textutils.unserialiseJSON(request.readAll()).tree)do
        if(v.type=="blob")then
            table.insert(tree, {name = v.path, path=fs.combine(dirName, v.path), url=installer.githubPath..branch.."/Basalt/"..fs.combine(dirName, v.path), size=v.size})
        elseif(v.type=="tree")then
            tree[v.path] = installer.createTree(v.url, branch, fs.combine(dirName, v.path))
        end
    end
    return tree
end

-- Creates a filetree based on my github project, ofc you can use this in your projects if you'd like to
function installer.createTableTree(page, branch, dirName)
    dirName = dirName or ""
    printStatus("Receiving file tree for "..dirName~="" and dirName or "Basalt")
    local tree = {}
    local request = http.get(page, _G._GIT_API_KEY and {Authorization = "token ".._G._GIT_API_KEY})
    if not(page)then return end
    if(request==nil)then error("API rate limit exceeded. It will be available again in a couple of hours.") end
    for _,v in pairs(textutils.unserialiseJSON(request.readAll()).tree)do
        if(v.type=="blob")then
            table.insert(tree, {name = v.path, path=fs.combine(dirName, v.path), url=installer.githubPath..branch.."/Basalt/"..fs.combine(dirName, v.path), size=v.size})
        elseif(v.type=="tree")then
            tree[v.path] = installer.createTableTree(v.url, branch, fs.combine(dirName, v.path))
        end
    end
    return tree
end

function installer.createTreeByBasaltData(page, branch, dirName)
    dirName = dirName or ""
    printStatus("Receiving file tree for "..dirName~="" and dirName or "Basalt")
    local bData = installer.getBasaltData()
    if(bData~=nil)then
        local tree = {}
        for k,v in pairs(bData.structure)do
            if(k=="base")then
                for a,b in pairs(v)do
                    table.insert(tree, b)
                end
            else
                tree[k] = v
            end
        end
        return tree
    end
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

function installer.createIgnoreList(str)
    local files = splitString(str, ":")
    local ignList = {}
    for k,v in pairs(files)do
        local a = splitString(v, "/")
        if(#a>1)then
            if(ignList[a[1]]==nil)then ignList[a[1]] = {} end
            table.insert(ignList[a[1]], a[2])
        else
            table.insert(ignList, v)
        end
    end
end

function installer.download(url, file)
    local content = installer.get(url)
    if(content~=nil)then
        local f = fs.open(file, "w")
        f.write(content)
        f.close()
    end
end

function installer.getRelease(version)
    local v = installer.getBasaltData().versions[version]
    if(v~=nil)then
        printStatus("Downloading basalt "..version)
        local content = http.get("https://basalt.madefor.cc/versions/"..v, {Authorization =  _G._GIT_API_KEY and  "token ".._G._GIT_API_KEY})
        if(content~=nil)then
            return content.readAll()
        end
    end
end

function installer.downloadRelease(version, file)
    local content = installer.getRelease(version)
    if(content~=nil)then
        local f = fs.open(file or "basalt.lua", "w")
        f.write(content)
        f.close()
        return true
    end
    return false
end

function installer.getPackedProject(branch, ignoreList)
    if (ignoreList==nil)then 
        ignoreList = {"init.lua"} 
    else
        table.insert(ignoreList, "init.lua")
    end
    local projTree = installer.createTableTree("https://api.github.com/repos/Pyroxenium/Basalt/git/trees/"..branch..":Basalt", branch, "")
    local filteredList = {}
    local project = {}

    local function isInIgnoreList(file, ign)
        if(ign~=nil)then
            for k,v in pairs(ign)do
                if(v==file.name)then
                    return true
                end
            end
        end
        return false
    end

    for k,v in pairs(projTree)do
        if(type(k)=="string")then
            for a,b in pairs(v)do
                if not(isInIgnoreList(b, ignoreList~=nil and ignoreList[k] or nil))then
                    if(filteredList[k]==nil)then filteredList[k] = {} end
                    table.insert(filteredList[k], b)
                end
            end
        else
            if not(isInIgnoreList(v, ignoreList))then
                table.insert(filteredList, v)
            end
        end
    end

    local fList = {}
    local delay = 0
    for k,v in pairs(filteredList)do
        if(type(k)=="string")then
            for a,b in pairs(v)do
                table.insert(fList, function() sleep(delay) 
                    if(project[k]==nil)then project[k] = {} end
                    table.insert(project[k], {content=installer.get(b.url), name=b.name, path=b.path, size = b.size, url = b.url})
                    delay = delay + 0.05 
                end)
            end
        else
            table.insert(fList, function() sleep(delay) table.insert(project, {content=installer.get(v.url), name=v.name, path=v.path, size = v.size, url = v.url}) delay = delay + 0.05 end)
        end
    end

    parallel.waitForAll(table.unpack(fList))

    local projectContent = 
[[
local project = {} 
local packaged = true 
local baseRequire = require 
local require = function(path)
    for k,v in pairs(project)do
        if(type(v)=="table")then
            for name,b in pairs(v)do
                if(name==path)then
                    return b()
                end
            end
        else
            if(k==path)then
                return v()
            end
        end
    end
    return baseRequire(path);
end
local getProject = function(subDir)
    if(subDir~=nil)then
        return project[subDir]
    end
    return project
end
]]
    
    for k,v in pairs(project)do
        if(type(k)=="string")then
            local newSubDir = 'project["'..k..'"] = {}\n'
            projectContent = projectContent.."\n"..newSubDir
            for a,b in pairs(v)do
                local newFile = 'project["'..k..'"]["'..b.name:gsub(".lua", "")..'"] = function(...)\n'..b.content..'\nend'
                projectContent = projectContent.."\n"..newFile
            end
        else
            local newFile = 'project["'..v.name:gsub(".lua", "")..'"] = function(...)\n'..v.content..'\nend'
            projectContent = projectContent.."\n"..newFile
        end
    end
    projectContent = projectContent..'\n return project["main"]()'
    
    return projectContent
end

function installer.generateWebVersion(file, version)
    version = version or "latest.lua"
    local request = http.get("https://basalt.madefor.cc/versions/"..version, _G._GIT_API_KEY and {Authorization = "token ".._G._GIT_API_KEY})
    if(request~=nil)then
        if(fs.exists(file))then
            fs.delete(file)
            local f = fs.open(file, "w")
            local link = "https://basalt.madefor.cc/versions/"..version
            local content = 'local request = http.get("'..link..'", _G._GIT_API_KEY and {Authorization = "token ".._G._GIT_API_KEY})\n'
            content = content..[[
if(request~=nil)then
    return load(request.readAll())()
else
    error("Unable to connect to ]]..link..[[)
end
            ]]
            f:write(content)
        end
    else
        error("Version doesn't exist!")
    end
end

function installer.getProjectFiles(branch, ignoreList)
    local projTree = installer.createTree("https://api.github.com/repos/Pyroxenium/Basalt/git/trees/"..branch..":Basalt", branch, "")
    local filteredList = {}
    local project = {}

    local function isInIgnoreList(file)
        if(ignoreList~=nil)then
            for k,v in pairs(ignoreList)do
                if(v==file)then
                    return true
                end
            end
        end
        return false
    end

    for k,v in pairs(projTree)do
        if not(isInIgnoreList(v))then
            table.insert(filteredList, v)
        end
    end

    local function downloadFile(url, path)
        project[path] = installer.get(url)
    end

    local fList = {}
    local delay = 0
    for k,v in pairs(filteredList)do
        table.insert(fList, function() sleep(delay) downloadFile(v.url, v.path) delay = delay + 0.05 end)
    end
    parallel.waitForAll(table.unpack(fList))
    
    return project
end

function installer.downloadPacked(filename, branch, ignoreList, minify)
    local projectContent = installer.getPackedProject(branch, ignoreList)
    if(minify)then
        local min
        if(fs.exists("packager.lua"))then
            min = require("packager")
        else
            min = load(installer.get("https://raw.githubusercontent.com/Pyroxenium/Basalt/master/docs/packager.lua"))()
        end
        if(min~=nil)then
            success, data = min(projectContent)
            if(success)then
                projectContent = data
            else
                error(data)
            end
        end
    end
    local f = fs.open(filename, "w")
    f.write(projectContent)
    f.close()    
end

function installer.downloadProject(projectDir, branch, ignoreList)
    local projectFiles = installer.getProjectFiles(branch, ignoreList)
    projectDir = projectDir or "basalt"
    branch = branch or "master"

    local function downloadFile(url, path)
        print("Downloading "..path)
        local files = splitString(path)
        if(#files>1)then
            local folderPath = ""
            for a,b in pairs(files)do
                if(a<#files)then
                    folderPath = fs.combine(folderPath, b)
                else
                    if not (fs.exists(folderPath))then fs.makeDir(folderPath) end
                    installer.download(url, fs.combine(projectDir, path))
                end
            end
        else
            installer.download(url, fs.combine(projectDir, path))
        end
    end

    local fList = {}
    local delay = 0
    for k,v in pairs(projectFiles)do
        table.insert(fList, function() sleep(delay) downloadFile(v.url, v.path) delay = delay + 0.05 end)
    end
    parallel.waitForAll(table.unpack(fList))
end

if(#args>0)then
    if(string.lower(args[1])=="bpm")or(string.lower(args[1])=="basaltpackagemanager")or(string.lower(args[1])=="gui")then
        installer.download("https://raw.githubusercontent.com/Pyroxenium/Basalt/master/basaltPackageManager.lua", "basaltPackageManager.lua")
        if(args[2]=="true")then shell.run("basaltPackageManager.lua") fs.delete("basaltPackageManager.lua") end
            
    elseif(string.lower(args[1])=="packed")then
        installer.downloadPacked(args[2] or "basalt.lua", args[3] or "master", args[4]~=nil and installer.createIgnoreList(args[4]) or nil, args[5] == "false" and false or true)
    elseif(string.lower(args[1])=="source")then
        installer.downloadProject(args[2] or "basalt", args[3] or "master", args[4]~=nil and installer.createIgnoreList(args[4]) or nil)
    elseif(string.lower(args[1])=="web")then
        installer.generateWebVersion(args[3] or "basaltWeb.lua", args[2] or "latest.lua")
    end
end

return installer