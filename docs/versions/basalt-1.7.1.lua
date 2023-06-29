local aa={}local ba=true;local ca=require
local da=function(ab)
for bb,cb in pairs(aa)do
if(type(cb)=="table")then for db,_c in pairs(cb)do if(db==ab)then
return _c()end end else if(bb==ab)then return cb()end end end;return ca(ab)end
local _b=function(ab)if(ab~=nil)then return aa[ab]end;return aa end
aa["loadObjects"]=function(...)local ab={}if(ba)then
for db,_c in pairs(_b("objects"))do ab[db]=_c()end;return ab end;local bb=table.pack(...)local cb=fs.getDir(
bb[2]or"Basalt")if(cb==nil)then
error("Unable to find directory "..bb[2]..
" please report this bug to our discord.")end
for db,_c in
pairs(fs.list(fs.combine(cb,"objects")))do if(_c~="example.lua")and not(_c:find(".disabled"))then
local ac=_c:gsub(".lua","")ab[ac]=da(ac)end end;return ab end
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
__a.__index=__a;bd=setmetatable(__a,bd)end;return bd end end end;return bc end}end;aa["plugins"]={}
aa["plugins"]["debug"]=function(...)local ab=da("utils")
local bb=ab.wrapText
return
{basalt=function(cb)local db;local _c;local ac;local bc;local cc
local function dc()if(db==nil)then db=cb.getMainFrame()end
local _d=16;local ad=6;local bd=99;local cd=99;local dd,__a=db:getSize()
_c=db:addMovableFrame("basaltDebuggingFrame"):setSize(
dd-10,__a-6):setBackground(colors.black):setForeground(colors.white):setZ(100):hide()
_c:addPane():setSize("{parent.w}",1):setPosition(1,1):setBackground(colors.cyan):setForeground(colors.black)
_c:setPosition(-dd,__a/2 -_c:getHeight()/2):setBorder(colors.cyan)
local a_a=_c:addButton():setPosition("{parent.w}","{parent.h}"):setSize(1,1):setText("\133"):setForeground(colors.black):setBackground(colors.cyan):onClick(function()
end):onDrag(function(b_a,c_a,d_a,_aa,aaa)
local baa,caa=_c:getSize()local daa,_ba=baa,caa;if(baa+_aa-1 >=_d)and(baa+_aa-1 <=bd)then daa=baa+
_aa-1 end
if(caa+aaa-1 >=ad)and(
caa+aaa-1 <=cd)then _ba=caa+aaa-1 end;_c:setSize(daa,_ba)end)
cc=_c:addButton():setText("Close"):setPosition("{parent.w - 6}",1):setSize(7,1):setBackground(colors.red):setForeground(colors.white):onClick(function()
_c:animatePosition(
-dd,__a/2 -_c:getHeight()/2,0.5)end)
ac=_c:addList():setSize("{parent.w - 2}","{parent.h - 3}"):setPosition(2,3):setBackground(colors.black):setForeground(colors.white):setSelectionColor(colors.black,colors.white)
if(bc==nil)then
bc=db:addLabel():setPosition(1,"{parent.h}"):setBackground(colors.black):setForeground(colors.white):setZ(100):onClick(function()
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
dc:setForeground(_d:getTheme(db.."Text"))end end}return cc end end;return bb end
aa["plugins"]["dynamicValues"]=function(...)
local ab={clamp=true,round=true,math=true,colors=true}
local function bb(ac)if(ab[ac])then return ac end
if ac:sub(1,1):find('%a')and
not ac:find('.',1,true)then return'"'..ac..'"'end;return ac end
local function cb(ac)ac=ac:gsub("{","")ac=ac:gsub("}","")
for bc,cc in pairs(colors)do if
(type(bc)=="string")then
ac=ac:gsub("%f[%w]"..bc.."%f[%W]","colors."..bc)end end
ac=ac:gsub("(%s?)([%w.]+)",function(bc,cc)return bc..bb(cc)end)ac=ac:gsub("%s?%?"," and ")ac=ac:gsub("%s?:"," or ")
ac=ac:gsub("%.w%f[%W]",".width")ac=ac:gsub("%.h%f[%W]",".height")return ac end
local function db(ac,bc)bc.math=math;bc.colors=colors;bc.clamp=function(dc,_d,ad)
return math.min(math.max(dc,_d),ad)end;bc.round=function(dc)return math.floor(dc+
0.5)end;local cc=load(
"return "..ac,"",nil,bc)
if(cc==nil)then error(ac..
" - is not a valid dynamic value string")end;return cc()end
local function _c(ac,bc,cc,dc)local _d={}local ad={}cc=cb(cc)local bd=nil;local cd=true;local function dd()cd=true end
for a_a in
cc:gmatch("%a+%.%a+")do local b_a=a_a:gsub("%.%a+","")local c_a=a_a:gsub("%a+%.","")if(
_d[b_a]==nil)then _d[b_a]={}end
table.insert(_d[b_a],c_a)end
for a_a,b_a in pairs(_d)do
if(a_a=="self")then
for c_a,d_a in pairs(b_a)do
if(bc~=d_a)then
ac:addPropertyObserver(d_a,dd)
if(d_a=="clicked")or(d_a=="dragging")then
ac:listenEvent("mouse_click")ac:listenEvent("mouse_up")end
if(d_a=="dragging")then ac:listenEvent("mouse_drag")end;if(d_a=="hovered")then end
table.insert(ad,{obj=ac,name=d_a})else error("Dynamic Values - self reference to self")end end end
if(a_a=="parent")then for c_a,d_a in pairs(b_a)do
ac:getParent():addPropertyObserver(d_a,dd)
table.insert(ad,{obj=ac:getParent(),name=d_a})end end
if(a_a~="self"and a_a~="parent")and(ab[a_a]==nil)then
local c_a=ac:getParent():getChild(a_a)for d_a,_aa in pairs(b_a)do c_a:addPropertyObserver(_aa,dd)
table.insert(ad,{obj=c_a,name=_aa})end end end
local function __a()local a_a={}local b_a=ac:getParent()
for c_a,d_a in pairs(_d)do local _aa={}if(c_a=="self")then for aaa,baa in pairs(d_a)do
_aa[baa]=ac:getProperty(baa)end end;if(c_a==
"parent")then
for aaa,baa in pairs(d_a)do _aa[baa]=b_a:getProperty(baa)end end
if
(c_a~="self")and(c_a~="parent")and(ab[c_a]==nil)then local aaa=b_a:getChild(c_a)if
(aaa==nil)then
error("Dynamic Values - unable to find object: "..c_a)end;for baa,caa in pairs(d_a)do
_aa[caa]=aaa:getProperty(caa)end end;a_a[c_a]=_aa end;return db(cc,a_a)end
return
{get=function(a_a)
if(cd)then bd=__a()+0.5
if(type(bd)=="number")then bd=math.floor(bd+0.5)end;cd=false;ac:updatePropertyObservers(bc)end;return bd end,removeObservers=function(a_a)
for b_a,c_a in
pairs(ad)do c_a.obj:removePropertyObserver(c_a.name,dd)end end}end
return
{Object=function(ac,bc)local cc={}local dc={}
local function _d(ad,bd,cd)
if
(type(cd)=="string")and(cd:sub(1,1)=="{")and(cd:sub(-1)=="}")then if(dc[bd]~=nil)then
dc[bd].removeObservers()end;dc[bd]=_c(ad,bd,cd,bc)cd=dc[bd].get end;return cd end
return
{updatePropertyObservers=function(ad,bd)
if(cc[bd]~=nil)then for cd,dd in pairs(cc[bd])do dd(ad,bd)end end;return ad end,setProperty=function(ad,bd,cd,dd)cd=_d(ad,bd,cd)
ac.setProperty(ad,bd,cd,dd)
if(cc[bd]~=nil)then for __a,a_a in pairs(cc[bd])do a_a(ad,bd)end end;return ad end,addPropertyObserver=function(ad,bd,cd)
bd=bd:gsub("^%l",string.upper)if(cc[bd]==nil)then cc[bd]={}end
table.insert(cc[bd],cd)end,removePropertyObserver=function(ad,bd,cd)
bd=bd:gsub("^%l",string.upper)
if(cc[bd]~=nil)then for dd,__a in pairs(cc[bd])do
if(__a==cd)then table.remove(cc[bd],dd)end end end end}end}end
aa["plugins"]["textures"]=function(...)local ab=da("images")local bb=string.sub
return
{VisualObject=function(cb)local db={}
local _c={addTexture=function(ac,bc,cc,dc,_d,ad,bd,cd,dd)
if(
type(bc)=="function")then table.insert(db,bc)else if(type(bc)=="table")then
cc,dc,_d,ad,bd,cd,dd=bc.x,bc.y,bc.w,bc.h,bc.stretch,bc.animate,bc.infinitePlay;bc=bc.path end
local __a=db.loadImageAsBimg(bc)
local a_a={image=__a,x=cc,y=dc,w=_d,h=ad,animated=cd,curTextId=1,infinitePlay=dd}if(bd)then a_a.w=ac:getWidth()a_a.h=ac:getHeight()
a_a.image=db.resizeBIMG(__a,a_a.w,a_a.h)end
table.insert(db,a_a)
if(cd)then
if(__a.animated)then ac:listenEvent("other_event")
local b_a=
__a[a_a.curTextId].duration or __a.secondsPerFrame or 0.2;a_a.timer=os.startTimer(b_a)end end end;ac:setDrawState("texture-base",true)
ac:updateDraw()return ac end,removeTexture=function(ac,bc)
table.remove(db,bc)
if(#db==0)then ac:setDrawState("texture-base",false)end;ac:updateDraw()return ac end,clearTextures=function(ac)
db={}ac:setDrawState("texture-base",false)
ac:updateDraw()return ac end,eventHandler=function(ac,bc,cc,...)
cb.eventHandler(ac,bc,cc,...)
if(bc=="timer")then
for dc,_d in pairs(db)do
if(type(_d)=="table")then
if(_d.timer==cc)then
if(_d.animated)then
if(
_d.image[_d.curTextId+1]~=nil)then _d.curTextId=_d.curTextId+1
local ad=
_d.image[_d.curTextId].duration or _d.image.secondsPerFrame or 0.2;_d.timer=os.startTimer(ad)ac:updateDraw()else
if(_d.infinitePlay)then
_d.curTextId=1;local ad=
_d.image[_d.curTextId].duration or _d.image.secondsPerFrame or 0.2
_d.timer=os.startTimer(ad)ac:updateDraw()end end end end end end end end,draw=function(ac)
cb.draw(ac)
ac:addDraw("texture-base",function()
for bc,cc in pairs(db)do
if(type(cc)=="table")then local dc=#
cc.image[cc.curTextId][1][1]
local _d=#cc.image[cc.curTextId][1]local ad=cc.w>dc and dc or cc.w
local bd=cc.h>_d and _d or cc.h
for k=1,bd do if(cc.image[k]~=nil)then
local cd,dd,__a=table.unpack(cc.image[k])
ac:addBlit(1,k,bb(cd,1,ad),bb(dd,1,ad),bb(__a,1,ad))end end else if(type(cc)=="function")then cc(ac)end end end end)ac:setDrawState("texture-base",false)end}return _c end}end
aa["plugins"]["basaltAdditions"]=function(...)return
{basalt=function()return
{cool=function()print("ello")sleep(2)end}end}end
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
if(ad~=false)then ac:addForegroundBox(1,_d,1,1,ad)end;ac:addBackgroundBox(1,_d,1,1,db["left"])end end end)end}return _c end}end
aa["plugins"]["bigfonts"]=function(...)local ab=da("tHex")
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
d_a[nLine]=table.concat(caa)end;return{a_a,c_a,d_a}end
return
{Label=function(bc)local cc=1;local dc
local _d={setFontSize=function(ad,bd)
if(type(bd)=="number")then cc=bd
if(cc>1)then
ad:setDrawState("label",false)
dc=ac(cc-1,ad:getText(),ad:getForeground(),ad:getBackground()or colors.lightGray)if(ad:getAutoSize())then
ad:getBase():setSize(#dc[1][1],#dc[1]-1)end else
ad:setDrawState("label",true)end;ad:updateDraw()end;return ad end,setText=function(ad,bd)
bc.setText(ad,bd)
if(cc>1)then if(ad:getAutoSize())then
ad:getBase():setSize(#dc[1][1],#dc[1]-1)end end;return ad end,getFontSize=function(ad)
return cc end,draw=function(ad)bc.draw(ad)
ad:addDraw("bigfonts",function()
if(cc>1)then
local bd,cd=#dc[1][1],#dc[1]for i=1,cd do ad:addFg(1,i,dc[2][i])ad:addBg(1,i,dc[3][i])
ad:addText(1,i,dc[1][i])end end end)end}return _d end}end
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
aa["plugins"]["moreDrawing"]=function(...)local ab=da("tHex")
local function bb(dc,_d,ad,bd)local cd={}
local dd=math.abs(ad-dc)local __a=math.abs(bd-_d)local a_a=(dc<ad)and 1 or-1;local b_a=
(_d<bd)and 1 or-1;local c_a=dd-__a
while true do
table.insert(cd,{x=dc,y=_d})if(dc==ad and _d==bd)then break end;local d_a=c_a*2;if d_a>-__a then c_a=c_a-__a;dc=
dc+a_a end
if d_a<dd then c_a=c_a+dd;_d=_d+b_a end end;return cd end
local function cb(dc,_d,ad,bd)local cd={}
local function dd(d_a,_aa,aaa,baa)
table.insert(cd,{x=d_a+aaa,y=_aa+baa})table.insert(cd,{x=d_a-aaa,y=_aa+baa})table.insert(cd,{x=
d_a+aaa,y=_aa-baa})table.insert(cd,{x=d_a-aaa,y=
_aa-baa})
table.insert(cd,{x=d_a+baa,y=_aa+aaa})table.insert(cd,{x=d_a-baa,y=_aa+aaa})table.insert(cd,{x=
d_a+baa,y=_aa-aaa})table.insert(cd,{x=d_a-baa,y=
_aa-aaa})end
local function __a(d_a,_aa,aaa,baa)for fillX=-aaa,aaa do
table.insert(cd,{x=d_a+fillX,y=_aa+baa})
table.insert(cd,{x=d_a+fillX,y=_aa-baa})end
for fillY=-baa,baa do table.insert(cd,{x=d_a+fillY,y=
_aa+aaa})table.insert(cd,{x=d_a+fillY,y=
_aa-aaa})end end;local a_a=0;local b_a=ad;local c_a=3 -2 *ad;if bd then __a(dc,_d,a_a,b_a)else
dd(dc,_d,a_a,b_a)end
while b_a>=a_a do a_a=a_a+1
if c_a>0 then b_a=b_a-1;c_a=c_a+
4 * (a_a-b_a)+10 else c_a=c_a+4 *a_a+6 end
if bd then __a(dc,_d,a_a,b_a)else dd(dc,_d,a_a,b_a)end end;return cd end
local function db(dc,_d,ad,bd,cd)local dd={}
local function __a(aaa,baa,caa,daa)
table.insert(dd,{x=aaa+caa,y=baa+daa})table.insert(dd,{x=aaa-caa,y=baa+daa})table.insert(dd,{x=
aaa+caa,y=baa-daa})table.insert(dd,{x=aaa-caa,y=
baa-daa})end
local function a_a(aaa,baa,caa,daa)for fillX=-caa,caa do
table.insert(dd,{x=aaa+fillX,y=baa+daa})
table.insert(dd,{x=aaa+fillX,y=baa-daa})end end;local b_a=0;local c_a=bd
local d_a=(bd*bd)- (ad*ad*bd)+ (0.25 *ad*ad)__a(dc,_d,b_a,c_a)
while
( (ad*ad* (c_a-0.5))> (bd*bd* (b_a+1)))do if(d_a<0)then
d_a=d_a+ (2 *bd*bd*b_a)+ (3 *bd*bd)else
d_a=d_a+ (2 *bd*bd*b_a)- (2 *ad*ad*c_a)+ (2 *ad*ad)c_a=c_a-1 end
b_a=b_a+1;if cd then a_a(dc,_d,b_a,c_a)end end
local _aa=( (bd*bd)* ( (b_a+0.5)* (b_a+0.5)))+ ( (ad*ad)*
( (c_a-1)* (c_a-1)))- (ad*ad*bd*bd)
while c_a>0 do c_a=c_a-1
if _aa<0 then _aa=
_aa+ (2 *bd*bd*b_a)- (2 *ad*ad*c_a)+ (ad*ad)b_a=b_a+1 else _aa=_aa- (2 *ad*ad*
c_a)+ (ad*ad)end;if cd then a_a(dc,_d,b_a,c_a)end end;return dd end
local function _c(dc,_d)local ad={}local bd={}for dd,__a in ipairs(dc)do
table.insert(bd,{x=__a.x,y=__a.y})end;if bd[1].x~=bd[#bd].x or bd[1].y~=
bd[#bd].y then
table.insert(bd,{x=bd[1].x,y=bd[1].y})end;local cd={}
for i=1,#bd-1 do local dd=bb(bd[i].x,bd[i].y,bd[
i+1].x,bd[i+1].y)for __a,a_a in
ipairs(dd)do table.insert(cd,a_a)end end
if _d then local dd,__a,a_a,b_a=math.huge,-math.huge,math.huge,-math.huge
for d_a,_aa in
ipairs(bd)do dd=math.min(dd,_aa.x)__a=math.max(__a,_aa.x)
a_a=math.min(a_a,_aa.y)b_a=math.max(b_a,_aa.y)end;local c_a={}
for y=a_a,b_a do
for x=dd,__a do local d_a=0;for i=1,#bd-1 do
if( (bd[i].y>y)~= (bd[i+1].y>y))and
(x< (
bd[i+1].x-bd[i].x)* (y-bd[i].y)/
(bd[i+1].y-bd[i].y)+bd[i].x)then d_a=d_a+1 end end;if
d_a%2 ==1 then table.insert(c_a,{x=x,y=y})end end end;return c_a end;return cd end
local function ac(dc,_d,ad,bd,cd)local dd={}
if cd then for y=_d,_d+bd-1 do
for x=dc,dc+ad-1 do table.insert(dd,{x=x,y=y})end end else
for x=dc,dc+ad-1 do
table.insert(dd,{x=x,y=_d})table.insert(dd,{x=x,y=_d+bd-1})end;for y=_d,_d+bd-1 do table.insert(dd,{x=dc,y=y})
table.insert(dd,{x=dc+ad-1,y=y})end end;return dd end;local bc,cc=string.rep,string.sub
return
{VisualObject=function(dc)local _d={}
for ad,bd in pairs({"Text","Bg","Fg"})do
_d["add"..bd..
"Line"]=function(cd,dd,__a,a_a,b_a,c_a)
if(type(c_a)=="number")then c_a=ab[c_a]end;if(#c_a>1)then c_a=cc(c_a,1,1)end;local d_a=bb(dd,__a,a_a,b_a)
for _aa,aaa in
ipairs(d_a)do cd["add"..bd](cd,aaa.x,aaa.y,c_a)end;return cd end
_d["add"..bd.."Circle"]=function(cd,dd,__a,a_a,b_a,c_a)
if(type(c_a)=="number")then c_a=ab[c_a]end;if(#c_a>1)then c_a=cc(c_a,1,1)end;local d_a=cb(dd,__a,a_a,b_a)
for _aa,aaa in
ipairs(d_a)do cd["add"..bd](cd,aaa.x,aaa.y,c_a)end;return cd end
_d["add"..bd.."Ellipse"]=function(cd,dd,__a,a_a,b_a,c_a,d_a)
if(type(d_a)=="number")then d_a=ab[d_a]end;if(#d_a>1)then d_a=cc(d_a,1,1)end
local _aa=db(dd,__a,a_a,b_a,c_a)
for aaa,baa in ipairs(_aa)do cd["add"..bd](cd,baa.x,baa.y,d_a)end;return cd end
_d["add"..bd.."Polygon"]=function(cd,dd,__a,a_a)
if(type(a_a)=="number")then a_a=ab[a_a]end;if(#a_a>1)then a_a=cc(a_a,1,1)end;local b_a=_c(dd,__a)
for c_a,d_a in ipairs(b_a)do cd["add"..
bd](cd,d_a.x,d_a.y,a_a)end;return cd end
_d["add"..bd.."Rectangle"]=function(cd,dd,__a,a_a,b_a,c_a,d_a)if(type(d_a)=="number")then
d_a=ab[d_a]end;if(#d_a>1)then d_a=cc(d_a,1,1)end
local _aa=ac(dd,__a,a_a,b_a,c_a)
for aaa,baa in ipairs(_aa)do cd["add"..bd](cd,baa.x,baa.y,d_a)end;return cd end end;return _d end}end
aa["plugins"]["animations"]=function(...)
local ab,bb,cb,db,_c,ac=math.floor,math.sin,math.cos,math.pi,math.sqrt,math.pow;local function bc(cab,dab,_bb)return cab+ (dab-cab)*_bb end
local function cc(cab)return cab end;local function dc(cab)return 1 -cab end
local function _d(cab)return cab*cab*cab end;local function ad(cab)return dc(_d(dc(cab)))end;local function bd(cab)return
bc(_d(cab),ad(cab),cab)end
local function cd(cab)return bb((cab*db)/2)end;local function dd(cab)return dc(cb((cab*db)/2))end;local function __a(cab)return- (
cb(db*x)-1)/2 end
local function a_a(cab)local dab=1.70158
local _bb=dab+1;return _bb*cab^3 -dab*cab^2 end;local function b_a(cab)return cab^3 end;local function c_a(cab)local dab=(2 *db)/3
return cab==0 and 0 or(cab==1 and 1 or
(-2 ^ (10 *
cab-10)*bb((cab*10 -10.75)*dab)))end
local function d_a(cab)return
cab==0 and 0 or 2 ^ (10 *cab-10)end
local function _aa(cab)return cab==0 and 0 or 2 ^ (10 *cab-10)end
local function aaa(cab)local dab=1.70158;local _bb=dab*1.525;return
cab<0.5 and( (2 *cab)^2 *
( (_bb+1)*2 *cab-_bb))/2 or
(
(2 *cab-2)^2 * ( (_bb+1)* (cab*2 -2)+_bb)+2)/2 end;local function baa(cab)return
cab<0.5 and 4 *cab^3 or 1 - (-2 *cab+2)^3 /2 end
local function caa(cab)
local dab=(2 *db)/4.5
return
cab==0 and 0 or(cab==1 and 1 or
(
cab<0.5 and- (2 ^ (20 *cab-10)*
bb((20 *cab-11.125)*dab))/2 or
(2 ^ (-20 *cab+10)*bb((20 *cab-11.125)*dab))/2 +1))end
local function daa(cab)return
cab==0 and 0 or(cab==1 and 1 or
(
cab<0.5 and 2 ^ (20 *cab-10)/2 or(2 -2 ^ (-20 *cab+10))/2))end;local function _ba(cab)return
cab<0.5 and 2 *cab^2 or 1 - (-2 *cab+2)^2 /2 end;local function aba(cab)return
cab<0.5 and 8 *
cab^4 or 1 - (-2 *cab+2)^4 /2 end;local function bba(cab)return
cab<0.5 and 16 *
cab^5 or 1 - (-2 *cab+2)^5 /2 end;local function cba(cab)
return cab^2 end;local function dba(cab)return cab^4 end
local function _ca(cab)return cab^5 end;local function aca(cab)local dab=1.70158;local _bb=dab+1;return
1 +_bb* (cab-1)^3 +dab* (cab-1)^2 end;local function bca(cab)return 1 -
(1 -cab)^3 end
local function cca(cab)local dab=(2 *db)/3;return

cab==0 and 0 or(cab==1 and 1 or(
2 ^ (-10 *cab)*bb((cab*10 -0.75)*dab)+1))end
local function dca(cab)return cab==1 and 1 or 1 -2 ^ (-10 *cab)end;local function _da(cab)return 1 - (1 -cab)* (1 -cab)end;local function ada(cab)return 1 - (
1 -cab)^4 end;local function bda(cab)
return 1 - (1 -cab)^5 end
local function cda(cab)return 1 -_c(1 -ac(cab,2))end;local function dda(cab)return _c(1 -ac(cab-1,2))end
local function __b(cab)return

cab<0.5 and(1 -_c(
1 -ac(2 *cab,2)))/2 or(_c(1 -ac(-2 *cab+2,2))+1)/2 end
local function a_b(cab)local dab=7.5625;local _bb=2.75
if(cab<1 /_bb)then return dab*cab*cab elseif(cab<2 /_bb)then local abb=cab-
1.5 /_bb;return dab*abb*abb+0.75 elseif(cab<2.5 /_bb)then local abb=cab-
2.25 /_bb;return dab*abb*abb+0.9375 else
local abb=cab-2.625 /_bb;return dab*abb*abb+0.984375 end end;local function b_b(cab)return 1 -a_b(1 -cab)end;local function c_b(cab)return
x<0.5 and(1 -
a_b(1 -2 *cab))/2 or(1 +a_b(2 *cab-1))/2 end
local d_b={linear=cc,lerp=bc,flip=dc,easeIn=_d,easeInSine=dd,easeInBack=a_a,easeInCubic=b_a,easeInElastic=c_a,easeInExpo=_aa,easeInQuad=cba,easeInQuart=dba,easeInQuint=_ca,easeInCirc=cda,easeInBounce=b_b,easeOut=ad,easeOutSine=cd,easeOutBack=aca,easeOutCubic=bca,easeOutElastic=cca,easeOutExpo=dca,easeOutQuad=_da,easeOutQuart=ada,easeOutQuint=bda,easeOutCirc=dda,easeOutBounce=a_b,easeInOut=bd,easeInOutSine=__a,easeInOutBack=aaa,easeInOutCubic=baa,easeInOutElastic=caa,easeInOutExpo=daa,easeInOutQuad=_ba,easeInOutQuart=aba,easeInOutQuint=bba,easeInOutCirc=__b,easeInOutBounce=c_b}local _ab=da("xmlParser")local aab=0;local bab
return
{VisualObject=function(cab,dab)local _bb={}local abb="linear"if(bab==nil)then
bab=dab.getRenderingThrottle()end
local function bbb(acb,bcb)for ccb,dcb in pairs(_bb)do
if(dcb.timerId==bcb)then return dcb end end end
local function cbb(acb,bcb,ccb,dcb,_db,adb,bdb,cdb,ddb,__c)local a_c,b_c=ddb(acb)if(_bb[bdb]~=nil)then
os.cancelTimer(_bb[bdb].timerId)end;_bb[bdb]={}
_bb[bdb].call=function()
local c_c=_bb[bdb].progress
local d_c=math.floor(d_b.lerp(a_c,bcb,d_b[adb](c_c/dcb))+0.5)
local _ac=math.floor(d_b.lerp(b_c,ccb,d_b[adb](c_c/dcb))+0.5)__c(acb,d_c,_ac)end
_bb[bdb].finished=function()__c(acb,bcb,ccb)aab=aab-1;if(aab==0)then
dab.setRenderingThrottle(bab)end;if(cdb~=nil)then cdb(acb)end end;_bb[bdb].timerId=os.startTimer(0.05 +_db)
_bb[bdb].progress=0;_bb[bdb].duration=dcb;_bb[bdb].mode=adb;aab=aab+1
dab.setRenderingThrottle(0)acb:listenEvent("other_event")end
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
dcb.timerId=os.startTimer(0.05)else dcb.finished()acb:doneHandler(ccb)end end end end}return _cb end}end
aa["plugins"]["templates"]=function(...)local ab=da("utils").splitString
local function bb(db)local _c={}for ac,bc in
pairs(db)do _c[ac]=bc end;return _c end
local cb={VisualObject=function(db,_c)
return
{__getElementPathTypes=function(ac,bc)if(bc~=nil)then table.insert(bc,1,ac:getTypes())else
bc={ac:getTypes()}end;local cc=ac:getParent()if(cc~=nil)then return
cc:__getElementPathTypes(bc)else return bc end end,init=function(ac)
db.init(ac)local bc=_c.getTemplate(ac)local cc=_c.getObjects()
if(bc~=nil)then for dc,_d in pairs(bc)do
if(
cc[dc]==nil)then if(colors[_d]~=nil)then ac:setProperty(dc,colors[_d])else
ac:setProperty(dc,_d)end end end end;return ac end}end,basalt=function()
local db={default={Background=colors.gray,Foreground=colors.black},BaseFrame={Background=colors.lightGray,Foreground=colors.black,Button={Background="{self.clicked ? black : gray}",Foreground="{self.clicked ? lightGray : black}"},Container={Background=colors.gray,Foreground=colors.black,Button={Background="{self.clicked ? lightGray : black}",Foreground="{self.clicked ? black : lightGray}"}},Checkbox={Background=colors.gray,Foreground=colors.black,Text="Checkbox"},Input={Background="{self.focused ? gray : black}",Foreground="{self.focused ? black : lightGray}",defaultBackground="{self.focused ? gray : black}",defaultForeground="{self.focused ? black : lightGray}",defaultText="..."}}}
local function _c(bc)
if(type(bc)=="string")then local cc=fs.open(bc,"r")
if(cc~=nil)then
local dc=cc.readAll()cc.close()db=textutils.unserializeJSON(dc)else error(
"Could not open template file "..bc)end end
if(type(bc)=="table")then for cc,dc in pairs(bc)do db[cc]=dc end end end
local function ac(bc,cc)local dc=bb(db.default)local _d=bc
if(_d~=nil)then
for ad,bd in pairs(cc)do
for cd,dd in pairs(bd)do if(_d[dd]~=nil)then
_d=_d[dd]for __a,a_a in pairs(_d)do dc[__a]=a_a end;break else
for __a,a_a in pairs(db.default)do dc[__a]=a_a end end end end end;return dc end;return
{getTemplate=function(bc)return ac(db,bc:__getElementPathTypes())end,addTemplate=_c}end}return cb end
aa["plugins"]["advancedBackground"]=function(...)local ab=da("xmlParser")
return
{VisualObject=function(bb)local cb=false
local db=colors.black
local _c={setBackground=function(ac,bc,cc,dc)bb.setBackground(ac,bc)cb=cc or cb;db=dc or db;return ac end,setBackgroundSymbol=function(ac,bc,cc)
cb=bc;db=cc or db;ac:updateDraw()return ac end,getBackgroundSymbol=function(ac)
return cb end,getBackgroundSymbolColor=function(ac)return db end,draw=function(ac)bb.draw(ac)
ac:addDraw("advanced-bg",function()
local bc,cc=ac:getSize()
if(cb~=false)then ac:addTextBox(1,1,bc,cc,cb:sub(1,1))if(cb~=" ")then
ac:addForegroundBox(1,1,bc,cc,db)end end end,2)end}return _c end}end
aa["plugins"]["shadow"]=function(...)
return
{VisualObject=function(ab)local bb=false
local cb={setShadow=function(db,_c)bb=_c;db:updateDraw()return db end,getShadow=function(db)return
bb end,draw=function(db)ab.draw(db)
db:addDraw("shadow",function()
if(bb~=false)then
local _c,ac=db:getSize()
if(bb)then db:addBackgroundBox(_c+1,2,1,ac,bb)
db:addBackgroundBox(2,ac+1,_c,1,bb)db:addForegroundBox(_c+1,2,1,ac,bb)
db:addForegroundBox(2,ac+1,_c,1,bb)end end end)end}return cb end}end
aa["plugins"]["reactiveXml"]=function(...)local ab=da("reactivePrimitives")
local bb=da("xmlParser")
local cb={fromXML=function(ac)local bc=bb.parseText(ac)local cc=nil
for dc,_d in ipairs(bc)do if(_d.tag=="script")then cc=_d.value
table.remove(bc,dc)break end end;return{nodes=bc,script=cc}end}
local db=function(ac,bc)return load(ac,nil,"t",bc)()end
local _c=function(ac,bc,cc,dc)
bc(ac,function(...)
local _d,ad=pcall(function()ab.transaction(load(cc,nil,"t",dc))end)if not _d then error("XML Error: "..ad)end end)end
return
{basalt=function(ac)
local bc={observable=ab.observable,derived=ab.derived,effect=ab.effect,transaction=ab.transaction,untracked=ab.untracked,layout=function(cc)if(not fs.exists(cc))then
error("Can't open file "..cc)end;local dc=fs.open(cc,"r")
local _d=dc.readAll()dc.close()return cb.fromXML(_d)end,createObjectsFromXMLNode=function(cc,dc)
local _d=dc[cc.tag]if(_d~=nil)then local cd={}for dd,__a in pairs(cc.attributes)do
cd[dd]=load("return "..__a,nil,"t",dc)end
return ac.createObjectsFromLayout(_d,cd)end
local ad=cc.tag:gsub("^%l",string.upper)local bd=ac:createObject(ad,cc.attributes["id"])
for cd,dd in
pairs(cc.attributes)do
if(cd:sub(1,2)=="on")then _c(bd,bd[cd],dd.."()",dc)else
ab.effect(function()local __a=load("return "..dd,
nil,"t",dc)()if
(colors[__a]~=nil)then __a=colors[__a]end;bd:setProperty(cd,__a)end)end end
for cd,dd in ipairs(cc.children)do local __a=ac.createObjectsFromXMLNode(dd,dc)for a_a,b_a in
ipairs(__a)do bd:addChild(b_a)end end;return{bd}end,createObjectsFromLayout=function(cc,dc)
local _d=_ENV;_d.props={}local ad={}for cd,dd in pairs(dc)do
ad[cd]=ac.derived(function()return dd()end)end
setmetatable(_d.props,{__index=function(cd,dd)return ad[dd]()end})if(cc.script~=nil)then
ab.transaction(function()db(cc.script,_d)end)end;local bd={}
for cd,dd in ipairs(cc.nodes)do
local __a=ac.createObjectsFromXMLNode(dd,_d)for a_a,b_a in ipairs(__a)do table.insert(bd,b_a)end end;return bd end}return bc end,Container=function(ac,bc)
local cc={loadLayout=function(dc,_d,ad)
local bd={}if(ad==nil)then ad={}end
for __a,a_a in pairs(ad)do bd[__a]=function()return a_a end end;local cd=bc.layout(_d)
local dd=bc.createObjectsFromLayout(cd,bd)for __a,a_a in ipairs(dd)do dc:addChild(a_a)end;return dc end}return cc end}end;aa["libraries"]={}
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
aa["libraries"]["basaltDraw"]=function(...)local ab=da("tHex")
local bb,cb=string.sub,string.rep
return
function(db)local _c=db or term.current()local ac;local bc,cc=_c.getSize()local dc={}
local _d={}local ad={}local bd;local cd={}
local function dd()bd=cb(" ",bc)for n=0,15 do local aaa=2 ^n;local baa=ab[aaa]
cd[aaa]=cb(baa,bc)end end;dd()
local function __a()dd()local aaa=bd;local baa=cd[colors.white]
local caa=cd[colors.black]
for currentY=1,cc do
dc[currentY]=bb(dc[currentY]==nil and aaa or dc[currentY]..aaa:sub(1,bc-
dc[currentY]:len()),1,bc)
ad[currentY]=bb(ad[currentY]==nil and baa or ad[currentY]..baa:sub(1,bc-
ad[currentY]:len()),1,bc)
_d[currentY]=bb(_d[currentY]==nil and caa or _d[currentY]..caa:sub(1,bc-
_d[currentY]:len()),1,bc)end end;__a()
local function a_a(aaa,baa,caa,daa,_ba)
if#caa==#daa and#caa==#_ba then
if baa>=1 and baa<=cc then
if
aaa+#caa>0 and aaa<=bc then local aba=aaa<1 and 1 -aaa+1 or 1;local bba=
aaa+#caa>bc and bc-aaa+1 or#caa
local cba,dba,_ca=dc[baa],ad[baa],_d[baa]local aca=bb(cba,1,aaa-1)..bb(caa,aba,bba)local bca=
bb(dba,1,aaa-1)..bb(daa,aba,bba)local cca=bb(_ca,1,aaa-1)..
bb(_ba,aba,bba)
if aaa+#caa<=bc then aca=aca..
bb(cba,aaa+#caa,bc)
bca=bca..bb(dba,aaa+#caa,bc)cca=cca..bb(_ca,aaa+#caa,bc)end;dc[baa],ad[baa],_d[baa]=aca,bca,cca end end end end
local function b_a(aaa,baa,caa)
if baa>=1 and baa<=cc then
if aaa+#caa>0 and aaa<=bc then local daa;local _ba=dc[baa]
local aba,bba=1,#caa
if aaa<1 then aba=1 -aaa+1;bba=bc-aaa+1 elseif aaa+#caa>bc then bba=bc-aaa+1 end;daa=bb(_ba,1,aaa-1)..bb(caa,aba,bba)
if
aaa+#caa<=bc then daa=daa..bb(_ba,aaa+#caa,bc)end;dc[baa]=daa end end end
local function c_a(aaa,baa,caa)
if baa>=1 and baa<=cc then
if aaa+#caa>0 and aaa<=bc then local daa;local _ba=_d[baa]
local aba,bba=1,#caa
if aaa<1 then aba=1 -aaa+1;bba=bc-aaa+1 elseif aaa+#caa>bc then bba=bc-aaa+1 end;daa=bb(_ba,1,aaa-1)..bb(caa,aba,bba)
if
aaa+#caa<=bc then daa=daa..bb(_ba,aaa+#caa,bc)end;_d[baa]=daa end end end
local function d_a(aaa,baa,caa)
if baa>=1 and baa<=cc then
if aaa+#caa>0 and aaa<=bc then local daa;local _ba=ad[baa]
local aba,bba=1,#caa
if aaa<1 then aba=1 -aaa+1;bba=bc-aaa+1 elseif aaa+#caa>bc then bba=bc-aaa+1 end;daa=bb(_ba,1,aaa-1)..bb(caa,aba,bba)
if
aaa+#caa<=bc then daa=daa..bb(_ba,aaa+#caa,bc)end;ad[baa]=daa end end end
local _aa={setSize=function(aaa,baa)bc,cc=aaa,baa;__a()end,setMirror=function(aaa)ac=aaa end,setBg=function(aaa,baa,caa)
c_a(aaa,baa,caa)end,setText=function(aaa,baa,caa)b_a(aaa,baa,caa)end,setFg=function(aaa,baa,caa)
d_a(aaa,baa,caa)end,blit=function(aaa,baa,caa,daa,_ba)a_a(aaa,baa,caa,daa,_ba)end,drawBackgroundBox=function(aaa,baa,caa,daa,_ba)
local aba=cb(ab[_ba],caa)for n=1,daa do c_a(aaa,baa+ (n-1),aba)end end,drawForegroundBox=function(aaa,baa,caa,daa,_ba)
local aba=cb(ab[_ba],caa)for n=1,daa do d_a(aaa,baa+ (n-1),aba)end end,drawTextBox=function(aaa,baa,caa,daa,_ba)
local aba=cb(_ba,caa)for n=1,daa do b_a(aaa,baa+ (n-1),aba)end end,update=function()
local aaa,baa=_c.getCursorPos()local caa=false
if(_c.getCursorBlink~=nil)then caa=_c.getCursorBlink()end;_c.setCursorBlink(false)if(ac~=nil)then
ac.setCursorBlink(false)end
for n=1,cc do _c.setCursorPos(1,n)
_c.blit(dc[n],ad[n],_d[n])if(ac~=nil)then ac.setCursorPos(1,n)
ac.blit(dc[n],ad[n],_d[n])end end;_c.setBackgroundColor(colors.black)
_c.setCursorBlink(caa)_c.setCursorPos(aaa,baa)
if(ac~=nil)then
ac.setBackgroundColor(colors.black)ac.setCursorBlink(caa)ac.setCursorPos(aaa,baa)end end,setTerm=function(aaa)
_c=aaa end}return _aa end end
aa["libraries"]["basaltLogs"]=function(...)local ab=""local bb="basaltLog.txt"local cb="Debug"
fs.delete(
ab~=""and ab.."/"..bb or bb)
local db={__call=function(_c,ac,bc)if(ac==nil)then return end
local cc=ab~=""and ab.."/"..bb or bb
local dc=fs.open(cc,fs.exists(cc)and"a"or"w")
dc.writeLine("[Basalt]["..
os.date("%Y-%m-%d %H:%M:%S").."][".. (bc and bc or cb)..
"]: "..tostring(ac))dc.close()end}return setmetatable({},db)end
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
aa["libraries"]["basaltEvent"]=function(...)local ab=da("utils").tableCount
return
function()
local bb={}
local cb={registerEvent=function(db,_c,ac)if(bb[_c]==nil)then bb[_c]={}end
table.insert(bb[_c],ac)end,removeEvent=function(db,_c,ac)bb[_c][ac[_c]]=nil end,hasEvent=function(db,_c)return
bb[_c]~=nil end,getEventCount=function(db,_c)return _c~=nil and bb[_c]~=nil and
ab(bb[_c])or ab(bb)end,getEvents=function(db)
local _c={}for ac,bc in pairs(bb)do table.insert(_c,ac)end;return _c end,clearEvent=function(db,_c)bb[_c]=
nil end,clear=function(db,_c)bb={}end,sendEvent=function(db,_c,...)local ac
if(bb[_c]~=nil)then for bc,cc in pairs(bb[_c])do
local dc=cc(...)if(dc==false)then ac=dc end end end;return ac end}cb.__index=cb;return cb end end
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
aa["libraries"]["tHex"]=function(...)local ab={}
for i=0,15 do ab[2 ^i]=("%x"):format(i)end;return ab end
aa["libraries"]["images"]=function(...)local ab,bb=string.sub,math.floor;local function cb(ad)return
{[1]={{},{},paintutils.loadImage(ad)}},"bimg"end;local function db(ad)return
paintutils.loadImage(ad),"nfp"end
local function _c(ad,bd)
local cd=fs.open(ad,bd and"rb"or"r")if(cd==nil)then
error("Path - "..ad.." doesn't exist!")end
local dd=textutils.unserialize(cd.readAll())cd.close()if(dd~=nil)then return dd,"bimg"end end;local function ac(ad)end;local function bc(ad)end
local function cc(ad,bd)
if(ab(ad,-5)==".bimg")then return _c(ad,bd)elseif
(ab(ad,-4)==".bbf")then return ac(ad)elseif(ab(ad,-4)==".nfp")then return db(ad)else
error("Unknown file type")end end
local function dc(ad,bd)
if(ab(ad,-5)==".bimg")then return _c(ad,bd)elseif(ab(ad,-4)==".bbf")then return bc(ad)elseif(
ab(ad,-4)==".nfp")then return cb(ad)else error("Unknown file type")end end
local function _d(ad,bd,cd)
local dd,__a=ad.width or#ad[1][1][1],ad.height or#ad[1]local a_a={}
for b_a,c_a in pairs(ad)do
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
caa.color then d_a=caa.color elseif caa.bgColor then _aa=caa.bgColor else local daa=cc(caa.text,"\n")
for _ba,aba in
ipairs(daa)do local bba=cc(aba," ")
for cba,dba in ipairs(bba)do local _ca=#dba
if cba>1 then if b_a+1 +_ca<=dd then
aaa({text=" "})b_a=b_a+1 else b_a=1;c_a=c_a+1 end end;while _ca>0 do local aca=dba:sub(1,dd-b_a+1)
dba=dba:sub(dd-b_a+2)_ca=#dba;aaa({text=aca})
if _ca>0 then b_a=1;c_a=c_a+1 else b_a=b_a+#aca end end end;if _ba~=#daa then b_a=1;c_a=c_a+1 end end end;if b_a>dd then b_a=1;c_a=c_a+1 end end;return a_a end
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
if(_aa==#d_a)and(aaa=="")then break end;if(aaa.text~=nil)then
cd:addText(dd+aaa.x-1,__a+aaa.y-1,aaa.text)end;if(aaa.color~=nil)then
cd:addFG(dd+aaa.x-1,
__a+aaa.y-1,ab[colors[aaa.color]]:rep(#aaa.text))end;if(aaa.bgColor~=nil)then
cd:addBG(dd+
aaa.x-1,__a+aaa.y-1,ab[colors[aaa.bgColor]]:rep(#
aaa.text))end end end,uuid=function()
return
string.gsub(string.format('%x-%x-%x-%x-%x',math.random(0,0xffff),math.random(0,0xffff),math.random(0,0xffff),
math.random(0,0x0fff)+0x4000,math.random(0,0x3fff)+0x8000),' ','0')end}end
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
aa["main"]=function(...)local ab=da("basaltEvent")()
local bb=da("loadObjects")local cb;local db=da("plugin")local _c=da("utils")local ac=da("basaltLogs")
local bc=_c.uuid;local cc=_c.wrapText;local dc=_c.tableCount;local _d=300;local ad=0;local bd=50;local cd={}local dd={0,0}
local __a=term.current()local a_a="1.7.1"
local b_a=fs.getDir(table.pack(...)[2]or"")local c_a,d_a,_aa,aaa,baa={},{},{},{},{}local caa,daa,_ba,aba;local bba=nil;local cba={}if not term.isColor or not
term.isColor()then
error('Basalt requires an advanced (golden) computer to run.',0)end;local dba={}
for b_c,c_c in
pairs(colors)do if(type(c_c)=="number")then
dba[b_c]={__a.getPaletteColor(c_c)}end end
local function _ca()aba=false;__a.clear()__a.setCursorPos(1,1)
for b_c,c_c in pairs(colors)do if(
type(c_c)=="number")then
__a.setPaletteColor(c_c,colors.packRGB(table.unpack(dba[b_c])))end end end
local function aca(b_c)
assert(b_c~="function","Schedule needs a function in order to work!")
return function(...)local c_c=coroutine.create(b_c)
local d_c,_ac=coroutine.resume(c_c,...)
if(d_c)then table.insert(baa,c_c)else cba.basaltError(_ac)end end end;cba.log=function(...)ac(...)end
local bca=function(b_c,c_c)aaa[b_c]=c_c end;local cca=function(b_c)return aaa[b_c]end
local dca=function()return cb end;local _da=function(b_c)return dca()[b_c]end;local ada=function(b_c,c_c,d_c)return
_da(c_c)(d_c,b_c)end
local bda=function(b_c)if(b_c<=0)then bd=0 else bba=
nil;bd=b_c end end;local cda=function()return bd end;local dda=0
local __b=function()dda=os.clock("utc")
cba.log(
"Timer started at "..dda.." seconds")end
local a_b=function()local b_c=os.clock("utc")-dda;cba.log("Timer ended at "..
os.clock().." seconds")
cba.log(
"Timer ended after "..b_c.." seconds")end
local b_b={getDynamicValueEventSetting=function()return cba.dynamicValueEvents end,getRenderingThrottle=cda,setRenderingThrottle=bda,getMainFrame=function()return caa end,setVariable=bca,getVariable=cca,setMainFrame=function(b_c)
caa=b_c end,getActiveFrame=function()return daa end,setActiveFrame=function(b_c)daa=b_c end,getFocusedObject=function()return _ba end,setFocusedObject=function(b_c)_ba=b_c end,getMonitorFrame=function(b_c)return
_aa[b_c]or monGroups[b_c][1]end,setMonitorFrame=function(b_c,c_c,d_c)if(
caa==c_c)then caa=nil end;if(d_c)then monGroups[b_c]={c_c,sides}else
_aa[b_c]=c_c end
if(c_c==nil)then monGroups[b_c]=nil end end,getTerm=function()return
__a end,schedule=aca,stop=_ca,debug=cba.debug,log=cba.log,getObjects=dca,getObject=_da,createObject=ada,getDirectory=function()return b_a end}
local function c_b(b_c)__a.clear()__a.setBackgroundColor(colors.black)
__a.setTextColor(colors.red)local c_c,d_c=__a.getSize()if(cba.logging)then ac(b_c,"Error")end;local _ac=cc(
"Basalt error: "..b_c,c_c)local aac=1;for bac,cac in pairs(_ac)do
__a.setCursorPos(1,aac)__a.write(cac)aac=aac+1 end;__a.setCursorPos(1,
aac+1)aba=false end
local function d_b(b_c,c_c,d_c,_ac,aac)
if(#baa>0)then local bac={}
for n=1,#baa do
if(baa[n]~=nil)then
if
(coroutine.status(baa[n])=="suspended")then
local cac,dac=coroutine.resume(baa[n],b_c,c_c,d_c,_ac,aac)if not(cac)then cba.basaltError(dac)end else
table.insert(bac,n)end end end
for n=1,#bac do table.remove(baa,bac[n]- (n-1))end end end
local function _ab()if(aba==false)then return end;if(caa~=nil)then caa:render()
caa:updateTerm()end;for b_c,c_c in pairs(_aa)do c_c:render()
c_c:updateTerm()end end;local aab,bab,cab=nil,nil,nil;local dab=nil
local function _bb(b_c,c_c,d_c,_ac)aab,bab,cab=c_c,d_c,_ac;if(dab==nil)then
dab=os.startTimer(_d/1000)end end
local function abb()dab=nil;caa:hoverHandler(bab,cab,aab)daa=caa end;local bbb,cbb,dbb=nil,nil,nil;local _cb=nil;local function acb()_cb=nil;caa:dragHandler(bbb,cbb,dbb)
daa=caa end;local function bcb(b_c,c_c,d_c,_ac)bbb,cbb,dbb=c_c,d_c,_ac
if(ad<50)then acb()else if(_cb==nil)then _cb=os.startTimer(
ad/1000)end end end;local function ccb()
bba=nil;_ab()end
local function dcb(b_c)if(bd<50)then _ab()else if(bba==nil)then
bba=os.startTimer(bd/1000)end end end
local function _db(b_c,...)local c_c={...}if
(ab:sendEvent("basaltEventCycle",b_c,...)==false)then return end
if(b_c=="terminate")then cba.stop()end
if(caa~=nil)then
local d_c={mouse_click=caa.mouseHandler,mouse_up=caa.mouseUpHandler,mouse_scroll=caa.scrollHandler,mouse_drag=bcb,mouse_move=_bb}local _ac=d_c[b_c]
if(_ac~=nil)then local aac,bac=c_c[3],c_c[4]if(aac~=nil and bac~=nil)then
dd={aac,bac}end;_ac(caa,...)d_b(b_c,...)dcb()return end end
if(b_c=="monitor_touch")then
for d_c,_ac in pairs(_aa)do if
(_ac:mouseHandler(1,c_c[2],c_c[3],true,c_c[1]))then daa=_ac end end;d_b(b_c,...)dcb()return end
if(daa~=nil)then
local d_c={char=daa.charHandler,key=daa.keyHandler,key_up=daa.keyUpHandler}local _ac=d_c[b_c]if(_ac~=nil)then if(b_c=="key")then c_a[c_c[1]]=true elseif(b_c=="key_up")then
c_a[c_c[1]]=false end;_ac(daa,...)d_b(b_c,...)
dcb()return end end
if(b_c=="timer")and(c_c[1]==dab)then abb()elseif
(b_c=="timer")and(c_c[1]==_cb)then acb()elseif(b_c=="timer")and(c_c[1]==bba)then ccb()else for d_c,_ac in pairs(d_a)do
_ac:eventHandler(b_c,...)end
for d_c,_ac in pairs(_aa)do _ac:eventHandler(b_c,...)end;d_b(b_c,...)dcb()end end;local adb=false;local bdb=false
local function cdb()
if not(adb)then
for b_c,c_c in pairs(cd)do
if(fs.exists(c_c))then
if(fs.isDir(c_c))then
local d_c=fs.list(c_c)
for _ac,aac in pairs(d_c)do
if not(fs.isDir(c_c.."/"..aac))then
local bac=aac:gsub(".lua","")
if
(bac~="example.lua")and not(bac:find(".disabled"))then
if(bb[bac]==nil)then
bb[bac]=da(c_c.."."..aac:gsub(".lua",""))else error("Duplicate object name: "..bac)end end end end else local d_c=c_c:gsub(".lua","")
if(bb[d_c]==nil)then bb[d_c]=da(d_c)else error(
"Duplicate object name: "..d_c)end end end end;adb=true end
if not(bdb)then cb=db.loadPlugins(bb,b_b)local b_c=db.get("basalt")
if
(b_c~=nil)then for d_c,_ac in pairs(b_c)do
for aac,bac in pairs(_ac(cba))do cba[aac]=bac;b_b[aac]=bac end end end;local c_c=db.get("basaltInternal")
if(c_c~=nil)then for d_c,_ac in pairs(c_c)do for aac,bac in pairs(_ac(cba))do
b_b[aac]=bac end end end;bdb=true end end;cdb()
local function ddb(b_c)
for d_c,_ac in pairs(d_a)do if(_ac:getName()==b_c)then return nil end end;local c_c=cb["BaseFrame"](b_c,b_b)c_c:init()
c_c:load()c_c:draw()table.insert(d_a,c_c)
if(caa==nil)and(c_c:getName()~=
"basaltDebuggingFrame")then c_c:show()end;return c_c end
cba={basaltError=c_b,logging=false,dynamicValueEvents=false,drawFrames=_ab,log=ac,getVersion=function()return a_a end,memory=function()return
math.floor(collectgarbage("count")+0.5).."KB"end,addObject=function(b_c)if
(fs.exists(b_c))then table.insert(cd,b_c)end end,addPlugin=function(b_c)
db.addPlugin(b_c)end,getAvailablePlugins=function()return db.getAvailablePlugins()end,getAvailableObjects=function()
local b_c={}for c_c,d_c in pairs(bb)do table.insert(b_c,c_c)end;return b_c end,getMousePosition=function()return
dd[1],dd[2]end,setVariable=bca,getVariable=cca,getObjects=dca,getObject=_da,createObject=ada,setBaseTerm=function(b_c)__a=b_c end,resetPalette=function()for b_c,c_c in pairs(colors)do if(type(c_c)==
"number")then end end end,setMouseMoveThrottle=function(b_c)
if
(_HOST:find("CraftOS%-PC"))then if(config.get("mouse_move_throttle")~=10)then
config.set("mouse_move_throttle",10)end
if(b_c<100)then _d=100 else _d=b_c end;return true end;return false end,setRenderingThrottle=bda,getRenderingThrottle=cda,setMouseDragThrottle=function(b_c)if(
b_c<=0)then ad=0 else _cb=nil;ad=b_c end end,autoUpdate=function(b_c)
aba=b_c;if(b_c==nil)then aba=true end;local function c_c()_ab()while aba do
_db(os.pullEventRaw())end end
while aba do
local d_c,_ac=xpcall(c_c,debug.traceback)if not(d_c)then cba.basaltError(_ac)end end end,update=function(b_c,...)
if(
b_c~=nil)then local c_c={...}
local d_c,_ac=xpcall(function()_db(b_c,table.unpack(c_c))end,debug.traceback)if not(d_c)then cba.basaltError(_ac)return end end end,stop=_ca,stopUpdate=_ca,isKeyDown=function(b_c)if(
c_a[b_c]==nil)then return false end;return c_a[b_c]end,getFrame=function(b_c)for c_c,d_c in
pairs(d_a)do if(d_c.name==b_c)then return d_c end end end,getActiveFrame=function()return
daa end,setActiveFrame=function(b_c)
if(b_c:getType()=="Container")then daa=b_c;return true end;return false end,getMainFrame=function()return caa end,onEvent=function(...)
for b_c,c_c in
pairs(table.pack(...))do if(type(c_c)=="function")then
ab:registerEvent("basaltEventCycle",c_c)end end end,schedule=aca,addFrame=ddb,createFrame=ddb,addMonitor=function(b_c)
for d_c,_ac in
pairs(d_a)do if(_ac:getName()==b_c)then return nil end end;local c_c=cb["MonitorFrame"](b_c,b_b)c_c:init()
c_c:load()c_c:draw()table.insert(_aa,c_c)return c_c end,removeFrame=function(b_c)d_a[b_c]=
nil end,setProjectDir=function(b_c)b_a=b_c end}local __c=db.get("basalt")if(__c~=nil)then
for b_c,c_c in pairs(__c)do for d_c,_ac in pairs(c_c(cba))do
cba[d_c]=_ac;b_b[d_c]=_ac end end end
local a_c=db.get("basaltInternal")if(a_c~=nil)then
for b_c,c_c in pairs(a_c)do for d_c,_ac in pairs(c_c(cba))do b_b[d_c]=_ac end end end;return cba end;aa["objects"]={}
aa["objects"]["MonitorFrame"]=function(...)
local ab=da("basaltMon")local bb,cb,db,_c=math.max,math.min,string.sub,string.rep
return
function(ac,bc)
local cc=bc.getObject("BaseFrame")(ac,bc)cc:setType("MonitorFrame")local dc=false
cc:addProperty("Monitor","string|table",nil,false,function(ad,bd)
if(
type(bd)=="string")then local cd=peripheral.wrap(bd)if(cd~=nil)then
ad:setTerm(cd)end elseif(type(bd)=="table")then ad:setTerm(bd)end end)
cc:addProperty("MonitorGroup","string|table",nil,false,function(ad,bd)ad:setTerm(ab(bd))dc=true end)cc:setTerm(nil)
local _d={getBase=function(ad)return cc end}
_d.mouseHandler=function(ad,bd,cd,dd,__a,a_a,...)if(dc)then local b_a=ad:getTerm()
cd,dd=b_a.calculateClick(a_a,cd,dd)end
cc.mouseHandler(ad,bd,cd,dd,__a,a_a,...)end;_d.__index=_d;return setmetatable(_d,cc)end end
aa["objects"]["Radio"]=function(...)local ab=da("utils")local bb=da("tHex")
return
function(cb,db)
local _c=db.getObject("List")(cb,db)_c:setType("Radio")_c:setSize(1,1)_c:setZ(5)
_c:addProperty("BoxSelectionBG","color",colors.black)
_c:addProperty("BoxSelectionFG","color",colors.green)
_c:combineProperty("BoxSelectionColor","BoxSelectionBG","BoxSelectionFG")
_c:addProperty("BoxNotSelectionBG","color",colors.black)
_c:addProperty("BoxNotSelectionFG","color",colors.red)
_c:combineProperty("BoxNotSelectionColor","BoxNotSelectionBG","BoxNotSelectionFG")
_c:addProperty("SelectionColorActive","boolean",true)_c:addProperty("Symbol","char","\7")
_c:addProperty("Align","string",{"left","right"},"left")local ac={}
local bc={addItem=function(cc,dc,_d,ad,bd,cd,...)_c.addItem(cc,dc,bd,cd,...)
table.insert(ac,{x=_d or 1,y=ad or#ac*2})return cc end,removeItem=function(cc,dc)
_c.removeItem(cc,dc)table.remove(ac,dc)return cc end,clear=function(cc)
_c.clear(cc)ac={}return cc end,editItem=function(cc,dc,_d,ad,bd,cd,dd,...)
_c.editItem(cc,dc,_d,cd,dd,...)table.remove(ac,dc)
table.insert(ac,dc,{x=ad or 1,y=bd or 1})return cc end,mouseHandler=function(cc,dc,_d,ad,...)
if(
#ac>0)then local bd,cd=cc:getAbsolutePosition()local dd=cc:getAll()
for __a,a_a in
pairs(dd)do
if

(bd+ac[__a].x-1 <=_d)and(bd+ac[__a].x-1 +
a_a.text:len()+1 >=_d)and(cd+ac[__a].y-1 ==ad)then cc:setValue(a_a)cc:selectHandler()
local b_a=cc:sendEvent("mouse_click",cc,"mouse_click",dc,_d,ad,...)cc:updateDraw()if(b_a==false)then return b_a end;return true end end end end,draw=function(cc)
cc:addDraw("radio",function()
local dc,_d=cc:getSelectionColor()local ad=cc:getAll()local bd,cd=cc:getBoxSelectionColor()
local dd,__a=cc:getBoxNotSelectionColor()local a_a=cc:getSymbol()
for b_a,c_a in pairs(ad)do
if(c_a==cc:getValue())then
cc:addBlit(ac[b_a].x,ac[b_a].y,a_a,bb[cd],bb[bd])
cc:addBlit(ac[b_a].x+2,ac[b_a].y,c_a.text,bb[_d]:rep(#c_a.text),bb[dc]:rep(
#c_a.text))else
cc:addBackgroundBox(ac[b_a].x,ac[b_a].y,1,1,dd or colors.black)
cc:addBlit(ac[b_a].x+2,ac[b_a].y,c_a.text,bb[c_a.fgCol]:rep(#c_a.text),bb[c_a.bgCol]:rep(
#c_a.text))end end;return true end)end}bc.__index=bc;return setmetatable(bc,_c)end end
aa["objects"]["Menubar"]=function(...)local ab=da("utils")local bb=da("tHex")
return
function(cb,db)
local _c=db.getObject("List")(cb,db)_c:setType("Menubar")local ac={}_c:setSize(30,1)
_c:setZ(5)_c:addProperty("ItemOffset","number",0)
_c:addProperty("Space","number",1)
local function bc()local cc=0;local dc=_c:getWidth()local _d=_c:getAll()local ad=_c:getSpace()
for n=1,#
_d do cc=cc+_d[n].text:len()+ad*2 end;return math.max(cc-dc,0)end
ac={init=function(cc)cc:listenEvent("mouse_click")
cc:listenEvent("mouse_drag")cc:listenEvent("mouse_scroll")return _c.init(cc)end,getBase=function(cc)return
_c end,mouseHandler=function(cc,dc,_d,ad)
if(_c:getBase().mouseHandler(cc,dc,_d,ad))then
local bd,cd=cc:getAbsolutePosition()local dd,__a=cc:getSize()local a_a=0;local b_a=cc:getAll()
local c_a=cc:getSpace()local d_a=cc:getItemOffset()
for n=1,#b_a do
if(b_a[n]~=nil)then if
(bd+a_a<=_d+d_a)and(bd+a_a+
b_a[n].text:len()+ (c_a*2)>_d+d_a)and(cd==ad)then cc:setValue(b_a[n])
cc:selectHandler()end;a_a=a_a+
b_a[n].text:len()+c_a*2 end end;cc:updateDraw()return true end end,scrollHandler=function(cc,dc,_d,ad)
if
(_c:getBase().scrollHandler(cc,dc,_d,ad))then local bd=cc:getScrollable()
if(bd)then local cd=cc:getItemOffset()cd=cd+dc;if(
cd<0)then cd=0 end;local dd=bc()if(cd>dd)then cd=dd end
cc:setItemOffset(cd)cc:updateDraw()end;return true end;return false end,draw=function(cc)
_c.draw(cc)
cc:addDraw("list",function()local dc,_d=cc:getSize()local ad=""local bd=""local cd=""
local dd,__a=cc:getSelectionColor()local a_a=cc:getItemOffset()local b_a=cc:getSpace()
for c_a,d_a in
pairs(cc:getAll())do
local _aa=(" "):rep(b_a)..d_a.text.. (" "):rep(b_a)ad=ad.._aa
if(d_a==cc:getValue())then bd=bd..
bb[dd or d_a.bgCol or cc:getBackground()]:rep(_aa:len())cd=cd..
bb[
__a or d_a.FgCol or cc:getForeground()]:rep(_aa:len())else bd=bd..
bb[d_a.bgCol or
cc:getBackground()]:rep(_aa:len())cd=cd..
bb[d_a.FgCol or
cc:getForeground()]:rep(_aa:len())end end
cc:addBlit(1,1,ad:sub(a_a+1,dc+a_a),cd:sub(a_a+1,dc+a_a),bd:sub(a_a+1,dc+a_a))end)end}ac.__index=ac;return setmetatable(ac,_c)end end
aa["objects"]["Slider"]=function(...)local ab=da("tHex")
return
function(bb,cb)
local db=cb.getObject("ChangeableObject")(bb,cb)db:setType("Slider")db:setSize(12,1)db:setValue(1)
db:addProperty("SymbolText","char"," ")
db:addProperty("SymbolForeground","color",colors.black)
db:addProperty("SymbolBackground","color",colors.gray)
db:combineProperty("Symbol","SymbolText","SymbolForeground","SymbolBackground")db:addProperty("SymbolSize","number",1)
db:addProperty("BarType",{"vertical","horizontal"},"horizontal")db:addProperty("MaxValue","number",12)local _c=1
local function ac(cc,dc,_d,ad)
local bd,cd=cc:getPosition()local dd,__a=cc:getSize()local a_a=cc:getBarType()local b_a=
a_a=="vertical"and __a or dd;local c_a=cc:getSymbolSize()
local d_a=cc:getSymbol()local _aa=cc:getMaxValue()
for i=0,b_a do
if

( (a_a=="vertical"and cd+i==ad)or(a_a==
"horizontal"and bd+i==_d))and(bd<=_d)and(bd+dd>_d)and(cd<=ad)and(cd+__a>ad)then _c=math.min(
i+1,b_a- (#d_a+c_a-2))cc:setValue(_aa/b_a*
_c)cc:updateDraw()end end end
local bc={init=function(cc)db.init(cc)db:setBgSymbol("\140")
db:setBgSymbolColor(colors.black)db:setBackground(nil)end,load=function(cc)
cc:listenEvent("mouse_click")cc:listenEvent("mouse_drag")
cc:listenEvent("mouse_scroll")end,setIndex=function(cc,dc)_c=dc;if(_c<1)then _c=1 end
local _d,ad=cc:getSize()local bd=cc:getSymbolSize()local cd=cc:getMaxValue()
local dd=cc:getBarType()
_c=math.min(_c,(dd=="vertical"and ad or _d)- (bd-1))
cc:setValue(cd/ (dd=="vertical"and ad or _d)*_c)cc:updateDraw()return cc end,getIndex=function(cc)return
_c end,mouseHandler=function(cc,dc,_d,ad)
if(db.mouseHandler(cc,dc,_d,ad))then ac(cc,dc,_d,ad)return true end;return false end,dragHandler=function(cc,dc,_d,ad)if
(db.dragHandler(cc,dc,_d,ad))then ac(cc,dc,_d,ad)return true end;return false end,scrollHandler=function(cc,dc,_d,ad)
if
(db.scrollHandler(cc,dc,_d,ad))then local bd,cd=cc:getSize()_c=_c+dc;if(_c<1)then _c=1 end
local dd=cc:getSymbolSize()local __a=cc:getMaxValue()local a_a=cc:getBarType()
_c=math.min(_c,(
a_a=="vertical"and cd or bd)- (dd-1))
cc:setValue(__a/ (a_a=="vertical"and cd or bd)*_c)cc:updateDraw()return true end;return false end,draw=function(cc)
db.draw(cc)
cc:addDraw("slider",function()local dc,_d=cc:getSize()
local ad,bd=cc:getBackground(),cc:getForeground()local cd=cc:getSymbolSize()local dd=cc:getSymbolText()
local __a=cc:getSymbolForeground()local a_a=cc:getSymbolBackground()local b_a=cc:getBarType()
local c_a,d_a=cc:getPosition()
if(b_a=="horizontal")then cc:addText(_c,d_a,dd:rep(cd))
if(a_a~=false)then cc:addBg(_c,1,ab[a_a]:rep(
#dd*cd))end;if(__a~=false)then
cc:addFg(_c,1,ab[__a]:rep(#dd*cd))end end
if(b_a=="vertical")then
for n=0,_d-1 do
if(_c==n+1)then for curIndexOffset=0,math.min(cd-1,_d)do
cc:addBlit(1,1 +n+curIndexOffset,dd,ab[__a],ab[__a])end else
if
(n+1 <_c)or(n+1 >_c-1 +cd)then cc:addBlit(1,1 +n," ",ab[bd],ab[ad])end end end end end)end}bc.__index=bc;return setmetatable(bc,db)end end
aa["objects"]["Flexbox"]=function(...)
local function ab(bb,cb)local db,_c=bb:getSize()
if
(bb:getType()~="lineBreakFakeObject")then bb:addProperty("FlexGrow","number",0)
bb:addProperty("FlexShrink","number",0)bb:addProperty("FlexBasis","number",0)end
local ac={getBaseSize=function(bc)return db,_c end,getBaseWidth=function(bc)return db end,getBaseHeight=function(bc)return _c end,setSize=function(bc,cc,dc,_d,ad)
bb.setSize(bc,cc,dc,_d)if not ad then db,_c=bb:getSize()end;return bc end}ac.__index=ac;return setmetatable(ac,bb)end
return
function(bb,cb)
local db=cb.getObject("ScrollableFrame")(bb,cb)db:setType("Flexbox")local _c=false
db:addProperty("FlexDirection",{"row","column"},"row",nil,function(dd,__a)if(
__a=="row")then db:setDirection("horizontal")elseif(__a=="column")then
db:setDirection("vertical")end end)
db:addProperty("Spacing","number",1,nil,function(dd,__a)_c=true end)
db:addProperty("JustifyContent",{"flex-start","flex-end","center","space-between","space-around","space-evenly"},"flex-start",
nil,function(dd,__a)_c=true end)
db:addProperty("Wrap",{"nowrap","wrap"},"nowrap",nil,function(dd,__a)_c=true end)local ac={}local bc={}
local cc=ab({getBaseHeight=function(dd)return 0 end,getBaseWidth=function(dd)return 0 end,getPosition=function(dd)return 0,0 end,getSize=function(dd)return 0,0 end,isType=function(dd)return
false end,getType=function(dd)return"lineBreakFakeObject"end,setPosition=function(dd)end,setSize=function(dd)end,getFlexGrow=function(dd)return
0 end,getFlexShrink=function(dd)return 0 end,getFlexBasis=function(dd)return 0 end})
local function dc(dd)local __a=dd:getDirection()local a_a=dd:getSpacing()
local b_a=dd:getWrap()
if(b_a=="nowrap")then bc={}local c_a=1;local d_a=1;local _aa=1
for aaa,baa in pairs(ac)do if(bc[c_a]==nil)then
bc[c_a]={offset=1}end
local caa=__a=="row"and baa:getHeight()or baa:getWidth()if caa>d_a then d_a=caa end
if(baa==cc)then _aa=_aa+d_a+a_a;d_a=1;c_a=c_a+1
bc[c_a]={offset=_aa}else table.insert(bc[c_a],baa)end end elseif(b_a=="wrap")then bc={}local c_a=1;local d_a=1;local _aa=__a=="row"and dd:getWidth()or
dd:getHeight()local aaa=0;local baa=1
for caa,daa in pairs(ac)do if(bc[baa]==
nil)then bc[baa]={offset=1}end
if daa==cc then
d_a=d_a+c_a+a_a;aaa=0;c_a=1;baa=baa+1;bc[baa]={offset=d_a}else
local _ba=
__a=="row"and daa:getBaseWidth()or daa:getBaseHeight()
if(_ba+aaa<=_aa)then table.insert(bc[baa],daa)
aaa=aaa+_ba+a_a else d_a=d_a+c_a+a_a;c_a=__a=="row"and daa:getBaseHeight()or
daa:getBaseWidth()baa=baa+1
aaa=_ba+a_a;bc[baa]={offset=d_a,daa}end
local aba=__a=="row"and daa:getBaseHeight()or daa:getBaseWidth()if aba>c_a then c_a=aba end end end end end
local function _d(dd,__a)local a_a,b_a=dd:getSize()local c_a=dd:getSpacing()
local d_a=dd:getJustifyContent()local _aa=0;local aaa=0;local baa=0
for _ba,aba in ipairs(__a)do _aa=_aa+aba:getFlexGrow()aaa=aaa+
aba:getFlexShrink()baa=baa+aba:getFlexBasis()end;local caa=a_a-baa- (c_a* (#__a-1))local daa=1
for _ba,aba in ipairs(__a)do
if
(aba~=cc)then local bba;local cba=aba:getFlexGrow()local dba=aba:getFlexShrink()
local _ca=
aba:getFlexBasis()~=0 and aba:getFlexBasis()or aba:getBaseWidth()if _aa>0 then bba=_ca+cba/_aa*caa else bba=_ca end;if caa<0 and
aaa>0 then bba=_ca+dba/aaa*caa end;aba:setPosition(daa,
__a.offset or 1)
aba:setSize(bba,aba:getHeight(),false,true)daa=daa+bba+c_a end end
if d_a=="flex-end"then local _ba=daa-c_a;local aba=a_a-_ba+1
for bba,cba in ipairs(__a)do
local dba,_ca=cba:getPosition()cba:setPosition(dba+aba,_ca)end elseif d_a=="center"then local _ba=daa-c_a;local aba=(a_a-_ba)/2 +1
for bba,cba in ipairs(__a)do
local dba,_ca=cba:getPosition()cba:setPosition(dba+aba,_ca)end elseif d_a=="space-between"then local _ba=daa-c_a
local aba=(a_a-_ba)/ (#__a-1)+1
for bba,cba in ipairs(__a)do if bba>1 then local dba,_ca=cba:getPosition()
cba:setPosition(dba+aba* (bba-1),_ca)end end elseif d_a=="space-around"then local _ba=daa-c_a;local aba=(a_a-_ba)/#__a
for bba,cba in ipairs(__a)do
local dba,_ca=cba:getPosition()cba:setPosition(dba+aba*bba-aba/2,_ca)end elseif d_a=="space-evenly"then local _ba=#__a+1;local aba=0;for _ca,aca in ipairs(__a)do
aba=aba+aca:getWidth()end;local bba=a_a-aba
local cba=math.floor(bba/_ba)local dba=bba-cba*_ba;daa=cba+ (dba>0 and 1 or 0)dba=dba>
0 and dba-1 or 0
for _ca,aca in ipairs(__a)do
aca:setPosition(daa,1)
daa=daa+aca:getWidth()+cba+ (dba>0 and 1 or 0)dba=dba>0 and dba-1 or 0 end end end
local function ad(dd,__a)local a_a,b_a=dd:getSize()local c_a=dd:getSpacing()
local d_a=dd:getJustifyContent()local _aa=0;local aaa=0;local baa=0
for _ba,aba in ipairs(__a)do _aa=_aa+aba:getFlexGrow()aaa=aaa+
aba:getFlexShrink()baa=baa+aba:getFlexBasis()end;local caa=b_a-baa- (c_a* (#__a-1))local daa=1
for _ba,aba in ipairs(__a)do
if
(aba~=cc)then local bba;local cba=aba:getFlexGrow()local dba=aba:getFlexShrink()
local _ca=
aba:getFlexBasis()~=0 and aba:getFlexBasis()or aba:getBaseHeight()if _aa>0 then bba=_ca+cba/_aa*caa else bba=_ca end;if caa<0 and
aaa>0 then bba=_ca+dba/aaa*caa end
aba:setPosition(__a.offset,daa)aba:setSize(aba:getWidth(),bba,false,true)daa=
daa+bba+c_a end end
if d_a=="flex-end"then local _ba=daa-c_a;local aba=b_a-_ba+1
for bba,cba in ipairs(__a)do
local dba,_ca=cba:getPosition()cba:setPosition(dba,_ca+aba)end elseif d_a=="center"then local _ba=daa-c_a;local aba=(b_a-_ba)/2
for bba,cba in ipairs(__a)do
local dba,_ca=cba:getPosition()cba:setPosition(dba,_ca+aba)end elseif d_a=="space-between"then local _ba=daa-c_a
local aba=(b_a-_ba)/ (#__a-1)+1
for bba,cba in ipairs(__a)do if bba>1 then local dba,_ca=cba:getPosition()
cba:setPosition(dba,_ca+aba* (bba-1))end end elseif d_a=="space-around"then local _ba=daa-c_a;local aba=(b_a-_ba)/#__a
for bba,cba in ipairs(__a)do
local dba,_ca=cba:getPosition()cba:setPosition(dba,_ca+aba*bba-aba/2)end elseif d_a=="space-evenly"then local _ba=#__a+1;local aba=0;for _ca,aca in ipairs(__a)do
aba=aba+aca:getHeight()end;local bba=b_a-aba
local cba=math.floor(bba/_ba)local dba=bba-cba*_ba;daa=cba+ (dba>0 and 1 or 0)dba=dba>
0 and dba-1 or 0
for _ca,aca in ipairs(__a)do
local bca,cca=aca:getPosition()aca:setPosition(bca,daa)daa=
daa+aca:getHeight()+cba+ (dba>0 and 1 or 0)dba=dba>0 and
dba-1 or 0 end end end
local function bd(dd)dc(dd)
if dd:getFlexDirection()=="row"then
for __a,a_a in pairs(bc)do _d(dd,a_a)end else for __a,a_a in pairs(bc)do ad(dd,a_a)end end;_c=false end
local cd={updateLayout=function(dd)_c=true;dd:updateDraw()end,addBreak=function(dd)
table.insert(ac,cc)_c=true;dd:updateDraw()return dd end,customEventHandler=function(dd,__a,...)
db.customEventHandler(dd,__a,...)if __a=="basalt_FrameResize"then _c=true end end,draw=function(dd)
db.draw(dd)
dd:addDraw("flexboxDraw",function()if _c then bd(dd)end end,1)end}
for dd,__a in pairs(cb.getObjects())do
cd["add"..dd]=function(a_a,b_a)
local c_a=db["add"..dd](a_a,b_a)local d_a=ab(c_a,cb)table.insert(ac,d_a)_c=true;return d_a end end;cd.__index=cd;return setmetatable(cd,db)end end
aa["objects"]["Dropdown"]=function(...)local ab=da("utils")local bb=da("tHex")
return
function(cb,db)
local _c=db.getObject("List")(cb,db)_c:setType("Dropdown")_c:setSize(12,1)_c:setZ(6)
_c:addProperty("Align",{"left","center","right"},"left")_c:addProperty("AutoSize","boolean",true)
_c:addProperty("ClosedSymbol","char","\16")_c:addProperty("OpenedSymbol","char","\31")
_c:addProperty("Opened","boolean",false)_c:addProperty("DropdownWidth","number",12)
_c:addProperty("DropdownHeight","number",0)
_c:combineProperty("DropdownSize","DropdownWidth","DropdownHeight")
local ac={load=function(bc)bc:listenEvent("mouse_click",bc)
bc:listenEvent("mouse_up",bc)bc:listenEvent("mouse_scroll",bc)
bc:listenEvent("mouse_drag",bc)end,addItem=function(bc,cc,...)
_c.addItem(bc,cc,...)
if(bc:getAutoSize())then local dc,_d=bc:getDropdownSize()bc:setDropdownSize(math.max(dc,#cc),
_d+1)end;return bc end,removeItem=function(bc,cc)
_c.removeItem(bc,cc)local dc=bc:getAll()
if(bc:getAutoSize())then local _d,ad=bc:getDropdownSize()
_d=0;ad=0
for n=1,#dc do _d=math.max(_d,#dc[n].text)end;ad=#dc;bc:setDropdownSize(_d,ad)end;return bc end,isOpened=function(bc)return
bc:getOpened()end,mouseHandler=function(bc,cc,dc,_d,ad)local bd=bc:getOpened()
if(bd)then
local dd,__a=bc:getAbsolutePosition()
if(cc==1)then local a_a=bc:getAll()
if(#a_a>0)then local b_a,c_a=bc:getDropdownSize()
local d_a=bc:getOffset()
for n=1,c_a do
if(a_a[n+d_a]~=nil)then
if
(dd<=dc)and(dd+b_a>dc)and(__a+n==_d)then bc:setValue(a_a[n+d_a])bc:selectHandler()
bc:updateDraw()
local _aa=bc:sendEvent("mouse_click",bc,"mouse_click",cc,dc,_d)if(_aa==false)then return _aa end;if(ad)then
db.schedule(function()sleep(0.1)
bc:mouseUpHandler(cc,dc,_d)end)()end;return true end end end end end end;local cd=_c:getBase()
if(cd.mouseHandler(bc,cc,dc,_d))then
bc:setOpened(not bd)bc:getParent():setImportant(bc)
bc:updateDraw()return true else
if(bd)then bc:updateDraw()bc:setOpened(false)end;return false end end,mouseUpHandler=function(bc,cc,dc,_d)
local ad=bc:getOpened()
if(ad)then local bd,cd=bc:getAbsolutePosition()
if(cc==1)then local dd=bc:getAll()
if
(#dd>0)then local __a,a_a=bc:getDropdownSize()local b_a=bc:getOffset()
for n=1,a_a do
if(dd[n+b_a]~=
nil)then
if(bd<=dc)and(bd+__a>dc)and(cd+n==_d)then
bc:setOpened(false)bc:updateDraw()
local c_a=bc:sendEvent("mouse_up",bc,"mouse_up",cc,dc,_d)if(c_a==false)then return c_a end;return true end end end end end end end,dragHandler=function(bc,cc,dc,_d)if
(_c.dragHandler(bc,cc,dc,_d))then bc:setOpened(true)end end,scrollHandler=function(bc,cc,dc,_d)
local ad=bc:getOpened()local bd,cd=bc:getDropdownSize()
if(ad)then
local dd,__a=bc:getAbsolutePosition()if
(dc>=dd)and(dc<=dd+bd)and(_d>=__a)and(_d<=__a+cd)then bc:setFocus()end end
if(ad)and(bc:isFocused())then local dd,__a=bc:getAbsolutePosition()if

(dc<dd)or(dc>dd+bd)or(_d<__a)or(_d>__a+cd)then return false end;if(#bc:getAll()<=cd)then
return false end;local a_a=bc:getAll()
local b_a=bc:getOffset()+cc;if(b_a<0)then b_a=0 end;if(cc==1)then
if(#a_a>cd)then
if(b_a>#a_a-cd)then b_a=#a_a-cd end else b_a=math.min(#a_a-1,0)end end
bc:setOffset(b_a)
local c_a=bc:sendEvent("mouse_scroll",bc,"mouse_scroll",cc,dc,_d)if(c_a==false)then return c_a end;bc:updateDraw()return true end end,draw=function(bc)
_c.draw(bc)bc:setDrawState("list",false)
bc:addDraw("dropdown",function()
local cc,dc=bc:getSize()local _d=bc:getValue()local ad=bc:getAll()
local bd,cd=bc:getBackground(),bc:getForeground()local dd,__a=bc:getOpenedSymbol(),bc:getClosedSymbol()
local a_a=bc:getAlign()local b_a,c_a=bc:getDropdownSize()local d_a=bc:getOffset()
local _aa=bc:getSelectionColorActive()local aaa=bc:getOpened()
local baa=ab.getTextHorizontalAlign((_d~=nil and _d.text or""),cc,a_a):sub(1,
cc-1).. (aaa and dd or __a)
bc:addBlit(1,1,baa,bb[cd]:rep(#baa),bb[bd]:rep(#baa))
if(aaa)then bc:addTextBox(1,2,b_a,c_a," ")
bc:addBackgroundBox(1,2,b_a,c_a,bd)bc:addForegroundBox(1,2,b_a,c_a,cd)
for n=1,c_a do
if(ad[n+d_a]~=nil)then local caa=ab.getTextHorizontalAlign(ad[
n+d_a].text,b_a,a_a)
if(ad[
n+d_a]==_d)then
if(_aa)then local daa,_ba=bc:getSelectionColor()
bc:addBlit(1,n+1,caa,bb[_ba]:rep(
#caa),bb[daa]:rep(#caa))else
bc:addBlit(1,n+1,caa,bb[ad[n+d_a].fgCol]:rep(#caa),bb[ad[n+d_a].bgCol]:rep(
#caa))end else
bc:addBlit(1,n+1,caa,bb[ad[n+d_a].fgCol]:rep(#caa),bb[ad[n+d_a].bgCol]:rep(
#caa))end end end end end)end}ac.__index=ac;return setmetatable(ac,_c)end end
aa["objects"]["ScrollableFrame"]=function(...)
local ab,bb,cb,db=math.max,math.min,string.sub,string.rep;local _c=da("tHex")
return
function(ac,bc)local cc=bc.getObject("Frame")(ac,bc)
cc:setType("ScrollableFrame")cc:addProperty("AutoCalculate","boolean",true)
cc:addProperty("Direction",{"vertical","horizontal"},"vertical")cc:addProperty("Scrollbar","boolean",false)
cc:addProperty("ScrollbarSymbolBackground","number",colors.black)
cc:addProperty("ScrollbarSymbolForeground","number",colors.black)cc:addProperty("ScrollbarSymbol","char"," ")
cc:combineProperty("ScrollbarFront","ScrollbarSymbol","ScrollbarSymbolBackground","ScrollbarSymbolForeground")
cc:addProperty("ScrollbarBackgroundSymbol","char","\127")
cc:addProperty("ScrollbarBackground","number",colors.gray)
cc:addProperty("ScrollbarForeground","number",colors.black)
cc:combineProperty("ScrollbarBack","ScrollbarBackgroundSymbol","ScrollbarBackground","ScrollbarForeground")
cc:addProperty("ScrollbarArrowForeground","number",colors.lightGray)
cc:addProperty("ScrollbarArrowBackground","number",colors.black)
cc:combineProperty("ScrollbarArrowColor","ScrollbarArrowBackground","ScrollbarArrowForeground")
cc:addProperty("ScrollAmount","number",0,false,function(dd,__a)dd:setAutoCalculate(false)end)cc:addProperty("ScrollSpeed","number",1)
local function dc(dd)local __a=0
local a_a=dd:getChildren()
for b_a,c_a in pairs(a_a)do
if
(c_a.element.getWidth~=nil)and(c_a.element.getX~=nil)then
local d_a,_aa=c_a.element:getWidth(),c_a.element:getX()local aaa=dd:getWidth()
if(c_a.element:getType()=="Dropdown")then
if
(c_a.element:isOpened())then local baa=c_a.element:getDropdownSize()if
(baa+_aa-aaa>=__a)then __a=ab(baa+_aa-aaa,0)end end end
if(d_a+_aa-aaa>=__a)then __a=ab(d_a+_aa-aaa,0)end end end;return __a end
local function _d(dd)local __a=0;local a_a=dd:getChildren()
for b_a,c_a in pairs(a_a)do
if
(c_a.element.getHeight~=nil)and(c_a.element.getY~=nil)then
local d_a,_aa=c_a.element:getHeight(),c_a.element:getY()local aaa=dd:getHeight()
if
(c_a.element:getType()=="Dropdown")then if(c_a.element:isOpened())then
local baa,caa=c_a.element:getDropdownSize()
if(caa+_aa-aaa>=__a)then __a=ab(caa+_aa-aaa,0)end end end
if(d_a+_aa-aaa>=__a)then __a=ab(d_a+_aa-aaa,0)end end end;return __a end
local function ad(dd,__a)local a_a,b_a=dd:getOffset()local c_a;local d_a=dd:getDirection()
local _aa=dd:getAutoCalculate()local aaa=dd:getScrollAmount()local baa=dd:getScrollSpeed()
if(d_a==
"horizontal")then c_a=_aa and dc(dd)or aaa
dd:setOffset(bb(c_a,ab(0,a_a+__a*baa)),b_a)elseif(d_a=="vertical")then c_a=_aa and _d(dd)or aaa
dd:setOffset(a_a,bb(c_a,ab(0,b_a+__a*baa)))end;dd:updateDraw()end
local function bd(dd,__a,a_a)local b_a=dd:getDirection()local c_a;local d_a=dd:getAutoCalculate()
local _aa=dd:getScrollAmount()
if(b_a=="horizontal")then
if(a_a==dd:getHeight())then if
(__a>1)and(__a<dd:getWidth())then c_a=d_a and dc(dd)or _aa
dd:setOffset(math.floor(
__a/dd:getWidth()*c_a),0)end end elseif(b_a=="vertical")then
if(__a==dd:getWidth())then if
(a_a>1)and(a_a<dd:getHeight())then c_a=d_a and _d(dd)or _aa
dd:setOffset(0,math.floor(
a_a/dd:getHeight()*c_a))end;if(a_a==1)then
ad(dd,-1)end;if(a_a==dd:getHeight())then ad(dd,1)end end end end
local cd={getBase=function(dd)return cc end,load=function(dd)cc.load(dd)
dd:listenEvent("mouse_scroll")dd:listenEvent("mouse_drag")
dd:listenEvent("mouse_click")dd:listenEvent("mouse_up")end,removeChildren=function(dd)
cc.removeChildren(dd)dd:listenEvent("mouse_scroll")
dd:listenEvent("mouse_drag")dd:listenEvent("mouse_click")
dd:listenEvent("mouse_up")end,scrollHandler=function(dd,__a,a_a,b_a)
if
(cc:getBase().scrollHandler(dd,__a,a_a,b_a))then dd:sortChildren()
for c_a,d_a in ipairs(dd:getEvents("mouse_scroll"))do
if(
d_a.element.scrollHandler~=nil)then local _aa,aaa=0,0
if(dd.getOffset~=nil)then _aa,aaa=dd:getOffset()end;if(d_a.element:getIgnoreOffset())then _aa,aaa=0,0 end
if(d_a.element.scrollHandler(d_a.element,__a,
a_a+_aa,b_a+aaa))then return true end end end;ad(dd,__a)dd:clearFocusedChild()return true end end,mouseHandler=function(dd,__a,a_a,b_a)if
(cc:getBase().mouseHandler(dd,__a,a_a,b_a))then local c_a,d_a=dd:getAbsolutePosition()
bd(dd,a_a-c_a+1,b_a-d_a+1)return true end end,dragHandler=function(dd,__a,a_a,b_a)if
(cc:getBase().dragHandler(dd,__a,a_a,b_a))then local c_a,d_a=dd:getAbsolutePosition()
bd(dd,a_a-c_a+1,b_a-d_a+1)return true end end,draw=function(dd)
cc.draw(dd)
dd:addDraw("scrollableFrameScrollbar",function()
if(dd:getScrollbar())then local __a,a_a=dd:getOffset()
local b_a=dd:getProperties()local c_a,d_a=b_a.Width,b_a.Height
if(b_a.Direction=="vertical")then local _aa=_d(dd)
local aaa=ab(1,math.floor(
d_a*d_a/ (d_a+_aa)))local baa=a_a* (d_a-aaa)/_aa
local caa,daa,_ba=dd:getScrollbarBack()local aba,bba,cba=dd:getScrollbarFront()
local dba,_ca=dd:getScrollbarArrowColor()daa=_c[daa]bba=_c[bba]_ba=_c[_ba]cba=_c[cba]dba=_c[dba]
_ca=_c[_ca]
for y=2,d_a-1 do local aca=caa;local bca=daa;local cca=_ba;if(y>=baa)and(y<=baa+aaa)then aca=aba;bca=bba
cca=cba end;dd:blit(c_a,y,aca,cca,bca)end;dd:blit(c_a,1,"\30",_ca,dba)
dd:blit(c_a,d_a,"\31",_ca,dba)elseif(b_a.Direction=="horizontal")then local _aa=dc(dd)
local aaa=ab(1,math.floor(c_a*c_a/ (c_a+_aa)))local baa=__a* (c_a-aaa)/_aa
local caa,daa,_ba=dd:getScrollbarBack()local aba,bba,cba=dd:getScrollbarFront()
local dba,_ca=dd:getScrollbarArrowColor()daa=_c[daa]bba=_c[bba]_ba=_c[_ba]cba=_c[cba]dba=_c[dba]
_ca=_c[_ca]
for x=2,c_a-1 do local aca=caa;local bca=daa;local cca=_ba;if(x>=baa)and(x<=baa+aaa)then aca=aba;bca=bba
cca=cba end;dd:blit(x,d_a,aca,cca,bca)end;dd:blit(1,d_a,"\17",_ca,dba)
dd:blit(c_a,d_a,"\16",_ca,dba)end end end)end}cd.__index=cd;return setmetatable(cd,cc)end end
aa["objects"]["MovableFrame"]=function(...)
local ab,bb,cb,db=math.max,math.min,string.sub,string.rep
return
function(_c,ac)local bc=ac.getObject("Frame")(_c,ac)
bc:setType("MovableFrame")local cc;local dc,_d,ad=0,0,false;local bd=ac.getRenderingThrottle()
bc:addProperty("DraggingMap","table",{{x1=1,x2="width",y1=1,y2=1}})
local cd={getBase=function(dd)return bc end,load=function(dd)bc.load(dd)
dd:listenEvent("mouse_click")dd:listenEvent("mouse_up")
dd:listenEvent("mouse_drag")end,removeChildren=function(dd)
bc.removeChildren(dd)dd:listenEvent("mouse_click")
dd:listenEvent("mouse_up")dd:listenEvent("mouse_drag")end,dragHandler=function(dd,__a,a_a,b_a)
if
(bc.dragHandler(dd,__a,a_a,b_a))then if(ad)then local c_a=1;local d_a=1;c_a,d_a=cc:getAbsolutePosition()dd:setPosition(a_a+dc-
(c_a-1),b_a+_d- (d_a-1))
dd:updateDraw()end;return true end end,mouseHandler=function(dd,__a,a_a,b_a,...)
if
(bc.mouseHandler(dd,__a,a_a,b_a,...))then cc:setImportant(dd)local c_a,d_a=dd:getAbsolutePosition()
local _aa,aaa=dd:getSize()local baa=dd:getDraggingMap()
for caa,daa in pairs(baa)do
local _ba,aba=daa.x1 =="width"and _aa or
daa.x1,daa.x2 =="width"and _aa or daa.x2;local bba,cba=daa.y1 =="height"and aaa or daa.y1,
daa.y2 =="height"and aaa or daa.y2
if
(a_a>=
c_a+_ba-1)and(a_a<=c_a+aba-1)and(b_a>=d_a+bba-1)and(b_a<=d_a+cba-1)then
bd=ac.getRenderingThrottle()ac.setRenderingThrottle(50)ad=true;dc=c_a-a_a;_d=d_a-b_a
return true end end;return true end end,mouseUpHandler=function(dd,...)
ad=false;ac.setRenderingThrottle(0)
return bc.mouseUpHandler(dd,...)end,setParent=function(dd,__a,...)
bc.setParent(dd,__a,...)cc=__a;return dd end}cd.__index=cd;return setmetatable(cd,bc)end end
aa["objects"]["Scrollbar"]=function(...)local ab=da("tHex")
return
function(bb,cb)
local db=cb.getObject("VisualObject")(bb,cb)db:setType("Scrollbar")db:setZ(2)db:setSize(1,8)
db:setBackground(colors.lightGray,"\127",colors.black)db:addProperty("SymbolChar","char"," ")
db:addProperty("SymbolBG","color",colors.black)db:addProperty("SymbolFG","color",colors.black)
db:combineProperty("Symbol","SymbolChar","SymbolBG","SymbolFG")db:addProperty("SymbolAutoSize","boolean",true)local _c=1
local function ac()
local dc,_d=db:getSize()local ad=db:getSymbolAutoSize()
if(ad)then local bd=db:getBarType()
local cd=db:getScrollAmount()local dd=db:getSymbolChar()
db:setSymbolSize(math.max((bd=="vertical"and _d or
dc- (#dd))- (cd-1),1))end end;db:addProperty("ScrollAmount","number",3,false,ac)
db:addProperty("SymbolSize","number",1)
db:addProperty("BarType",{"vertical","horizontal"},"vertical",false,ac)ac()
local function bc(dc,_d,ad,bd)local cd,dd=dc:getAbsolutePosition()local __a,a_a=dc:getSize()
ac()local b_a=dc:getBarType()local c_a=dc:getSymbolChar()
local d_a=dc:getSymbolSize()local _aa=b_a=="vertical"and a_a or __a
for i=0,_aa do
if


( (
b_a=="vertical"and dd+i==bd)or(b_a=="horizontal"and cd+i==ad))and(cd<=ad)and(cd+__a>ad)and(dd<=bd)and(dd+a_a>bd)then _c=math.min(i+1,_aa- (#c_a+d_a-2))
dc:scrollbarMoveHandler()dc:updateDraw()end end end
local cc={load=function(dc)db.load(dc)dc:listenEvent("mouse_click")
dc:listenEvent("mouse_up")dc:listenEvent("mouse_scroll")
dc:listenEvent("mouse_drag")end,setIndex=function(dc,_d)_c=_d;if(
_c<1)then _c=1 end;ac()dc:updateDraw()return dc end,getIndex=function(dc)
local _d,ad=dc:getSize()local bd=dc:getBarType()local cd=dc:getScrollAmount()
return
cd> (
bd=="vertical"and ad or _d)and math.floor(cd/ (
bd=="vertical"and ad or _d)*_c)or _c end,mouseHandler=function(dc,_d,ad,bd,...)if
(db.mouseHandler(dc,_d,ad,bd,...))then bc(dc,_d,ad,bd)return true end;return false end,dragHandler=function(dc,_d,ad,bd)if
(db.dragHandler(dc,_d,ad,bd))then bc(dc,_d,ad,bd)return true end;return false end,setSize=function(dc,...)
db.setSize(dc,...)ac()return dc end,scrollHandler=function(dc,_d,ad,bd)
if(db.scrollHandler(dc,_d,ad,bd))then
local cd,dd=dc:getSize()ac()_c=_c+_d;if(_c<1)then _c=1 end;local __a=dc:getBarType()
local a_a=dc:getSymbolChar()local b_a=dc:getSymbolSize()
_c=math.min(_c,
(__a=="vertical"and dd or cd)- (__a=="vertical"and b_a-1 or#a_a+b_a-2))dc:scrollbarMoveHandler()dc:updateDraw()end end,onChange=function(dc,...)
for _d,ad in
pairs(table.pack(...))do if(type(ad)=="function")then
dc:registerEvent("scrollbar_moved",ad)end end;return dc end,scrollbarMoveHandler=function(dc)
dc:sendEvent("scrollbar_moved",dc:getIndex())end,customEventHandler=function(dc,_d,...)
db.customEventHandler(dc,_d,...)if(_d=="basalt_FrameResize")then ac()end end,draw=function(dc)
db.draw(dc)
dc:addDraw("scrollbar",function()local _d=dc:getProperties()local ad,bd=_d.Width,_d.Height
if(_d.BarType==
"horizontal")then
for n=0,bd-1 do
dc:addBlit(_c,1 +n,_d.SymbolChar:rep(_d.SymbolSize),ab[_d.SymbolFG]:rep(
#_d.SymbolChar*_d.SymbolSize),ab[_d.SymbolBG]:rep(
#_d.SymbolChar*_d.SymbolSize))end elseif(_d.BarType=="vertical")then
for n=0,bd-1 do
if(_c==n+1)then
for curIndexOffset=0,math.min(_d.SymbolSize-1,bd)do
dc:addBlit(1,
_c+curIndexOffset,_d.SymbolChar:rep(math.max(#_d.SymbolChar,ad)),ab[_d.SymbolFG]:rep(math.max(
#_d.SymbolChar,ad)),ab[_d.SymbolBG]:rep(math.max(
#_d.SymbolChar,ad)))end end end end end)end}cc.__index=cc;return setmetatable(cc,db)end end
aa["objects"]["Switch"]=function(...)
return
function(ab,bb)
local cb=bb.getObject("ChangeableObject")(ab,bb)cb:setType("Switch")cb:setSize(4,1)
cb:setValue(false)cb:setZ(5)
cb:addProperty("SymbolColor","color",colors.black)
cb:addProperty("ActiveBackground","color",colors.green)
cb:addProperty("InactiveBackground","color",colors.red)
local db={load=function(_c)_c:listenEvent("mouse_click")end,mouseHandler=function(_c,...)if
(cb.mouseHandler(_c,...))then _c:setValue(not _c:getValue())
_c:updateDraw()return true end end,draw=function(_c)
cb.draw(_c)
_c:addDraw("switch",function()local ac=_c:getActiveBackground()
local bc=_c:getInactiveBackground()local cc=_c:getSymbolColor()local dc,_d=_c:getSize()
if(_c:getValue())then
_c:addBackgroundBox(1,1,dc,_d,ac)_c:addBackgroundBox(dc,1,1,_d,cc)else
_c:addBackgroundBox(1,1,dc,_d,bc)_c:addBackgroundBox(1,1,1,_d,cc)end end)end}db.__index=db;return setmetatable(db,cb)end end
aa["objects"]["Treeview"]=function(...)local ab=da("utils")local bb=da("tHex")
return
function(cb,db)
local _c=db.getObject("ChangeableObject")(cb,db)_c:setType("Treeview")
_c:addProperty("Nodes","table",{})
_c:addProperty("SelectionBackground","color",colors.black)
_c:addProperty("SelectionForeground","color",colors.lightGray)
_c:combineProperty("SelectionColor","SelectionBackground","SelectionForeground")_c:addProperty("XOffset","number",0)
_c:addProperty("YOffset","number",0)_c:combineProperty("Offset","XOffset","YOffset")
_c:addProperty("Scrollable","boolean",true)
_c:addProperty("TextAlign",{"left","center","right"},"left")_c:addProperty("ExpandableSymbol","char","\7")
_c:addProperty("ExpandableSymbolForeground","color",colors.lightGray)
_c:addProperty("ExpandableSymbolBackground","color",colors.black)
_c:combineProperty("ExpandableSymbolColor","ExpandableSymbolForeground","ExpandableSymbolBackground")_c:addProperty("ExpandedSymbol","char","\8")
_c:addProperty("ExpandedSymbolForeground","color",colors.lightGray)
_c:addProperty("ExpandedSymbolBackground","color",colors.black)
_c:combineProperty("ExpandedSymbolColor","ExpandedSymbolForeground","ExpandedSymbolBackground")
_c:addProperty("ExpandableSymbolSpacing","number",1)
_c:addProperty("selectionColorActive","boolean",true)_c:setSize(16,8)_c:setZ(5)
local function ac(dc,_d)dc=dc or""_d=_d or false
local ad=false;local bd=nil;local cd={}local dd={}local __a
dd={getChildren=function(a_a)return cd end,setParent=function(a_a,b_a)if(bd~=nil)then
bd.removeChild(bd.findChildrenByText(dd.getText()))end;bd=b_a;_c:updateDraw()return dd end,getParent=function(a_a)return
bd end,addChild=function(a_a,b_a,c_a)local d_a=ac(b_a,c_a)d_a.setParent(dd)
table.insert(cd,d_a)_c:updateDraw()return d_a end,setExpanded=function(a_a,b_a)if
(_d)then ad=b_a end;_c:updateDraw()return dd end,isExpanded=function(a_a)return
ad end,onSelect=function(a_a,...)for b_a,c_a in pairs(table.pack(...))do if(type(c_a)=="function")then
__a=c_a end end;return dd end,callOnSelect=function(a_a)if(
__a~=nil)then __a(dd)end end,setExpandable=function(a_a,b_a)b_a=b_a
_c:updateDraw()return dd end,isExpandable=function(a_a)return _d end,removeChild=function(a_a,b_a)
if(type(b_a)=="table")then for c_a,d_a in
pairs(b_a)do if(d_a==b_a)then b_a=c_a;break end end end;table.remove(cd,b_a)_c:updateDraw()return dd end,findChildrenByText=function(a_a,b_a)
local c_a={}
for d_a,_aa in ipairs(cd)do if string.find(_aa.getText(),b_a)then
table.insert(c_a,_aa)end end;return c_a end,getText=function(a_a)return
dc end,setText=function(a_a,b_a)dc=b_a;_c:updateDraw()return dd end}return dd end;local bc=ac("Root",true)
_c:addProperty("Root","table",bc,false,function(dc,_d)_d.setParent(nil)end)bc:setExpanded(true)
local cc={init=function(dc)local _d=dc:getParent()
dc:listenEvent("mouse_click")dc:listenEvent("mouse_scroll")return _c.init(dc)end,getBase=function(dc)return
_c end,onSelect=function(dc,...)
for _d,ad in pairs(table.pack(...))do if(type(ad)=="function")then
dc:registerEvent("treeview_select",ad)end end;return dc end,selectionHandler=function(dc,_d)
_d.callOnSelect(_d)dc:sendEvent("treeview_select",_d)return dc end,mouseHandler=function(dc,_d,ad,bd)
if
_c.mouseHandler(dc,_d,ad,bd)then local cd=1 -dc:getYOffset()
local dd,__a=dc:getAbsolutePosition()local a_a,b_a=dc:getSize()
local function c_a(d_a,_aa)
if bd==__a+cd-1 then
if ad>=dd and ad<dd+a_a then d_a:setExpanded(
not d_a:isExpanded())
dc:selectionHandler(d_a)dc:setValue(d_a)dc:updateDraw()return true end end;cd=cd+1
if d_a:isExpanded()then for aaa,baa in ipairs(d_a:getChildren())do if c_a(baa,_aa+1)then
return true end end end;return false end
for d_a,_aa in ipairs(bc:getChildren())do if c_a(_aa,1)then return true end end end end,scrollHandler=function(dc,_d,ad,bd)
if
_c.scrollHandler(dc,_d,ad,bd)then local cd=dc:getScrollable()local dd=dc:getYOffset()
if cd then
local __a,a_a=dc:getSize()dd=dd+_d;if dd<0 then dd=0 end
if _d>=1 then local b_a=0;local function c_a(d_a,_aa)b_a=b_a+1
if d_a:isExpanded()then for aaa,baa in
ipairs(d_a:getChildren())do c_a(baa,_aa+1)end end end;for d_a,_aa in
ipairs(bc:getChildren())do c_a(_aa,1)end;if b_a>a_a then
if dd>b_a-a_a then dd=b_a-a_a end else dd=dd-1 end end;dc:setYOffset(dd)dc:updateDraw()end;return true end;return false end,draw=function(dc)
_c.draw(dc)
dc:addDraw("treeview",function()local _d,ad=dc:getOffset()local bd
dc:getSelectionBackground()local cd;dc:getSelectionForeground()local dd=1 -ad
local __a=dc:getValue()
local function a_a(b_a,c_a)local d_a,_aa=dc:getSize()
if dd>=1 and dd<=_aa then local aaa=(b_a==__a)and bd or
dc:getBackground()local baa=(b_a==__a)and cd or
dc:getForeground()local caa=b_a.getText()
dc:addBlit(1 +
c_a+_d,dd,caa,bb[baa]:rep(#caa),bb[aaa]:rep(#caa))end;dd=dd+1;if b_a:isExpanded()then for aaa,baa in ipairs(b_a:getChildren())do
a_a(baa,c_a+1)end end end;for b_a,c_a in ipairs(bc:getChildren())do a_a(c_a,1)end end)end}cc.__index=cc;return setmetatable(cc,_c)end end
aa["objects"]["VisualObject"]=function(...)local ab=da("utils")local bb=da("tHex")
local cb,db,_c=string.sub,string.find,table.insert
local function ac(bc,cc)local dc={}if bc==""then return dc end;cc=cc or" "local _d=1;local ad,bd=db(bc,cc,_d)while ad do _c(dc,{x=_d,value=cb(bc,_d,
ad-1)})_d=bd+1
ad,bd=db(bc,cc,_d)end
_c(dc,{x=_d,value=cb(bc,_d)})return dc end
return
function(bc,cc)local dc=cc.getObject("Object")(bc,cc)
dc:setType("VisualObject")local _d,ad,bd,cd=false,false,false,false;local dd,__a=0,0;local a_a;local b_a={}local c_a={}local d_a={}local _aa={}
dc:addProperty("Visible","boolean",true,false,function(baa,caa)
baa:setProperty("Enabled",caa)end)dc:addProperty("Transparent","boolean",false)
dc:addProperty("Background","color",colors.black)dc:addProperty("BgSymbol","char","")
dc:addProperty("BgSymbolColor","color",colors.red)
dc:addProperty("Foreground","color",colors.white)
dc:addProperty("X","number",1,false,function(baa,caa)local daa=baa:getProperty("Y")if(a_a~=nil)then
a_a:customEventHandler("basalt_FrameReposition",baa,caa,daa)end
baa:repositionHandler(caa,daa)end)
dc:addProperty("Y","number",1,false,function(baa,caa)local daa=baa:getProperty("X")if(a_a~=nil)then
a_a:customEventHandler("basalt_FrameReposition",baa,daa,caa)end
baa:repositionHandler(daa,caa)end)
dc:addProperty("Width","number",1,false,function(baa,caa)local daa=baa:getProperty("Height")if(a_a~=nil)then
a_a:customEventHandler("basalt_FrameResize",baa,caa,daa)end
baa:resizeHandler(caa,daa)end)
dc:addProperty("Height","number",1,false,function(baa,caa)local daa=baa:getProperty("Width")if(a_a~=nil)then
a_a:customEventHandler("basalt_FrameResize",baa,daa,caa)end
baa:resizeHandler(daa,caa)end)
dc:addProperty("IgnoreOffset","boolean",false,false)dc:combineProperty("Position","X","Y")
dc:combineProperty("Size","Width","Height")dc:setProperty("Clicked",false)
dc:setProperty("Hovered",false)dc:setProperty("Dragging",false)
dc:setProperty("Focused",false)
local aaa={getBase=function(baa)return dc end,getBasalt=function(baa)return cc end,show=function(baa)baa:setVisible(true)return baa end,hide=function(baa)
baa:setVisible(false)return baa end,isVisible=function(baa)return baa:getVisible()end,setParent=function(baa,caa,daa)
a_a=caa;dc.setParent(baa,caa,daa)return baa end,setFocus=function(baa)if(
a_a~=nil)then a_a:setFocusedChild(baa)end;return baa end,updateDraw=function(baa)if(
a_a~=nil)then a_a:updateDraw()end;return baa end,getAbsolutePosition=function(baa,caa,daa)
if(
caa==nil)or(daa==nil)then caa,daa=baa:getPosition()end;if(a_a~=nil)then local _ba,aba=a_a:getAbsolutePosition()caa=_ba+caa-1;daa=
aba+daa-1 end;return caa,daa end,getRelativePosition=function(baa,caa,daa)if(
caa==nil)or(daa==nil)then caa,daa=1,1 end
if(a_a~=nil)then
local _ba,aba=baa:getAbsolutePosition()caa=_ba-caa+1;daa=aba-daa+1 end;return caa,daa end,isCoordsInObject=function(baa,caa,daa)
if
(baa:getVisible())and(baa:getEnabled())then
if(caa==nil)or(daa==nil)then return false end;local _ba,aba=baa:getAbsolutePosition()local bba,cba=baa:getSize()if

(_ba<=caa)and(_ba+bba>caa)and(aba<=daa)and(aba+cba>daa)then return true end end;return false end,onGetFocus=function(baa,...)
for caa,daa in
pairs(table.pack(...))do if(type(daa)=="function")then
baa:registerEvent("get_focus",daa)end end;return baa end,onLoseFocus=function(baa,...)
for caa,daa in
pairs(table.pack(...))do if(type(daa)=="function")then
baa:registerEvent("lose_focus",daa)end end;return baa end,isFocused=function(baa)if(
a_a~=nil)then return a_a:getFocused()==baa end;return
true end,resizeHandler=function(baa,...)
if(baa:isEnabled())then
local caa=baa:sendEvent("basalt_resize",...)if(caa==false)then return false end end;return true end,repositionHandler=function(baa,...)if
(baa:isEnabled())then local caa=baa:sendEvent("basalt_reposition",...)if(caa==false)then
return false end end;return
true end,onResize=function(baa,...)
for caa,daa in
pairs(table.pack(...))do if(type(daa)=="function")then
baa:registerEvent("basalt_resize",daa)end end;return baa end,onReposition=function(baa,...)
for caa,daa in
pairs(table.pack(...))do if(type(daa)=="function")then
baa:registerEvent("basalt_reposition",daa)end end;return baa end,mouseHandler=function(baa,caa,daa,_ba,aba)
if
(baa:isCoordsInObject(daa,_ba))then local bba,cba=baa:getAbsolutePosition()
local dba=baa:sendEvent("mouse_click",caa,daa- (bba-1),
_ba- (cba-1),daa,_ba,aba)if(dba==false)then return false end;if(a_a~=nil)then
a_a:setFocusedChild(baa)end;bd=true;cd=true
baa:setProperty("Dragging",true)baa:setProperty("Clicked",true)dd,__a=daa,_ba;return true end end,mouseUpHandler=function(baa,caa,daa,_ba)
cd=false
if(bd)then local aba,bba=baa:getAbsolutePosition()
local cba=baa:sendEvent("mouse_release",caa,daa- (aba-1),
_ba- (bba-1),daa,_ba)bd=false;baa:setProperty("Clicked",false)
baa:setProperty("Dragging",false)end
if(baa:isCoordsInObject(daa,_ba))then local aba,bba=baa:getAbsolutePosition()
local cba=baa:sendEvent("mouse_up",caa,
daa- (aba-1),_ba- (bba-1),daa,_ba)if(cba==false)then return false end;return true end end,dragHandler=function(baa,caa,daa,_ba)
if
(cd)then local aba,bba=baa:getAbsolutePosition()
local cba=baa:sendEvent("mouse_drag",caa,daa- (aba-1),_ba- (
bba-1),dd-daa,__a-_ba,daa,_ba)dd,__a=daa,_ba;if(cba~=nil)then return cba end;if(a_a~=nil)then
a_a:setFocusedChild(baa)end;return true end;if(baa:isCoordsInObject(daa,_ba))then dd,__a=daa,_ba end end,scrollHandler=function(baa,caa,daa,_ba)
if
(baa:isCoordsInObject(daa,_ba))then local aba,bba=baa:getAbsolutePosition()
local cba=baa:sendEvent("mouse_scroll",caa,daa- (aba-1),
_ba- (bba-1))if(cba==false)then return false end;if(a_a~=nil)then
a_a:setFocusedChild(baa)end;return true end end,hoverHandler=function(baa,caa,daa,_ba)
if
(baa:isCoordsInObject(caa,daa))then local aba=baa:sendEvent("mouse_hover",caa,daa,_ba)if(aba==false)then return
false end;ad=true
baa:setProperty("Hovered",true)return true end;if(ad)then local aba=baa:sendEvent("mouse_leave",caa,daa,_ba)if
(aba==false)then return false end;ad=false
baa:setProperty("Hovered",false)end end,keyHandler=function(baa,caa,daa)
if
(baa:isEnabled())and(baa:getVisible())then
if(baa:isFocused())then
local _ba=baa:sendEvent("key",caa,daa)if(_ba==false)then return false end;return true end end end,keyUpHandler=function(baa,caa)
if
(baa:isEnabled())and(baa:getVisible())then
if(baa:isFocused())then
local daa=baa:sendEvent("key_up",caa)if(daa==false)then return false end;return true end end end,charHandler=function(baa,caa)
if
(baa:isEnabled())and(baa:getVisible())then
if(baa:isFocused())then
local daa=baa:sendEvent("char",caa)if(daa==false)then return false end;return true end end end,getFocusHandler=function(baa)
local caa=baa:sendEvent("get_focus")baa:setProperty("Focused",true)
if(caa~=nil)then return caa end;return true end,loseFocusHandler=function(baa)
cd=false;baa:setProperty("Dragging",false)
baa:setProperty("Focused",false)local caa=baa:sendEvent("lose_focus")
if(caa~=nil)then return caa end;return true end,addDraw=function(baa,caa,daa,_ba,aba,bba)
local cba=(
aba==nil or aba==1)and c_a or aba==2 and b_a or aba==
3 and d_a;_ba=_ba or#cba+1
if(caa~=nil)then for _ca,aca in pairs(cba)do if(aca.name==caa)then
table.remove(cba,_ca)break end end
local dba={name=caa,f=daa,pos=_ba,active=
bba~=nil and bba or true}table.insert(cba,_ba,dba)end;baa:updateDraw()return baa end,addPreDraw=function(baa,caa,daa,_ba,aba)
baa:addDraw(caa,daa,_ba,2)return baa end,addPostDraw=function(baa,caa,daa,_ba,aba)
baa:addDraw(caa,daa,_ba,3)return baa end,setDrawState=function(baa,caa,daa,_ba)
local aba=
(_ba==nil or _ba==1)and c_a or _ba==2 and b_a or _ba==3 and d_a
for bba,cba in pairs(aba)do if(cba.name==caa)then cba.active=daa;break end end;baa:updateDraw()return baa end,getDrawId=function(baa,caa,daa)local _ba=

daa==1 and c_a or daa==2 and b_a or daa==3 and d_a or c_a;for aba,bba in pairs(_ba)do if(
bba.name==caa)then return aba end end end,addText=function(baa,caa,daa,_ba)local aba=
baa:getParent()or baa;local bba,cba=baa:getPosition()
local dba=baa:getTransparent()
if(a_a~=nil)then local aca,bca=a_a:getOffset()
bba=_d and bba or bba-aca;cba=_d and cba or cba-bca end;if not(dba)then aba:setText(caa+bba-1,daa+cba-1,_ba)
return end;local _ca=ac(_ba,"\0")
for aca,bca in pairs(_ca)do if
(bca.value~="")and(bca.value~="\0")then
aba:setText(caa+bca.x+bba-2,daa+cba-1,bca.value)end end end,addBg=function(baa,caa,daa,_ba,aba)local bba=
a_a or baa;local cba,dba=baa:getPosition()
local _ca=baa:getTransparent()
if(a_a~=nil)then local bca,cca=a_a:getOffset()
cba=_d and cba or cba-bca;dba=_d and dba or dba-cca end
if not(_ca)then bba:setBg(caa+cba-1,daa+dba-1,_ba)return end;local aca=ac(_ba)
for bca,cca in pairs(aca)do
if(cca.value~="")and(cca.value~=" ")then
if
(aba~=true)then
bba:setText(caa+cca.x+cba-2,daa+dba-1,(" "):rep(#cca.value))
bba:setBg(caa+cca.x+cba-2,daa+dba-1,cca.value)else
table.insert(_aa,{x=caa+cca.x-1,y=daa,bg=cca.value})bba:setBg(caa+cba-1,daa+dba-1,cca.value)end end end end,addFg=function(baa,caa,daa,_ba)local aba=
a_a or baa;local bba,cba=baa:getPosition()
local dba=baa:getTransparent()
if(a_a~=nil)then local aca,bca=a_a:getOffset()
bba=_d and bba or bba-aca;cba=_d and cba or cba-bca end
if not(dba)then aba:setFg(caa+bba-1,daa+cba-1,_ba)return end;local _ca=ac(_ba)
for aca,bca in pairs(_ca)do if(bca.value~="")and(bca.value~=" ")then
aba:setFg(
caa+bca.x+bba-2,daa+cba-1,bca.value)end end end,addBlit=function(baa,caa,daa,_ba,aba,bba)local cba=
a_a or baa;local dba,_ca=baa:getPosition()
local aca=baa:getTransparent()
if(a_a~=nil)then local _da,ada=a_a:getOffset()
dba=_d and dba or dba-_da;_ca=_d and _ca or _ca-ada end;if not(aca)then
cba:blit(caa+dba-1,daa+_ca-1,_ba,aba,bba)return end;local bca=ac(_ba,"\0")local cca=ac(aba)
local dca=ac(bba)
for _da,ada in pairs(bca)do if(ada.value~="")or(ada.value~="\0")then
cba:setText(caa+ada.x+
dba-2,daa+_ca-1,ada.value)end end;for _da,ada in pairs(dca)do
if(ada.value~="")or(ada.value~=" ")then cba:setBg(
caa+ada.x+dba-2,daa+_ca-1,ada.value)end end;for _da,ada in pairs(cca)do
if(
ada.value~="")or(ada.value~=" ")then cba:setFg(caa+ada.x+dba-2,daa+
_ca-1,ada.value)end end end,addTextBox=function(baa,caa,daa,_ba,aba,bba)local cba=
a_a or baa;local dba,_ca=baa:getPosition()if(a_a~=nil)then
local aca,bca=a_a:getOffset()dba=_d and dba or dba-aca
_ca=_d and _ca or _ca-bca end;cba:drawTextBox(caa+dba-1,
daa+_ca-1,_ba,aba,bba)end,addForegroundBox=function(baa,caa,daa,_ba,aba,bba)local cba=
a_a or baa;local dba,_ca=baa:getPosition()if(a_a~=nil)then
local aca,bca=a_a:getOffset()dba=_d and dba or dba-aca
_ca=_d and _ca or _ca-bca end;cba:drawForegroundBox(caa+dba-1,
daa+_ca-1,_ba,aba,bba)end,addBackgroundBox=function(baa,caa,daa,_ba,aba,bba)local cba=
a_a or baa;local dba,_ca=baa:getPosition()if(a_a~=nil)then
local aca,bca=a_a:getOffset()dba=_d and dba or dba-aca
_ca=_d and _ca or _ca-bca end;cba:drawBackgroundBox(caa+dba-1,
daa+_ca-1,_ba,aba,bba)end,render=function(baa)if
(baa:getVisible())then baa:redraw()end end,redraw=function(baa)for caa,daa in
pairs(b_a)do if(daa.active)then daa.f(baa)end end;for caa,daa in
pairs(c_a)do if(daa.active)then daa.f(baa)end end;for caa,daa in
pairs(d_a)do if(daa.active)then daa.f(baa)end end
return true end,draw=function(baa)
baa:addDraw("base",function()
local caa,daa=baa:getSize()local _ba=baa:getBackground()local aba=baa:getBgSymbol()
local bba=baa:getBgSymbolColor()local cba=baa:getForeground()
if(_ba~=nil)then
baa:addTextBox(1,1,caa,daa," ")baa:addBackgroundBox(1,1,caa,daa,_ba)end;if(aba~=nil)and(aba~="")then baa:addTextBox(1,1,caa,daa,aba)
baa:addForegroundBox(1,1,caa,daa,bba)end;if(cba~=nil)then
baa:addForegroundBox(1,1,caa,daa,cba)end end,1)end}aaa.__index=aaa;return setmetatable(aaa,dc)end end
aa["objects"]["Button"]=function(...)local ab=da("utils")local bb=da("tHex")
return
function(cb,db)
local _c=db.getObject("VisualObject")(cb,db)_c:setType("Button")_c:setSize(12,3)_c:setZ(5)
_c:addProperty("text","string","Button")
_c:addProperty("textHorizontalAlign",{"left","center","right"},"center")
_c:addProperty("textVerticalAlign",{"left","center","right"},"center")
_c:combineProperty("textAlign","textHorizontalAlign","textVerticalAlign")
local ac={getBase=function(bc)return _c end,draw=function(bc)_c.draw(bc)
bc:addDraw("button",function()local cc,dc=bc:getSize()
local _d=bc:getTextHorizontalAlign()local ad=bc:getTextVerticalAlign()
local bd=ab.getTextVerticalAlign(dc,ad)local cd=bc:getText()local dd
if(_d=="center")then
dd=math.floor((cc-cd:len())/2)elseif(_d=="right")then dd=cc-cd:len()end;bc:addText(dd+1,bd,cd)
bc:addFg(dd+1,bd,bb[bc:getForeground()or colors.white]:rep(cd:len()))end)end}ac.__index=ac;return setmetatable(ac,_c)end end
aa["objects"]["Input"]=function(...)local ab=da("utils")local bb=da("tHex")
return
function(cb,db)
local _c=db.getObject("ChangeableObject")(cb,db)_c:setType("Input")_c:setZ(5)_c:setValue("")
_c:setSize(12,1)local ac=""
_c:addProperty("defaultText","string","",nil,function(dc,_d)ac=_d end)_c:addProperty("defaultForeground","color",nil)_c:addProperty("defaultBackground","color",
nil)
_c:combineProperty("default","defaultText","defaultForeground","defaultBackground")_c:addProperty("offset","number",1)
_c:addProperty("cursorPosition","number",1)
_c:addProperty("inputType",{"text","number","password"},"text")_c:addProperty("inputLimit","number",0)
_c:addProperty("align",{"left","center","right"},"left")local bc=false
local cc={load=function(dc)dc:listenEvent("mouse_click")
dc:listenEvent("key")dc:listenEvent("char")
dc:listenEvent("other_event")dc:listenEvent("mouse_drag")end,setValue=function(dc,_d)
_c.setValue(dc,tostring(_d))
if not(bc)then local ad=tostring(_d):len()+1;local bd=math.max(1,ad-
dc:getWidth()+1)
dc:setOffset(bd)dc:setCursorPosition(ad)
if(dc:isFocused())then
local cd=dc:getParent()local dd,__a=dc:getPosition()
cd:setCursor(true,dd+ad-bd,__a+
math.floor(dc:getHeight()/2),dc:getForeground())end end;dc:updateDraw()return dc end,getFocusHandler=function(dc)
_c.getFocusHandler(dc)local _d=dc:getParent()
if(_d~=nil)then local ad=dc:getDefaultText()ac=""if
(ad~="")then dc:updateDraw()end end end,loseFocusHandler=function(dc)
_c.loseFocusHandler(dc)local _d=dc:getParent()ac=dc:getDefaultText()if(ac~="")then
dc:updateDraw()end;_d:setCursor(false)end,keyHandler=function(dc,_d)
if
(_c.keyHandler(dc,_d))then local ad,bd=dc:getSize()local cd=dc:getParent()bc=true
local dd=dc:getOffset()local __a=dc:getCursorPosition()
if(_d==keys.backspace)then
local a_a=tostring(dc:getValue())if(__a>1)then
dc:setValue(a_a:sub(1,__a-2)..a_a:sub(__a,a_a:len()))__a=math.max(__a-1,1)
if(__a<dd)then dd=math.max(dd-1,1)end end end
if(_d==keys.enter)then cd:clearFocusedChild(dc)end
if(_d==keys.right)then
local a_a=tostring(dc:getValue()):len()__a=__a+1;if(__a>a_a)then __a=a_a+1 end;__a=math.max(__a,1)if
(__a<dd)or(__a>=ad+dd)then dd=__a-ad+1 end
dd=math.max(dd,1)end;if(_d==keys.left)then __a=__a-1;if(__a>=1)then
if(__a<dd)or(__a>=ad+dd)then dd=__a end end;__a=math.max(__a,1)
dd=math.max(dd,1)end;if
(_d==keys.home)then __a=1;dd=1 end
if(_d==keys["end"])then __a=
tostring(dc:getValue()):len()+1;dd=math.max(__a-ad+1,1)end;dc:setOffset(dd)dc:setCursorPosition(__a)
dc:updateDraw()bc=false;return true end end,charHandler=function(dc,_d)
if
(_c.charHandler(dc,_d))then bc=true;local ad=dc:getOffset()local bd=dc:getCursorPosition()
local cd,dd=dc:getSize()local __a=tostring(dc:getValue())
local a_a=dc:getInputType()local b_a=dc:getInputLimit()
if(__a:len()<b_a or b_a<=0)then
if
(a_a=="number")then local c_a=__a
if
(bd==1 and _d=="-")or(_d==".")or(tonumber(_d)~=nil)then
dc:setValue(__a:sub(1,bd-1).._d..__a:sub(bd,__a:len()))bd=bd+1;if(_d==".")or(_d=="-")and(#__a>0)then
if(
tonumber(dc:getValue())==nil)then dc:setValue(c_a)bd=bd-1 end end end else
dc:setValue(__a:sub(1,bd-1).._d..__a:sub(bd,__a:len()))bd=bd+1 end;if(bd>=cd+ad)then ad=ad+1 end;dc:setOffset(ad)
dc:setCursorPosition(bd)end;bc=false;dc:updateDraw()return true end end,mouseHandler=function(dc,_d,ad,bd)
if
(_c.mouseHandler(dc,_d,ad,bd))then local cd,dd=dc:getPosition()
local __a,a_a=dc:getAbsolutePosition(cd,dd)local b_a=dc:getOffset()local c_a=dc:getCursorPosition()
c_a=ad-__a+b_a;local d_a=tostring(dc:getValue())if(c_a>d_a:len())then
c_a=d_a:len()+1 end
if(c_a<b_a)then b_a=c_a-1;if(b_a<1)then b_a=1 end end;dc:setOffset(b_a)dc:setCursorPosition(c_a)return true end end,dragHandler=function(dc,_d,ad,bd,cd,dd)
if
(dc:isFocused())then if(dc:isCoordsInObject(ad,bd))then
if(_c.dragHandler(dc,_d,ad,bd,cd,dd))then return true end end;local __a=dc:getParent()
__a:clearFocusedChild()end end,eventHandler=function(dc,_d,ad,...)
_c.eventHandler(dc,_d,ad,...)
if(_d=="paste")then
if(dc:isFocused())then local bd=tostring(dc:getValue())
local cd=dc:getCursorPosition()local dd=dc:getInputType()
if(dd=="number")then local __a=bd;if(ad==".")or
(tonumber(ad)~=nil)then
dc:setValue(bd:sub(1,cd-1)..ad..bd:sub(cd,bd:len()))end;if(tonumber(dc:getValue())==
nil)then dc:setValue(__a)end else
dc:setValue(bd:sub(1,
cd-1)..ad..bd:sub(cd,bd:len()))end;dc:updateDraw()end end end,draw=function(dc)
_c.draw(dc)
dc:addDraw("input",function()local _d=dc:getParent()local ad,bd=dc:getPosition()
local cd,dd=dc:getSize()local __a=dc:getOffset()local a_a=dc:getCursorPosition()
local b_a=dc:getDefaultBackground()local c_a=dc:getDefaultForeground()local d_a=dc:getInputType()
local _aa=ab.getTextVerticalAlign(dd,"center")local aaa=tostring(dc:getValue()or"")
local baa=dc:getBackground()local caa=dc:getForeground()local daa
if(aaa:len()<=0)then if
not(dc:isFocused())then daa=ac;baa=b_a or baa;caa=c_a or caa end end;daa=ac;if(aaa~="")then daa=aaa end;daa=daa:sub(__a,cd+__a-1)local _ba=cd-
daa:len()if(_ba<0)then _ba=0 end
if
(d_a=="password")and(aaa~="")then daa=string.rep("*",daa:len())end;daa=daa..string.rep(" ",_ba)
dc:addBlit(1,_aa,daa,bb[caa]:rep(daa:len()),bb[baa]:rep(daa:len()))if(dc:isFocused())then
_d:setCursor(true,ad+a_a-__a,bd+
math.floor(dc:getHeight()/2),dc:getForeground())end end)end}cc.__index=cc;return setmetatable(cc,_c)end end
aa["objects"]["Image"]=function(...)local ab=da("images")local bb=da("bimg")
local cb,db,_c,ac=table.unpack,string.sub,math.max,math.min
return
function(bc,cc)local dc=cc.getObject("VisualObject")(bc,cc)
dc:setType("Image")local _d=bb()local ad=_d.getFrameObject(1)local bd;local cd;local dd=1;local __a=false;local a_a
local b_a=false;local c_a=true;local d_a,_aa=1,1;dc:addProperty("XOffset","number",0)
dc:addProperty("YOffset","number",0)dc:combineProperty("Offset","XOffset","YOffset")
dc:setSize(24,8)dc:setZ(2)
local function aaa()local daa={}
for bba,cba in pairs(colors)do if(type(cba)=="number")then
daa[math.log(cba,2)]={term.nativePaletteColor(cba)}end end;local _ba=_d.getMetadata("palette")if(_ba~=nil)then
for bba,cba in pairs(_ba)do daa[bba]=cba end end
local aba=ad.getFrameData("palette")
if(aba~=nil)then for bba,cba in pairs(aba)do daa[bba]=cba end end;return daa end;local function baa()
if(c_a)then if(_d~=nil)then dc:setSize(_d.getSize())end end end
local caa={setSize=function(daa,_ba,aba)dc:setSize(_ba,aba)
c_a=false;return daa end,selectFrame=function(daa,_ba)if
(_d.getFrameObject(_ba)==nil)then _d.addFrame(_ba)end
ad=_d.getFrameObject(_ba)cd=ad.getImage(_ba)dd=_ba;daa:updateDraw()end,addFrame=function(daa,_ba)
_d.addFrame(_ba)return daa end,getFrame=function(daa,_ba)return _d.getFrame(_ba)end,getFrameObject=function(daa,_ba)return
_d.getFrameObject(_ba)end,removeFrame=function(daa,_ba)_d.removeFrame(_ba)return daa end,moveFrame=function(daa,_ba,aba)
_d.moveFrame(_ba,aba)return daa end,getFrames=function(daa)return _d.getFrames()end,getFrameCount=function(daa)return
#_d.getFrames()end,getActiveFrame=function(daa)return dd end,loadImage=function(daa,_ba)if
(fs.exists(_ba))then local aba=ab.loadBIMG(_ba)_d=bb(aba)dd=1
ad=_d.getFrameObject(1)bd=_d.createBimg()cd=ad.getImage()baa()
daa:updateDraw()end
return daa end,setPath=function(daa,_ba)return
daa:loadImage(_ba)end,setImage=function(daa,_ba)if(type(_ba)=="table")then _d=bb(_ba)dd=1
ad=_d.getFrameObject(1)bd=_d.createBimg()cd=ad.getImage()baa()
daa:updateDraw()end;return daa end,clear=function(daa)
_d=bb()ad=_d.getFrameObject(1)cd=nil;daa:updateDraw()return daa end,getImage=function(daa)return
_d.createBimg()end,getImageFrame=function(daa,_ba)return ad.getImage(_ba)end,usePalette=function(daa,_ba)b_a=
_ba~=nil and _ba or true;return daa end,getUsePalette=function(daa)return
b_a end,setUsePalette=function(daa,_ba)return daa:usePalette(_ba)end,play=function(daa,_ba)
if
(_d.getMetadata("animated"))then
local aba=
_d.getMetadata("duration")or _d.getMetadata("secondsPerFrame")or 0.2;daa:listenEvent("other_event")
a_a=os.startTimer(aba)__a=_ba or false end;return daa end,setPlay=function(daa,_ba)return
daa:play(_ba)end,stop=function(daa)os.cancelTimer(a_a)a_a=nil;__a=false
return daa end,eventHandler=function(daa,_ba,aba,...)
dc.eventHandler(daa,_ba,aba,...)
if(_ba=="timer")then
if(aba==a_a)then
if(_d.getFrame(dd+1)~=nil)then dd=dd+1
daa:selectFrame(dd)
local bba=
_d.getFrameData(dd,"duration")or _d.getMetadata("secondsPerFrame")or 0.2;a_a=os.startTimer(bba)else
if(__a)then dd=1;daa:selectFrame(dd)
local bba=
_d.getFrameData(dd,"duration")or _d.getMetadata("secondsPerFrame")or 0.2;a_a=os.startTimer(bba)end end;daa:updateDraw()end end end,setMetadata=function(daa,_ba,aba)
_d.setMetadata(_ba,aba)return daa end,getMetadata=function(daa,_ba)return _d.getMetadata(_ba)end,getFrameMetadata=function(daa,_ba,aba)return
_d.getFrameData(_ba,aba)end,setFrameMetadata=function(daa,_ba,aba,bba)
_d.setFrameData(_ba,aba,bba)return daa end,blit=function(daa,_ba,aba,bba,cba,dba)d_a=cba or d_a;_aa=dba or _aa
ad.blit(_ba,aba,bba,d_a,_aa)cd=ad.getImage()daa:updateDraw()return daa end,setText=function(daa,_ba,aba,bba)d_a=
aba or d_a;_aa=bba or _aa;ad.text(_ba,d_a,_aa)
cd=ad.getImage()daa:updateDraw()return daa end,setBg=function(daa,_ba,aba,bba)d_a=
aba or d_a;_aa=bba or _aa;ad.bg(_ba,d_a,_aa)
cd=ad.getImage()daa:updateDraw()return daa end,setFg=function(daa,_ba,aba,bba)d_a=
aba or d_a;_aa=bba or _aa;ad.fg(_ba,d_a,_aa)
cd=ad.getImage()daa:updateDraw()return daa end,getImageSize=function(daa)return
_d.getSize()end,setImageSize=function(daa,_ba,aba)_d.setSize(_ba,aba)
cd=ad.getImage()daa:updateDraw()return daa end,resizeImage=function(daa,_ba,aba)
local bba=ab.resizeBIMG(bd,_ba,aba)_d=bb(bba)dd=1;ad=_d.getFrameObject(1)cd=ad.getImage()
daa:updateDraw()return daa end,draw=function(daa)
dc.draw(daa)
daa:addDraw("image",function()local _ba,aba=daa:getSize()local bba,cba=daa:getPosition()
local dba,_ca=daa:getParent():getSize()local aca,bca=daa:getParent():getOffset()
if
(bba-aca>dba)or(cba-bca>_ca)or(bba-aca+_ba<1)or(cba-
bca+aba<1)then return end
if(b_a)then daa:getParent():setPalette(aaa())end
if(cd~=nil)then local cca,dca=daa:getOffset()
for _da,ada in pairs(cd)do
if
(_da+dca<=aba)and(_da+dca>=1)then local bda,cda,dda=ada[1],ada[2],ada[3]local __b=_c(1 -cca,1)
local a_b=ac(_ba-cca,#bda)bda=db(bda,__b,a_b)cda=db(cda,__b,a_b)dda=db(dda,__b,a_b)daa:addBlit(_c(
1 +cca,1),_da+dca,bda,cda,dda)end end end end)end}caa.__index=caa;return setmetatable(caa,dc)end end
aa["objects"]["Timer"]=function(...)
return
function(ab,bb)
local cb=bb.getObject("Object")(ab,bb)cb:setType("Timer")
cb:addProperty("Timer","number",0,false,function(bc,cc)if(cc<0)then cc=0 end;return cc end)
cb:addProperty("Repeat","number",1,false,function(bc,cc)if(cc~=nil)then if(cc<0)then cc=0 end else cc=0 end
return cc end)cb:combineProperty("Time","Timer","Repeat")local db
local _c=false
local ac={start=function(bc)if(_c)then os.cancelTimer(db)end;local cc,dc=bc:getTime()
db=os.startTimer(cc)_c=true;bc:listenEvent("other_event")return bc end,isActive=function(bc)return
_c end,cancel=function(bc)if(db~=nil)then os.cancelTimer(db)end
_c=false;bc:removeEvent("other_event")return bc end,setStart=function(bc,cc)
if(
cc==true)then return bc:start()else return bc:cancel()end end,onCall=function(bc,cc)
bc:registerEvent("timed_event",cc)return bc end,eventHandler=function(bc,cc,dc,...)
cb.eventHandler(bc,cc,dc,...)
if cc=="timer"and dc==db and _c then
bc:sendEvent("timed_event")local _d=bc:getTimer()local ad=bc:getRepeat()
if(ad>=1)then ad=ad-1;if(ad>=1)then
db=os.startTimer(_d)end elseif(ad==-1)then db=os.startTimer(_d)end end end}ac.__index=ac;return setmetatable(ac,cb)end end
aa["objects"]["Object"]=function(...)local ab=da("basaltEvent")
local bb=da("utils")local cb=bb.splitString;local db=bb.uuid;local _c,ac=table.unpack,string.sub
return
function(bc,cc)
bc=bc or db()
assert(cc~=nil,"Unable to find basalt instance! ID: "..bc)local dc=false;local _d=ab()local ad={}local bd={}local cd={}local dd={}
local function __a(c_a)
return
function(d_a,_aa)local aaa=false;if
(type(c_a)=="string")then local baa=cb(c_a,"|")
for caa,daa in pairs(baa)do if(type(_aa)==daa)then aaa=true end end end
if
(type(c_a)=="table")then for baa,caa in pairs(c_a)do if(caa==_aa)then aaa=true end end end
if(c_a=="color")then
if(type(_aa)=="string")then if(colors[_aa]~=nil)then aaa=true
_aa=colors[_aa]end else
for baa,caa in pairs(colors)do if(caa==_aa)then aaa=true end end end end;if(c_a=="char")then
if(type(_aa)=="string")then if(#_aa==1)then aaa=true end end end
if(c_a=="any")or(_aa==nil)or(
type(_aa)=="function")then aaa=true end
if(not aaa)then local baa=type(_aa)if(type(c_a)=="table")then
c_a=table.concat(c_a,", ")baa=_aa end
error(d_a:getType()..
": Invalid type for property "..bc..
"! Expected "..c_a..", got "..baa)end;return _aa end end;local a_a;local b_a
b_a={init=function(c_a)if(dc)then return false end;dc=true;return true end,isType=function(c_a,d_a)for _aa,aaa in
pairs(cd["Type"])do if(aaa==d_a)then return true end end
return false end,getTypes=function(c_a)return cd["Type"]end,load=function(c_a)
end,getName=function(c_a)return bc end,getProperty=function(c_a,d_a)
local _aa=cd[d_a:gsub("^%l",string.upper)]if(type(_aa)=="function")then return _aa()end;return _aa end,getProperties=function(c_a)
local d_a={}for _aa,aaa in pairs(cd)do
if(type(aaa)=="function")then d_a[_aa]=aaa()else d_a[_aa]=aaa end end;return d_a end,setProperty=function(c_a,d_a,_aa,aaa)
d_a=d_a:gsub("^%l",string.upper)if(aaa~=nil)then _aa=aaa(c_a,_aa)end;cd[d_a]=_aa;if
(c_a.updateDraw~=nil)then c_a:updateDraw()end;return c_a end,getPropertyConfig=function(c_a,d_a)return
dd[d_a]end,addProperty=function(c_a,d_a,_aa,aaa,baa,caa,daa,_ba)d_a=d_a:gsub("^%l",string.upper)
dd[d_a]={type=_aa,defaultValue=aaa,readonly=baa}if(cd[d_a]~=nil)then
error("Property "..d_a..
" in "..c_a:getType().." already exists!")end
c_a:setProperty(d_a,aaa)
b_a["get"..d_a]=function(aba,...)
if(aba~=nil)then local bba=aba:getProperty(d_a)if(daa~=nil)then return
daa(aba,bba,...)end;return bba end end
if(not baa)then
b_a["set"..d_a]=function(aba,bba,...)
if(aba~=nil)then if(caa~=nil)then local cba=caa(aba,bba,...)if(cba~=nil)then
bba=cba end end
aba:setProperty(d_a,bba,_ba~=nil and
_ba(_aa)or __a(_aa))end;return aba end end;return c_a end,combineProperty=function(c_a,d_a,...)
d_a=d_a:gsub("^%l",string.upper)local _aa={...}
b_a["get"..d_a]=function(aaa)local baa={}
for caa,daa in pairs(_aa)do
daa=daa:gsub("^%l",string.upper)baa[#baa+1]=aaa["get"..daa](aaa)end;return _c(baa)end
b_a["set"..d_a]=function(aaa,...)local baa={...}
for caa,daa in pairs(_aa)do if(aaa["set"..daa]~=nil)then
aaa["set"..daa](aaa,baa[caa])end end;return aaa end;return c_a end,setParent=function(c_a,d_a,_aa)if
(_aa)then a_a=d_a;return c_a end
if
(d_a.getType~=nil and d_a:isType("Container"))then c_a:remove()d_a:addChild(c_a)a_a=d_a end;return c_a end,getParent=function(c_a)return
a_a end,updateEvents=function(c_a)for d_a,_aa in pairs(bd)do a_a:removeEvent(d_a,c_a)if(_aa)then
a_a:addEvent(d_a,c_a)end end;return c_a end,listenEvent=function(c_a,d_a,_aa)if(
a_a~=nil)then
if(_aa)or(_aa==nil)then bd[d_a]=true;a_a:addEvent(d_a,c_a)elseif(_aa==
false)then bd[d_a]=false;a_a:removeEvent(d_a,c_a)end end
return c_a end,enable=function(c_a)
c_a:setProperty("Enabled",true)return c_a end,disable=function(c_a)
c_a:setProperty("Enabled",false)return c_a end,isEnabled=function(c_a)
return c_a:getProperty("Enabled")end,remove=function(c_a)
if(a_a~=nil)then a_a:removeChild(c_a)end;c_a:updateDraw()return c_a end,getBaseFrame=function(c_a)if(a_a~=
nil)then return a_a:getBaseFrame()end;return c_a end,onEvent=function(c_a,...)
for d_a,_aa in
pairs(table.pack(...))do if(type(_aa)=="function")then
c_a:registerEvent("other_event",_aa)end end;return c_a end,getEventSystem=function(c_a)return
_d end,getRegisteredEvents=function(c_a)return ad end,registerEvent=function(c_a,d_a,_aa)
if(a_a~=nil)then
a_a:addEvent(d_a,c_a)if(d_a=="mouse_drag")then a_a:addEvent("mouse_click",c_a)
a_a:addEvent("mouse_up",c_a)end end;_d:registerEvent(d_a,_aa)
if(ad[d_a]==nil)then ad[d_a]={}end;table.insert(ad[d_a],_aa)end,removeEvent=function(c_a,d_a,_aa)if(
_d:getEventCount(d_a)<1)then
if(a_a~=nil)then a_a:removeEvent(d_a,c_a)end end;_d:removeEvent(d_a,_aa)if(
ad[d_a]~=nil)then table.remove(ad[d_a],_aa)if(#ad[d_a]==0)then
ad[d_a]=nil end end end,eventHandler=function(c_a,d_a,...)
local _aa=c_a:sendEvent("other_event",d_a,...)if(_aa~=nil)then return _aa end end,customEventHandler=function(c_a,d_a,...)
local _aa=c_a:sendEvent("custom_event",d_a,...)if(_aa~=nil)then return _aa end;return true end,sendEvent=function(c_a,d_a,...)if(
d_a=="other_event")or(d_a=="custom_event")then return
_d:sendEvent(d_a,c_a,...)end;return
_d:sendEvent(d_a,c_a,d_a,...)end,onClick=function(c_a,...)
for d_a,_aa in
pairs(table.pack(...))do if(type(_aa)=="function")then
c_a:registerEvent("mouse_click",_aa)end end;return c_a end,onClickUp=function(c_a,...)for d_a,_aa in
pairs(table.pack(...))do
if(type(_aa)=="function")then c_a:registerEvent("mouse_up",_aa)end end;return c_a end,onRelease=function(c_a,...)
for d_a,_aa in
pairs(table.pack(...))do if(type(_aa)=="function")then
c_a:registerEvent("mouse_release",_aa)end end;return c_a end,onScroll=function(c_a,...)
for d_a,_aa in
pairs(table.pack(...))do if(type(_aa)=="function")then
c_a:registerEvent("mouse_scroll",_aa)end end;return c_a end,onHover=function(c_a,...)
for d_a,_aa in
pairs(table.pack(...))do if(type(_aa)=="function")then
c_a:registerEvent("mouse_hover",_aa)end end;return c_a end,onLeave=function(c_a,...)
for d_a,_aa in
pairs(table.pack(...))do if(type(_aa)=="function")then
c_a:registerEvent("mouse_leave",_aa)end end;return c_a end,onDrag=function(c_a,...)
for d_a,_aa in
pairs(table.pack(...))do if(type(_aa)=="function")then
c_a:registerEvent("mouse_drag",_aa)end end;return c_a end,onKey=function(c_a,...)for d_a,_aa in
pairs(table.pack(...))do
if(type(_aa)=="function")then c_a:registerEvent("key",_aa)end end;return c_a end,onChar=function(c_a,...)for d_a,_aa in
pairs(table.pack(...))do
if(type(_aa)=="function")then c_a:registerEvent("char",_aa)end end;return c_a end,onKeyUp=function(c_a,...)for d_a,_aa in
pairs(table.pack(...))do
if(type(_aa)=="function")then c_a:registerEvent("key_up",_aa)end end;return c_a end}
b_a:addProperty("Z","number",1,false,function(c_a,d_a)if(a_a~=nil)then a_a:updateZIndex(c_a,d_a)
c_a:updateDraw()end;return d_a end)
b_a:addProperty("Type","string|table",{"Object"},false,function(c_a,d_a)if(type(d_a)=="string")then
table.insert(cd["Type"],1,d_a)return cd["Type"]end end,function(c_a,d_a,_aa)return cd["Type"][
_aa or 1]end)b_a:addProperty("Enabled","boolean",true)
b_a.__index=b_a;return b_a end end
aa["objects"]["Thread"]=function(...)
return
function(ab,bb)
local cb=bb.getObject("Object")(ab,bb)cb:setType("Thread")local db;local _c;local ac=false;local bc
local cc={start=function(dc,_d)if(_d==nil)then
error("Function provided to thread is nil")end;db=_d;_c=coroutine.create(db)
ac=true;bc=nil;local ad,bd=coroutine.resume(_c)bc=bd;if not(ad)then
if(bd~="Terminated")then error(
"Thread Error Occurred - "..bd)end end
dc:listenEvent("mouse_click")dc:listenEvent("mouse_up")
dc:listenEvent("mouse_scroll")dc:listenEvent("mouse_drag")dc:listenEvent("key")
dc:listenEvent("key_up")dc:listenEvent("char")
dc:listenEvent("other_event")return dc end,getStatus=function(dc,_d)if(
_c~=nil)then return coroutine.status(_c)end;return nil end,stop=function(dc,_d)
ac=false;dc:listenEvent("mouse_click",false)
dc:listenEvent("mouse_up",false)dc:listenEvent("mouse_scroll",false)
dc:listenEvent("mouse_drag",false)dc:listenEvent("key",false)
dc:listenEvent("key_up",false)dc:listenEvent("char",false)
dc:listenEvent("other_event",false)return dc end,mouseHandler=function(dc,...)
dc:eventHandler("mouse_click",...)end,mouseUpHandler=function(dc,...)dc:eventHandler("mouse_up",...)end,mouseScrollHandler=function(dc,...)
dc:eventHandler("mouse_scroll",...)end,mouseDragHandler=function(dc,...)
dc:eventHandler("mouse_drag",...)end,mouseMoveHandler=function(dc,...)
dc:eventHandler("mouse_move",...)end,keyHandler=function(dc,...)dc:eventHandler("key",...)end,keyUpHandler=function(dc,...)
dc:eventHandler("key_up",...)end,charHandler=function(dc,...)dc:eventHandler("char",...)end,eventHandler=function(dc,_d,...)
cb.eventHandler(dc,_d,...)
if(ac)then
if(coroutine.status(_c)=="suspended")then if(bc~=nil)then
if(_d~=bc)then return end;bc=nil end
local ad,bd=coroutine.resume(_c,_d,...)bc=bd;if not(ad)then if(bd~="Terminated")then
error("Thread Error Occurred - "..bd)end end else
dc:stop()end end end}cc.__index=cc;return setmetatable(cc,cb)end end
aa["objects"]["Program"]=function(...)local ab=da("tHex")local bb=da("process")
local cb=string.sub
return
function(db,_c)local ac=_c.getObject("VisualObject")(db,_c)
ac:setType("Program")local bc;ac:addProperty("Path","string",nil)
ac:addProperty("Enviroment","table",nil)
local function cc(b_a,c_a,d_a,_aa)local aaa,baa=1,1;local caa,daa=colors.black,colors.white;local _ba=false;local aba=false;local bba={}
local cba={}local dba={}local _ca={}local aca;local bca={}for i=0,15 do local _ab=2 ^i
_ca[_ab]={_c.getTerm().getPaletteColour(_ab)}end;local function cca()aca=(" "):rep(d_a)
for n=0,15 do
local _ab=2 ^n;local aab=ab[_ab]bca[_ab]=aab:rep(d_a)end end
local function dca()cca()local _ab=aca
local aab=bca[colors.white]local bab=bca[colors.black]
for n=1,_aa do
bba[n]=cb(bba[n]==nil and _ab or bba[n].._ab:sub(1,
d_a-bba[n]:len()),1,d_a)
dba[n]=cb(dba[n]==nil and aab or dba[n]..
aab:sub(1,d_a-dba[n]:len()),1,d_a)
cba[n]=cb(cba[n]==nil and bab or cba[n]..
bab:sub(1,d_a-cba[n]:len()),1,d_a)end;ac.updateDraw(ac)end;dca()local function _da()if
aaa>=1 and baa>=1 and aaa<=d_a and baa<=_aa then else end end
local function ada(_ab,aab,bab)if

baa<1 or baa>_aa or aaa<1 or aaa+#_ab-1 >d_a then return end
bba[baa]=cb(bba[baa],1,aaa-1).._ab..cb(bba[baa],
aaa+#_ab,d_a)dba[baa]=cb(dba[baa],1,aaa-1)..
aab..cb(dba[baa],aaa+#_ab,d_a)
cba[baa]=
cb(cba[baa],1,aaa-1)..bab..cb(cba[baa],aaa+#_ab,d_a)aaa=aaa+#_ab;if aba then _da()end;bc:updateDraw()end
local function bda(_ab,aab,bab)
if(bab~=nil)then local cab=bba[aab]if(cab~=nil)then
bba[aab]=cb(cab:sub(1,_ab-1)..bab..cab:sub(_ab+
(bab:len()),d_a),1,d_a)end end;bc:updateDraw()end
local function cda(_ab,aab,bab)
if(bab~=nil)then local cab=cba[aab]if(cab~=nil)then
cba[aab]=cb(cab:sub(1,_ab-1)..bab..cab:sub(_ab+
(bab:len()),d_a),1,d_a)end end;bc:updateDraw()end
local function dda(_ab,aab,bab)
if(bab~=nil)then local cab=dba[aab]if(cab~=nil)then
dba[aab]=cb(cab:sub(1,_ab-1)..bab..cab:sub(_ab+
(bab:len()),d_a),1,d_a)end end;bc:updateDraw()end
local __b=function(_ab)
if type(_ab)~="number"then
error("bad argument #1 (expected number, got "..type(_ab)..")",2)elseif ab[_ab]==nil then
error("Invalid color (got ".._ab..")",2)end;daa=_ab end
local a_b=function(_ab)
if type(_ab)~="number"then
error("bad argument #1 (expected number, got "..type(_ab)..")",2)elseif ab[_ab]==nil then
error("Invalid color (got ".._ab..")",2)end;caa=_ab end
local b_b=function(_ab,aab,bab,cab)if type(_ab)~="number"then
error("bad argument #1 (expected number, got "..type(_ab)..")",2)end
if ab[_ab]==nil then error("Invalid color (got "..
_ab..")",2)end;local dab
if
type(aab)=="number"and bab==nil and cab==nil then dab={colours.rgb8(aab)}_ca[_ab]=dab else if
type(aab)~="number"then
error("bad argument #2 (expected number, got "..type(aab)..")",2)end;if type(bab)~="number"then
error(
"bad argument #3 (expected number, got "..type(bab)..")",2)end;if type(cab)~="number"then
error(
"bad argument #4 (expected number, got "..type(cab)..")",2)end;dab=_ca[_ab]dab[1]=aab
dab[2]=bab;dab[3]=cab end end
local c_b=function(_ab)if type(_ab)~="number"then
error("bad argument #1 (expected number, got "..type(_ab)..")",2)end
if ab[_ab]==nil then error("Invalid color (got "..
_ab..")",2)end;local aab=_ca[_ab]return aab[1],aab[2],aab[3]end
local d_b={setCursorPos=function(_ab,aab)if type(_ab)~="number"then
error("bad argument #1 (expected number, got "..type(_ab)..")",2)end;if type(aab)~="number"then
error(
"bad argument #2 (expected number, got "..type(aab)..")",2)end;aaa=math.floor(_ab)
baa=math.floor(aab)if(aba)then _da()end end,getCursorPos=function()return
aaa,baa end,setCursorBlink=function(_ab)if type(_ab)~="boolean"then
error("bad argument #1 (expected boolean, got "..
type(_ab)..")",2)end;_ba=_ab end,getCursorBlink=function()return
_ba end,getPaletteColor=c_b,getPaletteColour=c_b,setBackgroundColor=a_b,setBackgroundColour=a_b,setTextColor=__b,setTextColour=__b,setPaletteColor=b_b,setPaletteColour=b_b,getBackgroundColor=function()return caa end,getBackgroundColour=function()return caa end,getSize=function()
return d_a,_aa end,getTextColor=function()return daa end,getTextColour=function()return daa end,basalt_resize=function(_ab,aab)d_a,_aa=_ab,aab;dca()end,basalt_reposition=function(_ab,aab)
b_a,c_a=_ab,aab end,basalt_setVisible=function(_ab)aba=_ab end,drawBackgroundBox=function(_ab,aab,bab,cab,dab)for n=1,cab do
cda(_ab,aab+ (n-1),ab[dab]:rep(bab))end end,drawForegroundBox=function(_ab,aab,bab,cab,dab)
for n=1,cab do dda(_ab,
aab+ (n-1),ab[dab]:rep(bab))end end,drawTextBox=function(_ab,aab,bab,cab,dab)for n=1,cab do
bda(_ab,aab+ (n-1),dab:rep(bab))end end,basalt_update=function()for n=1,_aa do
bc:addBlit(1,n,bba[n],dba[n],cba[n])end end,scroll=function(_ab)
assert(type(_ab)==
"number","bad argument #1 (expected number, got "..type(_ab)..")")
if _ab~=0 then
for newY=1,_aa do local aab=newY+_ab;if aab<1 or aab>_aa then bba[newY]=aca
dba[newY]=bca[daa]cba[newY]=bca[caa]else bba[newY]=bba[aab]cba[newY]=cba[aab]
dba[newY]=dba[aab]end end end;if(aba)then _da()end end,isColor=function()return
_c.getTerm().isColor()end,isColour=function()
return _c.getTerm().isColor()end,write=function(_ab)_ab=tostring(_ab)if(aba)then
ada(_ab,ab[daa]:rep(_ab:len()),ab[caa]:rep(_ab:len()))end end,clearLine=function()
if
(aba)then bda(1,baa,(" "):rep(d_a))
cda(1,baa,ab[caa]:rep(d_a))dda(1,baa,ab[daa]:rep(d_a))end;if(aba)then _da()end end,clear=function()
for n=1,_aa
do bda(1,n,(" "):rep(d_a))
cda(1,n,ab[caa]:rep(d_a))dda(1,n,ab[daa]:rep(d_a))end;if(aba)then _da()end end,blit=function(_ab,aab,bab)if
type(_ab)~="string"then
error("bad argument #1 (expected string, got "..type(_ab)..")",2)end;if type(aab)~="string"then
error(
"bad argument #2 (expected string, got "..type(aab)..")",2)end;if type(bab)~="string"then
error(
"bad argument #3 (expected string, got "..type(bab)..")",2)end
if
#aab~=#_ab or#bab~=#_ab then error("Arguments must be the same length",2)end;if(aba)then ada(_ab,aab,bab)end end}return d_b end;ac:setZ(5)ac:setSize(30,12)local dc=cc(1,1,30,12)local _d;local ad=false
local bd={}
local function cd(b_a)local c_a=b_a:getParent()local d_a,_aa=dc.getCursorPos()
local aaa,baa=b_a:getPosition()local caa,daa=b_a:getSize()
if(aaa+d_a-1 >=1 and
aaa+d_a-1 <=aaa+caa-1 and _aa+baa-1 >=1 and
_aa+baa-1 <=baa+daa-1)then
c_a:setCursor(
b_a:isFocused()and dc.getCursorBlink(),aaa+d_a-1,_aa+baa-1,dc.getTextColor())end end
local function dd(b_a,c_a,...)local d_a,_aa=_d:resume(c_a,...)
if(d_a==false)and(_aa~=nil)and
(_aa~="Terminated")then
local aaa=b_a:sendEvent("program_error",_aa)
if(aaa~=false)then error("Basalt Program - ".._aa)end end
if(_d:getStatus()=="dead")then b_a:sendEvent("program_done")end end
local function __a(b_a,c_a,d_a,_aa,aaa)if(_d==nil)then return false end;if not(_d:isDead())then
if not(ad)then
local baa,caa=b_a:getAbsolutePosition()dd(b_a,c_a,d_a,_aa-baa+1,aaa-caa+1)cd(b_a)end end end
local function a_a(b_a,c_a,d_a,_aa)if(_d==nil)then return false end
if not(_d:isDead())then if not(ad)then if(b_a.draw)then
dd(b_a,c_a,d_a,_aa)cd(b_a)end end end end
bc={show=function(b_a)ac.show(b_a)
dc.setBackgroundColor(b_a:getBackground())dc.setTextColor(b_a:getForeground())
dc.basalt_setVisible(true)return b_a end,hide=function(b_a)
ac.hide(b_a)dc.basalt_setVisible(false)return b_a end,setPosition=function(b_a,c_a,d_a,_aa)
ac.setPosition(b_a,c_a,d_a,_aa)dc.basalt_reposition(b_a:getPosition())return b_a end,getBasaltWindow=function()return
dc end,getBasaltProcess=function()return _d end,setSize=function(b_a,c_a,d_a,_aa)ac.setSize(b_a,c_a,d_a,_aa)
dc.basalt_resize(b_a:getWidth(),b_a:getHeight())return b_a end,getStatus=function(b_a)if(_d~=nil)then return
_d:getStatus()end;return"inactive"end,execute=function(b_a,c_a,...)
local d_a=b_a:getPath()local _aa=b_a:getEnviroment()d_a=c_a or d_a;if(c_a~=nil)then
b_a:setPath(c_a)end;_d=bb:new(d_a,dc,_aa,...)
dc.setBackgroundColor(colors.black)dc.setTextColor(colors.white)dc.clear()
dc.setCursorPos(1,1)dc.setBackgroundColor(b_a:getBackground())
dc.setTextColor(
b_a:getForeground()or colors.white)dc.basalt_setVisible(true)dd(b_a)ad=false
b_a:listenEvent("mouse_click",b_a)b_a:listenEvent("mouse_up",b_a)
b_a:listenEvent("mouse_drag",b_a)b_a:listenEvent("mouse_scroll",b_a)
b_a:listenEvent("key",b_a)b_a:listenEvent("key_up",b_a)
b_a:listenEvent("char",b_a)b_a:listenEvent("other_event",b_a)return b_a end,setExecute=function(b_a,c_a,...)return
b_a:execute(c_a,...)end,stop=function(b_a)local c_a=b_a:getParent()
if(_d~=nil)then if not
(_d:isDead())then dd(b_a,"terminate")if(_d:isDead())then
c_a:setCursor(false)end end end;c_a:removeEvents(b_a)return b_a end,pause=function(b_a,c_a)ad=
c_a or(not ad)if(_d~=nil)then
if not(_d:isDead())then if not(ad)then
b_a:injectEvents(table.unpack(bd))bd={}end end end;return b_a end,isPaused=function(b_a)return
ad end,injectEvent=function(b_a,c_a,d_a,...)
if(_d~=nil)then if not(_d:isDead())then
if(ad==false)or(d_a)then
dd(b_a,c_a,...)else table.insert(bd,{event=c_a,args={...}})end end end;return b_a end,getQueuedEvents=function(b_a)return
bd end,updateQueuedEvents=function(b_a,c_a)bd=c_a or bd;return b_a end,injectEvents=function(b_a,...)if(_d~=nil)then
if not
(_d:isDead())then for c_a,d_a in pairs({...})do
dd(b_a,d_a.event,table.unpack(d_a.args))end end end;return b_a end,mouseHandler=function(b_a,c_a,d_a,_aa)
if
(ac.mouseHandler(b_a,c_a,d_a,_aa))then __a(b_a,"mouse_click",c_a,d_a,_aa)return true end;return false end,mouseUpHandler=function(b_a,c_a,d_a,_aa)
if
(ac.mouseUpHandler(b_a,c_a,d_a,_aa))then __a(b_a,"mouse_up",c_a,d_a,_aa)return true end;return false end,scrollHandler=function(b_a,c_a,d_a,_aa)
if
(ac.scrollHandler(b_a,c_a,d_a,_aa))then __a(b_a,"mouse_scroll",c_a,d_a,_aa)return true end;return false end,dragHandler=function(b_a,c_a,d_a,_aa)
if
(ac.dragHandler(b_a,c_a,d_a,_aa))then __a(b_a,"mouse_drag",c_a,d_a,_aa)return true end;return false end,keyHandler=function(b_a,c_a,d_a)if
(ac.keyHandler(b_a,c_a,d_a))then a_a(b_a,"key",c_a,d_a)return true end;return
false end,keyUpHandler=function(b_a,c_a)if
(ac.keyUpHandler(b_a,c_a))then a_a(b_a,"key_up",c_a)return true end
return false end,charHandler=function(b_a,c_a)if
(ac.charHandler(b_a,c_a))then a_a(b_a,"char",c_a)return true end
return false end,getFocusHandler=function(b_a)
ac.getFocusHandler(b_a)
if(_d~=nil)then
if not(_d:isDead())then
if not(ad)then local c_a=b_a:getParent()
if(c_a~=nil)then
local d_a,_aa=dc.getCursorPos()local aaa,baa=b_a:getPosition()local caa,daa=b_a:getSize()
if
(

aaa+d_a-1 >=1 and aaa+d_a-1 <=aaa+caa-1 and _aa+baa-1 >=1 and _aa+baa-1 <=baa+daa-1)then
c_a:setCursor(dc.getCursorBlink(),aaa+d_a-1,_aa+baa-1,dc.getTextColor())end end end end end end,loseFocusHandler=function(b_a)
ac.loseFocusHandler(b_a)
if(_d~=nil)then if not(_d:isDead())then local c_a=b_a:getParent()if(c_a~=nil)then
c_a:setCursor(false)end end end end,eventHandler=function(b_a,c_a,...)
ac.eventHandler(b_a,c_a,...)if _d==nil then return end
if not _d:isDead()then
if not ad then dd(b_a,c_a,...)
if
b_a:isFocused()then local d_a=b_a:getParent()local _aa,aaa=b_a:getPosition()
local baa,caa=dc.getCursorPos()local daa,_ba=b_a:getSize()
if _aa+baa-1 >=1 and
_aa+baa-1 <=_aa+daa-1 and caa+aaa-1 >=1 and
caa+aaa-1 <=aaa+_ba-1 then
d_a:setCursor(dc.getCursorBlink(),
_aa+baa-1,caa+aaa-1,dc.getTextColor())end end else table.insert(bd,{event=c_a,args={...}})end end end,resizeHandler=function(b_a,...)
ac.resizeHandler(b_a,...)
if(_d~=nil)then
if not(_d:isDead())then
if not(ad)then
dc.basalt_resize(b_a:getSize())dd(b_a,"term_resize",b_a:getSize())else
dc.basalt_resize(b_a:getSize())
table.insert(bd,{event="term_resize",args={b_a:getSize()}})end end end end,repositionHandler=function(b_a,...)
ac.repositionHandler(b_a,...)
if(_d~=nil)then if not(_d:isDead())then
dc.basalt_reposition(b_a:getPosition())end end end,draw=function(b_a)
ac.draw(b_a)
b_a:addDraw("program",function()dc.basalt_update()end)end,onError=function(b_a,...)for c_a,d_a in pairs(table.pack(...))do
if(
type(d_a)=="function")then b_a:registerEvent("program_error",d_a)end end
b_a:listenEvent("other_event")return b_a end,onDone=function(b_a,...)
for c_a,d_a in
pairs(table.pack(...))do if(type(d_a)=="function")then
b_a:registerEvent("program_done",d_a)end end;b_a:listenEvent("other_event")return b_a end}bc.__index=bc;return setmetatable(bc,ac)end end
aa["objects"]["Textfield"]=function(...)local ab=da("tHex")
local bb,cb,db,_c,ac=string.rep,string.find,string.gmatch,string.sub,string.len
return
function(bc,cc)
local dc=cc.getObject("ChangeableObject")(bc,cc)dc:setType("Textfield")local _d={""}local ad={""}local bd={""}local cd={}
local dd={}local __a,a_a,b_a,c_a
dc:addProperty("SelectionForeground","color",colors.black)
dc:addProperty("SelectionBackground","color",colors.lightBlue)
dc:combineProperty("SelectionColor","SelectionBackground","SelectionForeground")dc:addProperty("XOffset","number",1)
dc:addProperty("YOffset","number",1)dc:combineProperty("Offset","XOffset","YOffset")
dc:addProperty("TextXPosition","number",1)dc:addProperty("TextYPosition","number",1)
dc:combineProperty("TextPosition","TextXPosition","TextYPosition")dc:setSize(30,12)dc:setZ(5)local function d_a()
if(__a~=nil)and(a_a~=nil)and
(b_a~=nil)and(c_a~=nil)then return true end;return false end
local function _aa()
local cba,dba,_ca,aca=__a,a_a,b_a,c_a
if d_a()then
if __a<a_a and b_a<=c_a then cba=__a;dba=a_a
if b_a<c_a then _ca=b_a;aca=c_a else _ca=c_a;aca=b_a end elseif __a>a_a and b_a>=c_a then cba=a_a;dba=__a
if b_a>c_a then _ca=c_a;aca=b_a else _ca=b_a;aca=c_a end elseif b_a>c_a then cba=a_a;dba=__a;_ca=c_a;aca=b_a end;return cba,dba,_ca,aca end end
local function aaa(cba)local dba,_ca,aca,bca=_aa()local cca=_d[aca]local dca=_d[bca]_d[aca]=cca:sub(1,dba-1)..dca:sub(
_ca+1,dca:len())
ad[aca]=ad[aca]:sub(1,
dba-1)..ad[bca]:sub(_ca+1,ad[bca]:len())bd[aca]=bd[aca]:sub(1,dba-1)..
bd[bca]:sub(_ca+1,bd[bca]:len())for i=bca,aca+1,-1 do
if i~=aca then
table.remove(_d,i)table.remove(ad,i)table.remove(bd,i)end end
cba:setTextPosition(dba,aca)__a,a_a,b_a,c_a=nil,nil,nil,nil;return cba end
local function baa(cba)local dba,_ca,aca,bca=_aa()local cca={}
if d_a()then
if aca==bca then
table.insert(cca,_d[aca]:sub(dba,_ca))else
table.insert(cca,_d[aca]:sub(dba,_d[aca]:len()))for i=aca+1,bca-1 do table.insert(cca,_d[i])end
table.insert(cca,_d[bca]:sub(1,_ca))end end;return cca end
local function caa(cba,dba)local _ca={}
if(cba:len()>0)then
for aca in db(cba,dba)do local bca,cca=cb(cba,aca)
if
(bca~=nil)and(cca~=nil)then table.insert(_ca,bca)table.insert(_ca,cca)
local dca=_c(cba,1,(bca-1))local _da=_c(cba,cca+1,cba:len())cba=dca.. (":"):rep(aca:len())..
_da end end end;return _ca end
local function daa(cba,dba)local _ca="%f[%a]"..dba.."%f[%A]"local aca={}
local bca,cca=cba:find(_ca)while bca do table.insert(aca,bca)table.insert(aca,cca)bca,cca=cba:find(_ca,
cca+1)end
return aca end
local function _ba(cba,dba)dba=dba or cba:getTextYPosition()
local _ca=ab[cba:getForeground()]:rep(bd[dba]:len())
local aca=ab[cba:getBackground()]:rep(ad[dba]:len())
for bca,cca in pairs(dd)do local dca=caa(_d[dba],cca[1])
if(#dca>0)then
for x=1,#dca/2 do local _da=x*2 -1;if(
cca[2]~=nil)then
_ca=_ca:sub(1,dca[_da]-1)..ab[cca[2]]:rep(dca[_da+1]-
(dca[_da]-1))..
_ca:sub(dca[_da+1]+1,_ca:len())end;if
(cca[3]~=nil)then
aca=aca:sub(1,dca[_da]-1)..

ab[cca[3]]:rep(dca[_da+1]- (dca[_da]-1))..aca:sub(dca[_da+1]+1,aca:len())end end end end
for bca,cca in pairs(cd)do
for dca,_da in pairs(cca)do local ada=daa(_d[dba],_da)
if(#ada>0)then for x=1,#ada/2 do
local bda=x*2 -1
_ca=_ca:sub(1,ada[bda]-1)..

ab[bca]:rep(ada[bda+1]- (ada[bda]-1)).._ca:sub(ada[bda+1]+1,_ca:len())end end end end;bd[dba]=_ca;ad[dba]=aca;cba:updateDraw()end;local function aba(cba)for n=1,#_d do _ba(cba,n)end end
local bba={setBackground=function(cba,dba)
dc.setBackground(cba,dba)aba(cba)return cba end,setForeground=function(cba,dba)
dc.setForeground(cba,dba)aba(cba)return cba end,getLines=function(cba)return _d end,getLine=function(cba,dba)
return _d[dba]end,editLine=function(cba,dba,_ca)_d[dba]=_ca or _d[dba]_ba(cba,dba)
cba:updateDraw()return cba end,clear=function(cba)_d={""}ad={""}bd={""}__a,a_a,b_a,c_a=
nil,nil,nil,nil;cba:setTextPosition(1,1)
cba:setOffset(1,1)cba:updateDraw()return cba end,addLine=function(cba,dba,_ca)
if(
dba~=nil)then local aca=cba:getBackground()local bca=cba:getForeground()
if(#
_d==1)and(_d[1]=="")then _d[1]=dba
ad[1]=ab[aca]:rep(dba:len())bd[1]=ab[bca]:rep(dba:len())_ba(cba,1)return cba end
if(_ca~=nil)then table.insert(_d,_ca,dba)
table.insert(ad,_ca,ab[aca]:rep(dba:len()))
table.insert(bd,_ca,ab[bca]:rep(dba:len()))else table.insert(_d,dba)
table.insert(ad,ab[aca]:rep(dba:len()))
table.insert(bd,ab[bca]:rep(dba:len()))end end;_ba(cba,_ca or#_d)cba:updateDraw()return cba end,addKeywords=function(cba,dba,_ca)if(
cd[dba]==nil)then cd[dba]={}end;for aca,bca in pairs(_ca)do
table.insert(cd[dba],bca)end;cba:updateDraw()return cba end,addRule=function(cba,dba,_ca,aca)
table.insert(dd,{dba,_ca,aca})cba:updateDraw()return cba end,editRule=function(cba,dba,_ca,aca)for bca,cca in
pairs(dd)do
if(cca[1]==dba)then dd[bca][2]=_ca;dd[bca][3]=aca end end;cba:updateDraw()return cba end,removeRule=function(cba,dba)
for _ca,aca in
pairs(dd)do if(aca[1]==dba)then table.remove(dd,_ca)end end;cba:updateDraw()return cba end,setKeywords=function(cba,dba,_ca)
cd[dba]=_ca;cba:updateDraw()return cba end,removeLine=function(cba,dba)
if(#_d>1)then table.remove(_d,
dba or#_d)
table.remove(ad,dba or#ad)table.remove(bd,dba or#bd)else _d={""}ad={""}bd={""}end;cba:updateDraw()return cba end,getLineCount=function(cba)return
#_d end,getLineLength=function(cba,dba)return _d[dba]:len()end,getSelectedContent=baa,getFocusHandler=function(cba)
dc.getFocusHandler(cba)cc.setRenderingThrottle(50)local dba,_ca=cba:getPosition()
local aca,bca=cba:getOffset()local cca,dca=cba:getTextPosition()
cba:getParent():setCursor(true,
dba+cca-aca,_ca+dca-bca,cba:getForeground())end,loseFocusHandler=function(cba)
dc.loseFocusHandler(cba)cba:getParent():setCursor(false)end,keyHandler=function(cba,dba)
if
(dc.keyHandler(cba,dba))then local _ca=cba:getParent()local aca,bca=cba:getPosition()
local cca,dca=cba:getSize()local _da,ada=cba:getOffset()local bda,cda=cba:getTextPosition()
if(dba==
keys.backspace)then
if(d_a())then aaa(cba)else
if(_d[cda]=="")then
if(cda>1)then
table.remove(_d,cda)table.remove(bd,cda)table.remove(ad,cda)bda=
_d[cda-1]:len()+1;_da=bda-cca+1;if(_da<1)then _da=1 end;cda=cda-1 end elseif(bda<=1)then
if(cda>1)then bda=_d[cda-1]:len()+1
_da=bda-cca+1;if(_da<1)then _da=1 end;_d[cda-1]=_d[cda-1].._d[cda]bd[cda-1]=bd[
cda-1]..bd[cda]
ad[cda-1]=ad[cda-1]..ad[cda]table.remove(_d,cda)table.remove(bd,cda)
table.remove(ad,cda)cda=cda-1 end else _d[cda]=_d[cda]:sub(1,bda-2)..
_d[cda]:sub(bda,_d[cda]:len())
bd[cda]=bd[cda]:sub(1,
bda-2)..bd[cda]:sub(bda,bd[cda]:len())ad[cda]=ad[cda]:sub(1,bda-2)..
ad[cda]:sub(bda,ad[cda]:len())
if(bda>1)then bda=bda-1 end;if(_da>1)then if(bda<_da)then _da=_da-1 end end end;if(cda<ada)then ada=ada-1 end end;_ba(cba)cba:setValue("")elseif(dba==keys.delete)then
if(d_a())then aaa(cba)else
if(bda>
_d[cda]:len())then if(_d[cda+1]~=nil)then _d[cda]=_d[cda].._d[cda+1]table.remove(_d,
cda+1)table.remove(ad,cda+1)
table.remove(bd,cda+1)end else
_d[cda]=_d[cda]:sub(1,
bda-1).._d[cda]:sub(bda+1,_d[cda]:len())bd[cda]=bd[cda]:sub(1,bda-1)..
bd[cda]:sub(bda+1,bd[cda]:len())
ad[cda]=ad[cda]:sub(1,
bda-1)..ad[cda]:sub(bda+1,ad[cda]:len())end end;_ba(cba)elseif(dba==keys.enter)then if(d_a())then aaa(cba)end
table.insert(_d,cda+1,_d[cda]:sub(bda,_d[cda]:len()))
table.insert(bd,cda+1,bd[cda]:sub(bda,bd[cda]:len()))
table.insert(ad,cda+1,ad[cda]:sub(bda,ad[cda]:len()))_d[cda]=_d[cda]:sub(1,bda-1)
bd[cda]=bd[cda]:sub(1,bda-1)ad[cda]=ad[cda]:sub(1,bda-1)cda=cda+1;bda=1;_da=1;if
(cda-ada>=dca)then ada=ada+1 end;cba:setValue("")elseif(dba==keys.up)then __a,b_a,a_a,c_a=nil,nil,
nil,nil
if(cda>1)then cda=cda-1;if(bda>_d[cda]:len()+1)then bda=
_d[cda]:len()+1 end
if(_da>1)then if(bda<_da)then
_da=bda-cca+1;if(_da<1)then _da=1 end end end;if(ada>1)then if(cda<ada)then ada=ada-1 end end end elseif(dba==keys.down)then __a,b_a,a_a,c_a=nil,nil,nil,nil
if(cda<#_d)then cda=cda+1
if(bda>
_d[cda]:len()+1)then bda=_d[cda]:len()+1 end;if(_da>1)then
if(bda<_da)then _da=bda-cca+1;if(_da<1)then _da=1 end end end
if(cda>=ada+dca)then ada=ada+1 end end elseif(dba==keys.right)then __a,b_a,a_a,c_a=nil,nil,nil,nil;bda=bda+1
if(cda<#_d)then if(bda>
_d[cda]:len()+1)then bda=1;cda=cda+1 end elseif(bda>
_d[cda]:len())then bda=_d[cda]:len()+1 end;if(bda<1)then bda=1 end;if(bda<_da)or(bda>=cca+_da)then
_da=bda-cca+1 end;if(_da<1)then _da=1 end elseif(dba==keys.left)then
__a,b_a,a_a,c_a=nil,nil,nil,nil;bda=bda-1;if(bda>=1)then
if(bda<_da)or(bda>=cca+_da)then _da=bda end end
if(cda>1)then if(bda<1)then cda=cda-1
bda=_d[cda]:len()+1;_da=bda-cca+1 end end;if(bda<1)then bda=1 end;if(_da<1)then _da=1 end elseif(dba==keys.tab)then
if(bda%3 ==0)then _d[cda]=_d[cda]:sub(1,
bda-1)..
" ".._d[cda]:sub(bda,_d[cda]:len())
bd[cda]=bd[cda]:sub(1,
bda-1)..ab[cba:getForeground()]..
bd[cda]:sub(bda,bd[cda]:len())
ad[cda]=ad[cda]:sub(1,bda-1)..ab[cba:getBackground()]..
ad[cda]:sub(bda,ad[cda]:len())bda=bda+1 end
while bda%3 ~=0 do
_d[cda]=_d[cda]:sub(1,bda-1).." "..
_d[cda]:sub(bda,_d[cda]:len())
bd[cda]=bd[cda]:sub(1,bda-1)..ab[cba:getForeground()]..
bd[cda]:sub(bda,bd[cda]:len())
ad[cda]=ad[cda]:sub(1,bda-1)..ab[cba:getBackground()]..
ad[cda]:sub(bda,ad[cda]:len())bda=bda+1 end end
if not
( (aca+bda-_da>=aca and aca+bda-_da<aca+cca)and(bca+
cda-ada>=bca and bca+cda-ada<bca+dca))then _da=math.max(1,
_d[cda]:len()-cca+1)
ada=math.max(1,cda-dca+1)end;local dda=
(bda<=_d[cda]:len()and bda-1 or _d[cda]:len())- (_da-1)
if(dda>
cba:getX()+cca-1)then dda=cba:getX()+cca-1 end
local __b=(cda-ada<dca and cda-ada or cda-ada-1)if(dda<1)then dda=0 end
_ca:setCursor(true,aca+dda,bca+__b,cba:getForeground())cba:setOffset(_da,ada)cba:setTextPosition(bda,cda)
cba:updateDraw()return true end end,charHandler=function(cba,dba)
if
(dc.charHandler(cba,dba))then local _ca=cba:getParent()local aca,bca=cba:getPosition()
local cca,dca=cba:getSize()if(d_a())then aaa(cba)end;local _da,ada=cba:getOffset()
local bda,cda=cba:getTextPosition()
_d[cda]=_d[cda]:sub(1,bda-1)..dba..
_d[cda]:sub(bda,_d[cda]:len())
bd[cda]=bd[cda]:sub(1,bda-1)..ab[cba:getForeground()]..
bd[cda]:sub(bda,bd[cda]:len())
ad[cda]=ad[cda]:sub(1,bda-1)..ab[cba:getBackground()]..
ad[cda]:sub(bda,ad[cda]:len())bda=bda+1;if(bda>=cca+_da)then _da=_da+1 end;_ba(cba)
cba:setValue("")
if not
( (aca+bda-_da>=aca and aca+bda-_da<aca+cca)and(bca+
cda-ada>=bca and bca+cda-ada<bca+dca))then _da=math.max(1,
_d[cda]:len()-cca+1)
ada=math.max(1,cda-dca+1)end;local dda=
(bda<=_d[cda]:len()and bda-1 or _d[cda]:len())- (_da-1)
if(dda>
cba:getX()+cca-1)then dda=cba:getX()+cca-1 end
local __b=(cda-ada<dca and cda-ada or cda-ada-1)if(dda<1)then dda=0 end
_ca:setCursor(true,aca+dda,bca+__b,cba:getForeground())cba:setOffset(_da,ada)cba:setTextPosition(bda,cda)
cba:updateDraw()return true end end,dragHandler=function(cba,dba,_ca,aca)
if
(dc.dragHandler(cba,dba,_ca,aca))then local bca=cba:getParent()local cca,dca=cba:getAbsolutePosition()
local _da,ada=cba:getPosition()local bda,cda=cba:getSize()local dda,__b=cba:getOffset()
local a_b,b_b=cba:getTextPosition()
if(_d[aca-dca+__b]~=nil)then
if(_ca-cca+dda>0)and
(_ca-cca+dda<=bda)then a_b=_ca-cca+dda;b_b=aca-dca+__b;if a_b>
_d[b_b]:len()then a_b=_d[b_b]:len()+1 end
a_a=a_b;c_a=b_b;if a_b<dda then dda=a_b-1;if dda<1 then dda=1 end end
cba:setOffset(dda,__b)cba:setTextPosition(a_b,b_b)
bca:setCursor(not d_a(),_da+a_b-dda,
ada+b_b-__b,cba:getForeground())cba:updateDraw()end end;return true end end,scrollHandler=function(cba,dba,_ca,aca)
if
(dc.scrollHandler(cba,dba,_ca,aca))then local bca=cba:getParent()local cca,dca=cba:getAbsolutePosition()
local _da,ada=cba:getPosition()local bda,cda=cba:getSize()local dda,__b=cba:getOffset()
local a_b,b_b=cba:getTextPosition()__b=__b+dba
if(__b>#_d- (cda-1))then __b=#_d- (cda-1)end;if(__b<1)then __b=1 end;cba:setOffset(dda,__b)
if
(
cca+a_b-dda>=cca and cca+a_b-dda<cca+bda)and(ada+b_b-__b>=ada and
ada+b_b-__b<ada+cda)then
bca:setCursor(not d_a(),_da+a_b-dda,ada+b_b-__b,cba:getForeground())else bca:setCursor(false)end;cba:updateDraw()return true end end,mouseHandler=function(cba,dba,_ca,aca)
if
(dc.mouseHandler(cba,dba,_ca,aca))then local bca=cba:getParent()local cca,dca=cba:getAbsolutePosition()
local _da,ada=cba:getPosition()local bda,cda=cba:getOffset()local dda,__b=cba:getTextPosition()
if(_d[
aca-dca+cda]~=nil)then dda=_ca-cca+bda;__b=aca-dca+cda
a_a=nil;c_a=nil;__a=dda;b_a=__b;if(dda>_d[__b]:len())then
dda=_d[__b]:len()+1;__a=dda end
if(dda<bda)then bda=dda-1;if(bda<1)then bda=1 end end;cba:updateDraw()end;cba:setOffset(bda,cda)cba:setTextPosition(dda,__b)
bca:setCursor(true,
_da+dda-bda,ada+__b-cda,cba:getForeground())return true end end,mouseUpHandler=function(cba,dba,_ca,aca)
if
(dc.mouseUpHandler(cba,dba,_ca,aca))then local bca,cca=cba:getAbsolutePosition()local dca,_da=cba:getOffset()
if(_d[
aca-cca+_da]~=nil)then a_a=_ca-bca+dca
c_a=aca-cca+_da
if(a_a>_d[c_a]:len())then a_a=_d[c_a]:len()+1 end
if(__a==a_a)and(b_a==c_a)then __a,a_a,b_a,c_a=nil,nil,nil,nil end;cba:updateDraw()end;return true end end,eventHandler=function(cba,dba,_ca,...)
dc.eventHandler(cba,dba,_ca,...)
if(dba=="paste")then
if(cba:isFocused())then local aca=cba:getParent()
local bca,cca=cba:getForeground(),cba:getBackground()if(d_a())then aaa(cba)end;local dca,_da=cba:getOffset()
local ada,bda=cba:getTextPosition()local cda,dda=cba:getSize()
_d[bda]=_d[bda]:sub(1,ada-1).._ca..
_d[bda]:sub(ada,_d[bda]:len())
bd[bda]=bd[bda]:sub(1,ada-1)..ab[bca]:rep(_ca:len())..
bd[bda]:sub(ada,bd[bda]:len())
ad[bda]=ad[bda]:sub(1,ada-1)..ab[cca]:rep(_ca:len())..
ad[bda]:sub(ada,ad[bda]:len())ada=ada+_ca:len()
if(ada>=cda+dca)then dca=(ada+1)-cda end;local __b,a_b=cba:getPosition()
aca:setCursor(true,__b+ada-dca,a_b+bda-_da,bca)cba:setOffset(dca,_da)cba:setTextPosition(ada,bda)
_ba(cba)cba:updateDraw()end end end,draw=function(cba)
dc.draw(cba)
cba:addDraw("textfield",function()local dba,_ca=cba:getSize()local aca,bca=cba:getOffset()
local cca=cba:getSelectionBackground()local dca=cba:getSelectionForeground()
for n=1,_ca do local _da=""local ada=""local bda=""if _d[
n+bca-1]then _da=_d[n+bca-1]bda=bd[n+bca-1]
ada=ad[n+bca-1]end;_da=_c(_da,aca,dba+aca-1)ada=_c(ada,aca,
dba+aca-1)bda=_c(bda,aca,dba+aca-1)
cba:addText(1,n,_da)cba:addBg(1,n,ada)cba:addFg(1,n,bda)
cba:addBlit(1,n,_da,bda,ada)end
if __a and a_a and b_a and c_a then local _da,ada,bda,cda=_aa()
for n=bda,cda do local dda=#_d[n]
local __b=0
if n==bda and n==cda then __b=_da-1 - (aca-1)dda=
dda- (_da-1 - (aca-1))- (dda-ada+ (aca-1))elseif n==cda then dda=dda- (
dda-ada+ (aca-1))elseif n==bda then dda=dda- (_da-1)__b=
_da-1 - (aca-1)end;local a_b=math.min(dda,dba-__b)
cba:addBg(1 +__b,n,bb(ab[cca],a_b))cba:addFg(1 +__b,n,bb(ab[dca],a_b))end end end)end,load=function(cba)
cba:listenEvent("mouse_click")cba:listenEvent("mouse_up")
cba:listenEvent("mouse_scroll")cba:listenEvent("mouse_drag")
cba:listenEvent("key")cba:listenEvent("char")
cba:listenEvent("other_event")end}bba.__index=bba;return setmetatable(bba,dc)end end
aa["objects"]["Pane"]=function(...)
return
function(ab,bb)
local cb=bb.getObject("VisualObject")(ab,bb)cb:setType("Pane")cb:setSize(25,10)local db={}db.__index=db;return
setmetatable(db,cb)end end
aa["objects"]["Progressbar"]=function(...)
return
function(ab,bb)
local cb=bb.getObject("ChangeableObject")(ab,bb)cb:setType("ProgressBar")cb:setZ(5)
cb:setValue(false)cb:setSize(25,3)
cb:addProperty("Progress","number",0,false,function(_c,ac)local bc=_c:getProgress()
if
(ac>=0)and(ac<=100)and(bc~=ac)then _c:setValue(bc)if(bc==100)then
_c:progressDoneHandler()end;return ac end;return bc end)cb:addProperty("Direction","number",0)
cb:addProperty("ActiveBarSymbol","char","")
cb:addProperty("ActiveBarColor","color",colors.black)
cb:addProperty("ActiveBarSymbolColor","color",colors.white)
cb:combineProperty("ProgressBar","ActiveBarColor","ActiveBarSymbol","ActiveBarSymbolColor")cb:addProperty("BackgroundSymbol","char","")
local db={onProgressDone=function(_c,ac)
_c:registerEvent("progress_done",ac)return _c end,progressDoneHandler=function(_c)
_c:sendEvent("progress_done")end,draw=function(_c)cb.draw(_c)
_c:addDraw("progressbar",function()
local ac,bc=_c:getSize()local cc=_c:getProperties()local dc,_d,ad=_c:getProgressBar()if(cc.Background~=
nil)then
_c:addBackgroundBox(1,1,ac,bc,cc.Background)end;if(cc.BgSymbol~="")then
_c:addTextBox(1,1,ac,bc,cc.BgSymbol)end;if(cc.Foreground~=nil)then
_c:addForegroundBox(1,1,ac,bc,cc.Foreground)end
if(cc.Direction==1)then _c:addBackgroundBox(1,1,ac,bc/100 *
cc.Progress,dc)_c:addForegroundBox(1,1,ac,
bc/100 *cc.Progress,ad)_c:addTextBox(1,1,ac,
bc/100 *cc.Progress,_d)elseif
(cc.Direction==3)then
_c:addBackgroundBox(1,1 +math.ceil(bc-bc/100 *cc.Progress),ac,
bc/100 *cc.Progress,dc)
_c:addForegroundBox(1,1 +math.ceil(bc-bc/100 *cc.Progress),ac,
bc/100 *cc.Progress,ad)
_c:addTextBox(1,1 +math.ceil(bc-bc/100 *cc.Progress),ac,
bc/100 *cc.Progress,_d)elseif(cc.Direction==2)then
_c:addBackgroundBox(1 +
math.ceil(ac-ac/100 *cc.Progress),1,ac/100 *cc.Progress,bc,dc)
_c:addForegroundBox(1 +math.ceil(ac-ac/100 *cc.Progress),1,
ac/100 *cc.Progress,bc,ad)
_c:addTextBox(1 +math.ceil(ac-ac/100 *cc.Progress),1,
ac/100 *cc.Progress,bc,_d)else
_c:addBackgroundBox(1,1,math.ceil(ac/100 *cc.Progress),bc,dc)
_c:addForegroundBox(1,1,math.ceil(ac/100 *cc.Progress),bc,ad)
_c:addTextBox(1,1,math.ceil(ac/100 *cc.Progress),bc,_d)end end)end}db.__index=db;return setmetatable(db,cb)end end
aa["objects"]["Frame"]=function(...)local ab=da("utils")
local bb,cb,db,_c,ac=math.max,math.min,string.sub,string.rep,string.len
return
function(bc,cc)local dc=cc.getObject("Container")(bc,cc)
dc:setType("Frame")local _d;dc:setSize(30,10)dc:setZ(10)
dc:addProperty("XOffset","number",0)dc:addProperty("YOffset","number",0)
dc:combineProperty("Offset","XOffset","YOffset")
local ad={getBase=function(bd)return dc end,setParent=function(bd,cd,...)dc.setParent(bd,cd,...)_d=cd;return bd end,render=function(bd)
if(
dc.render~=nil)then
if(bd:isVisible())then dc.render(bd)local cd=bd:getChildren()for dd,__a in
ipairs(cd)do
if(__a.element.render~=nil)then __a.element:render()end end end end end,updateDraw=function(bd)if(
_d~=nil)then _d:updateDraw()end;return bd end,blit=function(bd,cd,dd,__a,a_a,b_a)
local c_a,d_a=bd:getPosition()local _aa,aaa=_d:getOffset()c_a=c_a-_aa;d_a=d_a-aaa
local baa,caa=bd:getSize()
if dd>=1 and dd<=caa then
local daa=db(__a,bb(1 -cd+1,1),bb(baa-cd+1,1))
local _ba=db(a_a,bb(1 -cd+1,1),bb(baa-cd+1,1))
local aba=db(b_a,bb(1 -cd+1,1),bb(baa-cd+1,1))
_d:blit(bb(cd+ (c_a-1),c_a),d_a+dd-1,daa,_ba,aba)end end,setCursor=function(bd,cd,dd,__a,a_a)
local b_a,c_a=bd:getPosition()local d_a,_aa=bd:getOffset()
_d:setCursor(cd or false,(dd or 0)+b_a-1 -d_a,(
__a or 0)+c_a-1 -_aa,a_a or colors.white)return bd end}
for bd,cd in
pairs({"drawBackgroundBox","drawForegroundBox","drawTextBox"})do
ad[cd]=function(dd,__a,a_a,b_a,c_a,d_a)local _aa,aaa=dd:getPosition()local baa,caa=_d:getOffset()
_aa=_aa-baa;aaa=aaa-caa
c_a=(a_a<1 and(
c_a+a_a>dd:getHeight()and dd:getHeight()or c_a+a_a-1)or(

c_a+a_a>dd:getHeight()and dd:getHeight()-a_a+1 or c_a))
b_a=(__a<1 and(b_a+__a>dd:getWidth()and dd:getWidth()or
b_a+__a-1)or
(b_a+__a>
dd:getWidth()and dd:getWidth()-__a+1 or b_a))
_d[cd](_d,bb(__a+ (_aa-1),_aa),bb(a_a+ (aaa-1),aaa),b_a,c_a,d_a)end end
for bd,cd in pairs({"setBg","setFg","setText"})do
ad[cd]=function(dd,__a,a_a,b_a)
local c_a,d_a=dd:getPosition()local _aa,aaa=_d:getOffset()c_a=c_a-_aa;d_a=d_a-aaa
local baa,caa=dd:getSize()if(a_a>=1)and(a_a<=caa)then
_d[cd](_d,bb(__a+ (c_a-1),c_a),d_a+a_a-1,db(b_a,bb(
1 -__a+1,1),bb(baa-__a+1,1)))end end end;ad.__index=ad;return setmetatable(ad,dc)end end
aa["objects"]["Label"]=function(...)local ab=da("utils")local bb=ab.wrapText
local cb=ab.writeWrappedText
return
function(db,_c)local ac=_c.getObject("VisualObject")(db,_c)
ac:setType("Label")ac:setZ(3)ac:setSize(5,1)
ac:addProperty("text","string","Label",nil,function(cc,dc)
local _d=cc:getAutoSize()
if(_d)then local ad=bb(dc,#dc)local bd,cd=1,0;for dd,__a in pairs(ad)do cd=cd+1
bd=math.max(bd,__a:len())end;if(cd==0)then cd=1 end
cc:setSize(bd,cd)cc:setAutoSize(true)end end)ac:addProperty("autoSize","boolean",true)
ac:addProperty("textAlign",{"left","center","right"},"left")
local bc={init=function(cc)ac.init(cc)local dc=cc:getParent()cc:setBackground(nil)
cc:setForeground(dc:getForeground())end,getBase=function(cc)return ac end,setSize=function(cc,dc,_d)
ac.setSize(cc,dc,_d)cc:setAutoSize(false)return cc end,draw=function(cc)
ac.draw(cc)
cc:addDraw("label",function()local dc,_d=cc:getSize()local ad=cc:getText()
local bd=cc:getTextAlign()
local cd=

bd=="center"and math.floor(dc/2 -ad:len()/2 +0.5)or bd=="right"and dc- (ad:len()-1)or 1;cb(cc,cd,1,ad,dc+1,_d)end)end}bc.__index=bc;return setmetatable(bc,ac)end end
aa["objects"]["List"]=function(...)local ab=da("utils")local bb=da("tHex")
return
function(cb,db)
local _c=db.getObject("ChangeableObject")(cb,db)_c:setType("List")local ac={}_c:setSize(16,8)_c:setZ(5)
_c:addProperty("SelectionBackground","color",colors.black)
_c:addProperty("SelectionForeground","color",colors.lightGray)
_c:combineProperty("SelectionColor","SelectionBackground","SelectionForeground")
_c:addProperty("selectionColorActive","boolean",true)
_c:addProperty("textAlign",{"left","center","right"},"left")_c:addProperty("scrollable","boolean",true)
_c:addProperty("offset","number",0)
local bc={init=function(cc)cc:listenEvent("mouse_click")
cc:listenEvent("mouse_drag")cc:listenEvent("mouse_scroll")return _c.init(cc)end,getBase=function(cc)return
_c end,addItem=function(cc,dc,_d,ad,...)
table.insert(ac,{text=dc,bgCol=_d or cc:getBackground(),fgCol=ad or
cc:getForeground(),args={...}})if(#ac<=1)then cc:setValue(ac[1],false)end
cc:updateDraw()return cc end,setOptions=function(cc,...)
ac={}
for dc,_d in pairs(...)do
if(type(_d)=="string")then
table.insert(ac,{text=_d,bgCol=cc:getBackground(),fgCol=cc:getForeground(),args={}})else
table.insert(ac,{text=_d[1],bgCol=_d[2]or cc:getBackground(),fgCol=_d[3]or cc:getForeground(),args=
_d[4]or{}})end end;cc:setValue(ac[1],false)cc:updateDraw()return cc end,removeItem=function(cc,dc)
if(
type(dc)=="number")then table.remove(ac,dc)elseif(type(dc)=="table")then
for _d,ad in pairs(ac)do if
(ad==dc)then table.remove(ac,_d)break end end end;cc:updateDraw()return cc end,getItem=function(cc,dc)return
ac[dc]end,getAll=function(cc)return ac end,getOptions=function(cc)return ac end,getItemIndex=function(cc)
local dc=cc:getValue()for _d,ad in pairs(ac)do if(ad==dc)then return _d end end end,clear=function(cc)
ac={}cc:setValue({},false)cc:updateDraw()return cc end,getItemCount=function(cc)return
#ac end,editItem=function(cc,dc,_d,ad,bd,...)table.remove(ac,dc)
table.insert(ac,dc,{text=_d,bgCol=ad or
cc:getBackground(),fgCol=bd or cc:getForeground(),args={...}})cc:updateDraw()return cc end,selectItem=function(cc,dc)cc:setValue(
ac[dc]or{},false)cc:updateDraw()return cc end,scrollHandler=function(cc,dc,_d,ad)
if
(_c.scrollHandler(cc,dc,_d,ad))then local bd=cc:getScrollable()
if(bd)then local cd=cc:getOffset()
local dd,__a=cc:getSize()cd=cd+dc;if(cd<0)then cd=0 end;if(dc>=1)then
if(#ac>__a)then
if(cd>#ac-__a)then cd=#ac-__a end;if(cd>=#ac)then cd=#ac-1 end else cd=cd-1 end end
cc:setOffset(cd)cc:updateDraw()end;return true end;return false end,mouseHandler=function(cc,dc,_d,ad)
if
(_c.mouseHandler(cc,dc,_d,ad))then local bd,cd=cc:getAbsolutePosition()local dd,__a=cc:getSize()
if(#ac>0)then
local a_a=cc:getOffset()for n=1,__a do
if(ac[n+a_a]~=nil)then if
(bd<=_d)and(bd+dd>_d)and(cd+n-1 ==ad)then cc:setValue(ac[n+a_a])cc:selectHandler()
cc:updateDraw()end end end end;return true end;return false end,dragHandler=function(cc,dc,_d,ad)return
cc:mouseHandler(dc,_d,ad)end,touchHandler=function(cc,dc,_d)
return cc:mouseHandler(1,dc,_d)end,onSelect=function(cc,...)for dc,_d in pairs(table.pack(...))do
if
(type(_d)=="function")then cc:registerEvent("select_item",_d)end end;return cc end,selectHandler=function(cc)
cc:sendEvent("select_item",cc:getValue())end,draw=function(cc)_c.draw(cc)
cc:addDraw("list",function()
local dc,_d=cc:getSize()local ad=cc:getOffset()local bd=cc:getSelectionColorActive()
local cd=cc:getSelectionBackground()local dd=cc:getSelectionForeground()local __a=cc:getValue()
for n=1,_d do
if
ac[n+ad]then local a_a=ac[n+ad].text
local b_a,c_a=ac[n+ad].fgCol,ac[n+ad].bgCol;if ac[n+ad]==__a and bd then b_a,c_a=dd,cd end
cc:addText(1,n,a_a:sub(1,dc))cc:addFg(1,n,bb[b_a]:rep(dc))
cc:addBg(1,n,bb[c_a]:rep(dc))end end end)end}bc.__index=bc;return setmetatable(bc,_c)end end
aa["objects"]["BaseFrame"]=function(...)local ab=da("basaltDraw")
local bb=da("utils")local cb,db,_c,ac=math.max,math.min,string.sub,string.rep
return
function(bc,cc)
local dc=cc.getObject("Container")(bc,cc)dc:setType("BaseFrame")local _d={}local ad=true;local bd=cc.getTerm()
local cd=ab(bd)local dd,__a,a_a,b_a=1,1,false,colors.white
dc:addProperty("XOffset","number",0)dc:addProperty("YOffset","number",0)
dc:combineProperty("Offset","XOffset","YOffset")
dc:addProperty("Term","table",nil,false,function(d_a,_aa)bd=_aa;cd=nil;if(_aa~=nil)then cd=ab(_aa)
dc:setSize(_aa.getSize())end end)dc:setSize(bd.getSize())
local c_a={getBase=function(d_a)return dc end,setPalette=function(d_a,_aa,...)
if(d_a==
cc.getActiveFrame())then
if(type(_aa)=="string")then _aa=colors[_aa]
_d[math.log(_aa,2)]=...bd.setPaletteColor(_aa,...)elseif(type(_aa)=="table")then
for aaa,baa in pairs(_aa)do
_d[aaa]=baa
if(type(baa)=="number")then bd.setPaletteColor(2 ^aaa,baa)else
local caa,daa,_ba=table.unpack(baa)bd.setPaletteColor(2 ^aaa,caa,daa,_ba)end end end end;return d_a end,setSize=function(d_a,...)
dc.setSize(d_a,...)cd=ab(bd)return d_a end,show=function(d_a)dc.show(d_a)
cc.setActiveFrame(d_a)
for _aa,aaa in pairs(colors)do if(type(aaa)=="number")then
bd.setPaletteColor(aaa,colors.packRGB(term.nativePaletteColor((aaa))))end end
for _aa,aaa in pairs(_d)do if(type(aaa)=="number")then
bd.setPaletteColor(_aa^2,aaa)else local baa,caa,daa=table.unpack(aaa)
bd.setPaletteColor(_aa^2,baa,caa,daa)end end;cc.setMainFrame(d_a)return d_a end,render=function(d_a)
if(
dc.render~=nil)then
if(d_a:isVisible())then
if(ad)then dc.render(d_a)
local _aa=d_a:getChildren()for aaa,baa in ipairs(_aa)do if(baa.element.render~=nil)then
baa.element:render()end end
ad=false end end end end,updateDraw=function(d_a)
ad=true;return d_a end,eventHandler=function(d_a,_aa,...)dc.eventHandler(d_a,_aa,...)if
(_aa=="term_resize")then d_a:setSize(bd.getSize())end end,updateTerm=function(d_a)if(
cd~=nil)then cd.update()end end,blit=function(d_a,_aa,aaa,baa,caa,daa)
local _ba,aba=d_a:getPosition()local bba,cba=d_a:getSize()
if aaa>=1 and aaa<=cba then local dba=_c(baa,cb(1 -_aa+1,1),cb(
bba-_aa+1,1))local _ca=_c(caa,cb(1 -_aa+1,1),cb(
bba-_aa+1,1))local aca=_c(daa,cb(1 -_aa+1,1),cb(
bba-_aa+1,1))
cd.blit(cb(_aa+
(_ba-1),_ba),aba+aaa-1,dba,_ca,aca)end end,setCursor=function(d_a,_aa,aaa,baa,caa)
local daa,_ba=d_a:getAbsolutePosition()local aba,bba=d_a:getOffset()a_a=_aa or false;if(aaa~=nil)then
dd=daa+aaa-1 -aba end
if(baa~=nil)then __a=_ba+baa-1 -bba end;b_a=caa or b_a
if(a_a)then bd.setTextColor(b_a)
bd.setCursorPos(dd,__a)bd.setCursorBlink(a_a)else bd.setCursorBlink(false)end;return d_a end}
for d_a,_aa in
pairs({mouse_click={"mouseHandler",true},mouse_up={"mouseUpHandler",false},mouse_drag={"dragHandler",false},mouse_scroll={"scrollHandler",true},mouse_hover={"hoverHandler",false}})do
c_a[_aa[1]]=function(aaa,baa,caa,daa,...)if(dc[_aa[1]](aaa,baa,caa,daa,...))then
cc.setActiveFrame(aaa)end end end
for d_a,_aa in
pairs({"drawBackgroundBox","drawForegroundBox","drawTextBox"})do
c_a[_aa]=function(aaa,baa,caa,daa,_ba,aba)local bba,cba=aaa:getPosition()local dba,_ca=aaa:getSize()if(_ba==nil)then
return end
_ba=(caa<1 and(
_ba+caa>aaa:getHeight()and aaa:getHeight()or _ba+caa-1)or(
_ba+
caa>aaa:getHeight()and aaa:getHeight()-caa+1 or _ba))
daa=(baa<1 and(daa+baa>aaa:getWidth()and aaa:getWidth()or daa+
baa-1)or(

daa+baa>aaa:getWidth()and aaa:getWidth()-baa+1 or daa))
cd[_aa](cb(baa+ (bba-1),bba),cb(caa+ (cba-1),cba),daa,_ba,aba)end end
for d_a,_aa in pairs({"setBg","setFg","setText"})do
c_a[_aa]=function(aaa,baa,caa,daa)
local _ba,aba=aaa:getPosition()local bba,cba=aaa:getSize()if(caa>=1)and(caa<=cba)then
cd[_aa](cb(baa+ (_ba-1),_ba),
aba+caa-1,_c(daa,cb(1 -baa+1,1),cb(bba-baa+1,1)))end end end;c_a.__index=c_a;return setmetatable(c_a,dc)end end
aa["objects"]["ChangeableObject"]=function(...)
return
function(ab,bb)
local cb=bb.getObject("VisualObject")(ab,bb)cb:setType("ChangeableObject")
cb:addProperty("ChangeHandler","function",nil)
cb:addProperty("Value","any",nil,false,function(_c,ac)local bc=_c:getValue()if(ac~=bc)then
local cc=_c:getChangeHandler()if(cc~=nil)then cc(_c,ac)end
_c:sendEvent("value_changed",ac)end;return ac end)
local db={onChange=function(_c,...)
for ac,bc in pairs(table.pack(...))do if(type(bc)=="function")then
_c:registerEvent("value_changed",bc)end end;return _c end}db.__index=db;return setmetatable(db,cb)end end
aa["objects"]["Container"]=function(...)local ab=da("utils")local bb=ab.tableCount
local cb=ab.rpairs
return
function(db,_c)local ac=_c.getObject("VisualObject")(db,_c)
ac:setType("Container")local bc={}local cc={}local dc={}local _d;local ad=true;local bd,cd=0,0
local dd=function(cba,dba)
if cba.zIndex==dba.zIndex then return cba.objId<
dba.objId else return cba.zIndex<dba.zIndex end end
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
local _ca=dba:getZ()
table.insert(bc,{element=dba,zIndex=_ca,objId=bd})ad=false;dba:setParent(cba,true)for aca,bca in
pairs(dba:getRegisteredEvents())do cba:addEvent(aca,dba)end;if(dba.init~=
nil)then dba:init()end
if(dba.load~=nil)then dba:load()end;if(dba.draw~=nil)then dba:draw()end;return dba end
local function _aa(cba,dba)
if(type(dba)=="string")then dba=b_a(dba:getName())end;if(dba==nil)then return end;for _ca,aca in ipairs(bc)do
if aca.element==dba then
table.remove(bc,_ca)cba:removeEvents(dba)ad=false;return true end end end
local function aaa(cba)local dba=cba:getParent()bc={}cc={}ad=false;bd=0;cd=0;_d=nil
dba:removeEvents(cba)cba:updateEvents()end
local function baa(cba,dba,_ca)bd=bd+1;cd=cd+1;for aca,bca in pairs(bc)do
if(bca.element==dba)then bca.zIndex=_ca;bca.objId=bd;break end end;for aca,bca in pairs(cc)do
for cca,dca in pairs(bca)do if
(dca.element==dba)then dca.zIndex=_ca;dca.evId=cd end end end;ad=false
cba:updateDraw()end
local function caa(cba,dba)local _ca=cba:getParent()
for aca,bca in pairs(cc)do for cca,dca in pairs(bca)do if(dca.element==dba)then
table.remove(cc[aca],cca)end end;if(
bb(cc[aca])<=0)then
if(_ca~=nil)then if(
cba:getEventSystem().getEventCount(aca)<=0)then _ca:removeEvent(aca,cba)
cba:updateEvents()end end end end;ad=false end
local function daa(cba,dba,_ca)if(type(_ca)=="table")then _ca=_ca:getName()end
if(cc[dba]~=
nil)then for aca,bca in pairs(cc[dba])do
if(bca.element:getName()==_ca)then return bca end end end end
local function _ba(cba,dba,_ca)
if(daa(cba,dba,_ca:getName())~=nil)then return end;local aca=_ca:getZ()cd=cd+1;if(cc[dba]==nil)then cc[dba]={}end
table.insert(cc[dba],{element=_ca,zIndex=aca,evId=cd})ad=false;cba:listenEvent(dba)return _ca end
local function aba(cba,dba,_ca)
if(cc[dba]~=nil)then for aca,bca in pairs(cc[dba])do if(bca.element==_ca)then
table.remove(cc[dba],aca)end end;if(
bb(cc[dba])<=0)then cba:listenEvent(dba,false)end end;ad=false end
local function bba(cba,dba)return dba~=nil and cc[dba]or cc end
dc={getBase=function(cba)return ac end,setSize=function(cba,...)ac.setSize(cba,...)
cba:customEventHandler("basalt_FrameResize")return cba end,setPosition=function(cba,...)
ac.setPosition(cba,...)cba:customEventHandler("basalt_FrameReposition")
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
_d end,getChildrenAt=function(cba,dba,_ca)local aca={}
for bca,cca in cb(bc)do
if(cca.element.getPosition~=nil)and(
cca.element.getSize~=nil)then
local dca,_da=cca.element:getPosition()local ada,bda=cca.element:getSize()
local cda=cca.element:getVisible()
if(cda)then if(dba>=dca and dba<=dca+ada-1 and _ca>=_da and _ca<=
_da+bda-1)then
table.insert(aca,cca.element)end end end end;return aca end,getChild=b_a,getChildren=a_a,getDeepChildren=c_a,addChild=d_a,removeChild=_aa,removeChildren=aaa,getEvents=bba,getEvent=daa,addEvent=_ba,removeEvent=aba,removeEvents=caa,updateZIndex=baa,listenEvent=function(cba,dba,_ca)
ac.listenEvent(cba,dba,_ca)if(cc[dba]==nil)then cc[dba]={}end;return cba end,customEventHandler=function(cba,...)
ac.customEventHandler(cba,...)
for dba,_ca in pairs(bc)do if(_ca.element.customEventHandler~=nil)then
_ca.element:customEventHandler(...)end end end,loseFocusHandler=function(cba)
ac.loseFocusHandler(cba)if(_d~=nil)then _d:loseFocusHandler()_d=nil end end,getBasalt=function(cba)return
_c end,setPalette=function(cba,dba,...)local _ca=cba:getParent()
_ca:setPalette(dba,...)return cba end,eventHandler=function(cba,...)
if(ac.eventHandler~=nil)then
ac.eventHandler(cba,...)
if(cc["other_event"]~=nil)then cba:sortChildren()
for dba,_ca in
ipairs(cc["other_event"])do if(_ca.element.eventHandler~=nil)then
_ca.element.eventHandler(_ca.element,...)end end end end end}
for cba,dba in
pairs({mouse_click={"mouseHandler",true},mouse_up={"mouseUpHandler",false},mouse_drag={"dragHandler",false},mouse_scroll={"scrollHandler",true},mouse_hover={"hoverHandler",false}})do
dc[dba[1]]=function(_ca,aca,bca,cca,...)
if(ac[dba[1]]~=nil)then
if(ac[dba[1]](_ca,aca,bca,cca,...))then
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
if(ac[dba]~=nil)then
if(ac[dba](_ca,...))then
if(cc[cba]~=nil)then
_ca:sortChildren()for aca,bca in ipairs(cc[cba])do
if(bca.element[dba]~=nil)then if
(bca.element[dba](bca.element,...))then return true end end end end end end end end;for cba,dba in pairs(_c.getObjects())do
dc["add"..cba]=function(_ca,aca)return
_ca:addChild(_c:createObject(cba,aca))end end
dc.__index=dc;return setmetatable(dc,ac)end end
aa["objects"]["Graph"]=function(...)
return
function(ab,bb)
local cb=bb.getObject("VisualObject")(ab,bb)cb:setType("Graph")cb:setZ(5)cb:setSize(30,10)
cb:addProperty("GraphColor","color",colors.gray)cb:addProperty("GraphSymbol","char","\7")
cb:addProperty("GraphSymbolColor","color",colors.black)cb:addProperty("MaxValue","number",100)
cb:addProperty("MinValue","number",0)
cb:addProperty("GraphType",{"bar","line","scatter"},"line")cb:addProperty("MaxEntries","number",10)local db={}
local _c={addDataPoint=function(ac,bc)
local cc=ac:getMinValue()local dc=ac:getMaxValue()if bc>=cc and bc<=dc then
table.insert(db,bc)ac:updateDraw()end;if(#db>100)then
table.remove(db,1)end;return ac end,clear=function(ac)
db={}ac:updateDraw()return ac end,draw=function(ac)cb.draw(ac)
ac:addDraw("graph",function()
local bc,cc=ac:getSize()local dc=ac:getGraphColor()local _d=ac:getGraphSymbol()
local ad=ac:getGraphSymbolColor()local bd=ac:getMaxValue()local cd=ac:getMinValue()
local dd=ac:getGraphType()local __a=ac:getMaxEntries()local a_a=bd-cd;local b_a,c_a;local d_a=#db-__a+1;if
d_a<1 then d_a=1 end
for i=d_a,#db do local _aa=db[i]local aaa=math.floor(
( (bc-1)/ (__a-1))* (i-d_a)+1.5)
local baa=math.floor(
(cc-1)- ( (cc-1)/a_a)* (_aa-cd)+1.5)
if dd=="scatter"then ac:addBackgroundBox(aaa,baa,1,1,dc)
ac:addForegroundBox(aaa,baa,1,1,ad)ac:addTextBox(aaa,baa,1,1,_d)elseif dd=="line"then
if b_a and c_a then
local caa=math.abs(aaa-b_a)local daa=math.abs(baa-c_a)local _ba=b_a<aaa and 1 or-1;local aba=c_a<
baa and 1 or-1;local bba=caa-daa
while true do
ac:addBackgroundBox(b_a,c_a,1,1,dc)ac:addForegroundBox(b_a,c_a,1,1,ad)
ac:addTextBox(b_a,c_a,1,1,_d)if b_a==aaa and c_a==baa then break end;local cba=2 *bba;if cba>-daa then
bba=bba-daa;b_a=b_a+_ba end
if cba<caa then bba=bba+caa;c_a=c_a+aba end end end;b_a,c_a=aaa,baa elseif dd=="bar"then
ac:addBackgroundBox(aaa-1,baa,1,cc-baa,dc)end end end)end}_c.__index=_c;return setmetatable(_c,cb)end end
aa["objects"]["Checkbox"]=function(...)local ab=da("utils")local bb=da("tHex")
return
function(cb,db)
local _c=db.getObject("ChangeableObject")(cb,db)_c:setType("Checkbox")_c:setZ(5)_c:setValue(false)
_c:setSize(1,1)_c:addProperty("activeSymbol","char","\42")
_c:addProperty("inactiveSymbol","char"," ")
_c:combineProperty("Symbol","activeSymbol","inactiveSymbol")_c:addProperty("text","string","")
_c:addProperty("textPosition",{"left","right"},"right")
local ac={load=function(bc)bc:listenEvent("mouse_click",bc)
bc:listenEvent("mouse_up",bc)end,setChecked=_c.setValue,getChecked=_c.getValue,mouseHandler=function(bc,cc,dc,_d)
if
(_c.mouseHandler(bc,cc,dc,_d))then
if(cc==1)then if
(bc:getValue()~=true)and(bc:getValue()~=false)then bc:setValue(false)else
bc:setValue(not bc:getValue())end
bc:updateDraw()return true end end;return false end,draw=function(bc)
_c.draw(bc)
bc:addDraw("checkbox",function()local cc,dc=bc:getSize()
local _d=ab.getTextVerticalAlign(dc,"center")local ad,bd=bc:getBackground(),bc:getForeground()
local cd=bc:getActiveSymbol()local dd=bc:getInactiveSymbol()local __a=bc:getText()
local a_a=bc:getTextPosition()
if(bc:getValue())then
bc:addBlit(1,_d,ab.getTextHorizontalAlign(cd,cc,"center"),bb[bd],bb[ad])else
bc:addBlit(1,_d,ab.getTextHorizontalAlign(dd,cc,"center"),bb[bd],bb[ad])end;if(__a~="")then
local b_a=a_a=="left"and-__a:len()or 3;bc:addText(b_a,_d,__a)end end)end}ac.__index=ac;return setmetatable(ac,_c)end end;return aa["main"]()