local aa={}local ba=true;local ca=require
local da=function(ab)
for bb,cb in pairs(aa)do
if(type(cb)=="table")then for db,_c in pairs(cb)do if(db==ab)then
return _c()end end else if(bb==ab)then return cb()end end end;return ca(ab)end
local _b=function(ab)if(ab~=nil)then return aa[ab]end;return aa end
aa["plugin"]=function(...)local ab={...}local bb={}local cb={}
local db=fs.getDir(ab[2]or"Basalt")local _c=fs.combine(db,"plugins")
if(ba)then
for bc,cc in pairs(_b("plugins"))do
table.insert(cb,bc)local dc=cc()
if(type(dc)=="table")then for _d,ad in pairs(dc)do
if(type(_d)=="string")then if(bb[_d]==nil)then
bb[_d]={}end;table.insert(bb[_d],ad)end end end end else
if(fs.exists(_c))then
for bc,cc in pairs(fs.list(_c))do local dc
if
(fs.isDir(fs.combine(_c,cc)))then table.insert(cb,fs.combine(_c,cc))
dc=da(cc.."/init")else table.insert(cb,cc)dc=da(cc:gsub(".lua",""))end
if(type(dc)=="table")then for _d,ad in pairs(dc)do
if(type(_d)=="string")then
if(bb[_d]==nil)then bb[_d]={}end;table.insert(bb[_d],ad)end end end end end end;local function ac(bc)return bb[bc]end
return
{get=ac,getAvailablePlugins=function()return cb end,addPlugin=function(bc)
if(fs.exists(bc))then
if(fs.isDir(bc))then
for cc,dc in
pairs(fs.list(bc))do table.insert(cb,dc)
if
not(fs.isDir(fs.combine(bc,dc)))then local _d=dc:gsub(".lua","")local ad=da(fs.combine(bc,_d))
if(
type(ad)=="table")then for bd,cd in pairs(ad)do
if(type(bd)=="string")then
if(bb[bd]==nil)then bb[bd]={}end;table.insert(bb[bd],cd)end end end end end else local cc=da(bc:gsub(".lua",""))
table.insert(cb,bc:match("[\\/]?([^\\/]-([^%.]+))$"))
if(type(cc)=="table")then for dc,_d in pairs(cc)do
if(type(dc)=="string")then
if(bb[dc]==nil)then bb[dc]={}end;table.insert(bb[dc],_d)end end end end end end,loadPlugins=function(bc,cc)
for dc,_d in
pairs(bc)do local ad=bb[dc]
if(ad~=nil)then
bc[dc]=function(...)local bd=_d(...)
for cd,dd in pairs(ad)do local __a=dd(bd,cc,...)
__a.__index=__a;bd=setmetatable(__a,bd)end;return bd end end end;return bc end}end
aa["main"]=function(...)local ab=da("basaltEvent")()
local bb=da("loadObjects")local cb;local db=da("plugin")local _c=da("utils")local ac=da("basaltLogs")
local bc=_c.uuid;local cc=_c.wrapText;local dc=_c.tableCount;local _d=300;local ad=0;local bd=0;local cd={}
local dd=term.current()local __a="1.7.0"
local a_a=fs.getDir(table.pack(...)[2]or"")local b_a,c_a,d_a,_aa,aaa={},{},{},{},{}local baa,caa,daa,_ba;local aba={}if not term.isColor or
not term.isColor()then
error('Basalt requires an advanced (golden) computer to run.',0)end;local bba={}
for adb,bdb in
pairs(colors)do if(type(bdb)=="number")then
bba[adb]={dd.getPaletteColor(bdb)}end end
local function cba()_ba=false;dd.clear()dd.setCursorPos(1,1)
for adb,bdb in pairs(colors)do if(type(bdb)==
"number")then
dd.setPaletteColor(bdb,colors.packRGB(table.unpack(bba[adb])))end end end
local function dba(adb)
assert(adb~="function","Schedule needs a function in order to work!")
return function(...)local bdb=coroutine.create(adb)
local cdb,ddb=coroutine.resume(bdb,...)
if(cdb)then table.insert(aaa,bdb)else aba.basaltError(ddb)end end end;aba.log=function(...)ac(...)end
local _ca=function(adb,bdb)_aa[adb]=bdb end;local aca=function(adb)return _aa[adb]end
local bca=function()return cb end;local cca=function(adb)return bca()[adb]end;local dca=function(adb,bdb,cdb)return
cca(bdb)(cdb,adb)end
local _da={getDynamicValueEventSetting=function()return
aba.dynamicValueEvents end,getMainFrame=function()return baa end,setVariable=_ca,getVariable=aca,setMainFrame=function(adb)baa=adb end,getActiveFrame=function()return
caa end,setActiveFrame=function(adb)caa=adb end,getFocusedObject=function()return daa end,setFocusedObject=function(adb)daa=adb end,getMonitorFrame=function(adb)return
d_a[adb]or monGroups[adb][1]end,setMonitorFrame=function(adb,bdb,cdb)if(
baa==bdb)then baa=nil end;if(cdb)then monGroups[adb]={bdb,sides}else
d_a[adb]=bdb end
if(bdb==nil)then monGroups[adb]=nil end end,getTerm=function()return
dd end,schedule=dba,stop=cba,debug=aba.debug,log=aba.log,getObjects=bca,getObject=cca,createObject=dca,getDirectory=function()return a_a end}
local function ada(adb)dd.clear()dd.setBackgroundColor(colors.black)
dd.setTextColor(colors.red)local bdb,cdb=dd.getSize()if(aba.logging)then ac(adb,"Error")end;local ddb=cc(
"Basalt error: "..adb,bdb)local __c=1;for a_c,b_c in pairs(ddb)do
dd.setCursorPos(1,__c)dd.write(b_c)__c=__c+1 end;dd.setCursorPos(1,
__c+1)_ba=false end
local function bda(adb,bdb,cdb,ddb,__c)
if(#aaa>0)then local a_c={}
for n=1,#aaa do
if(aaa[n]~=nil)then
if
(coroutine.status(aaa[n])=="suspended")then
local b_c,c_c=coroutine.resume(aaa[n],adb,bdb,cdb,ddb,__c)if not(b_c)then aba.basaltError(c_c)end else
table.insert(a_c,n)end end end
for n=1,#a_c do table.remove(aaa,a_c[n]- (n-1))end end end
local function cda()if(_ba==false)then return end;if(baa~=nil)then baa:render()
baa:updateTerm()end;for adb,bdb in pairs(d_a)do bdb:render()
bdb:updateTerm()end end;local dda,__b,a_b=nil,nil,nil;local b_b=nil
local function c_b(adb,bdb,cdb,ddb)dda,__b,a_b=bdb,cdb,ddb;if(b_b==nil)then
b_b=os.startTimer(_d/1000)end end
local function d_b()b_b=nil;baa:hoverHandler(__b,a_b,dda)caa=baa end;local _ab,aab,bab=nil,nil,nil;local cab=nil;local function dab()cab=nil;baa:dragHandler(_ab,aab,bab)
caa=baa end;local function _bb(adb,bdb,cdb,ddb)_ab,aab,bab=bdb,cdb,ddb
if(ad<50)then dab()else if(cab==nil)then cab=os.startTimer(
ad/1000)end end end
local abb=nil;local function bbb()abb=nil;cda()end
local function cbb(adb)if(bd<50)then cda()else if(abb==nil)then
abb=os.startTimer(bd/1000)end end end
local function dbb(adb,...)local bdb={...}if
(ab:sendEvent("basaltEventCycle",adb,...)==false)then return end
if(adb=="terminate")then aba.stop()end
if(baa~=nil)then
local cdb={mouse_click=baa.mouseHandler,mouse_up=baa.mouseUpHandler,mouse_scroll=baa.scrollHandler,mouse_drag=_bb,mouse_move=c_b}local ddb=cdb[adb]
if(ddb~=nil)then ddb(baa,...)bda(adb,...)cbb()return end end
if(adb=="monitor_touch")then
for cdb,ddb in pairs(d_a)do if
(ddb:mouseHandler(1,bdb[2],bdb[3],true,bdb[1]))then caa=ddb end end;bda(adb,...)cbb()return end
if(caa~=nil)then
local cdb={char=caa.charHandler,key=caa.keyHandler,key_up=caa.keyUpHandler}local ddb=cdb[adb]if(ddb~=nil)then if(adb=="key")then b_a[bdb[1]]=true elseif(adb=="key_up")then
b_a[bdb[1]]=false end;ddb(caa,...)bda(adb,...)
cbb()return end end
if(adb=="timer")and(bdb[1]==b_b)then d_b()elseif
(adb=="timer")and(bdb[1]==cab)then dab()elseif(adb=="timer")and(bdb[1]==abb)then bbb()else for cdb,ddb in pairs(c_a)do
ddb:eventHandler(adb,...)end
for cdb,ddb in pairs(d_a)do ddb:eventHandler(adb,...)end;bda(adb,...)cbb()end end;local _cb=false;local acb=false
local function bcb()
if not(_cb)then
for adb,bdb in pairs(cd)do
if(fs.exists(bdb))then
if(fs.isDir(bdb))then
local cdb=fs.list(bdb)
for ddb,__c in pairs(cdb)do
if not(fs.isDir(bdb.."/"..__c))then
local a_c=__c:gsub(".lua","")
if
(a_c~="example.lua")and not(a_c:find(".disabled"))then
if(bb[a_c]==nil)then
bb[a_c]=da(bdb.."."..__c:gsub(".lua",""))else error("Duplicate object name: "..a_c)end end end end else local cdb=bdb:gsub(".lua","")
if(bb[cdb]==nil)then bb[cdb]=da(cdb)else error(
"Duplicate object name: "..cdb)end end end end;_cb=true end
if not(acb)then cb=db.loadPlugins(bb,_da)local adb=db.get("basalt")
if
(adb~=nil)then for cdb,ddb in pairs(adb)do
for __c,a_c in pairs(ddb(aba))do aba[__c]=a_c;_da[__c]=a_c end end end;local bdb=db.get("basaltInternal")
if(bdb~=nil)then for cdb,ddb in pairs(bdb)do for __c,a_c in pairs(ddb(aba))do
_da[__c]=a_c end end end;acb=true end end
local function ccb(adb)bcb()
for cdb,ddb in pairs(c_a)do if(ddb:getName()==adb)then return nil end end;local bdb=cb["BaseFrame"](adb,_da)bdb:init()
bdb:load()bdb:draw()table.insert(c_a,bdb)
if(baa==nil)and(bdb:getName()~=
"basaltDebuggingFrame")then bdb:show()end;return bdb end
aba={basaltError=ada,logging=false,dynamicValueEvents=false,drawFrames=cda,log=ac,getVersion=function()return __a end,memory=function()return
math.floor(collectgarbage("count")+0.5).."KB"end,addObject=function(adb)if
(fs.exists(adb))then table.insert(cd,adb)end end,addPlugin=function(adb)
db.addPlugin(adb)end,getAvailablePlugins=function()return db.getAvailablePlugins()end,getAvailableObjects=function()
local adb={}for bdb,cdb in pairs(bb)do table.insert(adb,bdb)end;return adb end,setVariable=_ca,getVariable=aca,getObjects=bca,getObject=cca,createObject=dca,setBaseTerm=function(adb)
dd=adb end,resetPalette=function()
for adb,bdb in pairs(colors)do if(type(bdb)=="number")then end end end,setMouseMoveThrottle=function(adb)
if(_HOST:find("CraftOS%-PC"))then if(
config.get("mouse_move_throttle")~=10)then
config.set("mouse_move_throttle",10)end
if(adb<100)then _d=100 else _d=adb end;return true end;return false end,setRenderingThrottle=function(adb)if(
adb<=0)then bd=0 else abb=nil;bd=adb end end,setMouseDragThrottle=function(adb)if
(adb<=0)then ad=0 else cab=nil;ad=adb end end,autoUpdate=function(adb)_ba=adb;if(
adb==nil)then _ba=true end;local function bdb()cda()while _ba do
dbb(os.pullEventRaw())end end
while _ba do
local cdb,ddb=xpcall(bdb,debug.traceback)if not(cdb)then aba.basaltError(ddb)end end end,update=function(adb,...)
if(
adb~=nil)then local bdb={...}
local cdb,ddb=xpcall(function()dbb(adb,table.unpack(bdb))end,debug.traceback)if not(cdb)then aba.basaltError(ddb)return end end end,stop=cba,stopUpdate=cba,isKeyDown=function(adb)if(
b_a[adb]==nil)then return false end;return b_a[adb]end,getFrame=function(adb)for bdb,cdb in
pairs(c_a)do if(cdb.name==adb)then return cdb end end end,getActiveFrame=function()return
caa end,setActiveFrame=function(adb)
if(adb:getType()=="Container")then caa=adb;return true end;return false end,getMainFrame=function()return baa end,onEvent=function(...)
for adb,bdb in
pairs(table.pack(...))do if(type(bdb)=="function")then
ab:registerEvent("basaltEventCycle",bdb)end end end,schedule=dba,addFrame=ccb,createFrame=ccb,addMonitor=function(adb)
bcb()
for cdb,ddb in pairs(c_a)do if(ddb:getName()==adb)then return nil end end;local bdb=cb["MonitorFrame"](adb,_da)bdb:init()
bdb:load()bdb:draw()table.insert(d_a,bdb)return bdb end,removeFrame=function(adb)c_a[adb]=
nil end,setProjectDir=function(adb)a_a=adb end}local dcb=db.get("basalt")if(dcb~=nil)then
for adb,bdb in pairs(dcb)do for cdb,ddb in pairs(bdb(aba))do
aba[cdb]=ddb;_da[cdb]=ddb end end end
local _db=db.get("basaltInternal")if(_db~=nil)then
for adb,bdb in pairs(_db)do for cdb,ddb in pairs(bdb(aba))do _da[cdb]=ddb end end end;return aba end;aa["plugins"]={}
aa["plugins"]["advancedBackground"]=function(...)
local ab=da("xmlParser")
return
{VisualObject=function(bb)local cb=false;local db=colors.black
local _c={setBackground=function(ac,bc,cc,dc)bb.setBackground(ac,bc)
cb=cc or cb;db=dc or db;return ac end,setBackgroundSymbol=function(ac,bc,cc)cb=bc
db=cc or db;ac:updateDraw()return ac end,getBackgroundSymbol=function(ac)return cb end,getBackgroundSymbolColor=function(ac)return
db end,draw=function(ac)bb.draw(ac)
ac:addDraw("advanced-bg",function()local bc,cc=ac:getSize()
if
(cb~=false)then ac:addTextBox(1,1,bc,cc,cb:sub(1,1))if(cb~=" ")then
ac:addForegroundBox(1,1,bc,cc,db)end end end,2)end}return _c end}end
aa["plugins"]["bigfonts"]=function(...)local ab=da("tHex")
local bb={{"\32\32\32\137\156\148\158\159\148\135\135\144\159\139\32\136\157\32\159\139\32\32\143\32\32\143\32\32\32\32\32\32\32\32\147\148\150\131\148\32\32\32\151\140\148\151\140\147","\32\32\32\149\132\149\136\156\149\144\32\133\139\159\129\143\159\133\143\159\133\138\32\133\138\32\133\32\32\32\32\32\32\150\150\129\137\156\129\32\32\32\133\131\129\133\131\132","\32\32\32\130\131\32\130\131\32\32\129\32\32\32\32\130\131\32\130\131\32\32\32\32\143\143\143\32\32\32\32\32\32\130\129\32\130\135\32\32\32\32\131\32\32\131\32\131","\139\144\32\32\143\148\135\130\144\149\32\149\150\151\149\158\140\129\32\32\32\135\130\144\135\130\144\32\149\32\32\139\32\159\148\32\32\32\32\159\32\144\32\148\32\147\131\132","\159\135\129\131\143\149\143\138\144\138\32\133\130\149\149\137\155\149\159\143\144\147\130\132\32\149\32\147\130\132\131\159\129\139\151\129\148\32\32\139\131\135\133\32\144\130\151\32","\32\32\32\32\32\32\130\135\32\130\32\129\32\129\129\131\131\32\130\131\129\140\141\132\32\129\32\32\129\32\32\32\32\32\32\32\131\131\129\32\32\32\32\32\32\32\32\32","\32\32\32\32\149\32\159\154\133\133\133\144\152\141\132\133\151\129\136\153\32\32\154\32\159\134\129\130\137\144\159\32\144\32\148\32\32\32\32\32\32\32\32\32\32\32\151\129","\32\32\32\32\133\32\32\32\32\145\145\132\141\140\132\151\129\144\150\146\129\32\32\32\138\144\32\32\159\133\136\131\132\131\151\129\32\144\32\131\131\129\32\144\32\151\129\32","\32\32\32\32\129\32\32\32\32\130\130\32\32\129\32\129\32\129\130\129\129\32\32\32\32\130\129\130\129\32\32\32\32\32\32\32\32\133\32\32\32\32\32\129\32\129\32\32","\150\156\148\136\149\32\134\131\148\134\131\148\159\134\149\136\140\129\152\131\32\135\131\149\150\131\148\150\131\148\32\148\32\32\148\32\32\152\129\143\143\144\130\155\32\134\131\148","\157\129\149\32\149\32\152\131\144\144\131\148\141\140\149\144\32\149\151\131\148\32\150\32\150\131\148\130\156\133\32\144\32\32\144\32\130\155\32\143\143\144\32\152\129\32\134\32","\130\131\32\131\131\129\131\131\129\130\131\32\32\32\129\130\131\32\130\131\32\32\129\32\130\131\32\130\129\32\32\129\32\32\133\32\32\32\129\32\32\32\130\32\32\32\129\32","\150\140\150\137\140\148\136\140\132\150\131\132\151\131\148\136\147\129\136\147\129\150\156\145\138\143\149\130\151\32\32\32\149\138\152\129\149\32\32\157\152\149\157\144\149\150\131\148","\149\143\142\149\32\149\149\32\149\149\32\144\149\32\149\149\32\32\149\32\32\149\32\149\149\32\149\32\149\32\144\32\149\149\130\148\149\32\32\149\32\149\149\130\149\149\32\149","\130\131\129\129\32\129\131\131\32\130\131\32\131\131\32\131\131\129\129\32\32\130\131\32\129\32\129\130\131\32\130\131\32\129\32\129\131\131\129\129\32\129\129\32\129\130\131\32","\136\140\132\150\131\148\136\140\132\153\140\129\131\151\129\149\32\149\149\32\149\149\32\149\137\152\129\137\152\129\131\156\133\149\131\32\150\32\32\130\148\32\152\137\144\32\32\32","\149\32\32\149\159\133\149\32\149\144\32\149\32\149\32\149\32\149\150\151\129\138\155\149\150\130\148\32\149\32\152\129\32\149\32\32\32\150\32\32\149\32\32\32\32\32\32\32","\129\32\32\130\129\129\129\32\129\130\131\32\32\129\32\130\131\32\32\129\32\129\32\129\129\32\129\32\129\32\131\131\129\130\131\32\32\32\129\130\131\32\32\32\32\140\140\132","\32\154\32\159\143\32\149\143\32\159\143\32\159\144\149\159\143\32\159\137\145\159\143\144\149\143\32\32\145\32\32\32\145\149\32\144\32\149\32\143\159\32\143\143\32\159\143\32","\32\32\32\152\140\149\151\32\149\149\32\145\149\130\149\157\140\133\32\149\32\154\143\149\151\32\149\32\149\32\144\32\149\149\153\32\32\149\32\149\133\149\149\32\149\149\32\149","\32\32\32\130\131\129\131\131\32\130\131\32\130\131\129\130\131\129\32\129\32\140\140\129\129\32\129\32\129\32\137\140\129\130\32\129\32\130\32\129\32\129\129\32\129\130\131\32","\144\143\32\159\144\144\144\143\32\159\143\144\159\138\32\144\32\144\144\32\144\144\32\144\144\32\144\144\32\144\143\143\144\32\150\129\32\149\32\130\150\32\134\137\134\134\131\148","\136\143\133\154\141\149\151\32\129\137\140\144\32\149\32\149\32\149\154\159\133\149\148\149\157\153\32\154\143\149\159\134\32\130\148\32\32\149\32\32\151\129\32\32\32\32\134\32","\133\32\32\32\32\133\129\32\32\131\131\32\32\130\32\130\131\129\32\129\32\130\131\129\129\32\129\140\140\129\131\131\129\32\130\129\32\129\32\130\129\32\32\32\32\32\129\32","\32\32\32\32\149\32\32\149\32\32\32\32\32\32\32\32\149\32\32\149\32\32\32\32\32\32\32\32\149\32\32\149\32\32\32\32\32\32\32\32\149\32\32\149\32\32\32\32","\32\32\32\32\32\32\32\32\32\32\32\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\32\32\32\32\32\32\32\32\32\32\32","\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32","\32\32\32\32\149\32\32\149\32\32\32\32\32\32\32\32\149\32\32\149\32\32\32\32\32\32\32\32\149\32\32\149\32\32\32\32\32\32\32\32\149\32\32\149\32\32\32\32","\32\32\32\32\32\32\32\32\32\32\32\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\32\32\32\32\32\32\32\32\32\32\32","\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32","\32\32\32\32\145\32\159\139\32\151\131\132\155\143\132\134\135\145\32\149\32\158\140\129\130\130\32\152\147\155\157\134\32\32\144\144\32\32\32\32\32\32\152\131\155\131\131\129","\32\32\32\32\149\32\149\32\145\148\131\32\149\32\149\140\157\132\32\148\32\137\155\149\32\32\32\149\154\149\137\142\32\153\153\32\131\131\149\131\131\129\149\135\145\32\32\32","\32\32\32\32\129\32\130\135\32\131\131\129\134\131\132\32\129\32\32\129\32\131\131\32\32\32\32\130\131\129\32\32\32\32\129\129\32\32\32\32\32\32\130\131\129\32\32\32","\150\150\32\32\148\32\134\32\32\132\32\32\134\32\32\144\32\144\150\151\149\32\32\32\32\32\32\145\32\32\152\140\144\144\144\32\133\151\129\133\151\129\132\151\129\32\145\32","\130\129\32\131\151\129\141\32\32\142\32\32\32\32\32\149\32\149\130\149\149\32\143\32\32\32\32\142\132\32\154\143\133\157\153\132\151\150\148\151\158\132\151\150\148\144\130\148","\32\32\32\140\140\132\32\32\32\32\32\32\32\32\32\151\131\32\32\129\129\32\32\32\32\134\32\32\32\32\32\32\32\129\129\32\129\32\129\129\130\129\129\32\129\130\131\32","\156\143\32\159\141\129\153\140\132\153\137\32\157\141\32\159\142\32\150\151\129\150\131\132\140\143\144\143\141\145\137\140\148\141\141\144\157\142\32\159\140\32\151\134\32\157\141\32","\157\140\149\157\140\149\157\140\149\157\140\149\157\140\149\157\140\149\151\151\32\154\143\132\157\140\32\157\140\32\157\140\32\157\140\32\32\149\32\32\149\32\32\149\32\32\149\32","\129\32\129\129\32\129\129\32\129\129\32\129\129\32\129\129\32\129\129\131\129\32\134\32\131\131\129\131\131\129\131\131\129\131\131\129\130\131\32\130\131\32\130\131\32\130\131\32","\151\131\148\152\137\145\155\140\144\152\142\145\153\140\132\153\137\32\154\142\144\155\159\132\150\156\148\147\32\144\144\130\145\136\137\32\146\130\144\144\130\145\130\136\32\151\140\132","\151\32\149\151\155\149\149\32\149\149\32\149\149\32\149\149\32\149\149\32\149\152\137\144\157\129\149\149\32\149\149\32\149\149\32\149\149\32\149\130\150\32\32\157\129\149\32\149","\131\131\32\129\32\129\130\131\32\130\131\32\130\131\32\130\131\32\130\131\32\32\32\32\130\131\32\130\131\32\130\131\32\130\131\32\130\131\32\32\129\32\130\131\32\133\131\32","\156\143\32\159\141\129\153\140\132\153\137\32\157\141\32\159\142\32\159\159\144\152\140\144\156\143\32\159\141\129\153\140\132\157\141\32\130\145\32\32\147\32\136\153\32\130\146\32","\152\140\149\152\140\149\152\140\149\152\140\149\152\140\149\152\140\149\149\157\134\154\143\132\157\140\133\157\140\133\157\140\133\157\140\133\32\149\32\32\149\32\32\149\32\32\149\32","\130\131\129\130\131\129\130\131\129\130\131\129\130\131\129\130\131\129\130\130\131\32\134\32\130\131\129\130\131\129\130\131\129\130\131\129\32\129\32\32\129\32\32\129\32\32\129\32","\159\134\144\137\137\32\156\143\32\159\141\129\153\140\132\153\137\32\157\141\32\32\132\32\159\143\32\147\32\144\144\130\145\136\137\32\146\130\144\144\130\145\130\138\32\146\130\144","\149\32\149\149\32\149\149\32\149\149\32\149\149\32\149\149\32\149\149\32\149\131\147\129\138\134\149\149\32\149\149\32\149\149\32\149\149\32\149\154\143\149\32\157\129\154\143\149","\130\131\32\129\32\129\130\131\32\130\131\32\130\131\32\130\131\32\130\131\32\32\32\32\130\131\32\130\131\129\130\131\129\130\131\129\130\131\129\140\140\129\130\131\32\140\140\129"},{"000110000110110000110010101000000010000000100101","000000110110000000000010101000000010000000100101","000000000000000000000000000000000000000000000000","100010110100000010000110110000010100000100000110","000000110000000010110110000110000000000000110000","000000000000000000000000000000000000000000000000","000000110110000010000000100000100000000000000010","000000000110110100010000000010000000000000000100","000000000000000000000000000000000000000000000000","010000000000100110000000000000000000000110010000","000000000000000000000000000010000000010110000000","000000000000000000000000000000000000000000000000","011110110000000100100010110000000100000000000000","000000000000000000000000000000000000000000000000","000000000000000000000000000000000000000000000000","110000110110000000000000000000010100100010000000","000010000000000000110110000000000100010010000000","000000000000000000000000000000000000000000000000","010110010110100110110110010000000100000110110110","000000000000000000000110000000000110000000000000","000000000000000000000000000000000000000000000000","010100010110110000000000000000110000000010000000","110110000000000000110000110110100000000010000000","000000000000000000000000000000000000000000000000","000100011111000100011111000100011111000100011111","000000000000100100100100011011011011111111111111","000000000000000000000000000000000000000000000000","000100011111000100011111000100011111000100011111","000000000000100100100100011011011011111111111111","100100100100100100100100100100100100100100100100","000000110100110110000010000011110000000000011000","000000000100000000000010000011000110000000001000","000000000000000000000000000000000000000000000000","010000100100000000000000000100000000010010110000","000000000000000000000000000000110110110110110000","000000000000000000000000000000000000000000000000","110110110110110110000000110110110110110110110110","000000000000000000000110000000000000000000000000","000000000000000000000000000000000000000000000000","000000000000110110000110010000000000000000010010","000010000000000000000000000000000000000000000000","000000000000000000000000000000000000000000000000","110110110110110110110000110110110110000000000000","000000000000000000000110000000000000000000000000","000000000000000000000000000000000000000000000000","110110110110110110110000110000000000000000010000","000000000000000000000000100000000000000110000110","000000000000000000000000000000000000000000000000"}}local cb={}local db={}
do local cc=0;local dc=#bb[1]local _d=#bb[1][1]
for i=1,dc,3 do
for j=1,_d,3 do
local ad=string.char(cc)local bd={}bd[1]=bb[1][i]:sub(j,j+2)
bd[2]=bb[1][i+1]:sub(j,j+2)bd[3]=bb[1][i+2]:sub(j,j+2)local cd={}cd[1]=bb[2][i]:sub(j,
j+2)cd[2]=bb[2][i+1]:sub(j,j+2)cd[3]=bb[2][
i+2]:sub(j,j+2)db[ad]={bd,cd}cc=cc+1 end end;cb[1]=db end
local function _c(cc,dc)local _d={["0"]="1",["1"]="0"}if cc<=#cb then return true end
for f=#cb+1,cc do local ad={}local bd=cb[
f-1]
for char=0,255 do local cd=string.char(char)local dd={}local __a={}
local a_a=bd[cd][1]local b_a=bd[cd][2]
for i=1,#a_a do local c_a,d_a,_aa,aaa,baa,caa={},{},{},{},{},{}
for j=1,#a_a[1]do
local daa=db[a_a[i]:sub(j,j)][1]table.insert(c_a,daa[1])
table.insert(d_a,daa[2])table.insert(_aa,daa[3])
local _ba=db[a_a[i]:sub(j,j)][2]
if b_a[i]:sub(j,j)=="1"then
table.insert(aaa,(_ba[1]:gsub("[01]",_d)))
table.insert(baa,(_ba[2]:gsub("[01]",_d)))
table.insert(caa,(_ba[3]:gsub("[01]",_d)))else table.insert(aaa,_ba[1])
table.insert(baa,_ba[2])table.insert(caa,_ba[3])end end;table.insert(dd,table.concat(c_a))
table.insert(dd,table.concat(d_a))table.insert(dd,table.concat(_aa))
table.insert(__a,table.concat(aaa))table.insert(__a,table.concat(baa))
table.insert(__a,table.concat(caa))end;ad[cd]={dd,__a}if dc then dc="Font"..f.."Yeld"..char
os.queueEvent(dc)os.pullEvent(dc)end end;cb[f]=ad end;return true end
local function ac(cc,dc,_d,ad,bd)
if not type(dc)=="string"then error("Not a String",3)end
local cd=type(_d)=="string"and _d:sub(1,1)or ab[_d]or
error("Wrong Front Color",3)
local dd=type(ad)=="string"and ad:sub(1,1)or ab[ad]or
error("Wrong Back Color",3)if(cb[cc]==nil)then _c(3,false)end;local __a=cb[cc]or
error("Wrong font size selected",3)if dc==""then
return{{""},{""},{""}}end;local a_a={}
for caa in dc:gmatch('.')do table.insert(a_a,caa)end;local b_a={}local c_a=#__a[a_a[1]][1]
for nLine=1,c_a do local caa={}for i=1,#a_a do
caa[i]=
__a[a_a[i]]and __a[a_a[i]][1][nLine]or""end;b_a[nLine]=table.concat(caa)end;local d_a={}local _aa={}local aaa={["0"]=cd,["1"]=dd}local baa={["0"]=dd,["1"]=cd}
for nLine=1,c_a do
local caa={}local daa={}
for i=1,#a_a do
local _ba=__a[a_a[i]]and __a[a_a[i]][2][nLine]or""
caa[i]=_ba:gsub("[01]",
bd and{["0"]=_d:sub(i,i),["1"]=ad:sub(i,i)}or aaa)
daa[i]=_ba:gsub("[01]",
bd and{["0"]=ad:sub(i,i),["1"]=_d:sub(i,i)}or baa)end;d_a[nLine]=table.concat(caa)
_aa[nLine]=table.concat(daa)end;return{b_a,d_a,_aa}end;local bc=da("xmlParser")
return
{Label=function(cc)local dc=1;local _d
local ad={setFontSize=function(bd,cd)
if(type(cd)=="number")then dc=cd
if(dc>1)then
bd:setDrawState("label",false)
_d=ac(dc-1,bd:getText(),bd:getForeground(),bd:getBackground()or colors.lightGray)if(bd:getAutoSize())then
bd:getBase():setSize(#_d[1][1],#_d[1]-1)end else
bd:setDrawState("label",true)end;bd:updateDraw()end;return bd end,getFontSize=function(bd)return
dc end,getSize=function(bd)local cd,dd=cc.getSize(bd)
if
(dc>1)and(bd:getAutoSize())then
return dc==2 and bd:getText():len()*3 or math.floor(
bd:getText():len()*8.5),
dc==2 and dd*2 or math.floor(dd)else return cd,dd end end,getWidth=function(bd)
local cd=cc.getWidth(bd)if(dc>1)and(bd:getAutoSize())then return dc==2 and
bd:getText():len()*3 or
math.floor(bd:getText():len()*8.5)else
return cd end end,getHeight=function(bd)
local cd=cc.getHeight(bd)if(dc>1)and(bd:getAutoSize())then return
dc==2 and cd*2 or math.floor(cd)else return cd end end,draw=function(bd)
cc.draw(bd)
bd:addDraw("bigfonts",function()
if(dc>1)then local cd,dd=bd:getPosition()local __a=bd:getParent()
local a_a,b_a=__a:getSize()local c_a,d_a=#_d[1][1],#_d[1]cd=cd or
math.floor((a_a-c_a)/2)+1;dd=dd or
math.floor((b_a-d_a)/2)+1
for i=1,d_a do bd:addFG(1,i,_d[2][i])
bd:addBG(1,i,_d[3][i])bd:addText(1,i,_d[1][i])end end end)end}return ad end}end
aa["plugins"]["border"]=function(...)local ab=da("xmlParser")
return
{VisualObject=function(bb)local cb=true
local db={top=false,bottom=false,left=false,right=false}
local _c={setBorder=function(ac,...)local bc={...}
if(bc~=nil)then
for cc,dc in pairs(bc)do
if(dc=="left")or(#bc==1)then db["left"]=bc[1]end;if(dc=="top")or(#bc==1)then db["top"]=bc[1]end;if
(dc=="right")or(#bc==1)then db["right"]=bc[1]end;if
(dc=="bottom")or(#bc==1)then db["bottom"]=bc[1]end end end;ac:updateDraw()return ac end,draw=function(ac)
bb.draw(ac)
ac:addDraw("border",function()local bc,cc=ac:getPosition()local dc,_d=ac:getSize()
local ad=ac:getBackground()
if(cb)then
if(db["left"]~=false)then ac:addTextBox(1,1,1,_d,"\149")if(ad~=false)then
ac:addBackgroundBox(1,1,1,_d,ad)end
ac:addForegroundBox(1,1,1,_d,db["left"])end
if(db["top"]~=false)then ac:addTextBox(1,1,dc,1,"\131")if(ad~=false)then
ac:addBackgroundBox(1,1,dc,1,ad)end
ac:addForegroundBox(1,1,dc,1,db["top"])end
if(db["left"]~=false)and(db["top"]~=false)then
ac:addTextBox(1,1,1,1,"\151")
if(ad~=false)then ac:addBackgroundBox(1,1,1,1,ad)end;ac:addForegroundBox(1,1,1,1,db["left"])end
if(db["right"]~=false)then ac:addTextBox(dc,1,1,_d,"\149")if
(ad~=false)then ac:addForegroundBox(dc,1,1,_d,ad)end
ac:addBackgroundBox(dc,1,1,_d,db["right"])end
if(db["bottom"]~=false)then ac:addTextBox(1,_d,dc,1,"\143")if
(ad~=false)then ac:addForegroundBox(1,_d,dc,1,ad)end
ac:addBackgroundBox(1,_d,dc,1,db["bottom"])end
if(db["top"]~=false)and(db["right"]~=false)then
ac:addTextBox(dc,1,1,1,"\148")
if(ad~=false)then ac:addForegroundBox(dc,1,1,1,ad)end;ac:addBackgroundBox(dc,1,1,1,db["right"])end
if(db["right"]~=false)and(db["bottom"]~=false)then
ac:addTextBox(dc,_d,1,1,"\133")
if(ad~=false)then ac:addForegroundBox(dc,_d,1,1,ad)end;ac:addBackgroundBox(dc,_d,1,1,db["right"])end
if(db["bottom"]~=false)and(db["left"]~=false)then
ac:addTextBox(1,_d,1,1,"\138")
if(ad~=false)then ac:addForegroundBox(0,_d,1,1,ad)end;ac:addBackgroundBox(1,_d,1,1,db["left"])end end end)end}return _c end}end
aa["plugins"]["debug"]=function(...)local ab=da("utils")local bb=ab.wrapText
return
{basalt=function(cb)
local db=cb.getMainFrame()local _c;local ac;local bc;local cc
local function dc()local _d=16;local ad=6;local bd=99;local cd=99;local dd,__a=db:getSize()
_c=db:addMovableFrame("basaltDebuggingFrame"):setSize(
dd-20,__a-10):setBackground(colors.gray):setForeground(colors.white):setZIndex(100):hide()
_c:addPane():setSize("parent.w",1):setPosition(1,1):setBackground(colors.black):setForeground(colors.white)
_c:setPosition(-dd,__a/2 -_c:getHeight()/2):setBorder(colors.black)
local a_a=_c:addButton():setPosition("parent.w","parent.h"):setSize(1,1):setText("\133"):setForeground(colors.gray):setBackground(colors.black):onClick(function()
end):onDrag(function(b_a,c_a,d_a,_aa,aaa)
local baa,caa=_c:getSize()local daa,_ba=baa,caa;if(baa+_aa-1 >=_d)and(baa+_aa-1 <=bd)then daa=baa+
_aa-1 end
if(caa+aaa-1 >=ad)and(
caa+aaa-1 <=cd)then _ba=caa+aaa-1 end;_c:setSize(daa,_ba)end)
cc=_c:addButton():setText("Close"):setPosition("parent.w - 6",1):setSize(7,1):setBackground(colors.red):setForeground(colors.white):onClick(function()
_c:animatePosition(
-dd,__a/2 -_c:getHeight()/2,0.5)end)
ac=_c:addList():setSize("parent.w - 2","parent.h - 3"):setPosition(2,3):setBackground(colors.gray):setForeground(colors.white):setSelectionColor(colors.gray,colors.white)
if(bc==nil)then
bc=db:addLabel():setPosition(1,"parent.h"):setBackground(colors.black):setForeground(colors.white):setZIndex(100):onClick(function()
_c:show()
_c:animatePosition(dd/2 -_c:getWidth()/2,__a/2 -_c:getHeight()/2,0.5)end)end end
return
{debug=function(...)local _d={...}if(db==nil)then db=cb.getMainFrame()
if(db~=nil)then dc()else print(...)return end end
if
(db:getName()~="basaltDebuggingFrame")then if(db~=_c)then bc:setParent(db)end end;local ad=""for bd,cd in pairs(_d)do
ad=ad..tostring(cd).. (#_d~=bd and", "or"")end
bc:setText("[Debug] "..ad)
for bd,cd in pairs(bb(ad,ac:getWidth()))do ac:addItem(cd)end
if(ac:getItemCount()>50)then ac:removeItem(1)end
ac:setValue(ac:getItem(ac:getItemCount()))
if(ac.getItemCount()>ac:getHeight())then ac:setOffset(ac:getItemCount()-
ac:getHeight())end;bc:show()end}end}end
aa["plugins"]["animations"]=function(...)
local ab,bb,cb,db,_c,ac=math.floor,math.sin,math.cos,math.pi,math.sqrt,math.pow;local function bc(aab,bab,cab)return aab+ (bab-aab)*cab end
local function cc(aab)return aab end;local function dc(aab)return 1 -aab end
local function _d(aab)return aab*aab*aab end;local function ad(aab)return dc(_d(dc(aab)))end;local function bd(aab)return
bc(_d(aab),ad(aab),aab)end
local function cd(aab)return bb((aab*db)/2)end;local function dd(aab)return dc(cb((aab*db)/2))end;local function __a(aab)return- (
cb(db*x)-1)/2 end
local function a_a(aab)local bab=1.70158
local cab=bab+1;return cab*aab^3 -bab*aab^2 end;local function b_a(aab)return aab^3 end;local function c_a(aab)local bab=(2 *db)/3
return aab==0 and 0 or(aab==1 and 1 or
(-2 ^ (10 *
aab-10)*bb((aab*10 -10.75)*bab)))end
local function d_a(aab)return
aab==0 and 0 or 2 ^ (10 *aab-10)end
local function _aa(aab)return aab==0 and 0 or 2 ^ (10 *aab-10)end
local function aaa(aab)local bab=1.70158;local cab=bab*1.525;return
aab<0.5 and( (2 *aab)^2 *
( (cab+1)*2 *aab-cab))/2 or
(
(2 *aab-2)^2 * ( (cab+1)* (aab*2 -2)+cab)+2)/2 end;local function baa(aab)return
aab<0.5 and 4 *aab^3 or 1 - (-2 *aab+2)^3 /2 end
local function caa(aab)
local bab=(2 *db)/4.5
return
aab==0 and 0 or(aab==1 and 1 or
(
aab<0.5 and- (2 ^ (20 *aab-10)*
bb((20 *aab-11.125)*bab))/2 or
(2 ^ (-20 *aab+10)*bb((20 *aab-11.125)*bab))/2 +1))end
local function daa(aab)return
aab==0 and 0 or(aab==1 and 1 or
(
aab<0.5 and 2 ^ (20 *aab-10)/2 or(2 -2 ^ (-20 *aab+10))/2))end;local function _ba(aab)return
aab<0.5 and 2 *aab^2 or 1 - (-2 *aab+2)^2 /2 end;local function aba(aab)return
aab<0.5 and 8 *
aab^4 or 1 - (-2 *aab+2)^4 /2 end;local function bba(aab)return
aab<0.5 and 16 *
aab^5 or 1 - (-2 *aab+2)^5 /2 end;local function cba(aab)
return aab^2 end;local function dba(aab)return aab^4 end
local function _ca(aab)return aab^5 end;local function aca(aab)local bab=1.70158;local cab=bab+1;return
1 +cab* (aab-1)^3 +bab* (aab-1)^2 end;local function bca(aab)return 1 -
(1 -aab)^3 end
local function cca(aab)local bab=(2 *db)/3;return

aab==0 and 0 or(aab==1 and 1 or(
2 ^ (-10 *aab)*bb((aab*10 -0.75)*bab)+1))end
local function dca(aab)return aab==1 and 1 or 1 -2 ^ (-10 *aab)end;local function _da(aab)return 1 - (1 -aab)* (1 -aab)end;local function ada(aab)return 1 - (
1 -aab)^4 end;local function bda(aab)
return 1 - (1 -aab)^5 end
local function cda(aab)return 1 -_c(1 -ac(aab,2))end;local function dda(aab)return _c(1 -ac(aab-1,2))end
local function __b(aab)return

aab<0.5 and(1 -_c(
1 -ac(2 *aab,2)))/2 or(_c(1 -ac(-2 *aab+2,2))+1)/2 end
local function a_b(aab)local bab=7.5625;local cab=2.75
if(aab<1 /cab)then return bab*aab*aab elseif(aab<2 /cab)then local dab=aab-
1.5 /cab;return bab*dab*dab+0.75 elseif(aab<2.5 /cab)then local dab=aab-
2.25 /cab;return bab*dab*dab+0.9375 else
local dab=aab-2.625 /cab;return bab*dab*dab+0.984375 end end;local function b_b(aab)return 1 -a_b(1 -aab)end;local function c_b(aab)return
x<0.5 and(1 -
a_b(1 -2 *aab))/2 or(1 +a_b(2 *aab-1))/2 end
local d_b={linear=cc,lerp=bc,flip=dc,easeIn=_d,easeInSine=dd,easeInBack=a_a,easeInCubic=b_a,easeInElastic=c_a,easeInExpo=_aa,easeInQuad=cba,easeInQuart=dba,easeInQuint=_ca,easeInCirc=cda,easeInBounce=b_b,easeOut=ad,easeOutSine=cd,easeOutBack=aca,easeOutCubic=bca,easeOutElastic=cca,easeOutExpo=dca,easeOutQuad=_da,easeOutQuart=ada,easeOutQuint=bda,easeOutCirc=dda,easeOutBounce=a_b,easeInOut=bd,easeInOutSine=__a,easeInOutBack=aaa,easeInOutCubic=baa,easeInOutElastic=caa,easeInOutExpo=daa,easeInOutQuad=_ba,easeInOutQuart=aba,easeInOutQuint=bba,easeInOutCirc=__b,easeInOutBounce=c_b}local _ab=da("xmlParser")
return
{VisualObject=function(aab,bab)local cab={}local dab="linear"
local function _bb(dbb,_cb)for acb,bcb in pairs(cab)do if(bcb.timerId==_cb)then
return bcb end end end
local function abb(dbb,_cb,acb,bcb,ccb,dcb,_db,adb,bdb,cdb)local ddb,__c=bdb(dbb)if(cab[_db]~=nil)then
os.cancelTimer(cab[_db].timerId)end;cab[_db]={}
cab[_db].call=function()
local a_c=cab[_db].progress
local b_c=math.floor(d_b.lerp(ddb,_cb,d_b[dcb](a_c/bcb))+0.5)
local c_c=math.floor(d_b.lerp(__c,acb,d_b[dcb](a_c/bcb))+0.5)cdb(dbb,b_c,c_c)end
cab[_db].finished=function()cdb(dbb,_cb,acb)if(adb~=nil)then adb(dbb)end end;cab[_db].timerId=os.startTimer(0.05 +ccb)
cab[_db].progress=0;cab[_db].duration=bcb;cab[_db].mode=dcb
dbb:listenEvent("other_event")end
local function bbb(dbb,_cb,acb,bcb,ccb,...)local dcb={...}if(cab[bcb]~=nil)then
os.cancelTimer(cab[bcb].timerId)end;cab[bcb]={}local _db=1;cab[bcb].call=function()
local adb=dcb[_db]ccb(dbb,adb)end end
local cbb={animatePosition=function(dbb,_cb,acb,bcb,ccb,dcb,_db)dcb=dcb or dab;bcb=bcb or 1;ccb=ccb or 0
_cb=math.floor(_cb+0.5)acb=math.floor(acb+0.5)
abb(dbb,_cb,acb,bcb,ccb,dcb,"position",_db,dbb.getPosition,dbb.setPosition)return dbb end,animateSize=function(dbb,_cb,acb,bcb,ccb,dcb,_db)dcb=
dcb or dab;bcb=bcb or 1;ccb=ccb or 0
abb(dbb,_cb,acb,bcb,ccb,dcb,"size",_db,dbb.getSize,dbb.setSize)return dbb end,animateOffset=function(dbb,_cb,acb,bcb,ccb,dcb,_db)dcb=
dcb or dab;bcb=bcb or 1;ccb=ccb or 0
abb(dbb,_cb,acb,bcb,ccb,dcb,"offset",_db,dbb.getOffset,dbb.setOffset)return dbb end,animateBackground=function(dbb,_cb,acb,bcb,ccb,dcb)ccb=
ccb or dab;acb=acb or 1;bcb=bcb or 0
bbb(dbb,_cb,nil,acb,bcb,ccb,"background",dcb,dbb.getBackground,dbb.setBackground)return dbb end,doneHandler=function(dbb,_cb,...)
for acb,bcb in
pairs(cab)do if(bcb.timerId==_cb)then cab[acb]=nil
dbb:sendEvent("animation_done",dbb,"animation_done",acb)end end end,onAnimationDone=function(dbb,...)
for _cb,acb in
pairs(table.pack(...))do if(type(acb)=="function")then
dbb:registerEvent("animation_done",acb)end end;return dbb end,eventHandler=function(dbb,_cb,acb,...)
aab.eventHandler(dbb,_cb,acb,...)
if(_cb=="timer")then local bcb=_bb(dbb,acb)
if(bcb~=nil)then
if(bcb.progress<bcb.duration)then
bcb.call()bcb.progress=bcb.progress+0.05
bcb.timerId=os.startTimer(0.05)else bcb.finished()dbb:doneHandler(acb)end end end end}return cbb end}end
aa["plugins"]["basaltAdditions"]=function(...)return
{basalt=function()return
{cool=function()print("ello")sleep(2)end}end}end
aa["plugins"]["dynamicValues"]=function(...)local ab=da("utils")local bb=ab.tableCount
return
{VisualObject=function(cb,db)
local _c={}local ac={}local bc={x="getX",y="getY",w="getWidth",h="getHeight"}
local function cc(bd)
local cd,dd=pcall(load(
"return "..bd,"",nil,{math=math}))if not(cd)then
error(bd.." - is not a valid dynamic value string")end;return dd end
local function dc(bd,cd,dd)local __a={}local a_a=bc
for d_a,_aa in pairs(a_a)do for aaa in dd:gmatch("%a+%."..d_a)do
local baa=aaa:gsub("%."..d_a,"")
if(baa~="self")and(baa~="parent")then table.insert(__a,baa)end end end;local b_a=bd:getParent()local c_a={}
for d_a,_aa in pairs(__a)do
c_a[_aa]=b_a:getChild(_aa)if(c_a[_aa]==nil)then
error("Dynamic Values - unable to find object: ".._aa)end end;c_a["self"]=bd;c_a["parent"]=b_a
_c[cd]=function()local d_a=dd
for _aa,aaa in pairs(a_a)do
for baa in
dd:gmatch("%w+%.".._aa)do local caa=c_a[baa:gsub("%.".._aa,"")]if(caa~=nil)then
d_a=d_a:gsub(baa,caa[aaa](caa))else
error("Dynamic Values - unable to find object: "..baa)end end end;ac[cd]=math.floor(cc(d_a)+0.5)end;_c[cd]()end
local function _d(bd)
if(bb(_c)>0)then for dd,__a in pairs(_c)do __a()end
local cd={x="getX",y="getY",w="getWidth",h="getHeight"}
for dd,__a in pairs(cd)do
if(_c[dd]~=nil)then
if(ac[dd]~=bd[__a](bd))then if(dd=="x")or(dd=="y")then
cb.setPosition(bd,
ac["x"]or bd:getX(),ac["y"]or bd:getY())end;if(dd=="w")or(dd=="h")then
cb.setSize(bd,
ac["w"]or bd:getWidth(),ac["h"]or bd:getHeight())end end end end end end
local ad={updatePositions=_d,createDynamicValue=dc,setPosition=function(bd,cd,dd,__a)ac.x=cd;ac.y=dd
if(type(cd)=="string")then dc(bd,"x",cd)else _c["x"]=nil end
if(type(dd)=="string")then dc(bd,"y",dd)else _c["y"]=nil end;cb.setPosition(bd,ac.x,ac.y,__a)return bd end,setSize=function(bd,cd,dd,__a)
ac.w=cd;ac.h=dd
if(type(cd)=="string")then dc(bd,"w",cd)else _c["w"]=nil end
if(type(dd)=="string")then dc(bd,"h",dd)else _c["h"]=nil end;cb.setSize(bd,ac.w,ac.h,__a)return bd end,customEventHandler=function(bd,cd,...)
cb.customEventHandler(bd,cd,...)if
(cd=="basalt_FrameReposition")or(cd=="basalt_FrameResize")then _d(bd)end end}return ad end}end
aa["plugins"]["shadow"]=function(...)local ab=da("xmlParser")
return
{VisualObject=function(bb)local cb=false
local db={setShadow=function(_c,ac)cb=ac
_c:updateDraw()return _c end,getShadow=function(_c)return cb end,draw=function(_c)bb.draw(_c)
_c:addDraw("shadow",function()
if(
cb~=false)then local ac,bc=_c:getSize()
if(cb)then
_c:addBackgroundBox(ac+1,2,1,bc,cb)_c:addBackgroundBox(2,bc+1,ac,1,cb)
_c:addForegroundBox(ac+1,2,1,bc,cb)_c:addForegroundBox(2,bc+1,ac,1,cb)end end end)end}return db end}end
aa["plugins"]["textures"]=function(...)local ab=da("images")local bb=da("utils")
local cb=da("xmlParser")
return
{VisualObject=function(db)local _c,ac=1,true;local bc,cc,dc;local _d="default"
local ad={addTexture=function(bd,cd,dd)bc=ab.loadImageAsBimg(cd)
cc=bc[1]
if(dd)then if(bc.animated)then bd:listenEvent("other_event")local __a=bc[_c].duration or
bc.secondsPerFrame or 0.2
dc=os.startTimer(__a)end end;bd:setBackground(false)bd:setForeground(false)
bd:setDrawState("texture-base",true)bd:updateDraw()return bd end,setTextureMode=function(bd,cd)_d=
cd or _d;bd:updateDraw()return bd end,setInfinitePlay=function(bd,cd)ac=cd
return bd end,eventHandler=function(bd,cd,dd,...)db.eventHandler(bd,cd,dd,...)
if(cd=="timer")then
if
(dd==dc)then
if(bc[_c+1]~=nil)then _c=_c+1;cc=bc[_c]local __a=
bc[_c].duration or bc.secondsPerFrame or 0.2
dc=os.startTimer(__a)bd:updateDraw()else
if(ac)then _c=1;cc=bc[1]local __a=
bc[_c].duration or bc.secondsPerFrame or 0.2
dc=os.startTimer(__a)bd:updateDraw()end end end end end,draw=function(bd)
db.draw(bd)
bd:addDraw("texture-base",function()local cd=bd:getParent()or bd
local dd,__a=bd:getPosition()local a_a,b_a=bd:getSize()local c_a,d_a=cd:getSize()local _aa=bc.width or
#bc[_c][1][1]local aaa=bc.height or#bc[_c]
local baa,caa=0,0
if(_d=="center")then
baa=dd+math.floor((a_a-_aa)/2 +0.5)-1
caa=__a+math.floor((b_a-aaa)/2 +0.5)-1 elseif(_d=="default")then baa,caa=dd,__a elseif(_d=="right")then
baa,caa=dd+a_a-_aa,__a+b_a-aaa end;local daa=dd-baa;local _ba=__a-caa;if baa<dd then baa=dd;_aa=_aa-daa end;if
caa<__a then caa=__a;aaa=aaa-_ba end;if baa+_aa>dd+a_a then
_aa=(dd+a_a)-baa end
if caa+aaa>__a+b_a then aaa=(__a+b_a)-caa end
for k=1,aaa do if(cc[k+_ba]~=nil)then local aba,bba,cba=table.unpack(cc[k+_ba])
bd:addBlit(1,k,aba:sub(daa,
daa+_aa),bba:sub(daa,daa+_aa),cba:sub(daa,daa+_aa))end end end,1)bd:setDrawState("texture-base",false)end}return ad end}end
aa["plugins"]["pixelbox"]=function(...)
local ab,bb,cb=table.sort,table.concat,string.char;local function db(dc,_d)return dc[2]>_d[2]end
local _c={{5,256,16,8,64,32},{4,16,16384,256,128},[4]={4,64,1024,256,128},[8]={4,512,2048,256,1},[16]={4,2,16384,256,1},[32]={4,8192,4096,256,1},[64]={4,4,1024,256,1},[128]={6,32768,256,1024,2048,4096,16384},[256]={6,1,128,2,512,4,8192},[512]={4,8,2048,256,128},[1024]={4,4,64,128,32768},[2048]={4,512,8,128,32768},[4096]={4,8192,32,128,32768},[8192]={3,32,4096,256128},[16384]={4,2,16,128,32768},[32768]={5,128,1024,2048,4096,16384}}local ac={}for i=0,15 do ac[("%x"):format(i)]=2 ^i end
local bc={}for i=0,15 do bc[2 ^i]=("%x"):format(i)end
local function cc(dc,_d)_d=_d or"f"local ad,bd=#
dc[1],#dc;local cd={}local dd={}local __a=false
local function a_a()
for y=1,bd*3 do for x=1,ad*2 do
if not dd[y]then dd[y]={}end;dd[y][x]=_d end end;for _aa,aaa in ipairs(dc)do
for x=1,#aaa do local baa=aaa:sub(x,x)dd[_aa][x]=ac[baa]end end end;a_a()local function b_a(_aa,aaa)ad,bd=_aa,aaa;dd={}__a=false;a_a()end
local function c_a(_aa,aaa,baa,caa,daa,_ba)
local aba={_aa,aaa,baa,caa,daa,_ba}local bba={}local cba={}local dba=0
for i=1,6 do local cca=aba[i]if not bba[cca]then dba=dba+1
bba[cca]={0,dba}end;local dca=bba[cca]local _da=dca[1]+1;dca[1]=_da
cba[dca[2]]={cca,_da}end;local _ca=#cba
while _ca>2 do ab(cba,db)local cca=_c[cba[_ca][1]]
local dca,_da=1,false;local ada=_ca-1
for i=2,cca[1]do if _da then break end;local dda=cca[i]for j=1,ada do if cba[j][1]==dda then dca=j
_da=true;break end end end;local bda,cda=cba[_ca][1],cba[dca][1]
for i=1,6 do if aba[i]==bda then aba[i]=cda
local dda=cba[dca]dda[2]=dda[2]+1 end end;cba[_ca]=nil;_ca=_ca-1 end;local aca=128;local bca=aba[6]if aba[1]~=bca then aca=aca+1 end;if aba[2]~=bca then aca=aca+
2 end;if aba[3]~=bca then aca=aca+4 end;if
aba[4]~=bca then aca=aca+8 end;if aba[5]~=bca then aca=aca+16 end;if
cba[1][1]==aba[6]then return cb(aca),cba[2][1],aba[6]else
return cb(aca),cba[1][1],aba[6]end end
local function d_a()local _aa=ad*2;local aaa=0
for y=1,bd*3,3 do aaa=aaa+1;local baa=dd[y]local caa=dd[y+1]local daa=dd[y+2]
local _ba,aba,bba={},{},{}local cba=0
for x=1,_aa,2 do local dba=x+1
local _ca,aca,bca,cca,dca,_da=baa[x],baa[dba],caa[x],caa[dba],daa[x],daa[dba]local ada,bda,cda=" ",1,_ca;if not(
aca==_ca and bca==_ca and cca==_ca and dca==_ca and _da==_ca)then
ada,bda,cda=c_a(_ca,aca,bca,cca,dca,_da)end;cba=cba+1
_ba[cba]=ada;aba[cba]=bc[bda]bba[cba]=bc[cda]end;cd[aaa]={bb(_ba),bb(aba),bb(bba)}end;__a=true end
return
{convert=d_a,generateCanvas=a_a,setSize=b_a,getSize=function()return ad,bd end,set=function(_aa,aaa)dc=_aa;_d=aaa or _d;dd={}__a=false;a_a()end,get=function(_aa)if
not __a then d_a()end
return _aa~=nil and cd[_aa]or cd end}end
return
{Image=function(dc,_d)
return
{shrink=function(ad)local bd=ad:getImageFrame(1)local cd={}for __a,a_a in pairs(bd)do if(type(__a)=="number")then
table.insert(cd,a_a[3])end end
local dd=cc(cd,ad:getBackground()).get()ad:setImage(dd)return ad end,getShrinkedImage=function(ad)
local bd=ad:getImageFrame(1)local cd={}for dd,__a in pairs(bd)do
if(type(dd)=="number")then table.insert(cd,__a[3])end end;return
cc(cd,ad:getBackground()).get()end}end}end
aa["plugins"]["reactive"]=function(...)local ab=da("xmlParser")local bb={}
bb.currentEffect=nil
bb.observable=function(ac)local bc=ac;local cc={}
local dc=function()if(bb.currentEffect~=nil)then
table.insert(cc,bb.currentEffect)
table.insert(bb.currentEffect.dependencies,cc)end;return bc end
local _d=function(ad)bc=ad;local bd={}for cd,dd in ipairs(cc)do bd[cd]=dd end;for cd,dd in ipairs(bd)do
dd.execute()end end;return dc,_d end
bb.untracked=function(ac)local bc=bb.currentEffect;bb.currentEffect=nil;local cc=ac()
bb.currentEffect=bc;return cc end
bb.effect=function(ac)local bc={dependencies={}}
local cc=function()bb.clearEffectDependencies(bc)
local dc=bb.currentEffect;bb.currentEffect=bc;ac()bb.currentEffect=dc end;bc.execute=cc;bc.execute()end
bb.derived=function(ac)local bc,cc=bb.observable()
bb.effect(function()cc(ac())end)return bc end
bb.clearEffectDependencies=function(ac)
for bc,cc in ipairs(ac.dependencies)do for dc,_d in ipairs(cc)do if(_d==ac)then
table.remove(cc,dc)end end end;ac.dependencies={}end
local cb={fromXML=function(ac)local bc=ab.parseText(ac)local cc=nil
for dc,_d in ipairs(bc)do if(_d.tag=="script")then cc=_d.value
table.remove(bc,dc)break end end;return{nodes=bc,script=cc}end}
local db=function(ac,bc)return load(ac,nil,"t",bc)()end
local _c=function(ac,bc,cc,dc)
bc(ac,function(...)local _d,ad=pcall(load(cc,nil,"t",dc))if not _d then
error("XML Error: "..ad)end end)end
return
{basalt=function(ac)
local bc=function(dc,_d)local ad=_d[dc.tag]
if(ad~=nil)then local dd={}for __a,a_a in pairs(dc.attributes)do
dd[__a]=load("return "..a_a,nil,"t",_d)end
return ac.createObjectsFromLayout(ad,dd)end;local bd=dc.tag:gsub("^%l",string.upper)
local cd=ac:createObject(bd,dc.attributes["id"])
for dd,__a in pairs(dc.attributes)do
if(dd:sub(1,2)=="on")then
_c(cd,cd[dd],__a.."()",_d)else
local a_a=function()local b_a=load("return "..__a,nil,"t",_d)()
cd:setProperty(dd,b_a)end;ac.effect(a_a)end end
for dd,__a in ipairs(dc.children)do
local a_a=ac.createObjectsFromXMLNode(__a,_d)for b_a,c_a in ipairs(a_a)do cd:addChild(c_a)end end;return{cd}end
local cc={observable=bb.observable,untracked=bb.untracked,effect=bb.effect,derived=bb.derived,layout=function(dc)if(not fs.exists(dc))then
error("Can't open file "..dc)end;local _d=fs.open(dc,"r")
local ad=_d.readAll()_d.close()return cb.fromXML(ad)end,createObjectsFromLayout=function(dc,_d)
local ad=_ENV;ad.props={}local bd={}for dd,__a in pairs(_d)do
bd[dd]=ac.derived(function()return __a()end)end
setmetatable(ad.props,{__index=function(dd,__a)return bd[__a]()end})if(dc.script~=nil)then db(dc.script,ad)end;local cd={}for dd,__a in
ipairs(dc.nodes)do local a_a=bc(__a,ad)
for b_a,c_a in ipairs(a_a)do table.insert(cd,c_a)end end;return cd end}return cc end,Container=function(ac,bc)
local cc={loadLayout=function(dc,_d,ad)
local bd={}if(ad==nil)then ad={}end
for __a,a_a in pairs(ad)do bd[__a]=function()return a_a end end;local cd=bc.layout(_d)
local dd=bc.createObjectsFromLayout(cd,bd)for __a,a_a in ipairs(dd)do dc:addChild(a_a)end;return dc end}return cc end}end
aa["plugins"]["themes"]=function(...)
local ab={BaseFrameBG=colors.lightGray,BaseFrameText=colors.black,FrameBG=colors.gray,FrameText=colors.black,ButtonBG=colors.gray,ButtonText=colors.black,CheckboxBG=colors.lightGray,CheckboxText=colors.black,InputBG=colors.black,InputText=colors.lightGray,TextfieldBG=colors.black,TextfieldText=colors.white,ListBG=colors.gray,ListText=colors.black,MenubarBG=colors.gray,MenubarText=colors.black,DropdownBG=colors.gray,DropdownText=colors.black,RadioBG=colors.gray,RadioText=colors.black,SelectionBG=colors.black,SelectionText=colors.lightGray,GraphicBG=colors.black,ImageBG=colors.black,PaneBG=colors.black,ProgramBG=colors.black,ProgressbarBG=colors.gray,ProgressbarText=colors.black,ProgressbarActiveBG=colors.black,ScrollbarBG=colors.lightGray,ScrollbarText=colors.gray,ScrollbarSymbolColor=colors.black,SliderBG=false,SliderText=colors.gray,SliderSymbolColor=colors.black,SwitchBG=colors.lightGray,SwitchText=colors.gray,LabelBG=false,LabelText=colors.black,GraphBG=colors.gray,GraphText=colors.black}
local bb={Container=function(cb,db,_c)local ac={}
local bc={getTheme=function(cc,dc)local _d=cc:getParent()return ac[dc]or(_d~=nil and _d:getTheme(dc)or
ab[dc])end,setTheme=function(cc,dc,_d)
if(
type(dc)=="table")then ac=dc elseif(type(dc)=="string")then ac[dc]=_d end;cc:updateDraw()return cc end}return bc end,basalt=function()
return
{getTheme=function(cb)return
ab[cb]end,setTheme=function(cb,db)if(type(cb)=="table")then ab=cb elseif(type(cb)=="string")then
ab[cb]=db end end}end}
for cb,db in
pairs({"BaseFrame","Frame","ScrollableFrame","MovableFrame","Button","Checkbox","Dropdown","Graph","Graphic","Input","Label","List","Menubar","Pane","Program","Progressbar","Radio","Scrollbar","Slider","Switch","Textfield"})do
bb[db]=function(_c,ac,bc)
local cc={init=function(dc)if(_c.init(dc))then local _d=dc:getParent()or dc
dc:setBackground(_d:getTheme(db.."BG"))
dc:setForeground(_d:getTheme(db.."Text"))end end}return cc end end;return bb end;aa["libraries"]={}
aa["libraries"]["basaltDraw"]=function(...)
local ab=da("tHex")local bb=da("utils")local cb=bb.splitString;local db,_c=string.sub,string.rep
return
function(ac)local bc=ac or
term.current()local cc;local dc,_d=bc.getSize()local ad={}local bd={}local cd={}
local dd;local __a={}local function a_a()dd=_c(" ",dc)
for n=0,15 do local caa=2 ^n;local daa=ab[caa]__a[caa]=_c(daa,dc)end end;a_a()
local function b_a()a_a()local caa=dd
local daa=__a[colors.white]local _ba=__a[colors.black]
for currentY=1,_d do
ad[currentY]=db(
ad[currentY]==nil and caa or
ad[currentY]..caa:sub(1,dc-ad[currentY]:len()),1,dc)
cd[currentY]=db(cd[currentY]==nil and daa or cd[currentY]..daa:sub(1,dc-
cd[currentY]:len()),1,dc)
bd[currentY]=db(bd[currentY]==nil and _ba or bd[currentY].._ba:sub(1,dc-
bd[currentY]:len()),1,dc)end end;b_a()
local function c_a(caa,daa,_ba,aba,bba)
if#_ba==#aba and#_ba==#bba then
if daa>=1 and daa<=_d then
if
caa+#_ba>0 and caa<=dc then local cba,dba,_ca;local aca,bca,cca=ad[daa],cd[daa],bd[daa]
local dca,_da=1,#_ba
if caa<1 then dca=1 -caa+1;_da=dc-caa+1 elseif caa+#_ba>dc then _da=dc-caa+1 end;cba=db(aca,1,caa-1)..db(_ba,dca,_da)dba=
db(bca,1,caa-1)..db(aba,dca,_da)_ca=db(cca,1,caa-1)..
db(bba,dca,_da)
if caa+#_ba<=dc then cba=cba..
db(aca,caa+#_ba,dc)
dba=dba..db(bca,caa+#_ba,dc)_ca=_ca..db(cca,caa+#_ba,dc)end;ad[daa],cd[daa],bd[daa]=cba,dba,_ca end end end end
local function d_a(caa,daa,_ba)
if daa>=1 and daa<=_d then
if caa+#_ba>0 and caa<=dc then local aba;local bba=ad[daa]
local cba,dba=1,#_ba
if caa<1 then cba=1 -caa+1;dba=dc-caa+1 elseif caa+#_ba>dc then dba=dc-caa+1 end;aba=db(bba,1,caa-1)..db(_ba,cba,dba)
if
caa+#_ba<=dc then aba=aba..db(bba,caa+#_ba,dc)end;ad[daa]=aba end end end
local function _aa(caa,daa,_ba)
if daa>=1 and daa<=_d then
if caa+#_ba>0 and caa<=dc then local aba;local bba=bd[daa]
local cba,dba=1,#_ba
if caa<1 then cba=1 -caa+1;dba=dc-caa+1 elseif caa+#_ba>dc then dba=dc-caa+1 end;aba=db(bba,1,caa-1)..db(_ba,cba,dba)
if
caa+#_ba<=dc then aba=aba..db(bba,caa+#_ba,dc)end;bd[daa]=aba end end end
local function aaa(caa,daa,_ba)
if daa>=1 and daa<=_d then
if caa+#_ba>0 and caa<=dc then local aba;local bba=cd[daa]
local cba,dba=1,#_ba
if caa<1 then cba=1 -caa+1;dba=dc-caa+1 elseif caa+#_ba>dc then dba=dc-caa+1 end;aba=db(bba,1,caa-1)..db(_ba,cba,dba)
if
caa+#_ba<=dc then aba=aba..db(bba,caa+#_ba,dc)end;cd[daa]=aba end end end
local baa={setSize=function(caa,daa)dc,_d=caa,daa;b_a()end,setMirror=function(caa)cc=caa end,setBG=function(caa,daa,_ba)
_aa(caa,daa,_ba)end,setText=function(caa,daa,_ba)d_a(caa,daa,_ba)end,setFG=function(caa,daa,_ba)
aaa(caa,daa,_ba)end,blit=function(caa,daa,_ba,aba,bba)c_a(caa,daa,_ba,aba,bba)end,drawBackgroundBox=function(caa,daa,_ba,aba,bba)
local cba=_c(ab[bba],_ba)for n=1,aba do _aa(caa,daa+ (n-1),cba)end end,drawForegroundBox=function(caa,daa,_ba,aba,bba)
local cba=_c(ab[bba],_ba)for n=1,aba do aaa(caa,daa+ (n-1),cba)end end,drawTextBox=function(caa,daa,_ba,aba,bba)
local cba=_c(bba,_ba)for n=1,aba do d_a(caa,daa+ (n-1),cba)end end,update=function()
local caa,daa=bc.getCursorPos()local _ba=false
if(bc.getCursorBlink~=nil)then _ba=bc.getCursorBlink()end;bc.setCursorBlink(false)if(cc~=nil)then
cc.setCursorBlink(false)end
for n=1,_d do bc.setCursorPos(1,n)
bc.blit(ad[n],cd[n],bd[n])if(cc~=nil)then cc.setCursorPos(1,n)
cc.blit(ad[n],cd[n],bd[n])end end;bc.setBackgroundColor(colors.black)
bc.setCursorBlink(_ba)bc.setCursorPos(caa,daa)
if(cc~=nil)then
cc.setBackgroundColor(colors.black)cc.setCursorBlink(_ba)cc.setCursorPos(caa,daa)end end,setTerm=function(caa)
bc=caa end}return baa end end
aa["libraries"]["basaltEvent"]=function(...)
return
function()local ab={}
local bb={registerEvent=function(cb,db,_c)
if(ab[db]==nil)then ab[db]={}end;table.insert(ab[db],_c)end,removeEvent=function(cb,db,_c)ab[db][_c[db]]=
nil end,hasEvent=function(cb,db)return ab[db]~=nil end,getEventCount=function(cb,db)return
ab[db]~=nil and#ab[db]or 0 end,getEvents=function(cb)
local db={}for _c,ac in pairs(ab)do table.insert(db,_c)end;return db end,clearEvent=function(cb,db)ab[db]=
nil end,clear=function(cb,db)ab={}end,sendEvent=function(cb,db,...)local _c
if(ab[db]~=nil)then for ac,bc in pairs(ab[db])do
local cc=bc(...)if(cc==false)then _c=cc end end end;return _c end}bb.__index=bb;return bb end end
aa["libraries"]["bimg"]=function(...)local ab,bb=string.sub,string.rep
local function cb(db,_c)local ac,bc=0,0
local cc,dc,_d={},{},{}local ad,bd=1,1;local cd={}
local function dd()
for y=1,bc do if(cc[y]==nil)then cc[y]=bb(" ",ac)else cc[y]=cc[y]..
bb(" ",ac-#cc[y])end;if
(dc[y]==nil)then dc[y]=bb("0",ac)else
dc[y]=dc[y]..bb("0",ac-#dc[y])end
if(_d[y]==nil)then _d[y]=bb("f",ac)else _d[y]=
_d[y]..bb("f",ac-#_d[y])end end end
local __a=function(d_a,_aa,aaa)ad=_aa or ad;bd=aaa or bd
if(cc[bd]==nil)then cc[bd]=bb(" ",ad-1)..d_a..
bb(" ",ac- (#d_a+ad))else cc[bd]=
ab(cc[bd],1,ad-1)..
bb(" ",ad-#cc[bd])..d_a..ab(cc[bd],ad+#d_a,ac)end;if(#cc[bd]>ac)then ac=#cc[bd]end;if(bd>bc)then bc=bd end
_c.updateSize(ac,bc)end
local a_a=function(d_a,_aa,aaa)ad=_aa or ad;bd=aaa or bd
if(_d[bd]==nil)then _d[bd]=bb("f",ad-1)..d_a..
bb("f",ac- (#d_a+ad))else _d[bd]=
ab(_d[bd],1,ad-1)..
bb("f",ad-#_d[bd])..d_a..ab(_d[bd],ad+#d_a,ac)end;if(#_d[bd]>ac)then ac=#_d[bd]end;if(bd>bc)then bc=bd end
_c.updateSize(ac,bc)end
local b_a=function(d_a,_aa,aaa)ad=_aa or ad;bd=aaa or bd
if(dc[bd]==nil)then dc[bd]=bb("0",ad-1)..d_a..
bb("0",ac- (#d_a+ad))else dc[bd]=
ab(dc[bd],1,ad-1)..
bb("0",ad-#dc[bd])..d_a..ab(dc[bd],ad+#d_a,ac)end;if(#dc[bd]>ac)then ac=#dc[bd]end;if(bd>bc)then bc=bd end
_c.updateSize(ac,bc)end
local function c_a(d_a)cd={}cc,dc,_d={},{},{}
for _aa,aaa in pairs(db)do if(type(_aa)=="string")then cd[_aa]=aaa else
cc[_aa],dc[_aa],_d[_aa]=aaa[1],aaa[2],aaa[3]end end;_c.updateSize(ac,bc)end
if(db~=nil)then if(#db>0)then ac=#db[1][1]bc=#db;c_a(db)end end
return
{recalculateSize=dd,setFrame=c_a,getFrame=function()local d_a={}for _aa,aaa in pairs(cc)do
table.insert(d_a,{aaa,dc[_aa],_d[_aa]})end
for _aa,aaa in pairs(cd)do d_a[_aa]=aaa end;return d_a,ac,bc end,getImage=function()
local d_a={}for _aa,aaa in pairs(cc)do
table.insert(d_a,{aaa,dc[_aa],_d[_aa]})end;return d_a end,setFrameData=function(d_a,_aa)
if(
_aa~=nil)then cd[d_a]=_aa else if(type(d_a)=="table")then cd=d_a end end end,setFrameImage=function(d_a)
for _aa,aaa in pairs(d_a.t)do
cc[_aa]=d_a.t[_aa]dc[_aa]=d_a.fg[_aa]_d[_aa]=d_a.bg[_aa]end end,getFrameImage=function()
return{t=cc,fg=dc,bg=_d}end,getFrameData=function(d_a)if(d_a~=nil)then return cd[d_a]else return cd end end,blit=function(d_a,_aa,aaa,baa,caa)
__a(d_a,baa,caa)b_a(_aa,baa,caa)a_a(aaa,baa,caa)end,text=__a,fg=b_a,bg=a_a,getSize=function()return
ac,bc end,setSize=function(d_a,_aa)local aaa,baa,caa={},{},{}
for _y=1,_aa do
if(cc[_y]~=nil)then aaa[_y]=ab(cc[_y],1,d_a)..bb(" ",
d_a-ac)else aaa[_y]=bb(" ",d_a)end;if(dc[_y]~=nil)then
baa[_y]=ab(dc[_y],1,d_a)..bb("0",d_a-ac)else baa[_y]=bb("0",d_a)end;if
(_d[_y]~=nil)then caa[_y]=ab(_d[_y],1,d_a)..bb("f",d_a-ac)else
caa[_y]=bb("f",d_a)end end;cc,dc,_d=aaa,baa,caa;ac,bc=d_a,_aa end}end
return
function(db)local _c={}
local ac={creator="Bimg Library by NyoriE",date=os.date("!%Y-%m-%dT%TZ")}local bc,cc=0,0;if(db~=nil)then
if(db[1][1][1]~=nil)then bc,cc=ac.width or#db[1][1][1],
ac.height or#db[1]end end;local dc={}
local function _d(cd,dd)cd=cd or#_c+1
local __a=cb(dd,dc)table.insert(_c,cd,__a)if(dd==nil)then
_c[cd].setSize(bc,cc)end;return __a end;local function ad(cd)table.remove(_c,cd or#_c)end
local function bd(cd,dd)
local __a=_c[cd]
if(__a~=nil)then local a_a=cd+dd;if(a_a>=1)and(a_a<=#_c)then table.remove(_c,cd)
table.insert(_c,a_a,__a)end end end
dc={updateSize=function(cd,dd,__a)local a_a=__a==true and true or false
if(cd>bc)then a_a=true;bc=cd end;if(dd>cc)then a_a=true;cc=dd end
if(a_a)then for b_a,c_a in pairs(_c)do c_a.setSize(bc,cc)
c_a.recalculateSize()end end end,text=function(cd,dd,__a,a_a)
local b_a=_c[cd]if(b_a==nil)then b_a=_d(cd)end;b_a.text(dd,__a,a_a)end,fg=function(cd,dd,__a,a_a)
local b_a=_c[cd]if(b_a==nil)then b_a=_d(cd)end;b_a.fg(dd,__a,a_a)end,bg=function(cd,dd,__a,a_a)
local b_a=_c[cd]if(b_a==nil)then b_a=_d(cd)end;b_a.bg(dd,__a,a_a)end,blit=function(cd,dd,__a,a_a,b_a,c_a)
local d_a=_c[cd]if(d_a==nil)then d_a=_d(cd)end;d_a.blit(dd,__a,a_a,b_a,c_a)end,setSize=function(cd,dd)
bc=cd;cc=dd;for __a,a_a in pairs(_c)do a_a.setSize(cd,dd)end end,getFrame=function(cd)if(
_c[cd]~=nil)then return _c[cd].getFrame()end end,getFrameObjects=function()return
_c end,getFrames=function()local cd={}for dd,__a in pairs(_c)do local a_a=__a.getFrame()
table.insert(cd,a_a)end;return cd end,getFrameObject=function(cd)return
_c[cd]end,addFrame=function(cd)if(#_c<=1)then
if(ac.animated==nil)then ac.animated=true end
if(ac.secondsPerFrame==nil)then ac.secondsPerFrame=0.2 end end;return _d(cd)end,removeFrame=ad,moveFrame=bd,setFrameData=function(cd,dd,__a)
if(
_c[cd]~=nil)then _c[cd].setFrameData(dd,__a)end end,getFrameData=function(cd,dd)if(_c[cd]~=nil)then return
_c[cd].getFrameData(dd)end end,getSize=function()return
bc,cc end,setAnimation=function(cd)ac.animation=cd end,setMetadata=function(cd,dd)if(dd~=nil)then ac[cd]=dd else if(
type(cd)=="table")then ac=cd end end end,getMetadata=function(cd)if(
cd~=nil)then return ac[cd]else return ac end end,createBimg=function()
local cd={}
for dd,__a in pairs(_c)do local a_a=__a.getFrame()table.insert(cd,a_a)end;for dd,__a in pairs(ac)do cd[dd]=__a end;cd.width=bc;cd.height=cc;return cd end}
if(db~=nil)then
for cd,dd in pairs(db)do if(type(cd)=="string")then ac[cd]=dd end end
if(ac.width==nil)or(ac.height==nil)then
bc=ac.width or#db[1][1][1]cc=ac.height or#db[1]dc.updateSize(bc,cc,true)end
for cd,dd in pairs(db)do if(type(cd)=="number")then _d(cd,dd)end end else _d(1)end;return dc end end
aa["libraries"]["basaltMon"]=function(...)
local ab={[colors.white]="0",[colors.orange]="1",[colors.magenta]="2",[colors.lightBlue]="3",[colors.yellow]="4",[colors.lime]="5",[colors.pink]="6",[colors.gray]="7",[colors.lightGray]="8",[colors.cyan]="9",[colors.purple]="a",[colors.blue]="b",[colors.brown]="c",[colors.green]="d",[colors.red]="e",[colors.black]="f"}local bb,cb,db,_c=type,string.len,string.rep,string.sub
return
function(ac)local bc={}
for _ba,aba in pairs(ac)do
bc[_ba]={}
for bba,cba in pairs(aba)do local dba=peripheral.wrap(cba)if(dba==nil)then
error("Unable to find monitor "..cba)end;bc[_ba][bba]=dba
bc[_ba][bba].name=cba end end;local cc,dc,_d,ad,bd,cd,dd,__a=1,1,1,1,0,0,0,0;local a_a,b_a=false,1
local c_a,d_a=colors.white,colors.black
local function _aa()local _ba,aba=0,0
for bba,cba in pairs(bc)do local dba,_ca=0,0
for aca,bca in pairs(cba)do local cca,dca=bca.getSize()
dba=dba+cca;_ca=dca>_ca and dca or _ca end;_ba=_ba>dba and _ba or dba;aba=aba+_ca end;dd,__a=_ba,aba end;_aa()
local function aaa()local _ba=0;local aba,bba=0,0
for cba,dba in pairs(bc)do local _ca=0;local aca=0
for bca,cca in pairs(dba)do
local dca,_da=cca.getSize()if(cc-_ca>=1)and(cc-_ca<=dca)then aba=bca end;cca.setCursorPos(
cc-_ca,dc-_ba)_ca=_ca+dca
if(aca<_da)then aca=_da end end;if(dc-_ba>=1)and(dc-_ba<=aca)then bba=cba end
_ba=_ba+aca end;_d,ad=aba,bba end;aaa()
local function baa(_ba,...)local aba={...}return
function()for bba,cba in pairs(bc)do for dba,_ca in pairs(cba)do
_ca[_ba](table.unpack(aba))end end end end
local function caa()baa("setCursorBlink",false)()
if not(a_a)then return end;if(bc[ad]==nil)then return end;local _ba=bc[ad][_d]
if(_ba==nil)then return end;_ba.setCursorBlink(a_a)end
local function daa(_ba,aba,bba)if(bc[ad]==nil)then return end;local cba=bc[ad][_d]
if(cba==nil)then return end;cba.blit(_ba,aba,bba)local dba,_ca=cba.getSize()
if
(cb(_ba)+cc>dba)then local aca=bc[ad][_d+1]if(aca~=nil)then aca.blit(_ba,aba,bba)_d=_d+1;cc=cc+
cb(_ba)end end;aaa()end
return
{clear=baa("clear"),setCursorBlink=function(_ba)a_a=_ba;caa()end,getCursorBlink=function()return a_a end,getCursorPos=function()return cc,dc end,setCursorPos=function(_ba,aba)
cc,dc=_ba,aba;aaa()caa()end,setTextScale=function(_ba)
baa("setTextScale",_ba)()_aa()aaa()b_a=_ba end,getTextScale=function()return b_a end,blit=function(_ba,aba,bba)
daa(_ba,aba,bba)end,write=function(_ba)_ba=tostring(_ba)local aba=cb(_ba)
daa(_ba,db(ab[c_a],aba),db(ab[d_a],aba))end,getSize=function()return dd,__a end,setBackgroundColor=function(_ba)
baa("setBackgroundColor",_ba)()d_a=_ba end,setTextColor=function(_ba)
baa("setTextColor",_ba)()c_a=_ba end,calculateClick=function(_ba,aba,bba)local cba=0
for dba,_ca in pairs(bc)do local aca=0;local bca=0
for cca,dca in pairs(_ca)do
local _da,ada=dca.getSize()if(dca.name==_ba)then return aba+aca,bba+cba end
aca=aca+_da;if(ada>bca)then bca=ada end end;cba=cba+bca end;return aba,bba end}end end
aa["libraries"]["basaltLogs"]=function(...)local ab=""local bb="basaltLog.txt"local cb="Debug"
fs.delete(
ab~=""and ab.."/"..bb or bb)
local db={__call=function(_c,ac,bc)if(ac==nil)then return end
local cc=ab~=""and ab.."/"..bb or bb
local dc=fs.open(cc,fs.exists(cc)and"a"or"w")
dc.writeLine("[Basalt]["..
os.date("%Y-%m-%d %H:%M:%S").."][".. (bc and bc or cb)..
"]: "..tostring(ac))dc.close()end}return setmetatable({},db)end
aa["libraries"]["xmlParser"]=function(...)
local ab={new=function(db)
return
{tag=db,value=nil,attributes={},children={},addChild=function(_c,ac)
table.insert(_c.children,ac)end,addAttribute=function(_c,ac,bc)_c.attributes[ac]=bc end}end}
local bb=function(db,_c)
local ac,bc=string.gsub(_c,"(%w+)=([\"'])(.-)%2",function(_d,ad,bd)
db:addAttribute(_d,"\""..bd.."\"")end)
local cc,dc=string.gsub(_c,"(%w+)={(.-)}",function(_d,ad)db:addAttribute(_d,ad)end)end
local cb={parseText=function(db)local _c={}local ac=ab.new()table.insert(_c,ac)local bc,cc,dc,_d,ad;local bd,cd=1,1
while true do
bc,cd,cc,dc,_d,ad=string.find(db,"<(%/?)([%w_:]+)(.-)(%/?)>",bd)if not bc then break end;local __a=string.sub(db,bd,bc-1)if not
string.find(__a,"^%s*$")then local a_a=(ac.value or"")..__a
_c[#_c].value=a_a end
if ad=="/"then local a_a=ab.new(dc)
bb(a_a,_d)ac:addChild(a_a)elseif cc==""then local a_a=ab.new(dc)bb(a_a,_d)
table.insert(_c,a_a)ac=a_a else local a_a=table.remove(_c)ac=_c[#_c]
if#_c<1 then error("XMLParser: nothing to close with "..
dc)end;if a_a.tag~=dc then
error("XMLParser: trying to close "..a_a.tag.." with "..dc)end;ac:addChild(a_a)end;bd=cd+1 end;local dd=string.sub(db,bd)if#_c>1 then
error("XMLParser: unclosed ".._c[#_c].tag)end;return ac.children end}return cb end
aa["libraries"]["images"]=function(...)local ab,bb=string.sub,math.floor;local function cb(ad)return
{[1]={{},{},paintutils.loadImage(ad)}},"bimg"end;local function db(ad)return
paintutils.loadImage(ad),"nfp"end
local function _c(ad,bd)
local cd=fs.open(ad,bd and"rb"or"r")if(cd==nil)then
error("Path - "..ad.." doesn't exist!")end
local dd=textutils.unserialize(cd.readAll())cd.close()if(dd~=nil)then return dd,"bimg"end end;local function ac(ad)end;local function bc(ad)end;local function cc(ad,bd,cd)
if(ab(ad,-4)==".bimg")then return _c(ad,cd)elseif
(ab(ad,-3)==".bbf")then return ac(ad,cd)else return db(ad,cd)end end;local function dc(ad)
if
(ad:find(".bimg"))then return _c(ad)elseif(ad:find(".bbf"))then return bc(ad)else return cb(ad)end end
local function _d(ad,bd,cd)local dd,__a=ad.width or#
ad[1][1][1],ad.height or#ad[1]local a_a={}
for b_a,c_a in
pairs(ad)do
if(type(b_a)=="number")then local d_a={}
for y=1,cd do local _aa,aaa,baa="","",""
local caa=bb(y/cd*__a+0.5)
if(c_a[caa]~=nil)then
for x=1,bd do local daa=bb(x/bd*dd+0.5)_aa=_aa..
ab(c_a[caa][1],daa,daa)
aaa=aaa..ab(c_a[caa][2],daa,daa)baa=baa..ab(c_a[caa][3],daa,daa)end;table.insert(d_a,{_aa,aaa,baa})end end;table.insert(a_a,b_a,d_a)else a_a[b_a]=c_a end end;a_a.width=bd;a_a.height=cd;return a_a end
return{loadNFP=db,loadBIMG=_c,loadImage=cc,resizeBIMG=_d,loadImageAsBimg=dc}end
aa["libraries"]["utils"]=function(...)local ab=da("tHex")
local bb,cb,db,_c,ac,bc=string.sub,string.find,string.reverse,string.rep,table.insert,string.len
local function cc(cd,dd)local __a={}if cd==""or dd==""then return __a end;local a_a=1
local b_a,c_a=cb(cd,dd,a_a)while b_a do ac(__a,bb(cd,a_a,b_a-1))a_a=c_a+1
b_a,c_a=cb(cd,dd,a_a)end;ac(__a,bb(cd,a_a))return __a end;local function dc(cd)return cd:gsub("{[^}]+}","")end
local function _d(cd,dd)cd=dc(cd)if
(cd=="")or(dd==0)then return{""}end;local __a=cc(cd,"\n")local a_a={}
for b_a,c_a in
pairs(__a)do
if#c_a==0 then table.insert(a_a,"")else
while#c_a>dd do local d_a=dd;for i=dd,1,-1 do if bb(c_a,i,i)==" "then
d_a=i;break end end
if d_a==dd then
local _aa=bb(c_a,1,d_a-1).."-"table.insert(a_a,_aa)c_a=bb(c_a,d_a)else
local _aa=bb(c_a,1,d_a-1)table.insert(a_a,_aa)c_a=bb(c_a,d_a+1)end;if#c_a<=dd then break end end;if#c_a>0 then table.insert(a_a,c_a)end end end;return a_a end
local function ad(cd)local dd={}local __a=1;local a_a=1
while __a<=#cd do local b_a,c_a;local d_a,_aa;local aaa,baa
for _ba,aba in pairs(colors)do
local bba="{fg:".._ba.."}"local cba="{bg:".._ba.."}"local dba,_ca=cd:find(bba,__a)
local aca,bca=cd:find(cba,__a)
if dba and(not b_a or dba<b_a)then b_a=dba;d_a=_ba;aaa=_ca end
if aca and(not c_a or aca<c_a)then c_a=aca;_aa=_ba;baa=bca end end;local caa
if b_a and(not c_a or b_a<c_a)then caa=b_a elseif c_a then caa=c_a else caa=#cd+1 end;local daa=cd:sub(__a,caa-1)
if#daa>0 then
table.insert(dd,{color=nil,bgColor=nil,text=daa,position=a_a})a_a=a_a+#daa;__a=__a+#daa end
if b_a and(not c_a or b_a<c_a)then
table.insert(dd,{color=d_a,bgColor=nil,text="",position=a_a})__a=aaa+1 elseif c_a then
table.insert(dd,{color=nil,bgColor=_aa,text="",position=a_a})__a=baa+1 else break end end;return dd end
local function bd(cd,dd)local __a=ad(cd)local a_a={}local b_a,c_a=1,1;local d_a,_aa;local function aaa(baa)
table.insert(a_a,{x=b_a,y=c_a,text=baa.text,color=baa.color or d_a,bgColor=
baa.bgColor or _aa})end
for baa,caa in ipairs(__a)do
if
caa.color then d_a=caa.color elseif caa.bgColor then _aa=caa.bgColor else local daa=cc(caa.text," ")
for _ba,aba in
ipairs(daa)do local bba=#aba
if _ba>1 then if b_a+1 +bba<=dd then aaa({text=" "})b_a=b_a+1 else b_a=1;c_a=c_a+
1 end end;while bba>0 do local cba=aba:sub(1,dd-b_a+1)
aba=aba:sub(dd-b_a+2)bba=#aba;aaa({text=cba})
if bba>0 then b_a=1;c_a=c_a+1 else b_a=b_a+#cba end end end end;if b_a>dd then b_a=1;c_a=c_a+1 end end;return a_a end
return
{getTextHorizontalAlign=function(cd,dd,__a,a_a)cd=bb(cd,1,dd)local b_a=dd-bc(cd)
if(__a=="right")then
cd=_c(a_a or" ",b_a)..cd elseif(__a=="center")then
cd=_c(a_a or" ",math.floor(b_a/2))..cd.._c(a_a or" ",math.floor(
b_a/2))
cd=cd.. (bc(cd)<dd and(a_a or" ")or"")else cd=cd.._c(a_a or" ",b_a)end;return cd end,getTextVerticalAlign=function(cd,dd)
local __a=0
if(dd=="center")then __a=math.ceil(cd/2)if(__a<1)then __a=1 end end;if(dd=="bottom")then __a=cd end;if(__a<1)then __a=1 end;return __a end,orderedTable=function(cd)
local dd={}for __a,a_a in pairs(cd)do dd[#dd+1]=a_a end;return dd end,rpairs=function(cd)return
function(dd,__a)__a=
__a-1;if __a~=0 then return __a,dd[__a]end end,cd,#cd+1 end,tableCount=function(cd)
local dd=0;if(cd~=nil)then for __a,a_a in pairs(cd)do dd=dd+1 end end
return dd end,splitString=cc,removeTags=dc,wrapText=_d,convertRichText=ad,writeRichText=function(cd,dd,__a,a_a)local b_a=ad(a_a)if(#b_a==0)then
cd:addText(dd,__a,a_a)return end
local c_a,d_a=cd:getForeground(),cd:getBackground()
for _aa,aaa in pairs(b_a)do
cd:addText(dd+aaa.position-1,__a,aaa.text)
if(aaa.color~=nil)then
cd:addFG(dd+aaa.position-1,__a,ab[colors[aaa.color]]:rep(
#aaa.text))c_a=colors[aaa.color]else cd:addFG(dd+aaa.position-1,__a,ab[c_a]:rep(#
aaa.text))end
if(aaa.bgColor~=nil)then
cd:addBG(dd+aaa.position-1,__a,ab[colors[aaa.bgColor]]:rep(
#aaa.text))d_a=colors[aaa.bgColor]else if(d_a~=false)then
cd:addBG(dd+aaa.position-1,__a,ab[d_a]:rep(
#aaa.text))end end end end,wrapRichText=bd,writeWrappedText=function(cd,dd,__a,a_a,b_a,c_a)
local d_a=bd(a_a,b_a)
for _aa,aaa in pairs(d_a)do if(aaa.y>c_a)then break end
if(aaa.text~=nil)then cd:addText(dd+aaa.x-1,__a+
aaa.y-1,aaa.text)end;if(aaa.color~=nil)then
cd:addFG(dd+aaa.x-1,__a+aaa.y-1,ab[colors[aaa.color]]:rep(
#aaa.text))end;if(aaa.bgColor~=nil)then
cd:addBG(dd+
aaa.x-1,__a+aaa.y-1,ab[colors[aaa.bgColor]]:rep(#
aaa.text))end end end,uuid=function()
return
string.gsub(string.format('%x-%x-%x-%x-%x',math.random(0,0xffff),math.random(0,0xffff),math.random(0,0xffff),
math.random(0,0x0fff)+0x4000,math.random(0,0x3fff)+0x8000),' ','0')end}end
aa["libraries"]["process"]=function(...)local ab={}local bb={}local cb=0
local db=dofile("rom/modules/main/cc/require.lua").make
function bb:new(_c,ac,bc,...)local cc={...}
local dc=setmetatable({path=_c},{__index=self})dc.window=ac;ac.current=term.current;ac.redirect=term.redirect
dc.processId=cb
if(type(_c)=="string")then
dc.coroutine=coroutine.create(function()
local _d=shell.resolveProgram(_c)local ad=setmetatable(bc,{__index=_ENV})ad.shell=shell
ad.basaltProgram=true;ad.arg={[0]=_c,table.unpack(cc)}
if(_d==nil)then error("The path ".._c..
" does not exist!")end;ad.require,ad.package=db(ad,fs.getDir(_d))
if(fs.exists(_d))then
local bd=fs.open(_d,"r")local cd=bd.readAll()bd.close()local dd=load(cd,_c,"bt",ad)if(dd~=nil)then return
dd()end end end)elseif(type(_c)=="function")then
dc.coroutine=coroutine.create(function()
_c(table.unpack(cc))end)else return end;ab[cb]=dc;cb=cb+1;return dc end
function bb:resume(_c,...)local ac=term.current()term.redirect(self.window)
if(
self.filter~=nil)then if(_c~=self.filter)then return end;self.filter=nil end;local bc,cc=coroutine.resume(self.coroutine,_c,...)if bc then
self.filter=cc else printError(cc)end;term.redirect(ac)
return bc,cc end
function bb:isDead()
if(self.coroutine~=nil)then
if
(coroutine.status(self.coroutine)=="dead")then table.remove(ab,self.processId)return true end else return true end;return false end
function bb:getStatus()if(self.coroutine~=nil)then
return coroutine.status(self.coroutine)end;return nil end
function bb:start()coroutine.resume(self.coroutine)end;return bb end
aa["libraries"]["tHex"]=function(...)local ab={}
for i=0,15 do ab[2 ^i]=("%x"):format(i)end;return ab end
aa["libraries"]["reactivePrimitives"]=function(...)
local ab={CURRENT=0,STALE=1,MAYBE_STALE=2}local bb={}
bb.new=function()
return
{fn=nil,value=nil,status=ab.STALE,parents={},children={},cleanup=function(_c)
for ac,bc in ipairs(_c.parents)do for cc,dc in ipairs(bc.children)do if(dc==_c)then
table.remove(bc.children,cc)break end end end;_c.parents={}end}end
local cb={listeningNode=nil,sourceNodes={},effectNodes={},transaction=false}local db={}
db.pushUpdates=function()for _c,ac in ipairs(cb.sourceNodes)do
db.pushSourceNodeUpdate(ac)end;db.pullUpdates()end
db.pushSourceNodeUpdate=function(_c)if(_c.status==ab.CURRENT)then return end
db.pushNodeUpdate(_c)for ac,bc in ipairs(_c.children)do bc.status=ab.STALE end
_c.status=ab.CURRENT end
db.pushNodeUpdate=function(_c)if(_c==nil)then return end;_c.status=ab.MAYBE_STALE;for ac,bc in
ipairs(_c.children)do db.pushNodeUpdate(bc)end end
db.pullUpdates=function()
for _c,ac in ipairs(cb.effectNodes)do db.pullNodeUpdates(ac)end end
db.pullNodeUpdates=function(_c)if(_c.status==ab.CURRENT)then return end;if
(_c.status==ab.MAYBE_STALE)then
for ac,bc in ipairs(_c.parents)do db.pullNodeUpdates(bc)end end
if(_c.status==ab.STALE)then
_c:cleanup()local ac=cb.listeningNode;cb.listeningNode=_c;local bc=_c.value;_c.value=_c.fn()
cb.listeningNode=ac;for cc,dc in ipairs(_c.children)do
if(bc==_c.value)then dc.status=ab.CURRENT else dc.status=ab.STALE end end end;_c.status=ab.CURRENT end
db.subscribe=function(_c)local ac=cb.listeningNode
if(ac~=nil)then
table.insert(_c.children,ac)table.insert(ac.parents,_c)end end
db.observable=function(_c)local ac=bb.new()ac.value=_c;ac.status=ab.CURRENT;local bc=function()
db.subscribe(ac)return ac.value end
local cc=function(dc)if
(ac.value==dc)then return end;ac.value=dc;ac.status=cb.STALE;if(not cb.transaction)then
db.pushUpdates()end end;table.insert(cb.sourceNodes,ac)return bc,cc end
db.derived=function(_c)local ac=bb.new()ac.fn=_c;return
function()if(ac.status~=ab.CURRENT)then
db.pullNodeUpdates(ac)end;db.subscribe(ac)return ac.value end end
db.effect=function(_c)local ac=bb.new()ac.fn=_c
table.insert(cb.effectNodes,ac)db.pushUpdates()end
db.transaction=function(_c)cb.transaction=true;_c()cb.transaction=false
db.pushUpdates()end
db.untracked=function(_c)local ac=cb.listeningNode;cb.listeningNode=nil;local bc=_c()
cb.listeningNode=ac;return bc end;return db end
aa["loadObjects"]=function(...)local ab={}if(ba)then
for db,_c in pairs(_b("objects"))do ab[db]=_c()end;return ab end;local bb=table.pack(...)local cb=fs.getDir(
bb[2]or"Basalt")if(cb==nil)then
error("Unable to find directory "..bb[2]..
" please report this bug to our discord.")end
for db,_c in
pairs(fs.list(fs.combine(cb,"objects")))do if(_c~="example.lua")and not(_c:find(".disabled"))then
local ac=_c:gsub(".lua","")ab[ac]=da(ac)end end;return ab end;aa["objects"]={}
aa["objects"]["Graph"]=function(...)
return
function(ab,bb)
local cb=bb.getObject("ChangeableObject")(ab,bb)local db="Graph"cb:setZIndex(5)cb:setSize(30,10)local _c={}
local ac=colors.gray;local bc="\7"local cc=colors.black;local dc=100;local _d=0;local ad="line"local bd=10
local cd={getType=function(dd)return db end,setGraphColor=function(dd,__a)ac=
__a or ac;dd:updateDraw()return dd end,setGraphSymbol=function(dd,__a,a_a)
bc=__a or bc;cc=a_a or cc;dd:updateDraw()return dd end,setGraphSymbolColor=function(dd,__a)return dd:setGraphSymbolColor(
nil,__a)end,getGraphSymbol=function(dd)
return bc,cc end,getGraphSymbolColor=function(dd)return cc end,addDataPoint=function(dd,__a)if __a>=_d and __a<=dc then
table.insert(_c,__a)dd:updateDraw()end;if(#_c>100)then
table.remove(_c,1)end;return dd end,setMaxValue=function(dd,__a)
dc=__a;dd:updateDraw()return dd end,getMaxValue=function(dd)return dc end,setMinValue=function(dd,__a)
_d=__a;dd:updateDraw()return dd end,getMinValue=function(dd)return _d end,setGraphType=function(dd,__a)if __a==
"scatter"or __a=="line"or __a=="bar"then ad=__a
dd:updateDraw()end;return dd end,getGraphType=function(dd)return
ad end,setMaxEntries=function(dd,__a)bd=__a;dd:updateDraw()return dd end,getMaxEntries=function(dd)return
bd end,clear=function(dd)_c={}dd:updateDraw()return dd end,draw=function(dd)
cb.draw(dd)
dd:addDraw("graph",function()local __a,a_a=dd:getPosition()local b_a,c_a=dd:getSize()
local d_a,_aa=dd:getBackground(),dd:getForeground()local aaa=dc-_d;local baa,caa;local daa=#_c-bd+1;if daa<1 then daa=1 end
for i=daa,#_c do local _ba=_c[i]
local aba=math.floor(( (
b_a-1)/ (bd-1))* (i-daa)+1.5)
local bba=math.floor((c_a-1)- ( (c_a-1)/aaa)* (_ba-_d)+1.5)
if ad=="scatter"then dd:addBackgroundBox(aba,bba,1,1,ac)
dd:addForegroundBox(aba,bba,1,1,cc)dd:addTextBox(aba,bba,1,1,bc)elseif ad=="line"then
if baa and caa then
local cba=math.abs(aba-baa)local dba=math.abs(bba-caa)local _ca=baa<aba and 1 or-1;local aca=caa<
bba and 1 or-1;local bca=cba-dba
while true do
dd:addBackgroundBox(baa,caa,1,1,ac)dd:addForegroundBox(baa,caa,1,1,cc)
dd:addTextBox(baa,caa,1,1,bc)if baa==aba and caa==bba then break end;local cca=2 *bca;if cca>-dba then
bca=bca-dba;baa=baa+_ca end
if cca<cba then bca=bca+cba;caa=caa+aca end end end;baa,caa=aba,bba elseif ad=="bar"then
dd:addBackgroundBox(aba-1,bba,1,c_a-bba,ac)end end end)end}cd.__index=cd;return setmetatable(cd,cb)end end
aa["objects"]["Image"]=function(...)local ab=da("images")local bb=da("bimg")
local cb,db,_c,ac=table.unpack,string.sub,math.max,math.min
return
function(bc,cc)local dc=cc.getObject("VisualObject")(bc,cc)
local _d="Image"local ad=bb()local bd=ad.getFrameObject(1)local cd;local dd;local __a=1;local a_a=false;local b_a
local c_a=false;local d_a=true;local _aa,aaa=0,0;dc:setSize(24,8)dc:setZIndex(2)
local function baa(_ba)local aba={}
for dba,_ca in
pairs(colors)do if(type(_ca)=="number")then
aba[dba]={term.nativePaletteColor(_ca)}end end;local bba=ad.getMetadata("palette")if(bba~=nil)then for dba,_ca in pairs(bba)do
aba[dba]=tonumber(_ca)end end
local cba=ad.getFrameData("palette")cc.log(cba)if(cba~=nil)then
for dba,_ca in pairs(cba)do aba[dba]=tonumber(_ca)end end;return aba end;local function caa()
if(d_a)then if(ad~=nil)then dc:setSize(ad.getSize())end end end
local daa={getType=function(_ba)return _d end,isType=function(_ba,aba)return
_d==aba or
dc.isType~=nil and dc.isType(aba)or false end,setOffset=function(_ba,aba,bba,cba)
if(cba)then _aa=_aa+
aba or 0;aaa=aaa+bba or 0 else _aa=aba or _aa;aaa=bba or aaa end;_ba:updateDraw()return _ba end,setXOffset=function(_ba,aba)return _ba:setOffset(_ba,aba,
nil)end,setYOffset=function(_ba,aba)return
_ba:setOffset(_ba,nil,aba)end,setSize=function(_ba,aba,bba)dc:setSize(aba,bba)
d_a=false;return _ba end,getOffset=function(_ba)return _aa,aaa end,getXOffset=function(_ba)return _aa end,getYOffset=function(_ba)return
aaa end,selectFrame=function(_ba,aba)if(ad.getFrameObject(aba)==nil)then
ad.addFrame(aba)end;bd=ad.getFrameObject(aba)
dd=bd.getImage(aba)__a=aba;_ba:updateDraw()end,addFrame=function(_ba,aba)
ad.addFrame(aba)return _ba end,getFrame=function(_ba,aba)return ad.getFrame(aba)end,getFrameObject=function(_ba,aba)return
ad.getFrameObject(aba)end,removeFrame=function(_ba,aba)ad.removeFrame(aba)return _ba end,moveFrame=function(_ba,aba,bba)
ad.moveFrame(aba,bba)return _ba end,getFrames=function(_ba)return ad.getFrames()end,getFrameCount=function(_ba)return
#ad.getFrames()end,getActiveFrame=function(_ba)return __a end,loadImage=function(_ba,aba)if
(fs.exists(aba))then local bba=ab.loadBIMG(aba)ad=bb(bba)__a=1
bd=ad.getFrameObject(1)cd=ad.createBimg()dd=bd.getImage()caa()
_ba:updateDraw()end;return
_ba end,setPath=function(_ba,aba)return
_ba:loadImage(aba)end,setImage=function(_ba,aba)if(type(aba)=="table")then ad=bb(aba)__a=1
bd=ad.getFrameObject(1)cd=ad.createBimg()dd=bd.getImage()caa()
_ba:updateDraw()end;return _ba end,clear=function(_ba)
ad=bb()bd=ad.getFrameObject(1)dd=nil;_ba:updateDraw()return _ba end,getImage=function(_ba)return
ad.createBimg()end,getImageFrame=function(_ba,aba)return bd.getImage(aba)end,usePalette=function(_ba,aba)c_a=
aba~=nil and aba or true;return _ba end,getUsePalette=function(_ba)return
c_a end,setUsePalette=function(_ba,aba)return _ba:usePalette(aba)end,play=function(_ba,aba)
if
(ad.getMetadata("animated"))then
local bba=
ad.getMetadata("duration")or ad.getMetadata("secondsPerFrame")or 0.2;_ba:listenEvent("other_event")
b_a=os.startTimer(bba)a_a=aba or false end;return _ba end,setPlay=function(_ba,aba)return
_ba:play(aba)end,stop=function(_ba)os.cancelTimer(b_a)b_a=nil;a_a=false
return _ba end,eventHandler=function(_ba,aba,bba,...)
dc.eventHandler(_ba,aba,bba,...)
if(aba=="timer")then
if(bba==b_a)then
if(ad.getFrame(__a+1)~=nil)then __a=__a+1
_ba:selectFrame(__a)
local cba=
ad.getFrameData(__a,"duration")or ad.getMetadata("secondsPerFrame")or 0.2;b_a=os.startTimer(cba)else
if(a_a)then __a=1;_ba:selectFrame(__a)
local cba=
ad.getFrameData(__a,"duration")or ad.getMetadata("secondsPerFrame")or 0.2;b_a=os.startTimer(cba)end end;_ba:updateDraw()end end end,setMetadata=function(_ba,aba,bba)
ad.setMetadata(aba,bba)return _ba end,getMetadata=function(_ba,aba)return ad.getMetadata(aba)end,getFrameMetadata=function(_ba,aba,bba)return
ad.getFrameData(aba,bba)end,setFrameMetadata=function(_ba,aba,bba,cba)
ad.setFrameData(aba,bba,cba)return _ba end,blit=function(_ba,aba,bba,cba,dba,_ca)x=dba or x;y=_ca or y
bd.blit(aba,bba,cba,x,y)dd=bd.getImage()_ba:updateDraw()return _ba end,setText=function(_ba,aba,bba,cba)x=
bba or x;y=cba or y;bd.text(aba,x,y)dd=bd.getImage()
_ba:updateDraw()return _ba end,setBg=function(_ba,aba,bba,cba)x=bba or x;y=
cba or y;bd.bg(aba,x,y)dd=bd.getImage()
_ba:updateDraw()return _ba end,setFg=function(_ba,aba,bba,cba)x=bba or x
y=cba or y;bd.fg(aba,x,y)dd=bd.getImage()_ba:updateDraw()return _ba end,getImageSize=function(_ba)return
ad.getSize()end,setImageSize=function(_ba,aba,bba)ad.setSize(aba,bba)
dd=bd.getImage()_ba:updateDraw()return _ba end,resizeImage=function(_ba,aba,bba)
local cba=ab.resizeBIMG(cd,aba,bba)ad=bb(cba)__a=1;bd=ad.getFrameObject(1)dd=bd.getImage()
_ba:updateDraw()return _ba end,draw=function(_ba)
dc.draw(_ba)
_ba:addDraw("image",function()local aba,bba=_ba:getSize()local cba,dba=_ba:getPosition()
local _ca,aca=_ba:getParent():getSize()local bca,cca=_ba:getParent():getOffset()
if
(cba-bca>_ca)or(dba-cca>aca)or(cba-bca+aba<1)or(dba-
cca+bba<1)then return end
if(c_a)then _ba:getParent():setPalette(baa(__a))end
if(dd~=nil)then
for dca,_da in pairs(dd)do
if(dca+aaa<=bba)and(dca+aaa>=1)then
local ada,bda,cda=_da[1],_da[2],_da[3]local dda=_c(1 -_aa,1)local __b=ac(aba-_aa,#ada)
ada=db(ada,dda,__b)bda=db(bda,dda,__b)cda=db(cda,dda,__b)
_ba:addBlit(_c(1 +_aa,1),dca+aaa,ada,bda,cda)end end end end)end}daa.__index=daa;return setmetatable(daa,dc)end end
aa["objects"]["List"]=function(...)local ab=da("utils")local bb=da("tHex")
return
function(cb,db)
local _c=db.getObject("ChangeableObject")(cb,db)local ac="List"local bc={}local cc=colors.black;local dc=colors.lightGray;local _d=true
local ad="left"local bd=0;local cd=true;_c:setSize(16,8)_c:setZIndex(5)
local dd={init=function(__a)
local a_a=__a:getParent()__a:listenEvent("mouse_click")
__a:listenEvent("mouse_drag")__a:listenEvent("mouse_scroll")return _c.init(__a)end,getBase=function(__a)return
_c end,setTextAlign=function(__a,a_a)ad=a_a;return __a end,getTextAlign=function(__a)return ad end,getBase=function(__a)return _c end,getType=function(__a)return
ac end,isType=function(__a,a_a)return
ac==a_a or _c.isType~=nil and _c.isType(a_a)or false end,addItem=function(__a,a_a,b_a,c_a,...)
table.insert(bc,{text=a_a,bgCol=
b_a or __a:getBackground(),fgCol=c_a or __a:getForeground(),args={...}})if(#bc<=1)then __a:setValue(bc[1],false)end
__a:updateDraw()return __a end,setOptions=function(__a,...)
bc={}
for a_a,b_a in pairs(...)do
if(type(b_a)=="string")then
table.insert(bc,{text=b_a,bgCol=__a:getBackground(),fgCol=__a:getForeground(),args={}})else
table.insert(bc,{text=b_a[1],bgCol=b_a[2]or __a:getBackground(),fgCol=b_a[3]or
__a:getForeground(),args=b_a[4]or{}})end end;__a:setValue(bc[1],false)__a:updateDraw()return __a end,setOffset=function(__a,a_a)
bd=a_a;__a:updateDraw()return __a end,getOffset=function(__a)return bd end,removeItem=function(__a,a_a)
if(
type(a_a)=="number")then table.remove(bc,a_a)elseif(type(a_a)=="table")then
for b_a,c_a in
pairs(bc)do if(c_a==a_a)then table.remove(bc,b_a)break end end end;__a:updateDraw()return __a end,getItem=function(__a,a_a)return
bc[a_a]end,getAll=function(__a)return bc end,getOptions=function(__a)return bc end,getItemIndex=function(__a)
local a_a=__a:getValue()for b_a,c_a in pairs(bc)do if(c_a==a_a)then return b_a end end end,clear=function(__a)
bc={}__a:setValue({},false)__a:updateDraw()return __a end,getItemCount=function(__a)return
#bc end,editItem=function(__a,a_a,b_a,c_a,d_a,...)table.remove(bc,a_a)
table.insert(bc,a_a,{text=b_a,bgCol=c_a or
__a:getBackground(),fgCol=d_a or __a:getForeground(),args={...}})__a:updateDraw()return __a end,selectItem=function(__a,a_a)__a:setValue(
bc[a_a]or{},false)__a:updateDraw()return __a end,setSelectionColor=function(__a,a_a,b_a,c_a)cc=
a_a or __a:getBackground()
dc=b_a or __a:getForeground()_d=c_a~=nil and c_a or true;__a:updateDraw()
return __a end,setSelectionBG=function(__a,a_a)return __a:setSelectionColor(a_a,
nil,_d)end,setSelectionFG=function(__a,a_a)return __a:setSelectionColor(
nil,a_a,_d)end,getSelectionColor=function(__a)
return cc,dc end,getSelectionBG=function(__a)return cc end,getSelectionFG=function(__a)return dc end,isSelectionColorActive=function(__a)return _d end,setScrollable=function(__a,a_a)
cd=a_a;if(a_a==nil)then cd=true end;__a:updateDraw()return __a end,getScrollable=function(__a)return
cd end,scrollHandler=function(__a,a_a,b_a,c_a)
if(_c.scrollHandler(__a,a_a,b_a,c_a))then
if(cd)then
local d_a,_aa=__a:getSize()bd=bd+a_a;if(bd<0)then bd=0 end;if(a_a>=1)then
if(#bc>_aa)then
if(bd>#bc-_aa)then bd=#bc-_aa end;if(bd>=#bc)then bd=#bc-1 end else bd=bd-1 end end
__a:updateDraw()end;return true end;return false end,mouseHandler=function(__a,a_a,b_a,c_a)
if
(_c.mouseHandler(__a,a_a,b_a,c_a))then local d_a,_aa=__a:getAbsolutePosition()local aaa,baa=__a:getSize()
if
(#bc>0)then
for n=1,baa do
if(bc[n+bd]~=nil)then if
(d_a<=b_a)and(d_a+aaa>b_a)and(_aa+n-1 ==c_a)then __a:setValue(bc[n+bd])__a:selectHandler()
__a:updateDraw()end end end end;return true end;return false end,dragHandler=function(__a,a_a,b_a,c_a)return
__a:mouseHandler(a_a,b_a,c_a)end,touchHandler=function(__a,a_a,b_a)return
__a:mouseHandler(1,a_a,b_a)end,onSelect=function(__a,...)
for a_a,b_a in
pairs(table.pack(...))do if(type(b_a)=="function")then
__a:registerEvent("select_item",b_a)end end;return __a end,selectHandler=function(__a)
__a:sendEvent("select_item",__a:getValue())end,draw=function(__a)_c.draw(__a)
__a:addDraw("list",function()
local a_a,b_a=__a:getSize()
for n=1,b_a do
if bc[n+bd]then local c_a=bc[n+bd].text
local d_a,_aa=bc[n+bd].fgCol,bc[n+bd].bgCol
if bc[n+bd]==__a:getValue()and _d then d_a,_aa=dc,cc end;__a:addText(1,n,c_a:sub(1,a_a))
__a:addBG(1,n,bb[_aa]:rep(a_a))__a:addFG(1,n,bb[d_a]:rep(a_a))end end end)end}dd.__index=dd;return setmetatable(dd,_c)end end
aa["objects"]["ChangeableObject"]=function(...)
return
function(ab,bb)
local cb=bb.getObject("VisualObject")(ab,bb)local db="ChangeableObject"local _c
local ac={setValue=function(bc,cc,dc)if(_c~=cc)then _c=cc;bc:updateDraw()if(dc~=false)then
bc:valueChangedHandler()end end;return bc end,getValue=function(bc)return
_c end,onChange=function(bc,...)
for cc,dc in pairs(table.pack(...))do if(type(dc)=="function")then
bc:registerEvent("value_changed",dc)end end;return bc end,valueChangedHandler=function(bc)
bc:sendEvent("value_changed",_c)end}ac.__index=ac;return setmetatable(ac,cb)end end
aa["objects"]["Frame"]=function(...)local ab=da("utils")
local bb,cb,db,_c,ac=math.max,math.min,string.sub,string.rep,string.len
return
function(bc,cc)local dc=cc.getObject("Container")(bc,cc)local _d="Frame"
local ad;local bd=true;local cd,dd=0,0;dc:setSize(30,10)dc:setZIndex(10)
local __a={getType=function()return _d end,isType=function(a_a,b_a)return

_d==b_a or dc.isType~=nil and dc.isType(b_a)or false end,getBase=function(a_a)
return dc end,getOffset=function(a_a)return cd,dd end,setOffset=function(a_a,b_a,c_a)cd=b_a or cd;dd=c_a or dd
a_a:updateDraw()return a_a end,getXOffset=function(a_a)return cd end,setXOffset=function(a_a,b_a)return
a_a:setOffset(b_a,nil)end,getYOffset=function(a_a)return dd end,setYOffset=function(a_a,b_a)return
a_a:setOffset(nil,b_a)end,setParent=function(a_a,b_a,...)
dc.setParent(a_a,b_a,...)ad=b_a;return a_a end,render=function(a_a)
if(dc.render~=nil)then
if
(a_a:isVisible())then dc.render(a_a)local b_a=a_a:getChildren()for c_a,d_a in ipairs(b_a)do
if(
d_a.element.render~=nil)then d_a.element:render()end end end end end,updateDraw=function(a_a)if(
ad~=nil)then ad:updateDraw()end;return a_a end,blit=function(a_a,b_a,c_a,d_a,_aa,aaa)
local baa,caa=a_a:getPosition()local daa,_ba=ad:getOffset()baa=baa-daa;caa=caa-_ba
local aba,bba=a_a:getSize()
if c_a>=1 and c_a<=bba then
local cba=db(d_a,bb(1 -b_a+1,1),bb(aba-b_a+1,1))
local dba=db(_aa,bb(1 -b_a+1,1),bb(aba-b_a+1,1))
local _ca=db(aaa,bb(1 -b_a+1,1),bb(aba-b_a+1,1))
ad:blit(bb(b_a+ (baa-1),baa),caa+c_a-1,cba,dba,_ca)end end,setCursor=function(a_a,b_a,c_a,d_a,_aa)
local aaa,baa=a_a:getPosition()local caa,daa=a_a:getOffset()
ad:setCursor(b_a or false,(c_a or 0)+aaa-1 -caa,(
d_a or 0)+baa-1 -daa,_aa or colors.white)return a_a end}
for a_a,b_a in
pairs({"drawBackgroundBox","drawForegroundBox","drawTextBox"})do
__a[b_a]=function(c_a,d_a,_aa,aaa,baa,caa)local daa,_ba=c_a:getPosition()local aba,bba=ad:getOffset()
daa=daa-aba;_ba=_ba-bba
baa=(_aa<1 and(
baa+_aa>c_a:getHeight()and c_a:getHeight()or baa+_aa-1)or(
baa+
_aa>c_a:getHeight()and c_a:getHeight()-_aa+1 or baa))
aaa=(d_a<1 and(aaa+d_a>c_a:getWidth()and c_a:getWidth()or aaa+
d_a-1)or(

aaa+d_a>c_a:getWidth()and c_a:getWidth()-d_a+1 or aaa))
ad[b_a](ad,bb(d_a+ (daa-1),daa),bb(_aa+ (_ba-1),_ba),aaa,baa,caa)end end
for a_a,b_a in pairs({"setBG","setFG","setText"})do
__a[b_a]=function(c_a,d_a,_aa,aaa)
local baa,caa=c_a:getPosition()local daa,_ba=ad:getOffset()baa=baa-daa;caa=caa-_ba
local aba,bba=c_a:getSize()if(_aa>=1)and(_aa<=bba)then
ad[b_a](ad,bb(d_a+ (baa-1),baa),caa+_aa-1,db(aaa,bb(
1 -d_a+1,1),bb(aba-d_a+1,1)))end end end;__a.__index=__a;return setmetatable(__a,dc)end end
aa["objects"]["BaseFrame"]=function(...)local ab=da("basaltDraw")
local bb=da("utils")local cb,db,_c,ac=math.max,math.min,string.sub,string.rep
return
function(bc,cc)
local dc=cc.getObject("Container")(bc,cc)local _d="BaseFrame"local ad,bd=0,0;local cd={}local dd=true;local __a=cc.getTerm()
local a_a=ab(__a)local b_a,c_a,d_a,_aa=1,1,false,colors.white
local aaa={getType=function()return _d end,isType=function(baa,caa)
return _d==caa or dc.isType~=nil and
dc.isType(caa)or false end,getBase=function(baa)return dc end,getOffset=function(baa)return ad,bd end,setOffset=function(baa,caa,daa)ad=
caa or ad;bd=daa or bd;baa:updateDraw()return baa end,getXOffset=function(baa)return
ad end,setXOffset=function(baa,caa)return baa:setOffset(caa,nil)end,getYOffset=function(baa)return
bd end,setYOffset=function(baa,caa)return baa:setOffset(nil,caa)end,setPalette=function(baa,caa,...)
if(
baa==cc.getActiveFrame())then
if(type(caa)=="string")then cd[caa]=...
__a.setPaletteColor(
type(caa)=="number"and caa or colors[caa],...)elseif(type(caa)=="table")then
for daa,_ba in pairs(caa)do cd[daa]=_ba
if(type(_ba)=="number")then
__a.setPaletteColor(
type(daa)=="number"and daa or colors[daa],_ba)else local aba,bba,cba=table.unpack(_ba)
__a.setPaletteColor(
type(daa)=="number"and daa or colors[daa],aba,bba,cba)end end end end;return baa end,setSize=function(baa,...)
dc.setSize(baa,...)a_a=ab(__a)return baa end,getSize=function()return __a.getSize()end,getWidth=function(baa)return
({__a.getSize()})[1]end,getHeight=function(baa)
return({__a.getSize()})[2]end,show=function(baa)dc.show(baa)cc.setActiveFrame(baa)
for caa,daa in
pairs(colors)do if(type(daa)=="number")then
__a.setPaletteColor(daa,colors.packRGB(term.nativePaletteColor((daa))))end end
for caa,daa in pairs(cd)do
if(type(daa)=="number")then
__a.setPaletteColor(
type(caa)=="number"and caa or colors[caa],daa)else local _ba,aba,bba=table.unpack(daa)
__a.setPaletteColor(
type(caa)=="number"and caa or colors[caa],_ba,aba,bba)end end;cc.setMainFrame(baa)return baa end,render=function(baa)
if(
dc.render~=nil)then
if(baa:isVisible())then
if(dd)then dc.render(baa)
local caa=baa:getChildren()for daa,_ba in ipairs(caa)do if(_ba.element.render~=nil)then
_ba.element:render()end end
dd=false end end end end,updateDraw=function(baa)
dd=true;return baa end,eventHandler=function(baa,caa,...)dc.eventHandler(baa,caa,...)if
(caa=="term_resize")then baa:setSize(__a.getSize())end end,updateTerm=function(baa)if(
a_a~=nil)then a_a.update()end end,setTerm=function(baa,caa)__a=caa;if(caa==
nil)then a_a=nil else a_a=ab(__a)end;return baa end,getTerm=function()return
__a end,blit=function(baa,caa,daa,_ba,aba,bba)local cba,dba=baa:getPosition()
local _ca,aca=baa:getSize()
if daa>=1 and daa<=aca then
local bca=_c(_ba,cb(1 -caa+1,1),cb(_ca-caa+1,1))
local cca=_c(aba,cb(1 -caa+1,1),cb(_ca-caa+1,1))
local dca=_c(bba,cb(1 -caa+1,1),cb(_ca-caa+1,1))
a_a.blit(cb(caa+ (cba-1),cba),dba+daa-1,bca,cca,dca)end end,setCursor=function(baa,caa,daa,_ba,aba)
local bba,cba=baa:getAbsolutePosition()local dba,_ca=baa:getOffset()d_a=caa or false;if(daa~=nil)then
b_a=bba+daa-1 -dba end
if(_ba~=nil)then c_a=cba+_ba-1 -_ca end;_aa=aba or _aa
if(d_a)then __a.setTextColor(_aa)
__a.setCursorPos(b_a,c_a)__a.setCursorBlink(d_a)else __a.setCursorBlink(false)end;return baa end}
for baa,caa in
pairs({mouse_click={"mouseHandler",true},mouse_up={"mouseUpHandler",false},mouse_drag={"dragHandler",false},mouse_scroll={"scrollHandler",true},mouse_hover={"hoverHandler",false}})do
aaa[caa[1]]=function(daa,_ba,aba,bba,...)if(dc[caa[1]](daa,_ba,aba,bba,...))then
cc.setActiveFrame(daa)end end end
for baa,caa in
pairs({"drawBackgroundBox","drawForegroundBox","drawTextBox"})do
aaa[caa]=function(daa,_ba,aba,bba,cba,dba)local _ca,aca=daa:getPosition()local bca,cca=daa:getSize()
cba=(aba<1 and(cba+
aba>daa:getHeight()and daa:getHeight()or cba+aba-
1)or(cba+aba>
daa:getHeight()and daa:getHeight()-aba+1 or
cba))
bba=(_ba<1 and(bba+_ba>daa:getWidth()and daa:getWidth()or bba+
_ba-1)or(

bba+_ba>daa:getWidth()and daa:getWidth()-_ba+1 or bba))
a_a[caa](cb(_ba+ (_ca-1),_ca),cb(aba+ (aca-1),aca),bba,cba,dba)end end
for baa,caa in pairs({"setBG","setFG","setText"})do
aaa[caa]=function(daa,_ba,aba,bba)
local cba,dba=daa:getPosition()local _ca,aca=daa:getSize()if(aba>=1)and(aba<=aca)then
a_a[caa](cb(_ba+ (cba-1),cba),
dba+aba-1,_c(bba,cb(1 -_ba+1,1),cb(_ca-_ba+1,1)))end end end;aaa.__index=aaa;return setmetatable(aaa,dc)end end
aa["objects"]["Container"]=function(...)local ab=da("utils")local bb=ab.tableCount
return
function(cb,db)
local _c=db.getObject("VisualObject")(cb,db)local ac="Container"local bc={}local cc={}local dc={}local _d;local ad=true;local bd,cd=0,0
local dd=function(cba,dba)
if
cba.zIndex==dba.zIndex then return cba.objId<dba.objId else return cba.zIndex<dba.zIndex end end
local __a=function(cba,dba)if cba.zIndex==dba.zIndex then return cba.evId>dba.evId else return
cba.zIndex>dba.zIndex end end;local function a_a(cba)cba:sortChildren()return bc end
local function b_a(cba,dba)if
(type(dba)=="table")then dba=dba:getName()end
for _ca,aca in ipairs(bc)do if
aca.element:getName()==dba then return aca.element end end end
local function c_a(cba,dba)local _ca=b_a(dba)if(_ca~=nil)then return _ca end;for aca,bca in ipairs(bc)do
if
(bca:getType()=="Container")then local cca=bca:getDeepChild(dba)if(cca~=nil)then return cca end end end end
local function d_a(cba,dba)if(b_a(dba:getName())~=nil)then return end;bd=bd+1
local _ca=dba:getZIndex()
table.insert(bc,{element=dba,zIndex=_ca,objId=bd})ad=false;dba:setParent(cba,true)for aca,bca in
pairs(dba:getRegisteredEvents())do cba:addEvent(aca,dba)end;if(dba.init~=
nil)then dba:init()end
if(dba.load~=nil)then dba:load()end;if(dba.draw~=nil)then dba:draw()end;return dba end
local function _aa(cba,dba)
if(type(dba)=="string")then dba=b_a(dba:getName())end;if(dba==nil)then return end
for _ca,aca in ipairs(bc)do if aca.element==dba then
table.remove(bc,_ca)return true end end;cba:removeEvents(dba)ad=false end;local function aaa(cba)local dba=cba:getParent()bc={}cc={}ad=false;bd=0;cd=0;_d=nil
dba:removeEvents(cba)end
local function baa(cba,dba,_ca)bd=bd+1;cd=cd+1;for aca,bca in
pairs(bc)do
if(bca.element==dba)then bca.zIndex=_ca;bca.objId=bd;break end end;for aca,bca in pairs(cc)do
for cca,dca in pairs(bca)do if
(dca.element==dba)then dca.zIndex=_ca;dca.evId=cd end end end;ad=false
cba:updateDraw()end
local function caa(cba,dba)local _ca=cba:getParent()
for aca,bca in pairs(cc)do for cca,dca in pairs(bca)do if(dca.element==dba)then
table.remove(cc[aca],cca)end end
if(
bb(cc[aca])<=0)then if(_ca~=nil)then _ca:removeEvent(aca,cba)end end end;ad=false end
local function daa(cba,dba,_ca)if(type(_ca)=="table")then _ca=_ca:getName()end
if(cc[dba]~=
nil)then for aca,bca in pairs(cc[dba])do
if(bca.element:getName()==_ca)then return bca end end end end
local function _ba(cba,dba,_ca)
if(daa(cba,dba,_ca:getName())~=nil)then return end;local aca=_ca:getZIndex()cd=cd+1
if(cc[dba]==nil)then cc[dba]={}end
table.insert(cc[dba],{element=_ca,zIndex=aca,evId=cd})ad=false;cba:listenEvent(dba)return _ca end
local function aba(cba,dba,_ca)
if(cc[dba]~=nil)then for aca,bca in pairs(cc[dba])do if(bca.element==_ca)then
table.remove(cc[dba],aca)end end;if(
bb(cc[dba])<=0)then cba:listenEvent(dba,false)end end;ad=false end
local function bba(cba,dba)return dba~=nil and cc[dba]or cc end
dc={getType=function()return ac end,getBase=function(cba)return _c end,isType=function(cba,dba)
return ac==dba or
_c.isType~=nil and _c.isType(dba)or false end,setSize=function(cba,...)_c.setSize(cba,...)
cba:customEventHandler("basalt_FrameResize")return cba end,setPosition=function(cba,...)
_c.setPosition(cba,...)cba:customEventHandler("basalt_FrameReposition")
return cba end,searchChildren=function(cba,dba)local _ca={}
for aca,bca in pairs(bc)do if
(string.find(bca.element:getName(),dba))then table.insert(_ca,bca)end end;return _ca end,getChildrenByType=function(cba,dba)
local _ca={}for aca,bca in pairs(bc)do
if(bca.element:isType(dba))then table.insert(_ca,bca)end end;return _ca end,setImportant=function(cba,dba)bd=
bd+1;cd=cd+1
for _ca,aca in pairs(cc)do for bca,cca in pairs(aca)do
if(cca.element==dba)then cca.evId=cd
table.remove(cc[_ca],bca)table.insert(cc[_ca],cca)break end end end
for _ca,aca in ipairs(bc)do if aca.element==dba then aca.objId=bd;table.remove(bc,_ca)
table.insert(bc,aca)break end end;if(cba.updateDraw~=nil)then cba:updateDraw()end
ad=false end,sortChildren=function(cba)if
(ad)then return end;table.sort(bc,dd)for dba,_ca in pairs(cc)do
table.sort(cc[dba],__a)end;ad=true end,clearFocusedChild=function(cba)if(
_d~=nil)then
if(b_a(cba,_d)~=nil)then _d:loseFocusHandler()end end;_d=nil;return cba end,setFocusedChild=function(cba,dba)
if(
_d~=dba)then if(_d~=nil)then
if(b_a(cba,_d)~=nil)then _d:loseFocusHandler()end end;if(dba~=nil)then if(b_a(cba,dba)~=nil)then
dba:getFocusHandler()end end;_d=dba;return true end;return false end,getFocused=function(cba)return
_d end,getChild=b_a,getChildren=a_a,getDeepChildren=c_a,addChild=d_a,removeChild=_aa,removeChildren=aaa,getEvents=bba,getEvent=daa,addEvent=_ba,removeEvent=aba,removeEvents=caa,updateZIndex=baa,listenEvent=function(cba,dba,_ca)_c.listenEvent(cba,dba,_ca)if(
cc[dba]==nil)then cc[dba]={}end;return cba end,customEventHandler=function(cba,...)
_c.customEventHandler(cba,...)
for dba,_ca in pairs(bc)do if(_ca.element.customEventHandler~=nil)then
_ca.element:customEventHandler(...)end end end,loseFocusHandler=function(cba)
_c.loseFocusHandler(cba)if(_d~=nil)then _d:loseFocusHandler()_d=nil end end,getBasalt=function(cba)return
db end,setPalette=function(cba,dba,...)local _ca=cba:getParent()
_ca:setPalette(dba,...)return cba end,eventHandler=function(cba,...)
if(_c.eventHandler~=nil)then
_c.eventHandler(cba,...)
if(cc["other_event"]~=nil)then cba:sortChildren()
for dba,_ca in
ipairs(cc["other_event"])do if(_ca.element.eventHandler~=nil)then
_ca.element.eventHandler(_ca.element,...)end end end end end}
for cba,dba in
pairs({mouse_click={"mouseHandler",true},mouse_up={"mouseUpHandler",false},mouse_drag={"dragHandler",false},mouse_scroll={"scrollHandler",true},mouse_hover={"hoverHandler",false}})do
dc[dba[1]]=function(_ca,aca,bca,cca,...)
if(_c[dba[1]]~=nil)then
if(_c[dba[1]](_ca,aca,bca,cca,...))then
if
(cc[cba]~=nil)then _ca:sortChildren()
for dca,_da in ipairs(cc[cba])do
if
(_da.element[dba[1]]~=nil)then local ada,bda=0,0
if(_ca.getOffset~=nil)then ada,bda=_ca:getOffset()end
if(_da.element.getIgnoreOffset~=nil)then if(_da.element.getIgnoreOffset())then
ada,bda=0,0 end end;if(_da.element[dba[1]](_da.element,aca,bca+ada,cca+bda,...))then return
true end end end;if(dba[2])then _ca:clearFocusedChild()end end;return true end end end end
for cba,dba in
pairs({key="keyHandler",key_up="keyUpHandler",char="charHandler"})do
dc[dba]=function(_ca,...)
if(_c[dba]~=nil)then
if(_c[dba](_ca,...))then
if(cc[cba]~=nil)then
_ca:sortChildren()for aca,bca in ipairs(cc[cba])do
if(bca.element[dba]~=nil)then if
(bca.element[dba](bca.element,...))then return true end end end end end end end end;for cba,dba in pairs(db.getObjects())do
dc["add"..cba]=function(_ca,aca)return
_ca:addChild(db:createObject(cba,aca))end end
dc.__index=dc;return setmetatable(dc,_c)end end
aa["objects"]["Checkbox"]=function(...)local ab=da("utils")local bb=da("tHex")
return
function(cb,db)
local _c=db.getObject("ChangeableObject")(cb,db)local ac="Checkbox"_c:setZIndex(5)_c:setValue(false)
_c:setSize(1,1)local bc,cc,dc,_d="\42"," ","","right"
local ad={load=function(bd)bd:listenEvent("mouse_click",bd)
bd:listenEvent("mouse_up",bd)end,getType=function(bd)return ac end,isType=function(bd,cd)return
ac==cd or
_c.isType~=nil and _c.isType(cd)or false end,setSymbol=function(bd,cd,dd)
bc=cd or bc;cc=dd or cc;bd:updateDraw()return bd end,setActiveSymbol=function(bd,cd)return bd:setSymbol(cd,
nil)end,setInactiveSymbol=function(bd,cd)
return bd:setSymbol(nil,cd)end,getSymbol=function(bd)return bc,cc end,getActiveSymbol=function(bd)return bc end,getInactiveSymbol=function(bd)return cc end,setText=function(bd,cd)
dc=cd;return bd end,getText=function(bd)return dc end,setTextPosition=function(bd,cd)_d=cd or _d;return bd end,getTextPosition=function(bd)return
_d end,setChecked=_c.setValue,getChecked=_c.getValue,mouseHandler=function(bd,cd,dd,__a)
if(_c.mouseHandler(bd,cd,dd,__a))then
if(cd==1)then
if(
bd:getValue()~=true)and(bd:getValue()~=false)then
bd:setValue(false)else bd:setValue(not bd:getValue())end;bd:updateDraw()return true end end;return false end,draw=function(bd)
_c.draw(bd)
bd:addDraw("checkbox",function()local cd,dd=bd:getPosition()local __a,a_a=bd:getSize()
local b_a=ab.getTextVerticalAlign(a_a,"center")local c_a,d_a=bd:getBackground(),bd:getForeground()
if
(bd:getValue())then
bd:addBlit(1,b_a,ab.getTextHorizontalAlign(bc,__a,"center"),bb[d_a],bb[c_a])else
bd:addBlit(1,b_a,ab.getTextHorizontalAlign(cc,__a,"center"),bb[d_a],bb[c_a])end;if(dc~="")then local _aa=_d=="left"and-dc:len()or 3
bd:addText(_aa,b_a,dc)end end)end}ad.__index=ad;return setmetatable(ad,_c)end end
aa["objects"]["Button"]=function(...)local ab=da("utils")local bb=da("tHex")
return
function(cb,db)
local _c=db.getObject("VisualObject")(cb,db)local ac="Button"local bc="center"local cc="center"local dc="Button"_c:setSize(12,3)
_c:setZIndex(5)
local _d={getType=function(ad)return ac end,isType=function(ad,bd)return
ac==bd or _c.isType~=nil and _c.isType(bd)or false end,getBase=function(ad)return
_c end,getHorizontalAlign=function(ad)return bc end,setHorizontalAlign=function(ad,bd)bc=bd;ad:updateDraw()return ad end,getVerticalAlign=function(ad)return
cc end,setVerticalAlign=function(ad,bd)cc=bd;ad:updateDraw()return ad end,getText=function(ad)
return dc end,setText=function(ad,bd)dc=bd;ad:updateDraw()return ad end,draw=function(ad)
_c.draw(ad)
ad:addDraw("button",function()local bd,cd=ad:getSize()
local dd=ab.getTextVerticalAlign(cd,cc)local __a
if(bc=="center")then
__a=math.floor((bd-dc:len())/2)elseif(bc=="right")then __a=bd-dc:len()end;ad:addText(__a+1,dd,dc)
ad:addFG(__a+1,dd,bb[ad:getForeground()or colors.white]:rep(dc:len()))end)end}_d.__index=_d;return setmetatable(_d,_c)end end
aa["objects"]["Dropdown"]=function(...)local ab=da("utils")local bb=da("tHex")
return
function(cb,db)
local _c=db.getObject("List")(cb,db)local ac="Dropdown"_c:setSize(12,1)_c:setZIndex(6)local bc=true
local cc="left"local dc=0;local _d=0;local ad=0;local bd=true;local cd="\16"local dd="\31"local __a=false
local a_a={getType=function(b_a)return ac end,isType=function(b_a,c_a)return

ac==c_a or _c.isType~=nil and _c.isType(c_a)or false end,load=function(b_a)
b_a:listenEvent("mouse_click",b_a)b_a:listenEvent("mouse_up",b_a)
b_a:listenEvent("mouse_scroll",b_a)b_a:listenEvent("mouse_drag",b_a)end,setOffset=function(b_a,c_a)
dc=c_a;b_a:updateDraw()return b_a end,getOffset=function(b_a)return dc end,addItem=function(b_a,c_a,...)
_c.addItem(b_a,c_a,...)if(bd)then _d=math.max(_d,#c_a)ad=ad+1 end;return b_a end,removeItem=function(b_a,c_a)
_c.removeItem(b_a,c_a)if(bd)then _d=0;ad=0
for n=1,#list do _d=math.max(_d,#list[n].text)end;ad=#list end end,isOpened=function(b_a)return
__a end,setOpened=function(b_a,c_a)__a=c_a;b_a:updateDraw()return b_a end,setDropdownSize=function(b_a,c_a,d_a)
_d,ad=c_a,d_a;bd=false;b_a:updateDraw()return b_a end,setDropdownWidth=function(b_a,c_a)return
b_a:setDropdownSize(c_a,ad)end,setDropdownHeight=function(b_a,c_a)
return b_a:setDropdownSize(_d,c_a)end,getDropdownSize=function(b_a)return _d,ad end,getDropdownWidth=function(b_a)return _d end,getDropdownHeight=function(b_a)return ad end,mouseHandler=function(b_a,c_a,d_a,_aa,aaa)
if
(__a)then local caa,daa=b_a:getAbsolutePosition()
if(c_a==1)then local _ba=b_a:getAll()
if(#
_ba>0)then
for n=1,ad do
if(_ba[n+dc]~=nil)then
if
(caa<=d_a)and(caa+_d>d_a)and(daa+n==_aa)then b_a:setValue(_ba[n+dc])b_a:updateDraw()
local aba=b_a:sendEvent("mouse_click",b_a,"mouse_click",c_a,d_a,_aa)if(aba==false)then return aba end;if(aaa)then
db.schedule(function()sleep(0.1)
b_a:mouseUpHandler(c_a,d_a,_aa)end)()end;return true end end end end end end;local baa=_c:getBase()
if(baa.mouseHandler(b_a,c_a,d_a,_aa))then __a=not __a
b_a:getParent():setImportant(b_a)b_a:updateDraw()return true else
if(__a)then b_a:updateDraw()__a=false end;return false end end,mouseUpHandler=function(b_a,c_a,d_a,_aa)
if
(__a)then local aaa,baa=b_a:getAbsolutePosition()
if(c_a==1)then local caa=b_a:getAll()
if(#
caa>0)then
for n=1,ad do
if(caa[n+dc]~=nil)then
if
(aaa<=d_a)and(aaa+_d>d_a)and(baa+n==_aa)then __a=false;b_a:updateDraw()
local daa=b_a:sendEvent("mouse_up",b_a,"mouse_up",c_a,d_a,_aa)if(daa==false)then return daa end;return true end end end end end end end,dragHandler=function(b_a,c_a,d_a,_aa)if
(_c.dragHandler(b_a,c_a,d_a,_aa))then __a=true end end,scrollHandler=function(b_a,c_a,d_a,_aa)
if
(__a)then local aaa,baa=b_a:getAbsolutePosition()if
(d_a>=aaa)and(d_a<=aaa+_d)and(_aa>=baa)and(_aa<=baa+ad)then
b_a:setFocus()end end
if(__a)and(b_a:isFocused())then
local aaa,baa=b_a:getAbsolutePosition()if
(d_a<aaa)or(d_a>aaa+_d)or(_aa<baa)or(_aa>baa+ad)then return false end;if(#b_a:getAll()<=ad)then return
false end;local caa=b_a:getAll()dc=dc+c_a
if(dc<0)then dc=0 end
if(c_a==1)then if(#caa>ad)then if(dc>#caa-ad)then dc=#caa-ad end else
dc=math.min(#caa-1,0)end end
local daa=b_a:sendEvent("mouse_scroll",b_a,"mouse_scroll",c_a,d_a,_aa)if(daa==false)then return daa end;b_a:updateDraw()return true end end,draw=function(b_a)
_c.draw(b_a)b_a:setDrawState("list",false)
b_a:addDraw("dropdown",function()
local c_a,d_a=b_a:getPosition()local _aa,aaa=b_a:getSize()local baa=b_a:getValue()
local caa=b_a:getAll()local daa,_ba=b_a:getBackground(),b_a:getForeground()
local aba=ab.getTextHorizontalAlign((
baa~=nil and baa.text or""),_aa,cc):sub(1,
_aa-1).. (__a and dd or cd)
b_a:addBlit(1,1,aba,bb[_ba]:rep(#aba),bb[daa]:rep(#aba))
if(__a)then b_a:addTextBox(1,2,_d,ad," ")
b_a:addBackgroundBox(1,2,_d,ad,daa)b_a:addForegroundBox(1,2,_d,ad,_ba)
for n=1,ad do
if(caa[n+dc]~=nil)then local bba=ab.getTextHorizontalAlign(caa[
n+dc].text,_d,cc)
if(
caa[n+dc]==baa)then
if(bc)then local cba,dba=b_a:getSelectionColor()
b_a:addBlit(1,n+1,bba,bb[dba]:rep(
#bba),bb[cba]:rep(#bba))else
b_a:addBlit(1,n+1,bba,bb[caa[n+dc].fgCol]:rep(#bba),bb[caa[n+dc].bgCol]:rep(
#bba))end else
b_a:addBlit(1,n+1,bba,bb[caa[n+dc].fgCol]:rep(#bba),bb[caa[n+dc].bgCol]:rep(
#bba))end end end end end)end}a_a.__index=a_a;return setmetatable(a_a,_c)end end
aa["objects"]["Flexbox"]=function(...)
local function ab(bb,cb)local db=0;local _c=0;local ac=0;local bc,cc=bb:getSize()
local dc={getFlexGrow=function(_d)return db end,setFlexGrow=function(_d,ad)
db=ad;return _d end,getFlexShrink=function(_d)return _c end,setFlexShrink=function(_d,ad)_c=ad;return _d end,getFlexBasis=function(_d)return ac end,setFlexBasis=function(_d,ad)
ac=ad;return _d end,getSize=function(_d)return bc,cc end,getWidth=function(_d)return bc end,getHeight=function(_d)return cc end,setSize=function(_d,ad,bd,cd,dd)
bb.setSize(_d,ad,bd,cd)if not dd then bc,cc=bb:getSize()end;return _d end}dc.__index=dc;return setmetatable(dc,bb)end
return
function(bb,cb)
local db=cb.getObject("ScrollableFrame")(bb,cb)local _c="Flexbox"local ac="row"local bc=1;local cc="flex-start"local dc="nowrap"local _d={}local ad={}
local bd=false
local cd=ab({getHeight=function(d_a)return 0 end,getWidth=function(d_a)return 0 end,getPosition=function(d_a)return 0,0 end,getSize=function(d_a)return 0,0 end,isType=function(d_a)return
false end,getType=function(d_a)return"lineBreakFakeObject"end,setPosition=function(d_a)end,setSize=function(d_a)end})
cd:setFlexBasis(0):setFlexGrow(0):setFlexShrink(0)
local function dd(d_a)
if(dc=="nowrap")then ad={}local _aa=1;local aaa=1;local baa=1
for caa,daa in pairs(_d)do if(ad[_aa]==nil)then
ad[_aa]={offset=1}end
local _ba=ac=="row"and daa:getHeight()or daa:getWidth()if _ba>aaa then aaa=_ba end
if(daa==cd)then baa=baa+aaa+bc;aaa=1;_aa=_aa+1
ad[_aa]={offset=baa}else table.insert(ad[_aa],daa)end end elseif(dc=="wrap")then ad={}local _aa=1;local aaa=1;local baa=ac=="row"and d_a:getWidth()or
d_a:getHeight()local caa=0;local daa=1
for _ba,aba in pairs(_d)do if(
ad[daa]==nil)then ad[daa]={offset=1}end
if aba==cd then
aaa=aaa+_aa+bc;caa=0;_aa=1;daa=daa+1;ad[daa]={offset=aaa}else local bba=
ac=="row"and aba:getWidth()or aba:getHeight()
if
(bba+caa<=baa)then table.insert(ad[daa],aba)caa=caa+bba+bc else
aaa=aaa+_aa+bc
_aa=ac=="row"and aba:getHeight()or aba:getWidth()daa=daa+1;caa=bba+bc;ad[daa]={offset=aaa,aba}end
local cba=ac=="row"and aba:getHeight()or aba:getWidth()if cba>_aa then _aa=cba end end end end end
local function __a(d_a,_aa)local aaa,baa=d_a:getSize()local caa=0;local daa=0;local _ba=0
for cba,dba in ipairs(_aa)do caa=caa+
dba:getFlexGrow()daa=daa+dba:getFlexShrink()_ba=_ba+
dba:getFlexBasis()end;local aba=aaa-_ba- (bc* (#_aa-1))local bba=1
for cba,dba in ipairs(_aa)do
if(dba~=cd)then
local _ca;local aca=dba:getFlexGrow()local bca=dba:getFlexShrink()
local cca=
dba:getFlexBasis()~=0 and dba:getFlexBasis()or dba:getWidth()if caa>0 then _ca=cca+aca/caa*aba else _ca=cca end;if aba<0 and
daa>0 then _ca=cca+bca/daa*aba end;dba:setPosition(bba,
_aa.offset or 1)
dba:setSize(_ca,dba:getHeight(),false,true)bba=bba+_ca+bc end end
if cc=="flex-end"then local cba=bba-bc;local dba=aaa-cba+1
for _ca,aca in ipairs(_aa)do
local bca,cca=aca:getPosition()aca:setPosition(bca+dba,cca)end elseif cc=="center"then local cba=bba-bc;local dba=(aaa-cba)/2 +1
for _ca,aca in ipairs(_aa)do
local bca,cca=aca:getPosition()aca:setPosition(bca+dba,cca)end elseif cc=="space-between"then local cba=bba-bc
local dba=(aaa-cba)/ (#_aa-1)+1
for _ca,aca in ipairs(_aa)do if _ca>1 then local bca,cca=aca:getPosition()
aca:setPosition(bca+dba* (_ca-1),cca)end end elseif cc=="space-around"then local cba=bba-bc;local dba=(aaa-cba)/#_aa
for _ca,aca in ipairs(_aa)do
local bca,cca=aca:getPosition()aca:setPosition(bca+dba*_ca-dba/2,cca)end elseif cc=="space-evenly"then local cba=#_aa+1;local dba=0;for cca,dca in ipairs(_aa)do
dba=dba+dca:getWidth()end;local _ca=aaa-dba
local aca=math.floor(_ca/cba)local bca=_ca-aca*cba;bba=aca+ (bca>0 and 1 or 0)bca=bca>
0 and bca-1 or 0
for cca,dca in ipairs(_aa)do
dca:setPosition(bba,1)
bba=bba+dca:getWidth()+aca+ (bca>0 and 1 or 0)bca=bca>0 and bca-1 or 0 end end end
local function a_a(d_a,_aa)local aaa,baa=d_a:getSize()local caa=0;local daa=0;local _ba=0
for cba,dba in ipairs(_aa)do caa=caa+
dba:getFlexGrow()daa=daa+dba:getFlexShrink()_ba=_ba+
dba:getFlexBasis()end;local aba=baa-_ba- (bc* (#_aa-1))local bba=1
for cba,dba in ipairs(_aa)do
if(dba~=cd)then
local _ca;local aca=dba:getFlexGrow()local bca=dba:getFlexShrink()
local cca=
dba:getFlexBasis()~=0 and dba:getFlexBasis()or dba:getHeight()if caa>0 then _ca=cca+aca/caa*aba else _ca=cca end;if aba<0 and
daa>0 then _ca=cca+bca/daa*aba end
dba:setPosition(_aa.offset,bba)dba:setSize(dba:getWidth(),_ca,false,true)bba=
bba+_ca+bc end end
if cc=="flex-end"then local cba=bba-bc;local dba=baa-cba+1
for _ca,aca in ipairs(_aa)do
local bca,cca=aca:getPosition()aca:setPosition(bca,cca+dba)end elseif cc=="center"then local cba=bba-bc;local dba=(baa-cba)/2
for _ca,aca in ipairs(_aa)do
local bca,cca=aca:getPosition()aca:setPosition(bca,cca+dba)end elseif cc=="space-between"then local cba=bba-bc
local dba=(baa-cba)/ (#_aa-1)+1
for _ca,aca in ipairs(_aa)do if _ca>1 then local bca,cca=aca:getPosition()
aca:setPosition(bca,cca+dba* (_ca-1))end end elseif cc=="space-around"then local cba=bba-bc;local dba=(baa-cba)/#_aa
for _ca,aca in ipairs(_aa)do
local bca,cca=aca:getPosition()aca:setPosition(bca,cca+dba*_ca-dba/2)end elseif cc=="space-evenly"then local cba=#_aa+1;local dba=0;for cca,dca in ipairs(_aa)do
dba=dba+dca:getHeight()end;local _ca=baa-dba
local aca=math.floor(_ca/cba)local bca=_ca-aca*cba;bba=aca+ (bca>0 and 1 or 0)bca=bca>
0 and bca-1 or 0
for cca,dca in ipairs(_aa)do
local _da,ada=dca:getPosition()dca:setPosition(_da,bba)bba=
bba+dca:getHeight()+aca+ (bca>0 and 1 or 0)bca=bca>0 and
bca-1 or 0 end end end
local function b_a(d_a)dd(d_a)
if ac=="row"then for _aa,aaa in pairs(ad)do __a(d_a,aaa)end else for _aa,aaa in pairs(ad)do
a_a(d_a,aaa)end end;bd=false end
local c_a={getType=function()return _c end,isType=function(d_a,_aa)return
_c==_aa or db.isType~=nil and db.isType(_aa)or false end,setJustifyContent=function(d_a,_aa)
cc=_aa;bd=true;d_a:updateDraw()return d_a end,getJustifyContent=function(d_a)return cc end,setDirection=function(d_a,_aa)
ac=_aa;bd=true;d_a:updateDraw()return d_a end,getDirection=function(d_a)return ac end,setSpacing=function(d_a,_aa)
bc=_aa;bd=true;d_a:updateDraw()return d_a end,getSpacing=function(d_a)return bc end,setWrap=function(d_a,_aa)
dc=_aa;bd=true;d_a:updateDraw()return d_a end,getWrap=function(d_a)return dc end,updateLayout=function(d_a)
bd=true;d_a:updateDraw()end,addBreak=function(d_a)table.insert(_d,cd)
bd=true;d_a:updateDraw()return d_a end,customEventHandler=function(d_a,_aa,...)
db.customEventHandler(d_a,_aa,...)if _aa=="basalt_FrameResize"then bd=true end end,draw=function(d_a)
db.draw(d_a)
d_a:addDraw("flexboxDraw",function()if bd then b_a(d_a)end end,1)end}
for d_a,_aa in pairs(cb.getObjects())do
c_a["add"..d_a]=function(aaa,baa)
local caa=db["add"..d_a](aaa,baa)local daa=ab(caa,cb)table.insert(_d,daa)bd=true;return daa end end;c_a.__index=c_a;return setmetatable(c_a,db)end end
aa["objects"]["Label"]=function(...)local ab=da("utils")local bb=ab.wrapText
local cb=ab.writeWrappedText;local db=da("tHex")
return
function(_c,ac)
local bc=ac.getObject("VisualObject")(_c,ac)local cc="Label"bc:setZIndex(3)bc:setSize(5,1)
bc:setBackground(false)local dc=true;local _d,ad="Label","left"
local bd={getType=function(cd)return cc end,getBase=function(cd)return bc end,setText=function(cd,dd)
_d=tostring(dd)
if(dc)then local __a=bb(_d,#_d)local a_a,b_a=1,1;for c_a,d_a in pairs(__a)do b_a=b_a+1
a_a=math.max(a_a,d_a:len())end;cd:setSize(a_a,b_a)dc=true end;cd:updateDraw()return cd end,getAutoSize=function(cd)return
dc end,setAutoSize=function(cd,dd)dc=dd;return cd end,getText=function(cd)return _d end,setSize=function(cd,dd,__a)
bc.setSize(cd,dd,__a)dc=false;return cd end,getTextAlign=function(cd)return ad end,setTextAlign=function(cd,dd)ad=dd or ad;return
cd end,draw=function(cd)bc.draw(cd)
cd:addDraw("label",function()local dd,__a=cd:getSize()
local a_a=


ad=="center"and math.floor(dd/2 -_d:len()/2 +0.5)or ad=="right"and dd- (_d:len()-1)or 1;cb(cd,a_a,1,_d,dd+1,__a)end)end,init=function(cd)
bc.init(cd)local dd=cd:getParent()
cd:setForeground(dd:getForeground())end}bd.__index=bd;return setmetatable(bd,bc)end end
aa["objects"]["Input"]=function(...)local ab=da("utils")local bb=da("tHex")
return
function(cb,db)
local _c=db.getObject("ChangeableObject")(cb,db)local ac="Input"local bc="text"local cc=0;_c:setZIndex(5)_c:setValue("")
_c:setSize(12,1)local dc=1;local _d=1;local ad=""local bd=colors.black;local cd=colors.lightGray;local dd=ad
local __a=false
local a_a={load=function(b_a)b_a:listenEvent("mouse_click")
b_a:listenEvent("key")b_a:listenEvent("char")
b_a:listenEvent("other_event")b_a:listenEvent("mouse_drag")end,getType=function(b_a)return
ac end,isType=function(b_a,c_a)return
ac==c_a or _c.isType~=nil and _c.isType(c_a)or false end,setDefaultFG=function(b_a,c_a)return b_a:setDefaultText(b_a,ad,c_a,
nil)end,setDefaultBG=function(b_a,c_a)return b_a:setDefaultText(b_a,ad,
nil,c_a)end,setDefaultText=function(b_a,c_a,d_a,_aa)
ad=c_a;cd=d_a or cd;bd=_aa or bd;if(b_a:isFocused())then dd=""else dd=ad end
b_a:updateDraw()return b_a end,getDefaultText=function(b_a)return ad,cd,
bd end,setOffset=function(b_a,c_a)_d=c_a;b_a:updateDraw()return b_a end,getOffset=function(b_a)return
_d end,setTextOffset=function(b_a,c_a)dc=c_a;b_a:updateDraw()return b_a end,getTextOffset=function(b_a)return
dc end,setInputType=function(b_a,c_a)bc=c_a;b_a:updateDraw()return b_a end,getInputType=function(b_a)return
bc end,setValue=function(b_a,c_a)_c.setValue(b_a,tostring(c_a))
if not(__a)then dc=
tostring(c_a):len()+1
_d=math.max(1,dc-b_a:getWidth()+1)
if(b_a:isFocused())then local d_a=b_a:getParent()
local _aa,aaa=b_a:getPosition()
d_a:setCursor(true,_aa+dc-_d,aaa+math.floor(b_a:getHeight()/2),b_a:getForeground())end end;b_a:updateDraw()return b_a end,getValue=function(b_a)
local c_a=_c.getValue(b_a)
return bc=="number"and tonumber(c_a)or c_a end,setInputLimit=function(b_a,c_a)
cc=tonumber(c_a)or cc;b_a:updateDraw()return b_a end,getInputLimit=function(b_a)return cc end,getFocusHandler=function(b_a)
_c.getFocusHandler(b_a)local c_a=b_a:getParent()
if(c_a~=nil)then local d_a,_aa=b_a:getPosition()dd=""if(ad~=
"")then b_a:updateDraw()end
c_a:setCursor(true,d_a+dc-_d,_aa+math.max(math.ceil(
b_a:getHeight()/2 -1,1)),b_a:getForeground())end end,loseFocusHandler=function(b_a)
_c.loseFocusHandler(b_a)local c_a=b_a:getParent()dd=ad
if(ad~="")then b_a:updateDraw()end;c_a:setCursor(false)end,keyHandler=function(b_a,c_a)
if
(_c.keyHandler(b_a,c_a))then local d_a,_aa=b_a:getSize()local aaa=b_a:getParent()__a=true
if
(c_a==keys.backspace)then local _ba=tostring(_c.getValue())
if(dc>1)then b_a:setValue(_ba:sub(1,dc-2)..
_ba:sub(dc,_ba:len()))dc=math.max(
dc-1,1)if(dc<_d)then _d=math.max(_d-1,1)end end end
if(c_a==keys.enter)then aaa:clearFocusedChild(b_a)end
if(c_a==keys.right)then
local _ba=tostring(_c.getValue()):len()dc=dc+1;if(dc>_ba)then dc=_ba+1 end;dc=math.max(dc,1)if(dc<_d)or
(dc>=d_a+_d)then _d=dc-d_a+1 end;_d=math.max(_d,1)end;if(c_a==keys.left)then dc=dc-1;if(dc>=1)then
if(dc<_d)or(dc>=d_a+_d)then _d=dc end end;dc=math.max(dc,1)
_d=math.max(_d,1)end
local baa,caa=b_a:getPosition()local daa=tostring(_c.getValue())b_a:updateDraw()
__a=false;return true end end,charHandler=function(b_a,c_a)
if
(_c.charHandler(b_a,c_a))then __a=true;local d_a,_aa=b_a:getSize()local aaa=_c.getValue()
if(
aaa:len()<cc or cc<=0)then
if(bc=="number")then local _ba=aaa
if
(dc==1 and c_a=="-")or(c_a==".")or(tonumber(c_a)~=nil)then
b_a:setValue(aaa:sub(1,dc-1)..
c_a..aaa:sub(dc,aaa:len()))dc=dc+1;if(c_a==".")or(c_a=="-")and(#aaa>0)then
if(
tonumber(_c.getValue())==nil)then b_a:setValue(_ba)dc=dc-1 end end end else
b_a:setValue(aaa:sub(1,dc-1)..c_a..aaa:sub(dc,aaa:len()))dc=dc+1 end;if(dc>=d_a+_d)then _d=_d+1 end end;local baa,caa=b_a:getPosition()
local daa=tostring(_c.getValue())__a=false;b_a:updateDraw()return true end end,mouseHandler=function(b_a,c_a,d_a,_aa)
if
(_c.mouseHandler(b_a,c_a,d_a,_aa))then local aaa=b_a:getParent()local baa,caa=b_a:getPosition()
local daa,_ba=b_a:getAbsolutePosition(baa,caa)local aba,bba=b_a:getSize()dc=d_a-daa+_d;local cba=_c.getValue()if(dc>
cba:len())then dc=cba:len()+1 end;if(dc<_d)then _d=dc-1
if(_d<1)then _d=1 end end
aaa:setCursor(true,baa+dc-_d,caa+
math.max(math.ceil(bba/2 -1,1)),b_a:getForeground())return true end end,dragHandler=function(b_a,c_a,d_a,_aa,aaa,baa)
if
(b_a:isFocused())then if(b_a:isCoordsInObject(d_a,_aa))then
if(_c.dragHandler(b_a,c_a,d_a,_aa,aaa,baa))then return true end end
local caa=b_a:getParent()caa:clearFocusedChild()end end,draw=function(b_a)
_c.draw(b_a)
b_a:addDraw("input",function()local c_a=b_a:getParent()local d_a,_aa=b_a:getPosition()
local aaa,baa=b_a:getSize()local caa=ab.getTextVerticalAlign(baa,textVerticalAlign)
local daa=tostring(_c.getValue())local _ba=b_a:getBackground()local aba=b_a:getForeground()local bba;if(
daa:len()<=0)then bba=dd;_ba=bd or _ba;aba=cd or aba end
bba=dd;if(daa~="")then bba=daa end;bba=bba:sub(_d,aaa+_d-1)local cba=aaa-
bba:len()if(cba<0)then cba=0 end
if
(bc=="password")and(daa~="")then bba=string.rep("*",bba:len())end;bba=bba..string.rep(" ",cba)
b_a:addBlit(1,caa,bba,bb[aba]:rep(bba:len()),bb[_ba]:rep(bba:len()))if(b_a:isFocused())then
c_a:setCursor(true,d_a+dc-_d,_aa+
math.floor(b_a:getHeight()/2),b_a:getForeground())end end)end}a_a.__index=a_a;return setmetatable(a_a,_c)end end
aa["objects"]["Menubar"]=function(...)local ab=da("utils")local bb=da("tHex")
return
function(cb,db)
local _c=db.getObject("List")(cb,db)local ac="Menubar"local bc={}_c:setSize(30,1)_c:setZIndex(5)local cc=0
local dc,_d=1,1;local ad=true
local function bd()local cd=0;local dd=_c:getWidth()local __a=_c:getAll()for n=1,#__a do cd=cd+
__a[n].text:len()+dc*2 end;return
math.max(cd-dd,0)end
bc={init=function(cd)local dd=cd:getParent()cd:listenEvent("mouse_click")
cd:listenEvent("mouse_drag")cd:listenEvent("mouse_scroll")return _c.init(cd)end,getType=function(cd)return
ac end,getBase=function(cd)return _c end,setSpace=function(cd,dd)dc=dd or dc;cd:updateDraw()
return cd end,getSpace=function(cd)return dc end,setScrollable=function(cd,dd)ad=dd
if(dd==nil)then ad=true end;return cd end,getScrollable=function(cd)return ad end,mouseHandler=function(cd,dd,__a,a_a)
if
(_c:getBase().mouseHandler(cd,dd,__a,a_a))then local b_a,c_a=cd:getAbsolutePosition()local d_a,_aa=cd:getSize()local aaa=0
local baa=cd:getAll()
for n=1,#baa do
if(baa[n]~=nil)then
if
(b_a+aaa<=__a+cc)and(
b_a+aaa+baa[n].text:len()+ (dc*2)>__a+cc)and(c_a==a_a)then
cd:setValue(baa[n])cd:sendEvent(event,cd,event,0,__a,a_a,baa[n])end;aaa=aaa+baa[n].text:len()+dc*2 end end;cd:updateDraw()return true end end,scrollHandler=function(cd,dd,__a,a_a)
if
(_c:getBase().scrollHandler(cd,dd,__a,a_a))then if(ad)then cc=cc+dd;if(cc<0)then cc=0 end;local b_a=bd()if(cc>b_a)then cc=b_a end
cd:updateDraw()end;return true end;return false end,draw=function(cd)
_c.draw(cd)
cd:addDraw("list",function()local dd=cd:getParent()local __a,a_a=cd:getSize()local b_a=""local c_a=""
local d_a=""local _aa,aaa=cd:getSelectionColor()
for baa,caa in pairs(cd:getAll())do
local daa=
(" "):rep(dc)..caa.text.. (" "):rep(dc)b_a=b_a..daa
if(caa==cd:getValue())then c_a=c_a..
bb[_aa or caa.bgCol or
cd:getBackground()]:rep(daa:len())d_a=d_a..
bb[aaa or
caa.FgCol or cd:getForeground()]:rep(daa:len())else c_a=c_a..
bb[caa.bgCol or
cd:getBackground()]:rep(daa:len())d_a=d_a..
bb[caa.FgCol or
cd:getForeground()]:rep(daa:len())end end
cd:addBlit(1,1,b_a:sub(cc+1,__a+cc),d_a:sub(cc+1,__a+cc),c_a:sub(cc+1,__a+cc))end)end}bc.__index=bc;return setmetatable(bc,_c)end end
aa["objects"]["Pane"]=function(...)
return
function(ab,bb)
local cb=bb.getObject("VisualObject")(ab,bb)local db="Pane"cb:setSize(25,10)
local _c={getType=function(ac)return db end}_c.__index=_c;return setmetatable(_c,cb)end end
aa["objects"]["Slider"]=function(...)local ab=da("tHex")
return
function(bb,cb)
local db=cb.getObject("ChangeableObject")(bb,cb)local _c="Slider"db:setSize(12,1)db:setValue(1)
db:setBackground(false,"\140",colors.black)local ac="horizontal"local bc=" "local cc=colors.black;local dc=colors.gray;local _d=12;local ad=1
local bd=1
local function cd(__a,a_a,b_a,c_a)local d_a,_aa=__a:getPosition()local aaa,baa=__a:getSize()local caa=
ac=="vertical"and baa or aaa
for i=0,caa do
if

(
(ac=="vertical"and _aa+i==c_a)or(ac=="horizontal"and d_a+i==b_a))and(d_a<=b_a)and(d_a+aaa>b_a)and(_aa<=c_a)and
(_aa+baa>c_a)then ad=math.min(i+1,caa- (#
bc+bd-2))
__a:setValue(_d/caa*ad)__a:updateDraw()end end end
local dd={getType=function(__a)return _c end,load=function(__a)__a:listenEvent("mouse_click")
__a:listenEvent("mouse_drag")__a:listenEvent("mouse_scroll")end,setSymbol=function(__a,a_a)
bc=a_a:sub(1,1)__a:updateDraw()return __a end,getSymbol=function(__a)return bc end,setIndex=function(__a,a_a)
ad=a_a;if(ad<1)then ad=1 end;local b_a,c_a=__a:getSize()
ad=math.min(ad,(
ac=="vertical"and c_a or b_a)- (bd-1))
__a:setValue(_d/ (ac=="vertical"and c_a or b_a)*ad)__a:updateDraw()return __a end,getIndex=function(__a)return
ad end,setMaxValue=function(__a,a_a)_d=a_a;return __a end,getMaxValue=function(__a)return _d end,setSymbolColor=function(__a,a_a)
symbolColor=a_a;__a:updateDraw()return __a end,getSymbolColor=function(__a)
return symbolColor end,setBarType=function(__a,a_a)ac=a_a:lower()__a:updateDraw()return __a end,getBarType=function(__a)return
ac end,mouseHandler=function(__a,a_a,b_a,c_a)if(db.mouseHandler(__a,a_a,b_a,c_a))then cd(__a,a_a,b_a,c_a)return
true end;return false end,dragHandler=function(__a,a_a,b_a,c_a)if
(db.dragHandler(__a,a_a,b_a,c_a))then cd(__a,a_a,b_a,c_a)return true end
return false end,scrollHandler=function(__a,a_a,b_a,c_a)
if
(db.scrollHandler(__a,a_a,b_a,c_a))then local d_a,_aa=__a:getSize()ad=ad+a_a;if(ad<1)then ad=1 end
ad=math.min(ad,(
ac=="vertical"and _aa or d_a)- (bd-1))
__a:setValue(_d/ (ac=="vertical"and _aa or d_a)*ad)__a:updateDraw()return true end;return false end,draw=function(__a)
db.draw(__a)
__a:addDraw("slider",function()local a_a,b_a=__a:getSize()
local c_a,d_a=__a:getBackground(),__a:getForeground()
if(ac=="horizontal")then __a:addText(ad,oby,bc:rep(bd))
if(dc~=false)then __a:addBG(ad,1,ab[dc]:rep(
#bc*bd))end;if(cc~=false)then
__a:addFG(ad,1,ab[cc]:rep(#bc*bd))end end
if(ac=="vertical")then
for n=0,b_a-1 do
if(ad==n+1)then for curIndexOffset=0,math.min(bd-1,b_a)do
__a:addBlit(1,1 +n+curIndexOffset,bc,ab[symbolColor],ab[symbolColor])end else if(n+1 <ad)or(n+1 >
ad-1 +bd)then
__a:addBlit(1,1 +n,bgSymbol,ab[d_a],ab[c_a])end end end end end)end}dd.__index=dd;return setmetatable(dd,db)end end
aa["objects"]["MovableFrame"]=function(...)
local ab,bb,cb,db=math.max,math.min,string.sub,string.rep
return
function(_c,ac)local bc=ac.getObject("Frame")(_c,ac)local cc="MovableFrame"
local dc;local _d,ad,bd=0,0,false;local cd={{x1=1,x2="width",y1=1,y2=1}}
local dd={getType=function()return cc end,setDraggingMap=function(__a,a_a)
cd=a_a;return __a end,getDraggingMap=function(__a)return cd end,isType=function(__a,a_a)
return cc==a_a or(bc.isType~=nil and
bc.isType(a_a))or false end,getBase=function(__a)return bc end,load=function(__a)
bc.load(__a)__a:listenEvent("mouse_click")
__a:listenEvent("mouse_up")__a:listenEvent("mouse_drag")end,removeChildren=function(__a)
bc.removeChildren(__a)__a:listenEvent("mouse_click")
__a:listenEvent("mouse_up")__a:listenEvent("mouse_drag")end,dragHandler=function(__a,a_a,b_a,c_a)
if
(bc.dragHandler(__a,a_a,b_a,c_a))then
if(bd)then local d_a,_aa=dc:getOffset()
d_a=d_a<0 and math.abs(d_a)or-d_a;_aa=_aa<0 and math.abs(_aa)or-_aa;local aaa=1
local baa=1;aaa,baa=dc:getAbsolutePosition()
__a:setPosition(b_a+_d- (aaa-1)+d_a,
c_a+ad- (baa-1)+_aa)__a:updateDraw()end;return true end end,mouseHandler=function(__a,a_a,b_a,c_a,...)
if
(bc.mouseHandler(__a,a_a,b_a,c_a,...))then dc:setImportant(__a)local d_a,_aa=__a:getAbsolutePosition()
local aaa,baa=__a:getSize()
for caa,daa in pairs(cd)do local _ba,aba=daa.x1 =="width"and aaa or daa.x1,daa.x2 =="width"and
aaa or daa.x2;local bba,cba=
daa.y1 =="height"and baa or daa.y1,
daa.y2 =="height"and baa or daa.y2
if
(b_a>=
d_a+_ba-1)and(b_a<=d_a+aba-1)and(c_a>=_aa+bba-1)and(c_a<=_aa+cba-1)then bd=true
_d=d_a-b_a;ad=_aa-c_a;return true end end;return true end end,mouseUpHandler=function(__a,...)
bd=false;return bc.mouseUpHandler(__a,...)end,setParent=function(__a,a_a,...)
bc.setParent(__a,a_a,...)dc=a_a;return __a end}dd.__index=dd;return setmetatable(dd,bc)end end
aa["objects"]["Radio"]=function(...)local ab=da("utils")local bb=da("tHex")
return
function(cb,db)
local _c=db.getObject("List")(cb,db)local ac="Radio"_c:setSize(1,1)_c:setZIndex(5)local bc={}
local cc=colors.black;local dc=colors.green;local _d=colors.black;local ad=colors.red;local bd=true;local cd="\7"
local dd="left"
local __a={getType=function(a_a)return ac end,addItem=function(a_a,b_a,c_a,d_a,_aa,aaa,...)_c.addItem(a_a,b_a,_aa,aaa,...)table.insert(bc,{x=c_a or 1,y=
d_a or#bc*2})
return a_a end,removeItem=function(a_a,b_a)
_c.removeItem(a_a,b_a)table.remove(bc,b_a)return a_a end,clear=function(a_a)
_c.clear(a_a)bc={}return a_a end,editItem=function(a_a,b_a,c_a,d_a,_aa,aaa,baa,...)
_c.editItem(a_a,b_a,c_a,aaa,baa,...)table.remove(bc,b_a)
table.insert(bc,b_a,{x=d_a or 1,y=_aa or 1})return a_a end,setBoxSelectionColor=function(a_a,b_a,c_a)
cc=b_a;dc=c_a;return a_a end,setBoxSelectionBG=function(a_a,b_a)
return a_a:setBoxSelectionColor(b_a,dc)end,setBoxSelectionFG=function(a_a,b_a)
return a_a:setBoxSelectionColor(cc,b_a)end,getBoxSelectionColor=function(a_a)return cc,dc end,getBoxSelectionBG=function(a_a)return cc end,getBoxSelectionFG=function(a_a)
return dc end,setBoxDefaultColor=function(a_a,b_a,c_a)_d=b_a;ad=c_a;return a_a end,setBoxDefaultBG=function(a_a,b_a)return
a_a:setBoxDefaultColor(b_a,ad)end,setBoxDefaultFG=function(a_a,b_a)return
a_a:setBoxDefaultColor(_d,b_a)end,getBoxDefaultColor=function(a_a)return _d,ad end,getBoxDefaultBG=function(a_a)return _d end,getBoxDefaultFG=function(a_a)return
ad end,mouseHandler=function(a_a,b_a,c_a,d_a,...)
if(#bc>0)then local _aa,aaa=a_a:getAbsolutePosition()
local baa=a_a:getAll()
for caa,daa in pairs(baa)do
if

(_aa+bc[caa].x-1 <=c_a)and(_aa+bc[caa].x-1 +
daa.text:len()+1 >=c_a)and(aaa+bc[caa].y-1 ==d_a)then a_a:setValue(daa)
local _ba=a_a:sendEvent("mouse_click",a_a,"mouse_click",b_a,c_a,d_a,...)a_a:updateDraw()if(_ba==false)then return _ba end;return true end end end end,draw=function(a_a)
a_a:addDraw("radio",function()
local b_a,c_a=a_a:getSelectionColor()local d_a=a_a:getAll()
for _aa,aaa in pairs(d_a)do
if(aaa==a_a:getValue())then
a_a:addBlit(bc[_aa].x,bc[_aa].y,cd,bb[dc],bb[cc])
a_a:addBlit(bc[_aa].x+2,bc[_aa].y,aaa.text,bb[c_a]:rep(#aaa.text),bb[b_a]:rep(
#aaa.text))else
a_a:addBackgroundBox(bc[_aa].x,bc[_aa].y,1,1,_d or colors.black)
a_a:addBlit(bc[_aa].x+2,bc[_aa].y,aaa.text,bb[aaa.fgCol]:rep(#aaa.text),bb[aaa.bgCol]:rep(
#aaa.text))end end;return true end)end}__a.__index=__a;return setmetatable(__a,_c)end end
aa["objects"]["VisualObject"]=function(...)local ab=da("utils")local bb=da("tHex")
local cb,db,_c=string.sub,string.find,table.insert
return
function(ac,bc)local cc=bc.getObject("Object")(ac,bc)
local dc="VisualObject"local _d,ad,bd,cd,dd=true,false,false,false,false;local __a=1;local a_a,b_a,c_a,d_a=1,1,1,1
local _aa,aaa,baa,caa=0,0,0,0;local daa,_ba,aba=colors.black,colors.white,false;local bba;local cba={}local dba={}local _ca={}
local aca={}
local function bca(dca,_da)local ada={}if dca==""then return ada end;_da=_da or" "local bda=1
local cda,dda=db(dca,_da,bda)
while cda do
_c(ada,{x=bda,value=cb(dca,bda,cda-1)})bda=dda+1;cda,dda=db(dca,_da,bda)end;_c(ada,{x=bda,value=cb(dca,bda)})return ada end
local cca={getType=function(dca)return dc end,getBase=function(dca)return cc end,isType=function(dca,_da)
return dc==_da or
cc.isType~=nil and cc.isType(_da)or false end,getBasalt=function(dca)return bc end,show=function(dca)_d=true
dca:updateDraw()return dca end,hide=function(dca)_d=false;dca:updateDraw()return dca end,isVisible=function(dca)return
_d end,setVisible=function(dca,_da)_d=_da or not _d;dca:updateDraw()return dca end,setTransparency=function(dca,_da)aba=
_da~=nil and _da or true;dca:updateDraw()
return dca end,setParent=function(dca,_da,ada)
cc.setParent(dca,_da,ada)bba=_da;return dca end,setFocus=function(dca)if(bba~=nil)then
bba:setFocusedChild(dca)end;return dca end,setZIndex=function(dca,_da)__a=_da
if
(bba~=nil)then bba:updateZIndex(dca,__a)dca:updateDraw()end;return dca end,getZIndex=function(dca)return __a end,updateDraw=function(dca)if(
bba~=nil)then bba:updateDraw()end;return dca end,setPosition=function(dca,_da,ada,bda)
local cda,dda=a_a,b_a
if(type(_da)=="number")then a_a=bda and a_a+_da or _da end
if(type(ada)=="number")then b_a=bda and b_a+ada or ada end;if(bba~=nil)then
bba:customEventHandler("basalt_FrameReposition",dca)end;if(dca:getType()=="Container")then
bba:customEventHandler("basalt_FrameReposition",dca)end;dca:updateDraw()
dca:repositionHandler(cda,dda)return dca end,getX=function(dca)return
a_a end,setX=function(dca,_da)return dca:setPosition(_da,b_a)end,getY=function(dca)return
b_a end,setY=function(dca,_da)return dca:setPosition(a_a,_da)end,getPosition=function(dca)return
a_a,b_a end,setSize=function(dca,_da,ada,bda)local cda,dda=c_a,d_a;if(type(_da)=="number")then c_a=
bda and c_a+_da or _da end;if
(type(ada)=="number")then d_a=bda and d_a+ada or ada end
if
(bba~=nil)then bba:customEventHandler("basalt_FrameResize",dca)if(
dca:getType()=="Container")then
bba:customEventHandler("basalt_FrameResize",dca)end end;dca:resizeHandler(cda,dda)dca:updateDraw()return dca end,getHeight=function(dca)return
d_a end,setHeight=function(dca,_da)return dca:setSize(c_a,_da)end,getWidth=function(dca)return
c_a end,setWidth=function(dca,_da)return dca:setSize(_da,d_a)end,getSize=function(dca)return
c_a,d_a end,setBackground=function(dca,_da)daa=_da;dca:updateDraw()return dca end,getBackground=function(dca)return
daa end,setForeground=function(dca,_da)_ba=_da or false;dca:updateDraw()return dca end,getForeground=function(dca)return
_ba end,getAbsolutePosition=function(dca,_da,ada)if(_da==nil)or(ada==nil)then
_da,ada=dca:getPosition()end
if(bba~=nil)then
local bda,cda=bba:getAbsolutePosition()_da=bda+_da-1;ada=cda+ada-1 end;return _da,ada end,ignoreOffset=function(dca,_da)
ad=_da;if(_da==nil)then ad=true end;return dca end,getIgnoreOffset=function(dca)return ad end,isCoordsInObject=function(dca,_da,ada)
if
(_d)and(dca:isEnabled())then
if(_da==nil)or(ada==nil)then return false end;local bda,cda=dca:getAbsolutePosition()local dda,__b=dca:getSize()if

(bda<=_da)and(bda+dda>_da)and(cda<=ada)and(cda+__b>ada)then return true end end;return false end,onGetFocus=function(dca,...)
for _da,ada in
pairs(table.pack(...))do if(type(ada)=="function")then
dca:registerEvent("get_focus",ada)end end;return dca end,onLoseFocus=function(dca,...)
for _da,ada in
pairs(table.pack(...))do if(type(ada)=="function")then
dca:registerEvent("lose_focus",ada)end end;return dca end,isFocused=function(dca)if(
bba~=nil)then return bba:getFocused()==dca end;return
true end,resizeHandler=function(dca,...)
if(dca:isEnabled())then
local _da=dca:sendEvent("basalt_resize",...)if(_da==false)then return false end end;return true end,repositionHandler=function(dca,...)if
(dca:isEnabled())then local _da=dca:sendEvent("basalt_reposition",...)if(_da==false)then
return false end end;return
true end,onResize=function(dca,...)
for _da,ada in
pairs(table.pack(...))do if(type(ada)=="function")then
dca:registerEvent("basalt_resize",ada)end end;return dca end,onReposition=function(dca,...)
for _da,ada in
pairs(table.pack(...))do if(type(ada)=="function")then
dca:registerEvent("basalt_reposition",ada)end end;return dca end,mouseHandler=function(dca,_da,ada,bda,cda)
if
(dca:isCoordsInObject(ada,bda))then local dda,__b=dca:getAbsolutePosition()
local a_b=dca:sendEvent("mouse_click",_da,ada- (dda-1),
bda- (__b-1),ada,bda,cda)if(a_b==false)then return false end;if(bba~=nil)then
bba:setFocusedChild(dca)end;cd=true;dd=true;_aa,aaa=ada,bda;return true end end,mouseUpHandler=function(dca,_da,ada,bda)
dd=false
if(cd)then local cda,dda=dca:getAbsolutePosition()
local __b=dca:sendEvent("mouse_release",_da,ada- (cda-1),
bda- (dda-1),ada,bda)cd=false end
if(dca:isCoordsInObject(ada,bda))then local cda,dda=dca:getAbsolutePosition()
local __b=dca:sendEvent("mouse_up",_da,
ada- (cda-1),bda- (dda-1),ada,bda)if(__b==false)then return false end;return true end end,dragHandler=function(dca,_da,ada,bda)
if
(dd)then local cda,dda=dca:getAbsolutePosition()
local __b=dca:sendEvent("mouse_drag",_da,ada- (cda-1),bda- (
dda-1),_aa-ada,aaa-bda,ada,bda)_aa,aaa=ada,bda;if(__b==false)then return false end;if(bba~=nil)then
bba:setFocusedChild(dca)end;return true end
if(dca:isCoordsInObject(ada,bda))then local cda,dda=dca:getAbsolutePosition()
_aa,aaa=ada,bda;baa,caa=cda-ada,dda-bda end end,scrollHandler=function(dca,_da,ada,bda)
if
(dca:isCoordsInObject(ada,bda))then local cda,dda=dca:getAbsolutePosition()
local __b=dca:sendEvent("mouse_scroll",_da,ada- (cda-1),
bda- (dda-1))if(__b==false)then return false end;if(bba~=nil)then
bba:setFocusedChild(dca)end;return true end end,hoverHandler=function(dca,_da,ada,bda)
if
(dca:isCoordsInObject(_da,ada))then local cda=dca:sendEvent("mouse_hover",_da,ada,bda)if(cda==false)then return
false end;bd=true;return true end
if(bd)then local cda=dca:sendEvent("mouse_leave",_da,ada,bda)if
(cda==false)then return false end;bd=false end end,keyHandler=function(dca,_da,ada)if
(dca:isEnabled())and(_d)then
if(dca:isFocused())then
local bda=dca:sendEvent("key",_da,ada)if(bda==false)then return false end;return true end end end,keyUpHandler=function(dca,_da)if
(dca:isEnabled())and(_d)then
if(dca:isFocused())then
local ada=dca:sendEvent("key_up",_da)if(ada==false)then return false end;return true end end end,charHandler=function(dca,_da)if
(dca:isEnabled())and(_d)then
if(dca:isFocused())then local ada=dca:sendEvent("char",_da)if(ada==
false)then return false end;return true end end end,getFocusHandler=function(dca)
local _da=dca:sendEvent("get_focus")if(_da~=nil)then return _da end;return true end,loseFocusHandler=function(dca)
dd=false;local _da=dca:sendEvent("lose_focus")
if(_da~=nil)then return _da end;return true end,addDraw=function(dca,_da,ada,bda,cda,dda)
local __b=
(cda==nil or cda==1)and dba or cda==2 and cba or cda==3 and _ca;bda=bda or#__b+1
if(_da~=nil)then for b_b,c_b in pairs(__b)do if(c_b.name==_da)then
table.remove(__b,b_b)break end end
local a_b={name=_da,f=ada,pos=bda,active=
dda~=nil and dda or true}table.insert(__b,bda,a_b)end;dca:updateDraw()return dca end,addPreDraw=function(dca,_da,ada,bda,cda)
dca:addDraw(_da,ada,bda,2)return dca end,addPostDraw=function(dca,_da,ada,bda,cda)
dca:addDraw(_da,ada,bda,3)return dca end,setDrawState=function(dca,_da,ada,bda)
local cda=
(bda==nil or bda==1)and dba or bda==2 and cba or bda==3 and _ca
for dda,__b in pairs(cda)do if(__b.name==_da)then __b.active=ada;break end end;dca:updateDraw()return dca end,getDrawId=function(dca,_da,ada)local bda=

ada==1 and dba or ada==2 and cba or ada==3 and _ca or dba;for cda,dda in pairs(bda)do if(
dda.name==_da)then return cda end end end,addText=function(dca,_da,ada,bda)local cda=
dca:getParent()or dca;local dda,__b=dca:getPosition()if(bba~=nil)then
local b_b,c_b=bba:getOffset()dda=ad and dda or dda-b_b
__b=ad and __b or __b-c_b end
if not(aba)then cda:setText(_da+dda-1,
ada+__b-1,bda)return end;local a_b=bca(bda,"\0")
for b_b,c_b in pairs(a_b)do if
(c_b.value~="")and(c_b.value~="\0")then
cda:setText(_da+c_b.x+dda-2,ada+__b-1,c_b.value)end end end,addBG=function(dca,_da,ada,bda,cda)local dda=
bba or dca;local __b,a_b=dca:getPosition()if(bba~=nil)then
local c_b,d_b=bba:getOffset()__b=ad and __b or __b-c_b
a_b=ad and a_b or a_b-d_b end
if not(aba)then dda:setBG(_da+__b-1,
ada+a_b-1,bda)return end;local b_b=bca(bda)
for c_b,d_b in pairs(b_b)do
if(d_b.value~="")and(d_b.value~=" ")then
if(cda~=
true)then
dda:setText(_da+d_b.x+__b-2,ada+a_b-1,(" "):rep(#d_b.value))
dda:setBG(_da+d_b.x+__b-2,ada+a_b-1,d_b.value)else
table.insert(aca,{x=_da+d_b.x-1,y=ada,bg=d_b.value})dda:setBG(_da+__b-1,ada+a_b-1,fg)end end end end,addFG=function(dca,_da,ada,bda)local cda=
bba or dca;local dda,__b=dca:getPosition()if(bba~=nil)then
local b_b,c_b=bba:getOffset()dda=ad and dda or dda-b_b
__b=ad and __b or __b-c_b end
if not(aba)then cda:setFG(_da+dda-1,
ada+__b-1,bda)return end;local a_b=bca(bda)
for b_b,c_b in pairs(a_b)do if(c_b.value~="")and(c_b.value~=" ")then
cda:setFG(
_da+c_b.x+dda-2,ada+__b-1,c_b.value)end end end,addBlit=function(dca,_da,ada,bda,cda,dda)local __b=
bba or dca;local a_b,b_b=dca:getPosition()if(bba~=nil)then
local aab,bab=bba:getOffset()a_b=ad and a_b or a_b-aab
b_b=ad and b_b or b_b-bab end
if not(aba)then __b:blit(_da+a_b-1,
ada+b_b-1,bda,cda,dda)return end;local c_b=bca(bda,"\0")local d_b=bca(cda)local _ab=bca(dda)
for aab,bab in pairs(c_b)do if
(bab.value~="")or(bab.value~="\0")then
__b:setText(_da+bab.x+a_b-2,ada+b_b-1,bab.value)end end;for aab,bab in pairs(_ab)do
if(bab.value~="")or(bab.value~=" ")then __b:setBG(
_da+bab.x+a_b-2,ada+b_b-1,bab.value)end end;for aab,bab in pairs(d_b)do
if(
bab.value~="")or(bab.value~=" ")then __b:setFG(_da+bab.x+a_b-2,ada+
b_b-1,bab.value)end end end,addTextBox=function(dca,_da,ada,bda,cda,dda)local __b=
bba or dca;local a_b,b_b=dca:getPosition()if(bba~=nil)then
local c_b,d_b=bba:getOffset()a_b=ad and a_b or a_b-c_b
b_b=ad and b_b or b_b-d_b end;__b:drawTextBox(_da+a_b-1,
ada+b_b-1,bda,cda,dda)end,addForegroundBox=function(dca,_da,ada,bda,cda,dda)local __b=
bba or dca;local a_b,b_b=dca:getPosition()if(bba~=nil)then
local c_b,d_b=bba:getOffset()a_b=ad and a_b or a_b-c_b
b_b=ad and b_b or b_b-d_b end;__b:drawForegroundBox(_da+a_b-1,
ada+b_b-1,bda,cda,dda)end,addBackgroundBox=function(dca,_da,ada,bda,cda,dda)local __b=
bba or dca;local a_b,b_b=dca:getPosition()if(bba~=nil)then
local c_b,d_b=bba:getOffset()a_b=ad and a_b or a_b-c_b
b_b=ad and b_b or b_b-d_b end;__b:drawBackgroundBox(_da+a_b-1,
ada+b_b-1,bda,cda,dda)end,render=function(dca)if
(_d)then dca:redraw()end end,redraw=function(dca)for _da,ada in pairs(cba)do if(ada.active)then
ada.f(dca)end end;for _da,ada in pairs(dba)do if(ada.active)then
ada.f(dca)end end;for _da,ada in pairs(_ca)do if(ada.active)then
ada.f(dca)end end;return true end,draw=function(dca)
dca:addDraw("base",function()
local _da,ada=dca:getSize()if(daa~=false)then dca:addTextBox(1,1,_da,ada," ")
dca:addBackgroundBox(1,1,_da,ada,daa)end;if(_ba~=false)then
dca:addForegroundBox(1,1,_da,ada,_ba)end end,1)end}cca.__index=cca;return setmetatable(cca,cc)end end
aa["objects"]["ScrollableFrame"]=function(...)
local ab,bb,cb,db=math.max,math.min,string.sub,string.rep
return
function(_c,ac)local bc=ac.getObject("Frame")(_c,ac)
local cc="ScrollableFrame"local dc;local _d=0;local ad=0;local bd=true
local function cd(b_a)local c_a=0;local d_a=b_a:getChildren()
for _aa,aaa in pairs(d_a)do
if(
aaa.element.getWidth~=nil)and(aaa.element.getX~=nil)then
local baa,caa=aaa.element:getWidth(),aaa.element:getX()local daa=b_a:getWidth()
if
(aaa.element:getType()=="Dropdown")then if(aaa.element:isOpened())then
local _ba=aaa.element:getDropdownSize()
if(_ba+caa-daa>=c_a)then c_a=ab(_ba+caa-daa,0)end end end
if(baa+caa-daa>=c_a)then c_a=ab(baa+caa-daa,0)end end end;return c_a end
local function dd(b_a)local c_a=0;local d_a=b_a:getChildren()
for _aa,aaa in pairs(d_a)do
if
(aaa.element.getHeight~=nil)and(aaa.element.getY~=nil)then
local baa,caa=aaa.element:getHeight(),aaa.element:getY()local daa=b_a:getHeight()
if
(aaa.element:getType()=="Dropdown")then if(aaa.element:isOpened())then
local _ba,aba=aaa.element:getDropdownSize()
if(aba+caa-daa>=c_a)then c_a=ab(aba+caa-daa,0)end end end
if(baa+caa-daa>=c_a)then c_a=ab(baa+caa-daa,0)end end end;return c_a end
local function __a(b_a,c_a)local d_a,_aa=b_a:getOffset()local aaa
if(_d==1)then
aaa=bd and cd(b_a)or ad
b_a:setOffset(bb(aaa,ab(0,d_a+c_a)),_aa)elseif(_d==0)then aaa=bd and dd(b_a)or ad
b_a:setOffset(d_a,bb(aaa,ab(0,_aa+c_a)))end;b_a:updateDraw()end
local a_a={getType=function()return cc end,isType=function(b_a,c_a)return
cc==c_a or bc.isType~=nil and bc.isType(c_a)or false end,setDirection=function(b_a,c_a)_d=
c_a=="horizontal"and 1 or c_a=="vertical"and 0 or
_d;return b_a end,setScrollAmount=function(b_a,c_a)
ad=c_a;bd=false;return b_a end,getBase=function(b_a)return bc end,load=function(b_a)bc.load(b_a)
b_a:listenEvent("mouse_scroll")end,removeChildren=function(b_a)bc.removeChildren(b_a)
b_a:listenEvent("mouse_scroll")end,setParent=function(b_a,c_a,...)bc.setParent(b_a,c_a,...)
dc=c_a;return b_a end,scrollHandler=function(b_a,c_a,d_a,_aa)
if
(bc:getBase().scrollHandler(b_a,c_a,d_a,_aa))then b_a:sortChildren()
for aaa,baa in
ipairs(b_a:getEvents("mouse_scroll"))do
if(baa.element.scrollHandler~=nil)then local caa,daa=0,0;if(b_a.getOffset~=nil)then
caa,daa=b_a:getOffset()end
if(baa.element.getIgnoreOffset())then caa,daa=0,0 end;if(baa.element.scrollHandler(baa.element,c_a,d_a+caa,_aa+daa))then
return true end end end;__a(b_a,c_a,d_a,_aa)b_a:clearFocusedChild()return true end end,draw=function(b_a)
bc.draw(b_a)
b_a:addDraw("scrollableFrame",function()if(bd)then __a(b_a,0)end end,0)end}a_a.__index=a_a;return setmetatable(a_a,bc)end end
aa["objects"]["Scrollbar"]=function(...)local ab=da("tHex")
return
function(bb,cb)
local db=cb.getObject("VisualObject")(bb,cb)local _c="Scrollbar"db:setZIndex(2)db:setSize(1,8)
db:setBackground(colors.lightGray,"\127",colors.gray)local ac="vertical"local bc=" "local cc=colors.black;local dc=colors.black;local _d=3;local ad=1
local bd=1;local cd=true
local function dd()local b_a,c_a=db:getSize()if(cd)then
bd=math.max((ac=="vertical"and c_a or
b_a- (#bc))- (_d-1),1)end end;dd()
local function __a(b_a,c_a,d_a,_aa)local aaa,baa=b_a:getAbsolutePosition()
local caa,daa=b_a:getSize()dd()local _ba=ac=="vertical"and daa or caa
for i=0,_ba do
if

( (
ac=="vertical"and baa+i==_aa)or(ac=="horizontal"and aaa+i==d_a))and(aaa<=d_a)and(aaa+caa>d_a)and(baa<=_aa)and
(baa+daa>_aa)then ad=math.min(i+1,
_ba- (#bc+bd-2))
b_a:scrollbarMoveHandler()b_a:updateDraw()end end end
local a_a={getType=function(b_a)return _c end,load=function(b_a)db.load(b_a)local c_a=b_a:getParent()
b_a:listenEvent("mouse_click")b_a:listenEvent("mouse_up")
b_a:listenEvent("mouse_scroll")b_a:listenEvent("mouse_drag")end,setSymbol=function(b_a,c_a,d_a,_aa)
bc=c_a:sub(1,1)cc=d_a or cc;dc=_aa or dc;dd()b_a:updateDraw()return b_a end,setSymbolBG=function(b_a,c_a)return b_a:setSymbol(bc,c_a,
nil)end,setSymbolFG=function(b_a,c_a)return
b_a:setSymbol(bc,nil,c_a)end,getSymbol=function(b_a)return bc end,getSymbolBG=function(b_a)return cc end,getSymbolFG=function(b_a)return
dc end,setIndex=function(b_a,c_a)ad=c_a;if(ad<1)then ad=1 end;local d_a,_aa=b_a:getSize()dd()
b_a:updateDraw()return b_a end,setScrollAmount=function(b_a,c_a)_d=c_a;dd()
b_a:updateDraw()return b_a end,getScrollAmount=function(b_a)return _d end,getIndex=function(b_a)
local c_a,d_a=b_a:getSize()return
_d> (ac=="vertical"and d_a or c_a)and
math.floor(_d/ (
ac=="vertical"and d_a or c_a)*ad)or ad end,setSymbolSize=function(b_a,c_a)bd=
tonumber(c_a)or 1;cd=c_a~=false and false or true
dd()b_a:updateDraw()return b_a end,getSymbolSize=function(b_a)return
bd end,setBarType=function(b_a,c_a)ac=c_a:lower()dd()b_a:updateDraw()return b_a end,getBarType=function(b_a)return
ac end,mouseHandler=function(b_a,c_a,d_a,_aa,...)if(db.mouseHandler(b_a,c_a,d_a,_aa,...))then
__a(b_a,c_a,d_a,_aa)return true end;return false end,dragHandler=function(b_a,c_a,d_a,_aa)if
(db.dragHandler(b_a,c_a,d_a,_aa))then __a(b_a,c_a,d_a,_aa)return true end;return
false end,setSize=function(b_a,...)
db.setSize(b_a,...)dd()return b_a end,scrollHandler=function(b_a,c_a,d_a,_aa)
if(db.scrollHandler(b_a,c_a,d_a,_aa))then
local aaa,baa=b_a:getSize()dd()ad=ad+c_a;if(ad<1)then ad=1 end
ad=math.min(ad,
(ac=="vertical"and baa or aaa)- (ac=="vertical"and bd-1 or#bc+bd-2))b_a:scrollbarMoveHandler()b_a:updateDraw()end end,onChange=function(b_a,...)
for c_a,d_a in
pairs(table.pack(...))do if(type(d_a)=="function")then
b_a:registerEvent("scrollbar_moved",d_a)end end;return b_a end,scrollbarMoveHandler=function(b_a)
b_a:sendEvent("scrollbar_moved",b_a:getIndex())end,customEventHandler=function(b_a,c_a,...)
db.customEventHandler(b_a,c_a,...)if(c_a=="basalt_FrameResize")then dd()end end,draw=function(b_a)
db.draw(b_a)
b_a:addDraw("scrollbar",function()local c_a=b_a:getParent()local d_a,_aa=b_a:getSize()
local aaa,baa=b_a:getBackground(),b_a:getForeground()
if(ac=="horizontal")then for n=0,_aa-1 do
b_a:addBlit(ad,1 +n,bc:rep(bd),ab[dc]:rep(#bc*bd),ab[cc]:rep(
#bc*bd))end elseif(ac=="vertical")then
for n=0,_aa-1 do
if(ad==n+1)then
for curIndexOffset=0,math.min(
bd-1,_aa)do
b_a:addBlit(1,ad+curIndexOffset,bc:rep(math.max(#bc,d_a)),ab[dc]:rep(math.max(
#bc,d_a)),ab[cc]:rep(math.max(#bc,d_a)))end end end end end)end}a_a.__index=a_a;return setmetatable(a_a,db)end end
aa["objects"]["Thread"]=function(...)
return
function(ab,bb)
local cb=bb.getObject("Object")(ab,bb)local db="Thread"local _c;local ac;local bc=false;local cc
local dc={getType=function(_d)return db end,start=function(_d,ad)if(ad==nil)then
error("Function provided to thread is nil")end;_c=ad;ac=coroutine.create(_c)
bc=true;cc=nil;local bd,cd=coroutine.resume(ac)cc=cd;if not(bd)then
if(cd~="Terminated")then error(
"Thread Error Occurred - "..cd)end end
_d:listenEvent("mouse_click")_d:listenEvent("mouse_up")
_d:listenEvent("mouse_scroll")_d:listenEvent("mouse_drag")_d:listenEvent("key")
_d:listenEvent("key_up")_d:listenEvent("char")
_d:listenEvent("other_event")return _d end,getStatus=function(_d,ad)if(
ac~=nil)then return coroutine.status(ac)end;return nil end,stop=function(_d,ad)
bc=false;_d:listenEvent("mouse_click",false)
_d:listenEvent("mouse_up",false)_d:listenEvent("mouse_scroll",false)
_d:listenEvent("mouse_drag",false)_d:listenEvent("key",false)
_d:listenEvent("key_up",false)_d:listenEvent("char",false)
_d:listenEvent("other_event",false)return _d end,mouseHandler=function(_d,...)
_d:eventHandler("mouse_click",...)end,mouseUpHandler=function(_d,...)_d:eventHandler("mouse_up",...)end,mouseScrollHandler=function(_d,...)
_d:eventHandler("mouse_scroll",...)end,mouseDragHandler=function(_d,...)
_d:eventHandler("mouse_drag",...)end,mouseMoveHandler=function(_d,...)
_d:eventHandler("mouse_move",...)end,keyHandler=function(_d,...)_d:eventHandler("key",...)end,keyUpHandler=function(_d,...)
_d:eventHandler("key_up",...)end,charHandler=function(_d,...)_d:eventHandler("char",...)end,eventHandler=function(_d,ad,...)
cb.eventHandler(_d,ad,...)
if(bc)then
if(coroutine.status(ac)=="suspended")then if(cc~=nil)then
if(ad~=cc)then return end;cc=nil end
local bd,cd=coroutine.resume(ac,ad,...)cc=cd;if not(bd)then if(cd~="Terminated")then
error("Thread Error Occurred - "..cd)end end else
_d:stop()end end end}dc.__index=dc;return setmetatable(dc,cb)end end
aa["objects"]["Object"]=function(...)local ab=da("basaltEvent")
local bb=da("utils")local cb=bb.uuid;local db,_c=table.unpack,string.sub
return
function(ac,bc)ac=ac or cb()
assert(bc~=nil,
"Unable to find basalt instance! ID: "..ac)local cc="Object"local dc,_d=true,false;local ad=ab()local bd={}local cd={}local dd
local __a={init=function(a_a)
if(_d)then return false end;_d=true;return true end,load=function(a_a)end,getType=function(a_a)return cc end,isType=function(a_a,b_a)return cc==
b_a end,getProperty=function(a_a,b_a)
local c_a=a_a["get"..b_a:gsub("^%l",string.upper)]if(c_a~=nil)then return c_a(a_a)end end,setProperty=function(a_a,b_a,...)
local c_a=a_a[
"set"..b_a:gsub("^%l",string.upper)]if(c_a~=nil)then return c_a(a_a,...)end end,getName=function(a_a)return
ac end,getParent=function(a_a)return dd end,setParent=function(a_a,b_a,c_a)if(c_a)then dd=b_a;return a_a end
if(b_a.getType~=
nil and b_a:isType("Container"))then a_a:remove()
b_a:addChild(a_a)if(a_a.show)then a_a:show()end;dd=b_a end;return a_a end,updateEvents=function(a_a)for b_a,c_a in
pairs(cd)do dd:removeEvent(b_a,a_a)
if(c_a)then dd:addEvent(b_a,a_a)end end;return a_a end,listenEvent=function(a_a,b_a,c_a)if(
dd~=nil)then
if(c_a)or(c_a==nil)then cd[b_a]=true;dd:addEvent(b_a,a_a)elseif
(c_a==false)then cd[b_a]=false;dd:removeEvent(b_a,a_a)end end
return a_a end,getZIndex=function(a_a)return
1 end,enable=function(a_a)dc=true;return a_a end,disable=function(a_a)dc=false;return a_a end,isEnabled=function(a_a)return
dc end,remove=function(a_a)if(dd~=nil)then dd:removeChild(a_a)end
a_a:updateDraw()return a_a end,getBaseFrame=function(a_a)if(dd~=nil)then
return dd:getBaseFrame()end;return a_a end,onEvent=function(a_a,...)
for b_a,c_a in
pairs(table.pack(...))do if(type(c_a)=="function")then
a_a:registerEvent("other_event",c_a)end end;return a_a end,getEventSystem=function(a_a)return
ad end,getRegisteredEvents=function(a_a)return bd end,registerEvent=function(a_a,b_a,c_a)
if(dd~=nil)then
if(b_a=="mouse_drag")then
dd:addEvent("mouse_click",a_a)dd:addEvent("mouse_up",a_a)end;dd:addEvent(b_a,a_a)end;ad:registerEvent(b_a,c_a)
if(bd[b_a]==nil)then bd[b_a]={}end;table.insert(bd[b_a],c_a)end,removeEvent=function(a_a,b_a,c_a)if(
ad:getEventCount(b_a)<1)then
if(dd~=nil)then dd:removeEvent(b_a,a_a)end end;ad:removeEvent(b_a,c_a)if(
bd[b_a]~=nil)then table.remove(bd[b_a],c_a)if(#bd[b_a]==0)then
bd[b_a]=nil end end end,eventHandler=function(a_a,b_a,...)
local c_a=a_a:sendEvent("other_event",b_a,...)if(c_a~=nil)then return c_a end end,customEventHandler=function(a_a,b_a,...)
local c_a=a_a:sendEvent("custom_event",b_a,...)if(c_a~=nil)then return c_a end;return true end,sendEvent=function(a_a,b_a,...)if(
b_a=="other_event")or(b_a=="custom_event")then return
ad:sendEvent(b_a,a_a,...)end;return
ad:sendEvent(b_a,a_a,b_a,...)end,onClick=function(a_a,...)
for b_a,c_a in
pairs(table.pack(...))do if(type(c_a)=="function")then
a_a:registerEvent("mouse_click",c_a)end end;return a_a end,onClickUp=function(a_a,...)for b_a,c_a in
pairs(table.pack(...))do
if(type(c_a)=="function")then a_a:registerEvent("mouse_up",c_a)end end;return a_a end,onRelease=function(a_a,...)
for b_a,c_a in
pairs(table.pack(...))do if(type(c_a)=="function")then
a_a:registerEvent("mouse_release",c_a)end end;return a_a end,onScroll=function(a_a,...)
for b_a,c_a in
pairs(table.pack(...))do if(type(c_a)=="function")then
a_a:registerEvent("mouse_scroll",c_a)end end;return a_a end,onHover=function(a_a,...)
for b_a,c_a in
pairs(table.pack(...))do if(type(c_a)=="function")then
a_a:registerEvent("mouse_hover",c_a)end end;return a_a end,onLeave=function(a_a,...)
for b_a,c_a in
pairs(table.pack(...))do if(type(c_a)=="function")then
a_a:registerEvent("mouse_leave",c_a)end end;return a_a end,onDrag=function(a_a,...)
for b_a,c_a in
pairs(table.pack(...))do if(type(c_a)=="function")then
a_a:registerEvent("mouse_drag",c_a)end end;return a_a end,onKey=function(a_a,...)for b_a,c_a in
pairs(table.pack(...))do
if(type(c_a)=="function")then a_a:registerEvent("key",c_a)end end;return a_a end,onChar=function(a_a,...)for b_a,c_a in
pairs(table.pack(...))do
if(type(c_a)=="function")then a_a:registerEvent("char",c_a)end end;return a_a end,onKeyUp=function(a_a,...)for b_a,c_a in
pairs(table.pack(...))do
if(type(c_a)=="function")then a_a:registerEvent("key_up",c_a)end end;return a_a end}__a.__index=__a;return __a end end
aa["objects"]["MonitorFrame"]=function(...)local ab=da("basaltMon")
local bb,cb,db,_c=math.max,math.min,string.sub,string.rep
return
function(ac,bc)local cc=bc.getObject("BaseFrame")(ac,bc)
local dc="MonitorFrame"cc:setTerm(nil)local _d=false;local ad
local bd={getType=function()return dc end,isType=function(cd,dd)
return dc==dd or cc.isType~=nil and
cc.isType(dd)or false end,getBase=function(cd)return cc end,setMonitor=function(cd,dd)
if
(type(dd)=="string")then local __a=peripheral.wrap(dd)
if(__a~=nil)then cd:setTerm(__a)end elseif(type(dd)=="table")then cd:setTerm(dd)end;return cd end,setMonitorGroup=function(cd,dd)
ad=ab(dd)cd:setTerm(ad)_d=true;return cd end,render=function(cd)if(cd:getTerm()~=
nil)then cc.render(cd)end end,show=function(cd)
cc:getBase().show(cd)bc.setActiveFrame(cd)
for dd,__a in pairs(colors)do if(type(__a)=="number")then
termObject.setPaletteColor(__a,colors.packRGB(term.nativePaletteColor((__a))))end end
for dd,__a in pairs(colorTheme)do
if(type(__a)=="number")then
termObject.setPaletteColor(
type(dd)=="number"and dd or colors[dd],__a)else local a_a,b_a,c_a=table.unpack(__a)
termObject.setPaletteColor(
type(dd)=="number"and dd or colors[dd],a_a,b_a,c_a)end end;return cd end}
bd.mouseHandler=function(cd,dd,__a,a_a,b_a,c_a,...)
if(_d)then __a,a_a=ad.calculateClick(c_a,__a,a_a)end;cc.mouseHandler(cd,dd,__a,a_a,b_a,c_a,...)end;bd.__index=bd;return setmetatable(bd,cc)end end
aa["objects"]["Switch"]=function(...)
return
function(ab,bb)
local cb=bb.getObject("ChangeableObject")(ab,bb)local db="Switch"cb:setSize(4,1)cb:setValue(false)
cb:setZIndex(5)local _c=colors.black;local ac=colors.red;local bc=colors.green
local cc={getType=function(dc)return db end,setSymbol=function(dc,_d)
_c=_d;return dc end,getSymbol=function(dc)return _c end,setActiveBackground=function(dc,_d)bc=_d;return dc end,getActiveBackground=function(dc)return bc end,setInactiveBackground=function(dc,_d)
ac=_d;return dc end,getInactiveBackground=function(dc)return ac end,load=function(dc)
dc:listenEvent("mouse_click")end,mouseHandler=function(dc,...)
if(cb.mouseHandler(dc,...))then
dc:setValue(not dc:getValue())dc:updateDraw()return true end end,draw=function(dc)cb.draw(dc)
dc:addDraw("switch",function()
local _d=dc:getParent()local ad,bd=dc:getBackground(),dc:getForeground()
local cd,dd=dc:getSize()
if(dc:getValue())then dc:addBackgroundBox(1,1,cd,dd,bc)
dc:addBackgroundBox(cd,1,1,dd,_c)else dc:addBackgroundBox(1,1,cd,dd,ac)
dc:addBackgroundBox(1,1,1,dd,_c)end end)end}cc.__index=cc;return setmetatable(cc,cb)end end
aa["objects"]["Treeview"]=function(...)local ab=da("utils")local bb=da("tHex")
return
function(cb,db)
local _c=db.getObject("ChangeableObject")(cb,db)local ac="Treeview"local bc={}local cc=colors.black;local dc=colors.lightGray;local _d=true
local ad="left"local bd,cd=0,0;local dd=true;_c:setSize(16,8)_c:setZIndex(5)
local function __a(c_a,d_a)
c_a=c_a or""d_a=d_a or false;local _aa=false;local aaa=nil;local baa={}local caa={}local daa
caa={getChildren=function(_ba)return baa end,setParent=function(_ba,aba)if(
aaa~=nil)then
aaa.removeChild(aaa.findChildrenByText(caa.getText()))end;aaa=aba;_c:updateDraw()return caa end,getParent=function(_ba)return
aaa end,addChild=function(_ba,aba,bba)local cba=__a(aba,bba)cba.setParent(caa)
table.insert(baa,cba)_c:updateDraw()return cba end,setExpanded=function(_ba,aba)if
(d_a)then _aa=aba end;_c:updateDraw()return caa end,isExpanded=function(_ba)return
_aa end,onSelect=function(_ba,...)for aba,bba in pairs(table.pack(...))do if(type(bba)=="function")then
daa=bba end end;return caa end,callOnSelect=function(_ba)if(
daa~=nil)then daa(caa)end end,setExpandable=function(_ba,aba)aba=aba
_c:updateDraw()return caa end,isExpandable=function(_ba)return d_a end,removeChild=function(_ba,aba)
if(type(aba)=="table")then for bba,cba in
pairs(aba)do if(cba==aba)then aba=bba;break end end end;table.remove(baa,aba)_c:updateDraw()return caa end,findChildrenByText=function(_ba,aba)
local bba={}
for cba,dba in ipairs(baa)do if string.find(dba.getText(),aba)then
table.insert(bba,dba)end end;return bba end,getText=function(_ba)return
c_a end,setText=function(_ba,aba)c_a=aba;_c:updateDraw()return caa end}return caa end;local a_a=__a("Root",true)a_a:setExpanded(true)
local b_a={init=function(c_a)
local d_a=c_a:getParent()c_a:listenEvent("mouse_click")
c_a:listenEvent("mouse_scroll")return _c.init(c_a)end,getBase=function(c_a)return
_c end,getType=function(c_a)return ac end,isType=function(c_a,d_a)
return ac==d_a or
_c.isType~=nil and _c.isType(d_a)or false end,setOffset=function(c_a,d_a,_aa)bd=d_a;cd=_aa;return c_a end,setXOffset=function(c_a,d_a)return
c_a:setOffset(d_a,cd)end,setYOffset=function(c_a,d_a)return c_a:setOffset(bd,d_a)end,getOffset=function(c_a)return
bd,cd end,getXOffset=function(c_a)return bd end,getYOffset=function(c_a)return cd end,setScrollable=function(c_a,d_a)dd=d_a;return c_a end,getScrollable=function(c_a,d_a)return
dd end,setSelectionColor=function(c_a,d_a,_aa,aaa)cc=d_a or c_a:getBackground()dc=_aa or
c_a:getForeground()_d=aaa~=nil and aaa or true
c_a:updateDraw()return c_a end,setSelectionBG=function(c_a,d_a)return c_a:setSelectionColor(d_a,
nil,_d)end,setSelectionFG=function(c_a,d_a)return c_a:setSelectionColor(
nil,d_a,_d)end,getSelectionColor=function(c_a)
return cc,dc end,getSelectionBG=function(c_a)return cc end,getSelectionFG=function(c_a)return dc end,isSelectionColorActive=function(c_a)return _d end,getRoot=function(c_a)
return a_a end,setRoot=function(c_a,d_a)a_a=d_a;d_a.setParent(nil)return c_a end,onSelect=function(c_a,...)
for d_a,_aa in
pairs(table.pack(...))do if(type(_aa)=="function")then
c_a:registerEvent("treeview_select",_aa)end end;return c_a end,selectionHandler=function(c_a,d_a)
d_a.callOnSelect(d_a)c_a:sendEvent("treeview_select",d_a)return c_a end,mouseHandler=function(c_a,d_a,_aa,aaa)
if
_c.mouseHandler(c_a,d_a,_aa,aaa)then local baa=1 -cd;local caa,daa=c_a:getAbsolutePosition()
local _ba,aba=c_a:getSize()
local function bba(cba,dba)
if aaa==daa+baa-1 then
if _aa>=caa and _aa<caa+_ba then cba:setExpanded(not
cba:isExpanded())
c_a:selectionHandler(cba)c_a:setValue(cba)c_a:updateDraw()return true end end;baa=baa+1
if cba:isExpanded()then for _ca,aca in ipairs(cba:getChildren())do if bba(aca,dba+1)then return
true end end end;return false end
for cba,dba in ipairs(a_a:getChildren())do if bba(dba,1)then return true end end end end,scrollHandler=function(c_a,d_a,_aa,aaa)
if
_c.scrollHandler(c_a,d_a,_aa,aaa)then
if dd then local baa,caa=c_a:getSize()cd=cd+d_a;if cd<0 then cd=0 end
if d_a>=1 then local daa=0
local function _ba(aba,bba)
daa=daa+1;if aba:isExpanded()then
for cba,dba in ipairs(aba:getChildren())do _ba(dba,bba+1)end end end;for aba,bba in ipairs(a_a:getChildren())do _ba(bba,1)end
if
daa>caa then if cd>daa-caa then cd=daa-caa end else cd=cd-1 end end;c_a:updateDraw()end;return true end;return false end,draw=function(c_a)
_c.draw(c_a)
c_a:addDraw("treeview",function()local d_a=1 -cd;local _aa=c_a:getValue()
local function aaa(baa,caa)
local daa,_ba=c_a:getSize()
if d_a>=1 and d_a<=_ba then
local aba=(baa==_aa)and cc or c_a:getBackground()
local bba=(baa==_aa)and dc or c_a:getForeground()local cba=baa.getText()
c_a:addBlit(1 +caa+bd,d_a,cba,bb[bba]:rep(#cba),bb[aba]:rep(
#cba))end;d_a=d_a+1;if baa:isExpanded()then for aba,bba in ipairs(baa:getChildren())do
aaa(bba,caa+1)end end end;for baa,caa in ipairs(a_a:getChildren())do aaa(caa,1)end end)end}b_a.__index=b_a;return setmetatable(b_a,_c)end end
aa["objects"]["Timer"]=function(...)
return
function(ab,bb)
local cb=bb.getObject("Object")(ab,bb)local db="Timer"local _c=0;local ac=0;local bc=0;local cc;local dc=false
local _d={getType=function(ad)return db end,setTime=function(ad,bd,cd)_c=bd or 0
ac=cd or 1;return ad end,getTime=function(ad)return _c end,start=function(ad)if(dc)then
os.cancelTimer(cc)end;bc=ac;cc=os.startTimer(_c)dc=true
ad:listenEvent("other_event")return ad end,isActive=function(ad)return dc end,cancel=function(ad)if(
cc~=nil)then os.cancelTimer(cc)end;dc=false
ad:removeEvent("other_event")return ad end,setStart=function(ad,bd)if(bd==true)then
return ad:start()else return ad:cancel()end end,onCall=function(ad,bd)
ad:registerEvent("timed_event",bd)return ad end,eventHandler=function(ad,bd,...)cb.eventHandler(ad,bd,...)
if
bd=="timer"and tObj==cc and dc then
ad:sendEvent("timed_event")if(bc>=1)then bc=bc-1;if(bc>=1)then cc=os.startTimer(_c)end elseif(bc==-1)then
cc=os.startTimer(_c)end end end}_d.__index=_d;return setmetatable(_d,cb)end end
aa["objects"]["Program"]=function(...)local ab=da("tHex")local bb=da("process")
local cb=string.sub
return
function(db,_c)local ac=_c.getObject("VisualObject")(db,_c)
local bc="Program"local cc;local dc;local _d={}
local function ad(_aa,aaa,baa,caa)local daa,_ba=1,1;local aba,bba=colors.black,colors.white;local cba=false
local dba=false;local _ca={}local aca={}local bca={}local cca={}local dca;local _da={}for i=0,15 do local cab=2 ^i
cca[cab]={_c.getTerm().getPaletteColour(cab)}end;local function ada()dca=(" "):rep(baa)
for n=0,15 do
local cab=2 ^n;local dab=ab[cab]_da[cab]=dab:rep(baa)end end
local function bda()ada()local cab=dca
local dab=_da[colors.white]local _bb=_da[colors.black]
for n=1,caa do
_ca[n]=cb(_ca[n]==nil and cab or _ca[n]..cab:sub(1,
baa-_ca[n]:len()),1,baa)
bca[n]=cb(bca[n]==nil and dab or bca[n]..
dab:sub(1,baa-bca[n]:len()),1,baa)
aca[n]=cb(aca[n]==nil and _bb or aca[n]..
_bb:sub(1,baa-aca[n]:len()),1,baa)end;ac.updateDraw(ac)end;bda()local function cda()if
daa>=1 and _ba>=1 and daa<=baa and _ba<=caa then else end end
local function dda(cab,dab,_bb)if

_ba<1 or _ba>caa or daa<1 or daa+#cab-1 >baa then return end
_ca[_ba]=cb(_ca[_ba],1,daa-1)..cab..cb(_ca[_ba],
daa+#cab,baa)bca[_ba]=cb(bca[_ba],1,daa-1)..
dab..cb(bca[_ba],daa+#cab,baa)
aca[_ba]=
cb(aca[_ba],1,daa-1).._bb..cb(aca[_ba],daa+#cab,baa)daa=daa+#cab;if dba then cda()end;cc:updateDraw()end
local function __b(cab,dab,_bb)
if(_bb~=nil)then local abb=_ca[dab]if(abb~=nil)then
_ca[dab]=cb(abb:sub(1,cab-1).._bb..abb:sub(cab+
(_bb:len()),baa),1,baa)end end;cc:updateDraw()end
local function a_b(cab,dab,_bb)
if(_bb~=nil)then local abb=aca[dab]if(abb~=nil)then
aca[dab]=cb(abb:sub(1,cab-1).._bb..abb:sub(cab+
(_bb:len()),baa),1,baa)end end;cc:updateDraw()end
local function b_b(cab,dab,_bb)
if(_bb~=nil)then local abb=bca[dab]if(abb~=nil)then
bca[dab]=cb(abb:sub(1,cab-1).._bb..abb:sub(cab+
(_bb:len()),baa),1,baa)end end;cc:updateDraw()end
local c_b=function(cab)
if type(cab)~="number"then
error("bad argument #1 (expected number, got "..type(cab)..")",2)elseif ab[cab]==nil then
error("Invalid color (got "..cab..")",2)end;bba=cab end
local d_b=function(cab)
if type(cab)~="number"then
error("bad argument #1 (expected number, got "..type(cab)..")",2)elseif ab[cab]==nil then
error("Invalid color (got "..cab..")",2)end;aba=cab end
local _ab=function(cab,dab,_bb,abb)if type(cab)~="number"then
error("bad argument #1 (expected number, got "..type(cab)..")",2)end
if ab[cab]==nil then error("Invalid color (got "..
cab..")",2)end;local bbb
if
type(dab)=="number"and _bb==nil and abb==nil then bbb={colours.rgb8(dab)}cca[cab]=bbb else if
type(dab)~="number"then
error("bad argument #2 (expected number, got "..type(dab)..")",2)end;if type(_bb)~="number"then
error(
"bad argument #3 (expected number, got "..type(_bb)..")",2)end;if type(abb)~="number"then
error(
"bad argument #4 (expected number, got "..type(abb)..")",2)end;bbb=cca[cab]bbb[1]=dab
bbb[2]=_bb;bbb[3]=abb end end
local aab=function(cab)if type(cab)~="number"then
error("bad argument #1 (expected number, got "..type(cab)..")",2)end
if ab[cab]==nil then error("Invalid color (got "..
cab..")",2)end;local dab=cca[cab]return dab[1],dab[2],dab[3]end
local bab={setCursorPos=function(cab,dab)if type(cab)~="number"then
error("bad argument #1 (expected number, got "..type(cab)..")",2)end;if type(dab)~="number"then
error(
"bad argument #2 (expected number, got "..type(dab)..")",2)end;daa=math.floor(cab)
_ba=math.floor(dab)if(dba)then cda()end end,getCursorPos=function()return
daa,_ba end,setCursorBlink=function(cab)if type(cab)~="boolean"then
error("bad argument #1 (expected boolean, got "..
type(cab)..")",2)end;cba=cab end,getCursorBlink=function()return
cba end,getPaletteColor=aab,getPaletteColour=aab,setBackgroundColor=d_b,setBackgroundColour=d_b,setTextColor=c_b,setTextColour=c_b,setPaletteColor=_ab,setPaletteColour=_ab,getBackgroundColor=function()return aba end,getBackgroundColour=function()return aba end,getSize=function()
return baa,caa end,getTextColor=function()return bba end,getTextColour=function()return bba end,basalt_resize=function(cab,dab)baa,caa=cab,dab;bda()end,basalt_reposition=function(cab,dab)
_aa,aaa=cab,dab end,basalt_setVisible=function(cab)dba=cab end,drawBackgroundBox=function(cab,dab,_bb,abb,bbb)for n=1,abb do
a_b(cab,dab+ (n-1),ab[bbb]:rep(_bb))end end,drawForegroundBox=function(cab,dab,_bb,abb,bbb)
for n=1,abb do b_b(cab,
dab+ (n-1),ab[bbb]:rep(_bb))end end,drawTextBox=function(cab,dab,_bb,abb,bbb)for n=1,abb do
__b(cab,dab+ (n-1),bbb:rep(_bb))end end,basalt_update=function()for n=1,caa do
cc:addBlit(1,n,_ca[n],bca[n],aca[n])end end,scroll=function(cab)
assert(type(cab)==
"number","bad argument #1 (expected number, got "..type(cab)..")")
if cab~=0 then
for newY=1,caa do local dab=newY+cab;if dab<1 or dab>caa then _ca[newY]=dca
bca[newY]=_da[bba]aca[newY]=_da[aba]else _ca[newY]=_ca[dab]aca[newY]=aca[dab]
bca[newY]=bca[dab]end end end;if(dba)then cda()end end,isColor=function()return
_c.getTerm().isColor()end,isColour=function()
return _c.getTerm().isColor()end,write=function(cab)cab=tostring(cab)if(dba)then
dda(cab,ab[bba]:rep(cab:len()),ab[aba]:rep(cab:len()))end end,clearLine=function()
if
(dba)then __b(1,_ba,(" "):rep(baa))
a_b(1,_ba,ab[aba]:rep(baa))b_b(1,_ba,ab[bba]:rep(baa))end;if(dba)then cda()end end,clear=function()
for n=1,caa
do __b(1,n,(" "):rep(baa))
a_b(1,n,ab[aba]:rep(baa))b_b(1,n,ab[bba]:rep(baa))end;if(dba)then cda()end end,blit=function(cab,dab,_bb)if
type(cab)~="string"then
error("bad argument #1 (expected string, got "..type(cab)..")",2)end;if type(dab)~="string"then
error(
"bad argument #2 (expected string, got "..type(dab)..")",2)end;if type(_bb)~="string"then
error(
"bad argument #3 (expected string, got "..type(_bb)..")",2)end
if
#dab~=#cab or#_bb~=#cab then error("Arguments must be the same length",2)end;if(dba)then dda(cab,dab,_bb)end end}return bab end;ac:setZIndex(5)ac:setSize(30,12)local bd=ad(1,1,30,12)local cd
local dd=false;local __a={}
local function a_a(_aa)local aaa=_aa:getParent()local baa,caa=bd.getCursorPos()
local daa,_ba=_aa:getPosition()local aba,bba=_aa:getSize()
if(daa+baa-1 >=1 and
daa+baa-1 <=daa+aba-1 and caa+_ba-1 >=1 and
caa+_ba-1 <=_ba+bba-1)then
aaa:setCursor(
_aa:isFocused()and bd.getCursorBlink(),daa+baa-1,caa+_ba-1,bd.getTextColor())end end
local function b_a(_aa,aaa,...)local baa,caa=cd:resume(aaa,...)
if(baa==false)and(caa~=nil)and
(caa~="Terminated")then
local daa=_aa:sendEvent("program_error",caa)
if(daa~=false)then error("Basalt Program - "..caa)end end
if(cd:getStatus()=="dead")then _aa:sendEvent("program_done")end end
local function c_a(_aa,aaa,baa,caa,daa)if(cd==nil)then return false end
if not(cd:isDead())then if not(dd)then
local _ba,aba=_aa:getAbsolutePosition()b_a(_aa,aaa,baa,caa-_ba+1,daa-aba+1)
a_a(_aa)end end end
local function d_a(_aa,aaa,baa,caa)if(cd==nil)then return false end
if not(cd:isDead())then if not(dd)then if(_aa.draw)then
b_a(_aa,aaa,baa,caa)a_a(_aa)end end end end
cc={getType=function(_aa)return bc end,show=function(_aa)ac.show(_aa)
bd.setBackgroundColor(_aa:getBackground())bd.setTextColor(_aa:getForeground())
bd.basalt_setVisible(true)return _aa end,hide=function(_aa)
ac.hide(_aa)bd.basalt_setVisible(false)return _aa end,setPosition=function(_aa,aaa,baa,caa)
ac.setPosition(_aa,aaa,baa,caa)bd.basalt_reposition(_aa:getPosition())return _aa end,getBasaltWindow=function()return
bd end,getBasaltProcess=function()return cd end,setSize=function(_aa,aaa,baa,caa)ac.setSize(_aa,aaa,baa,caa)
bd.basalt_resize(_aa:getWidth(),_aa:getHeight())return _aa end,getStatus=function(_aa)if(cd~=nil)then return
cd:getStatus()end;return"inactive"end,setEnviroment=function(_aa,aaa)_d=
aaa or{}return _aa end,execute=function(_aa,aaa,...)dc=aaa or dc
cd=bb:new(dc,bd,_d,...)bd.setBackgroundColor(colors.black)
bd.setTextColor(colors.white)bd.clear()bd.setCursorPos(1,1)
bd.setBackgroundColor(_aa:getBackground())
bd.setTextColor(_aa:getForeground()or colors.white)bd.basalt_setVisible(true)b_a(_aa)dd=false
_aa:listenEvent("mouse_click",_aa)_aa:listenEvent("mouse_up",_aa)
_aa:listenEvent("mouse_drag",_aa)_aa:listenEvent("mouse_scroll",_aa)
_aa:listenEvent("key",_aa)_aa:listenEvent("key_up",_aa)
_aa:listenEvent("char",_aa)_aa:listenEvent("other_event",_aa)return _aa end,setExecute=function(_aa,aaa,...)return
_aa:execute(aaa,...)end,stop=function(_aa)local aaa=_aa:getParent()
if(cd~=nil)then if not
(cd:isDead())then b_a(_aa,"terminate")if(cd:isDead())then
aaa:setCursor(false)end end end;aaa:removeEvents(_aa)return _aa end,pause=function(_aa,aaa)dd=
aaa or(not dd)if(cd~=nil)then
if not(cd:isDead())then if not(dd)then
_aa:injectEvents(table.unpack(__a))__a={}end end end;return _aa end,isPaused=function(_aa)return
dd end,injectEvent=function(_aa,aaa,baa,...)
if(cd~=nil)then if not(cd:isDead())then
if(dd==false)or(baa)then
b_a(_aa,aaa,...)else table.insert(__a,{event=aaa,args={...}})end end end;return _aa end,getQueuedEvents=function(_aa)return
__a end,updateQueuedEvents=function(_aa,aaa)__a=aaa or __a;return _aa end,injectEvents=function(_aa,...)if(cd~=nil)then
if not
(cd:isDead())then for aaa,baa in pairs({...})do
b_a(_aa,baa.event,table.unpack(baa.args))end end end;return _aa end,mouseHandler=function(_aa,aaa,baa,caa)
if
(ac.mouseHandler(_aa,aaa,baa,caa))then c_a(_aa,"mouse_click",aaa,baa,caa)return true end;return false end,mouseUpHandler=function(_aa,aaa,baa,caa)
if
(ac.mouseUpHandler(_aa,aaa,baa,caa))then c_a(_aa,"mouse_up",aaa,baa,caa)return true end;return false end,scrollHandler=function(_aa,aaa,baa,caa)
if
(ac.scrollHandler(_aa,aaa,baa,caa))then c_a(_aa,"mouse_scroll",aaa,baa,caa)return true end;return false end,dragHandler=function(_aa,aaa,baa,caa)
if
(ac.dragHandler(_aa,aaa,baa,caa))then c_a(_aa,"mouse_drag",aaa,baa,caa)return true end;return false end,keyHandler=function(_aa,aaa,baa)if
(ac.keyHandler(_aa,aaa,baa))then d_a(_aa,"key",aaa,baa)return true end;return
false end,keyUpHandler=function(_aa,aaa)if
(ac.keyUpHandler(_aa,aaa))then d_a(_aa,"key_up",aaa)return true end
return false end,charHandler=function(_aa,aaa)if
(ac.charHandler(_aa,aaa))then d_a(_aa,"char",aaa)return true end
return false end,getFocusHandler=function(_aa)
ac.getFocusHandler(_aa)
if(cd~=nil)then
if not(cd:isDead())then
if not(dd)then local aaa=_aa:getParent()
if(aaa~=nil)then
local baa,caa=bd.getCursorPos()local daa,_ba=_aa:getPosition()local aba,bba=_aa:getSize()
if
(

daa+baa-1 >=1 and daa+baa-1 <=daa+aba-1 and caa+_ba-1 >=1 and caa+_ba-1 <=_ba+bba-1)then
aaa:setCursor(bd.getCursorBlink(),daa+baa-1,caa+_ba-1,bd.getTextColor())end end end end end end,loseFocusHandler=function(_aa)
ac.loseFocusHandler(_aa)
if(cd~=nil)then if not(cd:isDead())then local aaa=_aa:getParent()if(aaa~=nil)then
aaa:setCursor(false)end end end end,eventHandler=function(_aa,aaa,...)
ac.eventHandler(_aa,aaa,...)if cd==nil then return end
if not cd:isDead()then
if not dd then b_a(_aa,aaa,...)
if
_aa:isFocused()then local baa=_aa:getParent()local caa,daa=_aa:getPosition()
local _ba,aba=bd.getCursorPos()local bba,cba=_aa:getSize()
if caa+_ba-1 >=1 and
caa+_ba-1 <=caa+bba-1 and aba+daa-1 >=1 and
aba+daa-1 <=daa+cba-1 then
baa:setCursor(bd.getCursorBlink(),
caa+_ba-1,aba+daa-1,bd.getTextColor())end end else table.insert(__a,{event=aaa,args={...}})end end end,resizeHandler=function(_aa,...)
ac.resizeHandler(_aa,...)
if(cd~=nil)then
if not(cd:isDead())then
if not(dd)then
bd.basalt_resize(_aa:getSize())b_a(_aa,"term_resize",_aa:getSize())else
bd.basalt_resize(_aa:getSize())
table.insert(__a,{event="term_resize",args={_aa:getSize()}})end end end end,repositionHandler=function(_aa,...)
ac.repositionHandler(_aa,...)
if(cd~=nil)then if not(cd:isDead())then
bd.basalt_reposition(_aa:getPosition())end end end,draw=function(_aa)
ac.draw(_aa)
_aa:addDraw("program",function()local aaa=_aa:getParent()local baa,caa=_aa:getPosition()
local daa,_ba=bd.getCursorPos()local aba,bba=_aa:getSize()bd.basalt_update()end)end,onError=function(_aa,...)
for baa,caa in
pairs(table.pack(...))do if(type(caa)=="function")then
_aa:registerEvent("program_error",caa)end end;local aaa=_aa:getParent()_aa:listenEvent("other_event")
return _aa end,onDone=function(_aa,...)
for baa,caa in
pairs(table.pack(...))do if(type(caa)=="function")then
_aa:registerEvent("program_done",caa)end end;local aaa=_aa:getParent()_aa:listenEvent("other_event")
return _aa end}cc.__index=cc;return setmetatable(cc,ac)end end
aa["objects"]["Progressbar"]=function(...)
return
function(ab,bb)
local cb=bb.getObject("ChangeableObject")(ab,bb)local db="Progressbar"local _c=0;cb:setZIndex(5)cb:setValue(false)
cb:setSize(25,3)local ac=colors.black;local bc=""local cc=colors.white;local dc=""local _d=0
local ad={getType=function(bd)return db end,setDirection=function(bd,cd)
_d=cd;bd:updateDraw()return bd end,getDirection=function(bd)return _d end,setProgressBar=function(bd,cd,dd,__a)
ac=cd or ac;bc=dd or bc;cc=__a or cc;bd:updateDraw()return bd end,getProgressBar=function(bd)return
ac,bc,cc end,setActiveBarColor=function(bd,cd)return bd:setProgressBar(cd,nil,nil)end,getActiveBarColor=function(bd)return
ac end,setActiveBarSymbol=function(bd,cd)return bd:setProgressBar(nil,cd,nil)end,getActiveBarSymbol=function(bd)return
bc end,setActiveBarSymbolColor=function(bd,cd)return bd:setProgressBar(nil,nil,cd)end,getActiveBarSymbolColor=function(bd)return
cc end,setBackgroundSymbol=function(bd,cd)dc=cd:sub(1,1)bd:updateDraw()return bd end,getBackgroundSymbol=function(bd)return
dc end,setProgress=function(bd,cd)
if(cd>=0)and(cd<=100)and(_c~=cd)then _c=cd
bd:setValue(_c)if(_c==100)then bd:progressDoneHandler()end end;bd:updateDraw()return bd end,getProgress=function(bd)return
_c end,onProgressDone=function(bd,cd)bd:registerEvent("progress_done",cd)
return bd end,progressDoneHandler=function(bd)
bd:sendEvent("progress_done")end,draw=function(bd)cb.draw(bd)
bd:addDraw("progressbar",function()
local cd,dd=bd:getPosition()local __a,a_a=bd:getSize()
local b_a,c_a=bd:getBackground(),bd:getForeground()
if(b_a~=false)then bd:addBackgroundBox(1,1,__a,a_a,b_a)end;if(dc~="")then bd:addTextBox(1,1,__a,a_a,dc)end
if
(c_a~=false)then bd:addForegroundBox(1,1,__a,a_a,c_a)end
if(_d==1)then bd:addBackgroundBox(1,1,__a,a_a/100 *_c,ac)bd:addForegroundBox(1,1,__a,
a_a/100 *_c,cc)
bd:addTextBox(1,1,__a,a_a/100 *_c,bc)elseif(_d==3)then
bd:addBackgroundBox(1,1 +math.ceil(a_a-a_a/100 *_c),__a,
a_a/100 *_c,ac)
bd:addForegroundBox(1,1 +math.ceil(a_a-a_a/100 *_c),__a,
a_a/100 *_c,cc)
bd:addTextBox(1,1 +math.ceil(a_a-a_a/100 *_c),__a,a_a/100 *_c,bc)elseif(_d==2)then
bd:addBackgroundBox(1 +math.ceil(__a-__a/100 *_c),1,__a/
100 *_c,a_a,ac)
bd:addForegroundBox(1 +math.ceil(__a-__a/100 *_c),1,__a/100 *_c,a_a,cc)
bd:addTextBox(1 +math.ceil(__a-__a/100 *_c),1,__a/100 *_c,a_a,bc)else
bd:addBackgroundBox(1,1,math.ceil(__a/100 *_c),a_a,ac)
bd:addForegroundBox(1,1,math.ceil(__a/100 *_c),a_a,cc)
bd:addTextBox(1,1,math.ceil(__a/100 *_c),a_a,bc)end end)end}ad.__index=ad;return setmetatable(ad,cb)end end
aa["objects"]["Textfield"]=function(...)local ab=da("tHex")
local bb,cb,db,_c,ac=string.rep,string.find,string.gmatch,string.sub,string.len
return
function(bc,cc)
local dc=cc.getObject("ChangeableObject")(bc,cc)local _d="Textfield"local ad,bd,cd,dd=1,1,1,1;local __a={""}local a_a={""}local b_a={""}local c_a={}local d_a={}
local _aa,aaa,baa,caa;local daa,_ba=colors.lightBlue,colors.black;dc:setSize(30,12)
dc:setZIndex(5)
local function aba()if
(_aa~=nil)and(aaa~=nil)and(baa~=nil)and(caa~=nil)then return true end;return false end
local function bba()local cca,dca,_da,ada=_aa,aaa,baa,caa
if aba()then
if _aa<aaa and baa<=caa then cca=_aa;dca=aaa;if baa<caa then
_da=baa;ada=caa else _da=caa;ada=baa end elseif _aa>aaa and baa>=caa then
cca=aaa;dca=_aa;if baa>caa then _da=caa;ada=baa else _da=baa;ada=caa end elseif baa>caa then
cca=aaa;dca=_aa;_da=caa;ada=baa end;return cca,dca,_da,ada end end
local function cba(cca)local dca,_da,ada,bda=bba()local cda=__a[ada]local dda=__a[bda]__a[ada]=cda:sub(1,dca-1)..dda:sub(
_da+1,dda:len())
a_a[ada]=a_a[ada]:sub(1,
dca-1)..a_a[bda]:sub(_da+1,a_a[bda]:len())b_a[ada]=b_a[ada]:sub(1,dca-1)..
b_a[bda]:sub(_da+1,b_a[bda]:len())for i=bda,ada+1,-1 do
if i~=ada then
table.remove(__a,i)table.remove(a_a,i)table.remove(b_a,i)end end;cd,dd=dca,ada
_aa,aaa,baa,caa=nil,nil,nil,nil;return cca end
local function dba(cca,dca)local _da={}
if(cca:len()>0)then
for ada in db(cca,dca)do local bda,cda=cb(cca,ada)
if
(bda~=nil)and(cda~=nil)then table.insert(_da,bda)table.insert(_da,cda)
local dda=_c(cca,1,(bda-1))local __b=_c(cca,cda+1,cca:len())cca=dda.. (":"):rep(ada:len())..
__b end end end;return _da end
local function _ca(cca,dca)dca=dca or dd
local _da=ab[cca:getForeground()]:rep(b_a[dca]:len())
local ada=ab[cca:getBackground()]:rep(a_a[dca]:len())
for bda,cda in pairs(d_a)do local dda=dba(__a[dca],cda[1])
if(#dda>0)then
for x=1,#dda/2 do
local __b=x*2 -1;if(cda[2]~=nil)then
_da=_da:sub(1,dda[__b]-1)..ab[cda[2]]:rep(dda[__b+1]- (
dda[__b]-1))..
_da:sub(dda[__b+1]+1,_da:len())end;if
(cda[3]~=nil)then
ada=ada:sub(1,dda[__b]-1)..

ab[cda[3]]:rep(dda[__b+1]- (dda[__b]-1))..ada:sub(dda[__b+1]+1,ada:len())end end end end
for bda,cda in pairs(c_a)do
for dda,__b in pairs(cda)do local a_b=dba(__a[dca],__b)
if(#a_b>0)then for x=1,#a_b/2 do
local b_b=x*2 -1
_da=_da:sub(1,a_b[b_b]-1)..

ab[bda]:rep(a_b[b_b+1]- (a_b[b_b]-1)).._da:sub(a_b[b_b+1]+1,_da:len())end end end end;b_a[dca]=_da;a_a[dca]=ada;cca:updateDraw()end;local function aca(cca)for n=1,#__a do _ca(cca,n)end end
local bca={getType=function(cca)return _d end,setBackground=function(cca,dca)
dc.setBackground(cca,dca)aca(cca)return cca end,setForeground=function(cca,dca)
dc.setForeground(cca,dca)aca(cca)return cca end,setSelection=function(cca,dca,_da)_ba=dca or _ba
daa=_da or daa;return cca end,setSelectionFG=function(cca,dca)
return cca:setSelection(dca,nil)end,setSelectionBG=function(cca,dca)return cca:setSelection(nil,dca)end,getSelection=function(cca)return
_ba,daa end,getSelectionFG=function(cca)return _ba end,getSelectionBG=function(cca)return daa end,getLines=function(cca)return __a end,getLine=function(cca,dca)return
__a[dca]end,editLine=function(cca,dca,_da)__a[dca]=_da or __a[dca]
_ca(cca,dca)cca:updateDraw()return cca end,clear=function(cca)
__a={""}a_a={""}b_a={""}_aa,aaa,baa,caa=nil,nil,nil,nil;ad,bd,cd,dd=1,1,1,1
cca:updateDraw()return cca end,addLine=function(cca,dca,_da)
if(dca~=nil)then
local ada=cca:getBackground()local bda=cca:getForeground()
if(#__a==1)and(__a[1]=="")then
__a[1]=dca;a_a[1]=ab[ada]:rep(dca:len())
b_a[1]=ab[bda]:rep(dca:len())_ca(cca,1)return cca end
if(_da~=nil)then table.insert(__a,_da,dca)
table.insert(a_a,_da,ab[ada]:rep(dca:len()))
table.insert(b_a,_da,ab[bda]:rep(dca:len()))else table.insert(__a,dca)
table.insert(a_a,ab[ada]:rep(dca:len()))
table.insert(b_a,ab[bda]:rep(dca:len()))end end;_ca(cca,_da or#__a)cca:updateDraw()return cca end,addKeywords=function(cca,dca,_da)if(
c_a[dca]==nil)then c_a[dca]={}end;for ada,bda in pairs(_da)do
table.insert(c_a[dca],bda)end;cca:updateDraw()return cca end,addRule=function(cca,dca,_da,ada)
table.insert(d_a,{dca,_da,ada})cca:updateDraw()return cca end,editRule=function(cca,dca,_da,ada)for bda,cda in
pairs(d_a)do
if(cda[1]==dca)then d_a[bda][2]=_da;d_a[bda][3]=ada end end;cca:updateDraw()return cca end,removeRule=function(cca,dca)
for _da,ada in
pairs(d_a)do if(ada[1]==dca)then table.remove(d_a,_da)end end;cca:updateDraw()return cca end,setKeywords=function(cca,dca,_da)
c_a[dca]=_da;cca:updateDraw()return cca end,removeLine=function(cca,dca)
if(#__a>1)then table.remove(__a,
dca or#__a)
table.remove(a_a,dca or#a_a)table.remove(b_a,dca or#b_a)else __a={""}a_a={""}b_a={""}end;cca:updateDraw()return cca end,getTextCursor=function(cca)return
cd,dd end,getOffset=function(cca)return bd,ad end,setOffset=function(cca,dca,_da)bd=dca or bd;ad=_da or ad
cca:updateDraw()return cca end,getXOffset=function(cca)return bd end,setXOffset=function(cca,dca)return
cca:setOffset(dca,nil)end,getYOffset=function(cca)return ad end,setYOffset=function(cca,dca)return
cca:setOffset(nil,dca)end,getFocusHandler=function(cca)dc.getFocusHandler(cca)
local dca,_da=cca:getPosition()
cca:getParent():setCursor(true,dca+cd-bd,_da+dd-ad,cca:getForeground())end,loseFocusHandler=function(cca)
dc.loseFocusHandler(cca)cca:getParent():setCursor(false)end,keyHandler=function(cca,dca)
if
(dc.keyHandler(cca,dca))then local _da=cca:getParent()local ada,bda=cca:getPosition()
local cda,dda=cca:getSize()
if(dca==keys.backspace)then
if(aba())then cba(cca)else
if(__a[dd]=="")then
if(dd>1)then
table.remove(__a,dd)table.remove(b_a,dd)table.remove(a_a,dd)cd=
__a[dd-1]:len()+1;bd=cd-cda+1;if(bd<1)then bd=1 end;dd=dd-1 end elseif(cd<=1)then
if(dd>1)then cd=__a[dd-1]:len()+1;bd=cd-cda+1;if(bd<1)then
bd=1 end;__a[dd-1]=__a[dd-1]..__a[dd]b_a[dd-1]=
b_a[dd-1]..b_a[dd]
a_a[dd-1]=a_a[dd-1]..a_a[dd]table.remove(__a,dd)table.remove(b_a,dd)
table.remove(a_a,dd)dd=dd-1 end else __a[dd]=__a[dd]:sub(1,cd-2)..
__a[dd]:sub(cd,__a[dd]:len())
b_a[dd]=
b_a[dd]:sub(1,cd-2)..b_a[dd]:sub(cd,b_a[dd]:len())a_a[dd]=a_a[dd]:sub(1,cd-2)..
a_a[dd]:sub(cd,a_a[dd]:len())
if(cd>1)then cd=cd-1 end;if(bd>1)then if(cd<bd)then bd=bd-1 end end end;if(dd<ad)then ad=ad-1 end end;_ca(cca)cca:setValue("")elseif(dca==keys.delete)then
if(aba())then cba(cca)else
if(cd>
__a[dd]:len())then if(__a[dd+1]~=nil)then __a[dd]=__a[dd]..__a[dd+1]table.remove(__a,
dd+1)table.remove(a_a,dd+1)
table.remove(b_a,dd+1)end else
__a[dd]=__a[dd]:sub(1,
cd-1)..__a[dd]:sub(cd+1,__a[dd]:len())b_a[dd]=b_a[dd]:sub(1,cd-1)..
b_a[dd]:sub(cd+1,b_a[dd]:len())
a_a[dd]=a_a[dd]:sub(1,
cd-1)..a_a[dd]:sub(cd+1,a_a[dd]:len())end end;_ca(cca)elseif(dca==keys.enter)then if(aba())then cba(cca)end
table.insert(__a,dd+1,__a[dd]:sub(cd,__a[dd]:len()))
table.insert(b_a,dd+1,b_a[dd]:sub(cd,b_a[dd]:len()))
table.insert(a_a,dd+1,a_a[dd]:sub(cd,a_a[dd]:len()))__a[dd]=__a[dd]:sub(1,cd-1)
b_a[dd]=b_a[dd]:sub(1,cd-1)a_a[dd]=a_a[dd]:sub(1,cd-1)dd=dd+1;cd=1;bd=1;if(dd-ad>=dda)then
ad=ad+1 end;cca:setValue("")elseif(dca==keys.up)then
_aa,baa,aaa,caa=nil,nil,nil,nil
if(dd>1)then dd=dd-1;if(cd>__a[dd]:len()+1)then
cd=__a[dd]:len()+1 end;if(bd>1)then
if(cd<bd)then bd=cd-cda+1;if(bd<1)then bd=1 end end end
if(ad>1)then if(dd<ad)then ad=ad-1 end end end elseif(dca==keys.down)then _aa,baa,aaa,caa=nil,nil,nil,nil
if(dd<#__a)then dd=dd+1
if(cd>
__a[dd]:len()+1)then cd=__a[dd]:len()+1 end
if(bd>1)then if(cd<bd)then bd=cd-cda+1;if(bd<1)then bd=1 end end end;if(dd>=ad+dda)then ad=ad+1 end end elseif(dca==keys.right)then _aa,baa,aaa,caa=nil,nil,nil,nil;cd=cd+1
if(dd<#__a)then if(cd>
__a[dd]:len()+1)then cd=1;dd=dd+1 end elseif
(cd>__a[dd]:len())then cd=__a[dd]:len()+1 end;if(cd<1)then cd=1 end
if(cd<bd)or(cd>=cda+bd)then bd=cd-cda+1 end;if(bd<1)then bd=1 end elseif(dca==keys.left)then _aa,baa,aaa,caa=nil,nil,nil,nil;cd=cd-1
if(cd>=1)then if(
cd<bd)or(cd>=cda+bd)then bd=cd end end;if(dd>1)then
if(cd<1)then dd=dd-1;cd=__a[dd]:len()+1;bd=cd-cda+1 end end;if(cd<1)then cd=1 end;if(bd<1)then bd=1 end elseif(dca==
keys.tab)then
if(cd%3 ==0)then
__a[dd]=__a[dd]:sub(1,cd-1).." "..
__a[dd]:sub(cd,__a[dd]:len())
b_a[dd]=b_a[dd]:sub(1,cd-1)..ab[cca:getForeground()]..
b_a[dd]:sub(cd,b_a[dd]:len())
a_a[dd]=a_a[dd]:sub(1,cd-1)..ab[cca:getBackground()]..
a_a[dd]:sub(cd,a_a[dd]:len())cd=cd+1 end
while cd%3 ~=0 do
__a[dd]=__a[dd]:sub(1,cd-1).." "..
__a[dd]:sub(cd,__a[dd]:len())
b_a[dd]=b_a[dd]:sub(1,cd-1)..ab[cca:getForeground()]..
b_a[dd]:sub(cd,b_a[dd]:len())
a_a[dd]=a_a[dd]:sub(1,cd-1)..ab[cca:getBackground()]..
a_a[dd]:sub(cd,a_a[dd]:len())cd=cd+1 end end
if not
( (ada+cd-bd>=ada and ada+cd-bd<ada+cda)and(
bda+dd-ad>=bda and bda+dd-ad<bda+dda))then bd=math.max(1,
__a[dd]:len()-cda+1)
ad=math.max(1,dd-dda+1)end;local __b=
(cd<=__a[dd]:len()and cd-1 or __a[dd]:len())- (bd-1)
if(__b>cca:getX()+
cda-1)then __b=cca:getX()+cda-1 end;local a_b=(dd-ad<dda and dd-ad or dd-ad-1)if
(__b<1)then __b=0 end
_da:setCursor(true,ada+__b,bda+a_b,cca:getForeground())cca:updateDraw()return true end end,charHandler=function(cca,dca)
if
(dc.charHandler(cca,dca))then local _da=cca:getParent()local ada,bda=cca:getPosition()
local cda,dda=cca:getSize()if(aba())then cba(cca)end
__a[dd]=__a[dd]:sub(1,cd-1)..dca..
__a[dd]:sub(cd,__a[dd]:len())
b_a[dd]=b_a[dd]:sub(1,cd-1)..ab[cca:getForeground()]..
b_a[dd]:sub(cd,b_a[dd]:len())
a_a[dd]=a_a[dd]:sub(1,cd-1)..ab[cca:getBackground()]..
a_a[dd]:sub(cd,a_a[dd]:len())cd=cd+1;if(cd>=cda+bd)then bd=bd+1 end;_ca(cca)
cca:setValue("")
if not
( (ada+cd-bd>=ada and ada+cd-bd<ada+cda)and(
bda+dd-ad>=bda and bda+dd-ad<bda+dda))then bd=math.max(1,
__a[dd]:len()-cda+1)
ad=math.max(1,dd-dda+1)end;local __b=
(cd<=__a[dd]:len()and cd-1 or __a[dd]:len())- (bd-1)
if(__b>cca:getX()+
cda-1)then __b=cca:getX()+cda-1 end;local a_b=(dd-ad<dda and dd-ad or dd-ad-1)if
(__b<1)then __b=0 end
_da:setCursor(true,ada+__b,bda+a_b,cca:getForeground())cca:updateDraw()return true end end,dragHandler=function(cca,dca,_da,ada)
if
(dc.dragHandler(cca,dca,_da,ada))then local bda=cca:getParent()local cda,dda=cca:getAbsolutePosition()
local __b,a_b=cca:getPosition()local b_b,c_b=cca:getSize()
if(__a[ada-dda+ad]~=nil)then
if
(_da-cda+bd>0)and(_da-cda+bd<=b_b)then cd=_da-cda+bd
dd=ada-dda+ad
if cd>__a[dd]:len()then cd=__a[dd]:len()+1 end;aaa=cd;caa=dd;if cd<bd then bd=cd-1;if bd<1 then bd=1 end end
bda:setCursor(not
aba(),__b+cd-bd,a_b+dd-ad,cca:getForeground())cca:updateDraw()end end;return true end end,scrollHandler=function(cca,dca,_da,ada)
if
(dc.scrollHandler(cca,dca,_da,ada))then local bda=cca:getParent()local cda,dda=cca:getAbsolutePosition()
local __b,a_b=cca:getPosition()local b_b,c_b=cca:getSize()ad=ad+dca;if(ad>#__a- (c_b-1))then
ad=#__a- (c_b-1)end;if(ad<1)then ad=1 end
if(cda+cd-bd>=cda and cda+cd-bd<
cda+b_b)and
(a_b+dd-ad>=a_b and a_b+dd-ad<a_b+c_b)then
bda:setCursor(not aba(),__b+cd-bd,a_b+dd-ad,cca:getForeground())else bda:setCursor(false)end;cca:updateDraw()return true end end,mouseHandler=function(cca,dca,_da,ada)
if
(dc.mouseHandler(cca,dca,_da,ada))then local bda=cca:getParent()local cda,dda=cca:getAbsolutePosition()
local __b,a_b=cca:getPosition()
if(__a[ada-dda+ad]~=nil)then cd=_da-cda+bd;dd=ada-dda+ad;aaa=
nil;caa=nil;_aa=cd;baa=dd;if(cd>__a[dd]:len())then
cd=__a[dd]:len()+1;_aa=cd end
if(cd<bd)then bd=cd-1;if(bd<1)then bd=1 end end;cca:updateDraw()end
bda:setCursor(true,__b+cd-bd,a_b+dd-ad,cca:getForeground())return true end end,mouseUpHandler=function(cca,dca,_da,ada)
if
(dc.mouseUpHandler(cca,dca,_da,ada))then local bda,cda=cca:getAbsolutePosition()
if
(__a[ada-cda+ad]~=nil)then aaa=_da-bda+bd;caa=ada-cda+ad;if(aaa>__a[caa]:len())then aaa=
__a[caa]:len()+1 end;if(_aa==aaa)and(baa==caa)then _aa,aaa,baa,caa=
nil,nil,nil,nil end
cca:updateDraw()end;return true end end,eventHandler=function(cca,dca,_da,...)
dc.eventHandler(cca,dca,_da,...)
if(dca=="paste")then
if(cca:isFocused())then local ada=cca:getParent()
local bda,cda=cca:getForeground(),cca:getBackground()local dda,__b=cca:getSize()
__a[dd]=__a[dd]:sub(1,cd-1).._da..
__a[dd]:sub(cd,__a[dd]:len())
b_a[dd]=b_a[dd]:sub(1,cd-1)..ab[bda]:rep(_da:len())..
b_a[dd]:sub(cd,b_a[dd]:len())
a_a[dd]=a_a[dd]:sub(1,cd-1)..ab[cda]:rep(_da:len())..
a_a[dd]:sub(cd,a_a[dd]:len())cd=cd+_da:len()if(cd>=dda+bd)then bd=(cd+1)-dda end
local a_b,b_b=cca:getPosition()
ada:setCursor(true,a_b+cd-bd,b_b+dd-ad,bda)_ca(cca)cca:updateDraw()end end end,draw=function(cca)
dc.draw(cca)
cca:addDraw("textfield",function()local dca,_da=cca:getSize()
local ada=ab[cca:getBackground()]local bda=ab[cca:getForeground()]
for n=1,_da do local cda=""local dda=""local __b=""if __a[
n+ad-1]then cda=__a[n+ad-1]__b=b_a[n+ad-1]
dda=a_a[n+ad-1]end;cda=_c(cda,bd,dca+bd-1)
dda=bb(ada,dca)__b=bb(bda,dca)cca:addText(1,n,cda)cca:addBG(1,n,dda)
cca:addFG(1,n,__b)cca:addBlit(1,n,cda,__b,dda)end
if _aa and aaa and baa and caa then local cda,dda,__b,a_b=bba()
for n=__b,a_b do local b_b=#__a[n]
local c_b=0
if n==__b and n==a_b then c_b=cda-1 - (bd-1)b_b=
b_b- (cda-1 - (bd-1))- (b_b-dda+ (bd-1))elseif n==a_b then b_b=b_b- (
b_b-dda+ (bd-1))elseif n==__b then b_b=b_b- (cda-1)c_b=cda-1 -
(bd-1)end;local d_b=math.min(b_b,dca-c_b)
cca:addBG(1 +c_b,n,bb(ab[daa],d_b))cca:addFG(1 +c_b,n,bb(ab[_ba],d_b))end end end)end,load=function(cca)
cca:listenEvent("mouse_click")cca:listenEvent("mouse_up")
cca:listenEvent("mouse_scroll")cca:listenEvent("mouse_drag")
cca:listenEvent("key")cca:listenEvent("char")
cca:listenEvent("other_event")end}bca.__index=bca;return setmetatable(bca,dc)end end;return aa["main"]()