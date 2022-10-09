return function(path)
    local exists, content = pcall(require, path)
    return exists and content or nil
end