local _OBJECTS = {}
if(packaged)then
    for k,v in pairs(getProject("objects"))do
        _OBJECTS[k] = v()
    end
    return _OBJECTS
end
for _,v in pairs(fs.list(fs.combine("Basalt", "objects")))do
    if(v~="example.lua")then
        local name = v:gsub(".lua", "")
        _OBJECTS[name] = require(name)
    end
end
return _OBJECTS