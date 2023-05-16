-- this file can download the project or other tools from github

local args = table.pack(...)
local installer = {printStatus=true}
installer.githubPath = "https://raw.githubusercontent.com/Pyroxenium/Basalt/"

local projectContentStart = 
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

local projectContentEnd = '\nreturn project["main"]()'

local function split(s, delimiter)
    local result = {}
    if(s~=nil)then
        for match in (s..delimiter):gmatch("(.-)"..delimiter) do
            table.insert(result, match)
        end
    end
    return result
end

local function getFileName(path)
    local parts = split(path, "/")
    return parts[#parts]
end

local function isInIgnoreList(file, ignList)
    if(ignList~=nil) then
        local filePathParts = split(file, "/")
        for k,v in pairs(ignList) do
            if(v == filePathParts[1]) then
                return true
            end
        end
    end
    return false
end

local function printStatus(...)
    if(type(installer.printStatus)=="function")then
        installer.printStatus(...)
    elseif(installer.printStatus)then
        print(...)
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

-- Creates a filetree based on my github project, ofc you can use this in your projects if you'd like to
function installer.createTree(page, branch, dirName, ignList)
    ignList = ignList or {}
    dirName = dirName or ""
    printStatus("Receiving file tree for "..(dirName~="" and "Basalt/"..dirName or "Basalt"))
    local tree = {}
    local request = http.get(page, _G._GIT_API_KEY and {Authorization = "token ".._G._GIT_API_KEY})
    if not(page)then return end
    if(request==nil)then error("API rate limit exceeded. It will be available again in one hour.") end
    for _,v in pairs(textutils.unserialiseJSON(request.readAll()).tree)do
        if(v.type=="blob")then
            local filePath = fs.combine(dirName, v.path)
            if not isInIgnoreList(filePath, ignList) then
                table.insert(tree, {name = v.path, path=filePath, url=installer.githubPath..branch.."/Basalt/"..filePath, size=v.size})
            end
        elseif(v.type=="tree")then
            local dirPath = fs.combine(dirName, v.path)
            if not isInIgnoreList(dirPath, ignList) then
                tree[v.path] = installer.createTree(v.url, branch, dirPath)
            end
        end
    end
    return tree
end

function installer.createIgnoreList(str)
    local files = split(str, ":")
    local ignList = {}
    for k,v in pairs(files)do
        local a = split(v, "/")
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
    return installer.get("https://raw.githubusercontent.com/Pyroxenium/Basalt/master/docs/versions/"..version)
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

function installer.getReleases()
    local content = installer.get("https://api.github.com/repos/Pyroxenium/Basalt/git/trees/master:docs/versions")
    local versions = {}
    if(content~=nil)then
        content = textutils.unserializeJSON(content)
        for k,v in pairs(content.tree)do
            if(v.type=="blob")then
                table.insert(versions, {name=v.path, url="https://raw.githubusercontent.com/Pyroxenium/Basalt/master/docs/versions/"..v.path})
            end
        end
        return versions
    end
end

function installer.getBasaltObjectList(branch)
    branch = branch or "master"
    local content = installer.get("https://api.github.com/repos/Pyroxenium/Basalt/git/trees/"..branch..":Basalt/objects")
    if(content==nil)then
        error("Could not connect to github - rate limit exceeded")
    end
    local objects = {}
    content = textutils.unserializeJSON(content)
    for k,v in pairs(content.tree)do
        if(v.type=="blob")then
            table.insert(objects, {name=v.path, url="https://raw.githubusercontent.com/Pyroxenium/Basalt/"..branch.."/Basalt/objects/"..v.path})
        end
    end
    return objects
end

function installer.getAdditionalObjectList()
    local content = installer.get("https://api.github.com/repos/Pyroxenium/BasaltAdditions/git/trees/main:objects")
    if(content==nil)then
        error("Could not connect to github - rate limit exceeded")
    end
    local objects = {}
    content = textutils.unserializeJSON(content)
    for k,v in pairs(content.tree)do
        if(v.type=="blob")then
            table.insert(objects, {name=v.path, url="https://raw.githubusercontent.com/Pyroxenium/BasaltAdditions/main/objects/"..v.path})
        end
    end
    return objects
end

function installer.getAdditionalProgramList()
    local content = installer.get("https://api.github.com/repos/Pyroxenium/BasaltAdditions/git/trees/main:programs")
    if(content==nil)then
        error("Could not connect to github - rate limit exceeded")
    end
    local objects = {}
    content = textutils.unserializeJSON(content)
    for k,v in pairs(content.tree)do
        if(v.type=="blob")then
            table.insert(objects, {name=v.path, url="https://raw.githubusercontent.com/Pyroxenium/BasaltAdditions/main/programs/"..v.path})
        end
    end
    return objects
end

function installer.downloadAdditionalObject(file, path)
    local content = installer.get("https://raw.githubusercontent.com/Pyroxenium/BasaltAdditions/main/objects/"..file)
    if(content==nil)then
        error("Could not connect to github - rate limit exceeded")
    end
    if(content~=nil)then
        local f = fs.open(path, "w")
        f.write(content)
        f.close()
        return true
    end
    return false
end

function installer.downloadAdditionalPlugin(file, path)
    local content = installer.get("https://raw.githubusercontent.com/Pyroxenium/BasaltAdditions/main/plugins/"..file)
    if(content==nil)then
        error("Could not connect to github - rate limit exceeded")
    end
        local f = fs.open(path, "w")
        f.write(content)
        f.close()
    return true
end

function installer.downloadProgram(file, path)
    local content = installer.get("https://raw.githubusercontent.com/Pyroxenium/BasaltAdditions/main/programs/"..file)
    if(content==nil)then
        error("Could not connect to github - rate limit exceeded")
    end
        local f = fs.open(path, "w")
        f.write(content)
        f.close()
    return true
end

function installer.getBasaltPluginList(branch)
    branch = branch or "master"
    local content = installer.get("https://api.github.com/repos/Pyroxenium/Basalt/git/trees/"..branch..":Basalt/plugins")
    local plugins = {}
    if(content~=nil)then
        content = textutils.unserializeJSON(content)
        for k,v in pairs(content.tree)do
            if(v.type=="blob")then
                table.insert(plugins, {name=v.path, url="https://raw.githubusercontent.com/Pyroxenium/Basalt/"..branch.."/Basalt/plugins/"..v.path})
            end
        end
        return plugins
    end
end

function installer.getAdditionalPluginList()
    local content = installer.get("https://api.github.com/repos/Pyroxenium/BasaltAdditions/git/trees/main:plugins")
    local plugins = {}
    if(content~=nil)then
        content = textutils.unserializeJSON(content)
        for k,v in pairs(content.tree)do
            if(v.type=="blob")then
                table.insert(plugins, {name=v.path, url="https://raw.githubusercontent.com/Pyroxenium/BasaltAdditions/main/plugins/"..v.path})
            end
        end
        return plugins
    end
end

function installer.getPackedProject(branch, ignoreList)
    if (ignoreList==nil)then 
        ignoreList = {"init.lua"} 
    else
        table.insert(ignoreList, "init.lua")
    end
    local projTree = installer.createTree("https://api.github.com/repos/Pyroxenium/Basalt/git/trees/"..branch..":Basalt", branch, "", ignoreList)
    local project = {}

    local fList = {}
    local delay = 0
    for k,v in pairs(projTree)do
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

    local projectContent = projectContentStart
    
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
    projectContent = projectContent..projectContentEnd
    
    return projectContent
end

function installer.generateWebVersion(file, version)
    if(fs.exists(file))then error("A file called "..file.." already exists!") end
    version = version or "latest.lua"
    local request = http.get("https://basalt.madefor.cc/versions/"..version, _G._GIT_API_KEY and {Authorization = "token ".._G._GIT_API_KEY})
    if(request~=nil)then
        if(fs.exists(file))then
            fs.delete(file)
           end
            local f = fs.open(file, "w")
            local link = "https://basalt.madefor.cc/versions/"..version
            local content = 'local request = http.get("'..link..'", _G._GIT_API_KEY and {Authorization = "token ".._G._GIT_API_KEY})\n'
            content = content..
[[
if(request~=nil)then
    return load(request.readAll())()
else
    error("Unable to connect to ]]..link..[[")
end
]]
            f.write(content)
            f.close()
            printStatus("Web version successfully downloaded!")
    else
        error("Version doesn't exist!")
    end
end

function installer.getProjectFiles(branch, ignoreList)
    local projTree = installer.createTree("https://api.github.com/repos/Pyroxenium/Basalt/git/trees/"..branch..":Basalt", branch, "", ignoreList)
    local project = {}

    local function downloadFile(url, path)
        project[path] = installer.get(url)
    end

    local fList = {}
    local delay = 0
    for k,v in pairs(projTree)do
        if(type(k)=="string")then
            for a,b in pairs(v)do
                table.insert(fList, function() sleep(delay) downloadFile(b.url, b.path) end)
                delay = delay + 0.05
            end
        else
            table.insert(fList, function() sleep(delay) downloadFile(v.url, v.path) end)
            delay = delay + 0.05
        end
    end
    parallel.waitForAll(table.unpack(fList))
    
    return project
end

function installer.downloadPacked(filename, branch, ignoreList, minify)
    if(fs.exists(filename))then error("A file called "..filename.." already exists!") end
    local projectContent = installer.getPackedProject(branch, ignoreList)
    if(minify)then
        local min
        if(fs.exists("packager.lua"))then
            local f = fs.open("packager.lua", "r")
            min = load(f.readAll())()
            f.close()
        else
            min = load(installer.get("https://raw.githubusercontent.com/Pyroxenium/Basalt/master/docs/packager.lua"))()
        end
        if(min~=nil)then
            local success, data = min(projectContent)
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
    printStatus("Packed version successfully downloaded!")
end

function installer.downloadProject(projectDir, branch, ignoreList)
    if(fs.exists(projectDir))then error("A folder called "..projectDir.." already exists!") end
    projectDir = projectDir or "basalt"
    branch = branch or "master"
    local projectFiles = installer.getProjectFiles(branch, ignoreList)
    fs.makeDir(projectDir)
    for k,v in pairs(projectFiles)do
        local f = fs.open(fs.combine(projectDir, k), "w")
        f.write(v)
        f.close()
    end
    printStatus("Source version successfully downloaded!")
end

function installer.executeUI()
    local env = _ENV
    env.basalt = load(installer.get("https://basalt.madefor.cc/bTemp.lua"))() -- bTemp needs to be replaced later
    local ui = installer.get("https://basalt.madefor.cc/ui.lua")
    if(ui~=nil)then
        load(ui, nil, "t", env)()
    else
        error("Unable to connect to https://basalt.madefor.cc/ui.lua")
    end
end

function installer.generateCustomBasalt(files, basePath, branch)
    branch = branch or "master"
    local projectFiles = installer.getProjectFiles(branch, {"plugins", "objects"})
    local project = {}

    local function downloadFile(url, path)
        local folder = split(path, "/")
        if(#folder>1)then
            project[basePath..path] = {content=installer.get(url), folder=folder[2], filename=folder[#folder], url=url}
        else
            project[basePath..path] = {content=installer.get(url), folder="", filename=path, url=url}
        end
    end

    local fList = {}
    local delay = 0

    for k,v in pairs(projectFiles)do
        local folder = split(k, "/")
        if(#folder>1)then
            project[fs.combine(basePath, k)] = {content=v, folder=folder[1], filename=folder[#folder], url=""}
        else
            project[fs.combine(basePath, k)] = {content=v, folder="", filename=k, url=""}
        end
    end

    if(files.objects~=nil)then
        for _,v in pairs(files.objects)do
            table.insert(fList, function() sleep(delay) downloadFile(v.url, "/objects/"..v.name) end)
        end
    end
    if(files.plugins~=nil)then
        for _,v in pairs(files.plugins)do
            table.insert(fList, function() sleep(delay) downloadFile(v.url, "/plugins/"..v.name) end)
        end
    end

    parallel.waitForAll(table.unpack(fList))
    return project
end

function installer.downloadCustomBasalt(files, version, basePath, branch, minify)
    local project = installer.generateCustomBasalt(files, basePath, branch)

    if(version=="source")then
        for k,v in pairs(project)do
            local f = fs.open(k, "w")
            f.write(v.content)
            f.close()
        end
    elseif(version=="packed")then
        local projectContent = projectContentStart.."\nproject = {objects={}, plugins={}, libraries={}}"
        for _,v in pairs(project)do
            if(v.folder~="")then
                projectContent = projectContent.."\nproject['"..v.folder.."']['"..v.filename:gsub(".lua", "").."'] = ".."function(...)\n"..v.content.."\nend"
            else
                projectContent = projectContent.."\nproject['"..v.filename:gsub(".lua", "").."'] = ".."function(...)\n"..v.content.."\nend"
            end
        end
        projectContent = projectContent..projectContentEnd
        if(minify)then
            local min
            if(fs.exists("packager.lua"))then
                local f = fs.open("packager.lua", "r")
                min = load(f.readAll())()
                f.close()
            else
                min = load(installer.get("https://raw.githubusercontent.com/Pyroxenium/Basalt/master/docs/packager.lua"))()
            end
            if(min~=nil)then
                local success, data = min(projectContent)
                if(success)then
                    local f = fs.open(basePath, "w")
                    f.write(data)
                    f.close()
                else
                    error(data)
                end
            end
        else
            local f = fs.open(basePath, "w")
            f.write(projectContent)
            f.close()
        end
    end
end

if(#args>0)then
    if(string.lower(args[1])=="bpm")or(string.lower(args[1])=="basaltpackagemanager")or(string.lower(args[1])=="gui")or(string.lower(args[1])=="ui")then
        installer.executeUI()
    elseif(string.lower(args[1])=="packed")then
        installer.downloadPacked(args[2] or "basalt.lua", args[3] or "master", args[4]~=nil and installer.createIgnoreList(args[4]) or nil, args[5] == "false" and false or true)
    elseif(string.lower(args[1])=="source")then
        installer.downloadProject(args[2] or "basalt", args[3] or "master", args[4]~=nil and installer.createIgnoreList(args[4]) or nil)
    elseif(string.lower(args[1])=="web")then
        installer.generateWebVersion(args[3] or "basaltWeb.lua", args[2] or "latest.lua")
    elseif(string.lower(args[1])=="file")or(string.lower(args[1])=="release")then
        installer.downloadRelease(args[2] or "latest.lua", args[3] or "basalt.lua")
    end
end

return installer