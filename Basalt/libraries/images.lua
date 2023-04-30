local sub,floor = string.sub,math.floor

local function loadNFPAsBimg(path)
    return {[1]={{}, {}, paintutils.loadImage(path)}}, "bimg"
end

local function loadNFP(path)
    return paintutils.loadImage(path), "nfp"
end

local function loadBIMG(path, binaryMode)
    local f = fs.open(path, binaryMode and "rb" or "r")
    if(f==nil)then error("Path - "..path.." doesn't exist!") end
    local content = textutils.unserialize(f.readAll())
    f.close()
    if(content~=nil)then
        return content, "bimg"
    end
end

local function loadBBF(path)

end

local function loadBBFAsBimg(path)

end

local function loadImage(path, f, binaryMode)
    if(sub(path, -4) == ".bimg")then
        return loadBIMG(path, binaryMode)
    elseif(sub(path, -3) == ".bbf")then
        return loadBBF(path, binaryMode)
    else
        return loadNFP(path, binaryMode)
    end
    -- ...
end

local function loadImageAsBimg(path)
    if(path:find(".bimg"))then
        return loadBIMG(path)
    elseif(path:find(".bbf"))then
        return loadBBFAsBimg(path)
    else
        return loadNFPAsBimg(path)
    end
end

local function resizeBIMG(source, w, h)
    local oW, oH = source.width or #source[1][1][1], source.height or #source[1]
    local newImg = {}
    for k,v in pairs(source)do
        if(type(k)=="number")then
            local frame = {}
            for y=1, h do
                local xT,xFG,xBG = "","",""
                local yR = floor(y / h * oH + 0.5)
                if(v[yR]~=nil)then
                    for x=1, w do
                        local xR = floor(x / w * oW + 0.5)
                        xT = xT..sub(v[yR][1], xR,xR)
                        xFG = xFG..sub(v[yR][2], xR,xR)
                        xBG = xBG..sub(v[yR][3], xR,xR)
                    end
                    table.insert(frame, {xT, xFG, xBG})
                end
            end
            table.insert(newImg, k, frame)
        else
            newImg[k] = v
        end
    end
    newImg.width = w
    newImg.height = h
    return newImg
end

return {
    loadNFP = loadNFP,
    loadBIMG = loadBIMG,
    loadImage = loadImage,
    resizeBIMG = resizeBIMG,
    loadImageAsBimg = loadImageAsBimg,

}