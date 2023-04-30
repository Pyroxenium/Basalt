-- Most of this is made by Dev9551, you can find his awesome work here: https://github.com/9551-Dev/apis/blob/main/pixelbox_lite.lua
-- Slighly modified by NyoriE to work with Basalt

--[[
The MIT License (MIT)
Copyright © 2022 Oliver Caha (9551Dev)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]
local t_sort,t_cat,s_char  = table.sort,table.concat,string.char
local function sort(a,b) return a[2] > b[2] end

local distances = {
    {5,256,16,8,64,32},
    {4,16,16384,256,128},
    [4] = {4,64,1024,256,128},
    [8] = {4,512,2048,256,1},
    [16] = {4,2,16384,256,1},
    [32] = {4,8192,4096,256,1},
    [64] = {4,4,1024,256,1},
    [128] = {6,32768,256,1024,2048,4096,16384},
    [256] = {6,1,128,2,512,4,8192},
    [512] = {4,8,2048,256,128},
    [1024] = {4,4,64,128,32768},
    [2048] = {4,512,8,128,32768},
    [4096] = {4,8192,32,128,32768},
    [8192] = {3,32,4096,256128},
    [16384] = {4,2,16,128,32768},
    [32768] = {5,128,1024,2048,4096,16384}
}

local to_colors = {}
for i = 0, 15 do
    to_colors[("%x"):format(i)] = 2^i
end

local to_blit = {}
for i = 0, 15 do
    to_blit[2^i] = ("%x"):format(i)
end

local function pixelbox(colTable, defaultCol)
    defaultCol = defaultCol or "f"
    local width, height = #colTable[1], #colTable
    local cache = {}
    local canv = {}
    local cached = false
    
    local function generateCanvas()
        for y = 1, height * 3 do
            for x = 1, width * 2 do
                if not canv[y] then canv[y] = {} end
                canv[y][x] = defaultCol
            end
        end

        for k, v in ipairs(colTable) do
            for x = 1, #v do
                local col = v:sub(x, x)
                canv[k][x] = to_colors[col]
            end
        end
    end
    generateCanvas()

    local function setSize(w,h)
        width, height = w, h
        canv = {}
        cached = false
        generateCanvas()
    end


    local function generateChar(a,b,c,d,e,f)
        local arr = {a,b,c,d,e,f}
        local c_types = {}
        local sortable = {}
        local ind = 0
        for i=1,6 do
            local c = arr[i]
            if not c_types[c] then
                ind = ind + 1
                c_types[c] = {0,ind}
            end
    
            local t = c_types[c]
            local t1 = t[1] + 1
    
            t[1] = t1
            sortable[t[2]] = {c,t1}
        end
        local n = #sortable
        while n > 2 do
            t_sort(sortable,sort)
            local bit6 = distances[sortable[n][1]]
            local index,run = 1,false
            local nm1 = n - 1
            for i=2,bit6[1] do
                if run then break end
                local tab = bit6[i]
                for j=1,nm1 do
                    if sortable[j][1] == tab then
                        index = j
                        run = true
                        break
                    end
                end
            end
            local from,to = sortable[n][1],sortable[index][1]
            for i=1,6 do
                if arr[i] == from then
                    arr[i] = to
                    local sindex = sortable[index]
                    sindex[2] = sindex[2] + 1
                end
            end
    
            sortable[n] = nil
            n = n - 1
        end
    
        local n = 128
        local a6 = arr[6]
    
        if arr[1] ~= a6 then n = n + 1 end
        if arr[2] ~= a6 then n = n + 2 end
        if arr[3] ~= a6 then n = n + 4 end
        if arr[4] ~= a6 then n = n + 8 end
        if arr[5] ~= a6 then n = n + 16 end
    
        if sortable[1][1] == arr[6] then
            return s_char(n),sortable[2][1],arr[6]
        else
            return s_char(n),sortable[1][1],arr[6]
        end
    end

    local function convert()
        local w_double = width * 2

        local sy = 0
        for y = 1, height * 3, 3 do
            sy = sy + 1
            local layer_1 = canv[y]
            local layer_2 = canv[y + 1]
            local layer_3 = canv[y + 2]
            local char_line, fg_line, bg_line = {}, {}, {}
            local n = 0
            for x = 1, w_double, 2 do
                local xp1 = x + 1
                local b11, b21, b12, b22, b13, b23 = layer_1[x], layer_1[xp1], layer_2[x], layer_2[xp1], layer_3[x], layer_3[xp1]

                local char, fg, bg = " ", 1, b11
                if not (b21 == b11 and b12 == b11 and b22 == b11 and b13 == b11 and b23 == b11) then
                    char, fg, bg = generateChar(b11, b21, b12, b22, b13, b23)
                end
                n = n + 1
                char_line[n] = char
                fg_line[n] = to_blit[fg]
                bg_line[n] = to_blit[bg]
            end

            cache[sy] = {t_cat(char_line), t_cat(fg_line), t_cat(bg_line)}
        end
        cached = true
    end

    return {
        convert = convert,
        generateCanvas = generateCanvas,
        setSize = setSize,
        getSize = function()
            return width, height
        end,
        set = function(colTab, defCol)
            colTable = colTab
            defaultCol = defCol or defaultCol
            canv = {}
            cached = false
            generateCanvas()
        end,
        get = function(y)
            if not cached then convert() end
            return y~= nil and cache[y] or cache
        end
    }
end

return {
    Image = function(base, basalt)
        return {
            shrink = function(self)
                local bimg = self:getImageFrame(1)
                local img = {}
                for k,v in pairs(bimg)do
                    if(type(k)=="number")then
                        table.insert(img,v[3])
                    end
                end
                local shrinkedImg = pixelbox(img, self:getBackground()).get()
                self:setImage(shrinkedImg)
                return self
            end,

            getShrinkedImage = function(self)
                local bimg = self:getImageFrame(1)
                local img = {}
                for k,v in pairs(bimg)do
                    if(type(k)=="number")then
                        table.insert(img, v[3])
                    end
                end
                return pixelbox(img, self:getBackground()).get()
            end,
        }
    end,
}