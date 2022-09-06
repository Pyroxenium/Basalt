--Basalt configurated installer
local filePath = "basalt.lua" --here you can change the file path default: basalt
if not(fs.exists(filePath))then
    shell.run("pastebin run ESs1mg7P packed true "..filePath:gsub(".lua", "")) -- this is an alternative to the wget command
end
local basalt = require(filePath:gsub(".lua", "")) -- here you can change the variablename in any variablename you want default: basalt

local maxCoWorker = 3

local recipeList = {}
local craftingQueue = {}
local bridge = peripheral.find("rsBridge")
local w, h = term.getSize()

local main = basalt.createFrame()
local home = main:addFrame():setPosition(1,2):setBackground(colors.lightGray):setSize(w, h-2)
local recipes = main:addFrame():setPosition(1,2):setBackground(colors.lightGray):hide()
local log = main:addFrame():setPosition(1,2):setBackground(colors.lightGray):hide()

local menuBar = main:addMenubar():addItem("Home"):addItem("Recipes"):addItem("Log"):setBackground(colors.gray):setSize(w, 1):setSpace(6):setScrollable():show()
menuBar:onChange(function(self)
    home:hide()
    recipes:hide()
    log:hide()
    if(self:getValue().text=="Home")then
        home:show()
    elseif(self:getValue().text=="Recipes")then
        recipes:show()
    elseif(self:getValue().text=="Log")then
        log:show()
    end
end)

local function buttonVisuals(btn)
    btn:onClick(basalt.schedule(function() btn:setBackground(colors.black) btn:setForeground(colors.lightGray) os.sleep(0.1) btn:setBackground(colors.gray) btn:setForeground(colors.black) end))
end

local coworkerCount = home:addLabel():setText(maxCoWorker):setPosition(45,2):show()
home:addLabel():setText("Co-Worker:"):setPosition(32,2):show()
buttonVisuals(home:addButton():setText(">"):setSize(1,1):setPosition(47,2):onClick(function() if(maxCoWorker<100)then maxCoWorker = maxCoWorker+1 end coworkerCount:setText(maxCoWorker) end):show())
buttonVisuals(home:addButton():setText("<"):setSize(1,1):setPosition(43,2):onClick(function() if(maxCoWorker>1)then maxCoWorker = maxCoWorker-1 end coworkerCount:setText(maxCoWorker) end):show())

local logList = log:addList():setPosition(2,2):setSize(w-2,h-3):setScrollable(false):show()
local jobList = home:addList():setPosition(20,4):setSize(30,10):show()
local rList = recipes:addList():setPosition(13,2):setSize(38,16):show()

local function logging(text)
    logList:addItem(text)
    if(logList:getItemCount()>h-3)then
        logList:removeItem(1)
    end
end

logging("Loading autocrafter...")

function SaveToFile()
    local file = io.open("recipes", "wb")
    local sel = rList:getItemIndex()
    rList:clear()
    for _,v in pairs(recipeList)do
        if(v.useDmg)then
            file:write(v.name.."|"..v.damage.."|"..v.minAmount.."|"..v.maxCraftAmount.."|true|", "\n")
        else
            file:write(v.name.."|"..v.damage.."|"..v.minAmount.."|"..v.maxCraftAmount.."|false|", "\n")
        end
        rList:addItem(v.minAmount.."x "..v.name..":"..v.damage, nil, nil, v)
    end
    rList:selectItem(sel)
    file:close()
end

buttonVisuals(recipes:addButton():setPosition(2,2):setText("Remove"):setSize(8,1):onClick(function()
    if(rList:getValue()~=nil)then
        local sel = rList:getValue().args[1]
        for k,v in pairs(recipeList)do
            if(v.name==sel.name)and(tonumber(v.damage)==tonumber(sel.damage))then
                table.remove(recipeList, k)
                logging("Removed recipe: "..v.name..":"..v.damage)
                SaveToFile()
            end
        end
    end
end))
local changeAmn = recipes:addInput():setPosition(4,4):setSize(5,1):setInputType("number"):setForeground(colors.black):setDefaultText("32", colors.black):onChange(function(self)
    local val = tonumber(self:getValue()) or 32
    if(val<0)then
        self:setValue(0)
    end
end)
buttonVisuals(recipes:addButton():setPosition(2,4):setSize(1,1):setText("-"):onClick(function() 
    local val = tonumber(changeAmn:getValue()) or 32
    if(rList:getValue()~=nil)then
        local sel = rList:getValue().args[1]
        if(val>0)and(sel.name~=nil)and(sel.damage~=nil)then
            for k,v in pairs(recipeList)do
                if(v.name==sel.name)and(tonumber(v.damage)==tonumber(sel.damage))then
                    v.minAmount = v.minAmount - val
                    if(v.minAmount < 0)then v.minAmount = 0 end
                    SaveToFile()
                end
            end
        end
    end
end))
buttonVisuals(recipes:addButton():setPosition(10,4):setSize(1,1):setText("+"):onClick(function() 
    local val = tonumber(changeAmn:getValue()) or 32
    if(rList:getValue()~=nil)then
        local sel = rList:getValue().args[1]
        if(val>0)and(sel.name~=nil)and(sel.damage~=nil)then
            for k,v in pairs(recipeList)do
                if(v.name==sel.name)and(tonumber(v.damage)==tonumber(sel.damage))then
                    v.minAmount = v.minAmount + val
                    SaveToFile()
                end
            end
        end
    end
end))

buttonVisuals(recipes:addButton():setPosition(2,6):setSize(8,1):setText("Set"):onClick(function() 
    local val = tonumber(changeAmn:getValue()) or 32
    if(rList:getValue()~=nil)then
        local sel = rList:getValue().args[1]
        if(val>0)and(sel.name~=nil)and(sel.damage~=nil)then
            for k,v in pairs(recipeList)do
                if(v.name==sel.name)and(tonumber(v.damage)==tonumber(sel.damage))then
                    v.minAmount = val
                    SaveToFile()
                end
            end
        end
    end
end))

local rItemFrame = home:addFrame():setPosition(7,3):setBackground(colors.gray):setSize(27,6):setMoveable(true):setBar("Remove Item", colors.black, colors.lightGray):showBar():hide()
rItemFrame:addButton():setPosition(1,1):setAnchor("topRight"):setSize(1,1):setBackground(colors.black):setForeground(colors.lightGray):setText("x"):onClick(function() rItemFrame:hide() end):show()
rItemFrame:addLabel():setText("Item ID:"):setPosition(2,3):show()
local ritemId = rItemFrame:addInput("itemid"):setPosition(12,3):setSize(15,1):setBackground(colors.black):setForeground(colors.lightGray):setDefaultText("minecraft:stick", colors.gray):show()
rItemFrame:addButton():setPosition(-7,0):setAnchor("bottomRight"):setSize(8,1):setBackground(colors.black):setForeground(colors.lightGray):setText("Remove"):onClick(function()
    local id = ritemId:getValue()
    
    for k,v in pairs(recipeList)do
        if(v.name==id)then
            table.remove(recipeList, k)
            logging("Removed recipe: "..v.name..":"..v.damage)
        end
    end
    SaveToFile()
end)


local aItemFrame = home:addFrame():setPosition(7,3):setBackground(colors.gray):setSize(27,12):setMoveable(true):setBar("Add Item", colors.black, colors.lightGray):showBar():hide()
aItemFrame:addLabel():setText("Item ID:"):setPosition(2,3)
aItemFrame:addLabel():setText("Damage:"):setPosition(2,5)
aItemFrame:addLabel():setText("Count:"):setPosition(2,7)
aItemFrame:addLabel():setText("Max:"):setPosition(2,9)
aItemFrame:addLabel():setText("Use Damage:"):setAnchor("bottomLeft"):setPosition(4,0)
local itemId = aItemFrame:addInput():setPosition(12,3):setSize(15,1):setBackground(colors.black):setForeground(colors.lightGray):setDefaultText("minecraft:stick", colors.gray)
local itemDamage = aItemFrame:addInput():setPosition(12,5):setSize(15,1):setBackground(colors.black):setForeground(colors.lightGray):setInputType("number"):setDefaultText("0", colors.gray)
local itemCount = aItemFrame:addInput():setPosition(12,7):setSize(15,1):setBackground(colors.black):setForeground(colors.lightGray):setInputType("number"):setDefaultText("64", colors.gray)
local itemMaxCount = aItemFrame:addInput():setPosition(12,9):setSize(15,1):setBackground(colors.black):setForeground(colors.lightGray):setInputType("number"):setDefaultText("0", colors.gray)
local useDamage = aItemFrame:addCheckbox():setAnchor("bottomLeft"):setPosition(2,0):setBackground(colors.black):setForeground(colors.lightGray):setValue(true)
aItemFrame:addButton():setAnchor("topRight"):setPosition(1,1):setSize(1,1):setBackground(colors.black):setForeground(colors.lightGray):setText("x"):onClick(function() aItemFrame:hide() end)
aItemFrame:addButton():setAnchor("bottomRight"):setPosition(-4,0):setSize(5,1):setBackground(colors.black):setForeground(colors.lightGray):setText("Add"):onClick(function()
    local id = itemId:getValue()
    local dmg = itemDamage:getValue() == "" and 0 or itemDamage:getValue()
    local count = itemCount:getValue() == "" and 64 or itemCount:getValue()
    local maxCount = itemMaxCount:getValue() == "" and 0 or itemMaxCount:getValue()
    local usedamage = useDamage:getValue() or true
    if(id~="")then
        local itemExist = false
        for k,v in pairs(recipeList)do
            if(v.name==id)then
                if(usedamage)then
                    if(v.damage==dmg)then
                        itemExist = true
                        v.minAmount = count or 64
                        v.maxCraftAmount = maxCount or 0
                        logging("Edited recipe: "..(count).."x "..id..":"..dmg)
                    end
                else
                    itemExist = true
                    v.minAmount = count or 64
                    v.maxCraftAmount = maxCount or 0
                    logging("Edited recipe: "..(count).."x "..id..":"..dmg)
                end
            end
        end

        if(itemExist == false)then
            table.insert(recipeList, {name = id, damage = dmg or 0, minAmount = count, maxCraftAmount = maxCount or 0, useDmg = usedamage, fails = 0, timer = 0})
            logging("Added recipe: "..(count).."x "..id..":"..dmg)
        end
        SaveToFile()
    else
        logging("Please set a ID.")
    end
end)

buttonVisuals(home:addButton():setText("Add Item"):setSize(12,3):setPosition(2,6):onClick(function() aItemFrame:show() aItemFrame:setFocus() end):show())
buttonVisuals(home:addButton():setText("Remove Item"):setSize(12,3):setPosition(2,10):onClick(function() rItemFrame:show() rItemFrame:setFocus() end):show())

local function StringSeperate(str, seperator)
local words = {}
local word = ""

    if(string.sub(str, str:len(), str:len())~=seperator)then
        str = str..""..seperator        
    end
    for x=1,str:len() do
        local s = string.sub(str,x,x)
        if(s==seperator)then
            table.insert(words, word)
            word = ""
        else
            word = word..s
        end
    end
    return words
end

if not(fs.exists("recipes"))then
    fs.open("recipes","w").close()
end

local f = fs.open("recipes", "r")
for line in f.readLine do
    local tab = StringSeperate(line, "|")
    if(tab[1]~=nil)and(tab[2]~=nil)and(tab[3]~=nil)and(tab[4]~=nil)and(tab[5]~=nil)then
        logging("Registered recipe: "..tab[3].."x "..tab[1]..":"..tab[2])
        local recipe = {name=tab[1],damage=tonumber(tab[2]),minAmount=tonumber(tab[3]),maxCraftAmount=tonumber(tab[4]),fails=0,timer=0}
        if(tab[5]=="true")then
            recipe.useDmg=true
        else
            recipe.useDmg=false
        end
        rList:addItem(recipe.minAmount.."x "..recipe.name..":"..recipe.damage, nil, nil, recipe)
        table.insert(recipeList, recipe)
    end
end
f.close()

local function findKeyWithItemName(table, itemname, damage) 
    for k,v in pairs(table)do
        if(v.name==itemname)and(v.damage == damage)then
            return k
        end
    end
    return nil
end

local scanChestBtn = home:addButton("scanChest"):setText("Scan Chest"):setSize(12,3):setPosition(2,2):show()
local function checkChestForNewEntrys()
    scanChestBtn:setText("Scanning..")
    local inventory = peripheral.find("minecraft:chest")
    local items = {}
    local itemAmounts = {}
    local somethingChanged = false

        if(inventory~=nil)then
            for x=1,inventory.size(), 1 do
                local item = inventory.getItemDetail(x)
                if(item~=nil)then
                    if(item.damage==nil)then item.damage = 0 end
                    table.insert(items, item)
                end
                os.sleep(0.1)
            end
        else
            logging("No chest available!")
        end
     
        if(#items > 0)then
            for _,v in pairs(items)do
                local key = findKeyWithItemName(itemAmounts, v.name, v.damage)
                if(key~=nil)then
                    itemAmounts[key].count = itemAmounts[key].count + v.count
                else
                    table.insert( itemAmounts, {name=v.name, damage=v.damage, count = v.count})
                end     
            end
        end
     
        if(#itemAmounts > 0)then
            for _,v in pairs(itemAmounts)do
                local key = findKeyWithItemName(recipeList, v.name, v.damage)
                if(key~=nil)then
                    if(recipeList[key].minAmount ~= v.count)then
                        logging("Edited recipe: "..v.name.. ":"..v.damage.." new count: "..v.count)
                    end
                    somethingChanged = true
                    recipeList[key].minAmount = v.count
                else
                    table.insert( recipeList, {name=v.name, damage=v.damage, minAmount = v.count, maxCraftAmount = 0, useDmg = true, fails = 0, timer = 0})
                    somethingChanged = true
                    logging("Registered recipe: "..v.count.."x "..v.name.. ":"..v.damage)
                end
            end
            if(somethingChanged)then
                SaveToFile()
            end
        end
    scanChestBtn:setText("Scan Chest")
    logging("Scanning chest done.")
end

local chestScanThread = main:addThread("chestScanThread")
buttonVisuals(scanChestBtn:onClick(function() chestScanThread:start(checkChestForNewEntrys) end))


local function GetAmount(itemAmount, recipe)
    local amount = 0
    if(itemAmount < recipe.minAmount)then
        if(recipe.maxCraftAmount > 0)then
            if(recipe.minAmount-itemAmount > recipe.maxCraftAmount)then
                amount = recipe.maxCraftAmount
            else
                amount = recipe.minAmount-itemAmount
            end
        else
            amount = recipe.minAmount-itemAmount
        end
    end
    return amount
end
	
function GetRecipeKey(pattern)
    for k,v in pairs(recipeList)do
        if(v.name == pattern.name)then
            if(pattern.damage==nil)then return k end
            if(v.useDmg)then
                if(v.damage == pattern.damage)then
                    return k
                end
            else
                return k
            end
        end
    end
    return nil
end

local function CheckCraftingRecipe(recipe)
    local pattern = bridge.getItem({name=recipe.name})
    local item = {pattern=pattern, amount=0}
    if(pattern~=nil)then
      local storedAmount = pattern.amount
      local neededItemAmount = GetAmount(storedAmount, recipe)
      if(neededItemAmount > 0)then
	    item.amount = neededItemAmount
        table.insert(craftingQueue, item)
        return true
      end
    end
    return false
end

function RemoveRecipe(item)
    local key = -1
        for k,v in pairs(recipeList)do
            if(v.name == item.name)and(v.damage== item.damage)then
                key = k
            end
        end
        if(key>=0)then
            table.remove(recipeList, key)
        end
        SaveToFile()
end

local function FindKeyInTable(table, item)
    for k,v in pairs(table)do
        if(v==item)then
            return k
        end
    end
    return nil
end

local function CheckAllRecipes()
    for _,v in pairs(recipeList)do
        if(type(v)=="table")then
            CheckCraftingRecipe(v)
        end
    end
end

local function jobCrafting(coworker, item)
    if(jobList:getItem(coworker)~=nil)then
        jobList:editItem(coworker, "Co-Worker "..coworker..": "..item.amountToCraft.."x "..item.item.displayName:gsub(" ", ""))
    else
        jobList:addItem("Co-Worker "..coworker..": "..item.amountToCraft.."x "..item.item.displayName:gsub(" ", ""))
    end

end

local function jobDone(coworker)
    if(jobList:getItem(coworker)~=nil)then
        jobList:editItem(coworker, "Co-Worker "..coworker..": waiting...")
    else
        jobList:addItem("Co-Worker "..coworker..": waiting...")
    end
end

local coWorkerId = 1
local function UpdateCraftingQueue()
    while(#craftingQueue > 0)do
        local activeCoWorkers = {}
        local craftingQueuesToRemove = {}
        for _,v in pairs(craftingQueue)do
            if(#activeCoWorkers+1 <= maxCoWorker)then
                local stack = v.pattern
                local recipeKey = GetRecipeKey(stack)

                local waittimer = 0
                local multiplier = 1

                if(recipeList[recipeKey].fails > 0)and(recipeList[recipeKey].fails <=10)then
                    multiplier = recipeList[recipeKey].fails
                elseif(recipeList[recipeKey].fails > 10)then
                    multiplier = 20
                end
                waittimer = multiplier * 30
                if(os.clock()>=recipeList[recipeKey].timer+waittimer)then
                    if not(bridge.isItemCrafting(stack.name))then
                            local currentItemState = {item=stack, curAmount = stack.count, amountToCraft = v.amount}
                        if(bridge.isItemCraftable({name=stack.name}))then 
                            local task, errormsg = bridge.craftItem({name=stack.name, count = v.amount})
                            if(task)then
                                logging("Sheduled Task: "..v.amount.." ("..stack.name..") "..stack.displayName:gsub(" ", ""))
                                jobCrafting(coWorkerId, currentItemState)
                                currentItemState.coWorker = coWorkerId
                                coWorkerId = coWorkerId + 1
                                if(coWorkerId > maxCoWorker)then coWorkerId = 1 end
                                table.insert(activeCoWorkers, currentItemState)
                                recipeList[recipeKey].fails = 0
                            else
                                logging("Error sheduling task: "..v.amount.."x ("..stack.name..") "..stack.displayName:gsub(" ", ""))
                                logging("Not enough materials!")
                                recipeList[recipeKey].fails = recipeList[recipeKey].fails + 1
                                recipeList[recipeKey].timer = os.clock()
                            end
                        else
                            logging("Error sheduling task: "..v.amount.."x ("..stack.name..") "..stack.displayName:gsub(" ", ""))
                            logging("No pattern available!")
                            recipeList[recipeKey].fails = recipeList[recipeKey].fails + 1
                            recipeList[recipeKey].timer = os.clock()
                        end
                    end
                end
                table.insert(craftingQueuesToRemove, v)
            end
        end

        if(#craftingQueuesToRemove > 0)then
            for _,v in pairs(craftingQueuesToRemove)do
                local id = FindKeyInTable(craftingQueue, v)
                table.remove(craftingQueue, id)
            end
        end

        while(#activeCoWorkers > 0)do
            local finishedCoworker = {}
            for _,v in pairs(activeCoWorkers)do
                if not(bridge.isItemCrafting(v.item.name))then
                    logging("Task done: "..v.amountToCraft.."x ("..v.item.name..") "..v.item.displayName:gsub(" ", ""))
                    table.insert(finishedCoworker, v)
                end
            end
            if(#finishedCoworker>0)then
                for _,v in pairs(finishedCoworker)do
                    local id = FindKeyInTable(activeCoWorkers, v)
                    table.remove(activeCoWorkers, id)
                    jobDone(v.coWorker)
                end
            end
            os.sleep(0.75)
        end
        os.sleep(0.75)
    end
end

main:addThread("craftingThread"):start(function() while true do CheckAllRecipes() os.sleep(1) UpdateCraftingQueue() os.sleep(1) end end)

logging("Autocrafter successfully loaded!")

basalt.autoUpdate()