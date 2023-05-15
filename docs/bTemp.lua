local ba={}local ca=true;local da=require
local _b=function(bb)
for cb,db in pairs(ba)do
if(type(db)=="table")then for _c,ac in pairs(db)do if(_c==bb)then
return ac()end end else if(cb==bb)then return db()end end end;return da(bb)end
local ab=function(bb)if(bb~=nil)then return ba[bb]end;return ba end
ba["plugin"]=function(...)local bb={...}local cb={}local db={}
local _c=fs.getDir(bb[2]or"Basalt")local ac=fs.combine(_c,"plugins")
if(ca)then
for cc,dc in pairs(ab("plugins"))do
table.insert(db,cc)local _d=dc()
if(type(_d)=="table")then for ad,bd in pairs(_d)do
if(type(ad)=="string")then if(cb[ad]==nil)then
cb[ad]={}end;table.insert(cb[ad],bd)end end end end else
if(fs.exists(ac))then
for cc,dc in pairs(fs.list(ac))do table.insert(db,dc)
local _d=_b(dc:gsub(".lua",""))
if(type(_d)=="table")then for ad,bd in pairs(_d)do
if(type(ad)=="string")then
if(cb[ad]==nil)then cb[ad]={}end;table.insert(cb[ad],bd)end end end end end end;local function bc(cc)return cb[cc]end
return
{get=bc,getAvailablePlugins=function()return db end,addPlugin=function(cc)
if(fs.exists(cc))then
if(fs.isDir(cc))then
for dc,_d in
pairs(fs.list(cc))do table.insert(db,_d)
if
not(fs.isDir(fs.combine(cc,_d)))then local ad=_d:gsub(".lua","")local bd=_b(fs.combine(cc,ad))
if(
type(bd)=="table")then for cd,dd in pairs(bd)do
if(type(cd)=="string")then
if(cb[cd]==nil)then cb[cd]={}end;table.insert(cb[cd],dd)end end end end end else local dc=_b(cc:gsub(".lua",""))
table.insert(db,cc:match("[\\/]?([^\\/]-([^%.]+))$"))
if(type(dc)=="table")then for _d,ad in pairs(dc)do
if(type(_d)=="string")then
if(cb[_d]==nil)then cb[_d]={}end;table.insert(cb[_d],ad)end end end end end end,loadPlugins=function(cc,dc)
for _d,ad in
pairs(cc)do local bd=cb[_d]
if(bd~=nil)then
cc[_d]=function(...)local cd=ad(...)
for dd,__a in pairs(bd)do local a_a=__a(cd,dc,...)
a_a.__index=a_a;cd=setmetatable(a_a,cd)end;return cd end end end;return cc end}end
ba["main"]=function(...)local bb=_b("basaltEvent")()
local cb=_b("loadObjects")local db;local _c=_b("plugin")local ac=_b("utils")local bc=_b("basaltLogs")
local cc=ac.uuid;local dc=ac.wrapText;local _d=ac.tableCount;local ad=300;local bd=0;local cd=0;local dd={}
local __a=term.current()local a_a="1.7.0"
local b_a=fs.getDir(table.pack(...)[2]or"")local c_a,d_a,_aa,aaa,baa={},{},{},{},{}local caa,daa,_ba,aba;local bba={}if not term.isColor or
not term.isColor()then
error('Basalt requires an advanced (golden) computer to run.',0)end;local cba={}
for dcb,_db in
pairs(colors)do if(type(_db)=="number")then
cba[dcb]={__a.getPaletteColor(_db)}end end
local function dba()aba=false;__a.clear()__a.setCursorPos(1,1)
for dcb,_db in pairs(colors)do if(
type(_db)=="number")then
__a.setPaletteColor(_db,colors.packRGB(table.unpack(cba[dcb])))end end end
local function _ca(dcb)
assert(dcb~="function","Schedule needs a function in order to work!")
return function(...)local _db=coroutine.create(dcb)
local adb,bdb=coroutine.resume(_db,...)
if(adb)then table.insert(baa,_db)else bba.basaltError(bdb)end end end;bba.log=function(...)bc(...)end
local aca=function(dcb,_db)aaa[dcb]=_db end;local bca=function(dcb)return aaa[dcb]end
local cca={getDynamicValueEventSetting=function()
return bba.dynamicValueEvents end,getMainFrame=function()return caa end,setVariable=aca,getVariable=bca,setMainFrame=function(dcb)caa=dcb end,getActiveFrame=function()return daa end,setActiveFrame=function(dcb)
daa=dcb end,getFocusedObject=function()return _ba end,setFocusedObject=function(dcb)_ba=dcb end,getMonitorFrame=function(dcb)return _aa[dcb]or
monGroups[dcb][1]end,setMonitorFrame=function(dcb,_db,adb)
if(caa==_db)then caa=nil end
if(adb)then monGroups[dcb]={_db,sides}else _aa[dcb]=_db end;if(_db==nil)then monGroups[dcb]=nil end end,getTerm=function()return
__a end,schedule=_ca,stop=dba,debug=bba.debug,log=bba.log,getObjects=function()return db end,getObject=function(dcb)return db[dcb]end,getDirectory=function()return
b_a end}
local function dca(dcb)__a.clear()__a.setBackgroundColor(colors.black)
__a.setTextColor(colors.red)local _db,adb=__a.getSize()if(bba.logging)then bc(dcb,"Error")end;local bdb=dc(
"Basalt error: "..dcb,_db)local cdb=1;for ddb,__c in pairs(bdb)do
__a.setCursorPos(1,cdb)__a.write(__c)cdb=cdb+1 end;__a.setCursorPos(1,
cdb+1)aba=false end
local function _da(dcb,_db,adb,bdb,cdb)
if(#baa>0)then local ddb={}
for n=1,#baa do
if(baa[n]~=nil)then
if
(coroutine.status(baa[n])=="suspended")then
local __c,a_c=coroutine.resume(baa[n],dcb,_db,adb,bdb,cdb)if not(__c)then bba.basaltError(a_c)end else
table.insert(ddb,n)end end end
for n=1,#ddb do table.remove(baa,ddb[n]- (n-1))end end end
local function ada()if(aba==false)then return end;if(caa~=nil)then caa:render()
caa:updateTerm()end;for dcb,_db in pairs(_aa)do _db:render()
_db:updateTerm()end end;local bda,cda,dda=nil,nil,nil;local __b=nil
local function a_b(dcb,_db,adb,bdb)bda,cda,dda=_db,adb,bdb;if(__b==nil)then
__b=os.startTimer(ad/1000)end end
local function b_b()__b=nil;caa:hoverHandler(cda,dda,bda)daa=caa end;local c_b,d_b,_ab=nil,nil,nil;local aab=nil;local function bab()aab=nil;caa:dragHandler(c_b,d_b,_ab)
daa=caa end;local function cab(dcb,_db,adb,bdb)c_b,d_b,_ab=_db,adb,bdb
if(bd<50)then bab()else if(aab==nil)then aab=os.startTimer(
bd/1000)end end end
local dab=nil;local function _bb()dab=nil;ada()end
local function abb(dcb)if(cd<50)then ada()else if(dab==nil)then
dab=os.startTimer(cd/1000)end end end
local function bbb(dcb,...)local _db={...}if
(bb:sendEvent("basaltEventCycle",dcb,...)==false)then return end
if(dcb=="terminate")then bba.stop()end
if(caa~=nil)then
local adb={mouse_click=caa.mouseHandler,mouse_up=caa.mouseUpHandler,mouse_scroll=caa.scrollHandler,mouse_drag=cab,mouse_move=a_b}local bdb=adb[dcb]
if(bdb~=nil)then bdb(caa,...)_da(dcb,...)abb()return end end
if(dcb=="monitor_touch")then
for adb,bdb in pairs(_aa)do if
(bdb:mouseHandler(1,_db[2],_db[3],true,_db[1]))then daa=bdb end end;_da(dcb,...)abb()return end
if(daa~=nil)then
local adb={char=daa.charHandler,key=daa.keyHandler,key_up=daa.keyUpHandler}local bdb=adb[dcb]if(bdb~=nil)then if(dcb=="key")then c_a[_db[1]]=true elseif(dcb=="key_up")then
c_a[_db[1]]=false end;bdb(daa,...)_da(dcb,...)
abb()return end end
if(dcb=="timer")and(_db[1]==__b)then b_b()elseif
(dcb=="timer")and(_db[1]==aab)then bab()elseif(dcb=="timer")and(_db[1]==dab)then _bb()else for adb,bdb in pairs(d_a)do
bdb:eventHandler(dcb,...)end
for adb,bdb in pairs(_aa)do bdb:eventHandler(dcb,...)end;_da(dcb,...)abb()end end;local cbb=false;local dbb=false
local function _cb()
if not(cbb)then
for dcb,_db in pairs(dd)do
if(fs.exists(_db))then
if(fs.isDir(_db))then
local adb=fs.list(_db)
for bdb,cdb in pairs(adb)do
if not(fs.isDir(_db.."/"..cdb))then
local ddb=cdb:gsub(".lua","")
if
(ddb~="example.lua")and not(ddb:find(".disabled"))then
if(cb[ddb]==nil)then
cb[ddb]=_b(_db.."."..cdb:gsub(".lua",""))else error("Duplicate object name: "..ddb)end end end end else local adb=_db:gsub(".lua","")
if(cb[adb]==nil)then cb[adb]=_b(adb)else error(
"Duplicate object name: "..adb)end end end end;cbb=true end
if not(dbb)then db=_c.loadPlugins(cb,cca)local dcb=_c.get("basalt")
if
(dcb~=nil)then for adb,bdb in pairs(dcb)do
for cdb,ddb in pairs(bdb(bba))do bba[cdb]=ddb;cca[cdb]=ddb end end end;local _db=_c.get("basaltInternal")
if(_db~=nil)then for adb,bdb in pairs(_db)do for cdb,ddb in pairs(bdb(bba))do
cca[cdb]=ddb end end end;dbb=true end end
local function acb(dcb)_cb()
for adb,bdb in pairs(d_a)do if(bdb:getName()==dcb)then return nil end end;local _db=db["BaseFrame"](dcb,cca)_db:init()
_db:load()_db:draw()table.insert(d_a,_db)
if(caa==nil)and(_db:getName()~=
"basaltDebuggingFrame")then _db:show()end;return _db end
bba={basaltError=dca,logging=false,dynamicValueEvents=false,drawFrames=ada,log=bc,getVersion=function()return a_a end,memory=function()return
math.floor(collectgarbage("count")+0.5).."KB"end,addObject=function(dcb)if
(fs.exists(dcb))then table.insert(dd,dcb)end end,addPlugin=function(dcb)
_c.addPlugin(dcb)end,getAvailablePlugins=function()return _c.getAvailablePlugins()end,getAvailableObjects=function()
local dcb={}for _db,adb in pairs(cb)do table.insert(dcb,_db)end;return dcb end,setVariable=aca,getVariable=bca,setBaseTerm=function(dcb)
__a=dcb end,resetPalette=function()
for dcb,_db in pairs(colors)do if(type(_db)=="number")then end end end,setMouseMoveThrottle=function(dcb)
if(_HOST:find("CraftOS%-PC"))then if(
config.get("mouse_move_throttle")~=10)then
config.set("mouse_move_throttle",10)end
if(dcb<100)then ad=100 else ad=dcb end;return true end;return false end,setRenderingThrottle=function(dcb)if(
dcb<=0)then cd=0 else dab=nil;cd=dcb end end,setMouseDragThrottle=function(dcb)if
(dcb<=0)then bd=0 else aab=nil;bd=dcb end end,autoUpdate=function(dcb)aba=dcb;if(
dcb==nil)then aba=true end;local function _db()ada()while aba do
bbb(os.pullEventRaw())end end
while aba do
local adb,bdb=xpcall(_db,debug.traceback)if not(adb)then bba.basaltError(bdb)end end end,update=function(dcb,...)
if(
dcb~=nil)then local _db={...}
local adb,bdb=xpcall(function()bbb(dcb,table.unpack(_db))end,debug.traceback)if not(adb)then bba.basaltError(bdb)return end end end,stop=dba,stopUpdate=dba,isKeyDown=function(dcb)if(
c_a[dcb]==nil)then return false end;return c_a[dcb]end,getFrame=function(dcb)for _db,adb in
pairs(d_a)do if(adb.name==dcb)then return adb end end end,getActiveFrame=function()return
daa end,setActiveFrame=function(dcb)
if(dcb:getType()=="Container")then daa=dcb;return true end;return false end,getMainFrame=function()return caa end,onEvent=function(...)
for dcb,_db in
pairs(table.pack(...))do if(type(_db)=="function")then
bb:registerEvent("basaltEventCycle",_db)end end end,schedule=_ca,addFrame=acb,createFrame=acb,addMonitor=function(dcb)
_cb()
for adb,bdb in pairs(d_a)do if(bdb:getName()==dcb)then return nil end end;local _db=db["MonitorFrame"](dcb,cca)_db:init()
_db:load()_db:draw()table.insert(_aa,_db)return _db end,removeFrame=function(dcb)d_a[dcb]=
nil end,setProjectDir=function(dcb)b_a=dcb end}local bcb=_c.get("basalt")if(bcb~=nil)then
for dcb,_db in pairs(bcb)do for adb,bdb in pairs(_db(bba))do
bba[adb]=bdb;cca[adb]=bdb end end end
local ccb=_c.get("basaltInternal")if(ccb~=nil)then
for dcb,_db in pairs(ccb)do for adb,bdb in pairs(_db(bba))do cca[adb]=bdb end end end;return bba end;ba["objects"]={}
ba["objects"]["Frame"]=function(...)local bb=_b("utils")
local cb,db,_c,ac,bc=math.max,math.min,string.sub,string.rep,string.len
return
function(cc,dc)local _d=dc.getObject("Container")(cc,dc)local ad="Frame"
local bd;local cd=true;local dd,__a=0,0;_d:setSize(30,10)_d:setZIndex(10)
local a_a={getType=function()return ad end,isType=function(b_a,c_a)return

ad==c_a or _d.isType~=nil and _d.isType(c_a)or false end,getBase=function(b_a)
return _d end,getOffset=function(b_a)return dd,__a end,setOffset=function(b_a,c_a,d_a)dd=c_a or dd;__a=d_a or __a
b_a:updateDraw()return b_a end,setParent=function(b_a,c_a,...)
_d.setParent(b_a,c_a,...)bd=c_a;return b_a end,render=function(b_a)
if(_d.render~=nil)then
if
(b_a:isVisible())then _d.render(b_a)local c_a=b_a:getObjects()for d_a,_aa in ipairs(c_a)do
if(
_aa.element.render~=nil)then _aa.element:render()end end end end end,updateDraw=function(b_a)if(
bd~=nil)then bd:updateDraw()end;return b_a end,blit=function(b_a,c_a,d_a,_aa,aaa,baa)
local caa,daa=b_a:getPosition()local _ba,aba=bd:getOffset()caa=caa-_ba;daa=daa-aba
local bba,cba=b_a:getSize()
if d_a>=1 and d_a<=cba then
local dba=_c(_aa,cb(1 -c_a+1,1),cb(bba-c_a+1,1))
local _ca=_c(aaa,cb(1 -c_a+1,1),cb(bba-c_a+1,1))
local aca=_c(baa,cb(1 -c_a+1,1),cb(bba-c_a+1,1))
bd:blit(cb(c_a+ (caa-1),caa),daa+d_a-1,dba,_ca,aca)end end,setCursor=function(b_a,c_a,d_a,_aa,aaa)
local baa,caa=b_a:getPosition()local daa,_ba=b_a:getOffset()
bd:setCursor(c_a or false,(d_a or 0)+baa-1 -daa,(
_aa or 0)+caa-1 -_ba,aaa or colors.white)return b_a end}
for b_a,c_a in
pairs({"drawBackgroundBox","drawForegroundBox","drawTextBox"})do
a_a[c_a]=function(d_a,_aa,aaa,baa,caa,daa)local _ba,aba=d_a:getPosition()local bba,cba=bd:getOffset()
_ba=_ba-bba;aba=aba-cba
caa=(aaa<1 and(
caa+aaa>d_a:getHeight()and d_a:getHeight()or caa+aaa-1)or(
caa+
aaa>d_a:getHeight()and d_a:getHeight()-aaa+1 or caa))
baa=(_aa<1 and(baa+_aa>d_a:getWidth()and d_a:getWidth()or baa+
_aa-1)or(

baa+_aa>d_a:getWidth()and d_a:getWidth()-_aa+1 or baa))
bd[c_a](bd,cb(_aa+ (_ba-1),_ba),cb(aaa+ (aba-1),aba),baa,caa,daa)end end
for b_a,c_a in pairs({"setBG","setFG","setText"})do
a_a[c_a]=function(d_a,_aa,aaa,baa)
local caa,daa=d_a:getPosition()local _ba,aba=bd:getOffset()caa=caa-_ba;daa=daa-aba
local bba,cba=d_a:getSize()if(aaa>=1)and(aaa<=cba)then
bd[c_a](bd,cb(_aa+ (caa-1),caa),daa+aaa-1,_c(baa,cb(
1 -_aa+1,1),cb(bba-_aa+1,1)))end end end;a_a.__index=a_a;return setmetatable(a_a,_d)end end
ba["objects"]["MovableFrame"]=function(...)
local bb,cb,db,_c=math.max,math.min,string.sub,string.rep
return
function(ac,bc)local cc=bc.getObject("Frame")(ac,bc)local dc="MovableFrame"
local _d;local ad,bd,cd=0,0,false;local dd={{x1=1,x2="width",y1=1,y2=1}}
local __a={getType=function()return dc end,setDraggingMap=function(a_a,b_a)
dd=b_a;return a_a end,getDraggingMap=function(a_a)return dd end,isType=function(a_a,b_a)
return dc==b_a or(cc.isType~=nil and
cc.isType(b_a))or false end,getBase=function(a_a)return cc end,load=function(a_a)
cc.load(a_a)a_a:listenEvent("mouse_click")
a_a:listenEvent("mouse_up")a_a:listenEvent("mouse_drag")end,dragHandler=function(a_a,b_a,c_a,d_a)
if
(cc.dragHandler(a_a,b_a,c_a,d_a))then
if(cd)then local _aa,aaa=_d:getOffset()
_aa=_aa<0 and math.abs(_aa)or-_aa;aaa=aaa<0 and math.abs(aaa)or-aaa;local baa=1
local caa=1;baa,caa=_d:getAbsolutePosition()
a_a:setPosition(c_a+ad- (baa-1)+_aa,
d_a+bd- (caa-1)+aaa)a_a:updateDraw()end;return true end end,mouseHandler=function(a_a,b_a,c_a,d_a,...)
if
(cc.mouseHandler(a_a,b_a,c_a,d_a,...))then _d:setImportant(a_a)local _aa,aaa=a_a:getAbsolutePosition()
local baa,caa=a_a:getSize()
for daa,_ba in pairs(dd)do local aba,bba=_ba.x1 =="width"and baa or _ba.x1,_ba.x2 =="width"and
baa or _ba.x2;local cba,dba=
_ba.y1 =="height"and caa or _ba.y1,
_ba.y2 =="height"and caa or _ba.y2
if
(c_a>=
_aa+aba-1)and(c_a<=_aa+bba-1)and(d_a>=aaa+cba-1)and(d_a<=aaa+dba-1)then cd=true
ad=_aa-c_a;bd=aaa-d_a;return true end end;return true end end,mouseUpHandler=function(a_a,...)
cd=false;return cc.mouseUpHandler(a_a,...)end,setParent=function(a_a,b_a,...)
cc.setParent(a_a,b_a,...)_d=b_a;return a_a end}__a.__index=__a;return setmetatable(__a,cc)end end
ba["objects"]["Graph"]=function(...)
return
function(bb,cb)
local db=cb.getObject("ChangeableObject")(bb,cb)local _c="Graph"db:setZIndex(5)db:setSize(30,10)local ac={}
local bc=colors.gray;local cc="\7"local dc=colors.black;local _d=100;local ad=0;local bd="line"local cd=10
local dd={getType=function(__a)return _c end,setGraphColor=function(__a,a_a)bc=
a_a or bc;__a:updateDraw()return __a end,setGraphSymbol=function(__a,a_a,b_a)cc=
a_a or cc;dc=b_a or dc;__a:updateDraw()return __a end,getGraphSymbol=function(__a)return
cc,dc end,addDataPoint=function(__a,a_a)if a_a>=ad and a_a<=_d then table.insert(ac,a_a)
__a:updateDraw()end
if(#ac>100)then table.remove(ac,1)end;return __a end,setMaxValue=function(__a,a_a)
_d=a_a;__a:updateDraw()return __a end,getMaxValue=function(__a)return _d end,setMinValue=function(__a,a_a)
ad=a_a;__a:updateDraw()return __a end,getMinValue=function(__a)return ad end,setGraphType=function(__a,a_a)if
a_a=="scatter"or a_a=="line"or a_a=="bar"then bd=a_a
__a:updateDraw()end;return __a end,setMaxEntries=function(__a,a_a)
cd=a_a;__a:updateDraw()return __a end,getMaxEntries=function(__a)return cd end,clear=function(__a)
ac={}__a:updateDraw()return __a end,draw=function(__a)db.draw(__a)
__a:addDraw("graph",function()
local a_a,b_a=__a:getPosition()local c_a,d_a=__a:getSize()
local _aa,aaa=__a:getBackground(),__a:getForeground()local baa=_d-ad;local caa,daa;local _ba=#ac-cd+1;if _ba<1 then _ba=1 end
for i=_ba,#ac do local aba=ac[i]
local bba=math.floor(( (
c_a-1)/ (cd-1))* (i-_ba)+1.5)
local cba=math.floor((d_a-1)- ( (d_a-1)/baa)* (aba-ad)+1.5)
if bd=="scatter"then __a:addBackgroundBox(bba,cba,1,1,bc)
__a:addForegroundBox(bba,cba,1,1,dc)__a:addTextBox(bba,cba,1,1,cc)elseif bd=="line"then
if caa and daa then
local dba=math.abs(bba-caa)local _ca=math.abs(cba-daa)local aca=caa<bba and 1 or-1;local bca=daa<
cba and 1 or-1;local cca=dba-_ca
while true do
__a:addBackgroundBox(caa,daa,1,1,bc)__a:addForegroundBox(caa,daa,1,1,dc)
__a:addTextBox(caa,daa,1,1,cc)if caa==bba and daa==cba then break end;local dca=2 *cca;if dca>-_ca then
cca=cca-_ca;caa=caa+aca end
if dca<dba then cca=cca+dba;daa=daa+bca end end end;caa,daa=bba,cba elseif bd=="bar"then
__a:addBackgroundBox(bba-1,cba,1,d_a-cba,bc)end end end)end}dd.__index=dd;return setmetatable(dd,db)end end
ba["objects"]["Flexbox"]=function(...)
return
function(bb,cb)
local db=cb.getObject("Frame")(bb,cb)local _c="Flexbox"local ac="row"local bc="flex-start"local cc="flex-start"local dc=1
local function _d(cd,dd)
local __a,a_a=cd:getSize()local b_a,c_a=dd.element:getSize()
local d_a=ac=="row"and a_a-c_a or __a-b_a;local _aa=1
if cc=="center"then _aa=1 +d_a/2 elseif cc=="flex-end"then _aa=1 +d_a end;return _aa end
local function ad(cd)local dd=cd:getObjects()local __a=#dd;local a_a,b_a=cd:getSize()local c_a=0
for aaa,baa in
ipairs(dd)do local caa,daa=baa.element:getSize()if ac=="row"then c_a=c_a+caa else
c_a=c_a+daa end end
local d_a=(ac=="row"and a_a or b_a)-c_a- (dc* (__a-1))local _aa=1;if bc=="center"then _aa=1 +d_a/2 elseif bc=="flex-end"then
_aa=1 +mainAxisvailableSpace end
for aaa,baa in ipairs(dd)do local caa=_d(cd,baa)
if ac==
"row"then baa.element:setPosition(_aa,caa)
local daa,_ba=baa.element:getSize()_aa=_aa+daa+dc else
baa.element:setPosition(caa,math.floor(_aa+0.5))local daa,_ba=baa.element:getSize()_aa=_aa+_ba+dc end end end
local bd={getType=function()return _c end,isType=function(cd,dd)return
_c==dd or db.getBase(cd).isType(dd)or false end,setSpacing=function(cd,dd)
dc=dd;ad(cd)return cd end,getSpacing=function(cd)return dc end,setFlexDirection=function(cd,dd)if
dd=="row"or dd=="column"then ac=dd;ad(cd)end;return cd end,setJustifyContent=function(cd,dd)if


dd=="flex-start"or dd=="flex-end"or dd=="center"or dd=="space-between"or dd=="space-around"then bc=dd;ad(cd)end
return cd end,setAlignItems=function(cd,dd)if
dd==
"flex-start"or dd=="flex-end"or dd=="center"or dd==
"space-between"or dd=="space-around"then cc=dd;ad(cd)end
return cd end}for cd,dd in pairs(cb.getObjects())do
bd["add"..cd]=function(__a,a_a)
local b_a=db["add"..cd](__a,a_a)ad(db)return b_a end end
bd.__index=bd;return setmetatable(bd,db)end end
ba["objects"]["Button"]=function(...)local bb=_b("utils")local cb=_b("tHex")
return
function(db,_c)
local ac=_c.getObject("VisualObject")(db,_c)local bc="Button"local cc="center"local dc="center"local _d="Button"ac:setSize(12,3)
ac:setZIndex(5)
local ad={getType=function(bd)return bc end,isType=function(bd,cd)return
bc==cd or ac.isType~=nil and ac.isType(cd)or false end,getBase=function(bd)return
ac end,setHorizontalAlign=function(bd,cd)cc=cd;bd:updateDraw()return bd end,setVerticalAlign=function(bd,cd)
dc=cd;bd:updateDraw()return bd end,setText=function(bd,cd)_d=cd
bd:updateDraw()return bd end,draw=function(bd)ac.draw(bd)
bd:addDraw("button",function()
local cd,dd=bd:getSize()local __a=bb.getTextVerticalAlign(dd,dc)local a_a;if(cc=="center")then a_a=math.floor((
cd-_d:len())/2)elseif(cc=="right")then
a_a=cd-_d:len()end
bd:addText(a_a+1,__a,_d)
bd:addFG(a_a+1,__a,cb[bd:getForeground()or colors.white]:rep(_d:len()))end)end}ad.__index=ad;return setmetatable(ad,ac)end end
ba["objects"]["Object"]=function(...)local bb=_b("basaltEvent")
local cb=_b("utils")local db=cb.uuid;local _c,ac=table.unpack,string.sub
return
function(bc,cc)bc=bc or db()
assert(cc~=nil,
"Unable to find basalt instance! ID: "..bc)local dc="Object"local _d,ad=true,false;local bd=bb()local cd={}local dd
local __a={init=function(a_a)if(ad)then return false end
ad=true;return true end,load=function(a_a)end,getType=function(a_a)return dc end,isType=function(a_a,b_a)
return dc==b_a end,getName=function(a_a)return bc end,getParent=function(a_a)return dd end,setParent=function(a_a,b_a,c_a)
if(c_a)then dd=b_a;return a_a end
if(b_a.getType~=nil and b_a:isType("Container"))then
a_a:remove()b_a:addObject(a_a)if(a_a.show)then a_a:show()end;dd=b_a end;return a_a end,updateEvents=function(a_a)for b_a,c_a in
pairs(cd)do dd:removeEvent(b_a,a_a)
if(c_a)then dd:addEvent(b_a,a_a)end end;return a_a end,listenEvent=function(a_a,b_a,c_a)if(
dd~=nil)then
if(c_a)or(c_a==nil)then cd[b_a]=true;dd:addEvent(b_a,a_a)elseif
(c_a==false)then cd[b_a]=false;dd:removeEvent(b_a,a_a)end end
return a_a end,getZIndex=function(a_a)return
1 end,enable=function(a_a)_d=true;return a_a end,disable=function(a_a)_d=false;return a_a end,isEnabled=function(a_a)return
_d end,remove=function(a_a)if(dd~=nil)then dd:removeObject(a_a)
dd:removeEvents(a_a)end;a_a:updateDraw()return a_a end,getBaseFrame=function(a_a)if(
dd~=nil)then return dd:getBaseFrame()end;return a_a end,onEvent=function(a_a,...)
for b_a,c_a in
pairs(table.pack(...))do if(type(c_a)=="function")then
a_a:registerEvent("other_event",c_a)end end;return a_a end,getEventSystem=function(a_a)return
bd end,registerEvent=function(a_a,b_a,c_a)if(dd~=nil)then dd:addEvent(b_a,a_a)end;return
bd:registerEvent(b_a,c_a)end,removeEvent=function(a_a,b_a,c_a)if(
bd:getEventCount(b_a)<1)then
if(dd~=nil)then dd:removeEvent(b_a,a_a)end end
return bd:removeEvent(b_a,c_a)end,eventHandler=function(a_a,b_a,...)
local c_a=a_a:sendEvent("other_event",b_a,...)if(c_a~=nil)then return c_a end end,customEventHandler=function(a_a,b_a,...)
local c_a=a_a:sendEvent("custom_event",b_a,...)if(c_a~=nil)then return c_a end;return true end,sendEvent=function(a_a,b_a,...)if(
b_a=="other_event")or(b_a=="custom_event")then return
bd:sendEvent(b_a,a_a,...)end;return
bd:sendEvent(b_a,a_a,b_a,...)end,onClick=function(a_a,...)
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
ba["objects"]["BaseFrame"]=function(...)local bb=_b("basaltDraw")
local cb=_b("utils")local db,_c,ac,bc=math.max,math.min,string.sub,string.rep
return
function(cc,dc)
local _d=dc.getObject("Container")(cc,dc)local ad="BaseFrame"local bd,cd=0,0;local dd={}local __a=true;local a_a=dc.getTerm()
local b_a=bb(a_a)local c_a,d_a,_aa,aaa=1,1,false,colors.white
local baa={getType=function()return ad end,isType=function(caa,daa)
return ad==daa or _d.isType~=nil and
_d.isType(daa)or false end,getBase=function(caa)return _d end,getOffset=function(caa)return bd,cd end,setOffset=function(caa,daa,_ba)bd=
daa or bd;cd=_ba or cd;caa:updateDraw()return caa end,setPalette=function(caa,daa,...)
if(
caa==dc.getActiveFrame())then
if(type(daa)=="string")then dd[daa]=...
a_a.setPaletteColor(
type(daa)=="number"and daa or colors[daa],...)elseif(type(daa)=="table")then
for _ba,aba in pairs(daa)do dd[_ba]=aba
if(type(aba)=="number")then
a_a.setPaletteColor(
type(_ba)=="number"and _ba or colors[_ba],aba)else local bba,cba,dba=table.unpack(aba)
a_a.setPaletteColor(
type(_ba)=="number"and _ba or colors[_ba],bba,cba,dba)end end end end;return caa end,setSize=function(caa,...)
_d.setSize(caa,...)b_a=bb(a_a)return caa end,getSize=function()return a_a.getSize()end,getWidth=function(caa)return
({a_a.getSize()})[1]end,getHeight=function(caa)
return({a_a.getSize()})[2]end,show=function(caa)_d.show(caa)dc.setActiveFrame(caa)
for daa,_ba in
pairs(colors)do if(type(_ba)=="number")then
a_a.setPaletteColor(_ba,colors.packRGB(term.nativePaletteColor((_ba))))end end
for daa,_ba in pairs(dd)do
if(type(_ba)=="number")then
a_a.setPaletteColor(
type(daa)=="number"and daa or colors[daa],_ba)else local aba,bba,cba=table.unpack(_ba)
a_a.setPaletteColor(
type(daa)=="number"and daa or colors[daa],aba,bba,cba)end end;dc.setMainFrame(caa)return caa end,render=function(caa)
if(
_d.render~=nil)then
if(caa:isVisible())then
if(__a)then _d.render(caa)
local daa=caa:getObjects()for _ba,aba in ipairs(daa)do if(aba.element.render~=nil)then
aba.element:render()end end
__a=false end end end end,updateDraw=function(caa)
__a=true;return caa end,eventHandler=function(caa,daa,...)_d.eventHandler(caa,daa,...)if
(daa=="term_resize")then caa:setSize(a_a.getSize())end end,updateTerm=function(caa)if(
b_a~=nil)then b_a.update()end end,setTerm=function(caa,daa)a_a=daa;if(daa==
nil)then b_a=nil else b_a=bb(a_a)end;return caa end,getTerm=function()return
a_a end,blit=function(caa,daa,_ba,aba,bba,cba)local dba,_ca=caa:getPosition()
local aca,bca=caa:getSize()
if _ba>=1 and _ba<=bca then
local cca=ac(aba,db(1 -daa+1,1),db(aca-daa+1,1))
local dca=ac(bba,db(1 -daa+1,1),db(aca-daa+1,1))
local _da=ac(cba,db(1 -daa+1,1),db(aca-daa+1,1))
b_a.blit(db(daa+ (dba-1),dba),_ca+_ba-1,cca,dca,_da)end end,setCursor=function(caa,daa,_ba,aba,bba)
local cba,dba=caa:getAbsolutePosition()local _ca,aca=caa:getOffset()_aa=daa or false;if(_ba~=nil)then
c_a=cba+_ba-1 -_ca end
if(aba~=nil)then d_a=dba+aba-1 -aca end;aaa=bba or aaa
if(_aa)then a_a.setTextColor(aaa)
a_a.setCursorPos(c_a,d_a)a_a.setCursorBlink(_aa)else a_a.setCursorBlink(false)end;return caa end}
for caa,daa in
pairs({mouse_click={"mouseHandler",true},mouse_up={"mouseUpHandler",false},mouse_drag={"dragHandler",false},mouse_scroll={"scrollHandler",true},mouse_hover={"hoverHandler",false}})do
baa[daa[1]]=function(_ba,aba,bba,cba,...)if(_d[daa[1]](_ba,aba,bba,cba,...))then
dc.setActiveFrame(_ba)end end end
for caa,daa in
pairs({"drawBackgroundBox","drawForegroundBox","drawTextBox"})do
baa[daa]=function(_ba,aba,bba,cba,dba,_ca)local aca,bca=_ba:getPosition()local cca,dca=_ba:getSize()
dba=(bba<1 and(dba+
bba>_ba:getHeight()and _ba:getHeight()or dba+bba-
1)or(dba+bba>
_ba:getHeight()and _ba:getHeight()-bba+1 or
dba))
cba=(aba<1 and(cba+aba>_ba:getWidth()and _ba:getWidth()or cba+
aba-1)or(

cba+aba>_ba:getWidth()and _ba:getWidth()-aba+1 or cba))
b_a[daa](db(aba+ (aca-1),aca),db(bba+ (bca-1),bca),cba,dba,_ca)end end
for caa,daa in pairs({"setBG","setFG","setText"})do
baa[daa]=function(_ba,aba,bba,cba)
local dba,_ca=_ba:getPosition()local aca,bca=_ba:getSize()if(bba>=1)and(bba<=bca)then
b_a[daa](db(aba+ (dba-1),dba),
_ca+bba-1,ac(cba,db(1 -aba+1,1),db(aca-aba+1,1)))end end end;baa.__index=baa;return setmetatable(baa,_d)end end
ba["objects"]["Progressbar"]=function(...)
return
function(bb,cb)
local db=cb.getObject("ChangeableObject")(bb,cb)local _c="Progressbar"local ac=0;db:setZIndex(5)db:setValue(false)
db:setSize(25,3)local bc=colors.black;local cc=""local dc=colors.white;local _d=""local ad=0
local bd={getType=function(cd)return _c end,setDirection=function(cd,dd)
ad=dd;cd:updateDraw()return cd end,setProgressBar=function(cd,dd,__a,a_a)bc=dd or bc
cc=__a or cc;dc=a_a or dc;cd:updateDraw()return cd end,getProgressBar=function(cd)return
bc,cc,dc end,setBackgroundSymbol=function(cd,dd)_d=dd:sub(1,1)cd:updateDraw()return cd end,setProgress=function(cd,dd)
if(
dd>=0)and(dd<=100)and(ac~=dd)then ac=dd;cd:setValue(ac)if
(ac==100)then cd:progressDoneHandler()end end;cd:updateDraw()return cd end,getProgress=function(cd)return
ac end,onProgressDone=function(cd,dd)cd:registerEvent("progress_done",dd)
return cd end,progressDoneHandler=function(cd)
cd:sendEvent("progress_done")end,draw=function(cd)db.draw(cd)
cd:addDraw("progressbar",function()
local dd,__a=cd:getPosition()local a_a,b_a=cd:getSize()
local c_a,d_a=cd:getBackground(),cd:getForeground()
if(c_a~=false)then cd:addBackgroundBox(1,1,a_a,b_a,c_a)end;if(_d~="")then cd:addTextBox(1,1,a_a,b_a,_d)end
if
(d_a~=false)then cd:addForegroundBox(1,1,a_a,b_a,d_a)end
if(ad==1)then cd:addBackgroundBox(1,1,a_a,b_a/100 *ac,bc)cd:addForegroundBox(1,1,a_a,
b_a/100 *ac,dc)
cd:addTextBox(1,1,a_a,b_a/100 *ac,cc)elseif(ad==3)then
cd:addBackgroundBox(1,1 +math.ceil(b_a-b_a/100 *ac),a_a,
b_a/100 *ac,bc)
cd:addForegroundBox(1,1 +math.ceil(b_a-b_a/100 *ac),a_a,
b_a/100 *ac,dc)
cd:addTextBox(1,1 +math.ceil(b_a-b_a/100 *ac),a_a,b_a/100 *ac,cc)elseif(ad==2)then
cd:addBackgroundBox(1 +math.ceil(a_a-a_a/100 *ac),1,a_a/
100 *ac,b_a,bc)
cd:addForegroundBox(1 +math.ceil(a_a-a_a/100 *ac),1,a_a/100 *ac,b_a,dc)
cd:addTextBox(1 +math.ceil(a_a-a_a/100 *ac),1,a_a/100 *ac,b_a,cc)else
cd:addBackgroundBox(1,1,math.ceil(a_a/100 *ac),b_a,bc)
cd:addForegroundBox(1,1,math.ceil(a_a/100 *ac),b_a,dc)
cd:addTextBox(1,1,math.ceil(a_a/100 *ac),b_a,cc)end end)end}bd.__index=bd;return setmetatable(bd,db)end end
ba["objects"]["ChangeableObject"]=function(...)
return
function(bb,cb)
local db=cb.getObject("VisualObject")(bb,cb)local _c="ChangeableObject"local ac
local bc={setValue=function(cc,dc,_d)if(ac~=dc)then ac=dc;cc:updateDraw()if(_d~=false)then
cc:valueChangedHandler()end end;return cc end,getValue=function(cc)return
ac end,onChange=function(cc,...)
for dc,_d in pairs(table.pack(...))do if(type(_d)=="function")then
cc:registerEvent("value_changed",_d)end end;return cc end,valueChangedHandler=function(cc)
cc:sendEvent("value_changed",ac)end}bc.__index=bc;return setmetatable(bc,db)end end
ba["objects"]["Label"]=function(...)local bb=_b("utils")local cb=bb.wrapText
local db=bb.writeWrappedText;local _c=_b("tHex")
return
function(ac,bc)
local cc=bc.getObject("VisualObject")(ac,bc)local dc="Label"cc:setZIndex(3)cc:setSize(5,1)
cc:setBackground(false)local _d=true;local ad,bd="Label","left"
local cd={getType=function(dd)return dc end,getBase=function(dd)return cc end,setText=function(dd,__a)
ad=tostring(__a)
if(_d)then local a_a=cb(ad,#ad)local b_a,c_a=1,1;for d_a,_aa in pairs(a_a)do c_a=c_a+1
b_a=math.max(b_a,_aa:len())end;dd:setSize(b_a,c_a)_d=true end;dd:updateDraw()return dd end,getAutoSize=function(dd)return
_d end,setAutoSize=function(dd,__a)_d=__a;return dd end,getText=function(dd)return ad end,setSize=function(dd,__a,a_a)
cc.setSize(dd,__a,a_a)_d=false;return dd end,setTextAlign=function(dd,__a)bd=__a or bd;return dd end,draw=function(dd)
cc.draw(dd)
dd:addDraw("label",function()local __a,a_a=dd:getSize()
local b_a=
bd=="center"and math.floor(
__a/2 -ad:len()/2 +0.5)or bd=="right"and __a- (
ad:len()-1)or 1;db(dd,b_a,1,ad,__a+1,a_a)end)end,init=function(dd)
cc.init(dd)local __a=dd:getParent()
dd:setForeground(__a:getForeground())end}cd.__index=cd;return setmetatable(cd,cc)end end
ba["objects"]["Checkbox"]=function(...)local bb=_b("utils")local cb=_b("tHex")
return
function(db,_c)
local ac=_c.getObject("ChangeableObject")(db,_c)local bc="Checkbox"ac:setZIndex(5)ac:setValue(false)
ac:setSize(1,1)local cc,dc,_d,ad="\42"," ","","right"
local bd={load=function(cd)cd:listenEvent("mouse_click",cd)
cd:listenEvent("mouse_up",cd)end,getType=function(cd)return bc end,isType=function(cd,dd)return
bc==dd or
ac.isType~=nil and ac.isType(dd)or false end,setSymbol=function(cd,dd,__a)
cc=dd or cc;dc=__a or dc;cd:updateDraw()return cd end,getSymbol=function(cd)return
cc,dc end,setText=function(cd,dd)_d=dd;return cd end,setTextPosition=function(cd,dd)ad=dd or ad;return cd end,setChecked=ac.setValue,mouseHandler=function(cd,dd,__a,a_a)
if
(ac.mouseHandler(cd,dd,__a,a_a))then
if(dd==1)then if
(cd:getValue()~=true)and(cd:getValue()~=false)then cd:setValue(false)else
cd:setValue(not cd:getValue())end
cd:updateDraw()return true end end;return false end,draw=function(cd)
ac.draw(cd)
cd:addDraw("checkbox",function()local dd,__a=cd:getPosition()local a_a,b_a=cd:getSize()
local c_a=bb.getTextVerticalAlign(b_a,"center")local d_a,_aa=cd:getBackground(),cd:getForeground()
if
(cd:getValue())then
cd:addBlit(1,c_a,bb.getTextHorizontalAlign(cc,a_a,"center"),cb[_aa],cb[d_a])else
cd:addBlit(1,c_a,bb.getTextHorizontalAlign(dc,a_a,"center"),cb[_aa],cb[d_a])end;if(_d~="")then local aaa=ad=="left"and-_d:len()or 3
cd:addText(aaa,c_a,_d)end end)end}bd.__index=bd;return setmetatable(bd,ac)end end
ba["objects"]["List"]=function(...)local bb=_b("utils")local cb=_b("tHex")
return
function(db,_c)
local ac=_c.getObject("ChangeableObject")(db,_c)local bc="List"local cc={}local dc=colors.black;local _d=colors.lightGray;local ad=true
local bd="left"local cd=0;local dd=true;ac:setSize(16,8)ac:setZIndex(5)
local __a={init=function(a_a)
local b_a=a_a:getParent()a_a:listenEvent("mouse_click")
a_a:listenEvent("mouse_drag")a_a:listenEvent("mouse_scroll")return ac.init(a_a)end,getBase=function(a_a)return
ac end,setTextAlign=function(a_a,b_a)bd=b_a;return a_a end,getTextAlign=function(a_a)return bd end,getBase=function(a_a)return ac end,getType=function(a_a)return
bc end,isType=function(a_a,b_a)return
bc==b_a or ac.isType~=nil and ac.isType(b_a)or false end,addItem=function(a_a,b_a,c_a,d_a,...)
table.insert(cc,{text=b_a,bgCol=
c_a or a_a:getBackground(),fgCol=d_a or a_a:getForeground(),args={...}})if(#cc<=1)then a_a:setValue(cc[1],false)end
a_a:updateDraw()return a_a end,setOptions=function(a_a,...)
cc={}
for b_a,c_a in pairs(...)do
if(type(c_a)=="string")then
table.insert(cc,{text=c_a,bgCol=a_a:getBackground(),fgCol=a_a:getForeground(),args={}})else
table.insert(cc,{text=c_a[1],bgCol=c_a[2]or a_a:getBackground(),fgCol=c_a[3]or
a_a:getForeground(),args=c_a[4]or{}})end end;a_a:setValue(cc[1],false)a_a:updateDraw()return a_a end,setOffset=function(a_a,b_a)
cd=b_a;a_a:updateDraw()return a_a end,getOffset=function(a_a)return cd end,removeItem=function(a_a,b_a)
if(
type(b_a)=="number")then table.remove(cc,b_a)elseif(type(b_a)=="table")then
for c_a,d_a in
pairs(cc)do if(d_a==b_a)then table.remove(cc,c_a)break end end end;a_a:updateDraw()return a_a end,getItem=function(a_a,b_a)return
cc[b_a]end,getAll=function(a_a)return cc end,getOptions=function(a_a)return cc end,getItemIndex=function(a_a)
local b_a=a_a:getValue()for c_a,d_a in pairs(cc)do if(d_a==b_a)then return c_a end end end,clear=function(a_a)
cc={}a_a:setValue({},false)a_a:updateDraw()return a_a end,getItemCount=function(a_a)return
#cc end,editItem=function(a_a,b_a,c_a,d_a,_aa,...)table.remove(cc,b_a)
table.insert(cc,b_a,{text=c_a,bgCol=d_a or
a_a:getBackground(),fgCol=_aa or a_a:getForeground(),args={...}})a_a:updateDraw()return a_a end,selectItem=function(a_a,b_a)a_a:setValue(
cc[b_a]or{},false)a_a:updateDraw()return a_a end,setSelectionColor=function(a_a,b_a,c_a,d_a)dc=
b_a or a_a:getBackground()
_d=c_a or a_a:getForeground()ad=d_a~=nil and d_a or true;a_a:updateDraw()
return a_a end,getSelectionColor=function(a_a)
return dc,_d end,isSelectionColorActive=function(a_a)return ad end,setScrollable=function(a_a,b_a)dd=b_a;if(b_a==nil)then dd=true end
a_a:updateDraw()return a_a end,scrollHandler=function(a_a,b_a,c_a,d_a)
if
(ac.scrollHandler(a_a,b_a,c_a,d_a))then
if(dd)then local _aa,aaa=a_a:getSize()cd=cd+b_a;if(cd<0)then cd=0 end
if(b_a>=1)then if(#cc>aaa)then if(cd>
#cc-aaa)then cd=#cc-aaa end;if(cd>=#cc)then cd=#cc-1 end else cd=
cd-1 end end;a_a:updateDraw()end;return true end;return false end,mouseHandler=function(a_a,b_a,c_a,d_a)
if
(ac.mouseHandler(a_a,b_a,c_a,d_a))then local _aa,aaa=a_a:getAbsolutePosition()local baa,caa=a_a:getSize()
if
(#cc>0)then
for n=1,caa do
if(cc[n+cd]~=nil)then if
(_aa<=c_a)and(_aa+baa>c_a)and(aaa+n-1 ==d_a)then a_a:setValue(cc[n+cd])a_a:selectHandler()
a_a:updateDraw()end end end end;return true end;return false end,dragHandler=function(a_a,b_a,c_a,d_a)return
a_a:mouseHandler(b_a,c_a,d_a)end,touchHandler=function(a_a,b_a,c_a)return
a_a:mouseHandler(1,b_a,c_a)end,onSelect=function(a_a,...)
for b_a,c_a in
pairs(table.pack(...))do if(type(c_a)=="function")then
a_a:registerEvent("select_item",c_a)end end;return a_a end,selectHandler=function(a_a)
a_a:sendEvent("select_item",a_a:getValue())end,draw=function(a_a)ac.draw(a_a)
a_a:addDraw("list",function()
local b_a,c_a=a_a:getSize()
for n=1,c_a do
if cc[n+cd]then local d_a=cc[n+cd].text
local _aa,aaa=cc[n+cd].fgCol,cc[n+cd].bgCol
if cc[n+cd]==a_a:getValue()and ad then _aa,aaa=_d,dc end;a_a:addText(1,n,d_a:sub(1,b_a))
a_a:addBG(1,n,cb[aaa]:rep(b_a))a_a:addFG(1,n,cb[_aa]:rep(b_a))end end end)end}__a.__index=__a;return setmetatable(__a,ac)end end
ba["objects"]["Input"]=function(...)local bb=_b("utils")local cb=_b("tHex")
return
function(db,_c)
local ac=_c.getObject("ChangeableObject")(db,_c)local bc="Input"local cc="text"local dc=0;ac:setZIndex(5)ac:setValue("")
ac:setSize(12,1)local _d=1;local ad=1;local bd=""local cd=colors.black;local dd=colors.lightGray;local __a=bd
local a_a=false
local b_a={load=function(c_a)c_a:listenEvent("mouse_click")
c_a:listenEvent("key")c_a:listenEvent("char")
c_a:listenEvent("other_event")c_a:listenEvent("mouse_drag")end,getType=function(c_a)return
bc end,isType=function(c_a,d_a)return
bc==d_a or ac.isType~=nil and ac.isType(d_a)or false end,setDefaultText=function(c_a,d_a,_aa,aaa)
bd=d_a;dd=_aa or dd;cd=aaa or cd
if(c_a:isFocused())then __a=""else __a=bd end;c_a:updateDraw()return c_a end,getDefaultText=function(c_a)return
bd,dd,cd end,setOffset=function(c_a,d_a)ad=d_a;c_a:updateDraw()return c_a end,getOffset=function(c_a)return
ad end,setTextOffset=function(c_a,d_a)_d=d_a;c_a:updateDraw()return c_a end,getTextOffset=function(c_a)return
_d end,setInputType=function(c_a,d_a)cc=d_a;c_a:updateDraw()return c_a end,getInputType=function(c_a)return
cc end,setValue=function(c_a,d_a)ac.setValue(c_a,tostring(d_a))
if not(a_a)then _d=
tostring(d_a):len()+1
ad=math.max(1,_d-c_a:getWidth()+1)
if(c_a:isFocused())then local _aa=c_a:getParent()
local aaa,baa=c_a:getPosition()
_aa:setCursor(true,aaa+_d-ad,baa+math.floor(c_a:getHeight()/2),c_a:getForeground())end end;c_a:updateDraw()return c_a end,getValue=function(c_a)
local d_a=ac.getValue(c_a)
return cc=="number"and tonumber(d_a)or d_a end,setInputLimit=function(c_a,d_a)
dc=tonumber(d_a)or dc;c_a:updateDraw()return c_a end,getInputLimit=function(c_a)return dc end,getFocusHandler=function(c_a)
ac.getFocusHandler(c_a)local d_a=c_a:getParent()
if(d_a~=nil)then local _aa,aaa=c_a:getPosition()__a=""if(
bd~="")then c_a:updateDraw()end
d_a:setCursor(true,_aa+_d-ad,aaa+math.max(math.ceil(
c_a:getHeight()/2 -1,1)),c_a:getForeground())end end,loseFocusHandler=function(c_a)
ac.loseFocusHandler(c_a)local d_a=c_a:getParent()__a=bd
if(bd~="")then c_a:updateDraw()end;d_a:setCursor(false)end,keyHandler=function(c_a,d_a)
if
(ac.keyHandler(c_a,d_a))then local _aa,aaa=c_a:getSize()local baa=c_a:getParent()a_a=true
if
(d_a==keys.backspace)then local aba=tostring(ac.getValue())
if(_d>1)then c_a:setValue(aba:sub(1,_d-2)..
aba:sub(_d,aba:len()))_d=math.max(
_d-1,1)if(_d<ad)then ad=math.max(ad-1,1)end end end
if(d_a==keys.enter)then baa:removeFocusedObject(c_a)end
if(d_a==keys.right)then
local aba=tostring(ac.getValue()):len()_d=_d+1;if(_d>aba)then _d=aba+1 end;_d=math.max(_d,1)if(_d<ad)or
(_d>=_aa+ad)then ad=_d-_aa+1 end;ad=math.max(ad,1)end;if(d_a==keys.left)then _d=_d-1;if(_d>=1)then
if(_d<ad)or(_d>=_aa+ad)then ad=_d end end;_d=math.max(_d,1)
ad=math.max(ad,1)end
local caa,daa=c_a:getPosition()local _ba=tostring(ac.getValue())c_a:updateDraw()
a_a=false;return true end end,charHandler=function(c_a,d_a)
if
(ac.charHandler(c_a,d_a))then a_a=true;local _aa,aaa=c_a:getSize()local baa=ac.getValue()
if(
baa:len()<dc or dc<=0)then
if(cc=="number")then local aba=baa
if
(_d==1 and d_a=="-")or(d_a==".")or(tonumber(d_a)~=nil)then
c_a:setValue(baa:sub(1,_d-1)..
d_a..baa:sub(_d,baa:len()))_d=_d+1;if(d_a==".")or(d_a=="-")and(#baa>0)then
if(
tonumber(ac.getValue())==nil)then c_a:setValue(aba)_d=_d-1 end end end else
c_a:setValue(baa:sub(1,_d-1)..d_a..baa:sub(_d,baa:len()))_d=_d+1 end;if(_d>=_aa+ad)then ad=ad+1 end end;local caa,daa=c_a:getPosition()
local _ba=tostring(ac.getValue())a_a=false;c_a:updateDraw()return true end end,mouseHandler=function(c_a,d_a,_aa,aaa)
if
(ac.mouseHandler(c_a,d_a,_aa,aaa))then local baa=c_a:getParent()local caa,daa=c_a:getPosition()
local _ba,aba=c_a:getAbsolutePosition(caa,daa)local bba,cba=c_a:getSize()_d=_aa-_ba+ad;local dba=ac.getValue()if(_d>
dba:len())then _d=dba:len()+1 end;if(_d<ad)then ad=_d-1
if(ad<1)then ad=1 end end
baa:setCursor(true,caa+_d-ad,daa+
math.max(math.ceil(cba/2 -1,1)),c_a:getForeground())return true end end,dragHandler=function(c_a,d_a,_aa,aaa,baa,caa)
if
(c_a:isFocused())then if(c_a:isCoordsInObject(_aa,aaa))then
if(ac.dragHandler(c_a,d_a,_aa,aaa,baa,caa))then return true end end
local daa=c_a:getParent()daa:removeFocusedObject()end end,draw=function(c_a)
ac.draw(c_a)
c_a:addDraw("input",function()local d_a=c_a:getParent()local _aa,aaa=c_a:getPosition()
local baa,caa=c_a:getSize()local daa=bb.getTextVerticalAlign(caa,textVerticalAlign)
local _ba=tostring(ac.getValue())local aba=c_a:getBackground()local bba=c_a:getForeground()local cba;if(
_ba:len()<=0)then cba=__a;aba=cd or aba;bba=dd or bba end
cba=__a;if(_ba~="")then cba=_ba end;cba=cba:sub(ad,baa+ad-1)local dba=baa-
cba:len()if(dba<0)then dba=0 end
if
(cc=="password")and(_ba~="")then cba=string.rep("*",cba:len())end;cba=cba..string.rep(" ",dba)
c_a:addBlit(1,daa,cba,cb[bba]:rep(cba:len()),cb[aba]:rep(cba:len()))if(c_a:isFocused())then
d_a:setCursor(true,_aa+_d-ad,aaa+
math.floor(c_a:getHeight()/2),c_a:getForeground())end end)end}b_a.__index=b_a;return setmetatable(b_a,ac)end end
ba["objects"]["Container"]=function(...)local bb=_b("utils")local cb=bb.tableCount
return
function(db,_c)
local ac=_c.getObject("VisualObject")(db,_c)local bc="Container"local cc={}local dc={}local _d={}local ad;local bd=true;local cd,dd=0,0
local __a=function(cba,dba)
if
cba.zIndex==dba.zIndex then return cba.objId<dba.objId else return cba.zIndex<dba.zIndex end end
local a_a=function(cba,dba)if cba.zIndex==dba.zIndex then return cba.evId>dba.evId else return
cba.zIndex>dba.zIndex end end
local function b_a(cba,dba)if(type(dba)=="table")then dba=dba:getName()end;for _ca,aca in
ipairs(cc)do
if aca.element:getName()==dba then return aca.element end end end
local function c_a(cba,dba)local _ca=b_a(dba)if(_ca~=nil)then return _ca end;for aca,bca in pairs(objects)do
if
(b:getType()=="Container")then local cca=b:getDeepObject(dba)if(cca~=nil)then return cca end end end end
local function d_a(cba,dba,_ca)if(b_a(dba:getName())~=nil)then return end;cd=cd+1
local aca=dba:getZIndex()
table.insert(cc,{element=dba,zIndex=aca,objId=cd})bd=false;dba:setParent(cba,true)
if(dba.init~=nil)then dba:init()end;if(dba.load~=nil)then dba:load()end;if(dba.draw~=nil)then
dba:draw()end;return dba end
local function _aa(cba,dba,_ca)cd=cd+1;dd=dd+1;for aca,bca in pairs(cc)do
if(bca.element==dba)then bca.zIndex=_ca;bca.objId=cd;break end end;for aca,bca in pairs(dc)do
for cca,dca in pairs(bca)do if
(dca.element==dba)then dca.zIndex=_ca;dca.evId=dd end end end;bd=false
cba:updateDraw()end
local function aaa(cba,dba)
if(type(dba)=="string")then dba=b_a(dba:getName())end;if(dba==nil)then return end
for _ca,aca in ipairs(cc)do if aca.element==dba then
table.remove(cc,_ca)return true end end;bd=false end
local function baa(cba,dba)local _ca=cba:getParent()
for aca,bca in pairs(dc)do for cca,dca in pairs(bca)do if(dca.element==dba)then
table.remove(dc[aca],cca)end end
if(
cb(dc[aca])<=0)then if(_ca~=nil)then _ca:removeEvent(aca,cba)end end end;bd=false end
local function caa(cba,dba,_ca)if(type(_ca)=="table")then _ca=_ca:getName()end
if(dc[dba]~=
nil)then for aca,bca in pairs(dc[dba])do
if(bca.element:getName()==_ca)then return bca end end end end
local function daa(cba,dba,_ca)
if(caa(cba,dba,_ca:getName())~=nil)then return end;local aca=_ca:getZIndex()dd=dd+1
if(dc[dba]==nil)then dc[dba]={}end
table.insert(dc[dba],{element=_ca,zIndex=aca,evId=dd})bd=false;cba:listenEvent(dba)return _ca end
local function _ba(cba,dba,_ca)
if(dc[dba]~=nil)then for aca,bca in pairs(dc[dba])do if(bca.element==_ca)then
table.remove(dc[dba],aca)end end;if(
cb(dc[dba])<=0)then cba:listenEvent(dba,false)end end;bd=false end;local function aba(cba)cba:sortElementOrder()return cc end;local function bba(cba,dba)return dba~=nil and
dc[dba]or dc end
_d={getType=function()
return bc end,getBase=function(cba)return ac end,isType=function(cba,dba)
return bc==dba or
ac.isType~=nil and ac.isType(dba)or false end,setSize=function(cba,...)ac.setSize(cba,...)
cba:customEventHandler("basalt_FrameResize")return cba end,setPosition=function(cba,...)
ac.setPosition(cba,...)cba:customEventHandler("basalt_FrameReposition")
return cba end,searchObjects=function(cba,dba)local _ca={}
for aca,bca in pairs(cc)do if
(string.find(aca:getName(),dba))then table.insert(_ca,bca)end end;return _ca end,getObjectsByType=function(cba,dba)
local _ca={}for aca,bca in pairs(cc)do
if(bca:isType(_ca))then table.insert(_ca,bca)end end;return _ca end,setImportant=function(cba,dba)cd=
cd+1;dd=dd+1
for _ca,aca in pairs(dc)do for bca,cca in pairs(aca)do
if(cca.element==dba)then cca.evId=dd
table.remove(dc[_ca],bca)table.insert(dc[_ca],cca)break end end end
for _ca,aca in ipairs(cc)do if aca.element==dba then aca.objId=cd;table.remove(cc,_ca)
table.insert(cc,aca)break end end;if(cba.updateDraw~=nil)then cba:updateDraw()end
bd=false end,sortElementOrder=function(cba)if
(bd)then return end;table.sort(cc,__a)for dba,_ca in pairs(dc)do
table.sort(dc[dba],a_a)end;bd=true end,removeFocusedObject=function(cba)if(
ad~=nil)then
if(b_a(cba,ad)~=nil)then ad:loseFocusHandler()end end;ad=nil;return cba end,setFocusedObject=function(cba,dba)
if(
ad~=dba)then if(ad~=nil)then
if(b_a(cba,ad)~=nil)then ad:loseFocusHandler()end end;if(dba~=nil)then if(b_a(cba,dba)~=nil)then
dba:getFocusHandler()end end;ad=dba;return true end;return false end,getFocusedObject=function(cba)return
ad end,getObject=b_a,getObjects=aba,getDeepObject=c_a,addObject=d_a,removeObject=aaa,getEvents=bba,getEvent=caa,addEvent=daa,removeEvent=_ba,removeEvents=baa,updateZIndex=_aa,listenEvent=function(cba,dba,_ca)ac.listenEvent(cba,dba,_ca)if(
dc[dba]==nil)then dc[dba]={}end;return cba end,customEventHandler=function(cba,...)
ac.customEventHandler(cba,...)
for dba,_ca in pairs(cc)do if(_ca.element.customEventHandler~=nil)then
_ca.element:customEventHandler(...)end end end,loseFocusHandler=function(cba)
ac.loseFocusHandler(cba)if(ad~=nil)then ad:loseFocusHandler()ad=nil end end,getBasalt=function(cba)return
_c end,setPalette=function(cba,dba,...)local _ca=cba:getParent()
_ca:setPalette(dba,...)return cba end,eventHandler=function(cba,...)
if(ac.eventHandler~=nil)then
ac.eventHandler(cba,...)
if(dc["other_event"]~=nil)then cba:sortElementOrder()
for dba,_ca in
ipairs(dc["other_event"])do if(_ca.element.eventHandler~=nil)then
_ca.element.eventHandler(_ca.element,...)end end end end end}
for cba,dba in
pairs({mouse_click={"mouseHandler",true},mouse_up={"mouseUpHandler",false},mouse_drag={"dragHandler",false},mouse_scroll={"scrollHandler",true},mouse_hover={"hoverHandler",false}})do
_d[dba[1]]=function(_ca,aca,bca,cca,...)
if(ac[dba[1]]~=nil)then
if(ac[dba[1]](_ca,aca,bca,cca,...))then
if
(dc[cba]~=nil)then _ca:sortElementOrder()
for dca,_da in ipairs(dc[cba])do
if
(_da.element[dba[1]]~=nil)then local ada,bda=0,0
if(_ca.getOffset~=nil)then ada,bda=_ca:getOffset()end
if(_da.element.getIgnoreOffset~=nil)then if(_da.element.getIgnoreOffset())then
ada,bda=0,0 end end;if(_da.element[dba[1]](_da.element,aca,bca+ada,cca+bda,...))then return
true end end end;if(dba[2])then _ca:removeFocusedObject()end end;return true end end end end
for cba,dba in
pairs({key="keyHandler",key_up="keyUpHandler",char="charHandler"})do
_d[dba]=function(_ca,...)
if(ac[dba]~=nil)then
if(ac[dba](_ca,...))then
if(dc[cba]~=nil)then
_ca:sortElementOrder()for aca,bca in ipairs(dc[cba])do
if(bca.element[dba]~=nil)then if
(bca.element[dba](bca.element,...))then return true end end end end end end end end
for cba,dba in pairs(_c.getObjects())do _d["add"..cba]=function(_ca,aca)
return d_a(_ca,dba(aca,_c))end end;_d.__index=_d;return setmetatable(_d,ac)end end
ba["objects"]["Dropdown"]=function(...)local bb=_b("utils")local cb=_b("tHex")
return
function(db,_c)
local ac=_c.getObject("List")(db,_c)local bc="Dropdown"ac:setSize(12,1)ac:setZIndex(6)local cc=true
local dc="left"local _d=0;local ad=0;local bd=0;local cd=true;local dd="\16"local __a="\31"local a_a=false
local b_a={getType=function(c_a)return bc end,isType=function(c_a,d_a)return
bc==
d_a or ac.isType~=nil and ac.isType(d_a)or false end,load=function(c_a)
c_a:listenEvent("mouse_click",c_a)c_a:listenEvent("mouse_up",c_a)
c_a:listenEvent("mouse_scroll",c_a)c_a:listenEvent("mouse_drag",c_a)end,setOffset=function(c_a,d_a)
_d=d_a;c_a:updateDraw()return c_a end,getOffset=function(c_a)return _d end,addItem=function(c_a,d_a,...)
ac.addItem(c_a,d_a,...)if(cd)then ad=math.max(ad,#d_a)bd=bd+1 end;return c_a end,removeItem=function(c_a,d_a)
ac.removeItem(c_a,d_a)if(cd)then ad=0;bd=0
for n=1,#list do ad=math.max(ad,#list[n].text)end;bd=#list end end,isOpened=function(c_a)return
a_a end,setOpened=function(c_a,d_a)a_a=d_a;c_a:updateDraw()return c_a end,setDropdownSize=function(c_a,d_a,_aa)
ad,bd=d_a,_aa;cd=false;c_a:updateDraw()return c_a end,getDropdownSize=function(c_a)return
ad,bd end,mouseHandler=function(c_a,d_a,_aa,aaa,baa)
if(a_a)then local daa,_ba=c_a:getAbsolutePosition()
if(d_a==1)then
local aba=c_a:getAll()
if(#aba>0)then
for n=1,bd do
if(aba[n+_d]~=nil)then
if
(daa<=_aa)and(daa+ad>_aa)and(_ba+n==aaa)then c_a:setValue(aba[n+_d])c_a:updateDraw()
local bba=c_a:sendEvent("mouse_click",c_a,"mouse_click",d_a,_aa,aaa)if(bba==false)then return bba end;if(baa)then
_c.schedule(function()sleep(0.1)
c_a:mouseUpHandler(d_a,_aa,aaa)end)()end;return true end end end end end end;local caa=ac:getBase()
if(caa.mouseHandler(c_a,d_a,_aa,aaa))then a_a=not a_a
c_a:getParent():setImportant(c_a)c_a:updateDraw()return true else
if(a_a)then c_a:updateDraw()a_a=false end;return false end end,mouseUpHandler=function(c_a,d_a,_aa,aaa)
if
(a_a)then local baa,caa=c_a:getAbsolutePosition()
if(d_a==1)then local daa=c_a:getAll()
if(#
daa>0)then
for n=1,bd do
if(daa[n+_d]~=nil)then
if
(baa<=_aa)and(baa+ad>_aa)and(caa+n==aaa)then a_a=false;c_a:updateDraw()
local _ba=c_a:sendEvent("mouse_up",c_a,"mouse_up",d_a,_aa,aaa)if(_ba==false)then return _ba end;return true end end end end end end end,dragHandler=function(c_a,d_a,_aa,aaa)if
(ac.dragHandler(c_a,d_a,_aa,aaa))then a_a=true end end,scrollHandler=function(c_a,d_a,_aa,aaa)
if
(a_a)then local baa,caa=c_a:getAbsolutePosition()if
(_aa>=baa)and(_aa<=baa+ad)and(aaa>=caa)and(aaa<=caa+bd)then
c_a:setFocus()end end
if(a_a)and(c_a:isFocused())then
local baa,caa=c_a:getAbsolutePosition()if
(_aa<baa)or(_aa>baa+ad)or(aaa<caa)or(aaa>caa+bd)then return false end;if(#c_a:getAll()<=bd)then return
false end;local daa=c_a:getAll()_d=_d+d_a
if(_d<0)then _d=0 end
if(d_a==1)then if(#daa>bd)then if(_d>#daa-bd)then _d=#daa-bd end else
_d=math.min(#daa-1,0)end end
local _ba=c_a:sendEvent("mouse_scroll",c_a,"mouse_scroll",d_a,_aa,aaa)if(_ba==false)then return _ba end;c_a:updateDraw()return true end end,draw=function(c_a)
ac.draw(c_a)c_a:setDrawState("list",false)
c_a:addDraw("dropdown",function()
local d_a,_aa=c_a:getPosition()local aaa,baa=c_a:getSize()local caa=c_a:getValue()
local daa=c_a:getAll()local _ba,aba=c_a:getBackground(),c_a:getForeground()
local bba=bb.getTextHorizontalAlign((
caa~=nil and caa.text or""),aaa,dc):sub(1,
aaa-1).. (a_a and __a or dd)
c_a:addBlit(1,1,bba,cb[aba]:rep(#bba),cb[_ba]:rep(#bba))
if(a_a)then c_a:addTextBox(1,2,ad,bd," ")
c_a:addBackgroundBox(1,2,ad,bd,_ba)c_a:addForegroundBox(1,2,ad,bd,aba)
for n=1,bd do
if(daa[n+_d]~=nil)then local cba=bb.getTextHorizontalAlign(daa[
n+_d].text,ad,dc)
if(
daa[n+_d]==caa)then
if(cc)then local dba,_ca=c_a:getSelectionColor()
c_a:addBlit(1,n+1,cba,cb[_ca]:rep(
#cba),cb[dba]:rep(#cba))else
c_a:addBlit(1,n+1,cba,cb[daa[n+_d].fgCol]:rep(#cba),cb[daa[n+_d].bgCol]:rep(
#cba))end else
c_a:addBlit(1,n+1,cba,cb[daa[n+_d].fgCol]:rep(#cba),cb[daa[n+_d].bgCol]:rep(
#cba))end end end end end)end}b_a.__index=b_a;return setmetatable(b_a,ac)end end
ba["objects"]["Menubar"]=function(...)local bb=_b("utils")local cb=_b("tHex")
return
function(db,_c)
local ac=_c.getObject("List")(db,_c)local bc="Menubar"local cc={}ac:setSize(30,1)ac:setZIndex(5)local dc=0
local _d,ad=1,1;local bd=true
local function cd()local dd=0;local __a=ac:getWidth()local a_a=ac:getAll()for n=1,#a_a do dd=dd+
a_a[n].text:len()+_d*2 end;return
math.max(dd-__a,0)end
cc={init=function(dd)local __a=dd:getParent()dd:listenEvent("mouse_click")
dd:listenEvent("mouse_drag")dd:listenEvent("mouse_scroll")return ac.init(dd)end,getType=function(dd)return
bc end,getBase=function(dd)return ac end,setSpace=function(dd,__a)_d=__a or _d;dd:updateDraw()
return dd end,setScrollable=function(dd,__a)bd=__a;if(__a==nil)then bd=true end;return dd end,mouseHandler=function(dd,__a,a_a,b_a)
if
(ac:getBase().mouseHandler(dd,__a,a_a,b_a))then local c_a,d_a=dd:getAbsolutePosition()local _aa,aaa=dd:getSize()local baa=0
local caa=dd:getAll()
for n=1,#caa do
if(caa[n]~=nil)then
if
(c_a+baa<=a_a+dc)and(
c_a+baa+caa[n].text:len()+ (_d*2)>a_a+dc)and(d_a==b_a)then
dd:setValue(caa[n])dd:sendEvent(event,dd,event,0,a_a,b_a,caa[n])end;baa=baa+caa[n].text:len()+_d*2 end end;dd:updateDraw()return true end end,scrollHandler=function(dd,__a,a_a,b_a)
if
(ac:getBase().scrollHandler(dd,__a,a_a,b_a))then if(bd)then dc=dc+__a;if(dc<0)then dc=0 end;local c_a=cd()if(dc>c_a)then dc=c_a end
dd:updateDraw()end;return true end;return false end,draw=function(dd)
ac.draw(dd)
dd:addDraw("list",function()local __a=dd:getParent()local a_a,b_a=dd:getSize()local c_a=""local d_a=""
local _aa=""local aaa,baa=dd:getSelectionColor()
for caa,daa in pairs(dd:getAll())do
local _ba=
(" "):rep(_d)..daa.text.. (" "):rep(_d)c_a=c_a.._ba
if(daa==dd:getValue())then d_a=d_a..
cb[aaa or daa.bgCol or
dd:getBackground()]:rep(_ba:len())_aa=_aa..
cb[baa or
daa.FgCol or dd:getForeground()]:rep(_ba:len())else d_a=d_a..
cb[daa.bgCol or
dd:getBackground()]:rep(_ba:len())_aa=_aa..
cb[daa.FgCol or
dd:getForeground()]:rep(_ba:len())end end
dd:addBlit(1,1,c_a:sub(dc+1,a_a+dc),_aa:sub(dc+1,a_a+dc),d_a:sub(dc+1,a_a+dc))end)end}cc.__index=cc;return setmetatable(cc,ac)end end
ba["objects"]["Pane"]=function(...)
return
function(bb,cb)
local db=cb.getObject("VisualObject")(bb,cb)local _c="Pane"db:setSize(25,10)
local ac={getType=function(bc)return _c end}ac.__index=ac;return setmetatable(ac,db)end end
ba["objects"]["Scrollbar"]=function(...)local bb=_b("tHex")
return
function(cb,db)
local _c=db.getObject("VisualObject")(cb,db)local ac="Scrollbar"_c:setZIndex(2)_c:setSize(1,8)
_c:setBackground(colors.lightGray,"\127",colors.gray)local bc="vertical"local cc=" "local dc=colors.black;local _d=colors.black;local ad=3;local bd=1
local cd=1;local dd=true
local function __a()local c_a,d_a=_c:getSize()if(dd)then
cd=math.max((bc=="vertical"and d_a or
c_a- (#cc))- (ad-1),1)end end;__a()
local function a_a(c_a,d_a,_aa,aaa)local baa,caa=c_a:getAbsolutePosition()
local daa,_ba=c_a:getSize()__a()local aba=bc=="vertical"and _ba or daa
for i=0,aba do
if

( (
bc=="vertical"and caa+i==aaa)or(bc=="horizontal"and baa+i==_aa))and(baa<=_aa)and(baa+daa>_aa)and(caa<=aaa)and
(caa+_ba>aaa)then bd=math.min(i+1,
aba- (#cc+cd-2))
c_a:scrollbarMoveHandler()c_a:updateDraw()end end end
local b_a={getType=function(c_a)return ac end,load=function(c_a)_c.load(c_a)local d_a=c_a:getParent()
c_a:listenEvent("mouse_click")c_a:listenEvent("mouse_up")
c_a:listenEvent("mouse_scroll")c_a:listenEvent("mouse_drag")end,setSymbol=function(c_a,d_a,_aa,aaa)
cc=d_a:sub(1,1)dc=_aa or dc;_d=aaa or _d;__a()c_a:updateDraw()return c_a end,setIndex=function(c_a,d_a)
bd=d_a;if(bd<1)then bd=1 end;local _aa,aaa=c_a:getSize()__a()
c_a:updateDraw()return c_a end,setScrollAmount=function(c_a,d_a)ad=d_a;__a()
c_a:updateDraw()return c_a end,getIndex=function(c_a)local d_a,_aa=c_a:getSize()return
ad> (
bc=="vertical"and _aa or d_a)and
math.floor(ad/ (
bc=="vertical"and _aa or d_a)*bd)or bd end,setSymbolSize=function(c_a,d_a)cd=
tonumber(d_a)or 1;dd=d_a~=false and false or true
__a()c_a:updateDraw()return c_a end,setBarType=function(c_a,d_a)
bc=d_a:lower()__a()c_a:updateDraw()return c_a end,mouseHandler=function(c_a,d_a,_aa,aaa,...)
if
(_c.mouseHandler(c_a,d_a,_aa,aaa,...))then a_a(c_a,d_a,_aa,aaa)return true end;return false end,dragHandler=function(c_a,d_a,_aa,aaa)if
(_c.dragHandler(c_a,d_a,_aa,aaa))then a_a(c_a,d_a,_aa,aaa)return true end;return
false end,setSize=function(c_a,...)
_c.setSize(c_a,...)__a()return c_a end,scrollHandler=function(c_a,d_a,_aa,aaa)
if(_c.scrollHandler(c_a,d_a,_aa,aaa))then
local baa,caa=c_a:getSize()__a()bd=bd+d_a;if(bd<1)then bd=1 end
bd=math.min(bd,
(bc=="vertical"and caa or baa)- (bc=="vertical"and cd-1 or#cc+cd-2))c_a:scrollbarMoveHandler()c_a:updateDraw()end end,onChange=function(c_a,...)
for d_a,_aa in
pairs(table.pack(...))do if(type(_aa)=="function")then
c_a:registerEvent("scrollbar_moved",_aa)end end;return c_a end,scrollbarMoveHandler=function(c_a)
c_a:sendEvent("scrollbar_moved",c_a:getIndex())end,customEventHandler=function(c_a,d_a,...)
_c.customEventHandler(c_a,d_a,...)if(d_a=="basalt_FrameResize")then __a()end end,draw=function(c_a)
_c.draw(c_a)
c_a:addDraw("scrollbar",function()local d_a=c_a:getParent()local _aa,aaa=c_a:getSize()
local baa,caa=c_a:getBackground(),c_a:getForeground()
if(bc=="horizontal")then for n=0,aaa-1 do
c_a:addBlit(bd,1 +n,cc:rep(cd),bb[_d]:rep(#cc*cd),bb[dc]:rep(
#cc*cd))end elseif(bc=="vertical")then
for n=0,aaa-1 do
if(bd==n+1)then
for curIndexOffset=0,math.min(
cd-1,aaa)do
c_a:addBlit(1,bd+curIndexOffset,cc:rep(math.max(#cc,_aa)),bb[_d]:rep(math.max(
#cc,_aa)),bb[dc]:rep(math.max(#cc,_aa)))end end end end end)end}b_a.__index=b_a;return setmetatable(b_a,_c)end end
ba["objects"]["Image"]=function(...)local bb=_b("images")local cb=_b("bimg")
local db,_c,ac,bc=table.unpack,string.sub,math.max,math.min
return
function(cc,dc)local _d=dc.getObject("VisualObject")(cc,dc)
local ad="Image"local bd=cb()local cd=bd.getFrameObject(1)local dd;local __a;local a_a=1;local b_a=false;local c_a
local d_a=false;local _aa=true;local aaa,baa=0,0;_d:setSize(24,8)_d:setZIndex(2)
local function caa(aba)local bba={}
for _ca,aca in
pairs(colors)do if(type(aca)=="number")then
bba[_ca]={term.nativePaletteColor(aca)}end end;local cba=bd.getMetadata("palette")if(cba~=nil)then for _ca,aca in pairs(cba)do
bba[_ca]=tonumber(aca)end end
local dba=bd.getFrameData("palette")dc.log(dba)if(dba~=nil)then
for _ca,aca in pairs(dba)do bba[_ca]=tonumber(aca)end end;return bba end;local function daa()
if(_aa)then if(bd~=nil)then _d:setSize(bd.getSize())end end end
local _ba={getType=function(aba)return ad end,isType=function(aba,bba)return
ad==bba or
_d.isType~=nil and _d.isType(bba)or false end,setOffset=function(aba,bba,cba,dba)
if(dba)then aaa=aaa+
bba or 0;baa=baa+cba or 0 else aaa=bba or aaa;baa=cba or baa end;aba:updateDraw()return aba end,setSize=function(aba,bba,cba)
_d:setSize(bba,cba)_aa=false;return aba end,getOffset=function(aba)return aaa,baa end,selectFrame=function(aba,bba)if(
bd.getFrameObject(bba)==nil)then bd.addFrame(bba)end
cd=bd.getFrameObject(bba)__a=cd.getImage(bba)a_a=bba;aba:updateDraw()end,addFrame=function(aba,bba)
bd.addFrame(bba)return aba end,getFrame=function(aba,bba)return bd.getFrame(bba)end,getFrameObject=function(aba,bba)return
bd.getFrameObject(bba)end,removeFrame=function(aba,bba)bd.removeFrame(bba)return aba end,moveFrame=function(aba,bba,cba)
bd.moveFrame(bba,cba)return aba end,getFrames=function(aba)return bd.getFrames()end,getFrameCount=function(aba)return
#bd.getFrames()end,getActiveFrame=function(aba)return a_a end,loadImage=function(aba,bba)if
(fs.exists(bba))then local cba=bb.loadBIMG(bba)bd=cb(cba)a_a=1
cd=bd.getFrameObject(1)dd=bd.createBimg()__a=cd.getImage()daa()
aba:updateDraw()end;return
aba end,setImage=function(aba,bba)
if(
type(bba)=="table")then bd=cb(bba)a_a=1;cd=bd.getFrameObject(1)
dd=bd.createBimg()__a=cd.getImage()daa()aba:updateDraw()end;return aba end,clear=function(aba)
bd=cb()cd=bd.getFrameObject(1)__a=nil;aba:updateDraw()return aba end,getImage=function(aba)return
bd.createBimg()end,getImageFrame=function(aba,bba)return cd.getImage(bba)end,usePalette=function(aba,bba)d_a=
bba~=nil and bba or true;return aba end,play=function(aba,bba)
if
(bd.getMetadata("animated"))then
local cba=
bd.getMetadata("duration")or bd.getMetadata("secondsPerFrame")or 0.2;aba:listenEvent("other_event")
c_a=os.startTimer(cba)b_a=bba or false end;return aba end,stop=function(aba)
os.cancelTimer(c_a)c_a=nil;b_a=false;return aba end,eventHandler=function(aba,bba,cba,...)
_d.eventHandler(aba,bba,cba,...)
if(bba=="timer")then
if(cba==c_a)then
if(bd.getFrame(a_a+1)~=nil)then a_a=a_a+1
aba:selectFrame(a_a)
local dba=
bd.getFrameData(a_a,"duration")or bd.getMetadata("secondsPerFrame")or 0.2;c_a=os.startTimer(dba)else
if(b_a)then a_a=1;aba:selectFrame(a_a)
local dba=
bd.getFrameData(a_a,"duration")or bd.getMetadata("secondsPerFrame")or 0.2;c_a=os.startTimer(dba)end end;aba:updateDraw()end end end,setMetadata=function(aba,bba,cba)
bd.setMetadata(bba,cba)return aba end,getMetadata=function(aba,bba)return bd.getMetadata(bba)end,getFrameMetadata=function(aba,bba,cba)return
bd.getFrameData(bba,cba)end,setFrameMetadata=function(aba,bba,cba,dba)
bd.setFrameData(bba,cba,dba)return aba end,blit=function(aba,bba,cba,dba,_ca,aca)x=_ca or x;y=aca or y
cd.blit(bba,cba,dba,x,y)__a=cd.getImage()aba:updateDraw()return aba end,setText=function(aba,bba,cba,dba)x=
cba or x;y=dba or y;cd.text(bba,x,y)__a=cd.getImage()
aba:updateDraw()return aba end,setBg=function(aba,bba,cba,dba)x=cba or x;y=
dba or y;cd.bg(bba,x,y)__a=cd.getImage()
aba:updateDraw()return aba end,setFg=function(aba,bba,cba,dba)x=cba or x;y=dba or
y;cd.fg(bba,x,y)__a=cd.getImage()
aba:updateDraw()return aba end,getImageSize=function(aba)
return bd.getSize()end,setImageSize=function(aba,bba,cba)bd.setSize(bba,cba)__a=cd.getImage()
aba:updateDraw()return aba end,resizeImage=function(aba,bba,cba)
local dba=bb.resizeBIMG(dd,bba,cba)bd=cb(dba)a_a=1;cd=bd.getFrameObject(1)__a=cd.getImage()
aba:updateDraw()return aba end,draw=function(aba)
_d.draw(aba)
aba:addDraw("image",function()local bba,cba=aba:getSize()local dba,_ca=aba:getPosition()
local aca,bca=aba:getParent():getSize()local cca,dca=aba:getParent():getOffset()
if
(dba-cca>aca)or(_ca-dca>bca)or(dba-cca+bba<1)or(_ca-
dca+cba<1)then return end
if(d_a)then aba:getParent():setPalette(caa(a_a))end
if(__a~=nil)then
for _da,ada in pairs(__a)do
if(_da+baa<=cba)and(_da+baa>=1)then
local bda,cda,dda=ada[1],ada[2],ada[3]local __b=ac(1 -aaa,1)local a_b=bc(bba-aaa,#bda)
bda=_c(bda,__b,a_b)cda=_c(cda,__b,a_b)dda=_c(dda,__b,a_b)
aba:addBlit(ac(1 +aaa,1),_da+baa,bda,cda,dda)end end end end)end}_ba.__index=_ba;return setmetatable(_ba,_d)end end
ba["objects"]["MonitorFrame"]=function(...)local bb=_b("basaltMon")
local cb,db,_c,ac=math.max,math.min,string.sub,string.rep
return
function(bc,cc)local dc=cc.getObject("BaseFrame")(bc,cc)
local _d="MonitorFrame"dc:setTerm(nil)local ad=false;local bd
local cd={getType=function()return _d end,isType=function(dd,__a)
return _d==__a or dc.isType~=nil and
dc.isType(__a)or false end,getBase=function(dd)return dc end,setMonitor=function(dd,__a)
if
(type(__a)=="string")then local a_a=peripheral.wrap(__a)
if(a_a~=nil)then dd:setTerm(a_a)end elseif(type(__a)=="table")then dd:setTerm(__a)end;return dd end,setMonitorGroup=function(dd,__a)
bd=bb(__a)dd:setTerm(bd)ad=true;return dd end,render=function(dd)if(
dd:getTerm()~=nil)then dc.render(dd)end end,show=function(dd)
dc:getBase().show(dd)cc.setActiveFrame(dd)
for __a,a_a in pairs(colors)do if(type(a_a)=="number")then
termObject.setPaletteColor(a_a,colors.packRGB(term.nativePaletteColor((a_a))))end end
for __a,a_a in pairs(colorTheme)do
if(type(a_a)=="number")then
termObject.setPaletteColor(
type(__a)=="number"and __a or colors[__a],a_a)else local b_a,c_a,d_a=table.unpack(a_a)
termObject.setPaletteColor(
type(__a)=="number"and __a or colors[__a],b_a,c_a,d_a)end end;return dd end}
cd.mouseHandler=function(dd,__a,a_a,b_a,c_a,d_a,...)
if(ad)then a_a,b_a=bd.calculateClick(d_a,a_a,b_a)end;dc.mouseHandler(dd,__a,a_a,b_a,c_a,d_a,...)end;cd.__index=cd;return setmetatable(cd,dc)end end
ba["objects"]["Radio"]=function(...)local bb=_b("utils")local cb=_b("tHex")
return
function(db,_c)
local ac=_c.getObject("List")(db,_c)local bc="Radio"ac:setSize(1,1)ac:setZIndex(5)local cc={}
local dc=colors.black;local _d=colors.green;local ad=colors.black;local bd=colors.red;local cd=true;local dd="\7"
local __a="left"
local a_a={getType=function(b_a)return bc end,addItem=function(b_a,c_a,d_a,_aa,aaa,baa,...)ac.addItem(b_a,c_a,aaa,baa,...)table.insert(cc,{x=d_a or 1,y=
_aa or#cc*2})
return b_a end,removeItem=function(b_a,c_a)
ac.removeItem(b_a,c_a)table.remove(cc,c_a)return b_a end,clear=function(b_a)
ac.clear(b_a)cc={}return b_a end,editItem=function(b_a,c_a,d_a,_aa,aaa,baa,caa,...)
ac.editItem(b_a,c_a,d_a,baa,caa,...)table.remove(cc,c_a)
table.insert(cc,c_a,{x=_aa or 1,y=aaa or 1})return b_a end,setBoxSelectionColor=function(b_a,c_a,d_a)
dc=c_a;_d=d_a;return b_a end,getBoxSelectionColor=function(b_a)return dc,_d end,setBoxDefaultColor=function(b_a,c_a,d_a)ad=c_a;bd=d_a
return b_a end,getBoxDefaultColor=function(b_a)return ad,bd end,mouseHandler=function(b_a,c_a,d_a,_aa,...)
if(#cc>0)then
local aaa,baa=b_a:getAbsolutePosition()local caa=b_a:getAll()
for daa,_ba in pairs(caa)do
if
(aaa+cc[daa].x-1 <=d_a)and
(aaa+
cc[daa].x-1 +_ba.text:len()+1 >=d_a)and(baa+cc[daa].y-1 ==_aa)then b_a:setValue(_ba)
local aba=b_a:sendEvent("mouse_click",b_a,"mouse_click",c_a,d_a,_aa,...)b_a:updateDraw()if(aba==false)then return aba end;return true end end end end,draw=function(b_a)
b_a:addDraw("radio",function()
local c_a,d_a=b_a:getSelectionColor()local _aa=b_a:getAll()
for aaa,baa in pairs(_aa)do
if(baa==b_a:getValue())then
b_a:addBlit(cc[aaa].x,cc[aaa].y,dd,cb[_d],cb[dc])
b_a:addBlit(cc[aaa].x+2,cc[aaa].y,baa.text,cb[d_a]:rep(#baa.text),cb[c_a]:rep(
#baa.text))else
b_a:addBackgroundBox(cc[aaa].x,cc[aaa].y,1,1,ad or colors.black)
b_a:addBlit(cc[aaa].x+2,cc[aaa].y,baa.text,cb[baa.fgCol]:rep(#baa.text),cb[baa.bgCol]:rep(
#baa.text))end end;return true end)end}a_a.__index=a_a;return setmetatable(a_a,ac)end end
ba["objects"]["Slider"]=function(...)local bb=_b("tHex")
return
function(cb,db)
local _c=db.getObject("ChangeableObject")(cb,db)local ac="Slider"_c:setSize(12,1)_c:setValue(1)
_c:setBackground(false,"\140",colors.black)local bc="horizontal"local cc=" "local dc=colors.black;local _d=colors.gray;local ad=12;local bd=1
local cd=1
local function dd(a_a,b_a,c_a,d_a)local _aa,aaa=a_a:getPosition()local baa,caa=a_a:getSize()local daa=
bc=="vertical"and caa or baa
for i=0,daa do
if

(
(bc=="vertical"and aaa+i==d_a)or(bc=="horizontal"and _aa+i==c_a))and(_aa<=c_a)and(_aa+baa>c_a)and(aaa<=d_a)and
(aaa+caa>d_a)then bd=math.min(i+1,daa- (#
cc+cd-2))
a_a:setValue(ad/daa*bd)a_a:updateDraw()end end end
local __a={getType=function(a_a)return ac end,load=function(a_a)a_a:listenEvent("mouse_click")
a_a:listenEvent("mouse_drag")a_a:listenEvent("mouse_scroll")end,setSymbol=function(a_a,b_a)
cc=b_a:sub(1,1)a_a:updateDraw()return a_a end,setIndex=function(a_a,b_a)bd=b_a;if(bd<1)then
bd=1 end;local c_a,d_a=a_a:getSize()
bd=math.min(bd,
(bc=="vertical"and d_a or c_a)- (cd-1))
a_a:setValue(ad/ (bc=="vertical"and d_a or c_a)*bd)a_a:updateDraw()return a_a end,getIndex=function(a_a)return
bd end,setMaxValue=function(a_a,b_a)ad=b_a;return a_a end,setSymbolColor=function(a_a,b_a)symbolColor=b_a
a_a:updateDraw()return a_a end,setBarType=function(a_a,b_a)bc=b_a:lower()
a_a:updateDraw()return a_a end,mouseHandler=function(a_a,b_a,c_a,d_a)if(_c.mouseHandler(a_a,b_a,c_a,d_a))then
dd(a_a,b_a,c_a,d_a)return true end;return false end,dragHandler=function(a_a,b_a,c_a,d_a)if
(_c.dragHandler(a_a,b_a,c_a,d_a))then dd(a_a,b_a,c_a,d_a)return true end
return false end,scrollHandler=function(a_a,b_a,c_a,d_a)
if
(_c.scrollHandler(a_a,b_a,c_a,d_a))then local _aa,aaa=a_a:getSize()bd=bd+b_a;if(bd<1)then bd=1 end
bd=math.min(bd,(
bc=="vertical"and aaa or _aa)- (cd-1))
a_a:setValue(ad/ (bc=="vertical"and aaa or _aa)*bd)a_a:updateDraw()return true end;return false end,draw=function(a_a)
_c.draw(a_a)
a_a:addDraw("slider",function()local b_a,c_a=a_a:getSize()
local d_a,_aa=a_a:getBackground(),a_a:getForeground()
if(bc=="horizontal")then a_a:addText(bd,oby,cc:rep(cd))
if(_d~=false)then a_a:addBG(bd,1,bb[_d]:rep(
#cc*cd))end;if(dc~=false)then
a_a:addFG(bd,1,bb[dc]:rep(#cc*cd))end end
if(bc=="vertical")then
for n=0,c_a-1 do
if(bd==n+1)then for curIndexOffset=0,math.min(cd-1,c_a)do
a_a:addBlit(1,1 +n+curIndexOffset,cc,bb[symbolColor],bb[symbolColor])end else if(n+1 <bd)or(n+1 >
bd-1 +cd)then
a_a:addBlit(1,1 +n,bgSymbol,bb[_aa],bb[d_a])end end end end end)end}__a.__index=__a;return setmetatable(__a,_c)end end
ba["objects"]["ScrollableFrame"]=function(...)
local bb,cb,db,_c=math.max,math.min,string.sub,string.rep
return
function(ac,bc)local cc=bc.getObject("Frame")(ac,bc)
local dc="ScrollableFrame"local _d;local ad=0;local bd=0;local cd=true
local function dd(c_a)local d_a=0;local _aa=c_a:getObjects()
for aaa,baa in pairs(_aa)do
if(
baa.element.getWidth~=nil)and(baa.element.getX~=nil)then
local caa,daa=baa.element:getWidth(),baa.element:getX()local _ba=c_a:getWidth()
if
(baa.element:getType()=="Dropdown")then if(baa.element:isOpened())then
local aba=baa.element:getDropdownSize()
if(aba+daa-_ba>=d_a)then d_a=bb(aba+daa-_ba,0)end end end
if(h+daa-_ba>=d_a)then d_a=bb(caa+daa-_ba,0)end end end;return d_a end
local function __a(c_a)local d_a=0;local _aa=c_a:getObjects()
for aaa,baa in pairs(_aa)do
if
(baa.element.getHeight~=nil)and(baa.element.getY~=nil)then
local caa,daa=baa.element:getHeight(),baa.element:getY()local _ba=c_a:getHeight()
if
(baa.element:getType()=="Dropdown")then if(baa.element:isOpened())then
local aba,bba=baa.element:getDropdownSize()
if(bba+daa-_ba>=d_a)then d_a=bb(bba+daa-_ba,0)end end end
if(caa+daa-_ba>=d_a)then d_a=bb(caa+daa-_ba,0)end end end;return d_a end
local function a_a(c_a,d_a)local _aa,aaa=c_a:getOffset()local baa
if(ad==1)then
baa=cd and dd(c_a)or bd
c_a:setOffset(cb(baa,bb(0,_aa+d_a)),aaa)elseif(ad==0)then baa=cd and __a(c_a)or bd
c_a:setOffset(_aa,cb(baa,bb(0,aaa+d_a)))end;c_a:updateDraw()end
local b_a={getType=function()return dc end,isType=function(c_a,d_a)return
dc==d_a or cc.isType~=nil and cc.isType(d_a)or false end,setDirection=function(c_a,d_a)ad=
d_a=="horizontal"and 1 or d_a=="vertical"and 0 or
ad;return c_a end,setScrollAmount=function(c_a,d_a)
bd=d_a;cd=false;return c_a end,getBase=function(c_a)return cc end,load=function(c_a)cc.load(c_a)
c_a:listenEvent("mouse_scroll")end,setParent=function(c_a,d_a,...)cc.setParent(c_a,d_a,...)_d=d_a
return c_a end,scrollHandler=function(c_a,d_a,_aa,aaa)
if
(cc:getBase().scrollHandler(c_a,d_a,_aa,aaa))then c_a:sortElementOrder()
for baa,caa in
ipairs(c_a:getEvents("mouse_scroll"))do
if(caa.element.scrollHandler~=nil)then local daa,_ba=0,0;if(c_a.getOffset~=nil)then
daa,_ba=c_a:getOffset()end
if(caa.element.getIgnoreOffset())then daa,_ba=0,0 end;if(caa.element.scrollHandler(caa.element,d_a,_aa+daa,aaa+_ba))then
return true end end end;a_a(c_a,d_a,_aa,aaa)c_a:removeFocusedObject()return true end end,draw=function(c_a)
cc.draw(c_a)
c_a:addDraw("scrollableFrame",function()if(cd)then a_a(c_a,0)end end,0)end}b_a.__index=b_a;return setmetatable(b_a,cc)end end
ba["objects"]["Program"]=function(...)local bb=_b("tHex")local cb=_b("process")
local db=string.sub
return
function(_c,ac)local bc=ac.getObject("VisualObject")(_c,ac)
local cc="Program"local dc;local _d;local ad={}
local function bd(aaa,baa,caa,daa)local _ba,aba=1,1;local bba,cba=colors.black,colors.white;local dba=false
local _ca=false;local aca={}local bca={}local cca={}local dca={}local _da;local ada={}for i=0,15 do local dab=2 ^i
dca[dab]={ac.getTerm().getPaletteColour(dab)}end;local function bda()_da=(" "):rep(caa)
for n=0,15 do
local dab=2 ^n;local _bb=bb[dab]ada[dab]=_bb:rep(caa)end end
local function cda()bda()local dab=_da
local _bb=ada[colors.white]local abb=ada[colors.black]
for n=1,daa do
aca[n]=db(aca[n]==nil and dab or aca[n]..dab:sub(1,
caa-aca[n]:len()),1,caa)
cca[n]=db(cca[n]==nil and _bb or cca[n]..
_bb:sub(1,caa-cca[n]:len()),1,caa)
bca[n]=db(bca[n]==nil and abb or bca[n]..
abb:sub(1,caa-bca[n]:len()),1,caa)end;bc.updateDraw(bc)end;cda()local function dda()if
_ba>=1 and aba>=1 and _ba<=caa and aba<=daa then else end end
local function __b(dab,_bb,abb)if

aba<1 or aba>daa or _ba<1 or _ba+#dab-1 >caa then return end
aca[aba]=db(aca[aba],1,_ba-1)..dab..db(aca[aba],
_ba+#dab,caa)cca[aba]=db(cca[aba],1,_ba-1)..
_bb..db(cca[aba],_ba+#dab,caa)
bca[aba]=
db(bca[aba],1,_ba-1)..abb..db(bca[aba],_ba+#dab,caa)_ba=_ba+#dab;if _ca then dda()end;dc:updateDraw()end
local function a_b(dab,_bb,abb)
if(abb~=nil)then local bbb=aca[_bb]if(bbb~=nil)then
aca[_bb]=db(bbb:sub(1,dab-1)..abb..bbb:sub(dab+
(abb:len()),caa),1,caa)end end;dc:updateDraw()end
local function b_b(dab,_bb,abb)
if(abb~=nil)then local bbb=bca[_bb]if(bbb~=nil)then
bca[_bb]=db(bbb:sub(1,dab-1)..abb..bbb:sub(dab+
(abb:len()),caa),1,caa)end end;dc:updateDraw()end
local function c_b(dab,_bb,abb)
if(abb~=nil)then local bbb=cca[_bb]if(bbb~=nil)then
cca[_bb]=db(bbb:sub(1,dab-1)..abb..bbb:sub(dab+
(abb:len()),caa),1,caa)end end;dc:updateDraw()end
local d_b=function(dab)
if type(dab)~="number"then
error("bad argument #1 (expected number, got "..type(dab)..")",2)elseif bb[dab]==nil then
error("Invalid color (got "..dab..")",2)end;cba=dab end
local _ab=function(dab)
if type(dab)~="number"then
error("bad argument #1 (expected number, got "..type(dab)..")",2)elseif bb[dab]==nil then
error("Invalid color (got "..dab..")",2)end;bba=dab end
local aab=function(dab,_bb,abb,bbb)if type(dab)~="number"then
error("bad argument #1 (expected number, got "..type(dab)..")",2)end
if bb[dab]==nil then error("Invalid color (got "..
dab..")",2)end;local cbb
if
type(_bb)=="number"and abb==nil and bbb==nil then cbb={colours.rgb8(_bb)}dca[dab]=cbb else if
type(_bb)~="number"then
error("bad argument #2 (expected number, got "..type(_bb)..")",2)end;if type(abb)~="number"then
error(
"bad argument #3 (expected number, got "..type(abb)..")",2)end;if type(bbb)~="number"then
error(
"bad argument #4 (expected number, got "..type(bbb)..")",2)end;cbb=dca[dab]cbb[1]=_bb
cbb[2]=abb;cbb[3]=bbb end end
local bab=function(dab)if type(dab)~="number"then
error("bad argument #1 (expected number, got "..type(dab)..")",2)end
if bb[dab]==nil then error("Invalid color (got "..
dab..")",2)end;local _bb=dca[dab]return _bb[1],_bb[2],_bb[3]end
local cab={setCursorPos=function(dab,_bb)if type(dab)~="number"then
error("bad argument #1 (expected number, got "..type(dab)..")",2)end;if type(_bb)~="number"then
error(
"bad argument #2 (expected number, got "..type(_bb)..")",2)end;_ba=math.floor(dab)
aba=math.floor(_bb)if(_ca)then dda()end end,getCursorPos=function()return
_ba,aba end,setCursorBlink=function(dab)if type(dab)~="boolean"then
error("bad argument #1 (expected boolean, got "..
type(dab)..")",2)end;dba=dab end,getCursorBlink=function()return
dba end,getPaletteColor=bab,getPaletteColour=bab,setBackgroundColor=_ab,setBackgroundColour=_ab,setTextColor=d_b,setTextColour=d_b,setPaletteColor=aab,setPaletteColour=aab,getBackgroundColor=function()return bba end,getBackgroundColour=function()return bba end,getSize=function()
return caa,daa end,getTextColor=function()return cba end,getTextColour=function()return cba end,basalt_resize=function(dab,_bb)caa,daa=dab,_bb;cda()end,basalt_reposition=function(dab,_bb)
aaa,baa=dab,_bb end,basalt_setVisible=function(dab)_ca=dab end,drawBackgroundBox=function(dab,_bb,abb,bbb,cbb)for n=1,bbb do
b_b(dab,_bb+ (n-1),bb[cbb]:rep(abb))end end,drawForegroundBox=function(dab,_bb,abb,bbb,cbb)
for n=1,bbb do c_b(dab,
_bb+ (n-1),bb[cbb]:rep(abb))end end,drawTextBox=function(dab,_bb,abb,bbb,cbb)for n=1,bbb do
a_b(dab,_bb+ (n-1),cbb:rep(abb))end end,basalt_update=function()for n=1,daa do
dc:addBlit(1,n,aca[n],cca[n],bca[n])end end,scroll=function(dab)
assert(type(dab)==
"number","bad argument #1 (expected number, got "..type(dab)..")")
if dab~=0 then
for newY=1,daa do local _bb=newY+dab;if _bb<1 or _bb>daa then aca[newY]=_da
cca[newY]=ada[cba]bca[newY]=ada[bba]else aca[newY]=aca[_bb]bca[newY]=bca[_bb]
cca[newY]=cca[_bb]end end end;if(_ca)then dda()end end,isColor=function()return
ac.getTerm().isColor()end,isColour=function()
return ac.getTerm().isColor()end,write=function(dab)dab=tostring(dab)if(_ca)then
__b(dab,bb[cba]:rep(dab:len()),bb[bba]:rep(dab:len()))end end,clearLine=function()
if
(_ca)then a_b(1,aba,(" "):rep(caa))
b_b(1,aba,bb[bba]:rep(caa))c_b(1,aba,bb[cba]:rep(caa))end;if(_ca)then dda()end end,clear=function()
for n=1,daa
do a_b(1,n,(" "):rep(caa))
b_b(1,n,bb[bba]:rep(caa))c_b(1,n,bb[cba]:rep(caa))end;if(_ca)then dda()end end,blit=function(dab,_bb,abb)if
type(dab)~="string"then
error("bad argument #1 (expected string, got "..type(dab)..")",2)end;if type(_bb)~="string"then
error(
"bad argument #2 (expected string, got "..type(_bb)..")",2)end;if type(abb)~="string"then
error(
"bad argument #3 (expected string, got "..type(abb)..")",2)end
if
#_bb~=#dab or#abb~=#dab then error("Arguments must be the same length",2)end;if(_ca)then __b(dab,_bb,abb)end end}return cab end;bc:setZIndex(5)bc:setSize(30,12)local cd=bd(1,1,30,12)local dd
local __a=false;local a_a={}
local function b_a(aaa)local baa=aaa:getParent()local caa,daa=cd.getCursorPos()
local _ba,aba=aaa:getPosition()local bba,cba=aaa:getSize()
if(_ba+caa-1 >=1 and
_ba+caa-1 <=_ba+bba-1 and daa+aba-1 >=1 and
daa+aba-1 <=aba+cba-1)then
baa:setCursor(
aaa:isFocused()and cd.getCursorBlink(),_ba+caa-1,daa+aba-1,cd.getTextColor())end end
local function c_a(aaa,baa,...)local caa,daa=dd:resume(baa,...)
if(caa==false)and(daa~=nil)and
(daa~="Terminated")then
local _ba=aaa:sendEvent("program_error",daa)
if(_ba~=false)then error("Basalt Program - "..daa)end end
if(dd:getStatus()=="dead")then aaa:sendEvent("program_done")end end
local function d_a(aaa,baa,caa,daa,_ba)if(dd==nil)then return false end
if not(dd:isDead())then if not(__a)then
local aba,bba=aaa:getAbsolutePosition()c_a(aaa,baa,caa,daa-aba+1,_ba-bba+1)
b_a(aaa)end end end
local function _aa(aaa,baa,caa,daa)if(dd==nil)then return false end
if not(dd:isDead())then if not(__a)then if(aaa.draw)then
c_a(aaa,baa,caa,daa)b_a(aaa)end end end end
dc={getType=function(aaa)return cc end,show=function(aaa)bc.show(aaa)
cd.setBackgroundColor(aaa:getBackground())cd.setTextColor(aaa:getForeground())
cd.basalt_setVisible(true)return aaa end,hide=function(aaa)
bc.hide(aaa)cd.basalt_setVisible(false)return aaa end,setPosition=function(aaa,baa,caa,daa)
bc.setPosition(aaa,baa,caa,daa)cd.basalt_reposition(aaa:getPosition())return aaa end,getBasaltWindow=function()return
cd end,getBasaltProcess=function()return dd end,setSize=function(aaa,baa,caa,daa)bc.setSize(aaa,baa,caa,daa)
cd.basalt_resize(aaa:getWidth(),aaa:getHeight())return aaa end,getStatus=function(aaa)if(dd~=nil)then return
dd:getStatus()end;return"inactive"end,setEnviroment=function(aaa,baa)ad=
baa or{}return aaa end,execute=function(aaa,baa,...)_d=baa or _d
dd=cb:new(_d,cd,ad,...)cd.setBackgroundColor(colors.black)
cd.setTextColor(colors.white)cd.clear()cd.setCursorPos(1,1)
cd.setBackgroundColor(aaa:getBackground())
cd.setTextColor(aaa:getForeground()or colors.white)cd.basalt_setVisible(true)c_a(aaa)__a=false
aaa:listenEvent("mouse_click",aaa)aaa:listenEvent("mouse_up",aaa)
aaa:listenEvent("mouse_drag",aaa)aaa:listenEvent("mouse_scroll",aaa)
aaa:listenEvent("key",aaa)aaa:listenEvent("key_up",aaa)
aaa:listenEvent("char",aaa)aaa:listenEvent("other_event",aaa)return aaa end,stop=function(aaa)
local baa=aaa:getParent()
if(dd~=nil)then if not(dd:isDead())then c_a(aaa,"terminate")if(dd:isDead())then
baa:setCursor(false)end end end;baa:removeEvents(aaa)return aaa end,pause=function(aaa,baa)__a=
baa or(not __a)if(dd~=nil)then
if not(dd:isDead())then if not(__a)then
aaa:injectEvents(table.unpack(a_a))a_a={}end end end;return aaa end,isPaused=function(aaa)return
__a end,injectEvent=function(aaa,baa,caa,...)
if(dd~=nil)then if not(dd:isDead())then
if(__a==false)or(caa)then
c_a(aaa,baa,...)else table.insert(a_a,{event=baa,args={...}})end end end;return aaa end,getQueuedEvents=function(aaa)return
a_a end,updateQueuedEvents=function(aaa,baa)a_a=baa or a_a;return aaa end,injectEvents=function(aaa,...)if(dd~=nil)then
if not
(dd:isDead())then for baa,caa in pairs({...})do
c_a(aaa,caa.event,table.unpack(caa.args))end end end;return aaa end,mouseHandler=function(aaa,baa,caa,daa)
if
(bc.mouseHandler(aaa,baa,caa,daa))then d_a(aaa,"mouse_click",baa,caa,daa)return true end;return false end,mouseUpHandler=function(aaa,baa,caa,daa)
if
(bc.mouseUpHandler(aaa,baa,caa,daa))then d_a(aaa,"mouse_up",baa,caa,daa)return true end;return false end,scrollHandler=function(aaa,baa,caa,daa)
if
(bc.scrollHandler(aaa,baa,caa,daa))then d_a(aaa,"mouse_scroll",baa,caa,daa)return true end;return false end,dragHandler=function(aaa,baa,caa,daa)
if
(bc.dragHandler(aaa,baa,caa,daa))then d_a(aaa,"mouse_drag",baa,caa,daa)return true end;return false end,keyHandler=function(aaa,baa,caa)if
(bc.keyHandler(aaa,baa,caa))then _aa(aaa,"key",baa,caa)return true end;return
false end,keyUpHandler=function(aaa,baa)if
(bc.keyUpHandler(aaa,baa))then _aa(aaa,"key_up",baa)return true end
return false end,charHandler=function(aaa,baa)if
(bc.charHandler(aaa,baa))then _aa(aaa,"char",baa)return true end
return false end,getFocusHandler=function(aaa)
bc.getFocusHandler(aaa)
if(dd~=nil)then
if not(dd:isDead())then
if not(__a)then local baa=aaa:getParent()
if(baa~=nil)then
local caa,daa=cd.getCursorPos()local _ba,aba=aaa:getPosition()local bba,cba=aaa:getSize()
if
(

_ba+caa-1 >=1 and _ba+caa-1 <=_ba+bba-1 and daa+aba-1 >=1 and daa+aba-1 <=aba+cba-1)then
baa:setCursor(cd.getCursorBlink(),_ba+caa-1,daa+aba-1,cd.getTextColor())end end end end end end,loseFocusHandler=function(aaa)
bc.loseFocusHandler(aaa)
if(dd~=nil)then if not(dd:isDead())then local baa=aaa:getParent()if(baa~=nil)then
baa:setCursor(false)end end end end,eventHandler=function(aaa,baa,...)
bc.eventHandler(aaa,baa,...)if dd==nil then return end
if not dd:isDead()then
if not __a then c_a(aaa,baa,...)
if
aaa:isFocused()then local caa=aaa:getParent()local daa,_ba=aaa:getPosition()
local aba,bba=cd.getCursorPos()local cba,dba=aaa:getSize()
if daa+aba-1 >=1 and
daa+aba-1 <=daa+cba-1 and bba+_ba-1 >=1 and
bba+_ba-1 <=_ba+dba-1 then
caa:setCursor(cd.getCursorBlink(),
daa+aba-1,bba+_ba-1,cd.getTextColor())end end else table.insert(a_a,{event=baa,args={...}})end end end,resizeHandler=function(aaa,...)
bc.resizeHandler(aaa,...)
if(dd~=nil)then
if not(dd:isDead())then
if not(__a)then
cd.basalt_resize(aaa:getSize())c_a(aaa,"term_resize",aaa:getSize())else
cd.basalt_resize(aaa:getSize())
table.insert(a_a,{event="term_resize",args={aaa:getSize()}})end end end end,repositionHandler=function(aaa,...)
bc.repositionHandler(aaa,...)
if(dd~=nil)then if not(dd:isDead())then
cd.basalt_reposition(aaa:getPosition())end end end,draw=function(aaa)
bc.draw(aaa)
aaa:addDraw("program",function()local baa=aaa:getParent()local caa,daa=aaa:getPosition()
local _ba,aba=cd.getCursorPos()local bba,cba=aaa:getSize()cd.basalt_update()end)end,onError=function(aaa,...)
for caa,daa in
pairs(table.pack(...))do if(type(daa)=="function")then
aaa:registerEvent("program_error",daa)end end;local baa=aaa:getParent()aaa:listenEvent("other_event")
return aaa end,onDone=function(aaa,...)
for caa,daa in
pairs(table.pack(...))do if(type(daa)=="function")then
aaa:registerEvent("program_done",daa)end end;local baa=aaa:getParent()aaa:listenEvent("other_event")
return aaa end}dc.__index=dc;return setmetatable(dc,bc)end end
ba["objects"]["VisualObject"]=function(...)local bb=_b("utils")local cb=_b("tHex")
local db,_c,ac=string.sub,string.find,table.insert
return
function(bc,cc)local dc=cc.getObject("Object")(bc,cc)
local _d="VisualObject"local ad,bd,cd,dd,__a=true,false,false,false,false;local a_a=1;local b_a,c_a,d_a,_aa=1,1,1,1
local aaa,baa,caa,daa=0,0,0,0;local _ba,aba,bba=colors.black,colors.white,false;local cba;local dba={}local _ca={}local aca={}
local bca={}
local function cca(_da,ada)local bda={}if _da==""then return bda end;ada=ada or" "local cda=1
local dda,__b=_c(_da,ada,cda)
while dda do
ac(bda,{x=cda,value=db(_da,cda,dda-1)})cda=__b+1;dda,__b=_c(_da,ada,cda)end;ac(bda,{x=cda,value=db(_da,cda)})return bda end
local dca={getType=function(_da)return _d end,getBase=function(_da)return dc end,isType=function(_da,ada)
return _d==ada or
dc.isType~=nil and dc.isType(ada)or false end,getBasalt=function(_da)return cc end,show=function(_da)ad=true
_da:updateDraw()return _da end,hide=function(_da)ad=false;_da:updateDraw()return _da end,isVisible=function(_da)return
ad end,setVisible=function(_da,ada)ad=ada or not ad;_da:updateDraw()return _da end,setTransparency=function(_da,ada)bba=
ada~=nil and ada or true;_da:updateDraw()
return _da end,setParent=function(_da,ada,bda)
dc.setParent(_da,ada,bda)cba=ada;return _da end,setFocus=function(_da)if(cba~=nil)then
cba:setFocusedObject(_da)end;return _da end,setZIndex=function(_da,ada)a_a=ada
if
(cba~=nil)then cba:updateZIndex(_da,a_a)_da:updateDraw()end;return _da end,getZIndex=function(_da)return a_a end,updateDraw=function(_da)if(
cba~=nil)then cba:updateDraw()end;return _da end,setPosition=function(_da,ada,bda,cda)
local dda,__b=b_a,c_a
if(type(ada)=="number")then b_a=cda and b_a+ada or ada end
if(type(bda)=="number")then c_a=cda and c_a+bda or bda end;if(cba~=nil)then
cba:customEventHandler("basalt_FrameReposition",_da)end;if(_da:getType()=="Container")then
cba:customEventHandler("basalt_FrameReposition",_da)end;_da:updateDraw()
_da:repositionHandler(dda,__b)return _da end,getX=function(_da)return
b_a end,getY=function(_da)return c_a end,getPosition=function(_da)return b_a,c_a end,setSize=function(_da,ada,bda,cda)
local dda,__b=d_a,_aa
if(type(ada)=="number")then d_a=cda and d_a+ada or ada end
if(type(bda)=="number")then _aa=cda and _aa+bda or bda end
if(cba~=nil)then
cba:customEventHandler("basalt_FrameResize",_da)if(_da:getType()=="Container")then
cba:customEventHandler("basalt_FrameResize",_da)end end;_da:resizeHandler(dda,__b)_da:updateDraw()return _da end,getHeight=function(_da)return
_aa end,getWidth=function(_da)return d_a end,getSize=function(_da)return d_a,_aa end,setBackground=function(_da,ada)_ba=ada
_da:updateDraw()return _da end,getBackground=function(_da)return _ba end,setForeground=function(_da,ada)aba=ada or false
_da:updateDraw()return _da end,getForeground=function(_da)return aba end,getAbsolutePosition=function(_da,ada,bda)if
(ada==nil)or(bda==nil)then ada,bda=_da:getPosition()end
if(cba~=nil)then
local cda,dda=cba:getAbsolutePosition()ada=cda+ada-1;bda=dda+bda-1 end;return ada,bda end,ignoreOffset=function(_da,ada)
bd=ada;if(ada==nil)then bd=true end;return _da end,getIgnoreOffset=function(_da)return bd end,isCoordsInObject=function(_da,ada,bda)
if
(ad)and(_da:isEnabled())then
if(ada==nil)or(bda==nil)then return false end;local cda,dda=_da:getAbsolutePosition()local __b,a_b=_da:getSize()if

(cda<=ada)and(cda+__b>ada)and(dda<=bda)and(dda+a_b>bda)then return true end end;return false end,onGetFocus=function(_da,...)
for ada,bda in
pairs(table.pack(...))do if(type(bda)=="function")then
_da:registerEvent("get_focus",bda)end end;return _da end,onLoseFocus=function(_da,...)
for ada,bda in
pairs(table.pack(...))do if(type(bda)=="function")then
_da:registerEvent("lose_focus",bda)end end;return _da end,isFocused=function(_da)
if(
cba~=nil)then return cba:getFocusedObject()==_da end;return true end,resizeHandler=function(_da,...)
if(_da:isEnabled())then
local ada=_da:sendEvent("basalt_resize",...)if(ada==false)then return false end end;return true end,repositionHandler=function(_da,...)if
(_da:isEnabled())then local ada=_da:sendEvent("basalt_reposition",...)if(ada==false)then
return false end end;return
true end,onResize=function(_da,...)
for ada,bda in
pairs(table.pack(...))do if(type(bda)=="function")then
_da:registerEvent("basalt_resize",bda)end end;return _da end,onReposition=function(_da,...)
for ada,bda in
pairs(table.pack(...))do if(type(bda)=="function")then
_da:registerEvent("basalt_reposition",bda)end end;return _da end,mouseHandler=function(_da,ada,bda,cda,dda)
if
(_da:isCoordsInObject(bda,cda))then local __b,a_b=_da:getAbsolutePosition()
local b_b=_da:sendEvent("mouse_click",ada,bda- (__b-1),
cda- (a_b-1),bda,cda,dda)if(b_b==false)then return false end;if(cba~=nil)then
cba:setFocusedObject(_da)end;dd=true;__a=true;aaa,baa=bda,cda;return true end end,mouseUpHandler=function(_da,ada,bda,cda)
__a=false
if(dd)then local dda,__b=_da:getAbsolutePosition()
local a_b=_da:sendEvent("mouse_release",ada,bda- (dda-1),
cda- (__b-1),bda,cda)dd=false end
if(_da:isCoordsInObject(bda,cda))then local dda,__b=_da:getAbsolutePosition()
local a_b=_da:sendEvent("mouse_up",ada,
bda- (dda-1),cda- (__b-1),bda,cda)if(a_b==false)then return false end;return true end end,dragHandler=function(_da,ada,bda,cda)
if
(__a)then local dda,__b=_da:getAbsolutePosition()
local a_b=_da:sendEvent("mouse_drag",ada,bda- (dda-1),cda- (
__b-1),aaa-bda,baa-cda,bda,cda)aaa,baa=bda,cda;if(a_b~=nil)then return a_b end;if(cba~=nil)then
cba:setFocusedObject(_da)end;return true end
if(_da:isCoordsInObject(bda,cda))then local dda,__b=_da:getAbsolutePosition()
aaa,baa=bda,cda;caa,daa=dda-bda,__b-cda end end,scrollHandler=function(_da,ada,bda,cda)
if
(_da:isCoordsInObject(bda,cda))then local dda,__b=_da:getAbsolutePosition()
local a_b=_da:sendEvent("mouse_scroll",ada,bda- (dda-1),
cda- (__b-1))if(a_b==false)then return false end;if(cba~=nil)then
cba:setFocusedObject(_da)end;return true end end,hoverHandler=function(_da,ada,bda,cda)
if
(_da:isCoordsInObject(ada,bda))then local dda=_da:sendEvent("mouse_hover",ada,bda,cda)if(dda==false)then return
false end;cd=true;return true end
if(cd)then local dda=_da:sendEvent("mouse_leave",ada,bda,cda)if
(dda==false)then return false end;cd=false end end,keyHandler=function(_da,ada,bda)if
(_da:isEnabled())and(ad)then
if(_da:isFocused())then
local cda=_da:sendEvent("key",ada,bda)if(cda==false)then return false end;return true end end end,keyUpHandler=function(_da,ada)if
(_da:isEnabled())and(ad)then
if(_da:isFocused())then
local bda=_da:sendEvent("key_up",ada)if(bda==false)then return false end;return true end end end,charHandler=function(_da,ada)if
(_da:isEnabled())and(ad)then
if(_da:isFocused())then local bda=_da:sendEvent("char",ada)if(bda==
false)then return false end;return true end end end,getFocusHandler=function(_da)
local ada=_da:sendEvent("get_focus")if(ada~=nil)then return ada end;return true end,loseFocusHandler=function(_da)
__a=false;local ada=_da:sendEvent("lose_focus")
if(ada~=nil)then return ada end;return true end,addDraw=function(_da,ada,bda,cda,dda,__b)
local a_b=
(dda==nil or dda==1)and _ca or dda==2 and dba or dda==3 and aca;cda=cda or#a_b+1
if(ada~=nil)then for c_b,d_b in pairs(a_b)do if(d_b.name==ada)then
table.remove(a_b,c_b)break end end
local b_b={name=ada,f=bda,pos=cda,active=
__b~=nil and __b or true}table.insert(a_b,cda,b_b)end;_da:updateDraw()return _da end,addPreDraw=function(_da,ada,bda,cda,dda)
_da:addDraw(ada,bda,cda,2)return _da end,addPostDraw=function(_da,ada,bda,cda,dda)
_da:addDraw(ada,bda,cda,3)return _da end,setDrawState=function(_da,ada,bda,cda)
local dda=
(cda==nil or cda==1)and _ca or cda==2 and dba or cda==3 and aca
for __b,a_b in pairs(dda)do if(a_b.name==ada)then a_b.active=bda;break end end;_da:updateDraw()return _da end,getDrawId=function(_da,ada,bda)local cda=

bda==1 and _ca or bda==2 and dba or bda==3 and aca or _ca;for dda,__b in pairs(cda)do if(
__b.name==ada)then return dda end end end,addText=function(_da,ada,bda,cda)local dda=
_da:getParent()or _da;local __b,a_b=_da:getPosition()if(cba~=nil)then
local c_b,d_b=cba:getOffset()__b=bd and __b or __b-c_b
a_b=bd and a_b or a_b-d_b end
if not(bba)then dda:setText(ada+__b-1,
bda+a_b-1,cda)return end;local b_b=cca(cda,"\0")
for c_b,d_b in pairs(b_b)do if
(d_b.value~="")and(d_b.value~="\0")then
dda:setText(ada+d_b.x+__b-2,bda+a_b-1,d_b.value)end end end,addBG=function(_da,ada,bda,cda,dda)local __b=
cba or _da;local a_b,b_b=_da:getPosition()if(cba~=nil)then
local d_b,_ab=cba:getOffset()a_b=bd and a_b or a_b-d_b
b_b=bd and b_b or b_b-_ab end
if not(bba)then __b:setBG(ada+a_b-1,
bda+b_b-1,cda)return end;local c_b=cca(cda)
for d_b,_ab in pairs(c_b)do
if(_ab.value~="")and(_ab.value~=" ")then
if(dda~=
true)then
__b:setText(ada+_ab.x+a_b-2,bda+b_b-1,(" "):rep(#_ab.value))
__b:setBG(ada+_ab.x+a_b-2,bda+b_b-1,_ab.value)else
table.insert(bca,{x=ada+_ab.x-1,y=bda,bg=_ab.value})__b:setBG(ada+a_b-1,bda+b_b-1,fg)end end end end,addFG=function(_da,ada,bda,cda)local dda=
cba or _da;local __b,a_b=_da:getPosition()if(cba~=nil)then
local c_b,d_b=cba:getOffset()__b=bd and __b or __b-c_b
a_b=bd and a_b or a_b-d_b end
if not(bba)then dda:setFG(ada+__b-1,
bda+a_b-1,cda)return end;local b_b=cca(cda)
for c_b,d_b in pairs(b_b)do if(d_b.value~="")and(d_b.value~=" ")then
dda:setFG(
ada+d_b.x+__b-2,bda+a_b-1,d_b.value)end end end,addBlit=function(_da,ada,bda,cda,dda,__b)local a_b=
cba or _da;local b_b,c_b=_da:getPosition()if(cba~=nil)then
local bab,cab=cba:getOffset()b_b=bd and b_b or b_b-bab
c_b=bd and c_b or c_b-cab end
if not(bba)then a_b:blit(ada+b_b-1,
bda+c_b-1,cda,dda,__b)return end;local d_b=cca(cda,"\0")local _ab=cca(dda)local aab=cca(__b)
for bab,cab in pairs(d_b)do if
(cab.value~="")or(cab.value~="\0")then
a_b:setText(ada+cab.x+b_b-2,bda+c_b-1,cab.value)end end;for bab,cab in pairs(aab)do
if(cab.value~="")or(cab.value~=" ")then a_b:setBG(
ada+cab.x+b_b-2,bda+c_b-1,cab.value)end end;for bab,cab in pairs(_ab)do
if(
cab.value~="")or(cab.value~=" ")then a_b:setFG(ada+cab.x+b_b-2,bda+
c_b-1,cab.value)end end end,addTextBox=function(_da,ada,bda,cda,dda,__b)local a_b=
cba or _da;local b_b,c_b=_da:getPosition()if(cba~=nil)then
local d_b,_ab=cba:getOffset()b_b=bd and b_b or b_b-d_b
c_b=bd and c_b or c_b-_ab end;a_b:drawTextBox(ada+b_b-1,
bda+c_b-1,cda,dda,__b)end,addForegroundBox=function(_da,ada,bda,cda,dda,__b)local a_b=
cba or _da;local b_b,c_b=_da:getPosition()if(cba~=nil)then
local d_b,_ab=cba:getOffset()b_b=bd and b_b or b_b-d_b
c_b=bd and c_b or c_b-_ab end;a_b:drawForegroundBox(ada+b_b-1,
bda+c_b-1,cda,dda,__b)end,addBackgroundBox=function(_da,ada,bda,cda,dda,__b)local a_b=
cba or _da;local b_b,c_b=_da:getPosition()if(cba~=nil)then
local d_b,_ab=cba:getOffset()b_b=bd and b_b or b_b-d_b
c_b=bd and c_b or c_b-_ab end;a_b:drawBackgroundBox(ada+b_b-1,
bda+c_b-1,cda,dda,__b)end,render=function(_da)if
(ad)then _da:redraw()end end,redraw=function(_da)for ada,bda in pairs(dba)do if(bda.active)then
bda.f(_da)end end;for ada,bda in pairs(_ca)do if(bda.active)then
bda.f(_da)end end;for ada,bda in pairs(aca)do if(bda.active)then
bda.f(_da)end end;return true end,draw=function(_da)
_da:addDraw("base",function()
local ada,bda=_da:getSize()if(_ba~=false)then _da:addTextBox(1,1,ada,bda," ")
_da:addBackgroundBox(1,1,ada,bda,_ba)end;if(aba~=false)then
_da:addForegroundBox(1,1,ada,bda,aba)end end,1)end}dca.__index=dca;return setmetatable(dca,dc)end end
ba["objects"]["Switch"]=function(...)
return
function(bb,cb)
local db=cb.getObject("ChangeableObject")(bb,cb)local _c="Switch"db:setSize(4,1)db:setValue(false)
db:setZIndex(5)local ac=colors.black;local bc=colors.red;local cc=colors.green
local dc={getType=function(_d)return _c end,setSymbol=function(_d,ad)
ac=ad;return _d end,setActiveBackground=function(_d,ad)cc=ad;return _d end,setInactiveBackground=function(_d,ad)bc=ad;return _d end,load=function(_d)
_d:listenEvent("mouse_click")end,mouseHandler=function(_d,...)
if(db.mouseHandler(_d,...))then
_d:setValue(not _d:getValue())_d:updateDraw()return true end end,draw=function(_d)db.draw(_d)
_d:addDraw("switch",function()
local ad=_d:getParent()local bd,cd=_d:getBackground(),_d:getForeground()
local dd,__a=_d:getSize()
if(_d:getValue())then _d:addBackgroundBox(1,1,dd,__a,cc)
_d:addBackgroundBox(dd,1,1,__a,ac)else _d:addBackgroundBox(1,1,dd,__a,bc)
_d:addBackgroundBox(1,1,1,__a,ac)end end)end}dc.__index=dc;return setmetatable(dc,db)end end
ba["objects"]["Thread"]=function(...)
return
function(bb,cb)
local db=cb.getObject("Object")(bb,cb)local _c="Thread"local ac;local bc;local cc=false;local dc
local _d={getType=function(ad)return _c end,start=function(ad,bd)if(bd==nil)then
error("Function provided to thread is nil")end;ac=bd;bc=coroutine.create(ac)
cc=true;dc=nil;local cd,dd=coroutine.resume(bc)dc=dd;if not(cd)then
if(dd~="Terminated")then error(
"Thread Error Occurred - "..dd)end end
ad:listenEvent("mouse_click")ad:listenEvent("mouse_up")
ad:listenEvent("mouse_scroll")ad:listenEvent("mouse_drag")ad:listenEvent("key")
ad:listenEvent("key_up")ad:listenEvent("char")
ad:listenEvent("other_event")return ad end,getStatus=function(ad,bd)if(
bc~=nil)then return coroutine.status(bc)end;return nil end,stop=function(ad,bd)
cc=false;ad:listenEvent("mouse_click",false)
ad:listenEvent("mouse_up",false)ad:listenEvent("mouse_scroll",false)
ad:listenEvent("mouse_drag",false)ad:listenEvent("key",false)
ad:listenEvent("key_up",false)ad:listenEvent("char",false)
ad:listenEvent("other_event",false)return ad end,mouseHandler=function(ad,...)
ad:eventHandler("mouse_click",...)end,mouseUpHandler=function(ad,...)ad:eventHandler("mouse_up",...)end,mouseScrollHandler=function(ad,...)
ad:eventHandler("mouse_scroll",...)end,mouseDragHandler=function(ad,...)
ad:eventHandler("mouse_drag",...)end,mouseMoveHandler=function(ad,...)
ad:eventHandler("mouse_move",...)end,keyHandler=function(ad,...)ad:eventHandler("key",...)end,keyUpHandler=function(ad,...)
ad:eventHandler("key_up",...)end,charHandler=function(ad,...)ad:eventHandler("char",...)end,eventHandler=function(ad,bd,...)
db.eventHandler(ad,bd,...)
if(cc)then
if(coroutine.status(bc)=="suspended")then if(dc~=nil)then
if(bd~=dc)then return end;dc=nil end
local cd,dd=coroutine.resume(bc,bd,...)dc=dd;if not(cd)then if(dd~="Terminated")then
error("Thread Error Occurred - "..dd)end end else
ad:stop()end end end}_d.__index=_d;return setmetatable(_d,db)end end
ba["objects"]["Treeview"]=function(...)local bb=_b("utils")local cb=_b("tHex")
return
function(db,_c)
local ac=_c.getObject("ChangeableObject")(db,_c)local bc="Treeview"local cc={}local dc=colors.black;local _d=colors.lightGray;local ad=true
local bd="left"local cd,dd=0,0;local __a=true;ac:setSize(16,8)ac:setZIndex(5)
local function a_a(d_a,_aa)
d_a=d_a or""_aa=_aa or false;local aaa=false;local baa=nil;local caa={}local daa={}local _ba
daa={getChildren=function()return caa end,setParent=function(aba)if(
baa~=nil)then
baa.removeChild(baa.findChildrenByText(daa.getText()))end;baa=aba;ac:updateDraw()return daa end,getParent=function()return
baa end,addChild=function(aba,bba)local cba=a_a(aba,bba)cba.setParent(daa)
table.insert(caa,cba)ac:updateDraw()return cba end,setExpanded=function(aba)if
(_aa)then aaa=aba end;ac:updateDraw()return daa end,isExpanded=function()return
aaa end,onSelect=function(...)for aba,bba in pairs(table.pack(...))do if(type(bba)=="function")then
_ba=bba end end;return daa end,callOnSelect=function()if(
_ba~=nil)then _ba(daa)end end,setExpandable=function(aba)aba=aba
ac:updateDraw()return daa end,isExpandable=function()return _aa end,removeChild=function(aba)
if(type(aba)=="table")then for bba,cba in
pairs(aba)do if(cba==aba)then aba=bba;break end end end;table.remove(caa,aba)ac:updateDraw()return daa end,findChildrenByText=function(aba)
local bba={}
for cba,dba in ipairs(caa)do if string.find(dba.getText(),aba)then
table.insert(bba,dba)end end;return bba end,getText=function()return
d_a end,setText=function(aba)d_a=aba;ac:updateDraw()return daa end}return daa end;local b_a=a_a("Root",true)b_a.setExpanded(true)
local c_a={init=function(d_a)
local _aa=d_a:getParent()d_a:listenEvent("mouse_click")
d_a:listenEvent("mouse_scroll")return ac.init(d_a)end,getBase=function(d_a)return
ac end,getType=function(d_a)return bc end,isType=function(d_a,_aa)
return bc==_aa or
ac.isType~=nil and ac.isType(_aa)or false end,setOffset=function(d_a,_aa,aaa)cd=_aa;dd=aaa;return d_a end,getOffset=function(d_a)return
cd,dd end,setScrollable=function(d_a,_aa)__a=_aa;return d_a end,setSelectionColor=function(d_a,_aa,aaa,baa)dc=_aa or
d_a:getBackground()
_d=aaa or d_a:getForeground()ad=baa~=nil and baa or true;d_a:updateDraw()
return d_a end,getSelectionColor=function(d_a)
return dc,_d end,isSelectionColorActive=function(d_a)return ad end,getRoot=function(d_a)return b_a end,setRoot=function(d_a,_aa)b_a=_aa
_aa.setParent(nil)return d_a end,onSelect=function(d_a,...)for _aa,aaa in pairs(table.pack(...))do
if(type(aaa)==
"function")then d_a:registerEvent("treeview_select",aaa)end end;return d_a end,selectionHandler=function(d_a,_aa)
_aa.callOnSelect(_aa)d_a:sendEvent("treeview_select",_aa)return d_a end,mouseHandler=function(d_a,_aa,aaa,baa)
if
ac.mouseHandler(d_a,_aa,aaa,baa)then local caa=1 -dd;local daa,_ba=d_a:getAbsolutePosition()
local aba,bba=d_a:getSize()
local function cba(dba,_ca)
if baa==_ba+caa-1 then
if aaa>=daa and aaa<daa+aba then dba.setExpanded(not
dba.isExpanded())
d_a:selectionHandler(dba)d_a:setValue(dba)d_a:updateDraw()return true end end;caa=caa+1
if dba.isExpanded()then for aca,bca in ipairs(dba.getChildren())do if cba(bca,_ca+1)then return
true end end end;return false end
for dba,_ca in ipairs(b_a.getChildren())do if cba(_ca,1)then return true end end end end,scrollHandler=function(d_a,_aa,aaa,baa)
if
ac.scrollHandler(d_a,_aa,aaa,baa)then
if __a then local caa,daa=d_a:getSize()dd=dd+_aa;if dd<0 then dd=0 end
if _aa>=1 then local _ba=0
local function aba(bba,cba)
_ba=_ba+1;if bba.isExpanded()then
for dba,_ca in ipairs(bba.getChildren())do aba(_ca,cba+1)end end end;for bba,cba in ipairs(b_a.getChildren())do aba(cba,1)end
if
_ba>daa then if dd>_ba-daa then dd=_ba-daa end else dd=dd-1 end end;d_a:updateDraw()end;return true end;return false end,draw=function(d_a)
ac.draw(d_a)
d_a:addDraw("treeview",function()local _aa=1 -dd;local aaa=d_a:getValue()
local function baa(caa,daa)
local _ba,aba=d_a:getSize()
if _aa>=1 and _aa<=aba then
local bba=(caa==aaa)and dc or d_a:getBackground()
local cba=(caa==aaa)and _d or d_a:getForeground()local dba=caa.getText()
d_a:addBlit(1 +daa+cd,_aa,dba,cb[cba]:rep(#dba),cb[bba]:rep(
#dba))end;_aa=_aa+1;if caa.isExpanded()then for bba,cba in ipairs(caa.getChildren())do
baa(cba,daa+1)end end end;for caa,daa in ipairs(b_a.getChildren())do baa(daa,1)end end)end}c_a.__index=c_a;return setmetatable(c_a,ac)end end
ba["objects"]["Timer"]=function(...)
return
function(bb,cb)
local db=cb.getObject("Object")(bb,cb)local _c="Timer"local ac=0;local bc=0;local cc=0;local dc;local _d=false
local ad={getType=function(bd)return _c end,setTime=function(bd,cd,dd)ac=cd or 0
bc=dd or 1;return bd end,start=function(bd)
if(_d)then os.cancelTimer(dc)end;cc=bc;dc=os.startTimer(ac)_d=true
bd:listenEvent("other_event")return bd end,isActive=function(bd)return _d end,cancel=function(bd)if(
dc~=nil)then os.cancelTimer(dc)end;_d=false
bd:removeEvent("other_event")return bd end,onCall=function(bd,cd)
bd:registerEvent("timed_event",cd)return bd end,eventHandler=function(bd,cd,...)db.eventHandler(bd,cd,...)
if
cd=="timer"and tObj==dc and _d then
bd:sendEvent("timed_event")if(cc>=1)then cc=cc-1;if(cc>=1)then dc=os.startTimer(ac)end elseif(cc==-1)then
dc=os.startTimer(ac)end end end}ad.__index=ad;return setmetatable(ad,db)end end
ba["objects"]["Textfield"]=function(...)local bb=_b("tHex")
local cb,db,_c,ac,bc=string.rep,string.find,string.gmatch,string.sub,string.len
return
function(cc,dc)
local _d=dc.getObject("ChangeableObject")(cc,dc)local ad="Textfield"local bd,cd,dd,__a=1,1,1,1;local a_a={""}local b_a={""}local c_a={""}local d_a={}local _aa={}
local aaa,baa,caa,daa;local _ba,aba=colors.lightBlue,colors.black;_d:setSize(30,12)
_d:setZIndex(5)
local function bba()if
(aaa~=nil)and(baa~=nil)and(caa~=nil)and(daa~=nil)then return true end;return false end
local function cba()local dca,_da,ada,bda=aaa,baa,caa,daa
if bba()then
if aaa<baa and caa<=daa then dca=aaa;_da=baa;if caa<daa then
ada=caa;bda=daa else ada=daa;bda=caa end elseif aaa>baa and caa>=daa then
dca=baa;_da=aaa;if caa>daa then ada=daa;bda=caa else ada=caa;bda=daa end elseif caa>daa then
dca=baa;_da=aaa;ada=daa;bda=caa end;return dca,_da,ada,bda end end
local function dba(dca)local _da,ada,bda,cda=cba(dca)local dda=a_a[bda]local __b=a_a[cda]
a_a[bda]=
dda:sub(1,_da-1)..__b:sub(ada+1,__b:len())b_a[bda]=b_a[bda]:sub(1,_da-1)..
b_a[cda]:sub(ada+1,b_a[cda]:len())
c_a[bda]=c_a[bda]:sub(1,
_da-1)..c_a[cda]:sub(ada+1,c_a[cda]:len())
for i=cda,bda+1,-1 do if i~=bda then table.remove(a_a,i)table.remove(b_a,i)
table.remove(c_a,i)end end;dd,__a=_da,bda;aaa,baa,caa,daa=nil,nil,nil,nil;return dca end
local function _ca(dca,_da)local ada={}
if(dca:len()>0)then
for bda in _c(dca,_da)do local cda,dda=db(dca,bda)
if
(cda~=nil)and(dda~=nil)then table.insert(ada,cda)table.insert(ada,dda)
local __b=ac(dca,1,(cda-1))local a_b=ac(dca,dda+1,dca:len())dca=__b.. (":"):rep(bda:len())..
a_b end end end;return ada end
local function aca(dca,_da)_da=_da or __a
local ada=bb[dca:getForeground()]:rep(c_a[_da]:len())
local bda=bb[dca:getBackground()]:rep(b_a[_da]:len())
for cda,dda in pairs(_aa)do local __b=_ca(a_a[_da],dda[1])
if(#__b>0)then
for x=1,#__b/2 do
local a_b=x*2 -1;if(dda[2]~=nil)then
ada=ada:sub(1,__b[a_b]-1)..bb[dda[2]]:rep(__b[a_b+1]- (
__b[a_b]-1))..
ada:sub(__b[a_b+1]+1,ada:len())end;if
(dda[3]~=nil)then
bda=bda:sub(1,__b[a_b]-1)..

bb[dda[3]]:rep(__b[a_b+1]- (__b[a_b]-1))..bda:sub(__b[a_b+1]+1,bda:len())end end end end
for cda,dda in pairs(d_a)do
for __b,a_b in pairs(dda)do local b_b=_ca(a_a[_da],a_b)
if(#b_b>0)then for x=1,#b_b/2 do
local c_b=x*2 -1
ada=ada:sub(1,b_b[c_b]-1)..

bb[cda]:rep(b_b[c_b+1]- (b_b[c_b]-1))..ada:sub(b_b[c_b+1]+1,ada:len())end end end end;c_a[_da]=ada;b_a[_da]=bda;dca:updateDraw()end;local function bca(dca)for n=1,#a_a do aca(dca,n)end end
local cca={getType=function(dca)return ad end,setBackground=function(dca,_da)
_d.setBackground(dca,_da)bca(dca)return dca end,setForeground=function(dca,_da)
_d.setForeground(dca,_da)bca(dca)return dca end,setSelection=function(dca,_da,ada)aba=_da or aba
_ba=ada or _ba;return dca end,getSelection=function(dca)return aba,_ba end,getLines=function(dca)return a_a end,getLine=function(dca,_da)return
a_a[_da]end,editLine=function(dca,_da,ada)a_a[_da]=ada or a_a[_da]
aca(dca,_da)dca:updateDraw()return dca end,clear=function(dca)
a_a={""}b_a={""}c_a={""}aaa,baa,caa,daa=nil,nil,nil,nil;bd,cd,dd,__a=1,1,1,1
dca:updateDraw()return dca end,addLine=function(dca,_da,ada)
if(_da~=nil)then
local bda=dca:getBackground()local cda=dca:getForeground()
if(#a_a==1)and(a_a[1]=="")then
a_a[1]=_da;b_a[1]=bb[bda]:rep(_da:len())
c_a[1]=bb[cda]:rep(_da:len())aca(dca,1)return dca end
if(ada~=nil)then table.insert(a_a,ada,_da)
table.insert(b_a,ada,bb[bda]:rep(_da:len()))
table.insert(c_a,ada,bb[cda]:rep(_da:len()))else table.insert(a_a,_da)
table.insert(b_a,bb[bda]:rep(_da:len()))
table.insert(c_a,bb[cda]:rep(_da:len()))end end;aca(dca,ada or#a_a)dca:updateDraw()return dca end,addKeywords=function(dca,_da,ada)if(
d_a[_da]==nil)then d_a[_da]={}end;for bda,cda in pairs(ada)do
table.insert(d_a[_da],cda)end;dca:updateDraw()return dca end,addRule=function(dca,_da,ada,bda)
table.insert(_aa,{_da,ada,bda})dca:updateDraw()return dca end,editRule=function(dca,_da,ada,bda)for cda,dda in
pairs(_aa)do
if(dda[1]==_da)then _aa[cda][2]=ada;_aa[cda][3]=bda end end;dca:updateDraw()return dca end,removeRule=function(dca,_da)
for ada,bda in
pairs(_aa)do if(bda[1]==_da)then table.remove(_aa,ada)end end;dca:updateDraw()return dca end,setKeywords=function(dca,_da,ada)
d_a[_da]=ada;dca:updateDraw()return dca end,removeLine=function(dca,_da)
if(#a_a>1)then table.remove(a_a,
_da or#a_a)
table.remove(b_a,_da or#b_a)table.remove(c_a,_da or#c_a)else a_a={""}b_a={""}c_a={""}end;dca:updateDraw()return dca end,getTextCursor=function(dca)return
dd,__a end,getOffset=function(dca)return cd,bd end,setOffset=function(dca,_da,ada)cd=_da or cd;bd=ada or bd
dca:updateDraw()return dca end,getFocusHandler=function(dca)
_d.getFocusHandler(dca)local _da,ada=dca:getPosition()
dca:getParent():setCursor(true,_da+dd-cd,
ada+__a-bd,dca:getForeground())end,loseFocusHandler=function(dca)
_d.loseFocusHandler(dca)dca:getParent():setCursor(false)end,keyHandler=function(dca,_da)
if
(_d.keyHandler(dca,event,_da))then local ada=dca:getParent()local bda,cda=dca:getPosition()
local dda,__b=dca:getSize()
if(_da==keys.backspace)then
if(bba())then dba(dca)else
if(a_a[__a]=="")then
if(__a>1)then
table.remove(a_a,__a)table.remove(c_a,__a)table.remove(b_a,__a)dd=
a_a[__a-1]:len()+1;cd=dd-dda+1;if(cd<1)then cd=1 end;__a=__a-1 end elseif(dd<=1)then
if(__a>1)then dd=a_a[__a-1]:len()+1;cd=dd-dda+1;if(cd<
1)then cd=1 end;a_a[__a-1]=a_a[__a-1]..a_a[__a]c_a[
__a-1]=c_a[__a-1]..c_a[__a]b_a[__a-1]=b_a[__a-1]..
b_a[__a]table.remove(a_a,__a)
table.remove(c_a,__a)table.remove(b_a,__a)__a=__a-1 end else a_a[__a]=a_a[__a]:sub(1,dd-2)..
a_a[__a]:sub(dd,a_a[__a]:len())
c_a[__a]=c_a[__a]:sub(1,
dd-2)..c_a[__a]:sub(dd,c_a[__a]:len())b_a[__a]=b_a[__a]:sub(1,dd-2)..
b_a[__a]:sub(dd,b_a[__a]:len())
if(dd>1)then dd=dd-1 end;if(cd>1)then if(dd<cd)then cd=cd-1 end end end;if(__a<bd)then bd=bd-1 end end;aca(dca)dca:setValue("")elseif(_da==keys.delete)then
if(bba())then dba(dca)else
if(dd>
a_a[__a]:len())then
if(a_a[__a+1]~=nil)then
a_a[__a]=a_a[__a]..a_a[__a+1]table.remove(a_a,__a+1)table.remove(b_a,__a+1)table.remove(c_a,
__a+1)end else a_a[__a]=a_a[__a]:sub(1,dd-1)..
a_a[__a]:sub(dd+1,a_a[__a]:len())
c_a[__a]=c_a[__a]:sub(1,
dd-1)..c_a[__a]:sub(dd+1,c_a[__a]:len())b_a[__a]=b_a[__a]:sub(1,dd-1)..
b_a[__a]:sub(dd+1,b_a[__a]:len())end end;aca(dca)elseif(_da==keys.enter)then if(bba())then dba(dca)end
table.insert(a_a,__a+1,a_a[__a]:sub(dd,a_a[__a]:len()))
table.insert(c_a,__a+1,c_a[__a]:sub(dd,c_a[__a]:len()))
table.insert(b_a,__a+1,b_a[__a]:sub(dd,b_a[__a]:len()))a_a[__a]=a_a[__a]:sub(1,dd-1)
c_a[__a]=c_a[__a]:sub(1,dd-1)b_a[__a]=b_a[__a]:sub(1,dd-1)__a=__a+1;dd=1;cd=1;if
(__a-bd>=__b)then bd=bd+1 end;dca:setValue("")elseif(_da==keys.up)then
aaa,caa,baa,daa=nil,nil,nil,nil
if(__a>1)then __a=__a-1;if(dd>a_a[__a]:len()+1)then dd=
a_a[__a]:len()+1 end;if(cd>1)then if(dd<cd)then cd=dd-dda+1;if
(cd<1)then cd=1 end end end;if(
bd>1)then if(__a<bd)then bd=bd-1 end end end elseif(_da==keys.down)then aaa,caa,baa,daa=nil,nil,nil,nil
if(__a<#a_a)then __a=__a+1
if(dd>
a_a[__a]:len()+1)then dd=a_a[__a]:len()+1 end
if(cd>1)then if(dd<cd)then cd=dd-dda+1;if(cd<1)then cd=1 end end end;if(__a>=bd+__b)then bd=bd+1 end end elseif(_da==keys.right)then aaa,caa,baa,daa=nil,nil,nil,nil;dd=dd+1
if(__a<#a_a)then if(dd>
a_a[__a]:len()+1)then dd=1;__a=__a+1 end elseif(dd>
a_a[__a]:len())then dd=a_a[__a]:len()+1 end;if(dd<1)then dd=1 end
if(dd<cd)or(dd>=dda+cd)then cd=dd-dda+1 end;if(cd<1)then cd=1 end elseif(_da==keys.left)then aaa,caa,baa,daa=nil,nil,nil,nil;dd=dd-1
if(dd>=1)then if(
dd<cd)or(dd>=dda+cd)then cd=dd end end;if(__a>1)then if(dd<1)then __a=__a-1;dd=a_a[__a]:len()+1
cd=dd-dda+1 end end
if(dd<1)then dd=1 end;if(cd<1)then cd=1 end elseif(_da==keys.tab)then
if(dd%3 ==0)then
a_a[__a]=
a_a[__a]:sub(1,dd-1).." "..a_a[__a]:sub(dd,a_a[__a]:len())
c_a[__a]=c_a[__a]:sub(1,dd-1)..bb[dca:getForeground()]..
c_a[__a]:sub(dd,c_a[__a]:len())
b_a[__a]=b_a[__a]:sub(1,dd-1)..bb[dca:getBackground()]..
b_a[__a]:sub(dd,b_a[__a]:len())dd=dd+1 end
while dd%3 ~=0 do
a_a[__a]=a_a[__a]:sub(1,dd-1).." "..
a_a[__a]:sub(dd,a_a[__a]:len())
c_a[__a]=c_a[__a]:sub(1,dd-1)..bb[dca:getForeground()]..
c_a[__a]:sub(dd,c_a[__a]:len())
b_a[__a]=b_a[__a]:sub(1,dd-1)..bb[dca:getBackground()]..
b_a[__a]:sub(dd,b_a[__a]:len())dd=dd+1 end end
if not
( (bda+dd-cd>=bda and bda+dd-cd<bda+dda)and(
cda+__a-bd>=cda and cda+__a-bd<cda+__b))then cd=math.max(1,
a_a[__a]:len()-dda+1)
bd=math.max(1,__a-__b+1)end;local a_b=
(dd<=a_a[__a]:len()and dd-1 or a_a[__a]:len())- (cd-1)
if(a_b>
dca:getX()+dda-1)then a_b=dca:getX()+dda-1 end
local b_b=(__a-bd<__b and __a-bd or __a-bd-1)if(a_b<1)then a_b=0 end
ada:setCursor(true,bda+a_b,cda+b_b,dca:getForeground())dca:updateDraw()return true end end,charHandler=function(dca,_da)
if
(_d.charHandler(dca,_da))then local ada=dca:getParent()local bda,cda=dca:getPosition()
local dda,__b=dca:getSize()if(bba())then dba(dca)end
a_a[__a]=a_a[__a]:sub(1,dd-1).._da..
a_a[__a]:sub(dd,a_a[__a]:len())
c_a[__a]=c_a[__a]:sub(1,dd-1)..bb[dca:getForeground()]..
c_a[__a]:sub(dd,c_a[__a]:len())
b_a[__a]=b_a[__a]:sub(1,dd-1)..bb[dca:getBackground()]..
b_a[__a]:sub(dd,b_a[__a]:len())dd=dd+1;if(dd>=dda+cd)then cd=cd+1 end;aca(dca)
dca:setValue("")
if not
( (bda+dd-cd>=bda and bda+dd-cd<bda+dda)and(
cda+__a-bd>=cda and cda+__a-bd<cda+__b))then cd=math.max(1,
a_a[__a]:len()-dda+1)
bd=math.max(1,__a-__b+1)end;local a_b=
(dd<=a_a[__a]:len()and dd-1 or a_a[__a]:len())- (cd-1)
if(a_b>
dca:getX()+dda-1)then a_b=dca:getX()+dda-1 end
local b_b=(__a-bd<__b and __a-bd or __a-bd-1)if(a_b<1)then a_b=0 end
ada:setCursor(true,bda+a_b,cda+b_b,dca:getForeground())dca:updateDraw()return true end end,dragHandler=function(dca,_da,ada,bda)
if
(_d.dragHandler(dca,_da,ada,bda))then local cda=dca:getParent()local dda,__b=dca:getAbsolutePosition()
local a_b,b_b=dca:getPosition()local c_b,d_b=dca:getSize()
if(a_a[bda-__b+bd]~=nil)then
if
a_b<=ada-dda+cd and a_b+c_b>ada-dda+cd then dd=ada-dda+cd;__a=
bda-__b+bd;if dd>a_a[__a]:len()then
dd=a_a[__a]:len()+1 end;baa=dd;daa=__a
if dd<cd then cd=dd-1;if cd<1 then cd=1 end end
cda:setCursor(not bba(),a_b+dd-cd,b_b+__a-bd,dca:getForeground())dca:updateDraw()end end;return true end end,scrollHandler=function(dca,_da,ada,bda)
if
(_d.scrollHandler(dca,_da,ada,bda))then local cda=dca:getParent()local dda,__b=dca:getAbsolutePosition()
local a_b,b_b=dca:getPosition()local c_b,d_b=dca:getSize()bd=bd+_da;if(bd>#a_a- (d_b-1))then
bd=#a_a- (d_b-1)end;if(bd<1)then bd=1 end
if(dda+dd-cd>=dda and dda+dd-cd<
dda+c_b)and(b_b+__a-bd>=b_b and
b_b+__a-bd<b_b+d_b)then
cda:setCursor(not bba(),
a_b+dd-cd,b_b+__a-bd,dca:getForeground())else cda:setCursor(false)end;dca:updateDraw()return true end end,mouseHandler=function(dca,_da,ada,bda)
if
(_d.mouseHandler(dca,_da,ada,bda))then local cda=dca:getParent()local dda,__b=dca:getAbsolutePosition()
local a_b,b_b=dca:getPosition()
if(a_a[bda-__b+bd]~=nil)then dd=ada-dda+cd;__a=bda-__b+bd;baa=
nil;daa=nil;aaa=dd;caa=__a;if(dd>a_a[__a]:len())then dd=
a_a[__a]:len()+1;aaa=dd end;if(dd<cd)then cd=dd-1
if(cd<1)then cd=1 end end;dca:updateDraw()end
cda:setCursor(true,a_b+dd-cd,b_b+__a-bd,dca:getForeground())return true end end,mouseUpHandler=function(dca,_da,ada,bda)
if
(_d.mouseUpHandler(dca,_da,ada,bda))then local cda,dda=dca:getAbsolutePosition()
local __b,a_b=dca:getPosition()
if(a_a[bda-dda+bd]~=nil)then baa=ada-cda+cd
daa=bda-dda+bd
if(baa>a_a[daa]:len())then baa=a_a[daa]:len()+1 end
if(aaa==baa)and(caa==daa)then aaa,baa,caa,daa=nil,nil,nil,nil end;dca:updateDraw()end;return true end end,eventHandler=function(dca,_da,ada,bda,cda,dda)
if
(_d.eventHandler(dca,_da,ada,bda,cda,dda))then
if(_da=="paste")then
if(dca:isFocused())then local __b=dca:getParent()
local a_b,b_b=dca:getForeground(),dca:getBackground()local c_b,d_b=dca:getSize()
a_a[__a]=a_a[__a]:sub(1,dd-1)..ada..
a_a[__a]:sub(dd,a_a[__a]:len())
c_a[__a]=c_a[__a]:sub(1,dd-1)..bb[a_b]:rep(ada:len())..
c_a[__a]:sub(dd,c_a[__a]:len())
b_a[__a]=b_a[__a]:sub(1,dd-1)..bb[b_b]:rep(ada:len())..
b_a[__a]:sub(dd,b_a[__a]:len())dd=dd+ada:len()if(dd>=c_b+cd)then cd=(dd+1)-c_b end
local _ab,aab=dca:getPosition()
__b:setCursor(true,_ab+dd-cd,aab+__a-bd,a_b)aca(dca)dca:updateDraw()end end end end,draw=function(dca)
_d.draw(dca)
dca:addDraw("textfield",function()local _da=dca:getParent()local ada,bda=dca:getPosition()
local cda,dda=dca:getSize()local __b=bb[dca:getBackground()]
local a_b=bb[dca:getForeground()]
for n=1,dda do local b_b=""local c_b=""local d_b=""if a_a[n+bd-1]then b_b=a_a[n+bd-1]
d_b=c_a[n+bd-1]c_b=b_a[n+bd-1]end
b_b=ac(b_b,cd,cda+cd-1)c_b=cb(__b,cda)d_b=cb(a_b,cda)dca:addText(1,n,b_b)
dca:addBG(1,n,c_b)dca:addFG(1,n,d_b)dca:addBlit(1,n,b_b,d_b,c_b)end
if aaa and baa and caa and daa then local b_b,c_b,d_b,_ab=cba(dca)
for n=d_b,_ab do
local aab=#a_a[n]local bab=0
if n==d_b and n==_ab then bab=b_b-1
aab=aab- (b_b-1)- (aab-c_b)elseif n==_ab then aab=aab- (aab-c_b)elseif n==d_b then aab=aab- (b_b-1)bab=b_b-1 end;dca:addBG(1 +bab,n,cb(bb[_ba],aab))
dca:addFG(1 +bab,n,cb(bb[aba],aab))end end end)end,load=function(dca)
dca:listenEvent("mouse_click")dca:listenEvent("mouse_up")
dca:listenEvent("mouse_scroll")dca:listenEvent("mouse_drag")
dca:listenEvent("key")dca:listenEvent("char")
dca:listenEvent("other_event")end}cca.__index=cca;return setmetatable(cca,_d)end end;ba["libraries"]={}
ba["libraries"]["basaltLogs"]=function(...)local bb=""
local cb="basaltLog.txt"local db="Debug"
fs.delete(bb~=""and bb.."/"..cb or cb)
local _c={__call=function(ac,bc,cc)if(bc==nil)then return end
local dc=bb~=""and bb.."/"..cb or cb
local _d=fs.open(dc,fs.exists(dc)and"a"or"w")
_d.writeLine("[Basalt]["..
os.date("%Y-%m-%d %H:%M:%S").."][".. (cc and cc or db)..
"]: "..tostring(bc))_d.close()end}return setmetatable({},_c)end
ba["libraries"]["process"]=function(...)local bb={}local cb={}local db=0
local _c=dofile("rom/modules/main/cc/require.lua").make
function cb:new(ac,bc,cc,...)local dc={...}
local _d=setmetatable({path=ac},{__index=self})_d.window=bc;bc.current=term.current;bc.redirect=term.redirect
_d.processId=db
if(type(ac)=="string")then
_d.coroutine=coroutine.create(function()
local ad=shell.resolveProgram(ac)local bd=setmetatable(cc,{__index=_ENV})bd.shell=shell
bd.basaltProgram=true;bd.arg={[0]=ac,table.unpack(dc)}
if(ad==nil)then error("The path "..ac..
" does not exist!")end;bd.require,bd.package=_c(bd,fs.getDir(ad))
if(fs.exists(ad))then
local cd=fs.open(ad,"r")local dd=cd.readAll()cd.close()local __a=load(dd,ac,"bt",bd)if
(__a~=nil)then return __a()end end end)elseif(type(ac)=="function")then
_d.coroutine=coroutine.create(function()
ac(table.unpack(dc))end)else return end;bb[db]=_d;db=db+1;return _d end
function cb:resume(ac,...)local bc=term.current()term.redirect(self.window)
if(
self.filter~=nil)then if(ac~=self.filter)then return end;self.filter=nil end;local cc,dc=coroutine.resume(self.coroutine,ac,...)if cc then
self.filter=dc else printError(dc)end;term.redirect(bc)
return cc,dc end
function cb:isDead()
if(self.coroutine~=nil)then
if
(coroutine.status(self.coroutine)=="dead")then table.remove(bb,self.processId)return true end else return true end;return false end
function cb:getStatus()if(self.coroutine~=nil)then
return coroutine.status(self.coroutine)end;return nil end
function cb:start()coroutine.resume(self.coroutine)end;return cb end
ba["libraries"]["tHex"]=function(...)local bb={}
for i=0,15 do bb[2 ^i]=("%x"):format(i)end;return bb end
ba["libraries"]["images"]=function(...)local bb,cb=string.sub,math.floor;local function db(bd)return
{[1]={{},{},paintutils.loadImage(bd)}},"bimg"end;local function _c(bd)return
paintutils.loadImage(bd),"nfp"end
local function ac(bd,cd)
local dd=fs.open(bd,cd and"rb"or"r")if(dd==nil)then
error("Path - "..bd.." doesn't exist!")end
local __a=textutils.unserialize(dd.readAll())dd.close()if(__a~=nil)then return __a,"bimg"end end;local function bc(bd)end;local function cc(bd)end;local function dc(bd,cd,dd)
if(bb(bd,-4)==".bimg")then return ac(bd,dd)elseif
(bb(bd,-3)==".bbf")then return bc(bd,dd)else return _c(bd,dd)end end;local function _d(bd)
if
(bd:find(".bimg"))then return ac(bd)elseif(bd:find(".bbf"))then return cc(bd)else return db(bd)end end
local function ad(bd,cd,dd)local __a,a_a=bd.width or#
bd[1][1][1],bd.height or#bd[1]
local b_a={}
for c_a,d_a in pairs(bd)do
if(type(c_a)=="number")then local _aa={}
for y=1,dd do local aaa,baa,caa="","",""
local daa=cb(y/dd*a_a+0.5)
if(d_a[daa]~=nil)then
for x=1,cd do local _ba=cb(x/cd*__a+0.5)aaa=aaa..
bb(d_a[daa][1],_ba,_ba)
baa=baa..bb(d_a[daa][2],_ba,_ba)caa=caa..bb(d_a[daa][3],_ba,_ba)end;table.insert(_aa,{aaa,baa,caa})end end;table.insert(b_a,c_a,_aa)else b_a[c_a]=d_a end end;b_a.width=cd;b_a.height=dd;return b_a end
return{loadNFP=_c,loadBIMG=ac,loadImage=dc,resizeBIMG=ad,loadImageAsBimg=_d}end
ba["libraries"]["utils"]=function(...)local bb=_b("tHex")
local cb,db,_c,ac,bc,cc=string.sub,string.find,string.reverse,string.rep,table.insert,string.len
local function dc(dd,__a)local a_a={}if dd==""or __a==""then return a_a end;local b_a=1
local c_a,d_a=db(dd,__a,b_a)while c_a do bc(a_a,cb(dd,b_a,c_a-1))b_a=d_a+1
c_a,d_a=db(dd,__a,b_a)end;bc(a_a,cb(dd,b_a))return a_a end;local function _d(dd)return dd:gsub("{[^}]+}","")end
local function ad(dd,__a)dd=_d(dd)if
(dd=="")or(__a==0)then return{""}end;local a_a=dc(dd,"\n")local b_a={}
for c_a,d_a in
pairs(a_a)do
if#d_a==0 then table.insert(b_a,"")else
while#d_a>__a do local _aa=__a;for i=__a,1,-1 do if
cb(d_a,i,i)==" "then _aa=i;break end end
if _aa==__a then local aaa=
cb(d_a,1,_aa-1).."-"table.insert(b_a,aaa)
d_a=cb(d_a,_aa)else local aaa=cb(d_a,1,_aa-1)table.insert(b_a,aaa)
d_a=cb(d_a,_aa+1)end;if#d_a<=__a then break end end;if#d_a>0 then table.insert(b_a,d_a)end end end;return b_a end
local function bd(dd)local __a={}local a_a=1;local b_a=1
while a_a<=#dd do local c_a,d_a;local _aa,aaa;local baa,caa
for aba,bba in pairs(colors)do
local cba="{fg:"..aba.."}"local dba="{bg:"..aba.."}"local _ca,aca=dd:find(cba,a_a)
local bca,cca=dd:find(dba,a_a)
if _ca and(not c_a or _ca<c_a)then c_a=_ca;_aa=aba;baa=aca end
if bca and(not d_a or bca<d_a)then d_a=bca;aaa=aba;caa=cca end end;local daa
if c_a and(not d_a or c_a<d_a)then daa=c_a elseif d_a then daa=d_a else daa=#dd+1 end;local _ba=dd:sub(a_a,daa-1)
if#_ba>0 then
table.insert(__a,{color=nil,bgColor=nil,text=_ba,position=b_a})b_a=b_a+#_ba;a_a=a_a+#_ba end
if c_a and(not d_a or c_a<d_a)then
table.insert(__a,{color=_aa,bgColor=nil,text="",position=b_a})a_a=baa+1 elseif d_a then
table.insert(__a,{color=nil,bgColor=aaa,text="",position=b_a})a_a=caa+1 else break end end;return __a end
local function cd(dd,__a)local a_a=bd(dd)local b_a={}local c_a,d_a=1,1;local _aa,aaa;local function baa(caa)
table.insert(b_a,{x=c_a,y=d_a,text=caa.text,color=caa.color or _aa,bgColor=
caa.bgColor or aaa})end
for caa,daa in ipairs(a_a)do
if
daa.color then _aa=daa.color elseif daa.bgColor then aaa=daa.bgColor else local _ba=dc(daa.text," ")
for aba,bba in
ipairs(_ba)do local cba=#bba
if aba>1 then if c_a+1 +cba<=__a then baa({text=" "})c_a=c_a+1 else c_a=1;d_a=
d_a+1 end end;while cba>0 do local dba=bba:sub(1,__a-c_a+1)
bba=bba:sub(__a-c_a+2)cba=#bba;baa({text=dba})
if cba>0 then c_a=1;d_a=d_a+1 else c_a=c_a+#dba end end end end;if c_a>__a then c_a=1;d_a=d_a+1 end end;return b_a end
return
{getTextHorizontalAlign=function(dd,__a,a_a,b_a)dd=cb(dd,1,__a)local c_a=__a-cc(dd)
if(a_a=="right")then
dd=ac(b_a or" ",c_a)..dd elseif(a_a=="center")then
dd=ac(b_a or" ",math.floor(c_a/2))..dd..ac(b_a or" ",math.floor(
c_a/2))
dd=dd.. (cc(dd)<__a and(b_a or" ")or"")else dd=dd..ac(b_a or" ",c_a)end;return dd end,getTextVerticalAlign=function(dd,__a)
local a_a=0
if(__a=="center")then a_a=math.ceil(dd/2)if(a_a<1)then a_a=1 end end;if(__a=="bottom")then a_a=dd end;if(a_a<1)then a_a=1 end;return a_a end,orderedTable=function(dd)
local __a={}for a_a,b_a in pairs(dd)do __a[#__a+1]=b_a end;return __a end,rpairs=function(dd)return
function(__a,a_a)a_a=
a_a-1;if a_a~=0 then return a_a,__a[a_a]end end,dd,#dd+1 end,tableCount=function(dd)
local __a=0
if(dd~=nil)then for a_a,b_a in pairs(dd)do __a=__a+1 end end;return __a end,splitString=dc,removeTags=_d,wrapText=ad,xmlValue=function(dd,__a)local a_a;if(type(__a)~=
"table")then return end
if(__a[dd]~=nil)then if
(type(__a[dd])=="table")then
if(__a[dd].value~=nil)then a_a=__a[dd]:value()end end end;if(a_a==nil)then a_a=__a["@"..dd]end
if(a_a=="true")then a_a=true elseif
(a_a=="false")then a_a=false elseif(tonumber(a_a)~=nil)then a_a=tonumber(a_a)end;return a_a end,convertRichText=bd,writeRichText=function(dd,__a,a_a,b_a)
local c_a=bd(b_a)if(#c_a==0)then dd:addText(__a,a_a,b_a)return end
local d_a,_aa=dd:getForeground(),dd:getBackground()
for aaa,baa in pairs(c_a)do
dd:addText(__a+baa.position-1,a_a,baa.text)
if(baa.color~=nil)then
dd:addFG(__a+baa.position-1,a_a,bb[colors[baa.color]]:rep(
#baa.text))d_a=colors[baa.color]else dd:addFG(__a+baa.position-1,a_a,bb[d_a]:rep(#
baa.text))end
if(baa.bgColor~=nil)then
dd:addBG(__a+baa.position-1,a_a,bb[colors[baa.bgColor]]:rep(
#baa.text))_aa=colors[baa.bgColor]else if(_aa~=false)then
dd:addBG(__a+baa.position-1,a_a,bb[_aa]:rep(
#baa.text))end end end end,wrapRichText=cd,writeWrappedText=function(dd,__a,a_a,b_a,c_a,d_a)
local _aa=cd(b_a,c_a)
for aaa,baa in pairs(_aa)do if(baa.y>d_a)then break end
if(baa.text~=nil)then dd:addText(__a+baa.x-1,a_a+
baa.y-1,baa.text)end;if(baa.color~=nil)then
dd:addFG(__a+baa.x-1,a_a+baa.y-1,bb[colors[baa.color]]:rep(
#baa.text))end;if(baa.bgColor~=nil)then
dd:addBG(__a+
baa.x-1,a_a+baa.y-1,bb[colors[baa.bgColor]]:rep(#
baa.text))end end end,uuid=function()
return
string.gsub(string.format('%x-%x-%x-%x-%x',math.random(0,0xffff),math.random(0,0xffff),math.random(0,0xffff),
math.random(0,0x0fff)+0x4000,math.random(0,0x3fff)+0x8000),' ','0')end}end
ba["libraries"]["basaltDraw"]=function(...)local bb=_b("tHex")local cb=_b("utils")
local db=cb.splitString;local _c,ac=string.sub,string.rep
return
function(bc)local cc=bc or term.current()
local dc;local _d,ad=cc.getSize()local bd={}local cd={}local dd={}local __a;local a_a={}
local function b_a()__a=ac(" ",_d)for n=0,15 do
local daa=2 ^n;local _ba=bb[daa]a_a[daa]=ac(_ba,_d)end end;b_a()
local function c_a()b_a()local daa=__a;local _ba=a_a[colors.white]
local aba=a_a[colors.black]
for currentY=1,ad do
bd[currentY]=_c(bd[currentY]==nil and daa or bd[currentY]..daa:sub(1,_d-
bd[currentY]:len()),1,_d)
dd[currentY]=_c(dd[currentY]==nil and _ba or dd[currentY].._ba:sub(1,_d-
dd[currentY]:len()),1,_d)
cd[currentY]=_c(cd[currentY]==nil and aba or cd[currentY]..aba:sub(1,_d-
cd[currentY]:len()),1,_d)end end;c_a()
local function d_a(daa,_ba,aba,bba,cba)
if#aba==#bba and#aba==#cba then
if _ba>=1 and _ba<=ad then
if
daa+#aba>0 and daa<=_d then local dba,_ca,aca;local bca,cca,dca=bd[_ba],dd[_ba],cd[_ba]
local _da,ada=1,#aba
if daa<1 then _da=1 -daa+1;ada=_d-daa+1 elseif daa+#aba>_d then ada=_d-daa+1 end;dba=_c(bca,1,daa-1).._c(aba,_da,ada)_ca=
_c(cca,1,daa-1).._c(bba,_da,ada)aca=_c(dca,1,daa-1)..
_c(cba,_da,ada)
if daa+#aba<=_d then dba=dba..
_c(bca,daa+#aba,_d)
_ca=_ca.._c(cca,daa+#aba,_d)aca=aca.._c(dca,daa+#aba,_d)end;bd[_ba],dd[_ba],cd[_ba]=dba,_ca,aca end end end end
local function _aa(daa,_ba,aba)
if _ba>=1 and _ba<=ad then
if daa+#aba>0 and daa<=_d then local bba;local cba=bd[_ba]
local dba,_ca=1,#aba
if daa<1 then dba=1 -daa+1;_ca=_d-daa+1 elseif daa+#aba>_d then _ca=_d-daa+1 end;bba=_c(cba,1,daa-1).._c(aba,dba,_ca)
if
daa+#aba<=_d then bba=bba.._c(cba,daa+#aba,_d)end;bd[_ba]=bba end end end
local function aaa(daa,_ba,aba)
if _ba>=1 and _ba<=ad then
if daa+#aba>0 and daa<=_d then local bba;local cba=cd[_ba]
local dba,_ca=1,#aba
if daa<1 then dba=1 -daa+1;_ca=_d-daa+1 elseif daa+#aba>_d then _ca=_d-daa+1 end;bba=_c(cba,1,daa-1).._c(aba,dba,_ca)
if
daa+#aba<=_d then bba=bba.._c(cba,daa+#aba,_d)end;cd[_ba]=bba end end end
local function baa(daa,_ba,aba)
if _ba>=1 and _ba<=ad then
if daa+#aba>0 and daa<=_d then local bba;local cba=dd[_ba]
local dba,_ca=1,#aba
if daa<1 then dba=1 -daa+1;_ca=_d-daa+1 elseif daa+#aba>_d then _ca=_d-daa+1 end;bba=_c(cba,1,daa-1).._c(aba,dba,_ca)
if
daa+#aba<=_d then bba=bba.._c(cba,daa+#aba,_d)end;dd[_ba]=bba end end end
local caa={setSize=function(daa,_ba)_d,ad=daa,_ba;c_a()end,setMirror=function(daa)dc=daa end,setBG=function(daa,_ba,aba)
aaa(daa,_ba,aba)end,setText=function(daa,_ba,aba)_aa(daa,_ba,aba)end,setFG=function(daa,_ba,aba)
baa(daa,_ba,aba)end,blit=function(daa,_ba,aba,bba,cba)d_a(daa,_ba,aba,bba,cba)end,drawBackgroundBox=function(daa,_ba,aba,bba,cba)
local dba=ac(bb[cba],aba)for n=1,bba do aaa(daa,_ba+ (n-1),dba)end end,drawForegroundBox=function(daa,_ba,aba,bba,cba)
local dba=ac(bb[cba],aba)for n=1,bba do baa(daa,_ba+ (n-1),dba)end end,drawTextBox=function(daa,_ba,aba,bba,cba)
local dba=ac(cba,aba)for n=1,bba do _aa(daa,_ba+ (n-1),dba)end end,update=function()
local daa,_ba=cc.getCursorPos()local aba=false
if(cc.getCursorBlink~=nil)then aba=cc.getCursorBlink()end;cc.setCursorBlink(false)if(dc~=nil)then
dc.setCursorBlink(false)end
for n=1,ad do cc.setCursorPos(1,n)
cc.blit(bd[n],dd[n],cd[n])if(dc~=nil)then dc.setCursorPos(1,n)
dc.blit(bd[n],dd[n],cd[n])end end;cc.setBackgroundColor(colors.black)
cc.setCursorBlink(aba)cc.setCursorPos(daa,_ba)
if(dc~=nil)then
dc.setBackgroundColor(colors.black)dc.setCursorBlink(aba)dc.setCursorPos(daa,_ba)end end,setTerm=function(daa)
cc=daa end}return caa end end
ba["libraries"]["bimg"]=function(...)local bb,cb=string.sub,string.rep
local function db(_c,ac)local bc,cc=0,0
local dc,_d,ad={},{},{}local bd,cd=1,1;local dd={}
local function __a()
for y=1,cc do if(dc[y]==nil)then dc[y]=cb(" ",bc)else dc[y]=dc[y]..
cb(" ",bc-#dc[y])end;if
(_d[y]==nil)then _d[y]=cb("0",bc)else
_d[y]=_d[y]..cb("0",bc-#_d[y])end
if(ad[y]==nil)then ad[y]=cb("f",bc)else ad[y]=
ad[y]..cb("f",bc-#ad[y])end end end
local a_a=function(_aa,aaa,baa)bd=aaa or bd;cd=baa or cd
if(dc[cd]==nil)then dc[cd]=cb(" ",bd-1).._aa..
cb(" ",bc- (#_aa+bd))else dc[cd]=
bb(dc[cd],1,bd-1)..
cb(" ",bd-#dc[cd]).._aa..bb(dc[cd],bd+#_aa,bc)end;if(#dc[cd]>bc)then bc=#dc[cd]end;if(cd>cc)then cc=cd end
ac.updateSize(bc,cc)end
local b_a=function(_aa,aaa,baa)bd=aaa or bd;cd=baa or cd
if(ad[cd]==nil)then ad[cd]=cb("f",bd-1).._aa..
cb("f",bc- (#_aa+bd))else ad[cd]=
bb(ad[cd],1,bd-1)..
cb("f",bd-#ad[cd]).._aa..bb(ad[cd],bd+#_aa,bc)end;if(#ad[cd]>bc)then bc=#ad[cd]end;if(cd>cc)then cc=cd end
ac.updateSize(bc,cc)end
local c_a=function(_aa,aaa,baa)bd=aaa or bd;cd=baa or cd
if(_d[cd]==nil)then _d[cd]=cb("0",bd-1).._aa..
cb("0",bc- (#_aa+bd))else _d[cd]=
bb(_d[cd],1,bd-1)..
cb("0",bd-#_d[cd]).._aa..bb(_d[cd],bd+#_aa,bc)end;if(#_d[cd]>bc)then bc=#_d[cd]end;if(cd>cc)then cc=cd end
ac.updateSize(bc,cc)end
local function d_a(_aa)dd={}dc,_d,ad={},{},{}
for aaa,baa in pairs(_c)do if(type(aaa)=="string")then dd[aaa]=baa else
dc[aaa],_d[aaa],ad[aaa]=baa[1],baa[2],baa[3]end end;ac.updateSize(bc,cc)end
if(_c~=nil)then if(#_c>0)then bc=#_c[1][1]cc=#_c;d_a(_c)end end
return
{recalculateSize=__a,setFrame=d_a,getFrame=function()local _aa={}for aaa,baa in pairs(dc)do
table.insert(_aa,{baa,_d[aaa],ad[aaa]})end
for aaa,baa in pairs(dd)do _aa[aaa]=baa end;return _aa,bc,cc end,getImage=function()
local _aa={}for aaa,baa in pairs(dc)do
table.insert(_aa,{baa,_d[aaa],ad[aaa]})end;return _aa end,setFrameData=function(_aa,aaa)
if(
aaa~=nil)then dd[_aa]=aaa else if(type(_aa)=="table")then dd=_aa end end end,setFrameImage=function(_aa)
for aaa,baa in pairs(_aa.t)do
dc[aaa]=_aa.t[aaa]_d[aaa]=_aa.fg[aaa]ad[aaa]=_aa.bg[aaa]end end,getFrameImage=function()
return{t=dc,fg=_d,bg=ad}end,getFrameData=function(_aa)if(_aa~=nil)then return dd[_aa]else return dd end end,blit=function(_aa,aaa,baa,caa,daa)
a_a(_aa,caa,daa)c_a(aaa,caa,daa)b_a(baa,caa,daa)end,text=a_a,fg=c_a,bg=b_a,getSize=function()return
bc,cc end,setSize=function(_aa,aaa)local baa,caa,daa={},{},{}
for _y=1,aaa do
if(dc[_y]~=nil)then baa[_y]=bb(dc[_y],1,_aa)..cb(" ",
_aa-bc)else baa[_y]=cb(" ",_aa)end;if(_d[_y]~=nil)then
caa[_y]=bb(_d[_y],1,_aa)..cb("0",_aa-bc)else caa[_y]=cb("0",_aa)end;if
(ad[_y]~=nil)then daa[_y]=bb(ad[_y],1,_aa)..cb("f",_aa-bc)else
daa[_y]=cb("f",_aa)end end;dc,_d,ad=baa,caa,daa;bc,cc=_aa,aaa end}end
return
function(_c)local ac={}
local bc={creator="Bimg Library by NyoriE",date=os.date("!%Y-%m-%dT%TZ")}local cc,dc=0,0;if(_c~=nil)then
if(_c[1][1][1]~=nil)then cc,dc=bc.width or#_c[1][1][1],
bc.height or#_c[1]end end;local _d={}
local function ad(dd,__a)dd=dd or#ac+1
local a_a=db(__a,_d)table.insert(ac,dd,a_a)if(__a==nil)then
ac[dd].setSize(cc,dc)end;return a_a end;local function bd(dd)table.remove(ac,dd or#ac)end
local function cd(dd,__a)
local a_a=ac[dd]
if(a_a~=nil)then local b_a=dd+__a;if(b_a>=1)and(b_a<=#ac)then
table.remove(ac,dd)table.insert(ac,b_a,a_a)end end end
_d={updateSize=function(dd,__a,a_a)local b_a=a_a==true and true or false
if(dd>cc)then b_a=true;cc=dd end;if(__a>dc)then b_a=true;dc=__a end
if(b_a)then for c_a,d_a in pairs(ac)do d_a.setSize(cc,dc)
d_a.recalculateSize()end end end,text=function(dd,__a,a_a,b_a)
local c_a=ac[dd]if(c_a==nil)then c_a=ad(dd)end;c_a.text(__a,a_a,b_a)end,fg=function(dd,__a,a_a,b_a)
local c_a=ac[dd]if(c_a==nil)then c_a=ad(dd)end;c_a.fg(__a,a_a,b_a)end,bg=function(dd,__a,a_a,b_a)
local c_a=ac[dd]if(c_a==nil)then c_a=ad(dd)end;c_a.bg(__a,a_a,b_a)end,blit=function(dd,__a,a_a,b_a,c_a,d_a)
local _aa=ac[dd]if(_aa==nil)then _aa=ad(dd)end
_aa.blit(__a,a_a,b_a,c_a,d_a)end,setSize=function(dd,__a)cc=dd;dc=__a;for a_a,b_a in pairs(ac)do
b_a.setSize(dd,__a)end end,getFrame=function(dd)if
(ac[dd]~=nil)then return ac[dd].getFrame()end end,getFrameObjects=function()return
ac end,getFrames=function()local dd={}for __a,a_a in pairs(ac)do local b_a=a_a.getFrame()
table.insert(dd,b_a)end;return dd end,getFrameObject=function(dd)return
ac[dd]end,addFrame=function(dd)if(#ac<=1)then
if(bc.animated==nil)then bc.animated=true end
if(bc.secondsPerFrame==nil)then bc.secondsPerFrame=0.2 end end;return ad(dd)end,removeFrame=bd,moveFrame=cd,setFrameData=function(dd,__a,a_a)
if(
ac[dd]~=nil)then ac[dd].setFrameData(__a,a_a)end end,getFrameData=function(dd,__a)if(ac[dd]~=nil)then return
ac[dd].getFrameData(__a)end end,getSize=function()return
cc,dc end,setAnimation=function(dd)bc.animation=dd end,setMetadata=function(dd,__a)if(__a~=nil)then bc[dd]=__a else if(
type(dd)=="table")then bc=dd end end end,getMetadata=function(dd)if(
dd~=nil)then return bc[dd]else return bc end end,createBimg=function()
local dd={}
for __a,a_a in pairs(ac)do local b_a=a_a.getFrame()table.insert(dd,b_a)end;for __a,a_a in pairs(bc)do dd[__a]=a_a end;dd.width=cc;dd.height=dc;return dd end}
if(_c~=nil)then
for dd,__a in pairs(_c)do if(type(dd)=="string")then bc[dd]=__a end end
if(bc.width==nil)or(bc.height==nil)then
cc=bc.width or#_c[1][1][1]dc=bc.height or#_c[1]_d.updateSize(cc,dc,true)end
for dd,__a in pairs(_c)do if(type(dd)=="number")then ad(dd,__a)end end else ad(1)end;return _d end end
ba["libraries"]["basaltMon"]=function(...)
local bb={[colors.white]="0",[colors.orange]="1",[colors.magenta]="2",[colors.lightBlue]="3",[colors.yellow]="4",[colors.lime]="5",[colors.pink]="6",[colors.gray]="7",[colors.lightGray]="8",[colors.cyan]="9",[colors.purple]="a",[colors.blue]="b",[colors.brown]="c",[colors.green]="d",[colors.red]="e",[colors.black]="f"}local cb,db,_c,ac=type,string.len,string.rep,string.sub
return
function(bc)local cc={}
for aba,bba in pairs(bc)do
cc[aba]={}
for cba,dba in pairs(bba)do local _ca=peripheral.wrap(dba)if(_ca==nil)then
error("Unable to find monitor "..dba)end;cc[aba][cba]=_ca
cc[aba][cba].name=dba end end;local dc,_d,ad,bd,cd,dd,__a,a_a=1,1,1,1,0,0,0,0;local b_a,c_a=false,1
local d_a,_aa=colors.white,colors.black
local function aaa()local aba,bba=0,0
for cba,dba in pairs(cc)do local _ca,aca=0,0
for bca,cca in pairs(dba)do local dca,_da=cca.getSize()
_ca=_ca+dca;aca=_da>aca and _da or aca end;aba=aba>_ca and aba or _ca;bba=bba+aca end;__a,a_a=aba,bba end;aaa()
local function baa()local aba=0;local bba,cba=0,0
for dba,_ca in pairs(cc)do local aca=0;local bca=0
for cca,dca in pairs(_ca)do
local _da,ada=dca.getSize()if(dc-aca>=1)and(dc-aca<=_da)then bba=cca end;dca.setCursorPos(
dc-aca,_d-aba)aca=aca+_da
if(bca<ada)then bca=ada end end;if(_d-aba>=1)and(_d-aba<=bca)then cba=dba end
aba=aba+bca end;ad,bd=bba,cba end;baa()
local function caa(aba,...)local bba={...}return
function()for cba,dba in pairs(cc)do for _ca,aca in pairs(dba)do
aca[aba](table.unpack(bba))end end end end
local function daa()caa("setCursorBlink",false)()
if not(b_a)then return end;if(cc[bd]==nil)then return end;local aba=cc[bd][ad]
if(aba==nil)then return end;aba.setCursorBlink(b_a)end
local function _ba(aba,bba,cba)if(cc[bd]==nil)then return end;local dba=cc[bd][ad]
if(dba==nil)then return end;dba.blit(aba,bba,cba)local _ca,aca=dba.getSize()
if
(db(aba)+dc>_ca)then local bca=cc[bd][ad+1]if(bca~=nil)then bca.blit(aba,bba,cba)ad=ad+1;dc=dc+
db(aba)end end;baa()end
return
{clear=caa("clear"),setCursorBlink=function(aba)b_a=aba;daa()end,getCursorBlink=function()return b_a end,getCursorPos=function()return dc,_d end,setCursorPos=function(aba,bba)
dc,_d=aba,bba;baa()daa()end,setTextScale=function(aba)
caa("setTextScale",aba)()aaa()baa()c_a=aba end,getTextScale=function()return c_a end,blit=function(aba,bba,cba)
_ba(aba,bba,cba)end,write=function(aba)aba=tostring(aba)local bba=db(aba)
_ba(aba,_c(bb[d_a],bba),_c(bb[_aa],bba))end,getSize=function()return __a,a_a end,setBackgroundColor=function(aba)
caa("setBackgroundColor",aba)()_aa=aba end,setTextColor=function(aba)
caa("setTextColor",aba)()d_a=aba end,calculateClick=function(aba,bba,cba)local dba=0
for _ca,aca in pairs(cc)do local bca=0;local cca=0
for dca,_da in pairs(aca)do
local ada,bda=_da.getSize()if(_da.name==aba)then return bba+bca,cba+dba end
bca=bca+ada;if(bda>cca)then cca=bda end end;dba=dba+cca end;return bba,cba end}end end
ba["libraries"]["basaltEvent"]=function(...)
return
function()local bb={}
local cb={registerEvent=function(db,_c,ac)
if(bb[_c]==nil)then bb[_c]={}end;table.insert(bb[_c],ac)end,removeEvent=function(db,_c,ac)bb[_c][ac[_c]]=
nil end,hasEvent=function(db,_c)return bb[_c]~=nil end,getEventCount=function(db,_c)return
bb[_c]~=nil and#bb[_c]or 0 end,getEvents=function(db)
local _c={}for ac,bc in pairs(bb)do table.insert(_c,ac)end;return _c end,clearEvent=function(db,_c)bb[_c]=
nil end,clear=function(db,_c)bb={}end,sendEvent=function(db,_c,...)local ac
if(bb[_c]~=nil)then for bc,cc in pairs(bb[_c])do
local dc=cc(...)if(dc==false)then ac=dc end end end;return ac end}cb.__index=cb;return cb end end
ba["loadObjects"]=function(...)local bb={}if(ca)then
for _c,ac in pairs(ab("objects"))do bb[_c]=ac()end;return bb end;local cb=table.pack(...)local db=fs.getDir(
cb[2]or"Basalt")if(db==nil)then
error("Unable to find directory "..cb[2]..
" please report this bug to our discord.")end
for _c,ac in
pairs(fs.list(fs.combine(db,"objects")))do if(ac~="example.lua")and not(ac:find(".disabled"))then
local bc=ac:gsub(".lua","")bb[bc]=_b(bc)end end;return bb end;ba["plugins"]={}
ba["plugins"]["basaltAdditions"]=function(...)return
{basalt=function()return{cool=function()
print("ello")sleep(2)end}end}end
ba["plugins"]["shadow"]=function(...)local bb=_b("utils")local cb=bb.xmlValue
return
{VisualObject=function(db)local _c=false
local ac={setShadow=function(bc,cc)
_c=cc;bc:updateDraw()return bc end,getShadow=function(bc)return _c end,draw=function(bc)
db.draw(bc)
bc:addDraw("shadow",function()
if(_c~=false)then local cc,dc=bc:getSize()
if(_c)then
bc:addBackgroundBox(cc+1,2,1,dc,_c)bc:addBackgroundBox(2,dc+1,cc,1,_c)
bc:addForegroundBox(cc+1,2,1,dc,_c)bc:addForegroundBox(2,dc+1,cc,1,_c)end end end)end,setValuesByXMLData=function(bc,cc,dc)
db.setValuesByXMLData(bc,cc,dc)if(cb("shadow",cc)~=nil)then
bc:setShadow(cb("shadow",cc))end;return bc end}return ac end}end
ba["plugins"]["advancedBackground"]=function(...)local bb=_b("utils")
local cb=bb.xmlValue
return
{VisualObject=function(db)local _c=false;local ac=colors.black
local bc={setBackground=function(cc,dc,_d,ad)db.setBackground(cc,dc)
_c=_d or _c;ac=ad or ac;return cc end,setBackgroundSymbol=function(cc,dc,_d)_c=dc
ac=_d or ac;cc:updateDraw()return cc end,getBackgroundSymbol=function(cc)return _c end,getBackgroundSymbolColor=function(cc)return
ac end,setValuesByXMLData=function(cc,dc,_d)db.setValuesByXMLData(cc,dc,_d)if(
cb("background-symbol",dc)~=nil)then
cc:setBackgroundSymbol(cb("background-symbol",dc),cb("background-symbol-color",dc))end;return cc end,draw=function(cc)
db.draw(cc)
cc:addDraw("advanced-bg",function()local dc,_d=cc:getSize()if(_c~=false)then
cc:addTextBox(1,1,dc,_d,_c:sub(1,1))
if(_c~=" ")then cc:addForegroundBox(1,1,dc,_d,ac)end end end,2)end}return bc end}end
ba["plugins"]["themes"]=function(...)
local bb={BaseFrameBG=colors.lightGray,BaseFrameText=colors.black,FrameBG=colors.gray,FrameText=colors.black,ButtonBG=colors.gray,ButtonText=colors.black,CheckboxBG=colors.lightGray,CheckboxText=colors.black,InputBG=colors.black,InputText=colors.lightGray,TextfieldBG=colors.black,TextfieldText=colors.white,ListBG=colors.gray,ListText=colors.black,MenubarBG=colors.gray,MenubarText=colors.black,DropdownBG=colors.gray,DropdownText=colors.black,RadioBG=colors.gray,RadioText=colors.black,SelectionBG=colors.black,SelectionText=colors.lightGray,GraphicBG=colors.black,ImageBG=colors.black,PaneBG=colors.black,ProgramBG=colors.black,ProgressbarBG=colors.gray,ProgressbarText=colors.black,ProgressbarActiveBG=colors.black,ScrollbarBG=colors.lightGray,ScrollbarText=colors.gray,ScrollbarSymbolColor=colors.black,SliderBG=false,SliderText=colors.gray,SliderSymbolColor=colors.black,SwitchBG=colors.lightGray,SwitchText=colors.gray,LabelBG=false,LabelText=colors.black,GraphBG=colors.gray,GraphText=colors.black}
local cb={Container=function(db,_c,ac)local bc={}
local cc={getTheme=function(dc,_d)local ad=dc:getParent()return bc[_d]or(ad~=nil and ad:getTheme(_d)or
bb[_d])end,setTheme=function(dc,_d,ad)
if(
type(_d)=="table")then bc=_d elseif(type(_d)=="string")then bc[_d]=ad end;dc:updateDraw()return dc end}return cc end,basalt=function()
return
{getTheme=function(db)return
bb[db]end,setTheme=function(db,_c)if(type(db)=="table")then bb=db elseif(type(db)=="string")then
bb[db]=_c end end}end}
for db,_c in
pairs({"BaseFrame","Frame","ScrollableFrame","MovableFrame","Button","Checkbox","Dropdown","Graph","Graphic","Input","Label","List","Menubar","Pane","Program","Progressbar","Radio","Scrollbar","Slider","Switch","Textfield"})do
cb[_c]=function(ac,bc,cc)
local dc={init=function(_d)if(ac.init(_d))then local ad=_d:getParent()or _d
_d:setBackground(ad:getTheme(_c.."BG"))
_d:setForeground(ad:getTheme(_c.."Text"))end end}return dc end end;return cb end
ba["plugins"]["pixelbox"]=function(...)
local bb,cb,db=table.sort,table.concat,string.char;local function _c(_d,ad)return _d[2]>ad[2]end
local ac={{5,256,16,8,64,32},{4,16,16384,256,128},[4]={4,64,1024,256,128},[8]={4,512,2048,256,1},[16]={4,2,16384,256,1},[32]={4,8192,4096,256,1},[64]={4,4,1024,256,1},[128]={6,32768,256,1024,2048,4096,16384},[256]={6,1,128,2,512,4,8192},[512]={4,8,2048,256,128},[1024]={4,4,64,128,32768},[2048]={4,512,8,128,32768},[4096]={4,8192,32,128,32768},[8192]={3,32,4096,256128},[16384]={4,2,16,128,32768},[32768]={5,128,1024,2048,4096,16384}}local bc={}for i=0,15 do bc[("%x"):format(i)]=2 ^i end
local cc={}for i=0,15 do cc[2 ^i]=("%x"):format(i)end
local function dc(_d,ad)ad=ad or"f"local bd,cd=#
_d[1],#_d;local dd={}local __a={}local a_a=false
local function b_a()
for y=1,cd*3 do for x=1,bd*2 do
if not __a[y]then __a[y]={}end;__a[y][x]=ad end end;for aaa,baa in ipairs(_d)do
for x=1,#baa do local caa=baa:sub(x,x)__a[aaa][x]=bc[caa]end end end;b_a()local function c_a(aaa,baa)bd,cd=aaa,baa;__a={}a_a=false;b_a()end
local function d_a(aaa,baa,caa,daa,_ba,aba)
local bba={aaa,baa,caa,daa,_ba,aba}local cba={}local dba={}local _ca=0
for i=1,6 do local dca=bba[i]if not cba[dca]then _ca=_ca+1
cba[dca]={0,_ca}end;local _da=cba[dca]local ada=_da[1]+1;_da[1]=ada
dba[_da[2]]={dca,ada}end;local aca=#dba
while aca>2 do bb(dba,_c)local dca=ac[dba[aca][1]]
local _da,ada=1,false;local bda=aca-1
for i=2,dca[1]do if ada then break end;local __b=dca[i]for j=1,bda do if dba[j][1]==__b then _da=j
ada=true;break end end end;local cda,dda=dba[aca][1],dba[_da][1]
for i=1,6 do if bba[i]==cda then bba[i]=dda
local __b=dba[_da]__b[2]=__b[2]+1 end end;dba[aca]=nil;aca=aca-1 end;local bca=128;local cca=bba[6]if bba[1]~=cca then bca=bca+1 end;if bba[2]~=cca then bca=bca+
2 end;if bba[3]~=cca then bca=bca+4 end;if
bba[4]~=cca then bca=bca+8 end;if bba[5]~=cca then bca=bca+16 end;if
dba[1][1]==bba[6]then return db(bca),dba[2][1],bba[6]else
return db(bca),dba[1][1],bba[6]end end
local function _aa()local aaa=bd*2;local baa=0
for y=1,cd*3,3 do baa=baa+1;local caa=__a[y]local daa=__a[y+1]
local _ba=__a[y+2]local aba,bba,cba={},{},{}local dba=0
for x=1,aaa,2 do local _ca=x+1
local aca,bca,cca,dca,_da,ada=caa[x],caa[_ca],daa[x],daa[_ca],_ba[x],_ba[_ca]local bda,cda,dda=" ",1,aca;if not(
bca==aca and cca==aca and dca==aca and _da==aca and ada==aca)then
bda,cda,dda=d_a(aca,bca,cca,dca,_da,ada)end;dba=dba+1
aba[dba]=bda;bba[dba]=cc[cda]cba[dba]=cc[dda]end;dd[baa]={cb(aba),cb(bba),cb(cba)}end;a_a=true end
return
{convert=_aa,generateCanvas=b_a,setSize=c_a,getSize=function()return bd,cd end,set=function(aaa,baa)_d=aaa;ad=baa or ad;__a={}a_a=false;b_a()end,get=function(aaa)if
not a_a then _aa()end
return aaa~=nil and dd[aaa]or dd end}end
return
{Image=function(_d,ad)
return
{shrink=function(bd)local cd=bd:getImageFrame(1)local dd={}for a_a,b_a in pairs(cd)do if(type(a_a)=="number")then
table.insert(dd,b_a[3])end end
local __a=dc(dd,bd:getBackground()).get()bd:setImage(__a)return bd end,getShrinkedImage=function(bd)
local cd=bd:getImageFrame(1)local dd={}for __a,a_a in pairs(cd)do
if(type(__a)=="number")then table.insert(dd,a_a[3])end end;return
dc(dd,bd:getBackground()).get()end}end}end
ba["plugins"]["textures"]=function(...)local bb=_b("images")local cb=_b("utils")
local db=cb.xmlValue
return
{VisualObject=function(_c)local ac,bc=1,true;local cc,dc,_d;local ad="default"
local bd={addTexture=function(cd,dd,__a)cc=bb.loadImageAsBimg(dd)
dc=cc[1]
if(__a)then if(cc.animated)then cd:listenEvent("other_event")local a_a=cc[ac].duration or
cc.secondsPerFrame or 0.2
_d=os.startTimer(a_a)end end;cd:setBackground(false)cd:setForeground(false)
cd:setDrawState("texture-base",true)cd:updateDraw()return cd end,setTextureMode=function(cd,dd)ad=
dd or ad;cd:updateDraw()return cd end,setInfinitePlay=function(cd,dd)bc=dd
return cd end,eventHandler=function(cd,dd,__a,...)_c.eventHandler(cd,dd,__a,...)
if(dd=="timer")then
if
(__a==_d)then
if(cc[ac+1]~=nil)then ac=ac+1;dc=cc[ac]local a_a=
cc[ac].duration or cc.secondsPerFrame or 0.2
_d=os.startTimer(a_a)cd:updateDraw()else
if(bc)then ac=1;dc=cc[1]local a_a=
cc[ac].duration or cc.secondsPerFrame or 0.2
_d=os.startTimer(a_a)cd:updateDraw()end end end end end,draw=function(cd)
_c.draw(cd)
cd:addDraw("texture-base",function()local dd=cd:getParent()or cd
local __a,a_a=cd:getPosition()local b_a,c_a=cd:getSize()local d_a,_aa=dd:getSize()local aaa=cc.width or
#cc[ac][1][1]local baa=cc.height or#cc[ac]
local caa,daa=0,0
if(ad=="center")then caa=__a+math.floor((b_a-aaa)/2 +0.5)-
1;daa=a_a+
math.floor((c_a-baa)/2 +0.5)-1 elseif(ad=="default")then
caa,daa=__a,a_a elseif(ad=="right")then caa,daa=__a+b_a-aaa,a_a+c_a-baa end;local _ba=__a-caa;local aba=a_a-daa
if caa<__a then caa=__a;aaa=aaa-_ba end;if daa<a_a then daa=a_a;baa=baa-aba end;if caa+aaa>__a+b_a then aaa=
(__a+b_a)-caa end;if daa+baa>a_a+c_a then
baa=(a_a+c_a)-daa end
for k=1,baa do if(dc[k+aba]~=nil)then
local bba,cba,dba=table.unpack(dc[k+aba])
cd:addBlit(1,k,bba:sub(_ba,_ba+aaa),cba:sub(_ba,_ba+aaa),dba:sub(_ba,_ba+aaa))end end end,1)cd:setDrawState("texture-base",false)end,setValuesByXMLData=function(cd,dd,__a)
_c.setValuesByXMLData(cd,dd,__a)if(db("texture",dd)~=nil)then
cd:addTexture(db("texture",dd),db("animate",dd))end;if(db("textureMode",dd)~=nil)then
cd:setTextureMode(db("textureMode",dd))end;if(db("infinitePlay",dd)~=nil)then
cd:setInfinitePlay(db("infinitePlay",dd))end;return cd end}return bd end}end
ba["plugins"]["border"]=function(...)local bb=_b("utils")local cb=bb.xmlValue
return
{VisualObject=function(db)local _c=true
local ac={top=false,bottom=false,left=false,right=false}
local bc={setBorder=function(cc,...)local dc={...}
if(dc~=nil)then
for _d,ad in pairs(dc)do
if(ad=="left")or(#dc==1)then ac["left"]=dc[1]end;if(ad=="top")or(#dc==1)then ac["top"]=dc[1]end;if
(ad=="right")or(#dc==1)then ac["right"]=dc[1]end;if
(ad=="bottom")or(#dc==1)then ac["bottom"]=dc[1]end end end;cc:updateDraw()return cc end,draw=function(cc)
db.draw(cc)
cc:addDraw("border",function()local dc,_d=cc:getPosition()local ad,bd=cc:getSize()
local cd=cc:getBackground()
if(_c)then
if(ac["left"]~=false)then cc:addTextBox(1,1,1,bd,"\149")if(cd~=false)then
cc:addBackgroundBox(1,1,1,bd,cd)end
cc:addForegroundBox(1,1,1,bd,ac["left"])end
if(ac["top"]~=false)then cc:addTextBox(1,1,ad,1,"\131")if(cd~=false)then
cc:addBackgroundBox(1,1,ad,1,cd)end
cc:addForegroundBox(1,1,ad,1,ac["top"])end
if(ac["left"]~=false)and(ac["top"]~=false)then
cc:addTextBox(1,1,1,1,"\151")
if(cd~=false)then cc:addBackgroundBox(1,1,1,1,cd)end;cc:addForegroundBox(1,1,1,1,ac["left"])end
if(ac["right"]~=false)then cc:addTextBox(ad,1,1,bd,"\149")if
(cd~=false)then cc:addForegroundBox(ad,1,1,bd,cd)end
cc:addBackgroundBox(ad,1,1,bd,ac["right"])end
if(ac["bottom"]~=false)then cc:addTextBox(1,bd,ad,1,"\143")if
(cd~=false)then cc:addForegroundBox(1,bd,ad,1,cd)end
cc:addBackgroundBox(1,bd,ad,1,ac["bottom"])end
if(ac["top"]~=false)and(ac["right"]~=false)then
cc:addTextBox(ad,1,1,1,"\148")
if(cd~=false)then cc:addForegroundBox(ad,1,1,1,cd)end;cc:addBackgroundBox(ad,1,1,1,ac["right"])end
if(ac["right"]~=false)and(ac["bottom"]~=false)then
cc:addTextBox(ad,bd,1,1,"\133")
if(cd~=false)then cc:addForegroundBox(ad,bd,1,1,cd)end;cc:addBackgroundBox(ad,bd,1,1,ac["right"])end
if(ac["bottom"]~=false)and(ac["left"]~=false)then
cc:addTextBox(1,bd,1,1,"\138")
if(cd~=false)then cc:addForegroundBox(0,bd,1,1,cd)end;cc:addBackgroundBox(1,bd,1,1,ac["left"])end end end)end,setValuesByXMLData=function(cc,dc,_d)
db.setValuesByXMLData(cc,dc)local ad={}
if(cb("border",dc)~=nil)then
ad["top"]=colors[cb("border",dc)]ad["bottom"]=colors[cb("border",dc)]
ad["left"]=colors[cb("border",dc)]ad["right"]=colors[cb("border",dc)]end;if(cb("borderTop",dc)~=nil)then
ad["top"]=colors[cb("borderTop",dc)]end;if(cb("borderBottom",dc)~=nil)then
ad["bottom"]=colors[cb("borderBottom",dc)]end;if(cb("borderLeft",dc)~=nil)then
ad["left"]=colors[cb("borderLeft",dc)]end;if(cb("borderRight",dc)~=nil)then
ad["right"]=colors[cb("borderRight",dc)]end
cc:setBorder(ad["top"],ad["bottom"],ad["left"],ad["right"])return cc end}return bc end}end
ba["plugins"]["debug"]=function(...)local bb=_b("utils")local cb=bb.wrapText
return
{basalt=function(db)
local _c=db.getMainFrame()local ac;local bc;local cc;local dc
local function _d()local ad=16;local bd=6;local cd=99;local dd=99;local __a,a_a=_c:getSize()
ac=_c:addMovableFrame("basaltDebuggingFrame"):setSize(
__a-20,a_a-10):setBackground(colors.gray):setForeground(colors.white):setZIndex(100):hide()
ac:addPane():setSize("parent.w",1):setPosition(1,1):setBackground(colors.black):setForeground(colors.white)
ac:setPosition(-__a,a_a/2 -ac:getHeight()/2):setBorder(colors.black)
local b_a=ac:addButton():setPosition("parent.w","parent.h"):setSize(1,1):setText("\133"):setForeground(colors.gray):setBackground(colors.black):onClick(function()
end):onDrag(function(c_a,d_a,_aa,aaa,baa)
local caa,daa=ac:getSize()local _ba,aba=caa,daa;if(caa+aaa-1 >=ad)and(caa+aaa-1 <=cd)then _ba=caa+
aaa-1 end
if(daa+baa-1 >=bd)and(
daa+baa-1 <=dd)then aba=daa+baa-1 end;ac:setSize(_ba,aba)end)
dc=ac:addButton():setText("Close"):setPosition("parent.w - 6",1):setSize(7,1):setBackground(colors.red):setForeground(colors.white):onClick(function()
ac:animatePosition(
-__a,a_a/2 -ac:getHeight()/2,0.5)end)
bc=ac:addList():setSize("parent.w - 2","parent.h - 3"):setPosition(2,3):setBackground(colors.gray):setForeground(colors.white):setSelectionColor(colors.gray,colors.white)
if(cc==nil)then
cc=_c:addLabel():setPosition(1,"parent.h"):setBackground(colors.black):setForeground(colors.white):setZIndex(100):onClick(function()
ac:show()
ac:animatePosition(__a/2 -ac:getWidth()/2,a_a/2 -ac:getHeight()/2,0.5)end)end end
return
{debug=function(...)local ad={...}if(_c==nil)then _c=db.getMainFrame()
if(_c~=nil)then _d()else print(...)return end end
if
(_c:getName()~="basaltDebuggingFrame")then if(_c~=ac)then cc:setParent(_c)end end;local bd=""for cd,dd in pairs(ad)do
bd=bd..tostring(dd).. (#ad~=cd and", "or"")end
cc:setText("[Debug] "..bd)
for cd,dd in pairs(cb(bd,bc:getWidth()))do bc:addItem(dd)end
if(bc:getItemCount()>50)then bc:removeItem(1)end
bc:setValue(bc:getItem(bc:getItemCount()))
if(bc.getItemCount()>bc:getHeight())then bc:setOffset(bc:getItemCount()-
bc:getHeight())end;cc:show()end}end}end
ba["plugins"]["dynamicValues"]=function(...)local bb=_b("utils")local cb=bb.tableCount
local db=bb.xmlValue
return
{VisualObject=function(_c,ac)local bc={}local cc={}
local dc={x="getX",y="getY",w="getWidth",h="getHeight"}
local function _d(dd)
local __a,a_a=pcall(load("return "..dd,"",nil,{math=math}))if not(__a)then
error(dd.." - is not a valid dynamic value string")end;return a_a end
local function ad(dd,__a,a_a)local b_a={}local c_a=dc
for aaa,baa in pairs(c_a)do for caa in a_a:gmatch("%a+%."..aaa)do
local daa=caa:gsub("%."..aaa,"")
if(daa~="self")and(daa~="parent")then table.insert(b_a,daa)end end end;local d_a=dd:getParent()local _aa={}
for aaa,baa in pairs(b_a)do
_aa[baa]=d_a:getObject(baa)if(_aa[baa]==nil)then
error("Dynamic Values - unable to find object: "..baa)end end;_aa["self"]=dd;_aa["parent"]=d_a
bc[__a]=function()local aaa=a_a
for baa,caa in pairs(c_a)do
for daa in
a_a:gmatch("%w+%."..baa)do local _ba=_aa[daa:gsub("%."..baa,"")]if(_ba~=nil)then
aaa=aaa:gsub(daa,_ba[caa](_ba))else
error("Dynamic Values - unable to find object: "..daa)end end end;cc[__a]=math.floor(_d(aaa)+0.5)end;bc[__a]()end
local function bd(dd)
if(cb(bc)>0)then for a_a,b_a in pairs(bc)do b_a()end
local __a={x="getX",y="getY",w="getWidth",h="getHeight"}
for a_a,b_a in pairs(__a)do
if(bc[a_a]~=nil)then
if(cc[a_a]~=dd[b_a](dd))then if
(a_a=="x")or(a_a=="y")then
_c.setPosition(dd,cc["x"]or dd:getX(),cc["y"]or dd:getY())end;if(a_a=="w")or(a_a=="h")then
_c.setSize(dd,
cc["w"]or dd:getWidth(),cc["h"]or dd:getHeight())end end end end end end
local cd={updatePositions=bd,createDynamicValue=ad,setPosition=function(dd,__a,a_a,b_a)cc.x=__a;cc.y=a_a
if(type(__a)=="string")then ad(dd,"x",__a)else bc["x"]=nil end
if(type(a_a)=="string")then ad(dd,"y",a_a)else bc["y"]=nil end;_c.setPosition(dd,cc.x,cc.y,b_a)return dd end,setSize=function(dd,__a,a_a,b_a)
cc.w=__a;cc.h=a_a
if(type(__a)=="string")then ad(dd,"w",__a)else bc["w"]=nil end
if(type(a_a)=="string")then ad(dd,"h",a_a)else bc["h"]=nil end;_c.setSize(dd,cc.w,cc.h,b_a)return dd end,customEventHandler=function(dd,__a,...)
_c.customEventHandler(dd,__a,...)if
(__a=="basalt_FrameReposition")or(__a=="basalt_FrameResize")then bd(dd)end end}return cd end}end
ba["plugins"]["bigfonts"]=function(...)local bb=_b("tHex")
local cb={{"\32\32\32\137\156\148\158\159\148\135\135\144\159\139\32\136\157\32\159\139\32\32\143\32\32\143\32\32\32\32\32\32\32\32\147\148\150\131\148\32\32\32\151\140\148\151\140\147","\32\32\32\149\132\149\136\156\149\144\32\133\139\159\129\143\159\133\143\159\133\138\32\133\138\32\133\32\32\32\32\32\32\150\150\129\137\156\129\32\32\32\133\131\129\133\131\132","\32\32\32\130\131\32\130\131\32\32\129\32\32\32\32\130\131\32\130\131\32\32\32\32\143\143\143\32\32\32\32\32\32\130\129\32\130\135\32\32\32\32\131\32\32\131\32\131","\139\144\32\32\143\148\135\130\144\149\32\149\150\151\149\158\140\129\32\32\32\135\130\144\135\130\144\32\149\32\32\139\32\159\148\32\32\32\32\159\32\144\32\148\32\147\131\132","\159\135\129\131\143\149\143\138\144\138\32\133\130\149\149\137\155\149\159\143\144\147\130\132\32\149\32\147\130\132\131\159\129\139\151\129\148\32\32\139\131\135\133\32\144\130\151\32","\32\32\32\32\32\32\130\135\32\130\32\129\32\129\129\131\131\32\130\131\129\140\141\132\32\129\32\32\129\32\32\32\32\32\32\32\131\131\129\32\32\32\32\32\32\32\32\32","\32\32\32\32\149\32\159\154\133\133\133\144\152\141\132\133\151\129\136\153\32\32\154\32\159\134\129\130\137\144\159\32\144\32\148\32\32\32\32\32\32\32\32\32\32\32\151\129","\32\32\32\32\133\32\32\32\32\145\145\132\141\140\132\151\129\144\150\146\129\32\32\32\138\144\32\32\159\133\136\131\132\131\151\129\32\144\32\131\131\129\32\144\32\151\129\32","\32\32\32\32\129\32\32\32\32\130\130\32\32\129\32\129\32\129\130\129\129\32\32\32\32\130\129\130\129\32\32\32\32\32\32\32\32\133\32\32\32\32\32\129\32\129\32\32","\150\156\148\136\149\32\134\131\148\134\131\148\159\134\149\136\140\129\152\131\32\135\131\149\150\131\148\150\131\148\32\148\32\32\148\32\32\152\129\143\143\144\130\155\32\134\131\148","\157\129\149\32\149\32\152\131\144\144\131\148\141\140\149\144\32\149\151\131\148\32\150\32\150\131\148\130\156\133\32\144\32\32\144\32\130\155\32\143\143\144\32\152\129\32\134\32","\130\131\32\131\131\129\131\131\129\130\131\32\32\32\129\130\131\32\130\131\32\32\129\32\130\131\32\130\129\32\32\129\32\32\133\32\32\32\129\32\32\32\130\32\32\32\129\32","\150\140\150\137\140\148\136\140\132\150\131\132\151\131\148\136\147\129\136\147\129\150\156\145\138\143\149\130\151\32\32\32\149\138\152\129\149\32\32\157\152\149\157\144\149\150\131\148","\149\143\142\149\32\149\149\32\149\149\32\144\149\32\149\149\32\32\149\32\32\149\32\149\149\32\149\32\149\32\144\32\149\149\130\148\149\32\32\149\32\149\149\130\149\149\32\149","\130\131\129\129\32\129\131\131\32\130\131\32\131\131\32\131\131\129\129\32\32\130\131\32\129\32\129\130\131\32\130\131\32\129\32\129\131\131\129\129\32\129\129\32\129\130\131\32","\136\140\132\150\131\148\136\140\132\153\140\129\131\151\129\149\32\149\149\32\149\149\32\149\137\152\129\137\152\129\131\156\133\149\131\32\150\32\32\130\148\32\152\137\144\32\32\32","\149\32\32\149\159\133\149\32\149\144\32\149\32\149\32\149\32\149\150\151\129\138\155\149\150\130\148\32\149\32\152\129\32\149\32\32\32\150\32\32\149\32\32\32\32\32\32\32","\129\32\32\130\129\129\129\32\129\130\131\32\32\129\32\130\131\32\32\129\32\129\32\129\129\32\129\32\129\32\131\131\129\130\131\32\32\32\129\130\131\32\32\32\32\140\140\132","\32\154\32\159\143\32\149\143\32\159\143\32\159\144\149\159\143\32\159\137\145\159\143\144\149\143\32\32\145\32\32\32\145\149\32\144\32\149\32\143\159\32\143\143\32\159\143\32","\32\32\32\152\140\149\151\32\149\149\32\145\149\130\149\157\140\133\32\149\32\154\143\149\151\32\149\32\149\32\144\32\149\149\153\32\32\149\32\149\133\149\149\32\149\149\32\149","\32\32\32\130\131\129\131\131\32\130\131\32\130\131\129\130\131\129\32\129\32\140\140\129\129\32\129\32\129\32\137\140\129\130\32\129\32\130\32\129\32\129\129\32\129\130\131\32","\144\143\32\159\144\144\144\143\32\159\143\144\159\138\32\144\32\144\144\32\144\144\32\144\144\32\144\144\32\144\143\143\144\32\150\129\32\149\32\130\150\32\134\137\134\134\131\148","\136\143\133\154\141\149\151\32\129\137\140\144\32\149\32\149\32\149\154\159\133\149\148\149\157\153\32\154\143\149\159\134\32\130\148\32\32\149\32\32\151\129\32\32\32\32\134\32","\133\32\32\32\32\133\129\32\32\131\131\32\32\130\32\130\131\129\32\129\32\130\131\129\129\32\129\140\140\129\131\131\129\32\130\129\32\129\32\130\129\32\32\32\32\32\129\32","\32\32\32\32\149\32\32\149\32\32\32\32\32\32\32\32\149\32\32\149\32\32\32\32\32\32\32\32\149\32\32\149\32\32\32\32\32\32\32\32\149\32\32\149\32\32\32\32","\32\32\32\32\32\32\32\32\32\32\32\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\32\32\32\32\32\32\32\32\32\32\32","\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32","\32\32\32\32\149\32\32\149\32\32\32\32\32\32\32\32\149\32\32\149\32\32\32\32\32\32\32\32\149\32\32\149\32\32\32\32\32\32\32\32\149\32\32\149\32\32\32\32","\32\32\32\32\32\32\32\32\32\32\32\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\32\32\32\32\32\32\32\32\32\32\32","\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32","\32\32\32\32\145\32\159\139\32\151\131\132\155\143\132\134\135\145\32\149\32\158\140\129\130\130\32\152\147\155\157\134\32\32\144\144\32\32\32\32\32\32\152\131\155\131\131\129","\32\32\32\32\149\32\149\32\145\148\131\32\149\32\149\140\157\132\32\148\32\137\155\149\32\32\32\149\154\149\137\142\32\153\153\32\131\131\149\131\131\129\149\135\145\32\32\32","\32\32\32\32\129\32\130\135\32\131\131\129\134\131\132\32\129\32\32\129\32\131\131\32\32\32\32\130\131\129\32\32\32\32\129\129\32\32\32\32\32\32\130\131\129\32\32\32","\150\150\32\32\148\32\134\32\32\132\32\32\134\32\32\144\32\144\150\151\149\32\32\32\32\32\32\145\32\32\152\140\144\144\144\32\133\151\129\133\151\129\132\151\129\32\145\32","\130\129\32\131\151\129\141\32\32\142\32\32\32\32\32\149\32\149\130\149\149\32\143\32\32\32\32\142\132\32\154\143\133\157\153\132\151\150\148\151\158\132\151\150\148\144\130\148","\32\32\32\140\140\132\32\32\32\32\32\32\32\32\32\151\131\32\32\129\129\32\32\32\32\134\32\32\32\32\32\32\32\129\129\32\129\32\129\129\130\129\129\32\129\130\131\32","\156\143\32\159\141\129\153\140\132\153\137\32\157\141\32\159\142\32\150\151\129\150\131\132\140\143\144\143\141\145\137\140\148\141\141\144\157\142\32\159\140\32\151\134\32\157\141\32","\157\140\149\157\140\149\157\140\149\157\140\149\157\140\149\157\140\149\151\151\32\154\143\132\157\140\32\157\140\32\157\140\32\157\140\32\32\149\32\32\149\32\32\149\32\32\149\32","\129\32\129\129\32\129\129\32\129\129\32\129\129\32\129\129\32\129\129\131\129\32\134\32\131\131\129\131\131\129\131\131\129\131\131\129\130\131\32\130\131\32\130\131\32\130\131\32","\151\131\148\152\137\145\155\140\144\152\142\145\153\140\132\153\137\32\154\142\144\155\159\132\150\156\148\147\32\144\144\130\145\136\137\32\146\130\144\144\130\145\130\136\32\151\140\132","\151\32\149\151\155\149\149\32\149\149\32\149\149\32\149\149\32\149\149\32\149\152\137\144\157\129\149\149\32\149\149\32\149\149\32\149\149\32\149\130\150\32\32\157\129\149\32\149","\131\131\32\129\32\129\130\131\32\130\131\32\130\131\32\130\131\32\130\131\32\32\32\32\130\131\32\130\131\32\130\131\32\130\131\32\130\131\32\32\129\32\130\131\32\133\131\32","\156\143\32\159\141\129\153\140\132\153\137\32\157\141\32\159\142\32\159\159\144\152\140\144\156\143\32\159\141\129\153\140\132\157\141\32\130\145\32\32\147\32\136\153\32\130\146\32","\152\140\149\152\140\149\152\140\149\152\140\149\152\140\149\152\140\149\149\157\134\154\143\132\157\140\133\157\140\133\157\140\133\157\140\133\32\149\32\32\149\32\32\149\32\32\149\32","\130\131\129\130\131\129\130\131\129\130\131\129\130\131\129\130\131\129\130\130\131\32\134\32\130\131\129\130\131\129\130\131\129\130\131\129\32\129\32\32\129\32\32\129\32\32\129\32","\159\134\144\137\137\32\156\143\32\159\141\129\153\140\132\153\137\32\157\141\32\32\132\32\159\143\32\147\32\144\144\130\145\136\137\32\146\130\144\144\130\145\130\138\32\146\130\144","\149\32\149\149\32\149\149\32\149\149\32\149\149\32\149\149\32\149\149\32\149\131\147\129\138\134\149\149\32\149\149\32\149\149\32\149\149\32\149\154\143\149\32\157\129\154\143\149","\130\131\32\129\32\129\130\131\32\130\131\32\130\131\32\130\131\32\130\131\32\32\32\32\130\131\32\130\131\129\130\131\129\130\131\129\130\131\129\140\140\129\130\131\32\140\140\129"},{"000110000110110000110010101000000010000000100101","000000110110000000000010101000000010000000100101","000000000000000000000000000000000000000000000000","100010110100000010000110110000010100000100000110","000000110000000010110110000110000000000000110000","000000000000000000000000000000000000000000000000","000000110110000010000000100000100000000000000010","000000000110110100010000000010000000000000000100","000000000000000000000000000000000000000000000000","010000000000100110000000000000000000000110010000","000000000000000000000000000010000000010110000000","000000000000000000000000000000000000000000000000","011110110000000100100010110000000100000000000000","000000000000000000000000000000000000000000000000","000000000000000000000000000000000000000000000000","110000110110000000000000000000010100100010000000","000010000000000000110110000000000100010010000000","000000000000000000000000000000000000000000000000","010110010110100110110110010000000100000110110110","000000000000000000000110000000000110000000000000","000000000000000000000000000000000000000000000000","010100010110110000000000000000110000000010000000","110110000000000000110000110110100000000010000000","000000000000000000000000000000000000000000000000","000100011111000100011111000100011111000100011111","000000000000100100100100011011011011111111111111","000000000000000000000000000000000000000000000000","000100011111000100011111000100011111000100011111","000000000000100100100100011011011011111111111111","100100100100100100100100100100100100100100100100","000000110100110110000010000011110000000000011000","000000000100000000000010000011000110000000001000","000000000000000000000000000000000000000000000000","010000100100000000000000000100000000010010110000","000000000000000000000000000000110110110110110000","000000000000000000000000000000000000000000000000","110110110110110110000000110110110110110110110110","000000000000000000000110000000000000000000000000","000000000000000000000000000000000000000000000000","000000000000110110000110010000000000000000010010","000010000000000000000000000000000000000000000000","000000000000000000000000000000000000000000000000","110110110110110110110000110110110110000000000000","000000000000000000000110000000000000000000000000","000000000000000000000000000000000000000000000000","110110110110110110110000110000000000000000010000","000000000000000000000000100000000000000110000110","000000000000000000000000000000000000000000000000"}}local db={}local _c={}
do local _d=0;local ad=#cb[1]local bd=#cb[1][1]
for i=1,ad,3 do
for j=1,bd,3 do
local cd=string.char(_d)local dd={}dd[1]=cb[1][i]:sub(j,j+2)
dd[2]=cb[1][i+1]:sub(j,j+2)dd[3]=cb[1][i+2]:sub(j,j+2)local __a={}__a[1]=cb[2][i]:sub(j,
j+2)
__a[2]=cb[2][i+1]:sub(j,j+2)__a[3]=cb[2][i+2]:sub(j,j+2)_c[cd]={dd,__a}
_d=_d+1 end end;db[1]=_c end
local function ac(_d,ad)local bd={["0"]="1",["1"]="0"}if _d<=#db then return true end
for f=#db+1,_d do local cd={}local dd=db[
f-1]
for char=0,255 do local __a=string.char(char)local a_a={}local b_a={}
local c_a=dd[__a][1]local d_a=dd[__a][2]
for i=1,#c_a do local _aa,aaa,baa,caa,daa,_ba={},{},{},{},{},{}
for j=1,#c_a[1]do
local aba=_c[c_a[i]:sub(j,j)][1]table.insert(_aa,aba[1])
table.insert(aaa,aba[2])table.insert(baa,aba[3])
local bba=_c[c_a[i]:sub(j,j)][2]
if d_a[i]:sub(j,j)=="1"then
table.insert(caa,(bba[1]:gsub("[01]",bd)))
table.insert(daa,(bba[2]:gsub("[01]",bd)))
table.insert(_ba,(bba[3]:gsub("[01]",bd)))else table.insert(caa,bba[1])
table.insert(daa,bba[2])table.insert(_ba,bba[3])end end;table.insert(a_a,table.concat(_aa))
table.insert(a_a,table.concat(aaa))table.insert(a_a,table.concat(baa))
table.insert(b_a,table.concat(caa))table.insert(b_a,table.concat(daa))
table.insert(b_a,table.concat(_ba))end;cd[__a]={a_a,b_a}if ad then ad="Font"..f.."Yeld"..char
os.queueEvent(ad)os.pullEvent(ad)end end;db[f]=cd end;return true end
local function bc(_d,ad,bd,cd,dd)
if not type(ad)=="string"then error("Not a String",3)end
local __a=type(bd)=="string"and bd:sub(1,1)or bb[bd]or
error("Wrong Front Color",3)
local a_a=type(cd)=="string"and cd:sub(1,1)or bb[cd]or
error("Wrong Back Color",3)if(db[_d]==nil)then ac(3,false)end;local b_a=db[_d]or
error("Wrong font size selected",3)if ad==""then
return{{""},{""},{""}}end;local c_a={}
for _ba in ad:gmatch('.')do table.insert(c_a,_ba)end;local d_a={}local _aa=#b_a[c_a[1]][1]
for nLine=1,_aa do local _ba={}for i=1,#c_a do
_ba[i]=
b_a[c_a[i]]and b_a[c_a[i]][1][nLine]or""end;d_a[nLine]=table.concat(_ba)end;local aaa={}local baa={}local caa={["0"]=__a,["1"]=a_a}
local daa={["0"]=a_a,["1"]=__a}
for nLine=1,_aa do local _ba={}local aba={}
for i=1,#c_a do local bba=
b_a[c_a[i]]and b_a[c_a[i]][2][nLine]or""
_ba[i]=bba:gsub("[01]",dd and
{["0"]=bd:sub(i,i),["1"]=cd:sub(i,i)}or caa)
aba[i]=bba:gsub("[01]",
dd and{["0"]=cd:sub(i,i),["1"]=bd:sub(i,i)}or daa)end;aaa[nLine]=table.concat(_ba)
baa[nLine]=table.concat(aba)end;return{d_a,aaa,baa}end;local cc=_b("utils")local dc=cc.xmlValue
return
{Label=function(_d)local ad=1;local bd
local cd={setFontSize=function(dd,__a)
if(type(__a)=="number")then ad=__a
if(ad>
1)then dd:setDrawState("label",false)
bd=bc(ad-1,dd:getText(),dd:getForeground(),
dd:getBackground()or colors.lightGray)if(dd:getAutoSize())then
dd:getBase():setSize(#bd[1][1],#bd[1]-1)end else
dd:setDrawState("label",true)end;dd:updateDraw()end;return dd end,getFontSize=function(dd)return
ad end,getSize=function(dd)local __a,a_a=_d.getSize(dd)
if
(ad>1)and(dd:getAutoSize())then
return ad==2 and dd:getText():len()*3 or math.floor(
dd:getText():len()*8.5),
ad==2 and a_a*2 or math.floor(a_a)else return __a,a_a end end,getWidth=function(dd)
local __a=_d.getWidth(dd)if(ad>1)and(dd:getAutoSize())then return ad==2 and
dd:getText():len()*3 or
math.floor(dd:getText():len()*8.5)else
return __a end end,getHeight=function(dd)
local __a=_d.getHeight(dd)if(ad>1)and(dd:getAutoSize())then return
ad==2 and __a*2 or math.floor(__a)else return __a end end,setValuesByXMLData=function(dd,__a,a_a)
_d.setValuesByXMLData(dd,__a,a_a)if(dc("fontSize",__a)~=nil)then
dd:setFontSize(dc("fontSize",__a))end;return dd end,draw=function(dd)
_d.draw(dd)
dd:addDraw("bigfonts",function()
if(ad>1)then local __a,a_a=dd:getPosition()local b_a=dd:getParent()
local c_a,d_a=b_a:getSize()local _aa,aaa=#bd[1][1],#bd[1]__a=__a or
math.floor((c_a-_aa)/2)+1;a_a=a_a or
math.floor((d_a-aaa)/2)+1
for i=1,aaa do dd:addFG(1,i,bd[2][i])
dd:addBG(1,i,bd[3][i])dd:addText(1,i,bd[1][i])end end end)end}return cd end}end
ba["plugins"]["xml"]=function(...)local bb=_b("utils")local cb=bb.uuid;local db=bb.xmlValue
local function _c(bd)
local cd={}cd.___value=nil;cd.___name=bd;cd.___children={}cd.___props={}
cd.___reactiveProps={}function cd:value()return self.___value end
function cd:setValue(dd)self.___value=dd end;function cd:name()return self.___name end
function cd:setName(dd)self.___name=dd end;function cd:children()return self.___children end;function cd:numChildren()return
#self.___children end
function cd:addChild(dd)
if self[dd:name()]~=nil then
if
type(self[dd:name()].name)=="function"then local __a={}
table.insert(__a,self[dd:name()])self[dd:name()]=__a end;table.insert(self[dd:name()],dd)else
self[dd:name()]=dd end;table.insert(self.___children,dd)end;function cd:properties()return self.___props end;function cd:numProperties()
return#self.___props end
function cd:addProperty(dd,__a)local a_a="@"..dd
if self[a_a]~=nil then if
type(self[a_a])=="string"then local b_a={}table.insert(b_a,self[a_a])
self[a_a]=b_a end
table.insert(self[a_a],__a)else self[a_a]=__a end
table.insert(self.___props,{name=dd,value=self[a_a]})end;function cd:reactiveProperties()return self.___reactiveProps end;function cd:addReactiveProperty(dd,__a)
self.___reactiveProps[dd]=__a end;return cd end;local ac={}
function ac:ToXmlString(bd)bd=string.gsub(bd,"&","&amp;")
bd=string.gsub(bd,"<","&lt;")bd=string.gsub(bd,">","&gt;")
bd=string.gsub(bd,"\"","&quot;")
bd=string.gsub(bd,"([^%w%&%;%p%\t% ])",function(cd)
return string.format("&#x%X;",string.byte(cd))end)return bd end
function ac:FromXmlString(bd)
bd=string.gsub(bd,"&#x([%x]+)%;",function(cd)
return string.char(tonumber(cd,16))end)
bd=string.gsub(bd,"&#([0-9]+)%;",function(cd)return string.char(tonumber(cd,10))end)bd=string.gsub(bd,"&quot;","\"")
bd=string.gsub(bd,"&apos;","'")bd=string.gsub(bd,"&gt;",">")
bd=string.gsub(bd,"&lt;","<")bd=string.gsub(bd,"&amp;","&")return bd end;function ac:ParseProps(bd,cd)
string.gsub(cd,"(%w+)=([\"'])(.-)%2",function(dd,__a,a_a)
bd:addProperty(dd,self:FromXmlString(a_a))end)end;function ac:ParseReactiveProps(bd,cd)
string.gsub(cd,"(%w+)={(.-)}",function(dd,__a)
bd:addReactiveProperty(dd,__a)end)end
function ac:ParseXmlText(bd)
local cd={}local dd=_c()table.insert(cd,dd)local __a,a_a,b_a,c_a,d_a;local _aa,aaa=1,1
while true do
__a,aaa,a_a,b_a,c_a,d_a=string.find(bd,"<(%/?)([%w_:]+)(.-)(%/?)>",_aa)if not __a then break end;local caa=string.sub(bd,_aa,__a-1)
if not
string.find(caa,"^%s*$")then
local daa=(dd:value()or"")..self:FromXmlString(caa)cd[#cd]:setValue(daa)end
if d_a=="/"then local daa=_c(b_a)self:ParseProps(daa,c_a)
self:ParseReactiveProps(daa,c_a)dd:addChild(daa)elseif a_a==""then local daa=_c(b_a)
self:ParseProps(daa,c_a)self:ParseReactiveProps(daa,c_a)
table.insert(cd,daa)dd=daa else local daa=table.remove(cd)dd=cd[#cd]
if#cd<1 then error("XmlParser: nothing to close with "..
b_a)end;if daa:name()~=b_a then
error("XmlParser: trying to close "..daa.name.." with "..b_a)end;dd:addChild(daa)end;_aa=aaa+1 end;local baa=string.sub(bd,_aa)if#cd>1 then
error("XmlParser: unclosed "..cd[#cd]:name())end;return dd end;local function bc(bd,cd)local dd=db('script',bd)if(dd~=nil)then
load(dd,nil,"t",cd.env)()end end
local function cc(bd,cd,dd,__a)
local a_a=__a.env
if(cd:sub(1,1)=="$")then local b_a=cd:sub(2)
dd(bd,bd:getBasalt().getVariable(b_a))else
dd(bd,function(...)a_a.event={...}local b_a,c_a=pcall(load(cd,nil,"t",a_a))if
not b_a then error("XML Error: "..c_a)end end)end end
local function dc(bd,cd,dd,__a)
for a_a,b_a in pairs(dd)do local c_a=cd:reactiveProperties()[b_a]if(c_a~=nil)then cc(bd,
c_a.."()",bd[b_a],__a)end end end;local _d=nil
local ad=function(bd)
for cd,dd in ipairs(bd.dependencies)do for __a,a_a in ipairs(dd)do if(a_a==bd)then
table.remove(dd,__a)end end end;bd.dependencies={}end
return
{basalt=function(bd)
local cd={layout=function(dd)return{path=dd}end,reactive=function(dd)local __a=dd;local a_a={}
local b_a=function()
if(_d~=nil)then
table.insert(a_a,_d)table.insert(_d.dependencies,a_a)end;return __a end
local c_a=function(d_a)__a=d_a;local _aa={}for aaa,baa in ipairs(a_a)do _aa[aaa]=baa end;for aaa,baa in ipairs(_aa)do
baa.execute()end end;return b_a,c_a end,untracked=function(dd)
local __a=_d;_d=nil;local a_a=dd()_d=__a;return a_a end,effect=function(dd)
local __a={dependencies={}}
local a_a=function()ad(__a)local b_a=_d;_d=__a;dd()_d=b_a end;__a.execute=a_a;__a.execute()end,derived=function(dd)
local __a,a_a=bd.reactive()bd.effect(function()a_a(dd())end)return __a end}return cd end,VisualObject=function(bd,cd)
local dd={updateValue=function(__a,a_a,b_a)if(
b_a==nil)then return end;local c_a,d_a=__a:getPosition()
local _aa,aaa=__a:getSize()
if(a_a=="x")then __a:setPosition(b_a,d_a)elseif(a_a=="y")then
__a:setPosition(c_a,b_a)elseif(a_a=="width")then __a:setSize(b_a,aaa)elseif(a_a=="height")then
__a:setSize(_aa,b_a)elseif(a_a=="background")then __a:setBackground(colors[b_a])elseif
(a_a=="foreground")then __a:setForeground(colors[b_a])end end,updateSpecifiedValuesByXMLData=function(__a,a_a,b_a)for c_a,d_a in
ipairs(b_a)do local _aa=db(d_a,a_a)
if(_aa~=nil)then __a:updateValue(d_a,_aa)end end end,setValuesByXMLData=function(__a,a_a,b_a)
b_a.env[__a:getName()]=__a
for c_a,d_a in pairs(a_a:reactiveProperties())do
local _aa=function()
local aaa=load("return "..d_a,nil,"t",b_a.env)()__a:updateValue(c_a,aaa)end;cd.effect(_aa)end
__a:updateSpecifiedValuesByXMLData(a_a,{"x","y","width","height","background","foreground"})
dc(__a,a_a,{"onClick","onClickUp","onHover","onScroll","onDrag","onKey","onKeyUp","onRelease","onChar","onGetFocus","onLoseFocus","onResize","onReposition","onEvent","onLeave"},b_a)return __a end}return dd end,ChangeableObject=function(bd,cd)
local dd={updateValue=function(__a,a_a,b_a)if(
b_a==nil)then return end;bd.updateValue(__a,a_a,b_a)if
(a_a=="value")then __a:setValue(b_a)end end,setValuesByXMLData=function(__a,a_a,b_a)
bd.setValuesByXMLData(__a,a_a,b_a)
__a:updateSpecifiedValuesByXMLData(a_a,{"value"})cc(__a,a_a,{"onChange"},b_a)return __a end}return dd end,Container=function(bd,cd)
local dd={}local function __a(d_a,_aa,aaa)
if(_aa~=nil)then _aa:setValuesByXMLData(d_a,aaa)end end
local function a_a(d_a,_aa,aaa,baa)
if(d_a~=nil)then if(d_a.properties~=nil)then
d_a={d_a}end
for caa,daa in pairs(d_a)do
local _ba=_aa(aaa,daa["@id"]or cb())dd[_ba:getName()]=_ba;__a(daa,_ba,baa)end end end
local function b_a(d_a,_aa,aaa,baa)local caa={}
for _ba,aba in ipairs(aaa:properties())do caa[aba.name]=aba.value end;local daa={}for _ba,aba in pairs(aaa:reactiveProperties())do
daa[_ba]=cd.derived(function()return load("return "..aba,
nil,"t",baa.env)()end)end
setmetatable(caa,{__index=function(_ba,aba)return
daa[aba]()end})d_a:loadLayout(_aa.path,caa)end
local c_a={setValuesByXMLData=function(d_a,_aa,aaa)dd={}bd.setValuesByXMLData(d_a,_aa,aaa)
local baa=_aa:children()local caa=cd.getObjects()
for daa,_ba in pairs(baa)do local aba=_ba.___name
if(aba~="animation")then
local bba=aaa.env[aba]local cba=aba:gsub("^%l",string.upper)
if(bba~=nil)then
b_a(d_a,bba,_ba,aaa)elseif(caa[cba]~=nil)then local dba=d_a["add"..cba]a_a(_ba,dba,d_a,aaa)end end end;a_a(_aa["animation"],d_a.addAnimation,d_a,aaa)return
d_a end,loadLayout=function(d_a,_aa,aaa)
if
(fs.exists(_aa))then local baa={}baa.env=_ENV;baa.env.props=aaa;local caa=fs.open(_aa,"r")
local daa=ac:ParseXmlText(caa.readAll())caa.close()dd={}bc(daa,baa)
d_a:setValuesByXMLData(daa,baa)end;return d_a end,getXMLElements=function(d_a)return
dd end}return c_a end,BaseFrame=function(bd,cd)
local dd={updateValue=function(__a,a_a,b_a)if(
b_a==nil)then return end;bd.updateValue(__a,a_a,b_a)
local c_a,d_a=__a:getOffset()if(a_a=="layout")then __a:setLayout(b_a)elseif(a_a=="xOffset")then
__a:setOffset(b_a,d_a)end end,setValuesByXMLData=function(__a,a_a,b_a)
bd.setValuesByXMLData(__a,a_a,b_a)
__a:updateSpecifiedValuesByXMLData(a_a,{"layout","xOffset"})return __a end}return dd end,Frame=function(bd,cd)
local dd={updateValue=function(__a,a_a,b_a)if(
b_a==nil)then return end;bd.updateValue(__a,a_a,b_a)
local c_a,d_a=__a:getOffset()
if(a_a=="layout")then __a:setLayout(b_a)elseif(a_a=="xOffset")then
__a:setOffset(b_a,d_a)elseif(a_a=="yOffset")then __a:setOffset(c_a,b_a)end end,setValuesByXMLData=function(__a,a_a,b_a)
bd.setValuesByXMLData(__a,a_a,b_a)
__a:updateSpecifiedValuesByXMLData(a_a,{"layout","xOffset","yOffset"})return __a end}return dd end,Flexbox=function(bd,cd)
local dd={updateValue=function(__a,a_a,b_a)if(
b_a==nil)then return end;bd.updateValue(__a,a_a,b_a)
if
(a_a=="flexDirection")then __a:setFlexDirection(b_a)elseif(a_a=="justifyContent")then
__a:setJustifyContent(b_a)elseif(a_a=="alignItems")then __a:setAlignItems(b_a)elseif(a_a=="spacing")then
__a:setSpacing(b_a)end end,setValuesByXMLData=function(__a,a_a,b_a)
bd.setValuesByXMLData(__a,a_a,b_a)
__a:updateSpecifiedValuesByXMLData(a_a,{"flexDirection","justifyContent","alignItems","spacing"})return __a end}return dd end,Button=function(bd,cd)
local dd={updateValue=function(__a,a_a,b_a)if(
b_a==nil)then return end;bd.updateValue(__a,a_a,b_a)
if(a_a=="text")then
__a:setText(b_a)elseif(a_a=="horizontalAlign")then __a:setHorizontalAlign(b_a)elseif
(a_a=="verticalAlign")then __a:setVerticalAlign(b_a)end end,setValuesByXMLData=function(__a,a_a,b_a)
bd.setValuesByXMLData(__a,a_a,b_a)
__a:updateSpecifiedValuesByXMLData(a_a,{"text","horizontalAlign","verticalAlign"})return __a end}return dd end,Label=function(bd,cd)
local dd={updateValue=function(__a,a_a,b_a)if(
b_a==nil)then return end;bd.updateValue(__a,a_a,b_a)
if(a_a=="text")then
__a:setText(b_a)elseif(a_a=="align")then __a:setAlign(b_a)end end,setValuesByXMLData=function(__a,a_a,b_a)
bd.setValuesByXMLData(__a,a_a,b_a)
__a:updateSpecifiedValuesByXMLData(a_a,{"text","align"})return __a end}return dd end,Input=function(bd,cd)
local dd={updateValue=function(__a,a_a,b_a)if(
b_a==nil)then return end;bd.updateValue(__a,a_a,b_a)
local c_a,d_a,_aa=__a:getDefaultText()
if(a_a=="defaultText")then __a:setDefaultText(b_a,d_a,_aa)elseif
(a_a=="defaultFG")then __a:setDefaultText(c_a,b_a,_aa)elseif(a_a=="defaultBG")then
__a:setDefaultText(c_a,d_a,b_a)elseif(a_a=="offset")then __a:setOffset(b_a)elseif(a_a=="textOffset")then
__a:setTextOffset(b_a)elseif(a_a=="text")then __a:setText(b_a)elseif(a_a=="inputLimit")then
__a:setInputLimit(b_a)end end,setValuesByXMLData=function(__a,a_a,b_a)
bd.setValuesByXMLData(__a,a_a,b_a)
__a:updateSpecifiedValuesByXMLData(a_a,{"defaultText","defaultFG","defaultBG","offset","textOffset","text","inputLimit"})return __a end}return dd end,Image=function(bd,cd)
local dd={updateValue=function(__a,a_a,b_a)if(
b_a==nil)then return end;bd.updateValue(__a,a_a,b_a)
local c_a,d_a=__a:getOffset()
if(a_a=="xOffset")then __a:setOffset(b_a,d_a)elseif(a_a=="yOffset")then
__a:setOffset(c_a,b_a)elseif(a_a=="path")then __a:loadImage(b_a)elseif(a_a=="usePalette")then
__a:usePalette(b_a)elseif(a_a=="play")then __a:play(b_a)end end,setValuesByXMLData=function(__a,a_a,b_a)
bd.setValuesByXMLData(__a,a_a,b_a)
__a:updateSpecifiedValuesByXMLData(a_a,{"xOffset","yOffset","path","usePalette","play"})return __a end}return dd end,Checkbox=function(bd,cd)
local dd={updateValue=function(__a,a_a,b_a)if(
b_a==nil)then return end;bd.updateValue(__a,a_a,b_a)
local c_a,d_a=__a:getSymbol()
if(a_a=="text")then __a:setText(b_a)elseif(a_a=="checked")then
__a:setChecked(b_a)elseif(a_a=="textPosition")then __a:setTextPosition(b_a)elseif(a_a=="activeSymbol")then
__a:setSymbol(b_a,d_a)elseif(a_a=="inactiveSymbol")then __a:setSymbol(c_a,b_a)end end,setValuesByXMLData=function(__a,a_a,b_a)
bd.setValuesByXMLData(__a,a_a,b_a)
__a:updateSpecifiedValuesByXMLData(a_a,{"text","checked","textPosition","activeSymbol","inactiveSymbol"})return __a end}return dd end,Program=function(bd,cd)
local dd={updateValue=function(__a,a_a,b_a)if(
b_a==nil)then return end;bd.updateValue(__a,a_a,b_a)if
(a_a=="execute")then __a:execute(b_a)end end,setValuesByXMLData=function(__a,a_a,b_a)
bd.setValuesByXMLData(__a,a_a,b_a)
__a:updateSpecifiedValuesByXMLData(a_a,{"execute"})return __a end}return dd end,Progressbar=function(bd,cd)
local dd={updateValue=function(__a,a_a,b_a)if(
b_a==nil)then return end;bd.updateValue(__a,a_a,b_a)
local c_a,d_a,_aa=__a:getProgressBar()
if(a_a=="direction")then __a:setDirection(b_a)elseif(a_a=="activeBarColor")then
__a:setProgressBar(b_a,d_a,_aa)elseif(a_a=="activeBarSymbol")then __a:setProgressBar(c_a,b_a,_aa)elseif(a_a==
"activeBarSymbolColor")then __a:setProgressBar(c_a,d_a,b_a)elseif
(a_a=="backgroundSymbol")then __a:setBackgroundSymbol(b_a)elseif(a_a=="progress")then
__a:setProgress(b_a)end end,setValuesByXMLData=function(__a,a_a,b_a)
bd.setValuesByXMLData(__a,a_a,b_a)
__a:updateSpecifiedValuesByXMLData(a_a,{"direction","activeBarColor","activeBarSymbol","activeBarSymbolColor","backgroundSymbol","progress"})return __a end}return dd end,Slider=function(bd,cd)
local dd={updateValue=function(__a,a_a,b_a)if(
b_a==nil)then return end;bd.updateValue(__a,a_a,b_a)
if
(a_a=="symbol")then __a:setSymbol(b_a)elseif(a_a=="symbolColor")then
__a:setSymbolColor(b_a)elseif(a_a=="index")then __a:setIndex(b_a)elseif(a_a=="maxValue")then
__a:setMaxValue(b_a)elseif(a_a=="barType")then __a:setBarType(b_a)end end,setValuesByXMLData=function(__a,a_a,b_a)
bd.setValuesByXMLData(__a,a_a,b_a)
__a:updateSpecifiedValuesByXMLData(a_a,{"symbol","symbolColor","index","maxValue","barType"})return __a end}return dd end,Scrollbar=function(bd,cd)
local dd={updateValue=function(__a,a_a,b_a)if(
b_a==nil)then return end;bd.updateValue(__a,a_a,b_a)
if
(a_a=="symbol")then __a:setSymbol(b_a)elseif(a_a=="symbolColor")then
__a:setSymbolColor(b_a)elseif(a_a=="symbolSize")then __a:setSymbolSize(b_a)elseif(a_a=="scrollAmount")then
__a:setScrollAmount(b_a)elseif(a_a=="index")then __a:setIndex(b_a)elseif(a_a=="maxValue")then
__a:setMaxValue(b_a)elseif(a_a=="barType")then __a:setBarType(b_a)end end,setValuesByXMLData=function(__a,a_a,b_a)
bd.setValuesByXMLData(__a,a_a,b_a)
__a:updateSpecifiedValuesByXMLData(a_a,{"symbol","symbolColor","symbolSize","scrollAmount","index","maxValue","barType"})return __a end}return dd end,MonitorFrame=function(bd,cd)
local dd={updateValue=function(__a,a_a,b_a)if(
b_a==nil)then return end;bd.updateValue(__a,a_a,b_a)if
(a_a=="monitor")then __a:setMonitor(b_a)end end,setValuesByXMLData=function(__a,a_a,b_a)
bd.setValuesByXMLData(__a,a_a,b_a)
__a:updateSpecifiedValuesByXMLData(a_a,{"monitor"})return __a end}return dd end,Switch=function(bd,cd)
local dd={updateValue=function(__a,a_a,b_a)if(
b_a==nil)then return end;bd.updateValue(__a,a_a,b_a)
if
(a_a=="symbol")then __a:setSymbol(b_a)elseif(a_a=="activeBackground")then
__a:setActiveBackground(b_a)elseif(a_a=="inactiveBackground")then __a:setInactiveBackground(b_a)end end,setValuesByXMLData=function(__a,a_a,b_a)
bd.setValuesByXMLData(__a,a_a,b_a)
__a:updateSpecifiedValuesByXMLData(a_a,{"symbol","activeBackground","inactiveBackground"})return __a end}return dd end,Textfield=function(bd,cd)
local dd={updateValue=function(__a,a_a,b_a)if(
b_a==nil)then return end;bd.updateValue(__a,a_a,b_a)
local c_a,d_a=__a:getSelection()local _aa,aaa=__a:getOffset()
if(a_a=="bgSelection")then
__a:setSelection(c_a,b_a)elseif(a_a=="fgSelection")then __a:setSelection(b_a,d_a)elseif(a_a=="xOffset")then
__a:setOffset(b_a,aaa)elseif(a_a=="yOffset")then __a:setOffset(_aa,b_a)end end,setValuesByXMLData=function(__a,a_a,b_a)
bd.setValuesByXMLData(__a,a_a,b_a)
__a:updateSpecifiedValuesByXMLData(a_a,{"bgSelection","fgSelection","xOffset","yOffset"})
if(a_a["lines"]~=nil)then local c_a=a_a["lines"]["line"]if
(c_a.properties~=nil)then c_a={c_a}end;for d_a,_aa in pairs(c_a)do
__a:addLine(_aa:value())end end
if(a_a["keywords"]~=nil)then
for c_a,d_a in pairs(a_a["keywords"])do
if(colors[c_a]~=nil)then
local _aa=d_a;if(_aa.properties~=nil)then _aa={_aa}end;local aaa={}
for baa,caa in pairs(_aa)do
local daa=caa["keyword"]if(caa["keyword"].properties~=nil)then
daa={caa["keyword"]}end;for _ba,aba in pairs(daa)do
table.insert(aaa,aba:value())end end;__a:addKeywords(colors[c_a],aaa)end end end
if(a_a["rules"]~=nil)then
if(a_a["rules"]["rule"]~=nil)then
local c_a=a_a["rules"]["rule"]if(a_a["rules"]["rule"].properties~=nil)then
c_a={a_a["rules"]["rule"]}end
for d_a,_aa in pairs(c_a)do if(db("pattern",_aa)~=nil)then
__a:addRule(db("pattern",_aa),colors[db("fg",_aa)],colors[db("bg",_aa)])end end end end;return __a end}return dd end,Thread=function(bd,cd)
local dd={setValuesByXMLData=function(__a,a_a,b_a)local c_a=
db("start",a_a)~=nil;if(c_a~=nil)then
local d_a=load(c_a,nil,"t",b_a.env)__a:start(d_a)end;return __a end}return dd end,Timer=function(bd,cd)
local dd={updateValue=function(__a,a_a,b_a)if(
b_a==nil)then return end;bd.updateValue(__a,a_a,b_a)
if
(a_a=="start")then __a:start(b_a)elseif(a_a=="time")then __a:setTime(b_a)end end,setValuesByXMLData=function(__a,a_a,b_a)
bd.setValuesByXMLData(__a,a_a,b_a)
__a:updateSpecifiedValuesByXMLData(a_a,{"start","time"})dc(__a,a_a,{"onCall"},b_a)return __a end}return dd end,List=function(bd,cd)
local dd={updateValue=function(__a,a_a,b_a)if(
b_a==nil)then return end;bd.updateValue(__a,a_a,b_a)
local c_a,d_a=__a:getSelectionColor()
if(a_a=="align")then __a:setTextAlign(b_a)elseif(a_a=="offset")then
__a:setOffset(b_a)elseif(a_a=="selectionBg")then __a:setSelectionColor(b_a,d_a)elseif
(a_a=="selectionFg")then __a:setSelectionColor(c_a,b_a)elseif(a_a=="scrollable")then
__a:setScrollable(b_a)end end,setValuesByXMLData=function(__a,a_a,b_a)
bd.setValuesByXMLData(__a,a_a,b_a)
__a:updateSpecifiedValuesByXMLData(a_a,{"align","offset","selectionBg","selectionFg","scrollable"})
if(a_a["item"]~=nil)then local c_a=a_a["item"]
if(c_a.properties~=nil)then c_a={c_a}end
for d_a,_aa in pairs(c_a)do if(__a:getType()~="Radio")then
__a:addItem(db("text",_aa),colors[db("bg",_aa)],colors[db("fg",_aa)])end end end;return __a end}return dd end,Dropdown=function(bd,cd)
local dd={updateValue=function(__a,a_a,b_a)if(
b_a==nil)then return end;bd.updateValue(__a,a_a,b_a)
local c_a,d_a=__a:getDropdownSize()
if(a_a=="dropdownWidth")then __a:setDropdownSize(b_a,d_a)elseif
(a_a=="dropdownHeight")then __a:setDropdownSize(c_a,b_a)end end,setValuesByXMLData=function(__a,a_a,b_a)
bd.setValuesByXMLData(__a,a_a,b_a)
__a:updateSpecifiedValuesByXMLData(a_a,{"dropdownWidth","dropdownHeight"})return __a end}return dd end,Radio=function(bd,cd)
local dd={updateValue=function(__a,a_a,b_a)if(
b_a==nil)then return end;bd.updateValue(__a,a_a,b_a)
local c_a,d_a=__a:getBoxSelectionColor()local _aa,aaa=__a:setBoxDefaultColor()
if(a_a=="selectionBg")then
__a:setBoxSelectionColor(b_a,d_a)elseif(a_a=="selectionFg")then __a:setBoxSelectionColor(c_a,b_a)elseif
(a_a=="defaultBg")then __a:setBoxDefaultColor(b_a,aaa)elseif(a_a=="defaultFg")then
__a:setBoxDefaultColor(_aa,b_a)end end,setValuesByXMLData=function(__a,a_a,b_a)
bd.setValuesByXMLData(__a,a_a,b_a)
__a:updateSpecifiedValuesByXMLData(a_a,{"selectionBg","selectionFg","defaultBg","defaultFg"})
if(a_a["item"]~=nil)then local c_a=a_a["item"]
if(c_a.properties~=nil)then c_a={c_a}end;for d_a,_aa in pairs(c_a)do
__a:addItem(db("text",_aa),db("x",_aa),db("y",_aa),colors[db("bg",_aa)],colors[db("fg",_aa)])end end;return __a end}return dd end,Menubar=function(bd,cd)
local dd={updateValue=function(__a,a_a,b_a)if(
b_a==nil)then return end;bd.updateValue(__a,a_a,b_a)if
(a_a=="space")then __a:setSpace(b_a)elseif(a_a=="scrollable")then
__a:setScrollable(b_a)end end,setValuesByXMLData=function(__a,a_a,b_a)
bd.setValuesByXMLData(__a,a_a,b_a)
__a:updateSpecifiedValuesByXMLData(a_a,{"space","scrollable"})return __a end}return dd end,Graph=function(bd,cd)
local dd={updateValue=function(__a,a_a,b_a)if(
b_a==nil)then return end;bd.updateValue(__a,a_a,b_a)
local c_a,d_a=__a:getGraphSymbol()
if(a_a=="maxEntries")then __a:setMaxEntries(b_a)elseif(a_a=="type")then
__a:setType(b_a)elseif(a_a=="minValue")then __a:setMinValue(b_a)elseif(a_a=="maxValue")then
__a:setMaxValue(b_a)elseif(a_a=="symbol")then __a:setGraphSymbol(b_a,d_a)elseif(a_a=="symbolColor")then
__a:setGraphSymbol(c_a,b_a)end end,setValuesByXMLData=function(__a,a_a,b_a)
bd.setValuesByXMLData(__a,a_a,b_a)
__a:updateSpecifiedValuesByXMLData(a_a,{"maxEntries","type","minValue","maxValue","symbol","symbolColor"})
if(a_a["item"]~=nil)then local c_a=a_a["item"]
if(c_a.properties~=nil)then c_a={c_a}end
for d_a,_aa in pairs(c_a)do __a:addDataPoint(db("value"))end end;return __a end}return dd end,Treeview=function(bd,cd)
local dd={updateValue=function(__a,a_a,b_a)if(
b_a==nil)then return end;bd.updateValue(__a,a_a,b_a)
local c_a,d_a=__a:getSelectionColor()local _aa,aaa=__a:getOffset()
if(a_a=="space")then __a:setSpace(b_a)elseif(a_a==
"scrollable")then __a:setScrollable(b_a)elseif(a_a=="selectionBg")then
__a:setSelectionColor(b_a,d_a)elseif(a_a=="selectionFg")then __a:setSelectionColor(c_a,b_a)elseif
(a_a=="xOffset")then __a:setOffset(b_a,aaa)elseif(a_a=="yOffset")then
__a:setOffset(_aa,b_a)end end,setValuesByXMLData=function(__a,a_a,b_a)
bd.setValuesByXMLData(__a,a_a,b_a)
__a:updateSpecifiedValuesByXMLData(a_a,{"space","scrollable","selectionBg","selectionFg","xOffset","yOffset"})
local function c_a(d_a,_aa)
if(_aa["node"]~=nil)then local aaa=_aa["node"]
if(aaa.properties~=nil)then aaa={aaa}end
for baa,caa in pairs(aaa)do
local daa=d_a:addNode(db("text",caa),colors[db("bg",caa)],colors[db("fg",caa)])c_a(daa,caa)end end end
if(a_a["node"]~=nil)then local d_a=a_a["node"]
if(d_a.properties~=nil)then d_a={d_a}end
for _aa,aaa in pairs(d_a)do
local baa=__a:addNode(db("text",aaa),colors[db("bg",aaa)],colors[db("fg",aaa)])c_a(baa,aaa)end end;return __a end}return dd end}end
ba["plugins"]["betterError"]=function(...)local bb=_b("utils")local cb=bb.wrapText
return
{basalt=function(db)local _c
local ac
return
{getBasaltErrorFrame=function()return _c end,basaltError=function(bc)
if(_c==nil)then local dc=db.getMainFrame()
local _d,ad=dc:getSize()
_c=dc:addMovableFrame("basaltErrorFrame"):setSize(_d-10,ad-4):setBackground(colors.lightGray):setForeground(colors.white):setZIndex(500)
_c:addPane("titleBackground"):setSize(_d,1):setPosition(1,1):setBackground(colors.black):setForeground(colors.white)
_c:setPosition(_d/2 -_c:getWidth()/2,ad/2 -_c:getHeight()/2):setBorder(colors.black)
_c:addLabel("title"):setText("Basalt Unexpected Error"):setPosition(2,1):setBackground(colors.black):setForeground(colors.white)
ac=_c:addList("errorList"):setSize(_c:getWidth()-2,_c:getHeight()-6):setPosition(2,3):setBackground(colors.lightGray):setForeground(colors.white):setSelectionColor(colors.lightGray,colors.gray)
_c:addButton("xButton"):setText("x"):setPosition(_c:getWidth(),1):setSize(1,1):setBackground(colors.black):setForeground(colors.red):onClick(function()
_c:hide()end)
_c:addButton("Clear"):setText("Clear"):setPosition(
_c:getWidth()-19,_c:getHeight()-1):setSize(9,1):setBackground(colors.black):setForeground(colors.white):onClick(function()
ac:clear()end)
_c:addButton("Close"):setText("Close"):setPosition(
_c:getWidth()-9,_c:getHeight()-1):setSize(9,1):setBackground(colors.black):setForeground(colors.white):onClick(function()
db.autoUpdate(false)term.clear()term.setCursorPos(1,1)end)end;_c:show()
ac:addItem(("-"):rep(_c:getWidth()-2))local cc=cb(bc,_c:getWidth()-2)for i=1,#cc do
ac:addItem(cc[i])end end}end}end
ba["plugins"]["animations"]=function(...)
local bb,cb,db,_c,ac,bc=math.floor,math.sin,math.cos,math.pi,math.sqrt,math.pow;local function cc(cab,dab,_bb)return cab+ (dab-cab)*_bb end
local function dc(cab)return cab end;local function _d(cab)return 1 -cab end
local function ad(cab)return cab*cab*cab end;local function bd(cab)return _d(ad(_d(cab)))end;local function cd(cab)return
cc(ad(cab),bd(cab),cab)end
local function dd(cab)return cb((cab*_c)/2)end;local function __a(cab)return _d(db((cab*_c)/2))end;local function a_a(cab)return- (
db(_c*x)-1)/2 end
local function b_a(cab)local dab=1.70158
local _bb=dab+1;return _bb*cab^3 -dab*cab^2 end;local function c_a(cab)return cab^3 end;local function d_a(cab)local dab=(2 *_c)/3
return cab==0 and 0 or(cab==1 and 1 or
(-2 ^ (10 *
cab-10)*cb((cab*10 -10.75)*dab)))end
local function _aa(cab)return
cab==0 and 0 or 2 ^ (10 *cab-10)end
local function aaa(cab)return cab==0 and 0 or 2 ^ (10 *cab-10)end
local function baa(cab)local dab=1.70158;local _bb=dab*1.525;return
cab<0.5 and( (2 *cab)^2 *
( (_bb+1)*2 *cab-_bb))/2 or
(
(2 *cab-2)^2 * ( (_bb+1)* (cab*2 -2)+_bb)+2)/2 end;local function caa(cab)return
cab<0.5 and 4 *cab^3 or 1 - (-2 *cab+2)^3 /2 end
local function daa(cab)
local dab=(2 *_c)/4.5
return
cab==0 and 0 or(cab==1 and 1 or
(
cab<0.5 and- (2 ^ (20 *cab-10)*
cb((20 *cab-11.125)*dab))/2 or
(2 ^ (-20 *cab+10)*cb((20 *cab-11.125)*dab))/2 +1))end
local function _ba(cab)return
cab==0 and 0 or(cab==1 and 1 or
(
cab<0.5 and 2 ^ (20 *cab-10)/2 or(2 -2 ^ (-20 *cab+10))/2))end;local function aba(cab)return
cab<0.5 and 2 *cab^2 or 1 - (-2 *cab+2)^2 /2 end;local function bba(cab)return
cab<0.5 and 8 *
cab^4 or 1 - (-2 *cab+2)^4 /2 end;local function cba(cab)return
cab<0.5 and 16 *
cab^5 or 1 - (-2 *cab+2)^5 /2 end;local function dba(cab)
return cab^2 end;local function _ca(cab)return cab^4 end
local function aca(cab)return cab^5 end;local function bca(cab)local dab=1.70158;local _bb=dab+1;return
1 +_bb* (cab-1)^3 +dab* (cab-1)^2 end;local function cca(cab)return 1 -
(1 -cab)^3 end
local function dca(cab)local dab=(2 *_c)/3;return

cab==0 and 0 or(cab==1 and 1 or(
2 ^ (-10 *cab)*cb((cab*10 -0.75)*dab)+1))end
local function _da(cab)return cab==1 and 1 or 1 -2 ^ (-10 *cab)end;local function ada(cab)return 1 - (1 -cab)* (1 -cab)end;local function bda(cab)return 1 - (
1 -cab)^4 end;local function cda(cab)
return 1 - (1 -cab)^5 end
local function dda(cab)return 1 -ac(1 -bc(cab,2))end;local function __b(cab)return ac(1 -bc(cab-1,2))end
local function a_b(cab)return

cab<0.5 and(1 -ac(
1 -bc(2 *cab,2)))/2 or(ac(1 -bc(-2 *cab+2,2))+1)/2 end
local function b_b(cab)local dab=7.5625;local _bb=2.75
if(cab<1 /_bb)then return dab*cab*cab elseif(cab<2 /_bb)then local abb=cab-
1.5 /_bb;return dab*abb*abb+0.75 elseif(cab<2.5 /_bb)then local abb=cab-
2.25 /_bb;return dab*abb*abb+0.9375 else
local abb=cab-2.625 /_bb;return dab*abb*abb+0.984375 end end;local function c_b(cab)return 1 -b_b(1 -cab)end;local function d_b(cab)return
x<0.5 and(1 -
b_b(1 -2 *cab))/2 or(1 +b_b(2 *cab-1))/2 end
local _ab={linear=dc,lerp=cc,flip=_d,easeIn=ad,easeInSine=__a,easeInBack=b_a,easeInCubic=c_a,easeInElastic=d_a,easeInExpo=aaa,easeInQuad=dba,easeInQuart=_ca,easeInQuint=aca,easeInCirc=dda,easeInBounce=c_b,easeOut=bd,easeOutSine=dd,easeOutBack=bca,easeOutCubic=cca,easeOutElastic=dca,easeOutExpo=_da,easeOutQuad=ada,easeOutQuart=bda,easeOutQuint=cda,easeOutCirc=__b,easeOutBounce=b_b,easeInOut=cd,easeInOutSine=a_a,easeInOutBack=baa,easeInOutCubic=caa,easeInOutElastic=daa,easeInOutExpo=_ba,easeInOutQuad=aba,easeInOutQuart=bba,easeInOutQuint=cba,easeInOutCirc=a_b,easeInOutBounce=d_b}local aab=_b("utils")local bab=aab.xmlValue
return
{VisualObject=function(cab,dab)local _bb={}local abb="linear"
local function bbb(acb,bcb)for ccb,dcb in pairs(_bb)do if(dcb.timerId==
bcb)then return dcb end end end
local function cbb(acb,bcb,ccb,dcb,_db,adb,bdb,cdb,ddb,__c)local a_c,b_c=ddb(acb)if(_bb[bdb]~=nil)then
os.cancelTimer(_bb[bdb].timerId)end;_bb[bdb]={}
_bb[bdb].call=function()
local c_c=_bb[bdb].progress
local d_c=math.floor(_ab.lerp(a_c,bcb,_ab[adb](c_c/dcb))+0.5)
local _ac=math.floor(_ab.lerp(b_c,ccb,_ab[adb](c_c/dcb))+0.5)__c(acb,d_c,_ac)end
_bb[bdb].finished=function()__c(acb,bcb,ccb)if(cdb~=nil)then cdb(acb)end end;_bb[bdb].timerId=os.startTimer(0.05 +_db)
_bb[bdb].progress=0;_bb[bdb].duration=dcb;_bb[bdb].mode=adb
acb:listenEvent("other_event")end
local function dbb(acb,bcb,ccb,dcb,_db,...)local adb={...}if(_bb[dcb]~=nil)then
os.cancelTimer(_bb[dcb].timerId)end;_bb[dcb]={}local bdb=1;_bb[dcb].call=function()
local cdb=adb[bdb]_db(acb,cdb)end end
local _cb={animatePosition=function(acb,bcb,ccb,dcb,_db,adb,bdb)adb=adb or abb;dcb=dcb or 1;_db=_db or 0
bcb=math.floor(bcb+0.5)ccb=math.floor(ccb+0.5)
cbb(acb,bcb,ccb,dcb,_db,adb,"position",bdb,acb.getPosition,acb.setPosition)return acb end,animateSize=function(acb,bcb,ccb,dcb,_db,adb,bdb)adb=
adb or abb;dcb=dcb or 1;_db=_db or 0
cbb(acb,bcb,ccb,dcb,_db,adb,"size",bdb,acb.getSize,acb.setSize)return acb end,animateOffset=function(acb,bcb,ccb,dcb,_db,adb,bdb)adb=
adb or abb;dcb=dcb or 1;_db=_db or 0
cbb(acb,bcb,ccb,dcb,_db,adb,"offset",bdb,acb.getOffset,acb.setOffset)return acb end,animateBackground=function(acb,bcb,ccb,dcb,_db,adb)_db=
_db or abb;ccb=ccb or 1;dcb=dcb or 0
dbb(acb,bcb,nil,ccb,dcb,_db,"background",adb,acb.getBackground,acb.setBackground)return acb end,doneHandler=function(acb,bcb,...)
for ccb,dcb in
pairs(_bb)do if(dcb.timerId==bcb)then _bb[ccb]=nil
acb:sendEvent("animation_done",acb,"animation_done",ccb)end end end,onAnimationDone=function(acb,...)
for bcb,ccb in
pairs(table.pack(...))do if(type(ccb)=="function")then
acb:registerEvent("animation_done",ccb)end end;return acb end,eventHandler=function(acb,bcb,ccb,...)
cab.eventHandler(acb,bcb,ccb,...)
if(bcb=="timer")then local dcb=bbb(acb,ccb)
if(dcb~=nil)then
if(dcb.progress<dcb.duration)then
dcb.call()dcb.progress=dcb.progress+0.05
dcb.timerId=os.startTimer(0.05)else dcb.finished()acb:doneHandler(ccb)end end end end,setValuesByXMLData=function(acb,bcb,ccb)
cab.setValuesByXMLData(acb,bcb,ccb)
local dcb,_db,adb,bdb,cdb=bab("animateX",bcb),bab("animateY",bcb),bab("animateDuration",bcb),bab("animateTimeOffset",bcb),bab("animateMode",bcb)
local ddb,__c,a_c,b_c,c_c=bab("animateW",bcb),bab("animateH",bcb),bab("animateDuration",bcb),bab("animateTimeOffset",bcb),bab("animateMode",bcb)
local d_c,_ac,aac,bac,cac=bab("animateXOffset",bcb),bab("animateYOffset",bcb),bab("animateDuration",bcb),bab("animateTimeOffset",bcb),bab("animateMode",bcb)if(dcb~=nil and _db~=nil)then
acb:animatePosition(dcb,_db,aac,bac,cac)end;if(ddb~=nil and __c~=nil)then
acb:animateSize(ddb,__c,aac,bac,cac)end;if(d_c~=nil and _ac~=nil)then
acb:animateOffset(d_c,_ac,aac,bac,cac)end;return acb end}return _cb end}end;return ba["main"]()