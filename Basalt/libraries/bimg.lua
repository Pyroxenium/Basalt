local sub,rep = string.sub,string.rep

local function frame(base, manager)
    local w, h = 0, 0
    local t,fg,bg = {}, {}, {}
    local x, y = 1,1

    local data = {}

    local function recalculateSize()
        for y=1,h do
            if(t[y]==nil)then
                t[y] = rep(" ", w)
            else
                t[y] = t[y]..rep(" ", w-#t[y])
            end
            if(fg[y]==nil)then
                fg[y] = rep("0", w)
            else
                fg[y] = fg[y]..rep("0", w-#fg[y])
            end
            if(bg[y]==nil)then
                bg[y] = rep("f", w)
            else
                bg[y] = bg[y]..rep("f", w-#bg[y])
            end
        end
    end

    local addText = function(text, _x, _y)
        x = _x or x
        y = _y or y
        if(t[y]==nil)then
            t[y] = rep(" ", x-1)..text..rep(" ", w-(#text+x))
        else
            t[y] = sub(t[y], 1, x-1)..rep(" ", x-#t[y])..text..sub(t[y], x+#text, w)
        end
        if(#t[y]>w)then w = #t[y] end
        if(y > h)then h = y end  
        manager.updateSize(w, h)
    end

    local addBg = function(b, _x, _y)
        x = _x or x
        y = _y or y
        if(bg[y]==nil)then
            bg[y] = rep("f", x-1)..b..rep("f", w-(#b+x))
        else
            bg[y] = sub(bg[y], 1, x-1)..rep("f", x-#bg[y])..b..sub(bg[y], x+#b, w)
        end
        if(#bg[y]>w)then w = #bg[y] end
        if(y > h)then h = y end  
        manager.updateSize(w, h)
    end

    local addFg = function(f, _x, _y)
        x = _x or x
        y = _y or y
        if(fg[y]==nil)then
            fg[y] = rep("0", x-1)..f..rep("0", w-(#f+x))
        else
            fg[y] = sub(fg[y], 1, x-1)..rep("0", x-#fg[y])..f..sub(fg[y], x+#f, w)
        end
        if(#fg[y]>w)then w = #fg[y] end
        if(y > h)then h = y end  
        manager.updateSize(w, h)
    end

    local function setFrame(frm)
        data = {}
        t, fg, bg = {}, {}, {}
        for k,v in pairs(base)do
            if(type(k)=="string")then
                data[k] = v
            else
                t[k], fg[k], bg[k] = v[1], v[2], v[3]
            end
        end
        manager.updateSize(w, h)
    end

    if(base~=nil)then
        if(#base>0)then
            w = #base[1][1]
            h = #base
            setFrame(base)
        end
    end

    return {
        recalculateSize = recalculateSize,
        setFrame = setFrame,

        getFrame = function()
            local f = {}

            for k,v in pairs(t)do
                table.insert(f, {v, fg[k], bg[k]})
            end

            for k,v in pairs(data)do
                f[k] = v
            end
            
            return f, w, h
        end,

        getImage = function()
            local i = {}
            for k,v in pairs(t)do
                table.insert(i, {v, fg[k], bg[k]})
            end
            return i
        end,

        setFrameData = function(key, value)
            if(value~=nil)then
                data[key] = value
            else
                if(type(key)=="table")then
                    data = key
                end
            end
        end,

        setFrameImage = function(imgData)
            for k,v in pairs(imgData.t)do
                t[k] = imgData.t[k]
                fg[k] = imgData.fg[k]
                bg[k] = imgData.bg[k]
            end
        end,

        getFrameImage = function()
            return {t = t, fg = fg, bg = bg}
        end,

        getFrameData = function(key)
            if(key~=nil)then
                return data[key]
            else
                return data
            end
        end,

        blit = function(text, fgCol, bgCol, x, y)
            addText(text, x, y)
            addFg(fgCol, x, y)
            addBg(bgCol, x, y)
        end,
        
        text = addText,
        fg = addFg,
        bg = addBg,

        getSize = function()
            return w, h
        end,

        setSize = function(_w, _h)
            local nt,nfg,nbg = {}, {}, {}
            for _y=1,_h do
                if(t[_y]~=nil)then
                    nt[_y] = sub(t[_y], 1, _w)..rep(" ", _w - w)
                else
                    nt[_y] = rep(" ", _w)
                end
                if(fg[_y]~=nil)then
                    nfg[_y] = sub(fg[_y], 1, _w)..rep("0", _w - w)
                else
                    nfg[_y] = rep("0", _w)
                end
                if(bg[_y]~=nil)then
                    nbg[_y] = sub(bg[_y], 1, _w)..rep("f", _w - w)
                else
                    nbg[_y] = rep("f", _w)
                end
            end
            t, fg, bg = nt, nfg, nbg
            w, h = _w, _h
        end,
    }
end

return function(img)
    local frames = {}
    local metadata = {creator="Bimg Library by NyoriE", date=os.date("!%Y-%m-%dT%TZ")}
    local width,height = 0, 0

    local manager = {}

    local function addFrame(id, data)
        id = id or #frames+1
        local f = frame(data, manager)
        table.insert(frames, id, f)
        if(data==nil)then
            frames[id].setSize(width, height)
        end
        return f
    end

    local function removeFrame(id)
        table.remove(frames, id or #frames)
    end

    local function moveFrame(id, dir)
        local f = frames[id]
        if(f~=nil)then
        local newId = id+dir
            if(newId>=1)and(newId<=#frames)then
                table.remove(frames, id)
                table.insert(frames, newId, f)
            end
        end
    end

    manager = {
        updateSize = function(w, h, force)
            local changed = force==true and true or false
            if(w > width)then changed = true width = w end
            if(h > height)then changed = true height = h end
            if(changed)then
                for k,v in pairs(frames)do
                    v.setSize(width, height)
                    v.recalculateSize()
                end
            end
        end,

        text = function(frame, text, x, y)
            local f = frames[frame]
            if(f==nil)then
                f = addFrame(frame)
            end
            f.text(text, x, y)
        end,

        fg = function(frame, fg, x, y)
            local f = frames[frame]
            if(f==nil)then
                f = addFrame(frame)
            end
            f.fg(fg, x, y)
        end,

        bg = function(frame, bg, x, y)
            local f = frames[frame]
            if(f==nil)then
                f = addFrame(frame)
            end
            f.bg(bg, x, y)
        end,

        blit = function(frame, text, fg, bg, x, y)
            local f = frames[frame]
            if(f==nil)then
                f = addFrame(frame)
            end
            f.blit(text, fg, bg, x, y)
        end,

        setSize = function(w, h)
            width = w
            height = h
            for k,v in pairs(frames)do
                v.setSize(w, h)
            end
        end,

        getFrame = function(id)
            if(frames[id]~=nil)then
                return frames[id].getFrame()
            end
        end,

        getFrameObjects = function()
            return frames
        end,

        getFrames = function()
            local f = {}
            for k,v in pairs(frames)do
                local frame = v.getFrame()
                table.insert(f, frame)
            end
            return f
        end,

        getFrameObject = function(id)
            return frames[id]
        end,

        addFrame = function(id)
            if(#frames<=1)then
                if(metadata.animated==nil)then
                metadata.animated = true
                end
                if(metadata.secondsPerFrame==nil)then
                    metadata.secondsPerFrame = 0.2
                end
            end
            return addFrame(id)
        end,

        removeFrame = removeFrame,

        moveFrame = moveFrame,

        setFrameData = function(id, key, value)
            if(frames[id]~=nil)then
                frames[id].setFrameData(key, value)
            end
        end,

        getFrameData = function(id, key)
            if(frames[id]~=nil)then
                return frames[id].getFrameData(key)
            end
        end,

        getSize = function()
            return width, height
        end,

        setAnimation = function(anim)
            metadata.animation = anim
        end,

        setMetadata = function(key, val)
            if(val~=nil)then
                metadata[key] = val
            else
               if(type(key)=="table")then
                    metadata = key
               end
            end
        end,

        getMetadata = function(key)
            if(key~=nil)then
                return metadata[key]
            else
                return metadata
            end
        end,

        createBimg = function()
            local bimg = {}
            for k,v in pairs(frames)do
                local f = v.getFrame()
                table.insert(bimg, f)
            end
            for k,v in pairs(metadata)do
                bimg[k] = v
            end
            bimg.width = width
            bimg.height = height
            return bimg
        end,
    }

    if(img~=nil)then
        for k,v in pairs(img)do
            if(type(k)=="string")then
                metadata[k] = v
            else
                addFrame(k, v)
            end
        end
        if(metadata.width==nil)or(metadata.height==nil)then
            for k,v in pairs(frames)do
                local w, h = v.getSize()
                if(w>width)then w = width end
                if(h>height)then h = height end
            end
            manager.updateSize(width, height, true)
        end
    else
        addFrame(1)
    end

    return manager
end