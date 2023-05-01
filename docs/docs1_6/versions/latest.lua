local aa={}local ba=true;local ca=require
local da=function(ab)
for bb,cb in pairs(aa)do
if(type(cb)=="table")then for db,_c in pairs(cb)do if(db==ab)then
return _c()end end else if(bb==ab)then return cb()end end end;return ca(ab)end
local _b=function(ab)if(ab~=nil)then return aa[ab]end;return aa end
aa["module"]=function(...)return
function(ab)local bb,cb=pcall(da,ab)return bb and cb or nil end end
aa["loadObjects"]=function(...)local ab={}if(ba)then
for db,_c in pairs(_b("objects"))do ab[db]=_c()end;return ab end;local bb=table.pack(...)local cb=fs.getDir(
bb[2]or"Basalt")if(cb==nil)then
error("Unable to find directory "..bb[2]..
" please report this bug to our discord.")end;for db,_c in
pairs(fs.list(fs.combine(cb,"objects")))do
if(_c~="example.lua")then local ac=_c:gsub(".lua","")ab[ac]=da(ac)end end;return ab end
aa["main"]=function(...)local ab=da("basaltEvent")()local bb=da("Frame")
local cb=da("theme")local db=da("utils")local _c=da("basaltLogs")local ac=db.uuid
local bc=db.createText;local cc=db.tableCount;local dc=300;local _d=50;local ad=term.current()local bd="1.6.5"local cd=fs.getDir(
table.pack(...)[2]or"")
local dd,__a,a_a,b_a,c_a,d_a={},{},{},{},{},{}local _aa,aaa,baa,caa;local daa={}if
not term.isColor or not term.isColor()then
error('Basalt requires an advanced (golden) computer to run.',0)end;local _ba={}
for dab,_bb in
pairs(colors)do if(type(_bb)=="number")then
_ba[dab]={ad.getPaletteColor(_bb)}end end
local function aba()caa=false;ad.clear()ad.setCursorPos(1,1)
for dab,_bb in pairs(colors)do if(type(_bb)==
"number")then
ad.setPaletteColor(_bb,colors.packRGB(table.unpack(_ba[dab])))end end end
local function bba(dab)ad.clear()ad.setBackgroundColor(colors.black)
ad.setTextColor(colors.red)local _bb,abb=ad.getSize()if(daa.logging)then _c(dab,"Error")end;local bbb=bc(
"Basalt error: "..dab,_bb)local cbb=1;for dbb,_cb in pairs(bbb)do
ad.setCursorPos(1,cbb)ad.write(_cb)cbb=cbb+1 end;ad.setCursorPos(1,
cbb+1)caa=false end
local function cba(dab)
assert(dab~="function","Schedule needs a function in order to work!")
return function(...)local _bb=coroutine.create(dab)
local abb,bbb=coroutine.resume(_bb,...)
if(abb)then table.insert(d_a,{_bb,bbb})else bba(bbb)end end end;local dba=function(dab,_bb)c_a[dab]=_bb end
local _ca=function(dab)return c_a[dab]end;local aca=function(dab)cb=dab end
local bca=function(dab)return cb[dab]end
local cca={getDynamicValueEventSetting=function()return daa.dynamicValueEvents end,getMainFrame=function()return _aa end,setVariable=dba,getVariable=_ca,getTheme=bca,setMainFrame=function(dab)
_aa=dab end,getActiveFrame=function()return aaa end,setActiveFrame=function(dab)aaa=dab end,getFocusedObject=function()return baa end,setFocusedObject=function(dab)baa=dab end,getMonitorFrame=function(dab)return
a_a[dab]or b_a[dab][1]end,setMonitorFrame=function(dab,_bb,abb)if(_aa==_bb)then
_aa=nil end
if(abb)then b_a[dab]={_bb,sides}else a_a[dab]=_bb end;if(_bb==nil)then b_a[dab]=nil end end,getBaseTerm=function()return
ad end,schedule=cba,stop=aba,newFrame=bb,getDirectory=function()return cd end}
local function dca(dab,...)
if(#d_a>0)then local _bb={}
for n=1,#d_a do
if(d_a[n]~=nil)then
if
(coroutine.status(d_a[n][1])=="suspended")then
if(d_a[n][2]~=nil)then
if(d_a[n][2]==dab)then
local abb,bbb=coroutine.resume(d_a[n][1],dab,...)d_a[n][2]=bbb;if not(abb)then bba(bbb)end end else local abb,bbb=coroutine.resume(d_a[n][1],dab,...)
d_a[n][2]=bbb;if not(abb)then bba(bbb)end end else table.insert(_bb,n)end end end
for n=1,#_bb do table.remove(d_a,_bb[n]- (n-1))end end end
local function _da()if(caa==false)then return end;if(_aa~=nil)then _aa:draw()
_aa:updateTerm()end
for dab,_bb in pairs(a_a)do _bb:draw()_bb:updateTerm()end
for dab,_bb in pairs(b_a)do _bb[1]:draw()_bb[1]:updateTerm()end end;local ada,bda,cda=nil,nil,nil;local dda=nil
local function __b(dab,_bb,abb,bbb)ada,bda,cda=_bb,abb,bbb;if(dda==nil)then
dda=os.startTimer(dc/1000)end end
local function a_b()dda=nil;_aa:hoverHandler(bda,cda,ada)aaa=_aa end;local b_b,c_b,d_b=nil,nil,nil;local _ab=nil;local function aab()_ab=nil;_aa:dragHandler(b_b,c_b,d_b)
aaa=_aa end;local function bab(dab,_bb,abb,bbb)b_b,c_b,d_b=_bb,abb,bbb
if(_d<50)then aab()else if(_ab==nil)then _ab=os.startTimer(
_d/1000)end end end
local function cab(dab,...)
local _bb={...}
if(ab:sendEvent("basaltEventCycle",dab,...)==false)then return end;if(dab=="terminate")then daa.stop()end
if(_aa~=nil)then
local abb={mouse_click=_aa.mouseHandler,mouse_up=_aa.mouseUpHandler,mouse_scroll=_aa.scrollHandler,mouse_drag=bab,mouse_move=__b}local bbb=abb[dab]
if(bbb~=nil)then bbb(_aa,...)dca(dab,...)_da()return end end
if(dab=="monitor_touch")then if(a_a[_bb[1]]~=nil)then
a_a[_bb[1]]:mouseHandler(1,_bb[2],_bb[3],true)aaa=a_a[_bb[1]]end
if
(cc(b_a)>0)then for abb,bbb in pairs(b_a)do
bbb[1]:mouseHandler(1,_bb[2],_bb[3],true,_bb[1])end end;dca(dab,...)_da()return end
if(aaa~=nil)then
local abb={char=aaa.charHandler,key=aaa.keyHandler,key_up=aaa.keyUpHandler}local bbb=abb[dab]if(bbb~=nil)then if(dab=="key")then dd[_bb[1]]=true elseif(dab=="key_up")then
dd[_bb[1]]=false end;bbb(aaa,...)dca(dab,...)
_da()return end end
if(dab=="timer")and(_bb[1]==dda)then a_b()elseif
(dab=="timer")and(_bb[1]==_ab)then aab()else
for abb,bbb in pairs(__a)do bbb:eventHandler(dab,...)end end;dca(dab,...)_da()end
daa={logging=false,dynamicValueEvents=false,setTheme=aca,getTheme=bca,drawFrames=_da,getVersion=function()return bd end,setVariable=dba,getVariable=_ca,setBaseTerm=function(dab)ad=dab end,log=function(...)_c(...)end,setMouseMoveThrottle=function(dab)
if
(_HOST:find("CraftOS%-PC"))then if(config.get("mouse_move_throttle")~=10)then
config.set("mouse_move_throttle",10)end
if(dab<100)then dc=100 else dc=dab end;return true end;return false end,setMouseDragThrottle=function(dab)if(
dab<=0)then _d=0 else _ab=nil;_d=dab end end,autoUpdate=function(dab)
caa=dab;if(dab==nil)then caa=true end;local function _bb()_da()while caa do
cab(os.pullEventRaw())end end
local abb,bbb=xpcall(_bb,debug.traceback)if not(abb)then bba(bbb)return end end,update=function(dab,...)if(
dab~=nil)then local _bb,abb=xpcall(cab,debug.traceback,dab,...)if not(_bb)then
bba(abb)return end end end,stop=aba,stopUpdate=aba,isKeyDown=function(dab)if(
dd[dab]==nil)then return false end;return dd[dab]end,getFrame=function(dab)for _bb,abb in
pairs(__a)do if(abb.name==dab)then return abb end end end,getActiveFrame=function()return
aaa end,setActiveFrame=function(dab)
if(dab:getType()=="Frame")then aaa=dab;return true end;return false end,onEvent=function(...)
for dab,_bb in
pairs(table.pack(...))do if(type(_bb)=="function")then
ab:registerEvent("basaltEventCycle",_bb)end end end,schedule=cba,createFrame=function(dab)
dab=dab or ac()
for abb,bbb in pairs(__a)do if(bbb.name==dab)then return nil end end;local _bb=bb(dab,nil,nil,cca)_bb:init()
table.insert(__a,_bb)if
(_aa==nil)and(_bb:getName()~="basaltDebuggingFrame")then _bb:show()end;return _bb end,removeFrame=function(dab)__a[dab]=
nil end,setProjectDir=function(dab)cd=dab end,debug=function(...)local dab={...}if(_aa==nil)then print(...)
return end
if(_aa.name~="basaltDebuggingFrame")then if(_aa~=daa.debugFrame)then
daa.debugLabel:setParent(_aa)end end;local _bb=""
for abb,bbb in pairs(dab)do _bb=_bb..
tostring(bbb).. (#dab~=abb and", "or"")end;daa.debugLabel:setText("[Debug] ".._bb)
for abb,bbb in
pairs(bc(_bb,daa.debugList:getWidth()))do daa.debugList:addItem(bbb)end;if(daa.debugList:getItemCount()>50)then
daa.debugList:removeItem(1)end
daa.debugList:setValue(daa.debugList:getItem(daa.debugList:getItemCount()))if
(daa.debugList.getItemCount()>daa.debugList:getHeight())then
daa.debugList:setOffset(daa.debugList:getItemCount()-
daa.debugList:getHeight())end
daa.debugLabel:show()end}
daa.debugFrame=daa.createFrame("basaltDebuggingFrame"):showBar():setBackground(colors.lightGray):setBar("Debug",colors.black,colors.gray)
daa.debugFrame:addButton("back"):setAnchor("topRight"):setSize(1,1):setText("\22"):onClick(function()if(
daa.oldFrame~=nil)then daa.oldFrame:show()end end):setBackground(colors.red):show()
daa.debugList=daa.debugFrame:addList("debugList"):setSize("parent.w - 2","parent.h - 3"):setPosition(2,3):setScrollable(true):show()
daa.debugLabel=daa.debugFrame:addLabel("debugLabel"):onClick(function()
daa.oldFrame=_aa;daa.debugFrame:show()end):setBackground(colors.black):setForeground(colors.white):setAnchor("bottomLeft"):ignoreOffset():setZIndex(20):show()return daa end
aa["theme"]=function(...)
return
{BasaltBG=colors.lightGray,BasaltText=colors.black,FrameBG=colors.gray,FrameText=colors.black,ButtonBG=colors.gray,ButtonText=colors.black,CheckboxBG=colors.gray,CheckboxText=colors.black,InputBG=colors.gray,InputText=colors.black,TextfieldBG=colors.gray,TextfieldText=colors.black,ListBG=colors.gray,ListText=colors.black,MenubarBG=colors.gray,MenubarText=colors.black,DropdownBG=colors.gray,DropdownText=colors.black,RadioBG=colors.gray,RadioText=colors.black,SelectionBG=colors.black,SelectionText=colors.lightGray,GraphicBG=colors.black,ImageBG=colors.black,PaneBG=colors.black,ProgramBG=colors.black,ProgressbarBG=colors.gray,ProgressbarText=colors.black,ProgressbarActiveBG=colors.black,ScrollbarBG=colors.lightGray,ScrollbarText=colors.gray,ScrollbarSymbolColor=colors.black,SliderBG=false,SliderText=colors.gray,SliderSymbolColor=colors.black,SwitchBG=colors.lightGray,SwitchText=colors.gray,SwitchBGSymbol=colors.black,SwitchInactive=colors.red,SwitchActive=colors.green,LabelBG=false,LabelText=colors.black,GraphBG=colors.gray,GraphText=colors.black}end
aa["Frame"]=function(...)local ab=da("module")local bb=da("Object")
local cb=da("loadObjects")local db=da("basaltDraw")local _c=da("utils")local ac=ab("layout")
local bc=ab("basaltMon")local cc=_c.uuid;local dc=_c.rpairs;local _d=_c.getValueFromXML;local ad=_c.tableCount
local bd,cd,dd=string.sub,math.min,math.max
return
function(__a,a_a,b_a,c_a)local d_a=bb(__a)local _aa="Frame"local aaa={}local baa={}local caa={}local daa={}local _ba={}local aba={}
local bba={}local cba={}local dba=0;local _ca=b_a or term.current()local aca=""local bca=false
local cca=false;local dca=false;local _da=0;local ada=0;local bda=false;local cda=0;local dda=false;local __b=false;local a_b=""local b_b=false
local c_b=false;local d_b;local _ab;local aab=true;local bab=true;local cab=false;local dab={}local _bb={}
d_a:setZIndex(10)local abb=db(_ca)local bbb=false;local cbb=1;local dbb=1;local _cb=colors.white;local acb,bcb=0,0;local ccb={}
local function dcb(dbc,_cc)if(_cc~=
nil)then _cc:setValuesByXMLData(dbc)end end
local function _db(dbc,_cc,acc)
if(dbc~=nil)then if(dbc.properties~=nil)then dbc={dbc}end;for bcc,ccc in pairs(dbc)do local dcc=_cc(acc,
ccc["@id"]or cc())
table.insert(ccb,dcc)dcb(ccc,dcc)end end end
local function adb(dbc)if(type(dbc)~="string")then dbc=dbc.name end;for _cc,acc in pairs(aaa)do
for bcc,ccc in
pairs(acc)do if(ccc:getName()==dbc)then return ccc end end end end
local function bdb(dbc)local _cc=adb(dbc)if(_cc~=nil)then return _cc end
for acc,bcc in pairs(aaa)do
for ccc,dcc in pairs(bcc)do if(
dcc:getType()=="Frame")then local _dc=dcc:getDeepObject(dbc)
if(_dc~=nil)then return _dc end end end end end
local function cdb(dbc)local _cc=dbc:getZIndex()
if(adb(dbc.name)~=nil)then return nil end
if(aaa[_cc]==nil)then
for x=1,#baa+1 do if(baa[x]~=nil)then if(_cc==baa[x])then break end;if
(_cc>baa[x])then table.insert(baa,x,_cc)break end else
table.insert(baa,_cc)end end;if(#baa<=0)then table.insert(baa,_cc)end;aaa[_cc]={}end;dbc.parent=caa;if(dbc.init~=nil)then dbc:init()end
table.insert(aaa[_cc],dbc)return dbc end
local function ddb(dbc,_cc)
for acc,bcc in pairs(daa)do
for ccc,dcc in pairs(bcc)do
for _dc,adc in pairs(dcc)do
if(adc==_cc)then
table.remove(daa[acc][ccc],_dc)if(dbc.parent~=nil)then if(ad(daa[acc])<=0)then
dbc.parent:removeEvent(acc,dbc)end end end end end end end
local function __c(dbc,_cc)
for acc,bcc in pairs(aaa)do
for ccc,dcc in pairs(bcc)do
if(type(_cc)=="string")then
if(dcc:getName()==_cc)then
table.remove(aaa[acc],ccc)ddb(caa,dcc)dbc:updateDraw()return true end else if(dcc==_cc)then table.remove(aaa[acc],ccc)ddb(caa,dcc)
dbc:updateDraw()return true end end end end;return false end;local function a_c(dbc,_cc,acc)
for bcc,ccc in pairs(daa[_cc])do for dcc,_dc in pairs(ccc)do
if(_dc:getName()==acc)then return _dc end end end end
local function b_c(dbc,_cc,acc)
local bcc=acc:getZIndex()if(daa[_cc]==nil)then daa[_cc]={}end;if(_ba[_cc]==nil)then
_ba[_cc]={}end
if(a_c(dbc,_cc,acc.name)~=nil)then return nil end
if(dbc.parent~=nil)then dbc.parent:addEvent(_cc,dbc)end;dab[_cc]=true
if(daa[_cc][bcc]==nil)then
for x=1,#_ba[_cc]+1 do
if
(_ba[_cc][x]~=nil)then if(bcc==_ba[_cc][x])then break end;if(bcc>_ba[_cc][x])then
table.insert(_ba[_cc],x,bcc)break end else
table.insert(_ba[_cc],bcc)end end
if(#_ba[_cc]<=0)then table.insert(_ba[_cc],bcc)end;daa[_cc][bcc]={}end;table.insert(daa[_cc][bcc],acc)return acc end
local function c_c(dbc,_cc,acc)
if(daa[_cc]~=nil)then
for bcc,ccc in pairs(daa[_cc])do
for dcc,_dc in pairs(ccc)do
if(_dc==acc)then
table.remove(daa[_cc][bcc],dcc)if(#daa[_cc][bcc]<=0)then daa[_cc][bcc]=nil
if(dbc.parent~=nil)then if(
ad(daa[_cc])<=0)then dab[_cc]=false
dbc.parent:removeEvent(_cc,dbc)end end end;return
true end end end end;return false end;local d_c=math
local function _ac(dbc)
local _cc,acc=pcall(load("return "..dbc,"",nil,{math=d_c}))if not(_cc)then
error(dbc.." is not a valid dynamic code")end;return acc end
local function aac(dbc,_cc,acc)for bcc,ccc in pairs(cba)do
if(ccc[2]==acc)and(ccc[4]==_cc)then return ccc end end;dba=dba+1
cba[dba]={0,acc,{},_cc,dba}return cba[dba]end
local function bac(dbc,_cc)local acc={}local bcc={}for ccc in _cc:gmatch("%a+%.x")do local dcc=ccc:gsub("%.x","")
if
(dcc~="self")and(dcc~="parent")then table.insert(acc,dcc)end end
for ccc in
_cc:gmatch("%w+%.y")do local dcc=ccc:gsub("%.y","")if(dcc~="self")and(dcc~="parent")then
table.insert(acc,dcc)end end;for ccc in _cc:gmatch("%a+%.w")do local dcc=ccc:gsub("%.w","")
if(dcc~="self")and
(dcc~="parent")then table.insert(acc,dcc)end end
for ccc in
_cc:gmatch("%a+%.h")do local dcc=ccc:gsub("%.h","")if(dcc~="self")and(dcc~="parent")then
table.insert(acc,dcc)end end
for ccc,dcc in pairs(acc)do bcc[dcc]=adb(dcc)if(bcc[dcc]==nil)then
error("Dynamic Values - unable to find object "..dcc)end end;bcc["self"]=dbc;bcc["parent"]=dbc:getParent()return bcc end
local function cac(dbc,_cc)local acc=dbc;for bcc in dbc:gmatch("%w+%.x")do
acc=acc:gsub(bcc,_cc[bcc:gsub("%.x","")]:getX())end;for bcc in dbc:gmatch("%w+%.y")do
acc=acc:gsub(bcc,_cc[bcc:gsub("%.y","")]:getY())end;for bcc in dbc:gmatch("%w+%.w")do
acc=acc:gsub(bcc,_cc[bcc:gsub("%.w","")]:getWidth())end;for bcc in dbc:gmatch("%w+%.h")do
acc=acc:gsub(bcc,_cc[bcc:gsub("%.h","")]:getHeight())end;return acc end
local function dac(dbc)
if(#cba>0)then
for n=1,dba do
if(cba[n]~=nil)then local _cc;if(#cba[n][3]<=0)then
cba[n][3]=bac(cba[n][4],cba[n][2])end
_cc=cac(cba[n][2],cba[n][3])cba[n][1]=_ac(_cc)if(cba[n][4]:getType()=="Frame")then
cba[n][4]:recalculateDynamicValues()end end end
for _cc,acc in pairs(baa)do
if(aaa[acc]~=nil)then
for bcc,ccc in pairs(aaa[acc])do
if
(c_a.getDynamicValueEventSetting())then if(ccc.eventHandler~=nil)then
ccc:eventHandler("basalt_dynamicvalue",dbc)end end;if(ccc.customEventHandler~=nil)then
ccc:customEventHandler("basalt_resize",dbc)end end end end end end;local function _bc(dbc)return cba[dbc][1]end
local function abc(dbc)local _cc=0
for acc,bcc in pairs(aaa)do
for ccc,dcc in pairs(bcc)do
if(
dcc.getHeight~=nil)and(dcc.getY~=nil)then
if
(dcc:getType()=="Dropdown")then local _dc,adc=dcc:getHeight(),dcc:getY()
local bdc,cdc=dcc:getDropdownSize()_dc=_dc+cdc-1
if(_dc+adc-dbc:getHeight()>=_cc)then _cc=dd(
_dc+adc-dbc:getHeight(),0)end else local _dc,adc=dcc:getHeight(),dcc:getY()if(
_dc+adc-dbc:getHeight()>=_cc)then
_cc=dd(_dc+adc-dbc:getHeight(),0)end end end end end;return _cc end
local function bbc(dbc)local _cc=0
for acc,bcc in pairs(aaa)do
for ccc,dcc in pairs(bcc)do
if
(dcc.getWidth~=nil)and(dcc.getX~=nil)then local _dc,adc=dcc:getWidth(),dcc:getX()if(
_dc+adc-dbc:getWidth()>=_cc)then
_cc=dd(_dc+adc-dbc:getWidth(),0)end end end end;return _cc end;local function cbc(dbc)if(bab)then cda=abc(dbc)end end
caa={barActive=false,barBackground=colors.gray,barTextcolor=colors.black,barText="New Frame",barTextAlign="left",addEvent=b_c,removeEvent=c_c,removeEvents=ddb,getEvent=a_c,newDynamicValue=aac,recalculateDynamicValues=dac,getDynamicValue=_bc,getType=function(dbc)return
_aa end,setZIndex=function(dbc,_cc)d_a.setZIndex(dbc,_cc)for acc,bcc in pairs(dab)do if(bcc)then
dbc.parent:addEvent(acc,dbc)end end;return dbc end,setFocusedObject=function(dbc,_cc)
if(
_ab~=_cc)then if(_ab~=nil)then
if(adb(_ab)~=nil)then _ab:loseFocusHandler()end end;if(_cc~=nil)then if(adb(_cc)~=nil)then
_cc:getFocusHandler()end end;_ab=_cc end;return dbc end,getVariable=function(dbc,_cc)return
c_a.getVariable(_cc)end,setSize=function(dbc,_cc,acc,bcc)
d_a.setSize(dbc,_cc,acc,bcc)if(dbc.parent==nil)then abb=db(_ca)end
for ccc,dcc in pairs(baa)do if(aaa[dcc]~=nil)then
for _dc,adc in
pairs(aaa[dcc])do if(adc.customEventHandler~=nil)then
adc:customEventHandler("basalt_resize",dbc)end end end end;dbc:recalculateDynamicValues()aab=false;return dbc end,setTheme=function(dbc,_cc,acc)
if(
type(_cc)=="table")then bba=_cc elseif(type(_cc)=="string")then bba[_cc]=acc end;dbc:updateDraw()return dbc end,getTheme=function(dbc,_cc)
return
bba[_cc]or(dbc.parent~=nil and dbc.parent:getTheme(_cc)or
c_a.getTheme(_cc))end,getThemeColor=function(dbc,_cc)return
_cc~=nil and _bb[_cc]or _bb end,setThemeColor=function(dbc,_cc,...)
if
(dbc.parent==nil)then
if(dbc==c_a.getActiveFrame())then
if(type(_cc)=="string")then _bb[_cc]=...
_ca.setPaletteColor(
type(_cc)=="number"and _cc or colors[_cc],...)elseif(type(_cc)=="table")then
for acc,bcc in pairs(_cc)do _bb[acc]=bcc
if(type(bcc)=="number")then
_ca.setPaletteColor(
type(acc)=="number"and acc or colors[acc],bcc)else local ccc,dcc,_dc=table.unpack(bcc)
_ca.setPaletteColor(
type(acc)=="number"and acc or colors[acc],ccc,dcc,_dc)end end end end end;return dbc end,setPosition=function(dbc,_cc,acc,bcc)
d_a.setPosition(dbc,_cc,acc,bcc)dbc:recalculateDynamicValues()return dbc end,getBasaltInstance=function(dbc)return
c_a end,setOffset=function(dbc,_cc,acc)
acb=_cc~=nil and
d_c.floor(_cc<0 and d_c.abs(_cc)or-_cc)or acb
bcb=acc~=nil and
d_c.floor(acc<0 and d_c.abs(acc)or-acc)or bcb;dbc:updateDraw()return dbc end,getOffsetInternal=function(dbc)return
acb,bcb end,getOffset=function(dbc)return acb<0 and d_c.abs(acb)or-acb,bcb<0 and
d_c.abs(bcb)or-bcb end,removeFocusedObject=function(dbc)if(
_ab~=nil)then
if(adb(_ab)~=nil)then _ab:loseFocusHandler()end end;_ab=nil;return dbc end,getFocusedObject=function(dbc)return
_ab end,setCursor=function(dbc,_cc,acc,bcc,ccc)
if(dbc.parent~=nil)then
local dcc,_dc=dbc:getAnchorPosition()
dbc.parent:setCursor(_cc or false,(acc or 0)+dcc-1,(bcc or 0)+_dc-1,
ccc or _cb)else
local dcc,_dc=dbc:getAbsolutePosition(dbc:getAnchorPosition(dbc:getX(),dbc:getY(),true))bbb=_cc or false;if(acc~=nil)then cbb=dcc+acc-1 end;if(bcc~=nil)then dbb=_dc+
bcc-1 end;_cb=ccc or _cb;if(bbb)then
_ca.setTextColor(_cb)_ca.setCursorPos(cbb,dbb)_ca.setCursorBlink(bbb)else
_ca.setCursorBlink(false)end end;return dbc end,setMovable=function(dbc,_cc)
if(
dbc.parent~=nil)then b_b=_cc or not b_b
dbc.parent:addEvent("mouse_click",dbc)dab["mouse_click"]=true
dbc.parent:addEvent("mouse_up",dbc)dab["mouse_up"]=true
dbc.parent:addEvent("mouse_drag",dbc)dab["mouse_drag"]=true end;return dbc end,setScrollable=function(dbc,_cc)bda=(
_cc or _cc==nil)and true or false
if(
dbc.parent~=nil)then dbc.parent:addEvent("mouse_scroll",dbc)end;dab["mouse_scroll"]=true;return dbc end,setScrollAmount=function(dbc,_cc)cda=
_cc or cda;bab=false;return dbc end,getScrollAmount=function(dbc)return bab and cbc(dbc)or
cda end,getCalculatedVerticalScroll=abc,getCalculatedHorizontalScroll=bbc,show=function(dbc)d_a.show(dbc)
if(
dbc.parent==nil)then c_a.setActiveFrame(dbc)
for _cc,acc in pairs(colors)do if
(type(acc)=="number")then
_ca.setPaletteColor(acc,colors.packRGB(term.nativePaletteColor((acc))))end end
for _cc,acc in pairs(_bb)do
if(type(acc)=="number")then
_ca.setPaletteColor(
type(_cc)=="number"and _cc or colors[_cc],acc)else local bcc,ccc,dcc=table.unpack(acc)
_ca.setPaletteColor(
type(_cc)=="number"and _cc or colors[_cc],bcc,ccc,dcc)end end
if(bca)and not(cca)then c_a.setMonitorFrame(aca,dbc)elseif(cca)then
c_a.setMonitorFrame(dbc:getName(),dbc,aca)else c_a.setMainFrame(dbc)end end;return dbc end,hide=function(dbc)
d_a.hide(dbc)
if(dbc.parent==nil)then if(activeFrame==dbc)then activeFrame=nil end
if(bca)and
not(cca)then if(c_a.getMonitorFrame(aca)==dbc)then
c_a.setActiveFrame(nil)end elseif(cca)then
if(
c_a.getMonitorFrame(dbc:getName())==dbc)then c_a.setActiveFrame(nil)end else
if(c_a.getMainFrame()==dbc)then c_a.setMainFrame(nil)end end end;return dbc end,addLayout=function(dbc,_cc)
if(
_cc~=nil)then
if(fs.exists(_cc))then local acc=fs.open(_cc,"r")
local bcc=ac:ParseXmlText(acc.readAll())acc.close()ccb={}dbc:setValuesByXMLData(bcc)end end;return dbc end,getLastLayout=function(dbc)return
ccb end,addLayoutFromString=function(dbc,_cc)if(_cc~=nil)then local acc=ac:ParseXmlText(_cc)
dbc:setValuesByXMLData(acc)end;return dbc end,setValuesByXMLData=function(dbc,_cc)
d_a.setValuesByXMLData(dbc,_cc)if(_d("movable",_cc)~=nil)then if(_d("movable",_cc))then
dbc:setMovable(true)end end;if(
_d("scrollable",_cc)~=nil)then
if(_d("scrollable",_cc))then dbc:setScrollable(true)end end;if
(_d("monitor",_cc)~=nil)then
dbc:setMonitor(_d("monitor",_cc)):show()end;if(_d("mirror",_cc)~=nil)then
dbc:setMirror(_d("mirror",_cc))end
if(_d("bar",_cc)~=nil)then if(_d("bar",_cc))then
dbc:showBar(true)else dbc:showBar(false)end end
if(_d("barText",_cc)~=nil)then dbc.barText=_d("barText",_cc)end;if(_d("barBG",_cc)~=nil)then
dbc.barBackground=colors[_d("barBG",_cc)]end;if(_d("barFG",_cc)~=nil)then
dbc.barTextcolor=colors[_d("barFG",_cc)]end;if(_d("barAlign",_cc)~=nil)then
dbc.barTextAlign=_d("barAlign",_cc)end;if(_d("layout",_cc)~=nil)then
dbc:addLayout(_d("layout",_cc))end;if(_d("xOffset",_cc)~=nil)then
dbc:setOffset(_d("xOffset",_cc),bcb)end;if(_d("yOffset",_cc)~=nil)then
dbc:setOffset(bcb,_d("yOffset",_cc))end;if(_d("scrollAmount",_cc)~=nil)then
dbc:setScrollAmount(_d("scrollAmount",_cc))end;local acc=_cc:children()
for bcc,ccc in
pairs(acc)do if(ccc.___name~="animation")then
local dcc=ccc.___name:gsub("^%l",string.upper)
if(cb[dcc]~=nil)then _db(ccc,dbc["add"..dcc],dbc)end end end;_db(_cc["frame"],dbc.addFrame,dbc)
_db(_cc["animation"],dbc.addAnimation,dbc)return dbc end,showBar=function(dbc,_cc)dbc.barActive=
_cc or not dbc.barActive;dbc:updateDraw()
return dbc end,setBar=function(dbc,_cc,acc,bcc)dbc.barText=_cc or""dbc.barBackground=
acc or dbc.barBackground
dbc.barTextcolor=bcc or dbc.barTextcolor;dbc:updateDraw()return dbc end,setBarTextAlign=function(dbc,_cc)dbc.barTextAlign=
_cc or"left"dbc:updateDraw()return dbc end,setMirror=function(dbc,_cc)if(
dbc.parent~=nil)then
error("Frame has to be a base frame in order to attach a mirror.")end;a_b=_cc;if(mirror~=nil)then
abb.setMirror(mirror)end;dda=true;return dbc end,removeMirror=function(dbc)mirror=
nil;dda=false;abb.setMirror(nil)return dbc end,setMonitorScale=function(dbc,_cc)if
(bca)then _ca.setTextScale(_cc)end;return dbc end,setMonitor=function(dbc,_cc,acc)
if(
_cc~=nil)and(_cc~=false)then
if(type(_cc)=="string")then
if(
peripheral.getType(_cc)=="monitor")then _ca=peripheral.wrap(_cc)dca=true end
if(dbc.parent~=nil)then dbc.parent:removeObject(dbc)end;bca=true;c_a.setMonitorFrame(_cc,dbc)elseif(type(_cc)=="table")then
_ca=bc(_cc)dca=true;bca=true;cca=true
c_a.setMonitorFrame(dbc:getName(),dbc,true)end else _ca=parentTerminal;bca=false;cca=false
if(type(aca)=="string")then
if(
c_a.getMonitorFrame(aca)==dbc)then c_a.setMonitorFrame(aca,nil)end else
if(c_a.getMonitorFrame(dbc:getName())==dbc)then c_a.setMonitorFrame(dbc:getName(),
nil)end end end;if(acc~=nil)then _ca.setTextScale(acc)end;abb=db(_ca)
dbc:setSize(_ca.getSize())aab=true;aca=_cc or nil;dbc:updateDraw()return dbc end,loseFocusHandler=function(dbc)
d_a.loseFocusHandler(dbc)if(_ab~=nil)then _ab:loseFocusHandler()_ab=nil end end,getFocusHandler=function(dbc)
d_a.getFocusHandler(dbc)
if(dbc.parent~=nil)then
if(b_b)then dbc.parent:removeEvents(dbc)
dbc.parent:removeObject(dbc)dbc.parent:addObject(dbc)for _cc,acc in pairs(dab)do if(acc)then
dbc.parent:addEvent(_cc,dbc)end end
dbc:updateDraw()end end;if(_ab~=nil)then _ab:getFocusHandler()end end,eventHandler=function(dbc,_cc,...)
d_a.eventHandler(dbc,_cc,...)
if(daa["other_event"]~=nil)then
for acc,bcc in ipairs(_ba["other_event"])do if(
daa["other_event"][bcc]~=nil)then
for ccc,dcc in dc(daa["other_event"][bcc])do if
(dcc.eventHandler~=nil)then dcc:eventHandler(_cc,...)end end end end end
if(aab)and not(bca)then if(dbc.parent==nil)then
if(_cc=="term_resize")then
dbc:sendEvent("basalt_resize",dbc,_cc,...)dbc:setSize(_ca.getSize())aab=true end end end
if(bca)then
if(aab)then
if(_cc=="monitor_resize")then
if(type(aca)=="string")then
dbc:setSize(_ca.getSize())elseif(type(aca)=="table")then
for acc,bcc in pairs(aca)do for ccc,dcc in pairs(bcc)do if(p1 ==dcc)then
dbc:setSize(_ca.getSize())end end end end;aab=true;dbc:updateDraw()end end
if(_cc=="peripheral")and(p1 ==aca)then if
(peripheral.getType(aca)=="monitor")then dca=true;_ca=peripheral.wrap(aca)abb=db(_ca)
dbc:updateDraw()end end
if(_cc=="peripheral_detach")and(p1 ==aca)then dca=false end end
if(dda)then if(peripheral.getType(a_b)=="monitor")then __b=true
abb.setMirror(peripheral.wrap(a_b))end;if(_cc=="peripheral_detach")and
(p1 ==a_b)then dca=false end
if
(_cc=="monitor_touch")and(a_b==p1)then dbc:mouseHandler(1,p2,p3,true)end end end,mouseHandler=function(dbc,_cc,acc,bcc,ccc,dcc)
if
(cca)then if(_ca.calculateClick~=nil)then
acc,bcc=_ca.calculateClick(dcc,acc,bcc)end end
if(d_a.mouseHandler(dbc,_cc,acc,bcc))then
if(daa["mouse_click"]~=nil)then
dbc:setCursor(false)
for _dc,adc in ipairs(_ba["mouse_click"])do
if
(daa["mouse_click"][adc]~=nil)then for bdc,cdc in dc(daa["mouse_click"][adc])do
if(cdc.mouseHandler~=nil)then if
(cdc:mouseHandler(_cc,acc,bcc))then return true end end end end end end
if(b_b)then
local _dc,adc=dbc:getAbsolutePosition(dbc:getAnchorPosition())if
(acc>=_dc)and(acc<=_dc+dbc:getWidth()-1)and(bcc==adc)then c_b=true;_da=_dc-acc
ada=yOff and 1 or 0 end end;dbc:removeFocusedObject()return true end;return false end,mouseUpHandler=function(dbc,_cc,acc,bcc)if
(c_b)then c_b=false end
if(d_a.mouseUpHandler(dbc,_cc,acc,bcc))then
if
(daa["mouse_up"]~=nil)then
for ccc,dcc in ipairs(_ba["mouse_up"])do
if(daa["mouse_up"][dcc]~=nil)then
for _dc,adc in
dc(daa["mouse_up"][dcc])do if(adc.mouseUpHandler~=nil)then
if(adc:mouseUpHandler(_cc,acc,bcc))then return true end end end end end end;return true end;return false end,scrollHandler=function(dbc,_cc,acc,bcc)
if
(d_a.scrollHandler(dbc,_cc,acc,bcc))then
if(daa["mouse_scroll"]~=nil)then
for dcc,_dc in pairs(_ba["mouse_scroll"])do
if(
daa["mouse_scroll"][_dc]~=nil)then
for adc,bdc in dc(daa["mouse_scroll"][_dc])do if(bdc.scrollHandler~=
nil)then
if(bdc:scrollHandler(_cc,acc,bcc))then return true end end end end end end;local ccc=bcb
if(bda)then cbc(dbc)if(_cc>0)or(_cc<0)then
bcb=dd(cd(bcb-_cc,0),-cda)dbc:updateDraw()end end;if(bcb==ccc)then return false end;dbc:removeFocusedObject()
return true end;return false end,hoverHandler=function(dbc,_cc,acc,bcc)
if
(d_a.hoverHandler(dbc,_cc,acc,bcc))then
if(daa["mouse_move"]~=nil)then
for ccc,dcc in pairs(_ba["mouse_move"])do
if(
daa["mouse_move"][dcc]~=nil)then for _dc,adc in dc(daa["mouse_move"][dcc])do
if
(adc.hoverHandler~=nil)then if(adc:hoverHandler(_cc,acc,bcc))then return true end end end end end end end;return false end,dragHandler=function(dbc,_cc,acc,bcc)
if
(c_b)then local ccc,dcc=dbc.parent:getOffsetInternal()ccc=ccc<0 and
d_c.abs(ccc)or-ccc;dcc=dcc<0 and d_c.abs(dcc)or-
dcc;local _dc=1;local adc=1;if(dbc.parent~=nil)then
_dc,adc=dbc.parent:getAbsolutePosition(dbc.parent:getAnchorPosition())end
dbc:setPosition(
acc+_da- (_dc-1)+ccc,bcc+ada- (adc-1)+dcc)dbc:updateDraw()return true end
if(dbc:isVisible())and(dbc:isEnabled())then
if
(daa["mouse_drag"]~=nil)then
for ccc,dcc in ipairs(_ba["mouse_drag"])do
if
(daa["mouse_drag"][dcc]~=nil)then for _dc,adc in dc(daa["mouse_drag"][dcc])do
if(adc.dragHandler~=nil)then if
(adc:dragHandler(_cc,acc,bcc))then return true end end end end end end end;d_a.dragHandler(dbc,_cc,acc,bcc)return false end,keyHandler=function(dbc,_cc,acc)
if
(dbc:isFocused())or(dbc.parent==nil)then
local bcc=dbc:getEventSystem():sendEvent("key",dbc,"key",_cc)if(bcc==false)then return false end
if(daa["key"]~=nil)then
for ccc,dcc in pairs(_ba["key"])do
if(
daa["key"][dcc]~=nil)then
for _dc,adc in dc(daa["key"][dcc])do if(adc.keyHandler~=nil)then if
(adc:keyHandler(_cc,acc))then return true end end end end end end end;return false end,keyUpHandler=function(dbc,_cc)
if
(dbc:isFocused())or(dbc.parent==nil)then
local acc=dbc:getEventSystem():sendEvent("key_up",dbc,"key_up",_cc)if(acc==false)then return false end
if(daa["key_up"]~=nil)then
for bcc,ccc in
pairs(_ba["key_up"])do
if(daa["key_up"][ccc]~=nil)then for dcc,_dc in dc(daa["key_up"][ccc])do
if(
_dc.keyUpHandler~=nil)then if(_dc:keyUpHandler(_cc))then return true end end end end end end end;return false end,charHandler=function(dbc,_cc)
if
(dbc:isFocused())or(dbc.parent==nil)then
local acc=dbc:getEventSystem():sendEvent("char",dbc,"char",_cc)if(acc==false)then return false end
if(daa["char"]~=nil)then
for bcc,ccc in
pairs(_ba["char"])do
if(daa["char"][ccc]~=nil)then for dcc,_dc in dc(daa["char"][ccc])do
if
(_dc.charHandler~=nil)then if(_dc:charHandler(_cc))then return true end end end end end end end;return false end,setText=function(dbc,_cc,acc,bcc)
local ccc,dcc=dbc:getAnchorPosition()
if(acc>=1)and(acc<=dbc:getHeight())then
if(dbc.parent~=nil)then
dbc.parent:setText(dd(
_cc+ (ccc-1),ccc),dcc+acc-1,bd(bcc,dd(1 -_cc+1,1),dd(
dbc:getWidth()-_cc+1,1)))else
abb.setText(dd(_cc+ (ccc-1),ccc),dcc+acc-1,bd(bcc,dd(1 -_cc+1,1),dd(
dbc:getWidth()-_cc+1,1)))end end end,setBG=function(dbc,_cc,acc,bcc)
local ccc,dcc=dbc:getAnchorPosition()
if(acc>=1)and(acc<=dbc:getHeight())then
if(dbc.parent~=nil)then
dbc.parent:setBG(dd(
_cc+ (ccc-1),ccc),dcc+acc-1,bd(bcc,dd(1 -_cc+1,1),dd(
dbc:getWidth()-_cc+1,1)))else
abb.setBG(dd(_cc+ (ccc-1),ccc),dcc+acc-1,bd(bcc,dd(1 -_cc+1,1),dd(
dbc:getWidth()-_cc+1,1)))end end end,setFG=function(dbc,_cc,acc,bcc)
local ccc,dcc=dbc:getAnchorPosition()
if(acc>=1)and(acc<=dbc:getHeight())then
if(dbc.parent~=nil)then
dbc.parent:setFG(dd(
_cc+ (ccc-1),ccc),dcc+acc-1,bd(bcc,dd(1 -_cc+1,1),dd(
dbc:getWidth()-_cc+1,1)))else
abb.setFG(dd(_cc+ (ccc-1),ccc),dcc+acc-1,bd(bcc,dd(1 -_cc+1,1),dd(
dbc:getWidth()-_cc+1,1)))end end end,writeText=function(dbc,_cc,acc,bcc,ccc,dcc)
local _dc,adc=dbc:getAnchorPosition()
if(acc>=1)and(acc<=dbc:getHeight())then
if(dbc.parent~=nil)then
dbc.parent:writeText(dd(
_cc+ (_dc-1),_dc),adc+acc-1,bd(bcc,dd(1 -_cc+1,1),
dbc:getWidth()-_cc+1),ccc,dcc)else
abb.writeText(dd(_cc+ (_dc-1),_dc),adc+acc-1,bd(bcc,dd(1 -_cc+1,1),dd(
dbc:getWidth()-_cc+1,1)),ccc,dcc)end end end,blit=function(dbc,_cc,acc,bcc,ccc,dcc)
local _dc,adc=dbc:getAnchorPosition()
if(acc>=1)and(acc<=dbc:getHeight())then
local bdc=dbc:getWidth()
if(dbc.parent~=nil)then
bcc=bd(bcc,dd(1 -_cc+1,1),bdc-_cc+1)ccc=bd(ccc,dd(1 -_cc+1,1),bdc-_cc+1)dcc=bd(dcc,dd(
1 -_cc+1,1),bdc-_cc+1)
dbc.parent:blit(dd(
_cc+ (_dc-1),_dc),adc+acc-1,bcc,ccc,dcc)else
bcc=bd(bcc,dd(1 -_cc+1,1),dd(bdc-_cc+1,1))
ccc=bd(ccc,dd(1 -_cc+1,1),dd(bdc-_cc+1,1))
dcc=bd(dcc,dd(1 -_cc+1,1),dd(bdc-_cc+1,1))
abb.blit(dd(_cc+ (_dc-1),_dc),adc+acc-1,bcc,ccc,dcc)end end end,drawBackgroundBox=function(dbc,_cc,acc,bcc,ccc,dcc)
local _dc,adc=dbc:getAnchorPosition()
ccc=(acc<1 and(
ccc+acc>dbc:getHeight()and dbc:getHeight()or ccc+acc-1)or(
ccc+
acc>dbc:getHeight()and dbc:getHeight()-acc+1 or ccc))
bcc=(_cc<1 and(bcc+_cc>dbc:getWidth()and dbc:getWidth()or bcc+
_cc-1)or(

bcc+_cc>dbc:getWidth()and dbc:getWidth()-_cc+1 or bcc))
if(dbc.parent~=nil)then
dbc.parent:drawBackgroundBox(dd(_cc+ (_dc-1),_dc),dd(acc+ (adc-1),adc),bcc,ccc,dcc)else
abb.drawBackgroundBox(dd(_cc+ (_dc-1),_dc),dd(acc+ (adc-1),adc),bcc,ccc,dcc)end end,drawTextBox=function(dbc,_cc,acc,bcc,ccc,dcc)
local _dc,adc=dbc:getAnchorPosition()
ccc=(acc<1 and(
ccc+acc>dbc:getHeight()and dbc:getHeight()or ccc+acc-1)or(
ccc+
acc>dbc:getHeight()and dbc:getHeight()-acc+1 or ccc))
bcc=(_cc<1 and(bcc+_cc>dbc:getWidth()and dbc:getWidth()or bcc+
_cc-1)or(

bcc+_cc>dbc:getWidth()and dbc:getWidth()-_cc+1 or bcc))
if(dbc.parent~=nil)then
dbc.parent:drawTextBox(dd(_cc+ (_dc-1),_dc),dd(acc+ (adc-1),adc),bcc,ccc,bd(dcc,1,1))else
abb.drawTextBox(dd(_cc+ (_dc-1),_dc),dd(acc+ (adc-1),adc),bcc,ccc,bd(dcc,1,1))end end,drawForegroundBox=function(dbc,_cc,acc,bcc,ccc,dcc)
local _dc,adc=dbc:getAnchorPosition()
ccc=(acc<1 and(
ccc+acc>dbc:getHeight()and dbc:getHeight()or ccc+acc-1)or(
ccc+
acc>dbc:getHeight()and dbc:getHeight()-acc+1 or ccc))
bcc=(_cc<1 and(bcc+_cc>dbc:getWidth()and dbc:getWidth()or bcc+
_cc-1)or(

bcc+_cc>dbc:getWidth()and dbc:getWidth()-_cc+1 or bcc))
if(dbc.parent~=nil)then
dbc.parent:drawForegroundBox(dd(_cc+ (_dc-1),_dc),dd(acc+ (adc-1),adc),bcc,ccc,dcc)else
abb.drawForegroundBox(dd(_cc+ (_dc-1),_dc),dd(acc+ (adc-1),adc),bcc,ccc,dcc)end end,draw=function(dbc,_cc)if
(bca)and not(dca)then return false end
if(dbc.parent==nil)then if(dbc:getDraw()==
false)then return false end end
if(d_a.draw(dbc))then
local acc,bcc=dbc:getAbsolutePosition(dbc:getAnchorPosition())local ccc,dcc=dbc:getAnchorPosition()local _dc,adc=dbc:getSize()
if(
dbc.parent==nil)then
if(dbc.bgColor~=false)then
abb.drawBackgroundBox(ccc,dcc,_dc,adc,dbc.bgColor)abb.drawTextBox(ccc,dcc,_dc,adc," ")end;if(dbc.fgColor~=false)then
abb.drawForegroundBox(ccc,dcc,_dc,adc,dbc.fgColor)end end
if(dbc.barActive)then
if(dbc.parent~=nil)then
dbc.parent:writeText(ccc,dcc,_c.getTextHorizontalAlign(dbc.barText,_dc,dbc.barTextAlign),dbc.barBackground,dbc.barTextcolor)else
abb.writeText(ccc,dcc,_c.getTextHorizontalAlign(dbc.barText,_dc,dbc.barTextAlign),dbc.barBackground,dbc.barTextcolor)end
if(dbc:getBorder("left"))then
if(dbc.parent~=nil)then
dbc.parent:drawBackgroundBox(ccc-1,dcc,1,1,dbc.barBackground)if(dbc.bgColor~=false)then
dbc.parent:drawBackgroundBox(ccc-1,dcc+1,1,adc-1,dbc.bgColor)end end end
if(dbc:getBorder("top"))then if(dbc.parent~=nil)then
dbc.parent:drawBackgroundBox(ccc-1,dcc-1,_dc+1,1,dbc.barBackground)end end end;for bdc,cdc in dc(baa)do
if(aaa[cdc]~=nil)then for ddc,__d in pairs(aaa[cdc])do
if(__d.draw~=nil)then __d:draw()end end end end end end,updateTerm=function(dbc)if
(bca)and not(dca)then return false end;abb.update()end,addObject=function(dbc,_cc)return
cdb(_cc)end,removeObject=__c,getObject=function(dbc,_cc)return adb(_cc)end,getDeepObject=function(dbc,_cc)return bdb(_cc)end,addFrame=function(dbc,_cc)local acc=c_a.newFrame(
_cc or cc(),dbc,nil,c_a)return cdb(acc)end,init=function(dbc)
if
not(cab)then
if(a_a~=nil)then d_a.width,d_a.height=a_a:getSize()
dbc:setBackground(a_a:getTheme("FrameBG"))
dbc:setForeground(a_a:getTheme("FrameText"))else d_a.width,d_a.height=_ca.getSize()
dbc:setBackground(c_a.getTheme("BasaltBG"))
dbc:setForeground(c_a.getTheme("BasaltText"))end;cab=true end end}
for dbc,_cc in pairs(cb)do caa["add"..dbc]=function(acc,bcc)
return cdb(_cc(bcc or cc(),acc))end end;setmetatable(caa,d_a)return caa end end
aa["Object"]=function(...)local ab=da("basaltEvent")local bb=da("utils")
local cb=da("module")local db=cb("images")local _c=bb.splitString;local ac=bb.numberFromString
local bc=bb.getValueFromXML;local cc,dc=table.unpack,string.sub
return
function(_d)local ad="Object"local bd={}local cd=1;local dd
local __a="topLeft"local a_a=false;local b_a=true;local c_a=false;local d_a=false;local _aa=false;local aaa=false
local baa={left=false,right=false,top=false,bottom=false}local caa=colors.black;local daa=true;local _ba=false;local aba,bba,cba,dba=0,0,0,0;local _ca;local aca;local bca=1;local cca
local dca;local _da=true;local ada=true;local bda={}local cda=ab()
bd={x=1,y=1,width=1,height=1,bgColor=colors.black,bgSymbol=" ",bgSymbolColor=colors.black,fgColor=colors.white,transparentColor=false,name=_d or"Object",parent=
nil,show=function(dda)b_a=true;dda:updateDraw()return dda end,hide=function(dda)b_a=false
dda:updateDraw()return dda end,enable=function(dda)daa=true;return dda end,disable=function(dda)daa=false
return dda end,isEnabled=function(dda)return daa end,generateXMLEventFunction=function(dda,__b,a_b)
local b_b=function(c_b)
if(c_b:sub(1,1)=="#")then
local d_b=dda:getBaseFrame():getDeepObject(c_b:sub(2,c_b:len()))
if(d_b~=nil)and(d_b.internalObjetCall~=nil)then __b(dda,function()
d_b:internalObjetCall()end)end else
__b(dda,dda:getBaseFrame():getVariable(c_b))end end;if(type(a_b)=="string")then b_b(a_b)elseif(type(a_b)=="table")then
for c_b,d_b in pairs(a_b)do b_b(d_b)end end;return dda end,setValuesByXMLData=function(dda,__b)
local a_b=dda:getBaseFrame()local b_b,c_b,d_b
if(bc("texture",__b)~=nil)then b_b=bc("texture",__b)end;if(bc("mode",__b)~=nil)then c_b=bc("mode",__b)end
if(
bc("texturePlay",__b)~=nil)then d_b=bc("texturePlay",__b)end;local _ab,aab;if(bc("x",__b)~=nil)then _ab=bc("x",__b)end;if(
bc("y",__b)~=nil)then aab=bc("y",__b)end;if
(_ab~=nil)or(aab~=nil)then dda:setPosition(_ab,aab)end;local bab,cab;if(
bc("width",__b)~=nil)then bab=bc("width",__b)end;if(
bc("height",__b)~=nil)then cab=bc("height",__b)end;if(bab~=nil)or(
cab~=nil)then dda:setSize(bab,cab)end;if(
bc("bg",__b)~=nil)then
dda:setBackground(colors[bc("bg",__b)])end;if(bc("bgSymbol",__b)~=nil)then
dda:setBackground(dda.bgColor,bc("bgSymbol",__b))end;if
(bc("bgSymbolColor",__b)~=nil)then
dda:setBackground(dda.bgColor,dda.bgSymbol,colors[bc("bgSymbolColor",__b)])end
if
(bc("fg",__b)~=nil)then dda:setForeground(colors[bc("fg",__b)])end;if(bc("value",__b)~=nil)then
dda:setValue(colors[bc("value",__b)])end
if(bc("visible",__b)~=nil)then if
(bc("visible",__b))then dda:show()else dda:hide()end end
if(bc("enabled",__b)~=nil)then if(bc("enabled",__b))then dda:enable()else
dda:disable()end end;if(bc("zIndex",__b)~=nil)then
dda:setZIndex(bc("zIndex",__b))end;if(bc("anchor",__b)~=nil)then
dda:setAnchor(bc("anchor",__b))end;if(bc("shadowColor",__b)~=nil)then
dda:setShadow(colors[bc("shadowColor",__b)])end;if(bc("border",__b)~=nil)then
dda:setBorder(colors[bc("border",__b)])end;if(bc("borderLeft",__b)~=nil)then
baa["left"]=bc("borderLeft",__b)end;if(bc("borderTop",__b)~=nil)then
baa["top"]=bc("borderTop",__b)end;if(bc("borderRight",__b)~=nil)then
baa["right"]=bc("borderRight",__b)end;if(bc("borderBottom",__b)~=nil)then
baa["bottom"]=bc("borderBottom",__b)end;if(bc("borderColor",__b)~=nil)then
dda:setBorder(colors[bc("borderColor",__b)])end;if
(bc("ignoreOffset",__b)~=nil)then
if(bc("ignoreOffset",__b))then dda:ignoreOffset(true)end end;if
(bc("onClick",__b)~=nil)then
dda:generateXMLEventFunction(dda.onClick,bc("onClick",__b))end;if
(bc("onClickUp",__b)~=nil)then
dda:generateXMLEventFunction(dda.onClickUp,bc("onClickUp",__b))end;if
(bc("onScroll",__b)~=nil)then
dda:generateXMLEventFunction(dda.onScroll,bc("onScroll",__b))end;if
(bc("onDrag",__b)~=nil)then
dda:generateXMLEventFunction(dda.onDrag,bc("onDrag",__b))end;if(bc("onHover",__b)~=nil)then
dda:generateXMLEventFunction(dda.onHover,bc("onHover",__b))end;if
(bc("onLeave",__b)~=nil)then
dda:generateXMLEventFunction(dda.onLeave,bc("onLeave",__b))end;if(bc("onKey",__b)~=nil)then
dda:generateXMLEventFunction(dda.onKey,bc("onKey",__b))end;if(bc("onKeyUp",__b)~=nil)then
dda:generateXMLEventFunction(dda.onKeyUp,bc("onKeyUp",__b))end;if
(bc("onChange",__b)~=nil)then
dda:generateXMLEventFunction(dda.onChange,bc("onChange",__b))end;if
(bc("onResize",__b)~=nil)then
dda:generateXMLEventFunction(dda.onResize,bc("onResize",__b))end;if
(bc("onReposition",__b)~=nil)then
dda:generateXMLEventFunction(dda.onReposition,bc("onReposition",__b))end;if
(bc("onEvent",__b)~=nil)then
dda:generateXMLEventFunction(dda.onEvent,bc("onEvent",__b))end;if
(bc("onGetFocus",__b)~=nil)then
dda:generateXMLEventFunction(dda.onGetFocus,bc("onGetFocus",__b))end;if
(bc("onLoseFocus",__b)~=nil)then
dda:generateXMLEventFunction(dda.onLoseFocus,bc("onLoseFocus",__b))end;if(b_b~=nil)then
dda:setTexture(b_b,c_b,d_b)end;dda:updateDraw()return dda end,isVisible=function(dda)return
b_a end,setFocus=function(dda)if(dda.parent~=nil)then
dda.parent:setFocusedObject(dda)end;return dda end,setZIndex=function(dda,__b)
cd=__b
if(dda.parent~=nil)then dda.parent:removeObject(dda)
dda.parent:addObject(dda)dda:updateEventHandlers()end;return dda end,updateEventHandlers=function(dda)
for __b,a_b in
pairs(bda)do if(a_b)then dda.parent:addEvent(__b,dda)end end end,getZIndex=function(dda)return cd end,getType=function(dda)return ad end,getName=function(dda)return
dda.name end,remove=function(dda)if(dda.parent~=nil)then
dda.parent:removeObject(dda)end;dda:updateDraw()return dda end,setParent=function(dda,__b)
if(
__b.getType~=nil and __b:getType()=="Frame")then
dda:remove()__b:addObject(dda)if(dda.draw)then dda:show()end end;return dda end,setValue=function(dda,__b,a_b)if(
dd~=__b)then dd=__b;dda:updateDraw()if(a_b~=false)then
dda:valueChangedHandler()end end
return dda end,getValue=function(dda)return dd end,getDraw=function(dda)return
ada end,updateDraw=function(dda,__b)ada=__b;if(__b==nil)then ada=true end;if(ada)then if(dda.parent~=nil)then
dda.parent:updateDraw()end end;return dda end,getEventSystem=function(dda)return
cda end,getParent=function(dda)return dda.parent end,setPosition=function(dda,__b,a_b,b_b)
if(type(__b)=="number")then dda.x=
b_b and dda:getX()+__b or __b end;if(type(a_b)=="number")then
dda.y=b_b and dda:getY()+a_b or a_b end
if(dda.parent~=nil)then if(type(__b)=="string")then
dda.x=dda.parent:newDynamicValue(dda,__b)end;if(type(a_b)=="string")then
dda.y=dda.parent:newDynamicValue(dda,a_b)end
dda.parent:recalculateDynamicValues()end;dda:customEventHandler("basalt_reposition")
dda:updateDraw()return dda end,getX=function(dda)return

type(dda.x)=="number"and dda.x or math.floor(dda.x[1]+0.5)end,getY=function(dda)return

type(dda.y)=="number"and dda.y or math.floor(dda.y[1]+0.5)end,getPosition=function(dda)return
dda:getX(),dda:getY()end,getVisibility=function(dda)return b_a end,setVisibility=function(dda,__b)
b_a=__b or not b_a;dda:updateDraw()return dda end,setSize=function(dda,__b,a_b,b_b)if(type(__b)==
"number")then
dda.width=b_b and dda:getWidth()+__b or __b end
if(type(a_b)=="number")then dda.height=b_b and
dda:getHeight()+a_b or a_b end
if(dda.parent~=nil)then if(type(__b)=="string")then
dda.width=dda.parent:newDynamicValue(dda,__b)end;if(type(a_b)=="string")then
dda.height=dda.parent:newDynamicValue(dda,a_b)end
dda.parent:recalculateDynamicValues()end;if(_ca~=nil)and(dca=="stretch")then
aca=db.resizeBIMG(_ca,dda:getSize())[bca]end
dda:customEventHandler("basalt_resize")dda:updateDraw()return dda end,getHeight=function(dda)
return
type(dda.height)=="number"and dda.height or
math.floor(dda.height[1]+0.5)end,getWidth=function(dda)return

type(dda.width)=="number"and dda.width or math.floor(dda.width[1]+0.5)end,getSize=function(dda)return
dda:getWidth(),dda:getHeight()end,calculateDynamicValues=function(dda)
if(
type(dda.width)=="table")then dda.width:calculate()end
if(type(dda.height)=="table")then dda.height:calculate()end
if(type(dda.x)=="table")then dda.x:calculate()end
if(type(dda.y)=="table")then dda.y:calculate()end;dda:updateDraw()return dda end,setBackground=function(dda,__b,a_b,b_b)dda.bgColor=
__b or false
dda.bgSymbol=a_b or(dda.bgColor~=false and dda.bgSymbol or
false)dda.bgSymbolColor=b_b or dda.bgSymbolColor
dda:updateDraw()return dda end,setTexture=function(dda,__b,a_b,b_b)if(
type(__b)=="string")then _ca=db.loadImageAsBimg(__b)elseif(type(__b)=="table")then
_ca=__b end
if(_ca.animated)then local c_b=_ca[bca].duration or
_ca.secondsPerFrame or 0.2
cca=os.startTimer(c_b)dda.parent:addEvent("other_event",dda)
bda["other_event"]=true end;_da=b_b==false and false or true;bca=1
dca=a_b or"normal"if(dca=="stretch")then
aca=db.resizeBIMG(_ca,dda:getSize())[1]else aca=_ca[1]end
dda:updateDraw()return dda end,setTransparent=function(dda,__b)dda.transparentColor=
__b or false;if(__b~=false)then dda.bgSymbol=false
dda.bgSymbolColor=false end;dda:updateDraw()return dda end,getBackground=function(dda)return
dda.bgColor end,setForeground=function(dda,__b)dda.fgColor=__b or false
dda:updateDraw()return dda end,getForeground=function(dda)return dda.fgColor end,setShadow=function(dda,__b)if(
__b==false)then aaa=false else caa=__b;aaa=true end
dda:updateDraw()return dda end,isShadowActive=function(dda)return aaa end,setBorder=function(dda,...)
if(
...~=nil)then local __b={...}
for a_b,b_b in pairs(__b)do if(b_b=="left")or(#__b==1)then
baa["left"]=__b[1]end;if(b_b=="top")or(#__b==1)then
baa["top"]=__b[1]end;if(b_b=="right")or(#__b==1)then
baa["right"]=__b[1]end;if(b_b=="bottom")or(#__b==1)then
baa["bottom"]=__b[1]end end end;dda:updateDraw()return dda end,getBorder=function(dda,__b)if(
__b=="left")then return borderLeft end
if(__b=="top")then return borderTop end;if(__b=="right")then return borderRight end;if(__b=="bottom")then
return borderBottom end end,draw=function(dda)
if
(b_a)then
if(dda.parent~=nil)then local __b,a_b=dda:getAnchorPosition()
local b_b,c_b=dda:getSize()local d_b,_ab=dda.parent:getSize()
if(__b+b_b<1)or(__b>d_b)or(a_b+
c_b<1)or(a_b>_ab)then return false end;if(dda.transparentColor~=false)then
dda.parent:drawForegroundBox(__b,a_b,b_b,c_b,dda.transparentColor)end;if(dda.bgColor~=false)then
dda.parent:drawBackgroundBox(__b,a_b,b_b,c_b,dda.bgColor)end
if(dda.bgSymbol~=false)then
dda.parent:drawTextBox(__b,a_b,b_b,c_b,dda.bgSymbol)if(dda.bgSymbol~=" ")then
dda.parent:drawForegroundBox(__b,a_b,b_b,c_b,dda.bgSymbolColor)end end
if(aca~=nil)then
if(dca=="center")then local bab,cab=#aca[1][1],#aca
local dab=bab<b_b and math.floor((b_b-bab)/
2)or 0
local _bb=cab<c_b and math.floor((c_b-cab)/2)or 0
local abb=bab<b_b and 1 or math.floor((bab-b_b)/2)
local bbb=bab<b_b and b_b or
b_b-math.floor((b_b-bab)/2 +0.5)-1
local cbb=cab<c_b and 1 or math.floor((cab-c_b)/2)
local dbb=cab<c_b and c_b or
c_b-math.floor((c_b-cab)/2 +0.5)-1;local _cb=1
for k=cbb,#aca do
if(aca[k]~=nil)then local acb,bcb,ccb=cc(aca[k])acb=dc(acb,abb,bbb)
bcb=dc(bcb,abb,bbb)ccb=dc(ccb,abb,bbb)
dda.parent:blit(__b+dab,a_b+_cb-1 +_bb,acb,bcb,ccb)end;_cb=_cb+1;if(k==dbb)then break end end else
for bab,cab in pairs(aca)do local dab,_bb,abb=cc(cab)dab=dc(dab,1,b_b)_bb=dc(_bb,1,b_b)
abb=dc(abb,1,b_b)dda.parent:blit(__b,a_b+bab-1,dab,_bb,abb)if(bab==
c_b)then break end end end end
if(aaa)then
dda.parent:drawBackgroundBox(__b+1,a_b+c_b,b_b,1,caa)
dda.parent:drawBackgroundBox(__b+b_b,a_b+1,1,c_b,caa)
dda.parent:drawForegroundBox(__b+1,a_b+c_b,b_b,1,caa)
dda.parent:drawForegroundBox(__b+b_b,a_b+1,1,c_b,caa)end;local aab=dda.bgColor
if(baa["left"]~=false)then
dda.parent:drawTextBox(__b,a_b,1,c_b,"\149")if(aab~=false)then
dda.parent:drawBackgroundBox(__b,a_b,1,c_b,aab)end
dda.parent:drawForegroundBox(__b,a_b,1,c_b,baa["left"])end
if(baa["top"]~=false)then
dda.parent:drawTextBox(__b,a_b,b_b,1,"\131")if(aab~=false)then
dda.parent:drawBackgroundBox(__b,a_b,b_b,1,dda.bgColor)end
dda.parent:drawForegroundBox(__b,a_b,b_b,1,baa["top"])end
if(baa["left"]~=false)and(baa["top"]~=false)then
dda.parent:drawTextBox(__b,a_b,1,1,"\151")if(aab~=false)then
dda.parent:drawBackgroundBox(__b,a_b,1,1,dda.bgColor)end
dda.parent:drawForegroundBox(__b,a_b,1,1,baa["left"])end
if(baa["right"]~=false)then
dda.parent:drawTextBox(__b+b_b-1,a_b,1,c_b,"\149")if(aab~=false)then
dda.parent:drawForegroundBox(__b+b_b-1,a_b,1,c_b,dda.bgColor)end
dda.parent:drawBackgroundBox(__b+b_b-1,a_b,1,c_b,baa["right"])end
if(baa["bottom"]~=false)then
dda.parent:drawTextBox(__b,a_b+c_b-1,b_b,1,"\143")if(aab~=false)then
dda.parent:drawForegroundBox(__b,a_b+c_b-1,b_b,1,dda.bgColor)end
dda.parent:drawBackgroundBox(__b,a_b+c_b-1,b_b,1,baa["bottom"])end
if(baa["top"]~=false)and(baa["right"]~=false)then dda.parent:drawTextBox(
__b+b_b-1,a_b,1,1,"\148")if
(aab~=false)then
dda.parent:drawForegroundBox(__b+b_b-1,a_b,1,1,dda.bgColor)end
dda.parent:drawBackgroundBox(__b+b_b-1,a_b,1,1,baa["right"])end
if(baa["right"]~=false)and(baa["bottom"]~=false)then
dda.parent:drawTextBox(
__b+b_b-1,a_b+c_b-1,1,1,"\133")if(aab~=false)then
dda.parent:drawForegroundBox(__b+b_b-1,a_b+c_b-1,1,1,dda.bgColor)end
dda.parent:drawBackgroundBox(__b+b_b-1,
a_b+c_b-1,1,1,baa["right"])end
if(baa["bottom"]~=false)and(baa["left"]~=false)then dda.parent:drawTextBox(__b,
a_b+c_b-1,1,1,"\138")if(aab~=false)then
dda.parent:drawForegroundBox(
__b-1,a_b+c_b-1,1,1,dda.bgColor)end
dda.parent:drawBackgroundBox(__b,a_b+c_b-1,1,1,baa["left"])end end;ada=false;return true end;return false end,getAbsolutePosition=function(dda,__b,a_b)
if(
__b==nil)or(a_b==nil)then __b,a_b=dda:getAnchorPosition()end
if(dda.parent~=nil)then
local b_b,c_b=dda.parent:getAbsolutePosition()__b=b_b+__b-1;a_b=c_b+a_b-1 end;return __b,a_b end,getAnchorPosition=function(dda,__b,a_b,b_b)if(
__b==nil)then __b=dda:getX()end
if(a_b==nil)then a_b=dda:getY()end
if(dda.parent~=nil)then local c_b,d_b=dda.parent:getSize()
if(__a=="top")then __b=math.floor(
c_b/2)+__b-1 elseif(__a=="topRight")then
__b=c_b+__b-1 elseif(__a=="right")then __b=c_b+__b-1
a_b=math.floor(d_b/2)+a_b-1 elseif(__a=="bottomRight")then __b=c_b+__b-1;a_b=d_b+a_b-1 elseif(__a=="bottom")then __b=math.floor(
c_b/2)+__b-1;a_b=d_b+a_b-1 elseif(__a==
"bottomLeft")then a_b=d_b+a_b-1 elseif(__a=="left")then
a_b=math.floor(d_b/2)+a_b-1 elseif(__a=="center")then __b=math.floor(c_b/2)+__b-1;a_b=math.floor(
d_b/2)+a_b-1 end;local _ab,aab=dda.parent:getOffsetInternal()if not(a_a or b_b)then return
__b+_ab,a_b+aab end end;return __b,a_b end,ignoreOffset=function(dda,__b)
a_a=__b;if(__b==nil)then a_a=true end;return dda end,getBaseFrame=function(dda)
if(
dda.parent~=nil)then return dda.parent:getBaseFrame()end;return dda end,setAnchor=function(dda,__b)__a=__b
dda:updateDraw()return dda end,getAnchor=function(dda)return __a end,onChange=function(dda,...)
for __b,a_b in
pairs(table.pack(...))do if(type(a_b)=="function")then
dda:registerEvent("value_changed",a_b)end end;return dda end,onClick=function(dda,...)
for __b,a_b in
pairs(table.pack(...))do if(type(a_b)=="function")then
dda:registerEvent("mouse_click",a_b)end end
if(dda.parent~=nil)then
dda.parent:addEvent("mouse_click",dda)bda["mouse_click"]=true
dda.parent:addEvent("mouse_up",dda)bda["mouse_up"]=true end;return dda end,onClickUp=function(dda,...)for __b,a_b in
pairs(table.pack(...))do
if(type(a_b)=="function")then dda:registerEvent("mouse_up",a_b)end end
if(dda.parent~=nil)then
dda.parent:addEvent("mouse_click",dda)bda["mouse_click"]=true
dda.parent:addEvent("mouse_up",dda)bda["mouse_up"]=true end;return dda end,onRelease=function(dda,...)
for __b,a_b in
pairs(table.pack(...))do if(type(a_b)=="function")then
dda:registerEvent("mouse_release",a_b)end end
if(dda.parent~=nil)then
dda.parent:addEvent("mouse_click",dda)bda["mouse_click"]=true
dda.parent:addEvent("mouse_up",dda)bda["mouse_up"]=true end;return dda end,onScroll=function(dda,...)
for __b,a_b in
pairs(table.pack(...))do if(type(a_b)=="function")then
dda:registerEvent("mouse_scroll",a_b)end end
if(dda.parent~=nil)then
dda.parent:addEvent("mouse_scroll",dda)bda["mouse_scroll"]=true end;return dda end,onHover=function(dda,...)
for __b,a_b in
pairs(table.pack(...))do if(type(a_b)=="function")then
dda:registerEvent("mouse_hover",a_b)end end;if(dda.parent~=nil)then
dda.parent:addEvent("mouse_move",dda)bda["mouse_move"]=true end
return dda end,onLeave=function(dda,...)
for __b,a_b in
pairs(table.pack(...))do if(type(a_b)=="function")then
dda:registerEvent("mouse_leave",a_b)end end;if(dda.parent~=nil)then
dda.parent:addEvent("mouse_move",dda)bda["mouse_move"]=true end
return dda end,onDrag=function(dda,...)
for __b,a_b in
pairs(table.pack(...))do if(type(a_b)=="function")then
dda:registerEvent("mouse_drag",a_b)end end
if(dda.parent~=nil)then
dda.parent:addEvent("mouse_drag",dda)bda["mouse_drag"]=true
dda.parent:addEvent("mouse_click",dda)bda["mouse_click"]=true
dda.parent:addEvent("mouse_up",dda)bda["mouse_up"]=true end;return dda end,onEvent=function(dda,...)
for __b,a_b in
pairs(table.pack(...))do if(type(a_b)=="function")then
dda:registerEvent("other_event",a_b)end end;if(dda.parent~=nil)then
dda.parent:addEvent("other_event",dda)bda["other_event"]=true end;return
dda end,onKey=function(dda,...)
if
(daa)then
for __b,a_b in pairs(table.pack(...))do if(type(a_b)=="function")then
dda:registerEvent("key",a_b)end end;if(dda.parent~=nil)then dda.parent:addEvent("key",dda)
bda["key"]=true end end;return dda end,onChar=function(dda,...)
if
(daa)then
for __b,a_b in pairs(table.pack(...))do if(type(a_b)=="function")then
dda:registerEvent("char",a_b)end end;if(dda.parent~=nil)then dda.parent:addEvent("char",dda)
bda["char"]=true end end;return dda end,onResize=function(dda,...)
for __b,a_b in
pairs(table.pack(...))do if(type(a_b)=="function")then
dda:registerEvent("basalt_resize",a_b)end end;return dda end,onReposition=function(dda,...)
for __b,a_b in
pairs(table.pack(...))do if(type(a_b)=="function")then
dda:registerEvent("basalt_reposition",a_b)end end;return dda end,onKeyUp=function(dda,...)for __b,a_b in
pairs(table.pack(...))do
if(type(a_b)=="function")then dda:registerEvent("key_up",a_b)end end;if(dda.parent~=nil)then
dda.parent:addEvent("key_up",dda)bda["key_up"]=true end;return dda end,isFocused=function(dda)if(
dda.parent~=nil)then
return dda.parent:getFocusedObject()==dda end;return false end,onGetFocus=function(dda,...)
for __b,a_b in
pairs(table.pack(...))do if(type(a_b)=="function")then
dda:registerEvent("get_focus",a_b)end end;if(dda.parent~=nil)then
dda.parent:addEvent("mouse_click",dda)bda["mouse_click"]=true end;return
dda end,onLoseFocus=function(dda,...)
for __b,a_b in
pairs(table.pack(...))do if(type(a_b)=="function")then
dda:registerEvent("lose_focus",a_b)end end;if(dda.parent~=nil)then
dda.parent:addEvent("mouse_click",dda)bda["mouse_click"]=true end;return
dda end,registerEvent=function(dda,__b,a_b)return
cda:registerEvent(__b,a_b)end,removeEvent=function(dda,__b,a_b)
return cda:removeEvent(__b,a_b)end,sendEvent=function(dda,__b,...)return cda:sendEvent(__b,dda,...)end,isCoordsInObject=function(dda,__b,a_b)
if
(b_a)and(daa)then if(__b==nil)or(a_b==nil)then return false end
local b_b,c_b=dda:getAbsolutePosition()local d_b,_ab=dda:getSize()
if
(b_b<=__b)and(b_b+d_b>__b)and(c_b<=a_b)and(c_b+_ab>a_b)then return true end end;return false end,mouseHandler=function(dda,__b,a_b,b_b,c_b)
if
(dda:isCoordsInObject(a_b,b_b))then local d_b,_ab=dda:getAbsolutePosition()
local aab=cda:sendEvent("mouse_click",dda,"mouse_click",__b,a_b-
(d_b-1),b_b- (_ab-1),a_b,b_b,c_b)if(aab==false)then return false end;if(dda.parent~=nil)then
dda.parent:setFocusedObject(dda)end;_aa=true;_ba=true;aba,bba=a_b,b_b;return true end;return false end,mouseUpHandler=function(dda,__b,a_b,b_b)
_ba=false
if(_aa)then local c_b,d_b=dda:getAbsolutePosition()
local _ab=cda:sendEvent("mouse_release",dda,"mouse_release",__b,a_b- (
c_b-1),b_b- (d_b-1),a_b,b_b)_aa=false end
if(dda:isCoordsInObject(a_b,b_b))then local c_b,d_b=dda:getAbsolutePosition()
local _ab=cda:sendEvent("mouse_up",dda,"mouse_up",__b,
a_b- (c_b-1),b_b- (d_b-1),a_b,b_b)if(_ab==false)then return false end;return true end;return false end,dragHandler=function(dda,__b,a_b,b_b)
if
(_ba)then local c_b,d_b=dda:getAbsolutePosition()
local _ab=cda:sendEvent("mouse_drag",dda,"mouse_drag",__b,a_b- (c_b-1),
b_b- (d_b-1),aba-a_b,bba-b_b,a_b,b_b)aba,bba=a_b,b_b;if(_ab~=nil)then return _ab end;if(dda.parent~=nil)then
dda.parent:setFocusedObject(dda)end;return true end
if(dda:isCoordsInObject(a_b,b_b))then
local c_b,d_b=dda:getAbsolutePosition(dda:getAnchorPosition())aba,bba=a_b,b_b;cba,dba=c_b-a_b,d_b-b_b end;return false end,scrollHandler=function(dda,__b,a_b,b_b)
if
(dda:isCoordsInObject(a_b,b_b))then local c_b,d_b=dda:getAbsolutePosition()
local _ab=cda:sendEvent("mouse_scroll",dda,"mouse_scroll",__b,a_b-
(c_b-1),b_b- (d_b-1))if(_ab==false)then return false end;if(dda.parent~=nil)then
dda.parent:setFocusedObject(dda)end;return true end;return false end,hoverHandler=function(dda,__b,a_b,b_b)
if
(dda:isCoordsInObject(__b,a_b))then
local c_b=cda:sendEvent("mouse_hover",dda,"mouse_hover",__b,a_b,b_b)if(c_b==false)then return false end;d_a=true;return true end
if(d_a)then
local c_b=cda:sendEvent("mouse_leave",dda,"mouse_leave",__b,a_b,b_b)if(c_b==false)then return false end;d_a=false end;return false end,keyHandler=function(dda,__b,a_b)if
(daa)and(b_a)then
if(dda:isFocused())then
local b_b=cda:sendEvent("key",dda,"key",__b,a_b)if(b_b==false)then return false end;return true end end;return
false end,keyUpHandler=function(dda,__b)if
(daa)and(b_a)then
if(dda:isFocused())then
local a_b=cda:sendEvent("key_up",dda,"key_up",__b)if(a_b==false)then return false end;return true end end;return
false end,charHandler=function(dda,__b)if
(daa)and(b_a)then
if(dda:isFocused())then
local a_b=cda:sendEvent("char",dda,"char",__b)if(a_b==false)then return false end;return true end end;return
false end,valueChangedHandler=function(dda)
cda:sendEvent("value_changed",dda,dd)end,eventHandler=function(dda,__b,...)local a_b={...}
if
(__b=="timer")and(a_b[1]==cca)then
if(_ca[bca+1]~=nil)then bca=bca+1;if(dca=="stretch")then
aca=db.resizeBIMG(_ca,dda:getSize())[bca]else aca=_ca[bca]end;local c_b=_ca[bca].duration or
_ca.secondsPerFrame or 0.2
cca=os.startTimer(c_b)else
if(_da)then bca=1;if(dca=="stretch")then
aca=db.resizeBIMG(_ca,dda:getSize())[1]else aca=_ca[1]end;local c_b=
_ca[1].duration or _ca.secondsPerFrame or 0.2
cca=os.startTimer(c_b)end end;dda:updateDraw()end;local b_b=cda:sendEvent("other_event",dda,__b,...)if(b_b~=nil)then
return b_b end end,customEventHandler=function(dda,__b,...)
if
(
_ca~=nil)and(dca=="stretch")and(__b=="basalt_resize")then
aca=db.resizeBIMG(_ca,dda:getSize())[bca]dda:updateDraw()end;local a_b=cda:sendEvent("custom_event",dda,__b,...)if(a_b~=nil)then
return a_b end;return true end,getFocusHandler=function(dda)
local __b=cda:sendEvent("get_focus",dda)if(__b~=nil)then return __b end;return true end,loseFocusHandler=function(dda)
_ba=false;local __b=cda:sendEvent("lose_focus",dda)
if(__b~=nil)then return __b end;return true end,init=function(dda)
if
(dda.parent~=nil)then for __b,a_b in pairs(bda)do
if(a_b)then dda.parent:addEvent(__b,dda)end end end;if not(c_a)then c_a=true;return true end;return false end}bd.__index=bd;return bd end end;aa["objects"]={}
aa["objects"]["Input"]=function(...)local ab=da("Object")
local bb=da("utils")local cb=da("basaltLogs")local db=bb.getValueFromXML
return
function(_c)local ac=ab(_c)local bc="Input"
local cc="text"local dc=0;ac:setZIndex(5)ac:setValue("")ac.width=10;ac.height=1
local _d=1;local ad=1;local bd=""local cd;local dd;local __a=bd;local a_a=false
local b_a={getType=function(c_a)return bc end,setInputType=function(c_a,d_a)
if(d_a=="password")or(d_a==
"number")or(d_a=="text")then cc=d_a end;c_a:updateDraw()return c_a end,setDefaultText=function(c_a,d_a,_aa,aaa)
bd=d_a;cd=aaa or cd;dd=_aa or dd
if(c_a:isFocused())then __a=""else __a=bd end;c_a:updateDraw()return c_a end,getInputType=function(c_a)return
cc end,setValue=function(c_a,d_a)ac.setValue(c_a,tostring(d_a))
if not(a_a)then _d=
tostring(d_a):len()+1
ad=math.max(1,_d-c_a:getWidth()+1)if(c_a:isFocused())then local _aa,aaa=c_a:getAnchorPosition()
c_a.parent:setCursor(true,
_aa+_d-ad,aaa+math.floor(c_a:getHeight()/2),c_a.fgColor)end end;c_a:updateDraw()return c_a end,getValue=function(c_a)
local d_a=ac.getValue(c_a)
return cc=="number"and tonumber(d_a)or d_a end,setInputLimit=function(c_a,d_a)
dc=tonumber(d_a)or dc;c_a:updateDraw()return c_a end,getInputLimit=function(c_a)return dc end,setValuesByXMLData=function(c_a,d_a)
ac.setValuesByXMLData(c_a,d_a)local _aa,aaa
if(db("defaultBG",d_a)~=nil)then _aa=db("defaultBG",d_a)end
if(db("defaultFG",d_a)~=nil)then aaa=db("defaultFG",d_a)end;if(db("default",d_a)~=nil)then
c_a:setDefaultText(db("default",d_a),aaa~=nil and colors[aaa],
_aa~=nil and colors[_aa])end
if(db("limit",d_a)~=
nil)then c_a:setInputLimit(db("limit",d_a))end;if(db("type",d_a)~=nil)then
c_a:setInputType(db("type",d_a))end;return c_a end,getFocusHandler=function(c_a)
ac.getFocusHandler(c_a)
if(c_a.parent~=nil)then local d_a,_aa=c_a:getAnchorPosition()__a=""if(bd~="")then
c_a:updateDraw()end
c_a.parent:setCursor(true,d_a+_d-ad,_aa+math.max(math.ceil(
c_a:getHeight()/2 -1,1)),c_a.fgColor)end end,loseFocusHandler=function(c_a)
ac.loseFocusHandler(c_a)if(c_a.parent~=nil)then __a=bd;if(bd~="")then c_a:updateDraw()end
c_a.parent:setCursor(false)end end,keyHandler=function(c_a,d_a)
if
(ac.keyHandler(c_a,d_a))then local _aa,aaa=c_a:getSize()a_a=true
if(d_a==keys.backspace)then
local bba=tostring(ac.getValue())if(_d>1)then
c_a:setValue(bba:sub(1,_d-2)..bba:sub(_d,bba:len()))if(_d>1)then _d=_d-1 end
if(ad>1)then if(_d<ad)then ad=ad-1 end end end end;if(d_a==keys.enter)then if(c_a.parent~=nil)then end end
if(
d_a==keys.right)then
local bba=tostring(ac.getValue()):len()_d=_d+1;if(_d>bba)then _d=bba+1 end;if(_d<1)then _d=1 end;if
(_d<ad)or(_d>=_aa+ad)then ad=_d-_aa+1 end;if(ad<1)then ad=1 end end
if(d_a==keys.left)then _d=_d-1;if(_d>=1)then
if(_d<ad)or(_d>=_aa+ad)then ad=_d end end;if(_d<1)then _d=1 end;if(ad<1)then ad=1 end end;local baa,caa=c_a:getAnchorPosition()
local daa=tostring(ac.getValue())
local _ba=(_d<=daa:len()and _d-1 or daa:len())- (ad-1)local aba=c_a:getX()
if(_ba>aba+_aa-1)then _ba=aba+_aa-1 end;if(c_a.parent~=nil)then
c_a.parent:setCursor(true,baa+_ba,caa+
math.max(math.ceil(aaa/2 -1,1)),c_a.fgColor)end
c_a:updateDraw()a_a=false;return true end;return false end,charHandler=function(c_a,d_a)
if
(ac.charHandler(c_a,d_a))then a_a=true;local _aa,aaa=c_a:getSize()local baa=ac.getValue()
if(
baa:len()<dc or dc<=0)then
if(cc=="number")then local cba=baa
if
(_d==1 and d_a=="-")or(d_a==".")or(tonumber(d_a)~=nil)then
c_a:setValue(baa:sub(1,_d-1)..
d_a..baa:sub(_d,baa:len()))_d=_d+1;if(d_a==".")or(d_a=="-")and(#baa>0)then
if(
tonumber(ac.getValue())==nil)then c_a:setValue(cba)_d=_d-1 end end end else
c_a:setValue(baa:sub(1,_d-1)..d_a..baa:sub(_d,baa:len()))_d=_d+1 end;if(_d>=_aa+ad)then ad=ad+1 end end;local caa,daa=c_a:getAnchorPosition()
local _ba=tostring(ac.getValue())
local aba=(_d<=_ba:len()and _d-1 or _ba:len())- (ad-1)local bba=c_a:getX()
if(aba>bba+_aa-1)then aba=bba+_aa-1 end;if(c_a.parent~=nil)then
c_a.parent:setCursor(true,caa+aba,daa+
math.max(math.ceil(aaa/2 -1,1)),c_a.fgColor)end;a_a=false
c_a:updateDraw()return true end;return false end,mouseHandler=function(c_a,d_a,_aa,aaa)
if
(ac.mouseHandler(c_a,d_a,_aa,aaa))then local baa,caa=c_a:getAnchorPosition()
local daa,_ba=c_a:getAbsolutePosition(baa,caa)local aba,bba=c_a:getSize()_d=_aa-daa+ad;local cba=ac.getValue()if(_d>
cba:len())then _d=cba:len()+1 end;if(_d<ad)then ad=_d-1
if(ad<1)then ad=1 end end
c_a.parent:setCursor(true,baa+_d-ad,caa+
math.max(math.ceil(bba/2 -1,1)),c_a.fgColor)return true end end,dragHandler=function(c_a,d_a,_aa,aaa,baa,caa)
if
(c_a:isFocused())then if(c_a:isCoordsInObject(_aa,aaa))then
if(ac.dragHandler(c_a,d_a,_aa,aaa,baa,caa))then return true end end
c_a.parent:removeFocusedObject()end end,eventHandler=function(c_a,d_a,_aa,...)
ac.eventHandler(c_a,d_a,_aa,...)
if(d_a=="paste")then
if(c_a:isFocused())then local aaa=ac.getValue()
local baa,caa=c_a:getSize()a_a=true
if(cc=="number")then local dba=aaa
if(_aa==".")or(tonumber(_aa)~=nil)then
c_a:setValue(aaa:sub(1,
_d-1).._aa..aaa:sub(_d,aaa:len()))_d=_d+_aa:len()end
if(tonumber(ac.getValue())==nil)then c_a:setValue(dba)end else
c_a:setValue(aaa:sub(1,_d-1).._aa..aaa:sub(_d,aaa:len()))_d=_d+_aa:len()end;if(_d>=baa+ad)then ad=(_d+1)-baa end
local daa,_ba=c_a:getAnchorPosition()local aba=tostring(ac.getValue())
local bba=(
_d<=aba:len()and _d-1 or aba:len())- (ad-1)local cba=c_a:getX()
if(bba>cba+baa-1)then bba=cba+baa-1 end;if(c_a.parent~=nil)then
c_a.parent:setCursor(true,daa+bba,_ba+
math.max(math.ceil(caa/2 -1,1)),c_a.fgColor)end
c_a:updateDraw()a_a=false end end end,draw=function(c_a)
if
(ac.draw(c_a))then
if(c_a.parent~=nil)then local d_a,_aa=c_a:getAnchorPosition()
local aaa,baa=c_a:getSize()local caa=bb.getTextVerticalAlign(baa,"center")if
(c_a.bgColor~=false)then
c_a.parent:drawBackgroundBox(d_a,_aa,aaa,baa,c_a.bgColor)end
for n=1,baa do
if(n==caa)then
local daa=tostring(ac.getValue())local _ba=c_a.bgColor;local aba=c_a.fgColor;local bba;if(daa:len()<=0)then bba=__a
_ba=cd or _ba;aba=dd or aba end;bba=__a
if(daa~="")then bba=daa end;bba=bba:sub(ad,aaa+ad-1)local cba=aaa-bba:len()if(cba<0)then
cba=0 end;if(cc=="password")and(daa~="")then
bba=string.rep("*",bba:len())end
bba=bba..string.rep(c_a.bgSymbol,cba)
c_a.parent:writeText(d_a,_aa+ (n-1),bba,_ba,aba)end end;if(c_a:isFocused())then
c_a.parent:setCursor(true,d_a+_d-ad,_aa+
math.floor(c_a:getHeight()/2),c_a.fgColor)end end end end,init=function(c_a)
if(
c_a.parent~=nil)then c_a.parent:addEvent("mouse_click",c_a)
c_a.parent:addEvent("key",c_a)c_a.parent:addEvent("char",c_a)
c_a.parent:addEvent("other_event",c_a)c_a.parent:addEvent("mouse_drag",c_a)end
if(ac.init(c_a))then
c_a.bgColor=c_a.parent:getTheme("InputBG")c_a.fgColor=c_a.parent:getTheme("InputText")end end}return setmetatable(b_a,ac)end end
aa["objects"]["Button"]=function(...)local ab=da("Object")local bb=da("utils")
local cb=bb.getValueFromXML;local db=da("tHex")
return
function(_c)local ac=ab(_c)local bc="Button"local cc="center"local dc="center"
ac:setZIndex(5)ac:setValue("Button")ac.width=12;ac.height=3
local _d={init=function(ad)
if(ac.init(ad))then
ad.bgColor=ad.parent:getTheme("ButtonBG")ad.fgColor=ad.parent:getTheme("ButtonText")end end,getType=function(ad)return bc end,setHorizontalAlign=function(ad,bd)
cc=bd;ad:updateDraw()return ad end,setVerticalAlign=function(ad,bd)dc=bd
ad:updateDraw()return ad end,setText=function(ad,bd)ac:setValue(tostring(bd))
ad:updateDraw()return ad end,setValuesByXMLData=function(ad,bd)
ac.setValuesByXMLData(ad,bd)
if(cb("text",bd)~=nil)then ad:setText(cb("text",bd))end;if(cb("horizontalAlign",bd)~=nil)then
cc=cb("horizontalAlign",bd)end;if(cb("verticalAlign",bd)~=nil)then
dc=cb("verticalAlign",bd)end;return ad end,draw=function(ad)
if
(ac.draw(ad))then
if(ad.parent~=nil)then local bd,cd=ad:getAnchorPosition()
local dd,__a=ad:getSize()local a_a=bb.getTextVerticalAlign(__a,dc)
for n=1,__a do
if(n==a_a)then
local b_a=ad:getValue()
ad.parent:setText(bd+ (dd/2 -b_a:len()/2),cd+ (n-1),bb.getTextHorizontalAlign(b_a,b_a:len(),cc))
ad.parent:setFG(bd+ (dd/2 -b_a:len()/2),cd+ (n-1),bb.getTextHorizontalAlign(db[ad.fgColor]:rep(b_a:len()),b_a:len(),cc))end end end end end}return setmetatable(_d,ac)end end
aa["objects"]["Graphic"]=function(...)local ab=da("Object")local bb=da("tHex")
local cb=da("utils").getValueFromXML;local db=da("bimg")local _c=da("images")
local ac,bc,cc,dc=string.sub,string.len,math.max,math.min
return
function(_d)local ad=ab(_d)local bd="Graphic"local cd=db()local dd=cd.getFrameObject(1)local __a
local a_a=1;ad:setZIndex(5)local b_a,c_a=0,0
local d_a={getType=function(_aa)return bd end,setOffset=function(_aa,aaa,baa,caa)
if(caa)then
b_a=b_a+aaa or 0;c_a=c_a+baa or 0 else b_a=aaa or b_a;c_a=baa or c_a end;_aa:updateDraw()return _aa end,getOffset=function(_aa)return
b_a,c_a end,setValuesByXMLData=function(_aa,aaa)ad.setValuesByXMLData(_aa,aaa)return _aa end,selectFrame=function(_aa,aaa)if(
cd.getFrameObject(aaa)==nil)then cd.addFrame(aaa)end
dd=cd.getFrameObject(aaa)__a=dd.getImage(aaa)a_a=aaa;_aa:updateDraw()end,addFrame=function(_aa,aaa)
cd.addFrame(aaa)return _aa end,getFrameMetadata=function(_aa,aaa,baa)return cd.getFrameData(aaa,baa)end,setFrameMetadata=function(_aa,aaa,baa,caa)
cd.setFrameData(aaa,baa,caa)return _aa end,getMetadata=function(_aa,aaa)return cd.getMetadata(aaa)end,setMetadata=function(_aa,aaa,baa)return
cd.setMetadata(aaa,baa)end,getFrame=function(_aa,aaa)return cd.getFrame(aaa)end,getFrameObject=function(_aa,aaa)return
cd.getFrameObject(aaa)end,removeFrame=function(_aa,aaa)cd.removeFrame(aaa)return _aa end,moveFrame=function(_aa,aaa,baa)
cd.moveFrame(aaa,baa)return _aa end,getFrames=function(_aa)return cd.getFrames()end,getFrameCount=function(_aa)return
#cd.getFrames()end,getSelectedFrame=function(_aa)return a_a end,blit=function(_aa,aaa,baa,caa,daa,_ba)
x=daa or x;y=_ba or y;dd.blit(aaa,baa,caa,x,y)__a=dd.getImage()
_aa:updateDraw()return _aa end,setText=function(_aa,aaa,baa,caa)
x=baa or x;y=caa or y;dd.text(aaa,x,y)__a=dd.getImage()
_aa:updateDraw()return _aa end,setBg=function(_aa,aaa,baa,caa)x=baa or x;y=
caa or y;dd.bg(aaa,x,y)__a=dd.getImage()
_aa:updateDraw()return _aa end,setFg=function(_aa,aaa,baa,caa)x=baa or x;y=caa or
y;dd.fg(aaa,x,y)__a=dd.getImage()
_aa:updateDraw()return _aa end,getImageSize=function(_aa)
return cd.getSize()end,setImageSize=function(_aa,aaa,baa)cd.setSize(aaa,baa)__a=dd.getImage()
_aa:updateDraw()return _aa end,resizeImage=function(_aa,aaa,baa)
local caa=_c.resizeBIMG(cd.createBimg(),aaa,baa)cd=db(caa)a_a=1;dd=cd.getFrameObject(1)__a=dd.getImage()
_aa:updateDraw()return _aa end,loadImage=function(_aa,aaa)
if
(fs.exists(aaa))then local baa=_c.loadBIMG(aaa)cd=db(baa)a_a=1
dd=cd.getFrameObject(1)__a=dd.getImage()_aa:updateDraw()end;return _aa end,clear=function(_aa)
cd=db()__a=nil;_aa:updateDraw()return _aa end,getImage=function(_aa)return
cd.createBimg()end,draw=function(_aa)
if(ad.draw(_aa))then
if(_aa.parent~=nil)then
local aaa,baa=_aa:getAnchorPosition()local caa,daa=_aa:getSize()
if(__a~=nil)then
for _ba,aba in pairs(__a)do if
(_ba<=daa-c_a)and(_ba+c_a>=1)then
_aa.parent:blit(aaa+b_a,baa+_ba-1 +c_a,aba[1],aba[2],aba[3])end end end end end end,init=function(_aa)
if
(ad.init(_aa))then _aa.bgColor=_aa.parent:getTheme("GraphicBG")end end}return setmetatable(d_a,ad)end end
aa["objects"]["Checkbox"]=function(...)local ab=da("Object")local bb=da("utils")
local cb=bb.getValueFromXML
return
function(db)local _c=ab(db)local ac="Checkbox"_c:setZIndex(5)
_c:setValue(false)_c.width=1;_c.height=1;local bc="\42"
local cc={getType=function(dc)return ac end,setSymbol=function(dc,_d)bc=_d
dc:updateDraw()return dc end,mouseHandler=function(dc,_d,ad,bd)
if(_c.mouseHandler(dc,_d,ad,bd))then
if(_d==1)then
if(
dc:getValue()~=true)and(dc:getValue()~=false)then
dc:setValue(false)else dc:setValue(not dc:getValue())end;dc:updateDraw()return true end end;return false end,touchHandler=function(dc,_d,ad)return
dc:mouseHandler(1,_d,ad)end,setValuesByXMLData=function(dc,_d)
_c.setValuesByXMLData(dc,_d)
if(cb("checked",_d)~=nil)then if(cb("checked",_d))then dc:setValue(true)else
dc:setValue(false)end end;return dc end,draw=function(dc)
if
(_c.draw(dc))then
if(dc.parent~=nil)then local _d,ad=dc:getAnchorPosition()
local bd,cd=dc:getSize()local dd=bb.getTextVerticalAlign(cd,"center")if
(dc.bgColor~=false)then
dc.parent:drawBackgroundBox(_d,ad,bd,cd,dc.bgColor)end
for n=1,cd do
if(n==dd)then
if(dc:getValue()==true)then
dc.parent:writeText(_d,
ad+ (n-1),bb.getTextHorizontalAlign(bc,bd,"center"),dc.bgColor,dc.fgColor)else
dc.parent:writeText(_d,ad+ (n-1),bb.getTextHorizontalAlign(" ",bd,"center"),dc.bgColor,dc.fgColor)end end end end end end,init=function(dc)
dc.parent:addEvent("mouse_click",dc)dc.parent:addEvent("mouse_up",dc)
if(_c.init(dc))then
dc.bgColor=dc.parent:getTheme("CheckboxBG")dc.fgColor=dc.parent:getTheme("CheckboxText")end end}return setmetatable(cc,_c)end end
aa["objects"]["Label"]=function(...)local ab=da("Object")local bb=da("utils")
local cb=bb.getValueFromXML;local db=bb.createText;local _c=da("tHex")local ac=da("bigfont")
return
function(bc)local cc=ab(bc)
local dc="Label"cc:setZIndex(3)local _d=true;cc:setValue("Label")cc.width=5
local ad="left"local bd="top"local cd=0;local dd,__a=false,false
local a_a={getType=function(b_a)return dc end,setText=function(b_a,c_a)c_a=tostring(c_a)
cc:setValue(c_a)
if(_d)then local d_a=b_a.parent:getOffset()
if(
c_a:len()+b_a:getX()>b_a.parent:getWidth()+d_a)then local _aa=
b_a.parent:getWidth()+d_a-b_a:getX()cc.setSize(b_a,_aa,
#db(c_a,_aa))else
cc.setSize(b_a,c_a:len(),1)end end;b_a:updateDraw()return b_a end,setBackground=function(b_a,c_a)
cc.setBackground(b_a,c_a)__a=true;b_a:updateDraw()return b_a end,setForeground=function(b_a,c_a)
cc.setForeground(b_a,c_a)dd=true;b_a:updateDraw()return b_a end,setTextAlign=function(b_a,c_a,d_a)ad=
c_a or ad;bd=d_a or bd;b_a:updateDraw()return b_a end,setFontSize=function(b_a,c_a)if(
c_a>0)and(c_a<=4)then cd=c_a-1 or 0 end
b_a:updateDraw()return b_a end,getFontSize=function(b_a)return cd+1 end,setValuesByXMLData=function(b_a,c_a)
cc.setValuesByXMLData(b_a,c_a)
if(cb("text",c_a)~=nil)then b_a:setText(cb("text",c_a))end
if(cb("verticalAlign",c_a)~=nil)then bd=cb("verticalAlign",c_a)end;if(cb("horizontalAlign",c_a)~=nil)then
ad=cb("horizontalAlign",c_a)end;if(cb("font",c_a)~=nil)then
b_a:setFontSize(cb("font",c_a))end;return b_a end,setSize=function(b_a,c_a,d_a,_aa)
cc.setSize(b_a,c_a,d_a,_aa)_d=false;b_a:updateDraw()return b_a end,eventHandler=function(b_a,c_a)
if(
c_a=="basalt_resize")then
if(_d)then local d_a=b_a:getValue()
if(
d_a:len()+b_a:getX()>b_a.parent:getWidth())then local _aa=
b_a.parent:getWidth()-b_a:getX()
cc.setSize(b_a,_aa,#db(d_a,_aa))else cc.setSize(b_a,d_a:len(),1)end else end end end,draw=function(b_a)
if
(cc.draw(b_a))then
if(b_a.parent~=nil)then local c_a,d_a=b_a:getAnchorPosition()
local _aa,aaa=b_a:getSize()local baa=bb.getTextVerticalAlign(aaa,bd)
if(cd==0)then
if not(_d)then
local caa=db(b_a:getValue(),b_a:getWidth())
for daa,_ba in pairs(caa)do if(daa<=aaa)then
b_a.parent:writeText(c_a,d_a+daa-1,_ba,b_a.bgColor,b_a.fgColor)end end else
if
(#b_a:getValue()+c_a>b_a.parent:getWidth())then local caa=db(b_a:getValue(),b_a:getWidth())
for daa,_ba in
pairs(caa)do if(daa<=aaa)then
b_a.parent:writeText(c_a,d_a+daa-1,_ba,b_a.bgColor,b_a.fgColor)end end else
b_a.parent:writeText(c_a,d_a,b_a:getValue(),b_a.bgColor,b_a.fgColor)end end else
local caa=ac(cd,b_a:getValue(),b_a.fgColor,b_a.bgColor or colors.lightGray)
if(_d)then b_a:setSize(#caa[1][1],#caa[1]-1)end;local daa,_ba=b_a.parent:getSize()
local aba,bba=#caa[1][1],#caa[1]
c_a=c_a or math.floor((daa-aba)/2)+1
d_a=d_a or math.floor((_ba-bba)/2)+1
for i=1,bba do
b_a.parent:setFG(c_a,d_a+i-1,caa[2][i])b_a.parent:setBG(c_a,d_a+i-1,caa[3][i])b_a.parent:setText(c_a,
d_a+i-1,caa[1][i])end end end end end,init=function(b_a)
b_a.parent:addEvent("other_event",b_a)
if(cc.init(b_a))then
b_a.bgColor=b_a.parent:getTheme("LabelBG")b_a.fgColor=b_a.parent:getTheme("LabelText")
if
(
b_a.parent.bgColor==colors.black)and(b_a.fgColor==colors.black)then b_a.fgColor=colors.lightGray end end end}return setmetatable(a_a,cc)end end
aa["objects"]["Image"]=function(...)local ab=da("Object")
local bb=da("utils").getValueFromXML;local cb=da("images")local db,_c=table.unpack,string.sub
return
function(ac)local bc=ab(ac)
local cc="Image"bc:setZIndex(2)local dc;local _d;local ad=1;local bd=false;local cd;local dd=false;bc.width=24
bc.height=8
local function __a(b_a)
if(dc~=nil)then local c_a={}
for d_a,_aa in pairs(colors)do if(type(_aa)=="number")then
c_a[d_a]={term.nativePaletteColor(_aa)}end end;if(dc.palette~=nil)then
for d_a,_aa in pairs(dc.palette)do c_a[d_a]=tonumber(_aa)end end
if(dc[b_a]~=nil)and
(dc[b_a].palette~=nil)then for d_a,_aa in pairs(dc[b_a].palette)do
c_a[d_a]=tonumber(_aa)end end;return c_a end end
local a_a={init=function(b_a)if(bc.init(b_a))then
b_a.bgColor=b_a.parent:getTheme("ImageBG")end end,getType=function(b_a)return
cc end,loadImage=function(b_a,c_a,d_a)if not(fs.exists(c_a))then
error("No valid path: "..c_a)end;dc=cb.loadImageAsBimg(c_a,d_a)
ad=1;_d=dc;if(cd~=nil)then os.cancelTimer(cd)end
b_a:updateDraw()return b_a end,setImage=function(b_a,c_a)
dc=c_a;_d=dc;ad=1;if(cd~=nil)then os.cancelTimer(cd)end
b_a:updateDraw()return b_a end,usePalette=function(b_a,c_a)dd=
c_a~=nil and c_a or true;return b_a end,play=function(b_a,c_a)
if(dc.animated)then
local d_a=
dc[ad].duration or dc.secondsPerFrame or 0.2;b_a.parent:addEvent("other_event",b_a)
cd=os.startTimer(d_a)bd=c_a or false end;return b_a end,selectFrame=function(b_a,c_a)if(
dc[c_a]~=nil)then ad=c_a;if(cd~=nil)then os.cancelTimer(cd)end
b_a:updateDraw()end end,eventHandler=function(b_a,c_a,d_a,...)
bc.eventHandler(b_a,c_a,d_a,...)
if(c_a=="timer")then
if(d_a==cd)then
if(dc[ad+1]~=nil)then ad=ad+1;local _aa=
dc[ad].duration or dc.secondsPerFrame or 0.2
cd=os.startTimer(_aa)else
if(bd)then ad=1
local _aa=dc[ad].duration or dc.secondsPerFrame or 0.2;cd=os.startTimer(_aa)end end;b_a:updateDraw()end end end,getMetadata=function(b_a,c_a)return
dc[c_a]end,getImageSize=function(b_a)return dc.width,dc.height end,resizeImage=function(b_a,c_a,d_a)
_d=cb.resizeBIMG(dc,c_a,d_a)b_a:updateDraw()return b_a end,setValuesByXMLData=function(b_a,c_a)
bc.setValuesByXMLData(b_a,c_a)
if(bb("path",c_a)~=nil)then b_a:loadImage(bb("path",c_a))end;return b_a end,draw=function(b_a)
if
(bc.draw(b_a))then
if(_d~=nil)then if(dd)then
b_a:getBaseFrame():setThemeColor(__a(ad))end;local c_a,d_a=b_a:getAnchorPosition()
local _aa,aaa=b_a:getSize()
for baa,caa in ipairs(_d[ad])do local daa,_ba,aba=db(caa)daa=_c(daa,1,_aa)
_ba=_c(_ba,1,_aa)aba=_c(aba,1,_aa)
b_a.parent:blit(c_a,d_a+baa-1,daa,_ba,aba)if(baa==aaa)then break end end end end end}return setmetatable(a_a,bc)end end
aa["objects"]["Menubar"]=function(...)local ab=da("Object")local bb=da("utils")
local cb=bb.getValueFromXML;local db=da("tHex")
return
function(_c)local ac=ab(_c)local bc="Menubar"local cc={}ac.width=30;ac.height=1
ac:setZIndex(5)local dc={}local _d;local ad;local bd=true;local cd="left"local dd=0;local __a=1;local a_a=false
local function b_a()local c_a=0;local d_a=0
local _aa=cc:getWidth()
for n=1,#dc do if(d_a+dc[n].text:len()+__a*2 >_aa)then
if(
d_a<_aa)then
c_a=c_a+ (dc[n].text:len()+__a*2 - (_aa-d_a))else c_a=c_a+dc[n].text:len()+__a*2 end end;d_a=
d_a+dc[n].text:len()+__a*2 end;return c_a end
cc={getType=function(c_a)return bc end,addItem=function(c_a,d_a,_aa,aaa,...)
table.insert(dc,{text=tostring(d_a),bgCol=_aa or c_a.bgColor,fgCol=aaa or c_a.fgColor,args={...}})if(#dc==1)then c_a:setValue(dc[1])end
c_a:updateDraw()return c_a end,getAll=function(c_a)return
dc end,getItemIndex=function(c_a)local d_a=c_a:getValue()for _aa,aaa in pairs(dc)do
if(aaa==d_a)then return _aa end end end,clear=function(c_a)
dc={}c_a:setValue({},false)c_a:updateDraw()return c_a end,setSpace=function(c_a,d_a)__a=
d_a or __a;c_a:updateDraw()return c_a end,setOffset=function(c_a,d_a)dd=
d_a or 0;if(dd<0)then dd=0 end;local _aa=b_a()if(dd>_aa)then dd=_aa end
c_a:updateDraw()return c_a end,getOffset=function(c_a)return dd end,setScrollable=function(c_a,d_a)
a_a=d_a;if(d_a==nil)then a_a=true end;return c_a end,setValuesByXMLData=function(c_a,d_a)
ac.setValuesByXMLData(c_a,d_a)if(cb("selectionBG",d_a)~=nil)then
_d=colors[cb("selectionBG",d_a)]end;if(cb("selectionFG",d_a)~=nil)then
ad=colors[cb("selectionFG",d_a)]end;if(cb("scrollable",d_a)~=nil)then
if
(cb("scrollable",d_a))then c_a:setScrollable(true)else c_a:setScrollable(false)end end
if(
cb("offset",d_a)~=nil)then c_a:setOffset(cb("offset",d_a))end
if(cb("space",d_a)~=nil)then __a=cb("space",d_a)end
if(d_a["item"]~=nil)then local _aa=d_a["item"]
if(_aa.properties~=nil)then _aa={_aa}end;for aaa,baa in pairs(_aa)do
c_a:addItem(cb("text",baa),colors[cb("bg",baa)],colors[cb("fg",baa)])end end;return c_a end,removeItem=function(c_a,d_a)
table.remove(dc,d_a)c_a:updateDraw()return c_a end,getItem=function(c_a,d_a)
return dc[d_a]end,getItemCount=function(c_a)return#dc end,editItem=function(c_a,d_a,_aa,aaa,baa,...)table.remove(dc,d_a)
table.insert(dc,d_a,{text=_aa,bgCol=
aaa or c_a.bgColor,fgCol=baa or c_a.fgColor,args={...}})c_a:updateDraw()return c_a end,selectItem=function(c_a,d_a)c_a:setValue(
dc[d_a]or{},false)c_a:updateDraw()return c_a end,setSelectedItem=function(c_a,d_a,_aa,aaa)_d=
d_a or c_a.bgColor;ad=_aa or c_a.fgColor;bd=aaa
c_a:updateDraw()return c_a end,mouseHandler=function(c_a,d_a,_aa,aaa)
if
(ac.mouseHandler(c_a,d_a,_aa,aaa))then
local baa,caa=c_a:getAbsolutePosition(c_a:getAnchorPosition())local daa,_ba=c_a:getSize()local aba=0
for n=1,#dc do
if(dc[n]~=nil)then
if
(baa+aba<=_aa+dd)and(baa+aba+
dc[n].text:len()+ (__a*2)>_aa+dd)and(caa==aaa)then
c_a:setValue(dc[n])
c_a:getEventSystem():sendEvent(event,c_a,event,0,_aa,aaa,dc[n])end;aba=aba+dc[n].text:len()+__a*2 end end;c_a:updateDraw()return true end;return false end,scrollHandler=function(c_a,d_a,_aa,aaa)
if
(ac.scrollHandler(c_a,d_a,_aa,aaa))then if(a_a)then dd=dd+d_a;if(dd<0)then dd=0 end;local baa=b_a()if(dd>baa)then dd=baa end
c_a:updateDraw()end;return true end;return false end,draw=function(c_a)
if
(ac.draw(c_a))then
if(c_a.parent~=nil)then local d_a,_aa=c_a:getAnchorPosition()
local aaa,baa=c_a:getSize()if(c_a.bgColor~=false)then
c_a.parent:drawBackgroundBox(d_a,_aa,aaa,baa,c_a.bgColor)end;local caa=""local daa=""local _ba=""
for aba,bba in pairs(dc)do
local cba=
(" "):rep(__a)..bba.text.. (" "):rep(__a)caa=caa..cba
if(bba==c_a:getValue())then daa=daa..
db[_d or bba.bgCol or c_a.bgColor]:rep(cba:len())_ba=_ba..
db[
ad or bba.FgCol or c_a.fgColor]:rep(cba:len())else daa=daa..
db[bba.bgCol or c_a.bgColor]:rep(cba:len())_ba=_ba..
db[bba.FgCol or c_a.fgColor]:rep(cba:len())end end
c_a.parent:setText(d_a,_aa,caa:sub(dd+1,aaa+dd))
c_a.parent:setBG(d_a,_aa,daa:sub(dd+1,aaa+dd))
c_a.parent:setFG(d_a,_aa,_ba:sub(dd+1,aaa+dd))end end end,init=function(c_a)
c_a.parent:addEvent("mouse_click",c_a)c_a.parent:addEvent("mouse_scroll",c_a)
if
(ac.init(c_a))then c_a.bgColor=c_a.parent:getTheme("MenubarBG")
c_a.fgColor=c_a.parent:getTheme("MenubarText")_d=c_a.parent:getTheme("SelectionBG")
ad=c_a.parent:getTheme("SelectionText")end end}return setmetatable(cc,ac)end end
aa["objects"]["Dropdown"]=function(...)local ab=da("Object")local bb=da("utils")
local cb=da("utils").getValueFromXML
return
function(db)local _c=ab(db)local ac="Dropdown"_c.width=12;_c.height=1;_c:setZIndex(6)
local bc={}local cc;local dc;local _d=true;local ad="left"local bd=0;local cd=16;local dd=6;local __a="\16"local a_a="\31"local b_a=false
local c_a={getType=function(d_a)return
ac end,setValuesByXMLData=function(d_a,_aa)_c.setValuesByXMLData(d_a,_aa)
if(
cb("selectionBG",_aa)~=nil)then cc=colors[cb("selectionBG",_aa)]end;if(cb("selectionFG",_aa)~=nil)then
dc=colors[cb("selectionFG",_aa)]end;if(cb("dropdownWidth",_aa)~=nil)then
cd=cb("dropdownWidth",_aa)end;if(cb("dropdownHeight",_aa)~=nil)then
dd=cb("dropdownHeight",_aa)end;if(cb("offset",_aa)~=nil)then
bd=cb("offset",_aa)end
if(_aa["item"]~=nil)then local aaa=_aa["item"]if(
aaa.properties~=nil)then aaa={aaa}end;for baa,caa in pairs(aaa)do
d_a:addItem(cb("text",caa),colors[cb("bg",caa)],colors[cb("fg",caa)])end end end,setOffset=function(d_a,_aa)
bd=_aa;d_a:updateDraw()return d_a end,getOffset=function(d_a)return bd end,addItem=function(d_a,_aa,aaa,baa,...)
table.insert(bc,{text=_aa,bgCol=
aaa or d_a.bgColor,fgCol=baa or d_a.fgColor,args={...}})d_a:updateDraw()return d_a end,getAll=function(d_a)return
bc end,removeItem=function(d_a,_aa)table.remove(bc,_aa)d_a:updateDraw()
return d_a end,getItem=function(d_a,_aa)return bc[_aa]end,getItemIndex=function(d_a)
local _aa=d_a:getValue()for aaa,baa in pairs(bc)do if(baa==_aa)then return aaa end end end,clear=function(d_a)
bc={}d_a:setValue({},false)d_a:updateDraw()return d_a end,getItemCount=function(d_a)return
#bc end,editItem=function(d_a,_aa,aaa,baa,caa,...)table.remove(bc,_aa)
table.insert(bc,_aa,{text=aaa,bgCol=baa or d_a.bgColor,fgCol=
caa or d_a.fgColor,args={...}})d_a:updateDraw()return d_a end,selectItem=function(d_a,_aa)d_a:setValue(
bc[_aa]or{},false)d_a:updateDraw()return d_a end,setSelectedItem=function(d_a,_aa,aaa,baa)cc=
_aa or d_a.bgColor;dc=aaa or d_a.fgColor
_d=baa~=nil and baa;d_a:updateDraw()return d_a end,setDropdownSize=function(d_a,_aa,aaa)
cd,dd=_aa,aaa;d_a:updateDraw()return d_a end,getDropdownSize=function(d_a)return cd,dd end,mouseHandler=function(d_a,_aa,aaa,baa)
if
(b_a)then
local caa,daa=d_a:getAbsolutePosition(d_a:getAnchorPosition())
if(_aa==1)then
if(#bc>0)then
for n=1,dd do
if(bc[n+bd]~=nil)then
if(caa<=aaa)and(caa+cd>aaa)and
(daa+n==baa)then d_a:setValue(bc[n+bd])
d_a:updateDraw()
local _ba=d_a:getEventSystem():sendEvent("mouse_click",d_a,"mouse_click",dir,aaa,baa)if(_ba==false)then return _ba end;return true end end end end end end
if(_c.mouseHandler(d_a,_aa,aaa,baa))then b_a=(not b_a)d_a:updateDraw()
return true else if(b_a)then d_a:updateDraw()b_a=false end;return false end end,mouseUpHandler=function(d_a,_aa,aaa,baa)
if
(b_a)then
local caa,daa=d_a:getAbsolutePosition(d_a:getAnchorPosition())
if(_aa==1)then
if(#bc>0)then
for n=1,dd do
if(bc[n+bd]~=nil)then
if(caa<=aaa)and(caa+cd>aaa)and
(daa+n==baa)then b_a=false;d_a:updateDraw()
local _ba=d_a:getEventSystem():sendEvent("mouse_up",d_a,"mouse_up",dir,aaa,baa)if(_ba==false)then return _ba end;return true end end end end end end end,scrollHandler=function(d_a,_aa,aaa,baa)
if
(b_a)and(d_a:isFocused())then bd=bd+_aa;if(bd<0)then bd=0 end;if(_aa==1)then
if(#bc>dd)then if(bd>
#bc-dd)then bd=#bc-dd end else bd=math.min(#bc-1,0)end end
local caa=d_a:getEventSystem():sendEvent("mouse_scroll",d_a,"mouse_scroll",_aa,aaa,baa)if(caa==false)then return caa end;d_a:updateDraw()return true end end,draw=function(d_a)
if
(_c.draw(d_a))then local _aa,aaa=d_a:getAnchorPosition()local baa,caa=d_a:getSize()
if(
d_a.parent~=nil)then if(d_a.bgColor~=false)then
d_a.parent:drawBackgroundBox(_aa,aaa,baa,caa,d_a.bgColor)end;local daa=d_a:getValue()
local _ba=bb.getTextHorizontalAlign((
daa~=nil and daa.text or""),baa,ad):sub(1,
baa-1).. (b_a and a_a or __a)
d_a.parent:writeText(_aa,aaa,_ba,d_a.bgColor,d_a.fgColor)
if(b_a)then
for n=1,dd do
if(bc[n+bd]~=nil)then
if(bc[n+bd]==daa)then
if(_d)then
d_a.parent:writeText(_aa,aaa+n,bb.getTextHorizontalAlign(bc[
n+bd].text,cd,ad),cc,dc)else
d_a.parent:writeText(_aa,aaa+n,bb.getTextHorizontalAlign(bc[n+bd].text,cd,ad),bc[
n+bd].bgCol,bc[n+bd].fgCol)end else
d_a.parent:writeText(_aa,aaa+n,bb.getTextHorizontalAlign(bc[n+bd].text,cd,ad),bc[
n+bd].bgCol,bc[n+bd].fgCol)end end end end end end end,init=function(d_a)
d_a.parent:addEvent("mouse_click",d_a)d_a.parent:addEvent("mouse_up",d_a)
d_a.parent:addEvent("mouse_scroll",d_a)
if(_c.init(d_a))then
d_a.bgColor=d_a.parent:getTheme("DropdownBG")d_a.fgColor=d_a.parent:getTheme("DropdownText")
cc=d_a.parent:getTheme("SelectionBG")dc=d_a.parent:getTheme("SelectionText")end end}return setmetatable(c_a,_c)end end
aa["objects"]["Animation"]=function(...)local ab=da("utils").getValueFromXML
local bb=da("basaltEvent")
local cb,db,_c,ac,bc,cc=math.floor,math.sin,math.cos,math.pi,math.sqrt,math.pow
local dc=function(cab,dab,_bb)return cab+ (dab-cab)*_bb end;local _d=function(cab)return cab end
local ad=function(cab)return 1 -cab end;local bd=function(cab)return cab*cab*cab end;local cd=function(cab)return
ad(bd(ad(cab)))end;local dd=function(cab)return
dc(bd(cab),cd(cab),cab)end;local __a=function(cab)return
db((cab*ac)/2)end;local a_a=function(cab)return
ad(_c((cab*ac)/2))end;local b_a=function(cab)return
- (_c(ac*x)-1)/2 end
local c_a=function(cab)
local dab=1.70158;local _bb=dab+1;return _bb*cab^3 -dab*cab^2 end;local d_a=function(cab)return cab^3 end
local _aa=function(cab)local dab=(2 *ac)/3;return

cab==0 and 0 or(cab==1 and 1 or(-2 ^ (10 *cab-10)*
db((cab*10 -10.75)*dab)))end
local function aaa(cab)return cab==0 and 0 or 2 ^ (10 *cab-10)end
local function baa(cab)return cab==0 and 0 or 2 ^ (10 *cab-10)end
local function caa(cab)local dab=1.70158;local _bb=dab*1.525;return
cab<0.5 and( (2 *cab)^2 *
( (_bb+1)*2 *cab-_bb))/2 or
(
(2 *cab-2)^2 * ( (_bb+1)* (cab*2 -2)+_bb)+2)/2 end;local function daa(cab)return
cab<0.5 and 4 *cab^3 or 1 - (-2 *cab+2)^3 /2 end
local function _ba(cab)
local dab=(2 *ac)/4.5
return
cab==0 and 0 or(cab==1 and 1 or
(
cab<0.5 and- (2 ^ (20 *cab-10)*
db((20 *cab-11.125)*dab))/2 or
(2 ^ (-20 *cab+10)*db((20 *cab-11.125)*dab))/2 +1))end
local function aba(cab)return
cab==0 and 0 or(cab==1 and 1 or
(
cab<0.5 and 2 ^ (20 *cab-10)/2 or(2 -2 ^ (-20 *cab+10))/2))end;local function bba(cab)return
cab<0.5 and 2 *cab^2 or 1 - (-2 *cab+2)^2 /2 end;local function cba(cab)return
cab<0.5 and 8 *
cab^4 or 1 - (-2 *cab+2)^4 /2 end;local function dba(cab)return
cab<0.5 and 16 *
cab^5 or 1 - (-2 *cab+2)^5 /2 end;local function _ca(cab)
return cab^2 end;local function aca(cab)return cab^4 end
local function bca(cab)return cab^5 end;local function cca(cab)local dab=1.70158;local _bb=dab+1;return
1 +_bb* (cab-1)^3 +dab* (cab-1)^2 end;local function dca(cab)return 1 -
(1 -cab)^3 end
local function _da(cab)local dab=(2 *ac)/3;return

cab==0 and 0 or(cab==1 and 1 or(
2 ^ (-10 *cab)*db((cab*10 -0.75)*dab)+1))end
local function ada(cab)return cab==1 and 1 or 1 -2 ^ (-10 *cab)end;local function bda(cab)return 1 - (1 -cab)* (1 -cab)end;local function cda(cab)return 1 - (
1 -cab)^4 end;local function dda(cab)
return 1 - (1 -cab)^5 end
local function __b(cab)return 1 -bc(1 -cc(cab,2))end;local function a_b(cab)return bc(1 -cc(cab-1,2))end
local function b_b(cab)return

cab<0.5 and(1 -bc(
1 -cc(2 *cab,2)))/2 or(bc(1 -cc(-2 *cab+2,2))+1)/2 end
local function c_b(cab)local dab=7.5625;local _bb=2.75
if(cab<1 /_bb)then return dab*cab*cab elseif(cab<2 /_bb)then local abb=cab-
1.5 /_bb;return dab*abb*abb+0.75 elseif(cab<2.5 /_bb)then local abb=cab-
2.25 /_bb;return dab*abb*abb+0.9375 else
local abb=cab-2.625 /_bb;return dab*abb*abb+0.984375 end end;local function d_b(cab)return 1 -c_b(1 -cab)end;local function _ab(cab)return
x<0.5 and(1 -
c_b(1 -2 *cab))/2 or(1 +c_b(2 *cab-1))/2 end
local aab={linear=_d,lerp=dc,flip=ad,easeIn=bd,easeInSine=a_a,easeInBack=c_a,easeInCubic=d_a,easeInElastic=_aa,easeInExpo=baa,easeInQuad=_ca,easeInQuart=aca,easeInQuint=bca,easeInCirc=__b,easeInBounce=d_b,easeOut=cd,easeOutSine=__a,easeOutBack=cca,easeOutCubic=dca,easeOutElastic=_da,easeOutExpo=ada,easeOutQuad=bda,easeOutQuart=cda,easeOutQuint=dda,easeOutCirc=a_b,easeOutBounce=c_b,easeInOut=dd,easeInOutSine=b_a,easeInOutBack=caa,easeInOutCubic=daa,easeInOutElastic=_ba,easeInOutExpo=aba,easeInOutQuad=bba,easeInOutQuart=cba,easeInOutQuint=dba,easeInOutCirc=b_b,easeInOutBounce=_ab}local bab={}
return
function(cab)local dab={}local _bb="Animation"local abb;local bbb={}local cbb=0;local dbb=false;local _cb=1;local acb=false
local bcb=bb()local ccb=0;local dcb;local _db=false;local adb=false;local bdb="easeOut"local cdb;local function ddb(c_c)for d_c,_ac in pairs(c_c)do
_ac(dab,bbb[_cb].t,_cb)end end
local function __c(c_c)if(_cb==1)then
c_c:animationStartHandler()end;if(bbb[_cb]~=nil)then ddb(bbb[_cb].f)
cbb=bbb[_cb].t end;_cb=_cb+1
if(bbb[_cb]==nil)then if(acb)then _cb=1;cbb=0 else
c_c:animationDoneHandler()return end end;if(bbb[_cb].t>0)then
abb=os.startTimer(bbb[_cb].t-cbb)else __c(c_c)end end
local function a_c(c_c,d_c)for n=1,#bbb do
if(bbb[n].t==c_c)then table.insert(bbb[n].f,d_c)return end end
for n=1,#bbb do
if(bbb[n].t>c_c)then if
(bbb[n-1]~=nil)then if(bbb[n-1].t<c_c)then
table.insert(bbb,n-1,{t=c_c,f={d_c}})return end else
table.insert(bbb,n,{t=c_c,f={d_c}})return end end end
if(#bbb<=0)then table.insert(bbb,1,{t=c_c,f={d_c}})return elseif(
bbb[#bbb].t<c_c)then table.insert(bbb,{t=c_c,f={d_c}})end end
local function b_c(c_c,d_c,_ac,aac,bac,cac,dac,_bc)local abc=cdb;local bbc,cbc;local dbc=""if(abc.parent~=nil)then
dbc=abc.parent:getName()end;dbc=dbc..abc:getName()
a_c(aac+0.05,function()
if
(dac~=nil)then if(bab[dac]==nil)then bab[dac]={}end;if(bab[dac][dbc]~=nil)then
if(
bab[dac][dbc]~=_bc)then bab[dac][dbc]:cancel()end end;bab[dac][dbc]=_bc end;bbc,cbc=bac(abc)end)
for n=0.05,_ac+0.01,0.05 do
a_c(aac+n,function()
local _cc=math.floor(aab.lerp(bbc,c_c,aab[bdb](n/_ac))+0.5)
local acc=math.floor(aab.lerp(cbc,d_c,aab[bdb](n/_ac))+0.5)cac(abc,_cc,acc)
if(dac~=nil)then if(n>=_ac-0.01)then if(bab[dac][dbc]==_bc)then bab[dac][dbc]=
nil end end end end)end end
dab={name=cab,getType=function(c_c)return _bb end,getBaseFrame=function(c_c)if(c_c.parent~=nil)then
return c_c.parent:getBaseFrame()end;return c_c end,setMode=function(c_c,d_c)
bdb=d_c;return c_c end,addMode=function(c_c,d_c,_ac)aab[d_c]=_ac;return c_c end,generateXMLEventFunction=function(c_c,d_c,_ac)
local aac=function(bac)
if(
bac:sub(1,1)=="#")then
local cac=c_c:getBaseFrame():getDeepObject(bac:sub(2,bac:len()))
if(cac~=nil)and(cac.internalObjetCall~=nil)then d_c(c_c,function()
cac:internalObjetCall()end)end else
d_c(c_c,c_c:getBaseFrame():getVariable(bac))end end;if(type(_ac)=="string")then aac(_ac)elseif(type(_ac)=="table")then
for bac,cac in pairs(_ac)do aac(cac)end end;return c_c end,setValuesByXMLData=function(c_c,d_c)_db=
ab("loop",d_c)==true and true or false
if(
ab("object",d_c)~=nil)then
local _ac=c_c:getBaseFrame():getDeepObject(ab("object",d_c))if(_ac==nil)then
_ac=c_c:getBaseFrame():getVariable(ab("object",d_c))end
if(_ac~=nil)then c_c:setObject(_ac)end end
if(d_c["move"]~=nil)then local _ac=ab("x",d_c["move"])
local aac=ab("y",d_c["move"])local bac=ab("duration",d_c["move"])
local cac=ab("time",d_c["move"])c_c:move(_ac,aac,bac,cac)end
if(d_c["size"]~=nil)then local _ac=ab("width",d_c["size"])
local aac=ab("height",d_c["size"])local bac=ab("duration",d_c["size"])
local cac=ab("time",d_c["size"])c_c:size(_ac,aac,bac,cac)end
if(d_c["offset"]~=nil)then local _ac=ab("x",d_c["offset"])
local aac=ab("y",d_c["offset"])local bac=ab("duration",d_c["offset"])
local cac=ab("time",d_c["offset"])c_c:offset(_ac,aac,bac,cac)end
if(d_c["textColor"]~=nil)then
local _ac=ab("duration",d_c["textColor"])local aac=ab("time",d_c["textColor"])local bac={}
local cac=d_c["textColor"]["color"]
if(cac~=nil)then if(cac.properties~=nil)then cac={cac}end;for dac,_bc in pairs(cac)do
table.insert(bac,colors[_bc:value()])end end;if(_ac~=nil)and(#bac>0)then
c_c:changeTextColor(_ac,aac or 0,table.unpack(bac))end end
if(d_c["background"]~=nil)then
local _ac=ab("duration",d_c["background"])local aac=ab("time",d_c["background"])local bac={}
local cac=d_c["background"]["color"]
if(cac~=nil)then if(cac.properties~=nil)then cac={cac}end;for dac,_bc in pairs(cac)do
table.insert(bac,colors[_bc:value()])end end;if(_ac~=nil)and(#bac>0)then
c_c:changeBackground(_ac,aac or 0,table.unpack(bac))end end
if(d_c["text"]~=nil)then local _ac=ab("duration",d_c["text"])
local aac=ab("time",d_c["text"])local bac={}local cac=d_c["text"]["text"]
if(cac~=nil)then if(cac.properties~=nil)then
cac={cac}end;for dac,_bc in pairs(cac)do
table.insert(bac,_bc:value())end end;if(_ac~=nil)and(#bac>0)then
c_c:changeText(_ac,aac or 0,table.unpack(bac))end end;if(ab("onDone",d_c)~=nil)then
c_c:generateXMLEventFunction(c_c.onDone,ab("onDone",d_c))end;if(ab("onStart",d_c)~=nil)then
c_c:generateXMLEventFunction(c_c.onDone,ab("onStart",d_c))end
if
(ab("autoDestroy",d_c)~=nil)then if(ab("autoDestroy",d_c))then adb=true end end;bdb=ab("mode",d_c)or bdb
if(ab("play",d_c)~=nil)then if
(ab("play",d_c))then c_c:play(_db)end end;return c_c end,getZIndex=function(c_c)return
1 end,getName=function(c_c)return c_c.name end,setObject=function(c_c,d_c)cdb=d_c;return c_c end,move=function(c_c,d_c,_ac,aac,bac,cac)cdb=
cac or cdb
b_c(d_c,_ac,aac,bac or 0,cdb.getPosition,cdb.setPosition,"position",c_c)return c_c end,offset=function(c_c,d_c,_ac,aac,bac,cac)cdb=
cac or cdb
b_c(d_c,_ac,aac,bac or 0,cdb.getOffset,cdb.setOffset,"offset",c_c)return c_c end,size=function(c_c,d_c,_ac,aac,bac,cac)cdb=cac or
cdb
b_c(d_c,_ac,aac,bac or 0,cdb.getSize,cdb.setSize,"size",c_c)return c_c end,changeText=function(c_c,d_c,_ac,...)
local aac={...}_ac=_ac or 0;cdb=obj or cdb;for n=1,#aac do
a_c(_ac+n* (d_c/#aac),function()
cdb.setText(cdb,aac[n])end)end;return c_c end,changeBackground=function(c_c,d_c,_ac,...)
local aac={...}_ac=_ac or 0;cdb=obj or cdb;for n=1,#aac do
a_c(_ac+n* (d_c/#aac),function()
cdb.setBackground(cdb,aac[n])end)end;return c_c end,changeTextColor=function(c_c,d_c,_ac,...)
local aac={...}_ac=_ac or 0;cdb=obj or cdb;for n=1,#aac do
a_c(_ac+n* (d_c/#aac),function()
cdb.setForeground(cdb,aac[n])end)end;return c_c end,add=function(c_c,d_c,_ac)
dcb=d_c
a_c((_ac or ccb)+
(bbb[#bbb]~=nil and bbb[#bbb].t or 0),d_c)return c_c end,wait=function(c_c,d_c)ccb=d_c;return c_c end,rep=function(c_c,d_c)
if(
dcb~=nil)then for n=1,d_c or 1 do
a_c((wait or ccb)+
(bbb[#bbb]~=nil and bbb[#bbb].t or 0),dcb)end end;return c_c end,onDone=function(c_c,d_c)
bcb:registerEvent("animation_done",d_c)return c_c end,onStart=function(c_c,d_c)
bcb:registerEvent("animation_start",d_c)return c_c end,setAutoDestroy=function(c_c,d_c)
adb=d_c~=nil and d_c or true;return c_c end,animationDoneHandler=function(c_c)
bcb:sendEvent("animation_done",c_c)c_c.parent:removeEvent("other_event",c_c)if(adb)then
c_c.parent:removeObject(c_c)c_c=nil end end,animationStartHandler=function(c_c)
bcb:sendEvent("animation_start",c_c)end,clear=function(c_c)bbb={}dcb=nil;ccb=0;_cb=1;cbb=0;acb=false;return c_c end,play=function(c_c,d_c)
c_c:cancel()dbb=true;acb=d_c and true or false;_cb=1;cbb=0
if(bbb[_cb]~=nil)then
if(
bbb[_cb].t>0)then abb=os.startTimer(bbb[_cb].t)else __c(c_c)end else c_c:animationDoneHandler()end;c_c.parent:addEvent("other_event",c_c)return c_c end,cancel=function(c_c)if(
abb~=nil)then os.cancelTimer(abb)acb=false end
dbb=false;c_c.parent:removeEvent("other_event",c_c)return c_c end,internalObjetCall=function(c_c)
c_c:play(_db)end,eventHandler=function(c_c,d_c,_ac)if(dbb)then
if(d_c=="timer")and(_ac==abb)then if(bbb[_cb]~=nil)then
__c(c_c)else c_c:animationDoneHandler()end end end end}dab.__index=dab;return dab end end
aa["objects"]["List"]=function(...)local ab=da("Object")local bb=da("utils")
local cb=bb.getValueFromXML
return
function(db)local _c=ab(db)local ac="List"_c.width=16;_c.height=6;_c:setZIndex(5)local bc={}
local cc;local dc;local _d=true;local ad="left"local bd=0;local cd=true
local dd={getType=function(__a)return ac end,addItem=function(__a,a_a,b_a,c_a,...)
table.insert(bc,{text=a_a,bgCol=b_a or __a.bgColor,fgCol=
c_a or __a.fgColor,args={...}})if(#bc<=1)then __a:setValue(bc[1],false)end
__a:updateDraw()return __a end,setOffset=function(__a,a_a)
bd=a_a;__a:updateDraw()return __a end,getOffset=function(__a)return bd end,removeItem=function(__a,a_a)
table.remove(bc,a_a)__a:updateDraw()return __a end,getItem=function(__a,a_a)
return bc[a_a]end,getAll=function(__a)return bc end,getItemIndex=function(__a)local a_a=__a:getValue()for b_a,c_a in pairs(bc)do if
(c_a==a_a)then return b_a end end end,clear=function(__a)
bc={}__a:setValue({},false)__a:updateDraw()return __a end,getItemCount=function(__a)return
#bc end,editItem=function(__a,a_a,b_a,c_a,d_a,...)table.remove(bc,a_a)
table.insert(bc,a_a,{text=b_a,bgCol=c_a or __a.bgColor,fgCol=
d_a or __a.fgColor,args={...}})__a:updateDraw()return __a end,selectItem=function(__a,a_a)__a:setValue(
bc[a_a]or{},false)__a:updateDraw()return __a end,setSelectedItem=function(__a,a_a,b_a,c_a)cc=
a_a or __a.bgColor;dc=b_a or __a.fgColor;_d=c_a~=nil and c_a or
true;__a:updateDraw()return __a end,setScrollable=function(__a,a_a)
cd=a_a;if(a_a==nil)then cd=true end;__a:updateDraw()return __a end,setValuesByXMLData=function(__a,a_a)
_c.setValuesByXMLData(__a,a_a)if(cb("selectionBG",a_a)~=nil)then
cc=colors[cb("selectionBG",a_a)]end;if(cb("selectionFG",a_a)~=nil)then
dc=colors[cb("selectionFG",a_a)]end;if(cb("scrollable",a_a)~=nil)then
if
(cb("scrollable",a_a))then __a:setScrollable(true)else __a:setScrollable(false)end end;if(
cb("offset",a_a)~=nil)then bd=cb("offset",a_a)end
if(a_a["item"]~=
nil)then local b_a=a_a["item"]
if(b_a.properties~=nil)then b_a={b_a}end;for c_a,d_a in pairs(b_a)do
__a:addItem(cb("text",d_a),colors[cb("bg",d_a)],colors[cb("fg",d_a)])end end;return __a end,scrollHandler=function(__a,a_a,b_a,c_a)
if
(_c.scrollHandler(__a,a_a,b_a,c_a))then
if(cd)then local d_a,_aa=__a:getSize()bd=bd+a_a;if(bd<0)then bd=0 end
if(a_a>=1)then if(#bc>_aa)then if(bd>
#bc-_aa)then bd=#bc-_aa end;if(bd>=#bc)then bd=#bc-1 end else bd=
bd-1 end end;__a:updateDraw()end;return true end;return false end,mouseHandler=function(__a,a_a,b_a,c_a)
if
(_c.mouseHandler(__a,a_a,b_a,c_a))then
local d_a,_aa=__a:getAbsolutePosition(__a:getAnchorPosition())local aaa,baa=__a:getSize()
if(#bc>0)then for n=1,baa do
if(bc[n+bd]~=nil)then if(d_a<=b_a)and
(d_a+aaa>b_a)and(_aa+n-1 ==c_a)then
__a:setValue(bc[n+bd])__a:updateDraw()end end end end;return true end;return false end,dragHandler=function(__a,a_a,b_a,c_a)return
__a:mouseHandler(a_a,b_a,c_a)end,touchHandler=function(__a,a_a,b_a)return
__a:mouseHandler(1,a_a,b_a)end,draw=function(__a)
if(_c.draw(__a))then
if
(__a.parent~=nil)then local a_a,b_a=__a:getAnchorPosition()local c_a,d_a=__a:getSize()if(
__a.bgColor~=false)then
__a.parent:drawBackgroundBox(a_a,b_a,c_a,d_a,__a.bgColor)end
for n=1,d_a do
if(bc[n+bd]~=nil)then
if(bc[n+bd]==
__a:getValue())then
if(_d)then
__a.parent:writeText(a_a,b_a+n-1,bb.getTextHorizontalAlign(bc[n+bd].text,c_a,ad),cc,dc)else
__a.parent:writeText(a_a,b_a+n-1,bb.getTextHorizontalAlign(bc[n+bd].text,c_a,ad),bc[
n+bd].bgCol,bc[n+bd].fgCol)end else
__a.parent:writeText(a_a,b_a+n-1,bb.getTextHorizontalAlign(bc[n+bd].text,c_a,ad),bc[
n+bd].bgCol,bc[n+bd].fgCol)end end end end end end,init=function(__a)
__a.parent:addEvent("mouse_click",__a)__a.parent:addEvent("mouse_drag",__a)
__a.parent:addEvent("mouse_scroll",__a)
if(_c.init(__a))then __a.bgColor=__a.parent:getTheme("ListBG")
__a.fgColor=__a.parent:getTheme("ListText")cc=__a.parent:getTheme("SelectionBG")
dc=__a.parent:getTheme("SelectionText")end end}return setmetatable(dd,_c)end end
aa["objects"]["Pane"]=function(...)local ab=da("Object")local bb=da("basaltLogs")
return
function(cb)
local db=ab(cb)local _c="Pane"
local ac={getType=function(bc)return _c end,setBackground=function(bc,cc,dc,_d)db.setBackground(bc,cc,dc,_d)
return bc end,init=function(bc)
if(db.init(bc))then
bc.bgColor=bc.parent:getTheme("PaneBG")bc.fgColor=bc.parent:getTheme("PaneBG")end end}return setmetatable(ac,db)end end
aa["objects"]["Program"]=function(...)local ab=da("Object")local bb=da("tHex")
local cb=da("process")local db=da("utils").getValueFromXML;local _c=string.sub
return
function(ac,bc)local cc=ab(ac)
local dc="Program"cc:setZIndex(5)local _d;local ad;local bd={}
local function cd(baa,caa,daa,_ba,aba)local bba,cba=1,1
local dba,_ca=colors.black,colors.white;local aca=false;local bca=false;local cca={}local dca={}local _da={}local ada={}local bda;local cda={}for i=0,15 do local abb=2 ^i
ada[abb]={bc:getBasaltInstance().getBaseTerm().getPaletteColour(abb)}end;local function dda()
bda=(" "):rep(daa)
for n=0,15 do local abb=2 ^n;local bbb=bb[abb]cda[abb]=bbb:rep(daa)end end
local function __b()dda()local abb=bda
local bbb=cda[colors.white]local cbb=cda[colors.black]
for n=1,_ba do
cca[n]=_c(cca[n]==nil and abb or cca[n]..abb:sub(1,
daa-cca[n]:len()),1,daa)
_da[n]=_c(_da[n]==nil and bbb or _da[n]..
bbb:sub(1,daa-_da[n]:len()),1,daa)
dca[n]=_c(dca[n]==nil and cbb or dca[n]..
cbb:sub(1,daa-dca[n]:len()),1,daa)end;cc.updateDraw(cc)end;__b()local function a_b()if
bba>=1 and cba>=1 and bba<=daa and cba<=_ba then else end end
local function b_b(abb,bbb,cbb)
local dbb=bba;local _cb=dbb+#abb-1
if cba>=1 and cba<=_ba then
if dbb<=daa and _cb>=1 then
if dbb==1 and _cb==
daa then cca[cba]=abb;_da[cba]=bbb;dca[cba]=cbb else local acb,bcb,ccb
if dbb<1 then local __c=
1 -dbb+1;local a_c=daa-dbb+1;acb=_c(abb,__c,a_c)
bcb=_c(bbb,__c,a_c)ccb=_c(cbb,__c,a_c)elseif _cb>daa then local __c=daa-dbb+1;acb=_c(abb,1,__c)
bcb=_c(bbb,1,__c)ccb=_c(cbb,1,__c)else acb=abb;bcb=bbb;ccb=cbb end;local dcb=cca[cba]local _db=_da[cba]local adb=dca[cba]local bdb,cdb,ddb
if dbb>1 then local __c=dbb-1;bdb=
_c(dcb,1,__c)..acb;cdb=_c(_db,1,__c)..bcb
ddb=_c(adb,1,__c)..ccb else bdb=acb;cdb=bcb;ddb=ccb end
if _cb<daa then local __c=_cb+1;bdb=bdb.._c(dcb,__c,daa)
cdb=cdb.._c(_db,__c,daa)ddb=ddb.._c(adb,__c,daa)end;cca[cba]=bdb;_da[cba]=cdb;dca[cba]=ddb end;_d:updateDraw()end;bba=_cb+1;if(bca)then a_b()end end end
local function c_b(abb,bbb,cbb)
if(cbb~=nil)then local dbb=cca[bbb]if(dbb~=nil)then
cca[bbb]=_c(dbb:sub(1,abb-1)..cbb..dbb:sub(abb+
(cbb:len()),daa),1,daa)end end;_d:updateDraw()end
local function d_b(abb,bbb,cbb)
if(cbb~=nil)then local dbb=dca[bbb]if(dbb~=nil)then
dca[bbb]=_c(dbb:sub(1,abb-1)..cbb..dbb:sub(abb+
(cbb:len()),daa),1,daa)end end;_d:updateDraw()end
local function _ab(abb,bbb,cbb)
if(cbb~=nil)then local dbb=_da[bbb]if(dbb~=nil)then
_da[bbb]=_c(dbb:sub(1,abb-1)..cbb..dbb:sub(abb+
(cbb:len()),daa),1,daa)end end;_d:updateDraw()end
local aab=function(abb)
if type(abb)~="number"then
error("bad argument #1 (expected number, got "..type(abb)..")",2)elseif bb[abb]==nil then
error("Invalid color (got "..abb..")",2)end;_ca=abb end
local bab=function(abb)
if type(abb)~="number"then
error("bad argument #1 (expected number, got "..type(abb)..")",2)elseif bb[abb]==nil then
error("Invalid color (got "..abb..")",2)end;dba=abb end
local cab=function(abb,bbb,cbb,dbb)if type(abb)~="number"then
error("bad argument #1 (expected number, got "..type(abb)..")",2)end
if bb[abb]==nil then error("Invalid color (got "..
abb..")",2)end;local _cb
if
type(bbb)=="number"and cbb==nil and dbb==nil then _cb={colours.rgb8(bbb)}ada[abb]=_cb else if
type(bbb)~="number"then
error("bad argument #2 (expected number, got "..type(bbb)..")",2)end;if type(cbb)~="number"then
error(
"bad argument #3 (expected number, got "..type(cbb)..")",2)end;if type(dbb)~="number"then
error(
"bad argument #4 (expected number, got "..type(dbb)..")",2)end;_cb=ada[abb]_cb[1]=bbb
_cb[2]=cbb;_cb[3]=dbb end end
local dab=function(abb)if type(abb)~="number"then
error("bad argument #1 (expected number, got "..type(abb)..")",2)end
if bb[abb]==nil then error("Invalid color (got "..
abb..")",2)end;local bbb=ada[abb]return bbb[1],bbb[2],bbb[3]end
local _bb={setCursorPos=function(abb,bbb)if type(abb)~="number"then
error("bad argument #1 (expected number, got "..type(abb)..")",2)end;if type(bbb)~="number"then
error(
"bad argument #2 (expected number, got "..type(bbb)..")",2)end;bba=math.floor(abb)
cba=math.floor(bbb)if(bca)then a_b()end end,getCursorPos=function()return
bba,cba end,setCursorBlink=function(abb)if type(abb)~="boolean"then
error("bad argument #1 (expected boolean, got "..
type(abb)..")",2)end;aca=abb end,getCursorBlink=function()return
aca end,getPaletteColor=dab,getPaletteColour=dab,setBackgroundColor=bab,setBackgroundColour=bab,setTextColor=aab,setTextColour=aab,setPaletteColor=cab,setPaletteColour=cab,getBackgroundColor=function()return dba end,getBackgroundColour=function()return dba end,getSize=function()
return daa,_ba end,getTextColor=function()return _ca end,getTextColour=function()return _ca end,basalt_resize=function(abb,bbb)daa,_ba=abb,bbb;__b()end,basalt_reposition=function(abb,bbb)
baa,caa=abb,bbb end,basalt_setVisible=function(abb)bca=abb end,drawBackgroundBox=function(abb,bbb,cbb,dbb,_cb)for n=1,dbb do
d_b(abb,bbb+ (n-1),bb[_cb]:rep(cbb))end end,drawForegroundBox=function(abb,bbb,cbb,dbb,_cb)
for n=1,dbb do _ab(abb,
bbb+ (n-1),bb[_cb]:rep(cbb))end end,drawTextBox=function(abb,bbb,cbb,dbb,_cb)for n=1,dbb do
c_b(abb,bbb+ (n-1),_cb:rep(cbb))end end,writeText=function(abb,bbb,cbb,dbb,_cb)
dbb=dbb or dba;_cb=_cb or _ca;c_b(baa,bbb,cbb)
d_b(abb,bbb,bb[dbb]:rep(cbb:len()))_ab(abb,bbb,bb[_cb]:rep(cbb:len()))end,basalt_update=function()
if(
bc~=nil)then for n=1,_ba do bc:setText(baa,caa+ (n-1),cca[n])bc:setBG(baa,caa+
(n-1),dca[n])
bc:setFG(baa,caa+ (n-1),_da[n])end end end,scroll=function(abb)if
type(abb)~="number"then
error("bad argument #1 (expected number, got "..type(abb)..")",2)end
if abb~=0 then local bbb=bda
local cbb=cda[_ca]local dbb=cda[dba]
for newY=1,_ba do local _cb=newY+abb
if _cb>=1 and _cb<=_ba then
cca[newY]=cca[_cb]dca[newY]=dca[_cb]_da[newY]=_da[_cb]else cca[newY]=bbb
_da[newY]=cbb;dca[newY]=dbb end end end;if(bca)then a_b()end end,isColor=function()return
bc:getBasaltInstance().getBaseTerm().isColor()end,isColour=function()return
bc:getBasaltInstance().getBaseTerm().isColor()end,write=function(abb)
abb=tostring(abb)if(bca)then
b_b(abb,bb[_ca]:rep(abb:len()),bb[dba]:rep(abb:len()))end end,clearLine=function()
if
(bca)then c_b(1,cba,(" "):rep(daa))
d_b(1,cba,bb[dba]:rep(daa))_ab(1,cba,bb[_ca]:rep(daa))end;if(bca)then a_b()end end,clear=function()
for n=1,_ba
do c_b(1,n,(" "):rep(daa))
d_b(1,n,bb[dba]:rep(daa))_ab(1,n,bb[_ca]:rep(daa))end;if(bca)then a_b()end end,blit=function(abb,bbb,cbb)if
type(abb)~="string"then
error("bad argument #1 (expected string, got "..type(abb)..")",2)end;if type(bbb)~="string"then
error(
"bad argument #2 (expected string, got "..type(bbb)..")",2)end;if type(cbb)~="string"then
error(
"bad argument #3 (expected string, got "..type(cbb)..")",2)end
if
#bbb~=#abb or#cbb~=#abb then error("Arguments must be the same length",2)end;if(bca)then b_b(abb,bbb,cbb)end end}return _bb end;cc.width=30;cc.height=12;local dd=cd(1,1,cc.width,cc.height)local __a
local a_a=false;local b_a={}
local function c_a(baa)local caa,daa=dd.getCursorPos()
local _ba,aba=baa:getAnchorPosition()local bba,cba=baa:getSize()
if(_ba+caa-1 >=1 and
_ba+caa-1 <=_ba+bba-1 and daa+aba-1 >=1 and
daa+aba-1 <=aba+cba-1)then
baa.parent:setCursor(
baa:isFocused()and dd.getCursorBlink(),_ba+caa-1,daa+aba-1,dd.getTextColor())end end
local function d_a(baa,caa,...)local daa,_ba=__a:resume(caa,...)
if(daa==false)and(_ba~=nil)and
(_ba~="Terminated")then
local aba=baa:sendEvent("program_error",_ba)
if(aba~=false)then error("Basalt Program - ".._ba)end end
if(__a:getStatus()=="dead")then baa:sendEvent("program_done")end end
local function _aa(baa,caa,daa,_ba,aba)if(__a==nil)then return false end
if not(__a:isDead())then if not(a_a)then
local bba,cba=baa:getAbsolutePosition(baa:getAnchorPosition(
nil,nil,true))d_a(baa,caa,daa,_ba-bba+1,aba-cba+1)
c_a(baa)end end end
local function aaa(baa,caa,daa,_ba)if(__a==nil)then return false end
if not(__a:isDead())then if not(a_a)then if(baa.draw)then
d_a(baa,caa,daa,_ba)c_a(baa)end end end end
_d={getType=function(baa)return dc end,show=function(baa)cc.show(baa)
dd.setBackgroundColor(baa.bgColor)dd.setTextColor(baa.fgColor)
dd.basalt_setVisible(true)return baa end,hide=function(baa)
cc.hide(baa)dd.basalt_setVisible(false)return baa end,setPosition=function(baa,caa,daa,_ba)
cc.setPosition(baa,caa,daa,_ba)
dd.basalt_reposition(baa:getAnchorPosition())return baa end,setValuesByXMLData=function(baa,caa)
cc.setValuesByXMLData(baa,caa)if(db("path",caa)~=nil)then ad=db("path",caa)end
if(
db("execute",caa)~=nil)then if(db("execute",caa))then
if(ad~=nil)then baa:execute(ad)end end end end,getBasaltWindow=function()return
dd end,getBasaltProcess=function()return __a end,setSize=function(baa,caa,daa,_ba)cc.setSize(baa,caa,daa,_ba)
dd.basalt_resize(baa:getWidth(),baa:getHeight())return baa end,getStatus=function(baa)if(__a~=nil)then return
__a:getStatus()end;return"inactive"end,setEnviroment=function(baa,caa)bd=
caa or{}return baa end,execute=function(baa,caa,...)ad=caa or ad
__a=cb:new(ad,dd,bd,...)dd.setBackgroundColor(colors.black)
dd.setTextColor(colors.white)dd.clear()dd.setCursorPos(1,1)
dd.setBackgroundColor(baa.bgColor)dd.setTextColor(baa.fgColor)
dd.basalt_setVisible(true)d_a(baa)a_a=false
if(baa.parent~=nil)then
baa.parent:addEvent("mouse_click",baa)baa.parent:addEvent("mouse_up",baa)
baa.parent:addEvent("mouse_drag",baa)baa.parent:addEvent("mouse_scroll",baa)
baa.parent:addEvent("key",baa)baa.parent:addEvent("key_up",baa)
baa.parent:addEvent("char",baa)baa.parent:addEvent("other_event",baa)end;return baa end,stop=function(baa)
if(
__a~=nil)then
if not(__a:isDead())then d_a(baa,"terminate")if(__a:isDead())then
if(
baa.parent~=nil)then baa.parent:setCursor(false)end end end end;baa.parent:removeEvents(baa)return baa end,pause=function(baa,caa)a_a=
caa or(not a_a)
if(__a~=nil)then if not(__a:isDead())then if not(a_a)then
baa:injectEvents(b_a)b_a={}end end end;return baa end,isPaused=function(baa)return
a_a end,injectEvent=function(baa,caa,daa,_ba,aba,bba,cba)
if(__a~=nil)then
if not(__a:isDead())then if(a_a==false)or(cba)then
d_a(baa,caa,daa,_ba,aba,bba)else
table.insert(b_a,{event=caa,args={daa,_ba,aba,bba}})end end end;return baa end,getQueuedEvents=function(baa)return
b_a end,updateQueuedEvents=function(baa,caa)b_a=caa or b_a;return baa end,injectEvents=function(baa,caa)if(__a~=nil)then
if not
(__a:isDead())then for daa,_ba in pairs(caa)do
d_a(baa,_ba.event,table.unpack(_ba.args))end end end;return baa end,mouseHandler=function(baa,caa,daa,_ba)
if
(cc.mouseHandler(baa,caa,daa,_ba))then _aa(baa,"mouse_click",caa,daa,_ba)return true end;return false end,mouseUpHandler=function(baa,caa,daa,_ba)
if
(cc.mouseUpHandler(baa,caa,daa,_ba))then _aa(baa,"mouse_up",caa,daa,_ba)return true end;return false end,scrollHandler=function(baa,caa,daa,_ba)
if
(cc.scrollHandler(baa,caa,daa,_ba))then _aa(baa,"mouse_scroll",caa,daa,_ba)return true end;return false end,dragHandler=function(baa,caa,daa,_ba)
if
(cc.dragHandler(baa,caa,daa,_ba))then _aa(baa,"mouse_drag",caa,daa,_ba)return true end;return false end,keyHandler=function(baa,caa,daa)if
(cc.keyHandler(baa,caa,daa))then aaa(baa,"key",caa,daa)return true end;return
false end,keyUpHandler=function(baa,caa)if
(cc.keyUpHandler(baa,caa))then aaa(baa,"key_up",caa)return true end
return false end,charHandler=function(baa,caa)if
(cc.charHandler(baa,caa))then aaa(baa,"char",caa)return true end
return false end,getFocusHandler=function(baa)
cc.getFocusHandler(baa)
if(__a~=nil)then
if not(__a:isDead())then
if not(a_a)then
if(baa.parent~=nil)then
local caa,daa=dd.getCursorPos()local _ba,aba=baa:getAnchorPosition()local bba,cba=baa:getSize()
if
(
_ba+caa-1 >=1 and _ba+caa-1 <=_ba+bba-1 and
daa+aba-1 >=1 and daa+aba-1 <=aba+cba-1)then
baa.parent:setCursor(dd.getCursorBlink(),_ba+caa-1,daa+aba-1,dd.getTextColor())end end end end end end,loseFocusHandler=function(baa)
cc.loseFocusHandler(baa)
if(__a~=nil)then if not(__a:isDead())then if(baa.parent~=nil)then
baa.parent:setCursor(false)end end end end,customEventHandler=function(baa,caa,...)
cc.customEventHandler(baa,caa,...)if(__a==nil)then return end
if(caa=="basalt_resize")then local daa,_ba=dd.getSize()
local aba,bba=baa:getSize()
if(daa~=aba)or(_ba~=bba)then dd.basalt_resize(aba,bba)if not
(__a:isDead())then d_a(baa,"term_resize")end end
dd.basalt_reposition(baa:getAnchorPosition())end end,eventHandler=function(baa,caa,daa,_ba,aba,bba)
cc.eventHandler(baa,caa,daa,_ba,aba,bba)if(__a==nil)then return end
if not(__a:isDead())then
if not(a_a)then if(caa~="terminate")then
d_a(baa,caa,daa,_ba,aba,bba)end
if(baa:isFocused())then
local cba,dba=baa:getAnchorPosition()local _ca,aca=dd.getCursorPos()
if(baa.parent~=nil)then
local bca,cca=baa:getSize()
if
(cba+_ca-1 >=1 and cba+_ca-1 <=cba+bca-1 and
aca+dba-1 >=1 and aca+dba-1 <=dba+cca-1)then
baa.parent:setCursor(dd.getCursorBlink(),cba+_ca-1,aca+dba-1,dd.getTextColor())end end;if(caa=="terminate")then d_a(baa,caa)
baa.parent:setCursor(false)return true end end else
table.insert(b_a,{event=caa,args={daa,_ba,aba,bba}})end end end,draw=function(baa)
if
(cc.draw(baa))then
if(baa.parent~=nil)then local caa,daa=baa:getAnchorPosition()
local _ba,aba=dd.getCursorPos()local bba,cba=baa:getSize()dd.basalt_reposition(caa,daa)
dd.basalt_update()
if
(caa+_ba-1 >=1 and caa+_ba-1 <=caa+bba-1 and
aba+daa-1 >=1 and aba+daa-1 <=daa+cba-1)then
baa.parent:setCursor(baa:isFocused()and dd.getCursorBlink(),
caa+_ba-1,aba+daa-1,dd.getTextColor())end end end end,onError=function(baa,...)
for caa,daa in
pairs(table.pack(...))do if(type(daa)=="function")then
baa:registerEvent("program_error",daa)end end;if(baa.parent~=nil)then
baa.parent:addEvent("other_event",baa)end;return baa end,onDone=function(baa,...)
for caa,daa in
pairs(table.pack(...))do if(type(daa)=="function")then
baa:registerEvent("program_done",daa)end end;if(baa.parent~=nil)then
baa.parent:addEvent("other_event",baa)end;return baa end,init=function(baa)
if
(cc.init(baa))then baa.bgColor=baa.parent:getTheme("ProgramBG")end end}return setmetatable(_d,cc)end end
aa["objects"]["Progressbar"]=function(...)local ab=da("Object")
local bb=da("utils").getValueFromXML
return
function(cb)local db=ab(cb)local _c="Progressbar"local ac=0;db:setZIndex(5)
db:setValue(false)db.width=25;db.height=1;local bc;local cc=""local dc=colors.white;local _d=""local ad=0
local bd={init=function(cd)
if
(db.init(cd))then cd.bgColor=cd.parent:getTheme("ProgressbarBG")
cd.fgColor=cd.parent:getTheme("ProgressbarText")bc=cd.parent:getTheme("ProgressbarActiveBG")end end,getType=function(cd)return
_c end,setValuesByXMLData=function(cd,dd)db.setValuesByXMLData(cd,dd)if(bb("direction",dd)~=
nil)then ad=bb("direction",dd)end
if(
bb("progressColor",dd)~=nil)then bc=colors[bb("progressColor",dd)]end
if(bb("progressSymbol",dd)~=nil)then cc=bb("progressSymbol",dd)end;if(bb("backgroundSymbol",dd)~=nil)then
_d=bb("backgroundSymbol",dd)end
if
(bb("progressSymbolColor",dd)~=nil)then dc=colors[bb("progressSymbolColor",dd)]end;if(bb("onDone",dd)~=nil)then
cd:generateXMLEventFunction(cd.onProgressDone,bb("onDone",dd))end;return cd end,setDirection=function(cd,dd)
ad=dd;cd:updateDraw()return cd end,setProgressBar=function(cd,dd,__a,a_a)bc=dd or bc
cc=__a or cc;dc=a_a or dc;cd:updateDraw()return cd end,setBackgroundSymbol=function(cd,dd)
_d=dd:sub(1,1)cd:updateDraw()return cd end,setProgress=function(cd,dd)if
(dd>=0)and(dd<=100)and(ac~=dd)then ac=dd;cd:setValue(ac)if(ac==100)then
cd:progressDoneHandler()end end
cd:updateDraw()return cd end,getProgress=function(cd)return
ac end,onProgressDone=function(cd,dd)cd:registerEvent("progress_done",dd)
return cd end,progressDoneHandler=function(cd)
cd:sendEvent("progress_done",cd)end,draw=function(cd)
if(db.draw(cd))then
if(cd.parent~=nil)then
local dd,__a=cd:getAnchorPosition()local a_a,b_a=cd:getSize()if(cd.bgColor~=false)then
cd.parent:drawBackgroundBox(dd,__a,a_a,b_a,cd.bgColor)end;if(_d~="")then
cd.parent:drawTextBox(dd,__a,a_a,b_a,_d)end;if(cd.fgColor~=false)then
cd.parent:drawForegroundBox(dd,__a,a_a,b_a,cd.fgColor)end
if(ad==1)then cd.parent:drawBackgroundBox(dd,__a,a_a,
b_a/100 *ac,bc)cd.parent:drawForegroundBox(dd,__a,a_a,
b_a/100 *ac,dc)cd.parent:drawTextBox(dd,__a,a_a,
b_a/100 *ac,cc)elseif(ad==2)then
cd.parent:drawBackgroundBox(dd,
__a+math.ceil(b_a-b_a/100 *ac),a_a,b_a/100 *ac,bc)
cd.parent:drawForegroundBox(dd,__a+math.ceil(b_a-b_a/100 *ac),a_a,
b_a/100 *ac,dc)
cd.parent:drawTextBox(dd,__a+math.ceil(b_a-b_a/100 *ac),a_a,
b_a/100 *ac,cc)elseif(ad==3)then
cd.parent:drawBackgroundBox(dd+math.ceil(a_a-a_a/100 *ac),__a,
a_a/100 *ac,b_a,bc)
cd.parent:drawForegroundBox(dd+math.ceil(a_a-a_a/100 *ac),__a,
a_a/100 *ac,b_a,dc)
cd.parent:drawTextBox(dd+math.ceil(a_a-a_a/100 *ac),__a,
a_a/100 *ac,b_a,cc)else
cd.parent:drawBackgroundBox(dd,__a,a_a/100 *ac,b_a,bc)
cd.parent:drawForegroundBox(dd,__a,a_a/100 *ac,b_a,dc)
cd.parent:drawTextBox(dd,__a,a_a/100 *ac,b_a,cc)end end end end}return setmetatable(bd,db)end end
aa["objects"]["Scrollbar"]=function(...)local ab=da("Object")
local bb=da("utils").getValueFromXML
return
function(cb)local db=ab(cb)local _c="Scrollbar"db.width=1;db.height=8;db:setValue(1)
db:setZIndex(2)local ac="vertical"local bc=" "local cc;local dc="\127"local _d=db.height;local ad=1;local bd=1
local function cd(__a,a_a,b_a,c_a)
local d_a,_aa=__a:getAbsolutePosition(__a:getAnchorPosition())local aaa,baa=__a:getSize()
if(ac=="horizontal")then
for _index=0,aaa do
if
(d_a+_index==b_a)and(_aa<=c_a)and(_aa+baa>c_a)then
ad=math.min(_index+1,aaa- (bd-1))__a:setValue(_d/aaa* (ad))__a:updateDraw()end end end
if(ac=="vertical")then
for _index=0,baa do
if
(_aa+_index==c_a)and(d_a<=b_a)and(d_a+aaa>b_a)then ad=math.min(_index+1,baa- (bd-1))
__a:setValue(_d/baa* (ad))__a:updateDraw()end end end end
local dd={getType=function(__a)return _c end,setSymbol=function(__a,a_a)bc=a_a:sub(1,1)__a:updateDraw()return __a end,setValuesByXMLData=function(__a,a_a)
db.setValuesByXMLData(__a,a_a)
if(bb("maxValue",a_a)~=nil)then _d=bb("maxValue",a_a)end;if(bb("backgroundSymbol",a_a)~=nil)then
dc=bb("backgroundSymbol",a_a):sub(1,1)end;if(bb("symbol",a_a)~=nil)then
bc=bb("symbol",a_a):sub(1,1)end;if(bb("barType",a_a)~=nil)then
ac=bb("barType",a_a):lower()end;if(bb("symbolSize",a_a)~=nil)then
__a:setSymbolSize(bb("symbolSize",a_a))end;if(bb("symbolColor",a_a)~=nil)then
cc=colors[bb("symbolColor",a_a)]end;if(bb("index",a_a)~=nil)then
__a:setIndex(bb("index",a_a))end end,setIndex=function(__a,a_a)
ad=a_a;if(ad<1)then ad=1 end;local b_a,c_a=__a:getSize()
ad=math.min(ad,(
ac=="vertical"and c_a or b_a)- (bd-1))
__a:setValue(_d/ (ac=="vertical"and c_a or b_a)*ad)__a:updateDraw()return __a end,getIndex=function(__a)return
ad end,setSymbolSize=function(__a,a_a)bd=tonumber(a_a)or 1
local b_a,c_a=__a:getSize()
if(ac=="vertical")then
__a:setValue(ad-1 * (_d/ (c_a- (bd-1)))- (_d/ (c_a-
(bd-1))))elseif(ac=="horizontal")then
__a:setValue(ad-1 * (_d/ (b_a- (bd-1)))- (_d/ (b_a- (
bd-1))))end;__a:updateDraw()return __a end,setMaxValue=function(__a,a_a)
_d=a_a;__a:updateDraw()return __a end,setBackgroundSymbol=function(__a,a_a)
dc=string.sub(a_a,1,1)__a:updateDraw()return __a end,setSymbolColor=function(__a,a_a)cc=a_a
__a:updateDraw()return __a end,setBarType=function(__a,a_a)ac=a_a:lower()
__a:updateDraw()return __a end,mouseHandler=function(__a,a_a,b_a,c_a)if(db.mouseHandler(__a,a_a,b_a,c_a))then
cd(__a,a_a,b_a,c_a)return true end;return false end,dragHandler=function(__a,a_a,b_a,c_a)if
(db.dragHandler(__a,a_a,b_a,c_a))then cd(__a,a_a,b_a,c_a)return true end
return false end,scrollHandler=function(__a,a_a,b_a,c_a)
if
(db.scrollHandler(__a,a_a,b_a,c_a))then local d_a,_aa=__a:getSize()ad=ad+a_a;if(ad<1)then ad=1 end
ad=math.min(ad,(
ac=="vertical"and _aa or d_a)- (bd-1))
__a:setValue(_d/ (ac=="vertical"and _aa or d_a)*ad)__a:updateDraw()end end,draw=function(__a)
if
(db.draw(__a))then
if(__a.parent~=nil)then local a_a,b_a=__a:getAnchorPosition()
local c_a,d_a=__a:getSize()
if(ac=="horizontal")then
__a.parent:writeText(a_a,b_a,dc:rep(ad-1),__a.bgColor,__a.fgColor)
__a.parent:writeText(a_a+ad-1,b_a,bc:rep(bd),cc,cc)
__a.parent:writeText(a_a+ad+bd-1,b_a,dc:rep(c_a- (ad+bd-1)),__a.bgColor,__a.fgColor)end
if(ac=="vertical")then
for n=0,d_a-1 do
if(ad==n+1)then
for curIndexOffset=0,math.min(bd-1,d_a)do __a.parent:writeText(a_a,b_a+n+
curIndexOffset,bc,cc,cc)end else if(n+1 <ad)or(n+1 >ad-1 +bd)then
__a.parent:writeText(a_a,b_a+n,dc,__a.bgColor,__a.fgColor)end end end end end end end,init=function(__a)
__a.parent:addEvent("mouse_click",__a)__a.parent:addEvent("mouse_drag",__a)
__a.parent:addEvent("mouse_scroll",__a)
if(db.init(__a))then
__a.bgColor=__a.parent:getTheme("ScrollbarBG")__a.fgColor=__a.parent:getTheme("ScrollbarText")
cc=__a.parent:getTheme("ScrollbarSymbolColor")end end}return setmetatable(dd,db)end end
aa["objects"]["Radio"]=function(...)local ab=da("Object")local bb=da("utils")
local cb=bb.getValueFromXML
return
function(db)local _c=ab(db)local ac="Radio"_c.width=8;_c:setZIndex(5)local bc={}local cc;local dc
local _d;local ad;local bd;local cd;local dd=true;local __a="\7"local a_a="left"
local b_a={getType=function(c_a)return ac end,setValuesByXMLData=function(c_a,d_a)
_c.setValuesByXMLData(c_a,d_a)if(cb("selectionBG",d_a)~=nil)then
cc=colors[cb("selectionBG",d_a)]end;if(cb("selectionFG",d_a)~=nil)then
dc=colors[cb("selectionFG",d_a)]end;if(cb("boxBG",d_a)~=nil)then
_d=colors[cb("boxBG",d_a)]end;if(cb("inactiveBoxBG",d_a)~=nil)then
bd=colors[cb("inactiveBoxBG",d_a)]end;if(cb("inactiveBoxFG",d_a)~=nil)then
cd=colors[cb("inactiveBoxFG",d_a)]end;if(cb("boxFG",d_a)~=nil)then
ad=colors[cb("boxFG",d_a)]end;if(cb("symbol",d_a)~=nil)then
__a=cb("symbol",d_a)end
if(d_a["item"]~=nil)then local _aa=d_a["item"]if(
_aa.properties~=nil)then _aa={_aa}end;for aaa,baa in pairs(_aa)do
c_a:addItem(cb("text",baa),cb("x",baa),cb("y",baa),colors[cb("bg",baa)],colors[cb("fg",baa)])end end;return c_a end,addItem=function(c_a,d_a,_aa,aaa,baa,caa,...)
table.insert(bc,{x=
_aa or 1,y=aaa or 1,text=d_a,bgCol=baa or c_a.bgColor,fgCol=caa or c_a.fgColor,args={...}})if(#bc==1)then c_a:setValue(bc[1])end
c_a:updateDraw()return c_a end,getAll=function(c_a)return
bc end,removeItem=function(c_a,d_a)table.remove(bc,d_a)c_a:updateDraw()
return c_a end,getItem=function(c_a,d_a)return bc[d_a]end,getItemIndex=function(c_a)
local d_a=c_a:getValue()for _aa,aaa in pairs(bc)do if(aaa==d_a)then return _aa end end end,clear=function(c_a)
bc={}c_a:setValue({},false)c_a:updateDraw()return c_a end,getItemCount=function(c_a)return
#bc end,editItem=function(c_a,d_a,_aa,aaa,baa,caa,daa,...)table.remove(bc,d_a)
table.insert(bc,d_a,{x=aaa or 1,y=baa or 1,text=_aa,bgCol=
caa or c_a.bgColor,fgCol=daa or c_a.fgColor,args={...}})c_a:updateDraw()return c_a end,selectItem=function(c_a,d_a)c_a:setValue(
bc[d_a]or{},false)c_a:updateDraw()return c_a end,setActiveSymbol=function(c_a,d_a)
__a=d_a:sub(1,1)c_a:updateDraw()return c_a end,setSelectedItem=function(c_a,d_a,_aa,aaa,baa,caa)
cc=d_a or cc;dc=_aa or dc;_d=aaa or _d;ad=baa or ad
dd=caa~=nil and caa or true;c_a:updateDraw()return c_a end,mouseHandler=function(c_a,d_a,_aa,aaa)
if(
#bc>0)then
local baa,caa=c_a:getAbsolutePosition(c_a:getAnchorPosition())
for daa,_ba in pairs(bc)do
if(baa+_ba.x-1 <=_aa)and(
baa+_ba.x-1 +_ba.text:len()+1 >=_aa)and(
caa+_ba.y-1 ==aaa)then
c_a:setValue(_ba)
local aba=c_a:getEventSystem():sendEvent("mouse_click",c_a,"mouse_click",d_a,_aa,aaa)if(aba==false)then return aba end;if(c_a.parent~=nil)then
c_a.parent:setFocusedObject(c_a)end;c_a:updateDraw()return true end end end;return false end,draw=function(c_a)
if(
c_a.parent~=nil)then local d_a,_aa=c_a:getAnchorPosition()
for aaa,baa in pairs(bc)do
if(baa==
c_a:getValue())then if(a_a=="left")then
c_a.parent:writeText(baa.x+d_a-1,baa.y+_aa-1,__a,_d,ad)
c_a.parent:writeText(baa.x+2 +d_a-1,baa.y+_aa-1,baa.text,cc,dc)end else
c_a.parent:drawBackgroundBox(
baa.x+d_a-1,baa.y+_aa-1,1,1,bd or c_a.bgColor)
c_a.parent:writeText(baa.x+2 +d_a-1,baa.y+_aa-1,baa.text,baa.bgCol,baa.fgCol)end end;return true end end,init=function(c_a)
c_a.parent:addEvent("mouse_click",c_a)
if(_c.init(c_a))then
c_a.bgColor=c_a.parent:getTheme("MenubarBG")c_a.fgColor=c_a.parent:getTheme("MenubarFG")
cc=c_a.parent:getTheme("SelectionBG")dc=c_a.parent:getTheme("SelectionText")
_d=c_a.parent:getTheme("MenubarBG")ad=c_a.parent:getTheme("MenubarText")end end}return setmetatable(b_a,_c)end end
aa["objects"]["Slider"]=function(...)local ab=da("Object")
local bb=da("basaltLogs")local cb=da("utils").getValueFromXML
return
function(db)local _c=ab(db)local ac="Slider"
_c.width=8;_c.height=1;_c:setValue(1)local bc="horizontal"local cc=" "local dc;local _d="\140"
local ad=_c.width;local bd=1;local cd=1
local function dd(a_a,b_a,c_a,d_a)
local _aa,aaa=a_a:getAbsolutePosition(a_a:getAnchorPosition())local baa,caa=a_a:getSize()
if(bc=="horizontal")then
for _index=0,baa do
if
(_aa+_index==c_a)and(aaa<=d_a)and(aaa+caa>d_a)then
bd=math.min(_index+1,baa- (cd-1))a_a:setValue(ad/baa* (bd))a_a:updateDraw()end end end
if(bc=="vertical")then
for _index=0,caa do
if
(aaa+_index==d_a)and(_aa<=c_a)and(_aa+baa>c_a)then bd=math.min(_index+1,caa- (cd-1))
a_a:setValue(ad/caa* (bd))a_a:updateDraw()end end end end
local __a={getType=function(a_a)return ac end,setSymbol=function(a_a,b_a)cc=b_a:sub(1,1)a_a:updateDraw()return a_a end,setValuesByXMLData=function(a_a,b_a)
_c.setValuesByXMLData(a_a,b_a)
if(cb("maxValue",b_a)~=nil)then ad=cb("maxValue",b_a)end;if(cb("backgroundSymbol",b_a)~=nil)then
_d=cb("backgroundSymbol",b_a):sub(1,1)end;if(cb("barType",b_a)~=nil)then
bc=cb("barType",b_a):lower()end;if(cb("symbol",b_a)~=nil)then
cc=cb("symbol",b_a):sub(1,1)end;if(cb("symbolSize",b_a)~=nil)then
a_a:setSymbolSize(cb("symbolSize",b_a))end;if(cb("symbolColor",b_a)~=nil)then
dc=colors[cb("symbolColor",b_a)]end;if(cb("index",b_a)~=nil)then
a_a:setIndex(cb("index",b_a))end end,setIndex=function(a_a,b_a)
bd=b_a;if(bd<1)then bd=1 end;local c_a,d_a=a_a:getSize()
bd=math.min(bd,(
bc=="vertical"and d_a or c_a)- (cd-1))
a_a:setValue(ad/ (bc=="vertical"and d_a or c_a)*bd)a_a:updateDraw()return a_a end,getIndex=function(a_a)return
bd end,setSymbolSize=function(a_a,b_a)cd=tonumber(b_a)or 1
if(bc=="vertical")then
a_a:setValue(bd-1 * (ad/ (h- (cd-
1)))- (ad/ (h- (cd-1))))elseif(bc=="horizontal")then
a_a:setValue(bd-1 * (ad/ (w- (cd-1)))- (ad/
(w- (cd-1))))end;a_a:updateDraw()return a_a end,setMaxValue=function(a_a,b_a)
ad=b_a;return a_a end,setBackgroundSymbol=function(a_a,b_a)_d=string.sub(b_a,1,1)
a_a:updateDraw()return a_a end,setSymbolColor=function(a_a,b_a)dc=b_a;a_a:updateDraw()
return a_a end,setBarType=function(a_a,b_a)bc=b_a:lower()a_a:updateDraw()
return a_a end,mouseHandler=function(a_a,b_a,c_a,d_a)if(_c.mouseHandler(a_a,b_a,c_a,d_a))then
dd(a_a,b_a,c_a,d_a)return true end;return false end,dragHandler=function(a_a,b_a,c_a,d_a)if
(_c.dragHandler(a_a,b_a,c_a,d_a))then dd(a_a,b_a,c_a,d_a)return true end
return false end,scrollHandler=function(a_a,b_a,c_a,d_a)
if
(_c.scrollHandler(a_a,b_a,c_a,d_a))then local _aa,aaa=a_a:getSize()bd=bd+b_a;if(bd<1)then bd=1 end
bd=math.min(bd,(
bc=="vertical"and aaa or _aa)- (cd-1))
a_a:setValue(ad/ (bc=="vertical"and aaa or _aa)*bd)a_a:updateDraw()return true end;return false end,draw=function(a_a)
if
(_c.draw(a_a))then
if(a_a.parent~=nil)then local b_a,c_a=a_a:getAnchorPosition()
local d_a,_aa=a_a:getSize()
if(bc=="horizontal")then
a_a.parent:writeText(b_a,c_a,_d:rep(bd-1),a_a.bgColor,a_a.fgColor)
a_a.parent:writeText(b_a+bd-1,c_a,cc:rep(cd),dc,dc)
a_a.parent:writeText(b_a+bd+cd-1,c_a,_d:rep(d_a- (bd+cd-1)),a_a.bgColor,a_a.fgColor)end
if(bc=="vertical")then
for n=0,_aa-1 do
if(bd==n+1)then
for curIndexOffset=0,math.min(cd-1,_aa)do a_a.parent:writeText(b_a,c_a+n+
curIndexOffset,cc,dc,dc)end else if(n+1 <bd)or(n+1 >bd-1 +cd)then
a_a.parent:writeText(b_a,c_a+n,_d,a_a.bgColor,a_a.fgColor)end end end end end end end,init=function(a_a)
a_a.parent:addEvent("mouse_click",a_a)a_a.parent:addEvent("mouse_drag",a_a)
a_a.parent:addEvent("mouse_scroll",a_a)
if(_c.init(a_a))then
a_a.bgColor=a_a.parent:getTheme("SliderBG")a_a.fgColor=a_a.parent:getTheme("SliderText")
dc=a_a.parent:getTheme("SliderSymbolColor")end end}return setmetatable(__a,_c)end end
aa["objects"]["Textfield"]=function(...)local ab=da("Object")local bb=da("tHex")
local cb=da("utils").getValueFromXML;local db=da("basaltLogs")
local _c,ac,bc,cc,dc=string.rep,string.find,string.gmatch,string.sub,string.len
return
function(_d)local ad=ab(_d)local bd="Textfield"local cd,dd,__a,a_a=1,1,1,1;local b_a={" "}local c_a={""}local d_a={""}
local _aa={}local aaa={}local baa,caa,daa,_ba;local aba,bba=colors.lightBlue,colors.black;ad.width=30
ad.height=12;ad:setZIndex(5)local function cba()
if
(baa~=nil)and(caa~=nil)and(daa~=nil)and(_ba~=nil)then return true end;return false end
local function dba()local ada,bda,cda,dda
if
(cba())then if(baa>caa)then ada,bda=caa,baa else ada,bda=baa,caa end;if(daa>_ba)then
cda,dda=_ba,daa else cda,dda=daa,_ba end end;return ada,bda,cda,dda end;local function _ca()end
local function aca(ada)local bda,cda,dda,__b=dba(ada)
for n=__b,dda,-1 do
if(n==dda)or(n==__b)then local a_b=b_a[n]
local b_b=c_a[n]local c_b=d_a[n]
if(n==dda)and(n==__b)then a_b=a_b:sub(1,bda-1)..
a_b:sub(cda+1,a_b:len())b_b=b_b:sub(1,bda-1)..
b_b:sub(cda+1,b_b:len())c_b=c_b:sub(1,bda-1)..
c_b:sub(cda+1,c_b:len())elseif(n==bda)then
a_b=a_b:sub(1,bda)b_b=b_b:sub(1,bda)c_b=c_b:sub(1,bda)elseif(n==dda)then
a_b=a_b:sub(cda,a_b:len())b_b=b_b:sub(cda,b_b:len())
c_b=c_b:sub(cda,c_b:len())end;b_a[n]=a_b;c_a[n]=b_b;d_a[n]=c_b else table.remove(b_a,n)
table.remove(c_a,n)table.remove(d_a,n)end end;__a,a_a=baa,daa;baa,caa,daa,_ba=nil,nil,nil,nil;return ada end
local function bca(ada,bda)local cda={}
if(ada:len()>0)then
for dda in bc(ada,bda)do local __b,a_b=ac(ada,dda)
if
(__b~=nil)and(a_b~=nil)then table.insert(cda,__b)table.insert(cda,a_b)
local b_b=cc(ada,1,(__b-1))local c_b=cc(ada,a_b+1,ada:len())ada=b_b.. (":"):rep(dda:len())..
c_b end end end;return cda end
local function cca(ada,bda)bda=bda or a_a
local cda=bb[ada.fgColor]:rep(d_a[bda]:len())
local dda=bb[ada.bgColor]:rep(c_a[bda]:len())
for __b,a_b in pairs(aaa)do local b_b=bca(b_a[bda],a_b[1])
if(#b_b>0)then
for x=1,#b_b/2 do
local c_b=x*2 -1;if(a_b[2]~=nil)then
cda=cda:sub(1,b_b[c_b]-1)..bb[a_b[2]]:rep(b_b[c_b+1]- (
b_b[c_b]-1))..
cda:sub(b_b[c_b+1]+1,cda:len())end;if
(a_b[3]~=nil)then
dda=dda:sub(1,b_b[c_b]-1)..

bb[a_b[3]]:rep(b_b[c_b+1]- (b_b[c_b]-1))..dda:sub(b_b[c_b+1]+1,dda:len())end end end end
for __b,a_b in pairs(_aa)do
for b_b,c_b in pairs(a_b)do local d_b=bca(b_a[bda],c_b)
if(#d_b>0)then for x=1,#d_b/2 do
local _ab=x*2 -1
cda=cda:sub(1,d_b[_ab]-1)..

bb[__b]:rep(d_b[_ab+1]- (d_b[_ab]-1))..cda:sub(d_b[_ab+1]+1,cda:len())end end end end;d_a[bda]=cda;c_a[bda]=dda;ada:updateDraw()end;local function dca(ada)for n=1,#b_a do cca(ada,n)end end
local _da={getType=function(ada)return bd end,setBackground=function(ada,bda)
ad.setBackground(ada,bda)dca(ada)return ada end,setForeground=function(ada,bda)
ad.setForeground(ada,bda)dca(ada)return ada end,setValuesByXMLData=function(ada,bda)
ad.setValuesByXMLData(ada,bda)
if(bda["lines"]~=nil)then local cda=bda["lines"]["line"]if
(cda.properties~=nil)then cda={cda}end;for dda,__b in pairs(cda)do
ada:addLine(__b:value())end end
if(bda["keywords"]~=nil)then
for cda,dda in pairs(bda["keywords"])do
if(colors[cda]~=nil)then
local __b=dda;if(__b.properties~=nil)then __b={__b}end;local a_b={}
for b_b,c_b in pairs(__b)do
local d_b=c_b["keyword"]if(c_b["keyword"].properties~=nil)then
d_b={c_b["keyword"]}end;for _ab,aab in pairs(d_b)do
table.insert(a_b,aab:value())end end;ada:addKeywords(colors[cda],a_b)end end end
if(bda["rules"]~=nil)then
if(bda["rules"]["rule"]~=nil)then
local cda=bda["rules"]["rule"]if(bda["rules"]["rule"].properties~=nil)then
cda={bda["rules"]["rule"]}end
for dda,__b in pairs(cda)do if(cb("pattern",__b)~=nil)then
ada:addRule(cb("pattern",__b),colors[cb("fg",__b)],colors[cb("bg",__b)])end end end end end,getLines=function(ada)return
b_a end,getLine=function(ada,bda)return b_a[bda]end,editLine=function(ada,bda,cda)
b_a[bda]=cda or b_a[bda]cca(ada,bda)ada:updateDraw()return ada end,clear=function(ada)
b_a={" "}c_a={""}d_a={""}baa,caa,daa,_ba=nil,nil,nil,nil;cd,dd,__a,a_a=1,1,1,1
ada:updateDraw()return ada end,addLine=function(ada,bda,cda)
if
(bda~=nil)then
if(#b_a==1)and(b_a[1]=="")then b_a[1]=bda
c_a[1]=bb[ada.bgColor]:rep(bda:len())d_a[1]=bb[ada.fgColor]:rep(bda:len())
cca(ada,1)return ada end
if(cda~=nil)then table.insert(b_a,cda,bda)
table.insert(c_a,cda,bb[ada.bgColor]:rep(bda:len()))
table.insert(d_a,cda,bb[ada.fgColor]:rep(bda:len()))else table.insert(b_a,bda)
table.insert(c_a,bb[ada.bgColor]:rep(bda:len()))
table.insert(d_a,bb[ada.fgColor]:rep(bda:len()))end end;cca(ada,cda or#b_a)ada:updateDraw()return ada end,addKeywords=function(ada,bda,cda)if(
_aa[bda]==nil)then _aa[bda]={}end;for dda,__b in pairs(cda)do
table.insert(_aa[bda],__b)end;ada:updateDraw()return ada end,addRule=function(ada,bda,cda,dda)
table.insert(aaa,{bda,cda,dda})ada:updateDraw()return ada end,editRule=function(ada,bda,cda,dda)for __b,a_b in
pairs(aaa)do
if(a_b[1]==bda)then aaa[__b][2]=cda;aaa[__b][3]=dda end end;ada:updateDraw()return ada end,removeRule=function(ada,bda)
for cda,dda in
pairs(aaa)do if(dda[1]==bda)then table.remove(aaa,cda)end end;ada:updateDraw()return ada end,setKeywords=function(ada,bda,cda)
_aa[bda]=cda;ada:updateDraw()return ada end,removeLine=function(ada,bda)
if(#b_a>1)then table.remove(b_a,
bda or#b_a)
table.remove(c_a,bda or#c_a)table.remove(d_a,bda or#d_a)else b_a={" "}c_a={""}d_a={""}end;ada:updateDraw()return ada end,getTextCursor=function(ada)return
__a,a_a end,getFocusHandler=function(ada)ad.getFocusHandler(ada)
if(ada.parent~=nil)then
local bda,cda=ada:getAnchorPosition()if(ada.parent~=nil)then
ada.parent:setCursor(true,bda+__a-dd,cda+a_a-cd,ada.fgColor)end end end,loseFocusHandler=function(ada)
ad.loseFocusHandler(ada)
if(ada.parent~=nil)then ada.parent:setCursor(false)end end,keyHandler=function(ada,bda)
if
(ad.keyHandler(ada,event,bda))then local cda,dda=ada:getAnchorPosition()local __b,a_b=ada:getSize()
if(bda==
keys.backspace)then
if(b_a[a_a]=="")then
if(a_a>1)then table.remove(b_a,a_a)
table.remove(d_a,a_a)table.remove(c_a,a_a)
__a=b_a[a_a-1]:len()+1;dd=__a-__b+1;if(dd<1)then dd=1 end;a_a=a_a-1 end elseif(__a<=1)then
if(a_a>1)then __a=b_a[a_a-1]:len()+1
dd=__a-__b+1;if(dd<1)then dd=1 end;b_a[a_a-1]=b_a[a_a-1]..b_a[a_a]d_a[
a_a-1]=d_a[a_a-1]..d_a[a_a]c_a[a_a-1]=c_a[a_a-1]..
c_a[a_a]table.remove(b_a,a_a)
table.remove(d_a,a_a)table.remove(c_a,a_a)a_a=a_a-1 end else b_a[a_a]=b_a[a_a]:sub(1,__a-2)..
b_a[a_a]:sub(__a,b_a[a_a]:len())
d_a[a_a]=d_a[a_a]:sub(1,
__a-2)..d_a[a_a]:sub(__a,d_a[a_a]:len())c_a[a_a]=c_a[a_a]:sub(1,__a-2)..
c_a[a_a]:sub(__a,c_a[a_a]:len())if(__a>1)then
__a=__a-1 end;if(dd>1)then if(__a<dd)then dd=dd-1 end end end;if(a_a<cd)then cd=cd-1 end;cca(ada)ada:setValue("")end
if(bda==keys.delete)then
if(cba())then aca(ada)else
if(__a>b_a[a_a]:len())then
if(
b_a[a_a+1]~=nil)then b_a[a_a]=b_a[a_a]..b_a[a_a+1]
table.remove(b_a,a_a+1)table.remove(c_a,a_a+1)table.remove(d_a,a_a+1)end else b_a[a_a]=b_a[a_a]:sub(1,__a-1)..
b_a[a_a]:sub(__a+1,b_a[a_a]:len())
d_a[a_a]=d_a[a_a]:sub(1,
__a-1)..d_a[a_a]:sub(__a+1,d_a[a_a]:len())c_a[a_a]=c_a[a_a]:sub(1,__a-1)..
c_a[a_a]:sub(__a+1,c_a[a_a]:len())end end;cca(ada)end
if(bda==keys.enter)then
table.insert(b_a,a_a+1,b_a[a_a]:sub(__a,b_a[a_a]:len()))
table.insert(d_a,a_a+1,d_a[a_a]:sub(__a,d_a[a_a]:len()))
table.insert(c_a,a_a+1,c_a[a_a]:sub(__a,c_a[a_a]:len()))b_a[a_a]=b_a[a_a]:sub(1,__a-1)
d_a[a_a]=d_a[a_a]:sub(1,__a-1)c_a[a_a]=c_a[a_a]:sub(1,__a-1)a_a=a_a+1;__a=1;dd=1;if(a_a-cd>=
a_b)then cd=cd+1 end;ada:setValue("")end
if(bda==keys.up)then
if(a_a>1)then a_a=a_a-1;if(__a>b_a[a_a]:len()+1)then __a=
b_a[a_a]:len()+1 end
if(dd>1)then if(__a<dd)then
dd=__a-__b+1;if(dd<1)then dd=1 end end end;if(cd>1)then if(a_a<cd)then cd=cd-1 end end end end
if(bda==keys.down)then
if(a_a<#b_a)then a_a=a_a+1;if
(__a>b_a[a_a]:len()+1)then __a=b_a[a_a]:len()+1 end
if(dd>1)then if
(__a<dd)then dd=__a-__b+1;if(dd<1)then dd=1 end end end;if(a_a>=cd+a_b)then cd=cd+1 end end end
if(bda==keys.right)then __a=__a+1
if(a_a<#b_a)then if
(__a>b_a[a_a]:len()+1)then __a=1;a_a=a_a+1 end elseif(__a>b_a[a_a]:len())then __a=
b_a[a_a]:len()+1 end;if(__a<1)then __a=1 end
if(__a<dd)or(__a>=__b+dd)then dd=__a-__b+1 end;if(dd<1)then dd=1 end end
if(bda==keys.left)then __a=__a-1;if(__a>=1)then
if(__a<dd)or(__a>=__b+dd)then dd=__a end end
if(a_a>1)then if(__a<1)then a_a=a_a-1
__a=b_a[a_a]:len()+1;dd=__a-__b+1 end end;if(__a<1)then __a=1 end;if(dd<1)then dd=1 end end
if not
( (cda+__a-dd>=cda and cda+__a-dd<cda+__b)and(
dda+a_a-cd>=dda and dda+a_a-cd<dda+a_b))then dd=math.max(1,
b_a[a_a]:len()-__b+1)
cd=math.max(1,a_a-a_b+1)end;local b_b=
(__a<=b_a[a_a]:len()and __a-1 or b_a[a_a]:len())- (dd-1)
if(b_b>
ada:getX()+__b-1)then b_b=ada:getX()+__b-1 end
local c_b=(a_a-cd<a_b and a_a-cd or a_a-cd-1)if(b_b<1)then b_b=0 end
ada.parent:setCursor(true,cda+b_b,dda+c_b,ada.fgColor)ada:updateDraw()return true end end,charHandler=function(ada,bda)
if
(ad.charHandler(ada,bda))then local cda,dda=ada:getAnchorPosition()local __b,a_b=ada:getSize()b_a[a_a]=b_a[a_a]:sub(1,
__a-1)..
bda..b_a[a_a]:sub(__a,b_a[a_a]:len())
d_a[a_a]=d_a[a_a]:sub(1,
__a-1)..bb[ada.fgColor]..
d_a[a_a]:sub(__a,d_a[a_a]:len())
c_a[a_a]=c_a[a_a]:sub(1,__a-1)..bb[ada.bgColor]..
c_a[a_a]:sub(__a,c_a[a_a]:len())__a=__a+1;if(__a>=__b+dd)then dd=dd+1 end;cca(ada)
ada:setValue("")
if not
( (cda+__a-dd>=cda and cda+__a-dd<cda+__b)and(
dda+a_a-cd>=dda and dda+a_a-cd<dda+a_b))then dd=math.max(1,
b_a[a_a]:len()-__b+1)
cd=math.max(1,a_a-a_b+1)end;local b_b=
(__a<=b_a[a_a]:len()and __a-1 or b_a[a_a]:len())- (dd-1)
if(b_b>
ada:getX()+__b-1)then b_b=ada:getX()+__b-1 end
local c_b=(a_a-cd<a_b and a_a-cd or a_a-cd-1)if(b_b<1)then b_b=0 end;if(cba())then aca(ada)end;ada.parent:setCursor(true,cda+b_b,
dda+c_b,ada.fgColor)
ada:updateDraw()return true end end,dragHandler=function(ada,bda,cda,dda)
if
(ad.dragHandler(ada,bda,cda,dda))then
local __b,a_b=ada:getAbsolutePosition(ada:getAnchorPosition())local b_b,c_b=ada:getAnchorPosition()local d_b,_ab=ada:getSize()
if(b_a[
dda-a_b+cd]~=nil)then
if
(b_b+d_b>b_b+cda- (__b+1)+dd)and(b_b<b_b+cda-__b+dd)then
__a=cda-__b+dd;a_a=dda-a_b+cd;caa=__a;_ba=a_a;if(__a>b_a[a_a]:len())then __a=
b_a[a_a]:len()+1;caa=__a end;if(__a<dd)then dd=__a-1;if
(dd<1)then dd=1 end end;ada.parent:setCursor(true,b_b+__a-dd,
c_b+a_a-cd,ada.fgColor)
ada:updateDraw()end end;return true end end,scrollHandler=function(ada,bda,cda,dda)
if
(ad.scrollHandler(ada,bda,cda,dda))then
local __b,a_b=ada:getAbsolutePosition(ada:getAnchorPosition())local b_b,c_b=ada:getAnchorPosition()local d_b,_ab=ada:getSize()
cd=cd+bda;if(cd>#b_a- (_ab-1))then cd=#b_a- (_ab-1)end;if
(cd<1)then cd=1 end
if

(__b+__a-dd>=__b and __b+__a-dd<__b+d_b)and(c_b+a_a-cd>=c_b and c_b+a_a-cd<c_b+_ab)then
ada.parent:setCursor(true,b_b+__a-dd,c_b+a_a-cd,ada.fgColor)else ada.parent:setCursor(false)end;ada:updateDraw()return true end end,mouseHandler=function(ada,bda,cda,dda)
if
(ad.mouseHandler(ada,bda,cda,dda))then
local __b,a_b=ada:getAbsolutePosition(ada:getAnchorPosition())local b_b,c_b=ada:getAnchorPosition()
if
(b_a[dda-a_b+cd]~=nil)then __a=cda-__b+dd;a_a=dda-a_b+cd;caa=nil;_ba=nil;baa=__a;daa=a_a
if(__a>
b_a[a_a]:len())then __a=b_a[a_a]:len()+1;baa=__a end;if(__a<dd)then dd=__a-1;if(dd<1)then dd=1 end end
ada:updateDraw()end;if(ada.parent~=nil)then
ada.parent:setCursor(true,b_b+__a-dd,c_b+a_a-cd,ada.fgColor)end;return true end end,mouseUpHandler=function(ada,bda,cda,dda)
if
(ad.mouseUpHandler(ada,bda,cda,dda))then
local __b,a_b=ada:getAbsolutePosition(ada:getAnchorPosition())local b_b,c_b=ada:getAnchorPosition()
if
(b_a[dda-a_b+cd]~=nil)then caa=cda-__b+dd;_ba=dda-a_b+cd;if(caa>b_a[_ba]:len())then caa=
b_a[_ba]:len()+1 end;if(baa==caa)and(daa==_ba)then baa,caa,daa,_ba=
nil,nil,nil,nil end
ada:updateDraw()end;return true end end,eventHandler=function(ada,bda,cda,dda,__b,a_b)
if
(ad.eventHandler(ada,bda,cda,dda,__b,a_b))then
if(bda=="paste")then
if(ada:isFocused())then local b_b,c_b=ada:getSize()b_a[a_a]=b_a[a_a]:sub(1,
__a-1)..
cda..b_a[a_a]:sub(__a,b_a[a_a]:len())
d_a[a_a]=d_a[a_a]:sub(1,
__a-1)..bb[ada.fgColor]:rep(cda:len())..
d_a[a_a]:sub(__a,d_a[a_a]:len())
c_a[a_a]=c_a[a_a]:sub(1,__a-1)..

bb[ada.bgColor]:rep(cda:len())..c_a[a_a]:sub(__a,c_a[a_a]:len())__a=__a+cda:len()
if(__a>=b_b+dd)then dd=(__a+1)-b_b end;local d_b,_ab=ada:getAnchorPosition()
ada.parent:setCursor(true,d_b+__a-dd,_ab+
a_a-cd,ada.fgColor)cca(ada)ada:updateDraw()end end end end,draw=function(ada)
if
(ad.draw(ada))then
if(ada.parent~=nil)then local bda,cda=ada:getAnchorPosition()
local dda,__b=ada:getSize()
for n=1,__b do local a_b=""local b_b=""local c_b=""
if(b_a[n+cd-1]~=nil)then a_b=b_a[n+cd-1]c_b=d_a[
n+cd-1]b_b=c_a[n+cd-1]end;a_b=a_b:sub(dd,dda+dd-1)
b_b=b_b:sub(dd,dda+dd-1)c_b=c_b:sub(dd,dda+dd-1)local d_b=dda-a_b:len()if(d_b<0)then
d_b=0 end;a_b=a_b.._c(ada.bgSymbol,d_b)b_b=b_b..
_c(bb[ada.bgColor],d_b)
c_b=c_b.._c(bb[ada.fgColor],d_b)ada.parent:setText(bda,cda+n-1,a_b)ada.parent:setBG(bda,
cda+n-1,b_b)
ada.parent:setFG(bda,cda+n-1,c_b)end
if
(baa~=nil)and(caa~=nil)and(daa~=nil)and(_ba~=nil)then local a_b,b_b,c_b,d_b=dba(ada)
for n=c_b,d_b do local _ab=b_a[n]:len()local aab=0
if
(n==c_b)and(n==d_b)then aab=a_b-1;_ab=_ab- (a_b-1)- (_ab-b_b)elseif(n==d_b)then
_ab=_ab- (_ab-b_b)elseif(n==c_b)then _ab=_ab- (a_b-1)aab=a_b-1 end
ada.parent:setBG(bda+aab,cda+n-1,_c(bb[aba],_ab))
ada.parent:setFG(bda+aab,cda+n-1,_c(bb[bba],_ab))end end
if(ada:isFocused())then local a_b,b_b=ada:getAnchorPosition()end end end end,init=function(ada)
ada.parent:addEvent("mouse_click",ada)ada.parent:addEvent("mouse_up",ada)
ada.parent:addEvent("mouse_scroll",ada)ada.parent:addEvent("mouse_drag",ada)
ada.parent:addEvent("key",ada)ada.parent:addEvent("char",ada)
ada.parent:addEvent("other_event",ada)
if(ad.init(ada))then
ada.bgColor=ada.parent:getTheme("TextfieldBG")ada.fgColor=ada.parent:getTheme("TextfieldText")end end}return setmetatable(_da,ad)end end
aa["objects"]["Thread"]=function(...)local ab=da("utils").getValueFromXML
return
function(bb)local cb
local db="Thread"local _c;local ac;local bc=false;local cc
local dc=function(_d,ad)
if(ad:sub(1,1)=="#")then
local bd=_d:getBaseFrame():getDeepObject(ad:sub(2,ad:len()))
if(bd~=nil)and(bd.internalObjetCall~=nil)then return(function()
bd:internalObjetCall()end)end else return _d:getBaseFrame():getVariable(ad)end;return _d end
cb={name=bb,getType=function(_d)return db end,getZIndex=function(_d)return 1 end,getName=function(_d)return _d.name end,getBaseFrame=function(_d)if
(_d.parent~=nil)then return _d.parent:getBaseFrame()end
return _d end,setValuesByXMLData=function(_d,ad)local bd;if(ab("thread",ad)~=nil)then
bd=dc(_d,ab("thread",ad))end
if(ab("start",ad)~=nil)then if
(ab("start",ad))and(bd~=nil)then _d:start(bd)end end;return _d end,start=function(_d,ad)
if(
ad==nil)then error("Function provided to thread is nil")end;_c=ad;ac=coroutine.create(_c)bc=true;cc=nil
local bd,cd=coroutine.resume(ac)cc=cd;if not(bd)then if(cd~="Terminated")then
error("Thread Error Occurred - "..cd)end end
_d.parent:addEvent("mouse_click",_d)_d.parent:addEvent("mouse_up",_d)
_d.parent:addEvent("mouse_scroll",_d)_d.parent:addEvent("mouse_drag",_d)
_d.parent:addEvent("key",_d)_d.parent:addEvent("key_up",_d)
_d.parent:addEvent("char",_d)_d.parent:addEvent("other_event",_d)return _d end,getStatus=function(_d,ad)if(
ac~=nil)then return coroutine.status(ac)end;return nil end,stop=function(_d,ad)
bc=false;_d.parent:removeEvent("mouse_click",_d)
_d.parent:removeEvent("mouse_up",_d)_d.parent:removeEvent("mouse_scroll",_d)
_d.parent:removeEvent("mouse_drag",_d)_d.parent:removeEvent("key",_d)
_d.parent:removeEvent("key_up",_d)_d.parent:removeEvent("char",_d)
_d.parent:removeEvent("other_event",_d)return _d end,mouseHandler=function(_d,...)
_d:eventHandler("mouse_click",...)end,mouseUpHandler=function(_d,...)_d:eventHandler("mouse_up",...)end,mouseScrollHandler=function(_d,...)
_d:eventHandler("mouse_scroll",...)end,mouseDragHandler=function(_d,...)
_d:eventHandler("mouse_drag",...)end,mouseMoveHandler=function(_d,...)
_d:eventHandler("mouse_move",...)end,keyHandler=function(_d,...)_d:eventHandler("key",...)end,keyUpHandler=function(_d,...)
_d:eventHandler("key_up",...)end,charHandler=function(_d,...)_d:eventHandler("char",...)end,eventHandler=function(_d,ad,...)
if
(bc)then
if(coroutine.status(ac)=="suspended")then if(cc~=nil)then if(ad~=cc)then return end;cc=
nil end
local bd,cd=coroutine.resume(ac,ad,...)cc=cd;if not(bd)then if(cd~="Terminated")then
error("Thread Error Occurred - "..cd)end end else
_d:stop()end end end}cb.__index=cb;return cb end end
aa["objects"]["Timer"]=function(...)local ab=da("basaltEvent")
local bb=da("utils").getValueFromXML
return
function(cb)local db="Timer"local _c=0;local ac=0;local bc=0;local cc;local dc=ab()local _d=false
local ad=function(cd,dd,__a)
local a_a=function(b_a)
if(b_a:sub(1,1)=="#")then
local c_a=cd:getBaseFrame():getDeepObject(b_a:sub(2,b_a:len()))
if(c_a~=nil)and(c_a.internalObjetCall~=nil)then dd(cd,function()
c_a:internalObjetCall()end)end else
dd(cd,cd:getBaseFrame():getVariable(b_a))end end;if(type(__a)=="string")then a_a(__a)elseif(type(__a)=="table")then
for b_a,c_a in pairs(__a)do a_a(c_a)end end;return cd end
local bd={name=cb,getType=function(cd)return db end,setValuesByXMLData=function(cd,dd)
if(bb("time",dd)~=nil)then _c=bb("time",dd)end;if(bb("repeat",dd)~=nil)then ac=bb("repeat",dd)end
if(
bb("start",dd)~=nil)then if(bb("start",dd))then cd:start()end end;if(bb("onCall",dd)~=nil)then
ad(cd,cd.onCall,bb("onCall",dd))end;return cd end,getBaseFrame=function(cd)
if(
cd.parent~=nil)then return cd.parent:getBaseFrame()end;return cd end,getZIndex=function(cd)return 1 end,getName=function(cd)
return cd.name end,setTime=function(cd,dd,__a)_c=dd or 0;ac=__a or 1;return cd end,start=function(cd)if(_d)then
os.cancelTimer(cc)end;bc=ac;cc=os.startTimer(_c)_d=true
cd.parent:addEvent("other_event",cd)return cd end,isActive=function(cd)return _d end,cancel=function(cd)if(
cc~=nil)then os.cancelTimer(cc)end;_d=false
cd.parent:removeEvent("other_event",cd)return cd end,onCall=function(cd,dd)
dc:registerEvent("timed_event",dd)return cd end,eventHandler=function(cd,dd,__a)
if
dd=="timer"and __a==cc and _d then dc:sendEvent("timed_event",cd)
if(bc>=1)then bc=bc-1;if(bc>=1)then
cc=os.startTimer(_c)end elseif(bc==-1)then cc=os.startTimer(_c)end end end}bd.__index=bd;return bd end end
aa["objects"]["Switch"]=function(...)local ab=da("Object")
local bb=da("utils").getValueFromXML
return
function(cb)local db=ab(cb)local _c="Switch"db.width=2;db.height=1
db.bgColor=colors.lightGray;db.fgColor=colors.gray;db:setValue(false)db:setZIndex(5)
local ac=colors.black;local bc=colors.red;local cc=colors.green
local dc={getType=function(_d)return _c end,setSymbolColor=function(_d,ad)ac=ad
_d:updateDraw()return _d end,setActiveBackground=function(_d,ad)cc=ad;_d:updateDraw()return _d end,setInactiveBackground=function(_d,ad)
bc=ad;_d:updateDraw()return _d end,setValuesByXMLData=function(_d,ad)
db.setValuesByXMLData(_d,ad)if(bb("inactiveBG",ad)~=nil)then
bc=colors[bb("inactiveBG",ad)]end;if(bb("activeBG",ad)~=nil)then
cc=colors[bb("activeBG",ad)]end;if(bb("symbolColor",ad)~=nil)then
ac=colors[bb("symbolColor",ad)]end end,mouseHandler=function(_d,ad,bd,cd)
if
(db.mouseHandler(_d,ad,bd,cd))then
local dd,__a=_d:getAbsolutePosition(_d:getAnchorPosition())_d:setValue(not _d:getValue())
_d:updateDraw()return true end end,draw=function(_d)
if
(db.draw(_d))then
if(_d.parent~=nil)then local ad,bd=_d:getAnchorPosition()
local cd,dd=_d:getSize()
_d.parent:drawBackgroundBox(ad,bd,cd,dd,_d.bgColor)
if(_d:getValue())then
_d.parent:drawBackgroundBox(ad,bd,1,dd,cc)_d.parent:drawBackgroundBox(ad+1,bd,1,dd,ac)else
_d.parent:drawBackgroundBox(ad,bd,1,dd,ac)_d.parent:drawBackgroundBox(ad+1,bd,1,dd,bc)end end end end,init=function(_d)
_d.parent:addEvent("mouse_click",_d)
if(db.init(_d))then _d.bgColor=_d.parent:getTheme("SwitchBG")
_d.fgColor=_d.parent:getTheme("SwitchText")ac=_d.parent:getTheme("SwitchBGSymbol")
bc=_d.parent:getTheme("SwitchInactive")cc=_d.parent:getTheme("SwitchActive")end end}return setmetatable(dc,db)end end;aa["libraries"]={}
aa["libraries"]["basaltEvent"]=function(...)
return
function()local ab={}local bb={}
local cb={registerEvent=function(db,_c,ac)if(
ab[_c]==nil)then ab[_c]={}bb[_c]=1 end
ab[_c][bb[_c]]=ac;bb[_c]=bb[_c]+1;return bb[_c]-1 end,removeEvent=function(db,_c,ac)ab[_c][ac[_c]]=
nil end,sendEvent=function(db,_c,...)local ac
if(ab[_c]~=nil)then for bc,cc in pairs(ab[_c])do
local dc=cc(...)if(dc==false)then ac=dc end end end;return ac end}cb.__index=cb;return cb end end
aa["libraries"]["basaltLogs"]=function(...)local ab=""local bb="basaltLog.txt"local cb="Debug"
fs.delete(
ab~=""and ab.."/"..bb or bb)
local db={__call=function(_c,ac,bc)if(ac==nil)then return end
local cc=ab~=""and ab.."/"..bb or bb
local dc=fs.open(cc,fs.exists(cc)and"a"or"w")
dc.writeLine("[Basalt][".. (bc and bc or cb).."]: "..tostring(ac))dc.close()end}return setmetatable({},db)end
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
aa["libraries"]["basaltDraw"]=function(...)local ab=da("tHex")
local bb,cb=string.sub,string.rep
return
function(db)local _c=db or term.current()local ac;local bc,cc=_c.getSize()local dc={}
local _d={}local ad={}local bd={}local cd={}local dd={}local __a;local a_a={}
local function b_a()__a=cb(" ",bc)for n=0,15 do local daa=2 ^n
local _ba=ab[daa]a_a[daa]=cb(_ba,bc)end end;b_a()
local function c_a()b_a()local daa=__a;local _ba=a_a[colors.white]
local aba=a_a[colors.black]
for currentY=1,cc do
dc[currentY]=bb(dc[currentY]==nil and daa or dc[currentY]..daa:sub(1,bc-
dc[currentY]:len()),1,bc)
ad[currentY]=bb(ad[currentY]==nil and _ba or ad[currentY].._ba:sub(1,bc-
ad[currentY]:len()),1,bc)
_d[currentY]=bb(_d[currentY]==nil and aba or _d[currentY]..aba:sub(1,bc-
_d[currentY]:len()),1,bc)end end;c_a()
local function d_a(daa,_ba,aba)
if(_ba>=1)and(_ba<=cc)then
if
(daa+aba:len()>0)and(daa<=bc)then local bba=dc[_ba]local cba;local dba=daa+#aba-1
if(daa<1)then local _ca=1 -daa+1
local aca=bc-daa+1;aba=bb(aba,_ca,aca)elseif(dba>bc)then local _ca=bc-daa+1;aba=bb(aba,1,_ca)end
if(daa>1)then local _ca=daa-1;cba=bb(bba,1,_ca)..aba else cba=aba end;if dba<bc then cba=cba..bb(bba,dba+1,bc)end
dc[_ba]=cba end end end
local function _aa(daa,_ba,aba)
if(_ba>=1)and(_ba<=cc)then
if(daa+aba:len()>0)and(daa<=bc)then
local bba=_d[_ba]local cba;local dba=daa+#aba-1
if(daa<1)then
aba=bb(aba,1 -daa+1,bc-daa+1)elseif(dba>bc)then aba=bb(aba,1,bc-daa+1)end
if(daa>1)then cba=bb(bba,1,daa-1)..aba else cba=aba end;if dba<bc then cba=cba..bb(bba,dba+1,bc)end
_d[_ba]=cba end end end
local function aaa(daa,_ba,aba)
if(_ba>=1)and(_ba<=cc)then
if(daa+aba:len()>0)and(daa<=bc)then
local bba=ad[_ba]local cba;local dba=daa+#aba-1
if(daa<1)then local _ca=1 -daa+1;local aca=bc-daa+1
aba=bb(aba,_ca,aca)elseif(dba>bc)then local _ca=bc-daa+1;aba=bb(aba,1,_ca)end
if(daa>1)then local _ca=daa-1;cba=bb(bba,1,_ca)..aba else cba=aba end;if dba<bc then cba=cba..bb(bba,dba+1,bc)end
ad[_ba]=cba end end end
local function baa(daa,_ba,aba,bba,cba)
if(#aba==#bba)or(#aba==#cba)then
if(_ba>=1)and(_ba<=cc)then
if(
daa+aba:len()>0)and(daa<=bc)then local dba=dc[_ba]local _ca=ad[_ba]local aca=_d[_ba]
local bca,cca,dca;local _da=daa+#aba-1
if(daa<1)then local ada=1 -daa+1;local bda=bc-daa+1
aba=bb(aba,ada,bda)bba=bb(bba,ada,bda)cba=bb(cba,ada,bda)elseif(_da>bc)then local ada=bc-daa+1
aba=bb(aba,1,ada)bba=bb(bba,1,ada)cba=bb(cba,1,ada)end
if(daa>1)then local ada=daa-1;bca=bb(dba,1,ada)..aba
cca=bb(_ca,1,ada)..bba;dca=bb(aca,1,ada)..cba else bca=aba;cca=bba;dca=cba end
if _da<bc then bca=bca..bb(dba,_da+1,bc)
cca=cca..bb(_ca,_da+1,bc)dca=dca..bb(aca,_da+1,bc)end;dc[_ba]=bca;ad[_ba]=cca;_d[_ba]=dca end end end end
local caa={setSize=function(daa,_ba)bc,cc=daa,_ba;c_a()end,setMirror=function(daa)ac=daa end,setBG=function(daa,_ba,aba)
_aa(daa,_ba,aba)end,setText=function(daa,_ba,aba)d_a(daa,_ba,aba)end,setFG=function(daa,_ba,aba)
aaa(daa,_ba,aba)end,blit=function(daa,_ba,aba,bba,cba)baa(daa,_ba,aba,bba,cba)end,drawBackgroundBox=function(daa,_ba,aba,bba,cba)
for n=1,bba
do _aa(daa,_ba+ (n-1),cb(ab[cba],aba))end end,drawForegroundBox=function(daa,_ba,aba,bba,cba)for n=1,bba do
aaa(daa,_ba+ (n-1),cb(ab[cba],aba))end end,drawTextBox=function(daa,_ba,aba,bba,cba)
for n=1,bba do d_a(daa,
_ba+ (n-1),cb(cba,aba))end end,writeText=function(daa,_ba,aba,bba,cba)
if(aba~=nil)then d_a(daa,_ba,aba)if
(bba~=nil)and(bba~=false)then
_aa(daa,_ba,cb(ab[bba],aba:len()))end;if(cba~=nil)and(cba~=false)then
aaa(daa,_ba,cb(ab[cba],aba:len()))end end end,update=function()
local daa,_ba=_c.getCursorPos()local aba=false
if(_c.getCursorBlink~=nil)then aba=_c.getCursorBlink()end;_c.setCursorBlink(false)if(ac~=nil)then
ac.setCursorBlink(false)end
for n=1,cc do _c.setCursorPos(1,n)
_c.blit(dc[n],ad[n],_d[n])if(ac~=nil)then ac.setCursorPos(1,n)
ac.blit(dc[n],ad[n],_d[n])end end;_c.setBackgroundColor(colors.black)
_c.setCursorBlink(aba)_c.setCursorPos(daa,_ba)
if(ac~=nil)then
ac.setBackgroundColor(colors.black)ac.setCursorBlink(aba)ac.setCursorPos(daa,_ba)end end,setTerm=function(daa)
_c=daa end}return caa end end
aa["libraries"]["bigfont"]=function(...)local ab=da("tHex")
local bb={{"\32\32\32\137\156\148\158\159\148\135\135\144\159\139\32\136\157\32\159\139\32\32\143\32\32\143\32\32\32\32\32\32\32\32\147\148\150\131\148\32\32\32\151\140\148\151\140\147","\32\32\32\149\132\149\136\156\149\144\32\133\139\159\129\143\159\133\143\159\133\138\32\133\138\32\133\32\32\32\32\32\32\150\150\129\137\156\129\32\32\32\133\131\129\133\131\132","\32\32\32\130\131\32\130\131\32\32\129\32\32\32\32\130\131\32\130\131\32\32\32\32\143\143\143\32\32\32\32\32\32\130\129\32\130\135\32\32\32\32\131\32\32\131\32\131","\139\144\32\32\143\148\135\130\144\149\32\149\150\151\149\158\140\129\32\32\32\135\130\144\135\130\144\32\149\32\32\139\32\159\148\32\32\32\32\159\32\144\32\148\32\147\131\132","\159\135\129\131\143\149\143\138\144\138\32\133\130\149\149\137\155\149\159\143\144\147\130\132\32\149\32\147\130\132\131\159\129\139\151\129\148\32\32\139\131\135\133\32\144\130\151\32","\32\32\32\32\32\32\130\135\32\130\32\129\32\129\129\131\131\32\130\131\129\140\141\132\32\129\32\32\129\32\32\32\32\32\32\32\131\131\129\32\32\32\32\32\32\32\32\32","\32\32\32\32\149\32\159\154\133\133\133\144\152\141\132\133\151\129\136\153\32\32\154\32\159\134\129\130\137\144\159\32\144\32\148\32\32\32\32\32\32\32\32\32\32\32\151\129","\32\32\32\32\133\32\32\32\32\145\145\132\141\140\132\151\129\144\150\146\129\32\32\32\138\144\32\32\159\133\136\131\132\131\151\129\32\144\32\131\131\129\32\144\32\151\129\32","\32\32\32\32\129\32\32\32\32\130\130\32\32\129\32\129\32\129\130\129\129\32\32\32\32\130\129\130\129\32\32\32\32\32\32\32\32\133\32\32\32\32\32\129\32\129\32\32","\150\156\148\136\149\32\134\131\148\134\131\148\159\134\149\136\140\129\152\131\32\135\131\149\150\131\148\150\131\148\32\148\32\32\148\32\32\152\129\143\143\144\130\155\32\134\131\148","\157\129\149\32\149\32\152\131\144\144\131\148\141\140\149\144\32\149\151\131\148\32\150\32\150\131\148\130\156\133\32\144\32\32\144\32\130\155\32\143\143\144\32\152\129\32\134\32","\130\131\32\131\131\129\131\131\129\130\131\32\32\32\129\130\131\32\130\131\32\32\129\32\130\131\32\130\129\32\32\129\32\32\133\32\32\32\129\32\32\32\130\32\32\32\129\32","\150\140\150\137\140\148\136\140\132\150\131\132\151\131\148\136\147\129\136\147\129\150\156\145\138\143\149\130\151\32\32\32\149\138\152\129\149\32\32\157\152\149\157\144\149\150\131\148","\149\143\142\149\32\149\149\32\149\149\32\144\149\32\149\149\32\32\149\32\32\149\32\149\149\32\149\32\149\32\144\32\149\149\130\148\149\32\32\149\32\149\149\130\149\149\32\149","\130\131\129\129\32\129\131\131\32\130\131\32\131\131\32\131\131\129\129\32\32\130\131\32\129\32\129\130\131\32\130\131\32\129\32\129\131\131\129\129\32\129\129\32\129\130\131\32","\136\140\132\150\131\148\136\140\132\153\140\129\131\151\129\149\32\149\149\32\149\149\32\149\137\152\129\137\152\129\131\156\133\149\131\32\150\32\32\130\148\32\152\137\144\32\32\32","\149\32\32\149\159\133\149\32\149\144\32\149\32\149\32\149\32\149\150\151\129\138\155\149\150\130\148\32\149\32\152\129\32\149\32\32\32\150\32\32\149\32\32\32\32\32\32\32","\129\32\32\130\129\129\129\32\129\130\131\32\32\129\32\130\131\32\32\129\32\129\32\129\129\32\129\32\129\32\131\131\129\130\131\32\32\32\129\130\131\32\32\32\32\140\140\132","\32\154\32\159\143\32\149\143\32\159\143\32\159\144\149\159\143\32\159\137\145\159\143\144\149\143\32\32\145\32\32\32\145\149\32\144\32\149\32\143\159\32\143\143\32\159\143\32","\32\32\32\152\140\149\151\32\149\149\32\145\149\130\149\157\140\133\32\149\32\154\143\149\151\32\149\32\149\32\144\32\149\149\153\32\32\149\32\149\133\149\149\32\149\149\32\149","\32\32\32\130\131\129\131\131\32\130\131\32\130\131\129\130\131\129\32\129\32\140\140\129\129\32\129\32\129\32\137\140\129\130\32\129\32\130\32\129\32\129\129\32\129\130\131\32","\144\143\32\159\144\144\144\143\32\159\143\144\159\138\32\144\32\144\144\32\144\144\32\144\144\32\144\144\32\144\143\143\144\32\150\129\32\149\32\130\150\32\134\137\134\134\131\148","\136\143\133\154\141\149\151\32\129\137\140\144\32\149\32\149\32\149\154\159\133\149\148\149\157\153\32\154\143\149\159\134\32\130\148\32\32\149\32\32\151\129\32\32\32\32\134\32","\133\32\32\32\32\133\129\32\32\131\131\32\32\130\32\130\131\129\32\129\32\130\131\129\129\32\129\140\140\129\131\131\129\32\130\129\32\129\32\130\129\32\32\32\32\32\129\32","\32\32\32\32\149\32\32\149\32\32\32\32\32\32\32\32\149\32\32\149\32\32\32\32\32\32\32\32\149\32\32\149\32\32\32\32\32\32\32\32\149\32\32\149\32\32\32\32","\32\32\32\32\32\32\32\32\32\32\32\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\32\32\32\32\32\32\32\32\32\32\32","\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32","\32\32\32\32\149\32\32\149\32\32\32\32\32\32\32\32\149\32\32\149\32\32\32\32\32\32\32\32\149\32\32\149\32\32\32\32\32\32\32\32\149\32\32\149\32\32\32\32","\32\32\32\32\32\32\32\32\32\32\32\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\32\32\32\32\32\32\32\32\32\32\32","\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32","\32\32\32\32\145\32\159\139\32\151\131\132\155\143\132\134\135\145\32\149\32\158\140\129\130\130\32\152\147\155\157\134\32\32\144\144\32\32\32\32\32\32\152\131\155\131\131\129","\32\32\32\32\149\32\149\32\145\148\131\32\149\32\149\140\157\132\32\148\32\137\155\149\32\32\32\149\154\149\137\142\32\153\153\32\131\131\149\131\131\129\149\135\145\32\32\32","\32\32\32\32\129\32\130\135\32\131\131\129\134\131\132\32\129\32\32\129\32\131\131\32\32\32\32\130\131\129\32\32\32\32\129\129\32\32\32\32\32\32\130\131\129\32\32\32","\150\150\32\32\148\32\134\32\32\132\32\32\134\32\32\144\32\144\150\151\149\32\32\32\32\32\32\145\32\32\152\140\144\144\144\32\133\151\129\133\151\129\132\151\129\32\145\32","\130\129\32\131\151\129\141\32\32\142\32\32\32\32\32\149\32\149\130\149\149\32\143\32\32\32\32\142\132\32\154\143\133\157\153\132\151\150\148\151\158\132\151\150\148\144\130\148","\32\32\32\140\140\132\32\32\32\32\32\32\32\32\32\151\131\32\32\129\129\32\32\32\32\134\32\32\32\32\32\32\32\129\129\32\129\32\129\129\130\129\129\32\129\130\131\32","\156\143\32\159\141\129\153\140\132\153\137\32\157\141\32\159\142\32\150\151\129\150\131\132\140\143\144\143\141\145\137\140\148\141\141\144\157\142\32\159\140\32\151\134\32\157\141\32","\157\140\149\157\140\149\157\140\149\157\140\149\157\140\149\157\140\149\151\151\32\154\143\132\157\140\32\157\140\32\157\140\32\157\140\32\32\149\32\32\149\32\32\149\32\32\149\32","\129\32\129\129\32\129\129\32\129\129\32\129\129\32\129\129\32\129\129\131\129\32\134\32\131\131\129\131\131\129\131\131\129\131\131\129\130\131\32\130\131\32\130\131\32\130\131\32","\151\131\148\152\137\145\155\140\144\152\142\145\153\140\132\153\137\32\154\142\144\155\159\132\150\156\148\147\32\144\144\130\145\136\137\32\146\130\144\144\130\145\130\136\32\151\140\132","\151\32\149\151\155\149\149\32\149\149\32\149\149\32\149\149\32\149\149\32\149\152\137\144\157\129\149\149\32\149\149\32\149\149\32\149\149\32\149\130\150\32\32\157\129\149\32\149","\131\131\32\129\32\129\130\131\32\130\131\32\130\131\32\130\131\32\130\131\32\32\32\32\130\131\32\130\131\32\130\131\32\130\131\32\130\131\32\32\129\32\130\131\32\133\131\32","\156\143\32\159\141\129\153\140\132\153\137\32\157\141\32\159\142\32\159\159\144\152\140\144\156\143\32\159\141\129\153\140\132\157\141\32\130\145\32\32\147\32\136\153\32\130\146\32","\152\140\149\152\140\149\152\140\149\152\140\149\152\140\149\152\140\149\149\157\134\154\143\132\157\140\133\157\140\133\157\140\133\157\140\133\32\149\32\32\149\32\32\149\32\32\149\32","\130\131\129\130\131\129\130\131\129\130\131\129\130\131\129\130\131\129\130\130\131\32\134\32\130\131\129\130\131\129\130\131\129\130\131\129\32\129\32\32\129\32\32\129\32\32\129\32","\159\134\144\137\137\32\156\143\32\159\141\129\153\140\132\153\137\32\157\141\32\32\132\32\159\143\32\147\32\144\144\130\145\136\137\32\146\130\144\144\130\145\130\138\32\146\130\144","\149\32\149\149\32\149\149\32\149\149\32\149\149\32\149\149\32\149\149\32\149\131\147\129\138\134\149\149\32\149\149\32\149\149\32\149\149\32\149\154\143\149\32\157\129\154\143\149","\130\131\32\129\32\129\130\131\32\130\131\32\130\131\32\130\131\32\130\131\32\32\32\32\130\131\32\130\131\129\130\131\129\130\131\129\130\131\129\140\140\129\130\131\32\140\140\129"},{"000110000110110000110010101000000010000000100101","000000110110000000000010101000000010000000100101","000000000000000000000000000000000000000000000000","100010110100000010000110110000010100000100000110","000000110000000010110110000110000000000000110000","000000000000000000000000000000000000000000000000","000000110110000010000000100000100000000000000010","000000000110110100010000000010000000000000000100","000000000000000000000000000000000000000000000000","010000000000100110000000000000000000000110010000","000000000000000000000000000010000000010110000000","000000000000000000000000000000000000000000000000","011110110000000100100010110000000100000000000000","000000000000000000000000000000000000000000000000","000000000000000000000000000000000000000000000000","110000110110000000000000000000010100100010000000","000010000000000000110110000000000100010010000000","000000000000000000000000000000000000000000000000","010110010110100110110110010000000100000110110110","000000000000000000000110000000000110000000000000","000000000000000000000000000000000000000000000000","010100010110110000000000000000110000000010000000","110110000000000000110000110110100000000010000000","000000000000000000000000000000000000000000000000","000100011111000100011111000100011111000100011111","000000000000100100100100011011011011111111111111","000000000000000000000000000000000000000000000000","000100011111000100011111000100011111000100011111","000000000000100100100100011011011011111111111111","100100100100100100100100100100100100100100100100","000000110100110110000010000011110000000000011000","000000000100000000000010000011000110000000001000","000000000000000000000000000000000000000000000000","010000100100000000000000000100000000010010110000","000000000000000000000000000000110110110110110000","000000000000000000000000000000000000000000000000","110110110110110110000000110110110110110110110110","000000000000000000000110000000000000000000000000","000000000000000000000000000000000000000000000000","000000000000110110000110010000000000000000010010","000010000000000000000000000000000000000000000000","000000000000000000000000000000000000000000000000","110110110110110110110000110110110110000000000000","000000000000000000000110000000000000000000000000","000000000000000000000000000000000000000000000000","110110110110110110110000110000000000000000010000","000000000000000000000000100000000000000110000110","000000000000000000000000000000000000000000000000"}}local cb={}local db={}
do local bc=0;local cc=#bb[1]local dc=#bb[1][1]
for i=1,cc,3 do
for j=1,dc,3 do
local _d=string.char(bc)local ad={}ad[1]=bb[1][i]:sub(j,j+2)
ad[2]=bb[1][i+1]:sub(j,j+2)ad[3]=bb[1][i+2]:sub(j,j+2)local bd={}bd[1]=bb[2][i]:sub(j,
j+2)bd[2]=bb[2][i+1]:sub(j,j+2)bd[3]=bb[2][
i+2]:sub(j,j+2)db[_d]={ad,bd}bc=bc+1 end end;cb[1]=db end
local function _c(bc,cc)local dc={["0"]="1",["1"]="0"}if bc<=#cb then return true end
for f=#cb+1,bc do local _d={}local ad=cb[
f-1]
for char=0,255 do local bd=string.char(char)local cd={}local dd={}
local __a=ad[bd][1]local a_a=ad[bd][2]
for i=1,#__a do local b_a,c_a,d_a,_aa,aaa,baa={},{},{},{},{},{}
for j=1,#__a[1]do
local caa=db[__a[i]:sub(j,j)][1]table.insert(b_a,caa[1])
table.insert(c_a,caa[2])table.insert(d_a,caa[3])
local daa=db[__a[i]:sub(j,j)][2]
if a_a[i]:sub(j,j)=="1"then
table.insert(_aa,(daa[1]:gsub("[01]",dc)))
table.insert(aaa,(daa[2]:gsub("[01]",dc)))
table.insert(baa,(daa[3]:gsub("[01]",dc)))else table.insert(_aa,daa[1])
table.insert(aaa,daa[2])table.insert(baa,daa[3])end end;table.insert(cd,table.concat(b_a))
table.insert(cd,table.concat(c_a))table.insert(cd,table.concat(d_a))
table.insert(dd,table.concat(_aa))table.insert(dd,table.concat(aaa))
table.insert(dd,table.concat(baa))end;_d[bd]={cd,dd}if cc then cc="Font"..f.."Yeld"..char
os.queueEvent(cc)os.pullEvent(cc)end end;cb[f]=_d end;return true end
local function ac(bc,cc,dc,_d,ad)
if not type(cc)=="string"then error("Not a String",3)end
local bd=type(dc)=="string"and dc:sub(1,1)or ab[dc]or
error("Wrong Front Color",3)
local cd=type(_d)=="string"and _d:sub(1,1)or ab[_d]or
error("Wrong Back Color",3)if(cb[bc]==nil)then _c(3,false)end;local dd=cb[bc]or
error("Wrong font size selected",3)if cc==""then
return{{""},{""},{""}}end;local __a={}
for baa in cc:gmatch('.')do table.insert(__a,baa)end;local a_a={}local b_a=#dd[__a[1]][1]
for nLine=1,b_a do local baa={}
for i=1,#__a do baa[i]=dd[__a[i]]and
dd[__a[i]][1][nLine]or""end;a_a[nLine]=table.concat(baa)end;local c_a={}local d_a={}local _aa={["0"]=bd,["1"]=cd}local aaa={["0"]=cd,["1"]=bd}
for nLine=1,b_a do
local baa={}local caa={}
for i=1,#__a do
local daa=dd[__a[i]]and dd[__a[i]][2][nLine]or""
baa[i]=daa:gsub("[01]",
ad and{["0"]=dc:sub(i,i),["1"]=_d:sub(i,i)}or _aa)
caa[i]=daa:gsub("[01]",
ad and{["0"]=_d:sub(i,i),["1"]=dc:sub(i,i)}or aaa)end;c_a[nLine]=table.concat(baa)
d_a[nLine]=table.concat(caa)end;return{a_a,c_a,d_a}end;return ac end
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
cc[_aa],dc[_aa],_d[_aa]=aaa[1],aaa[2],aaa[3]end end;_c.updateSize(ac,bc)end;if(db~=nil)then ac=#db[1][1]bc=#db;c_a(db)end
return
{recalculateSize=dd,setFrame=c_a,getFrame=function()local d_a={}
for _aa,aaa in
pairs(cc)do table.insert(d_a,{aaa,dc[_aa],_d[_aa]})end;for _aa,aaa in pairs(cd)do d_a[_aa]=aaa end;return d_a,ac,bc end,getImage=function()
local d_a={}for _aa,aaa in pairs(cc)do
table.insert(d_a,{aaa,dc[_aa],_d[_aa]})end;return d_a end,setFrameData=function(d_a,_aa)
if(
_aa~=nil)then cd[d_a]=_aa else if(type(d_a)=="table")then cd=d_a end end end,setFrameImage=function(d_a)
for _aa,aaa in pairs(d_a.t)do
cc[_aa]=d_a.t[_aa]dc[_aa]=d_a.fg[_aa]_d[_aa]=d_a.bg[_aa]end end,getFrameImage=function()
return{t=cc,fg=dc,bg=_d}end,getFrameData=function(d_a)return(d_a~=nil and cd[d_a]or cd)end,blit=function(d_a,_aa,aaa,baa,caa)
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
local ac={creator="Bimg Library by NyoriE",date=os.date("!%Y-%m-%dT%TZ")}local bc,cc=0,0;local dc={}
local function _d(cd,dd)cd=cd or#_c+1
table.insert(_c,cd,cb(dd,dc))if(dd==nil)then _c[cd].setSize(bc,cc)end end;local function ad(cd)table.remove(_c,cd or#_c)end
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
_c[cd]end,addFrame=function(cd)local dd=cb()if(#_c<=1)then
if(ac.animated==nil)then ac.animated=true end
if(ac.secondsPerFrame==nil)then ac.secondsPerFrame=0.2 end end;_d(cd)return dd end,removeFrame=function(cd)
ad(cd)
if(#_c<=1)then if(ac.animated==nil)then ac.animated=true end;if
(ac.secondsPerFrame==nil)then ac.secondsPerFrame=0.2 end end end,moveFrame=bd,setFrameData=function(cd,dd,__a)
if(
_c[cd]~=nil)then _c[cd].setFrameData(dd,__a)end end,getFrameData=function(cd,dd)return _c[cd]~=nil and
_c[cd].getFrameData(dd)end,getSize=function()return
bc,cc end,setAnimation=function(cd)ac.animation=cd end,setMetadata=function(cd,dd)if(dd~=nil)then ac[cd]=dd else if(
type(cd)=="table")then ac=cd end end end,getMetadata=function(cd)return
cd~=nil and ac[cd]or ac end,createBimg=function()
local cd={}
for dd,__a in pairs(_c)do local a_a=__a.getFrame()table.insert(cd,a_a)end;for dd,__a in pairs(ac)do cd[dd]=__a end;cd.width=bc;cd.height=cc;return cd end}
if(db~=nil)then for cd,dd in pairs(db)do
if(type(cd)=="string")then ac[cd]=dd else _d(cd,dd)end end
if
(ac.width==nil)or(ac.height==nil)then for cd,dd in pairs(_c)do local __a,a_a=dd.getSize()if(__a>bc)then __a=bc end
if(a_a>cc)then a_a=cc end end
dc.updateSize(bc,cc,true)end else _d(1)end;return dc end end
aa["libraries"]["images"]=function(...)
local ab,bb,cb=string.sub,math.floor,string.rep
local function db(bd)local cd={{}}local dd=fs.open(bd,"r")
if(dd~=nil)then for __a in dd.readLine do
table.insert(cd[1],{cb(" ",#__a),cb(" ",
#__a),__a})end;dd.close()return cd end end
local function _c(bd)return paintutils.loadImage(bd),"nfp"end
local function ac(bd)local cd=fs.open(bd,"rb")
local dd=textutils.unserialize(cd.readAll())cd.close()if(dd~=nil)then return dd,"bimg"end end;local function bc(bd)end;local function cc(bd)end;local function dc(bd,cd)
if(cd==nil)then if(bd:find(".bimg"))then return ac(bd)elseif
(bd:find(".bbf"))then return bc(bd)else return _c(bd)end end end
local function _d(bd,cd)if(
cd==nil)then
if(bd:find(".bimg"))then return ac(bd)elseif(bd:find(".bbf"))then return cc(bd)else return db(bd)end end end
local function ad(bd,cd,dd)
local __a,a_a=bd.width or#bd[1][1][1],bd.height or#bd[1]local b_a={}
for c_a,d_a in pairs(bd)do
if(type(c_a)=="number")then local _aa={}
for y=1,dd do local aaa,baa,caa="","",""
local daa=bb(y/dd*a_a+0.5)
if(d_a[daa]~=nil)then
for x=1,cd do local _ba=bb(x/cd*__a+0.5)aaa=aaa..
ab(d_a[daa][1],_ba,_ba)
baa=baa..ab(d_a[daa][2],_ba,_ba)caa=caa..ab(d_a[daa][3],_ba,_ba)end;table.insert(_aa,{aaa,baa,caa})end end;table.insert(b_a,c_a,_aa)else b_a[c_a]=d_a end end;b_a.width=cd;b_a.height=dd;return b_a end
return{loadNFP=_c,loadBIMG=ac,loadImage=dc,resizeBIMG=ad,loadImageAsBimg=_d}end
aa["libraries"]["layout"]=function(...)
local function ab(cb)local db={}db.___value=nil;db.___name=cb
db.___children={}db.___props={}function db:value()return self.___value end;function db:setValue(_c)
self.___value=_c end;function db:name()return self.___name end;function db:setName(_c)
self.___name=_c end;function db:children()return self.___children end;function db:numChildren()return
#self.___children end
function db:addChild(_c)
if
self[_c:name()]~=nil then if
type(self[_c:name()].name)=="function"then local ac={}table.insert(ac,self[_c:name()])
self[_c:name()]=ac end
table.insert(self[_c:name()],_c)else self[_c:name()]=_c end;table.insert(self.___children,_c)end;function db:properties()return self.___props end;function db:numProperties()
return#self.___props end
function db:addProperty(_c,ac)local bc="@".._c
if self[bc]~=nil then if
type(self[bc])=="string"then local cc={}table.insert(cc,self[bc])
self[bc]=cc end
table.insert(self[bc],ac)else self[bc]=ac end
table.insert(self.___props,{name=_c,value=self[_c]})end;return db end;local bb={}
function bb:ToXmlString(cb)cb=string.gsub(cb,"&","&amp;")
cb=string.gsub(cb,"<","&lt;")cb=string.gsub(cb,">","&gt;")
cb=string.gsub(cb,"\"","&quot;")
cb=string.gsub(cb,"([^%w%&%;%p%\t% ])",function(db)
return string.format("&#x%X;",string.byte(db))end)return cb end
function bb:FromXmlString(cb)
cb=string.gsub(cb,"&#x([%x]+)%;",function(db)
return string.char(tonumber(db,16))end)
cb=string.gsub(cb,"&#([0-9]+)%;",function(db)return string.char(tonumber(db,10))end)cb=string.gsub(cb,"&quot;","\"")
cb=string.gsub(cb,"&apos;","'")cb=string.gsub(cb,"&gt;",">")
cb=string.gsub(cb,"&lt;","<")cb=string.gsub(cb,"&amp;","&")return cb end;function bb:ParseArgs(cb,db)
string.gsub(db,"(%w+)=([\"'])(.-)%2",function(_c,ac,bc)
cb:addProperty(_c,self:FromXmlString(bc))end)end
function bb:ParseXmlText(cb)
local db={}local _c=ab()table.insert(db,_c)local ac,bc,cc,dc,_d;local ad,bd=1,1
while true do
ac,bd,bc,cc,dc,_d=string.find(cb,"<(%/?)([%w_:]+)(.-)(%/?)>",ad)if not ac then break end;local dd=string.sub(cb,ad,ac-1)
if not
string.find(dd,"^%s*$")then
local __a=(_c:value()or"")..self:FromXmlString(dd)db[#db]:setValue(__a)end
if _d=="/"then local __a=ab(cc)self:ParseArgs(__a,dc)
_c:addChild(__a)elseif bc==""then local __a=ab(cc)self:ParseArgs(__a,dc)
table.insert(db,__a)_c=__a else local __a=table.remove(db)_c=db[#db]
if#db<1 then error("XmlParser: nothing to close with "..
cc)end;if __a:name()~=cc then
error("XmlParser: trying to close "..__a.name.." with "..cc)end;_c:addChild(__a)end;ad=bd+1 end;local cd=string.sub(cb,ad)if#db>1 then
error("XmlParser: unclosed "..db[#db]:name())end;return _c end
function bb:loadFile(cb,db)if not db then db=system.ResourceDirectory end
local _c=system.pathForFile(cb,db)local ac,bc=io.open(_c,"r")
if ac and not bc then local cc=ac:read("*a")
io.close(ac)return self:ParseXmlText(cc),nil else print(bc)return nil end end;return bb end
aa["libraries"]["module"]=function(...)return function(ab)local bb,cb=pcall(da,ab)
return bb and cb or nil end end
aa["libraries"]["process"]=function(...)local ab={}local bb={}local cb=0
local db=dofile("rom/modules/main/cc/require.lua").make
function bb:new(_c,ac,bc,...)local cc={...}
local dc=setmetatable({path=_c},{__index=self})dc.window=ac;ac.current=term.current;ac.redirect=term.redirect
dc.processId=cb
if(type(_c)=="string")then
dc.coroutine=coroutine.create(function()
local _d=shell.resolveProgram(_c)local ad=setmetatable(bc,{__index=_ENV})ad.shell=shell
ad.basaltProgram=true;ad.arg={[0]=_c,table.unpack(cc)}
ad.require,ad.package=db(ad,fs.getDir(_d))
if(fs.exists(_d))then local bd=fs.open(_d,"r")local cd=bd.readAll()
bd.close()local dd=load(cd,_c,"bt",ad)if(dd~=nil)then return dd()end end end)elseif(type(_c)=="function")then
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
aa["libraries"]["tHex"]=function(...)
return
{[colors.white]="0",[colors.orange]="1",[colors.magenta]="2",[colors.lightBlue]="3",[colors.yellow]="4",[colors.lime]="5",[colors.pink]="6",[colors.gray]="7",[colors.lightGray]="8",[colors.cyan]="9",[colors.purple]="a",[colors.blue]="b",[colors.brown]="c",[colors.green]="d",[colors.red]="e",[colors.black]="f"}end
aa["libraries"]["utils"]=function(...)
local ab,bb,cb=string.sub,string.find,string.reverse
local function db(ad,bd)local cd={}if ad==""or bd==""then return cd end;local dd=1
local __a,a_a=bb(ad,bd,dd)while __a do table.insert(cd,ab(ad,dd,__a-1))dd=a_a+1
__a,a_a=bb(ad,bd,dd)end
table.insert(cd,ab(ad,dd))return cd end
local _c={[0]={8,4,3,6,5},{4,14,8,7},{6,10,8,7},{9,11,8,0},{1,14,8,0},{13,12,8,0},{2,10,8,0},{15,8,10,11,12,14},{0,7,1,9,2,13},{3,11,8,7},{2,6,7,15},{9,3,7,15},{13,5,7,15},{5,12,8,7},{1,4,7,15},{7,10,11,12,14}}local ac,bc,cc={},{},{}for i=0,15 do bc[2 ^i]=i end
do local ad="0123456789abcdef"
for i=1,16 do ac[ad:sub(i,i)]=
i-1;ac[i-1]=ad:sub(i,i)
cc[ad:sub(i,i)]=2 ^ (i-1)cc[2 ^ (i-1)]=ad:sub(i,i)local bd=_c[i-1]for i=1,#bd do
bd[i]=2 ^bd[i]end end end
local function dc(ad)local bd=_c[bc[ad[#ad][1]]]
for j=1,#bd do local cd=bd[j]for i=1,#ad-1 do if
ad[i][1]==cd then return i end end end;return 1 end
local function _d(ad,bd)
if not bd then local dd={}bd={}for i=1,6 do local __a=ad[i]local a_a=bd[__a]
bd[__a],dd[i]=a_a and(a_a+1)or 1,__a end;ad=dd end;local cd={}for dd,__a in pairs(bd)do cd[#cd+1]={dd,__a}end
if#cd>1 then
while
#cd>2 do
table.sort(cd,function(d_a,_aa)return d_a[2]>_aa[2]end)local __a,a_a=dc(cd),#cd;local b_a,c_a=cd[a_a][1],cd[__a][1]
for i=1,6 do if ad[i]==b_a then
ad[i]=c_a;cd[__a][2]=cd[__a][2]+1 end end;cd[a_a]=nil end;local dd=128
for i=1,#ad-1 do if ad[i]~=ad[6]then dd=dd+2 ^ (i-1)end end;return string.char(dd),
cc[cd[1][1]==ad[6]and cd[2][1]or cd[1][1]],cc[ad[6]]else
return"\128",cc[ad[1]],cc[ad[1]]end end
return
{getTextHorizontalAlign=function(ad,bd,cd,dd)ad=ab(ad,1,bd)local __a=bd-string.len(ad)
if(cd=="right")then ad=string.rep(
dd or" ",__a)..ad elseif(cd=="center")then
ad=string.rep(dd or" ",math.floor(
__a/2))..ad..
string.rep(dd or" ",math.floor(__a/2))
ad=ad.. (string.len(ad)<bd and(dd or" ")or"")else ad=ad..string.rep(dd or" ",__a)end;return ad end,getTextVerticalAlign=function(ad,bd)
local cd=0
if(bd=="center")then cd=math.ceil(ad/2)if(cd<1)then cd=1 end end;if(bd=="bottom")then cd=ad end;if(cd<1)then cd=1 end;return cd end,rpairs=function(ad)return function(bd,cd)cd=
cd-1;if cd~=0 then return cd,bd[cd]end end,ad,
#ad+1 end,tableCount=function(ad)
local bd=0;if(ad~=nil)then for cd,dd in pairs(ad)do bd=bd+1 end end;return bd end,splitString=db,createText=function(ad,bd)
local cd=db(ad,"\n")local dd={}
for __a,a_a in pairs(cd)do if(#a_a==0)then table.insert(dd,"")end
while#a_a>
bd do local b_a=bb(cb(ab(a_a,1,bd))," ")if not b_a then b_a=bd else
b_a=bd-b_a+1 end;local c_a=ab(a_a,1,b_a)
table.insert(dd,c_a)a_a=ab(a_a,b_a+1)end;if#a_a>0 then table.insert(dd,a_a)end end;return dd end,getValueFromXML=function(ad,bd)
local cd;if(type(bd)~="table")then return end;if(bd[ad]~=nil)then
if
(type(bd[ad])=="table")then if(bd[ad].value~=nil)then cd=bd[ad]:value()end end end;if(cd==nil)then
cd=bd["@"..ad]end;if(cd=="true")then cd=true elseif(cd=="false")then cd=false elseif(tonumber(cd)~=nil)then
cd=tonumber(cd)end;return cd end,numberFromString=function(ad)return load(
"return "..ad)()end,uuid=function()
local ad=math.random
local function bd()local cd='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'return
string.gsub(cd,'[xy]',function(dd)local __a=
(dd=='x')and ad(0,0xf)or ad(8,0xb)
return string.format('%x',__a)end)end;return bd()end,array=function(ad,bd)return
load(
"return {"..
("nil,"):rep(ad).. ("[0]=nil,"):rep(bd).."}")()end,shrink=function(ad,bd)local cd,dd,__a,a_a={{},{},{}},0,
#ad+#ad%3,bd or colours.black;for i=1,#ad do if
#ad[i]>dd then dd=#ad[i]end end
for y=0,__a-1,3 do
local b_a,c_a,d_a,_aa={},{},{},1
for x=0,dd-1,2 do local aaa,baa={},{}
for yy=1,3 do
for xx=1,2 do
aaa[#aaa+1]=(ad[y+yy]and ad[y+yy][x+xx])and
(ad[y+
yy][x+xx]==0 and a_a or ad[y+yy][x+xx])or a_a;baa[aaa[#aaa]]=
baa[aaa[#aaa]]and(baa[aaa[#aaa]]+1)or 1 end end;b_a[_aa],c_a[_aa],d_a[_aa]=_d(aaa,baa)_aa=_aa+1 end
cd[1][#cd[1]+1],cd[2][#cd[2]+1],cd[3][#cd[3]+1]=table.concat(b_a),table.concat(c_a),table.concat(d_a)end;cd.width,cd.height=#cd[1][1],#cd[1]return cd end}end;return aa["main"]()