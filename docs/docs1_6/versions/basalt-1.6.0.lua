local project = {} 
local packaged = true 
local baseRequire = require 
local require = function(path)
    for _,v in pairs(project)do
        for name,b in pairs(v)do
            if(name==path)then
                return b()
            end
        end
    end
    return baseRequire(path);
end
local getProject = function(subDir)
    if(subDir~=nil)then
        return project[subDir]
    end
    return project
end
project['objects'] = {}project['libraries'] = {}project['default'] = {}project['objects']['Animation'] = function(...)local cc=require("utils").getValueFromXML
local dc=require("basaltEvent")local _d,ad,bd,cd=math.floor,math.sin,math.cos,math.pi;local dd=function(_ba,aba,bba)return
_ba+ (aba-_ba)*bba end
local __a=function(_ba)return _ba end;local a_a=function(_ba)return 1 -_ba end
local b_a=function(_ba)return _ba*_ba*_ba end
local c_a=function(_ba)return a_a(b_a(a_a(_ba)))end
local d_a=function(_ba)return dd(b_a(_ba),c_a(_ba),_ba)end;local _aa=function(_ba)return ad((_ba*cd)/2)end
local aaa=function(_ba)return a_a(bd((
_ba*cd)/2))end
local baa=function(_ba)return- (bd(cd*x)-1)/2 end
local caa={linear=__a,lerp=dd,flip=a_a,easeIn=b_a,easeOut=c_a,easeInOut=d_a,easeOutSine=_aa,easeInSine=aaa,easeInOutSine=baa}local daa={}
return
function(_ba)local aba={}local bba="Animation"local cba;local dba={}local _ca=0;local aca=false;local bca=1;local cca=false
local dca=dc()local _da=0;local ada;local bda=false;local cda=false;local dda="easeOut"local __b;local function a_b(_ab)for aab,bab in pairs(_ab)do
bab(aba,dba[bca].t,bca)end end
local function b_b(_ab)if(bca==1)then
_ab:animationStartHandler()end;if(dba[bca]~=nil)then a_b(dba[bca].f)
_ca=dba[bca].t end;bca=bca+1
if(dba[bca]==nil)then if(cca)then bca=1;_ca=0 else
_ab:animationDoneHandler()return end end;if(dba[bca].t>0)then
cba=os.startTimer(dba[bca].t-_ca)else b_b(_ab)end end
local function c_b(_ab,aab)for n=1,#dba do
if(dba[n].t==_ab)then table.insert(dba[n].f,aab)return end end
for n=1,#dba do
if(dba[n].t>_ab)then if
(dba[n-1]~=nil)then if(dba[n-1].t<_ab)then
table.insert(dba,n-1,{t=_ab,f={aab}})return end else
table.insert(dba,n,{t=_ab,f={aab}})return end end end
if(#dba<=0)then table.insert(dba,1,{t=_ab,f={aab}})return elseif(
dba[#dba].t<_ab)then table.insert(dba,{t=_ab,f={aab}})end end
local function d_b(_ab,aab,bab,cab,dab,_bb,abb,bbb)local cbb=__b;local dbb,_cb;local acb=""if(cbb.parent~=nil)then
acb=cbb.parent:getName()end;acb=acb..cbb:getName()
c_b(cab+0.05,function()
if
(abb~=nil)then if(daa[abb]==nil)then daa[abb]={}end;if(daa[abb][acb]~=nil)then
if(
daa[abb][acb]~=bbb)then daa[abb][acb]:cancel()end end;daa[abb][acb]=bbb end;dbb,_cb=dab(cbb)end)
for n=0.05,bab+0.01,0.05 do
c_b(cab+n,function()
local bcb=math.floor(caa.lerp(dbb,_ab,caa[dda](n/bab))+0.5)
local ccb=math.floor(caa.lerp(_cb,aab,caa[dda](n/bab))+0.5)_bb(cbb,bcb,ccb)
if(abb~=nil)then if(n>=bab-0.01)then if(daa[abb][acb]==bbb)then daa[abb][acb]=
nil end end end end)end end
aba={name=_ba,getType=function(_ab)return bba end,getBaseFrame=function(_ab)if(_ab.parent~=nil)then
return _ab.parent:getBaseFrame()end;return _ab end,setMode=function(_ab,aab)
dda=aab;return _ab end,generateXMLEventFunction=function(_ab,aab,bab)
local cab=function(dab)
if(dab:sub(1,1)=="#")then
local _bb=_ab:getBaseFrame():getDeepObject(dab:sub(2,dab:len()))
if(_bb~=nil)and(_bb.internalObjetCall~=nil)then aab(_ab,function()
_bb:internalObjetCall()end)end else
aab(_ab,_ab:getBaseFrame():getVariable(dab))end end;if(type(bab)=="string")then cab(bab)elseif(type(bab)=="table")then
for dab,_bb in pairs(bab)do cab(_bb)end end;return _ab end,setValuesByXMLData=function(_ab,aab)bda=
cc("loop",aab)==true and true or false
if(
cc("object",aab)~=nil)then
local bab=_ab:getBaseFrame():getDeepObject(cc("object",aab))if(bab==nil)then
bab=_ab:getBaseFrame():getVariable(cc("object",aab))end
if(bab~=nil)then _ab:setObject(bab)end end
if(aab["move"]~=nil)then local bab=cc("x",aab["move"])
local cab=cc("y",aab["move"])local dab=cc("duration",aab["move"])
local _bb=cc("time",aab["move"])_ab:move(bab,cab,dab,_bb)end
if(aab["size"]~=nil)then local bab=cc("width",aab["size"])
local cab=cc("height",aab["size"])local dab=cc("duration",aab["size"])
local _bb=cc("time",aab["size"])_ab:size(bab,cab,dab,_bb)end
if(aab["offset"]~=nil)then local bab=cc("x",aab["offset"])
local cab=cc("y",aab["offset"])local dab=cc("duration",aab["offset"])
local _bb=cc("time",aab["offset"])_ab:offset(bab,cab,dab,_bb)end
if(aab["textColor"]~=nil)then
local bab=cc("duration",aab["textColor"])local cab=cc("time",aab["textColor"])local dab={}
local _bb=aab["textColor"]["color"]
if(_bb~=nil)then if(_bb.properties~=nil)then _bb={_bb}end;for abb,bbb in pairs(_bb)do
table.insert(dab,colors[bbb:value()])end end;if(bab~=nil)and(#dab>0)then
_ab:changeTextColor(bab,cab or 0,table.unpack(dab))end end
if(aab["background"]~=nil)then
local bab=cc("duration",aab["background"])local cab=cc("time",aab["background"])local dab={}
local _bb=aab["background"]["color"]
if(_bb~=nil)then if(_bb.properties~=nil)then _bb={_bb}end;for abb,bbb in pairs(_bb)do
table.insert(dab,colors[bbb:value()])end end;if(bab~=nil)and(#dab>0)then
_ab:changeBackground(bab,cab or 0,table.unpack(dab))end end
if(aab["text"]~=nil)then local bab=cc("duration",aab["text"])
local cab=cc("time",aab["text"])local dab={}local _bb=aab["text"]["text"]
if(_bb~=nil)then if(_bb.properties~=nil)then
_bb={_bb}end;for abb,bbb in pairs(_bb)do
table.insert(dab,bbb:value())end end;if(bab~=nil)and(#dab>0)then
_ab:changeText(bab,cab or 0,table.unpack(dab))end end;if(cc("onDone",aab)~=nil)then
_ab:generateXMLEventFunction(_ab.onDone,cc("onDone",aab))end;if(cc("onStart",aab)~=nil)then
_ab:generateXMLEventFunction(_ab.onDone,cc("onStart",aab))end
if
(cc("autoDestroy",aab)~=nil)then if(cc("autoDestroy",aab))then cda=true end end;dda=cc("mode",aab)or dda
if(cc("play",aab)~=nil)then if
(cc("play",aab))then _ab:play(bda)end end;return _ab end,getZIndex=function(_ab)return
1 end,getName=function(_ab)return _ab.name end,setObject=function(_ab,aab)__b=aab;return _ab end,move=function(_ab,aab,bab,cab,dab,_bb)__b=
_bb or __b
d_b(aab,bab,cab,dab or 0,__b.getPosition,__b.setPosition,"position",_ab)return _ab end,offset=function(_ab,aab,bab,cab,dab,_bb)__b=
_bb or __b
d_b(aab,bab,cab,dab or 0,__b.getOffset,__b.setOffset,"offset",_ab)return _ab end,size=function(_ab,aab,bab,cab,dab,_bb)__b=_bb or
__b
d_b(aab,bab,cab,dab or 0,__b.getSize,__b.setSize,"size",_ab)return _ab end,changeText=function(_ab,aab,bab,...)
local cab={...}bab=bab or 0;__b=obj or __b;for n=1,#cab do
c_b(bab+n* (aab/#cab),function()
__b.setText(__b,cab[n])end)end;return _ab end,changeBackground=function(_ab,aab,bab,...)
local cab={...}bab=bab or 0;__b=obj or __b;for n=1,#cab do
c_b(bab+n* (aab/#cab),function()
__b.setBackground(__b,cab[n])end)end;return _ab end,changeTextColor=function(_ab,aab,bab,...)
local cab={...}bab=bab or 0;__b=obj or __b;for n=1,#cab do
c_b(bab+n* (aab/#cab),function()
__b.setForeground(__b,cab[n])end)end;return _ab end,add=function(_ab,aab,bab)
ada=aab
c_b((bab or _da)+
(dba[#dba]~=nil and dba[#dba].t or 0),aab)return _ab end,wait=function(_ab,aab)_da=aab;return _ab end,rep=function(_ab,aab)
if(
ada~=nil)then for n=1,aab or 1 do
c_b((wait or _da)+
(dba[#dba]~=nil and dba[#dba].t or 0),ada)end end;return _ab end,onDone=function(_ab,aab)
dca:registerEvent("animation_done",aab)return _ab end,onStart=function(_ab,aab)
dca:registerEvent("animation_start",aab)return _ab end,setAutoDestroy=function(_ab,aab)
cda=aab~=nil and aab or true;return _ab end,animationDoneHandler=function(_ab)
dca:sendEvent("animation_done",_ab)_ab.parent:removeEvent("other_event",_ab)if(cda)then
_ab.parent:removeObject(_ab)_ab=nil end end,animationStartHandler=function(_ab)
dca:sendEvent("animation_start",_ab)end,clear=function(_ab)dba={}ada=nil;_da=0;bca=1;_ca=0;cca=false;return _ab end,play=function(_ab,aab)
_ab:cancel()aca=true;cca=aab and true or false;bca=1;_ca=0
if(dba[bca]~=nil)then
if(
dba[bca].t>0)then cba=os.startTimer(dba[bca].t)else b_b(_ab)end else _ab:animationDoneHandler()end;_ab.parent:addEvent("other_event",_ab)return _ab end,cancel=function(_ab)if(
cba~=nil)then os.cancelTimer(cba)cca=false end
aca=false;_ab.parent:removeEvent("other_event",_ab)return _ab end,internalObjetCall=function(_ab)
_ab:play(bda)end,eventHandler=function(_ab,aab,bab)if(aca)then
if(aab=="timer")and(bab==cba)then if(dba[bca]~=nil)then
b_b(_ab)else _ab:animationDoneHandler()end end end end}aba.__index=aba;return aba end
end; 
project['objects']['Button'] = function(...)local _a=require("Object")local aa=require("utils")
local ba=aa.getValueFromXML;local ca=require("tHex")
return
function(da)local _b=_a(da)local ab="Button"local bb="center"
local cb="center"_b:setZIndex(5)_b:setValue("Button")_b.width=12
_b.height=3
local db={init=function(_c)_c.bgColor=_c.parent:getTheme("ButtonBG")
_c.fgColor=_c.parent:getTheme("ButtonText")end,getType=function(_c)return ab end,setHorizontalAlign=function(_c,ac)bb=ac
_c:updateDraw()return _c end,setVerticalAlign=function(_c,ac)cb=ac;_c:updateDraw()return _c end,setText=function(_c,ac)
_b:setValue(ac)_c:updateDraw()return _c end,setValuesByXMLData=function(_c,ac)
_b.setValuesByXMLData(_c,ac)
if(ba("text",ac)~=nil)then _c:setText(ba("text",ac))end;if(ba("horizontalAlign",ac)~=nil)then
bb=ba("horizontalAlign",ac)end;if(ba("verticalAlign",ac)~=nil)then
cb=ba("verticalAlign",ac)end;return _c end,draw=function(_c)
if
(_b.draw(_c))then
if(_c.parent~=nil)then local ac,bc=_c:getAnchorPosition()
local cc,dc=_c:getSize()local _d=aa.getTextVerticalAlign(dc,cb)
for n=1,dc do
if(n==_d)then
_c.parent:setText(ac,bc+ (n-1),aa.getTextHorizontalAlign(_c:getValue(),cc,bb))
_c.parent:setFG(ac,bc+ (n-1),aa.getTextHorizontalAlign(ca[_c.fgColor]:rep(_c:getValue():len()),cc,bb))end end end end end}return setmetatable(db,_b)end
end; 
project['objects']['Checkbox'] = function(...)local d=require("Object")local _a=require("utils")
local aa=_a.getValueFromXML
return
function(ba)local ca=d(ba)local da="Checkbox"ca:setZIndex(5)ca:setValue(false)
ca.width=1;ca.height=1;local _b="\42"
local ab={getType=function(bb)return da end,setSymbol=function(bb,cb)_b=cb;bb:updateDraw()return bb end,mouseHandler=function(bb,cb,db,_c)
if
(ca.mouseHandler(bb,cb,db,_c))then
if(cb==1)then if
(bb:getValue()~=true)and(bb:getValue()~=false)then bb:setValue(false)else
bb:setValue(not bb:getValue())end
bb:updateDraw()return true end end;return false end,touchHandler=function(bb,cb,db)return
bb:mouseHandler(1,cb,db)end,setValuesByXMLData=function(bb,cb)
ca.setValuesByXMLData(bb,cb)
if(aa("checked",cb)~=nil)then if(aa("checked",cb))then bb:setValue(true)else
bb:setValue(false)end end;return bb end,draw=function(bb)
if
(ca.draw(bb))then
if(bb.parent~=nil)then local cb,db=bb:getAnchorPosition()
local _c,ac=bb:getSize()local bc=_a.getTextVerticalAlign(ac,"center")if
(bb.bgColor~=false)then
bb.parent:drawBackgroundBox(cb,db,_c,ac,bb.bgColor)end
for n=1,ac do
if(n==bc)then
if(bb:getValue()==true)then
bb.parent:writeText(cb,
db+ (n-1),_a.getTextHorizontalAlign(_b,_c,"center"),bb.bgColor,bb.fgColor)else
bb.parent:writeText(cb,db+ (n-1),_a.getTextHorizontalAlign(" ",_c,"center"),bb.bgColor,bb.fgColor)end end end end end end,init=function(bb)
ca.init(bb)bb.bgColor=bb.parent:getTheme("CheckboxBG")
bb.fgColor=bb.parent:getTheme("CheckboxText")bb.parent:addEvent("mouse_click",bb)end}return setmetatable(ab,ca)end
end; 
project['objects']['Dropdown'] = function(...)local d=require("Object")local _a=require("utils")
local aa=require("utils").getValueFromXML
return
function(ba)local ca=d(ba)local da="Dropdown"ca.width=12;ca.height=1;ca:setZIndex(6)
local _b={}local ab;local bb;local cb=true;local db="left"local _c=0;local ac=16;local bc=6;local cc="\16"local dc="\31"local _d=false
local ad={getType=function(bd)
return da end,setValuesByXMLData=function(bd,cd)ca.setValuesByXMLData(bd,cd)
if
(aa("selectionBG",cd)~=nil)then ab=colors[aa("selectionBG",cd)]end;if(aa("selectionFG",cd)~=nil)then
bb=colors[aa("selectionFG",cd)]end;if(aa("dropdownWidth",cd)~=nil)then
ac=aa("dropdownWidth",cd)end;if(aa("dropdownHeight",cd)~=nil)then
bc=aa("dropdownHeight",cd)end;if(aa("offset",cd)~=nil)then
_c=aa("offset",cd)end
if(cd["item"]~=nil)then local dd=cd["item"]if
(dd.properties~=nil)then dd={dd}end;for __a,a_a in pairs(dd)do
bd:addItem(aa("text",a_a),colors[aa("bg",a_a)],colors[aa("fg",a_a)])end end end,setOffset=function(bd,cd)
_c=cd;bd:updateDraw()return bd end,getOffset=function(bd)return _c end,addItem=function(bd,cd,dd,__a,...)
table.insert(_b,{text=cd,bgCol=
dd or bd.bgColor,fgCol=__a or bd.fgColor,args={...}})bd:updateDraw()return bd end,getAll=function(bd)return
_b end,removeItem=function(bd,cd)table.remove(_b,cd)bd:updateDraw()return bd end,getItem=function(bd,cd)return
_b[cd]end,getItemIndex=function(bd)local cd=bd:getValue()for dd,__a in pairs(_b)do
if(__a==cd)then return dd end end end,clear=function(bd)
_b={}bd:setValue({})bd:updateDraw()return bd end,getItemCount=function(bd)return
#_b end,editItem=function(bd,cd,dd,__a,a_a,...)table.remove(_b,cd)
table.insert(_b,cd,{text=dd,bgCol=__a or bd.bgColor,fgCol=
a_a or bd.fgColor,args={...}})bd:updateDraw()return bd end,selectItem=function(bd,cd)bd:setValue(
_b[cd]or{})bd:updateDraw()return bd end,setSelectedItem=function(bd,cd,dd,__a)ab=
cd or bd.bgColor;bb=dd or bd.fgColor;cb=__a
bd:updateDraw()return bd end,setDropdownSize=function(bd,cd,dd)ac,bc=cd,dd
bd:updateDraw()return bd end,mouseHandler=function(bd,cd,dd,__a)
if(_d)then
local a_a,b_a=bd:getAbsolutePosition(bd:getAnchorPosition())
if(cd==1)then
if(#_b>0)then
for n=1,bc do
if(_b[n+_c]~=nil)then
if
(a_a<=dd)and(a_a+ac>dd)and(b_a+n==__a)then bd:setValue(_b[n+_c])bd:updateDraw()
local c_a=bd:getEventSystem():sendEvent("mouse_click",bd,"mouse_click",dir,dd,__a)if(c_a==false)then return c_a end;return true end end end end end end
if(ca.mouseHandler(bd,cd,dd,__a))then _d=(not _d)bd:updateDraw()return true else if(_d)then
bd:updateDraw()_d=false end;return false end end,mouseUpHandler=function(bd,cd,dd,__a)
if
(_d)then
local a_a,b_a=bd:getAbsolutePosition(bd:getAnchorPosition())
if(cd==1)then
if(#_b>0)then
for n=1,bc do
if(_b[n+_c]~=nil)then
if
(a_a<=dd)and(a_a+ac>dd)and(b_a+n==__a)then _d=false;bd:updateDraw()
local c_a=bd:getEventSystem():sendEvent("mouse_up",bd,"mouse_up",dir,dd,__a)if(c_a==false)then return c_a end;return true end end end end end end end,scrollHandler=function(bd,cd,dd,__a)
if
(_d)and(bd:isFocused())then _c=_c+cd;if(_c<0)then _c=0 end;if(cd==1)then
if(#_b>bc)then if
(_c>#_b-bc)then _c=#_b-bc end else _c=math.min(#_b-1,0)end end
local a_a=bd:getEventSystem():sendEvent("mouse_scroll",bd,"mouse_scroll",cd,dd,__a)if(a_a==false)then return a_a end;bd:updateDraw()return true end end,draw=function(bd)
if
(ca.draw(bd))then local cd,dd=bd:getAnchorPosition()local __a,a_a=bd:getSize()
if
(bd.parent~=nil)then if(bd.bgColor~=false)then
bd.parent:drawBackgroundBox(cd,dd,__a,a_a,bd.bgColor)end;local b_a=bd:getValue()
local c_a=_a.getTextHorizontalAlign((
b_a~=nil and b_a.text or""),__a,db):sub(1,
__a-1).. (_d and dc or cc)
bd.parent:writeText(cd,dd,c_a,bd.bgColor,bd.fgColor)
if(_d)then
for n=1,bc do
if(_b[n+_c]~=nil)then
if(_b[n+_c]==b_a)then
if(cb)then
bd.parent:writeText(cd,dd+n,_a.getTextHorizontalAlign(_b[n+
_c].text,ac,db),ab,bb)else
bd.parent:writeText(cd,dd+n,_a.getTextHorizontalAlign(_b[n+_c].text,ac,db),_b[n+
_c].bgCol,_b[n+_c].fgCol)end else
bd.parent:writeText(cd,dd+n,_a.getTextHorizontalAlign(_b[n+_c].text,ac,db),_b[n+
_c].bgCol,_b[n+_c].fgCol)end end end end end end end,init=function(bd)
bd.bgColor=bd.parent:getTheme("DropdownBG")bd.fgColor=bd.parent:getTheme("DropdownText")
ab=bd.parent:getTheme("SelectionBG")bb=bd.parent:getTheme("SelectionText")if(bd.parent~=nil)then
bd.parent:addEvent("mouse_click",bd)bd.parent:addEvent("mouse_up",bd)
bd.parent:addEvent("mouse_scroll",bd)end end}return setmetatable(ad,ca)end
end; 
project['objects']['Graphic'] = function(...)local da=require("Object")local _b=require("geometricPoints")
local ab=require("tHex")local bb=require("utils").getValueFromXML
local cb,db,_c,ac=string.sub,string.len,math.max,math.min
return
function(bc)local cc=da(bc)local dc="Graphic"cc:setZIndex(2)local _d={}local ad={}local bd={}
local cd=false;local dd,__a=0,0;local a_a=false;local b_a,c_a;local d_a,_aa=40,15;local aaa=false;local baa={}for n=1,16 do baa[string.byte("0123456789abcdef",n,n)]=
2 ^ (n-1)end
local function caa(dba)local _ca={}for i=1,
#dba do _ca[i]=dba:sub(i,i)end;return _ca end
local function daa(dba,_ca,aca,bca,cca)
if(_ca>=1)and(_ca<=bca)then
if(dba+db(cca)>0)and(dba<=aca)then
local dca=ad[_ca]local _da;local ada=dba+#cca-1
if(dba<1)then
cca=cb(cca,1 -dba+1,aca-dba+1)elseif(ada>aca)then cca=cb(cca,1,aca-dba+1)end
if(dba>1)then _da=cb(dca,1,dba-1)..cca else _da=cca end;if ada<aca then _da=_da..cb(dca,ada+1,aca)end
ad[_ca]=_da end end end
local function _ba()local dba,_ca=d_a,_aa;if(cd)then dba=dba*2;_ca=_ca*3 end
for y=1,_ca do
if(ad[y]~=nil)then if(dba>
ad[y]:len())then ad[y]=ad[y]..
(ab[cc.bgColor]):rep(dba-ad[y]:len())else
ad[y]=ad[y]:sub(1,dba)end else
ad[y]=(ab[cc.bgColor]):rep(dba)end end end;_ba()
local function aba()
local function dba(b_b,c_b)local d_b={}for x=1,c_b:len()do
d_b[x]=baa[string.byte(c_b,x,x)]or 0 end;table.insert(b_b,d_b)end
function parseImage(b_b)if type(b_b)~="string"then
error("bad argument #1 (expected string, got "..type(b_b)..")")end;local c_b={}for d_b in
(b_b.."\n"):gmatch("(.-)\n")do dba(c_b,d_b)end;return c_b end;local _ca=""for y=1,#ad do
if(y==#ad)then _ca=_ca..ad[y]else _ca=_ca..ad[y].."\n"end end;local aca=parseImage(_ca)
local bca={[0]={8,4,3,6,5},{4,14,8,7},{6,10,8,7},{9,11,8,0},{1,14,8,0},{13,12,8,0},{2,10,8,0},{15,8,10,11,12,14},{0,7,1,9,2,13},{3,11,8,7},{2,6,7,15},{9,3,7,15},{13,5,7,15},{5,12,8,7},{1,4,7,15},{7,10,11,12,14}}local cca,dca,_da={},{},{}for i=0,15 do dca[2 ^i]=i end
do local b_b="0123456789abcdef"
for i=1,16 do cca[b_b:sub(i,i)]=
i-1;cca[i-1]=b_b:sub(i,i)
_da[b_b:sub(i,i)]=2 ^ (i-1)_da[2 ^ (i-1)]=b_b:sub(i,i)local c_b=bca[i-1]for i=1,#c_b do
c_b[i]=2 ^c_b[i]end end end
local function ada(b_b)local c_b=bca[dca[b_b[#b_b][1] ] ]
for j=1,#c_b do local d_b=c_b[j]for i=1,
#b_b-1 do if b_b[i][1]==d_b then return i end end end;return 1 end
local function bda(b_b,c_b)
if not c_b then local _ab={}c_b={}for i=1,6 do local aab=b_b[i]local bab=c_b[aab]
c_b[aab],_ab[i]=bab and(bab+1)or 1,aab end;b_b=_ab end;local d_b={}for _ab,aab in pairs(c_b)do d_b[#d_b+1]={_ab,aab}end
if#
d_b>1 then
while#d_b>2 do
table.sort(d_b,function(_bb,abb)return _bb[2]>abb[2]end)local aab,bab=ada(d_b),#d_b;local cab,dab=d_b[bab][1],d_b[aab][1]for i=1,6 do
if b_b[i]==
cab then b_b[i]=dab;d_b[aab][2]=d_b[aab][2]+1 end end;d_b[bab]=nil end;local _ab=128;for i=1,#b_b-1 do
if b_b[i]~=b_b[6]then _ab=_ab+2 ^ (i-1)end end;return string.char(_ab),_da[d_b[1][1]==b_b[6]and
d_b[2][1]or d_b[1][1] ],
_da[b_b[6] ]else
return"\128",_da[b_b[1] ],_da[b_b[1] ]end end
local cda,dda,__b,a_b={{},{},{}},0,#aca+#aca%3,cc.bgColor or colors.black
for i=1,#aca do if#aca[i]>dda then dda=#aca[i]end end
for y=0,__b-1,3 do local b_b,c_b,d_b,_ab={},{},{},1
for x=0,dda-1,2 do local aab,bab={},{}
for yy=1,3 do
for xx=1,2 do
aab[#aab+1]=
(aca[y+yy]and aca[y+yy][
x+xx])and(aca[y+yy][x+xx]==0 and a_b or aca[y+yy][
x+xx])or a_b;bab[aab[#aab] ]=
bab[aab[#aab] ]and(bab[aab[#aab] ]+1)or 1 end end;b_b[_ab],c_b[_ab],d_b[_ab]=bda(aab,bab)_ab=_ab+1 end
cda[1][#cda[1]+1],cda[2][#cda[2]+1],cda[3][#cda[3]+1]=table.concat(b_b),table.concat(c_b),table.concat(d_b)end;cda.width,cda.height=#cda[1][1],#cda[1]bd=cda end
local function bba()local dba,_ca=d_a,_aa;if(cd)then dba=dba*2;_ca=_ca*3 end;for aca,bca in pairs(_d)do
for cca,dca in
pairs(bca[1])do daa(dca.x,dca.y,dba,_ca,bca[2])end end;if(cd)then aba()end end
local cba={init=function(dba)dba.bgColor=dba.parent:getTheme("GraphicBG")end,getType=function(dba)return
dc end,setSize=function(dba,_ca,aca,bca)cc.setSize(dba,_ca,aca,bca)if not(aaa)then d_a=_ca
_aa=aca;_ba()end;bba()return dba end,setOffset=function(dba,_ca,aca)dd=
_ca or dd;__a=aca or __a;return dba end,setCanvasSize=function(dba,_ca,aca)
d_a,_aa=_ca,aca;aaa=true;_ba()return dba end,clearCanvas=function(dba)_d={}ad={}_ba()end,getOffset=function(dba)return
dd,__a end,setValuesByXMLData=function(dba,_ca)cc.setValuesByXMLData(dba,_ca)
if(
bb("text",_ca)~=nil)then dba:setText(bb("text",_ca))end;if(bb("xOffset",_ca)~=nil)then
dba:setOffset(bb("xOffset",_ca),__a)end;if(bb("yOffset",_ca)~=nil)then
dba:setOffset(dd,bb("yOffset",_ca))end;if(bb("wCanvas",_ca)~=nil)then
d_a=bb("wCanvas",_ca)end;if(bb("hCanvas",_ca)~=nil)then
_aa=bb("hCanvas",_ca)end;if(bb("shrink",_ca)~=nil)then if(bb("shrink",_ca))then
dba:shrink()end end
if
(bb("dragable",_ca)~=nil)then if(bb("dragable",_ca))then a_a=true end end
if(_ca["ellipse"]~=nil)then local aca=_ca["ellipse"]if(aca.properties~=nil)then
aca={aca}end
for bca,cca in pairs(aca)do local dca=colors[bb("color",cca)]
local _da=bb("radius",cca)local ada=bb("radius2",cca)local bda=bb("x",cca)local cda=bb("y",cca)
local dda=bb("filled",cca)dba:addEllipse(dca,_da,ada,bda,cda,dda)end end
if(_ca["circle"]~=nil)then local aca=_ca["circle"]if(aca.properties~=nil)then
aca={aca}end
for bca,cca in pairs(aca)do local dca=colors[bb("color",cca)]
local _da=tonumber(bb("radius",cca))local ada=tonumber(bb("x",cca))
local bda=tonumber(bb("y",cca))local cda=bb("filled",cca)
dba:addCircle(dca,_da,ada,bda,cda)end end
if(_ca["line"]~=nil)then local aca=_ca["line"]
if(aca.properties~=nil)then aca={aca}end
for bca,cca in pairs(aca)do local dca=colors[bb("color",cca)]
local _da=tonumber(bb("x",cca))local ada=tonumber(bb("x2",cca))
local bda=tonumber(bb("y",cca))local cda=tonumber(bb("y2",cca))
dba:addLine(dca,_da,bda,ada,cda)end end
if(_ca["rectangle"]~=nil)then local aca=_ca["rectangle"]if
(aca.properties~=nil)then aca={aca}end
for bca,cca in pairs(aca)do
local dca=colors[bb("color",cca)]local _da=tonumber(bb("x",cca))
local ada=tonumber(bb("x2",cca))local bda=tonumber(bb("y",cca))
local cda=tonumber(bb("y2",cca))
local dda=bb("filled",cca)=="true"and true or false;dba:addRectangle(dca,_da,bda,ada,cda,dda)end end
if(_ca["triangle"]~=nil)then local aca=_ca["triangle"]if(aca.properties~=nil)then
aca={aca}end
for bca,cca in pairs(aca)do local dca=colors[bb("color",cca)]
local _da=tonumber(bb("x",cca))local ada=tonumber(bb("x2",cca))
local bda=tonumber(bb("x2",cca))local cda=tonumber(bb("y",cca))
local dda=tonumber(bb("y2",cca))local __b=tonumber(bb("y3",cca))local a_b=bb("filled",cca)
dba:addTriangle(dca,_da,cda,ada,dda,bda,__b,a_b)end end;return dba end,addCircle=function(dba,_ca,aca,bca,cca,dca)
local _da=ab[_ca]
table.insert(_d,{_b.circle(bca or 1,cca or 1,aca,dca),ab[_ca]})bba()return dba end,addEllipse=function(dba,_ca,aca,bca,cca,dca,_da)
table.insert(_d,{_b.ellipse(
cca or 1,dca or 1,aca,bca,_da),ab[_ca]})bba()return dba end,addLine=function(dba,_ca,aca,bca,cca,dca)
table.insert(_d,{_b.line(
aca or 1,bca or 1,cca or 1,dca or 1),ab[_ca]})bba()return dba end,addTriangle=function(dba,_ca,aca,bca,cca,dca,_da,ada,bda)
table.insert(_d,{_b.triangle(
aca or 1,bca or 1,cca or 1,dca or 1,_da or 1,ada or 1,bda),ab[_ca]})bba()return dba end,addRectangle=function(dba,_ca,aca,bca,cca,dca,_da)
table.insert(_d,{_b.rectangle(
aca or 1,bca or 1,cca or 1,dca or 1,_da),ab[_ca]})bba()return dba end,shrink=function(dba)
cd=true;_ba()aba()return dba end,setDragable=function(dba,_ca)
a_a=_ca==true and true or false;return dba end,mouseHandler=function(dba,_ca,aca,bca,cca)
if(cc.mouseHandler(dba,_ca,aca,bca,cca))then
if
(a_a)then if(_ca=="mouse_click")then b_a,c_a=bca,cca end
if(_ca=="mouse_drag")then if
(b_a~=nil)and(c_a~=nil)then
dd=_c(ac(dd+b_a-bca,d_a-dba:getWidth()),0)b_a=bca
__a=_c(ac(__a+c_a-cca,_aa-dba:getHeight()),0)c_a=cca end end end;return true end;return false end,draw=function(dba)
if
(cc.draw(dba))then
if(dba.parent~=nil)then local _ca,aca=dba:getAnchorPosition()
local bca,cca=dba:getSize()if(dba.bgColor~=false)then
dba.parent:drawBackgroundBox(_ca,aca,bca,cca,dba.bgColor)end
if(cd)then local dca,_da,ada=bd[1],bd[2],bd[3]
for i=1,bd.height
do local bda,cda=_ca+dd,aca+i-1 +__a
if
(cda>aca-1)and(cda<=aca+cca-1)and(bda<=bca+_ca)then local dda=dca[i]local __b,a_b,b_b=_c(bda,_ca),_c(1 -bda+1,1),ac(
bca- (bda-_ca),bca)
if
type(dda)=="string"then dba.parent:setText(__b,cda,cb(dda,a_b,b_b))
dba.parent:setFG(__b,cda,cb(_da[i],a_b,b_b))
dba.parent:setBG(__b,cda,cb(ada[i],a_b,b_b))elseif type(dda)=="table"then
dba.parent:setText(__b,cda,cb(dda[2],a_b,b_b))
dba.parent:setFG(__b,cda,cb(_da[i],a_b,b_b))
dba.parent:setBG(__b,cda,cb(ada[i],a_b,b_b))end end end else
for i=1,#ad do local dca,_da=_ca+dd,aca+i-1 +__a
if
(_da>aca-1)and(_da<=aca+cca-1)and(dca<=bca+_ca)then local ada,bda,cda=_c(dca,_ca),_c(1 -dca+1,1),ac(bca-
(dca-_ca),bca)
dba.parent:setBG(ada,_da,cb(ad[i],bda,cda))end end end end;dba:setVisualChanged(false)end end}return setmetatable(cba,cc)end
end; 
project['objects']['Image'] = function(...)local c=require("Object")
local d=require("utils").getValueFromXML
return
function(_a)local aa=c(_a)local ba="Image"aa:setZIndex(2)local ca;local da;local _b=false
local function ab()
local cb={[0]={8,4,3,6,5},{4,14,8,7},{6,10,8,7},{9,11,8,0},{1,14,8,0},{13,12,8,0},{2,10,8,0},{15,8,10,11,12,14},{0,7,1,9,2,13},{3,11,8,7},{2,6,7,15},{9,3,7,15},{13,5,7,15},{5,12,8,7},{1,4,7,15},{7,10,11,12,14}}local db,_c,ac={},{},{}for i=0,15 do _c[2 ^i]=i end
do local cd="0123456789abcdef"
for i=1,16 do db[cd:sub(i,i)]=
i-1;db[i-1]=cd:sub(i,i)
ac[cd:sub(i,i)]=2 ^ (i-1)ac[2 ^ (i-1)]=cd:sub(i,i)local dd=cb[i-1]for i=1,#dd do
dd[i]=2 ^dd[i]end end end
local function bc(cd)local dd=cb[_c[cd[#cd][1] ] ]
for j=1,#dd do local __a=dd[j]for i=1,#cd-1 do if
cd[i][1]==__a then return i end end end;return 1 end
local function cc(cd,dd)
if not dd then local a_a={}dd={}for i=1,6 do local b_a=cd[i]local c_a=dd[b_a]
dd[b_a],a_a[i]=c_a and(c_a+1)or 1,b_a end;cd=a_a end;local __a={}for a_a,b_a in pairs(dd)do __a[#__a+1]={a_a,b_a}end
if
#__a>1 then
while#__a>2 do
table.sort(__a,function(aaa,baa)return aaa[2]>baa[2]end)local b_a,c_a=bc(__a),#__a;local d_a,_aa=__a[c_a][1],__a[b_a][1]for i=1,6 do
if
cd[i]==d_a then cd[i]=_aa;__a[b_a][2]=__a[b_a][2]+1 end end;__a[c_a]=nil end;local a_a=128
for i=1,#cd-1 do if cd[i]~=cd[6]then a_a=a_a+2 ^ (i-1)end end
return string.char(a_a),ac[__a[1][1]==cd[6]and __a[2][1]or
__a[1][1] ],ac[cd[6] ]else return"\128",ac[cd[1] ],ac[cd[1] ]end end
local dc,_d,ad,bd={{},{},{}},0,#ca+#ca%3,aa.bgColor or colors.black;for i=1,#ca do if#ca[i]>_d then _d=#ca[i]end end
for y=0,ad-1,3 do
local cd,dd,__a,a_a={},{},{},1
for x=0,_d-1,2 do local b_a,c_a={},{}
for yy=1,3 do
for xx=1,2 do
b_a[#b_a+1]=(ca[y+yy]and ca[y+yy][x+xx])and
(ca[y+
yy][x+xx]==0 and bd or ca[y+yy][x+xx])or bd;c_a[b_a[#b_a] ]=
c_a[b_a[#b_a] ]and(c_a[b_a[#b_a] ]+1)or 1 end end;cd[a_a],dd[a_a],__a[a_a]=cc(b_a,c_a)a_a=a_a+1 end
dc[1][#dc[1]+1],dc[2][#dc[2]+1],dc[3][#dc[3]+1]=table.concat(cd),table.concat(dd),table.concat(__a)end;dc.width,dc.height=#dc[1][1],#dc[1]da=dc end
local bb={init=function(cb)cb.bgColor=cb.parent:getTheme("ImageBG")end,getType=function(cb)return
ba end,loadImage=function(cb,db)ca=paintutils.loadImage(db)_b=false
cb:updateDraw()return cb end,shrink=function(cb)ab()_b=true
cb:updateDraw()return cb end,setValuesByXMLData=function(cb,db)aa.setValuesByXMLData(cb,db)
if(
d("shrink",db)~=nil)then if(d("shrink",db))then cb:shrink()end end
if(d("path",db)~=nil)then cb:loadImage(d("path",db))end;return cb end,draw=function(cb)
if
(aa.draw(cb))then
if(cb.parent~=nil)then
if(ca~=nil)then local db,_c=cb:getAnchorPosition()
local ac,bc=cb:getSize()
if(_b)then local cc,dc,_d=da[1],da[2],da[3]
for i=1,da.height do local ad=cc[i]
if type(ad)=="string"then cb.parent:setText(db,
_c+i-1,ad)
cb.parent:setFG(db,_c+i-1,dc[i])cb.parent:setBG(db,_c+i-1,_d[i])elseif
type(ad)=="table"then cb.parent:setText(db,_c+i-1,ad[2])cb.parent:setFG(db,_c+
i-1,dc[i])
cb.parent:setBG(db,_c+i-1,_d[i])end end else
for yPos=1,math.min(#ca,bc)do local cc=ca[yPos]
for xPos=1,math.min(#cc,ac)do if cc[xPos]>0 then
cb.parent:drawBackgroundBox(
db+xPos-1,_c+yPos-1,1,1,cc[xPos])end end end end end end end end}return setmetatable(bb,aa)end
end; 
project['objects']['Input'] = function(...)local _a=require("Object")local aa=require("utils")
local ba=require("basaltLogs")local ca=aa.getValueFromXML
return
function(da)local _b=_a(da)local ab="Input"local bb="text"local cb=0
_b:setZIndex(5)_b:setValue("")_b.width=10;_b.height=1;local db=1;local _c=1;local ac=""local bc;local cc
local dc=ac;local _d=false
local ad={getType=function(bd)return ab end,setInputType=function(bd,cd)if(cd=="password")or(cd=="number")or
(cd=="text")then bb=cd end
bd:updateDraw()return bd end,setDefaultText=function(bd,cd,dd,__a)ac=cd
bc=__a or bc;cc=dd or cc;if(bd:isFocused())then dc=""else dc=ac end
bd:updateDraw()return bd end,getInputType=function(bd)return bb end,setValue=function(bd,cd)
_b.setValue(bd,tostring(cd))
if not(_d)then
if(bd:isFocused())then db=tostring(cd):len()+1;_c=math.max(1,
db-bd:getWidth()+1)
local dd,__a=bd:getAnchorPosition()
bd.parent:setCursor(true,dd+db-_c,__a+math.floor(bd.height/2),bd.fgColor)end end;bd:updateDraw()return bd end,getValue=function(bd)
local cd=_b.getValue(bd)return bb=="number"and tonumber(cd)or cd end,setInputLimit=function(bd,cd)cb=
tonumber(cd)or cb;bd:updateDraw()return bd end,getInputLimit=function(bd)return
cb end,setValuesByXMLData=function(bd,cd)_b.setValuesByXMLData(bd,cd)local dd,__a;if(
ca("defaultBG",cd)~=nil)then dd=ca("defaultBG",cd)end;if(
ca("defaultFG",cd)~=nil)then __a=ca("defaultFG",cd)end;if(
ca("default",cd)~=nil)then
bd:setDefaultText(ca("default",cd),__a~=nil and colors[__a],dd~=nil and
colors[dd])end
if
(ca("limit",cd)~=nil)then bd:setInputLimit(ca("limit",cd))end
if(ca("type",cd)~=nil)then bd:setInputType(ca("type",cd))end;return bd end,getFocusHandler=function(bd)
_b.getFocusHandler(bd)
if(bd.parent~=nil)then local cd,dd=bd:getAnchorPosition()dc=""if(ac~="")then
bd:updateDraw()end
bd.parent:setCursor(true,cd+db-_c,dd+math.max(math.ceil(
bd:getHeight()/2 -1,1)),bd.fgColor)end end,loseFocusHandler=function(bd)
_b.loseFocusHandler(bd)if(bd.parent~=nil)then dc=ac;if(ac~="")then bd:updateDraw()end
bd.parent:setCursor(false)end end,keyHandler=function(bd,cd)
if
(_b.keyHandler(bd,cd))then local dd,__a=bd:getSize()_d=true
if(cd==keys.backspace)then
local _aa=tostring(_b.getValue())if(db>1)then
bd:setValue(_aa:sub(1,db-2).._aa:sub(db,_aa:len()))if(db>1)then db=db-1 end
if(_c>1)then if(db<_c)then _c=_c-1 end end end end;if(cd==keys.enter)then if(bd.parent~=nil)then end end
if(cd==
keys.right)then
local _aa=tostring(_b.getValue()):len()db=db+1;if(db>_aa)then db=_aa+1 end;if(db<1)then db=1 end;if
(db<_c)or(db>=dd+_c)then _c=db-dd+1 end;if(_c<1)then _c=1 end end
if(cd==keys.left)then db=db-1;if(db>=1)then
if(db<_c)or(db>=dd+_c)then _c=db end end;if(db<1)then db=1 end;if(_c<1)then _c=1 end end;local a_a,b_a=bd:getAnchorPosition()
local c_a=tostring(_b.getValue())
local d_a=(db<=c_a:len()and db-1 or c_a:len())- (_c-1)if(d_a>bd.x+dd-1)then d_a=bd.x+dd-1 end;if
(bd.parent~=nil)then
bd.parent:setCursor(true,a_a+d_a,b_a+math.max(math.ceil(__a/2 -1,1)),bd.fgColor)end;_d=false;return true end;return false end,charHandler=function(bd,cd)
if
(_b.charHandler(bd,cd))then _d=true;local dd,__a=bd:getSize()local a_a=_b.getValue()
if(a_a:len()<cb or
cb<=0)then
if(bb=="number")then local baa=a_a;if
(cd==".")or(tonumber(cd)~=nil)then
bd:setValue(a_a:sub(1,db-1)..cd..a_a:sub(db,a_a:len()))db=db+1 end;if(
tonumber(_b.getValue())==nil)then bd:setValue(baa)end else
bd:setValue(a_a:sub(1,
db-1)..cd..a_a:sub(db,a_a:len()))db=db+1 end;if(db>=dd+_c)then _c=_c+1 end end;local b_a,c_a=bd:getAnchorPosition()
local d_a=tostring(_b.getValue())
local _aa=(db<=d_a:len()and db-1 or d_a:len())- (_c-1)local aaa=bd:getX()if(_aa>aaa+dd-1)then _aa=aaa+dd-1 end;if(
bd.parent~=nil)then
bd.parent:setCursor(true,b_a+_aa,c_a+
math.max(math.ceil(__a/2 -1,1)),bd.fgColor)end;_d=false
bd:updateDraw()return true end;return false end,mouseHandler=function(bd,cd,dd,__a)
if
(_b.mouseHandler(bd,cd,dd,__a))then local a_a,b_a=bd:getAnchorPosition()
local c_a,d_a=bd:getAbsolutePosition(a_a,b_a)local _aa,aaa=bd:getSize()db=dd-c_a+_c;local baa=_b.getValue()if(db>
baa:len())then db=baa:len()+1 end;if(db<_c)then _c=db-1
if(_c<1)then _c=1 end end
bd.parent:setCursor(true,c_a+db-1,d_a+
math.max(math.ceil(aaa/2 -1,1)),bd.fgColor)return true end end,eventHandler=function(bd,cd,dd,__a,a_a,b_a)
if
(_b.eventHandler(bd,cd,dd,__a,a_a,b_a))then
if(cd=="paste")then
if(bd:isFocused())then local c_a=_b.getValue()
local d_a,_aa=bd:getSize()_d=true
if(bb=="number")then local aba=c_a
if(dd==".")or(tonumber(dd)~=nil)then
bd:setValue(c_a:sub(1,
db-1)..dd..c_a:sub(db,c_a:len()))db=db+dd:len()end
if(tonumber(_b.getValue())==nil)then bd:setValue(aba)end else
bd:setValue(c_a:sub(1,db-1)..dd..c_a:sub(db,c_a:len()))db=db+dd:len()end;if(db>=d_a+_c)then _c=(db+1)-d_a end
local aaa,baa=bd:getAnchorPosition()local caa=tostring(_b.getValue())
local daa=(
db<=caa:len()and db-1 or caa:len())- (_c-1)local _ba=bd:getX()
if(daa>_ba+d_a-1)then daa=_ba+d_a-1 end;if(bd.parent~=nil)then
bd.parent:setCursor(true,aaa+daa,baa+
math.max(math.ceil(_aa/2 -1,1)),bd.fgColor)end
bd:updateDraw()_d=false end end end end,draw=function(bd)
if
(_b.draw(bd))then
if(bd.parent~=nil)then local cd,dd=bd:getAnchorPosition()
local __a,a_a=bd:getSize()local b_a=aa.getTextVerticalAlign(a_a,"center")if
(bd.bgColor~=false)then
bd.parent:drawBackgroundBox(cd,dd,__a,a_a,bd.bgColor)end
for n=1,a_a do
if(n==b_a)then
local c_a=tostring(_b.getValue())local d_a=bd.bgColor;local _aa=bd.fgColor;local aaa;if(c_a:len()<=0)then aaa=dc;d_a=bc or d_a;_aa=
cc or _aa end;aaa=dc
if(c_a~="")then aaa=c_a end;aaa=aaa:sub(_c,__a+_c-1)local baa=__a-aaa:len()if(baa<0)then
baa=0 end;if(bb=="password")and(c_a~="")then
aaa=string.rep("*",aaa:len())end
aaa=aaa..string.rep(bd.bgSymbol,baa)bd.parent:writeText(cd,dd+ (n-1),aaa,d_a,_aa)end end;if(bd:isFocused())then
bd.parent:setCursor(true,cd+db-_c,dd+math.max(math.ceil(
bd:getHeight()/2 -1,1)),bd.fgColor)end end end end,init=function(bd)
bd.bgColor=bd.parent:getTheme("InputBG")bd.fgColor=bd.parent:getTheme("InputText")
if
(bd.parent~=nil)then bd.parent:addEvent("mouse_click",bd)
bd.parent:addEvent("key",bd)bd.parent:addEvent("char",bd)
bd.parent:addEvent("other_event",bd)end end}return setmetatable(ad,_b)end
end; 
project['objects']['Label'] = function(...)local ba=require("Object")local ca=require("utils")
local da=ca.getValueFromXML;local _b=ca.createText;local ab=require("tHex")local bb=require("bigfont")
return
function(cb)
local db=ba(cb)local _c="Label"db:setZIndex(3)local ac=true;db:setValue("Label")
db.width=5;local bc="left"local cc="top"local dc=0;local _d,ad=false,false
local bd={getType=function(cd)return _c end,setText=function(cd,dd)
dd=tostring(dd)db:setValue(dd)if(ac)then cd.width=dd:len()end
cd:updateDraw()return cd end,setBackground=function(cd,dd)
db.setBackground(cd,dd)ad=true;cd:updateDraw()return cd end,setForeground=function(cd,dd)
db.setForeground(cd,dd)_d=true;cd:updateDraw()return cd end,setTextAlign=function(cd,dd,__a)
bc=dd or bc;cc=__a or cc;cd:updateDraw()return cd end,setFontSize=function(cd,dd)if(
dd>0)and(dd<=4)then dc=dd-1 or 0 end
cd:updateDraw()return cd end,getFontSize=function(cd)return dc+1 end,setValuesByXMLData=function(cd,dd)
db.setValuesByXMLData(cd,dd)
if(da("text",dd)~=nil)then cd:setText(da("text",dd))end
if(da("verticalAlign",dd)~=nil)then cc=da("verticalAlign",dd)end;if(da("horizontalAlign",dd)~=nil)then
bc=da("horizontalAlign",dd)end;if(da("font",dd)~=nil)then
cd:setFontSize(da("font",dd))end;return cd end,setSize=function(cd,dd,__a,a_a)
db.setSize(cd,dd,__a,a_a)ac=false;cd:updateDraw()return cd end,draw=function(cd)
if
(db.draw(cd))then
if(cd.parent~=nil)then local dd,__a=cd:getAnchorPosition()
local a_a,b_a=cd:getSize()local c_a=ca.getTextVerticalAlign(b_a,cc)
if(dc==0)then
if not(ac)then
local d_a=_b(cd:getValue(),cd:getWidth())for _aa,aaa in pairs(d_a)do
cd.parent:writeText(dd,__a+_aa-1,aaa,cd.bgColor,cd.fgColor)end else
cd.parent:writeText(dd,__a,cd:getValue(),cd.bgColor,cd.fgColor)end else
local d_a=bb(dc,cd:getValue(),cd.fgColor,cd.bgColor or colors.lightGray)
if(ac)then cd:setSize(#d_a[1][1],#d_a[1]-1)end;local _aa,aaa=cd.parent:getSize()
local baa,caa=#d_a[1][1],#d_a[1]
dd=dd or math.floor((_aa-baa)/2)+1
__a=__a or math.floor((aaa-caa)/2)+1
for i=1,caa do cd.parent:setFG(dd,__a+i-2,d_a[2][i])cd.parent:setBG(dd,
__a+i-2,d_a[3][i])cd.parent:setText(dd,
__a+i-2,d_a[1][i])end end end end end,init=function(cd)
if
(db.init(cd))then cd.bgColor=cd.parent:getTheme("LabelBG")
cd.fgColor=cd.parent:getTheme("LabelText")
if
(cd.parent.bgColor==colors.black)and(cd.fgColor==colors.black)then cd.fgColor=colors.lightGray end end end}return setmetatable(bd,db)end
end; 
project['objects']['List'] = function(...)local d=require("Object")local _a=require("utils")
local aa=_a.getValueFromXML
return
function(ba)local ca=d(ba)local da="List"ca.width=16;ca.height=6;ca:setZIndex(5)local _b={}
local ab;local bb;local cb=true;local db="left"local _c=0;local ac=true
local bc={getType=function(cc)return da end,addItem=function(cc,dc,_d,ad,...)
table.insert(_b,{text=dc,bgCol=_d or cc.bgColor,fgCol=
ad or cc.fgColor,args={...}})if(#_b==1)then cc:setValue(_b[1])end
cc:updateDraw()return cc end,setOffset=function(cc,dc)
_c=dc;cc:updateDraw()return cc end,getOffset=function(cc)return _c end,removeItem=function(cc,dc)
table.remove(_b,dc)cc:updateDraw()return cc end,getItem=function(cc,dc)return _b[dc]end,getAll=function(cc)return
_b end,getItemIndex=function(cc)local dc=cc:getValue()
for _d,ad in pairs(_b)do if(ad==dc)then return _d end end end,clear=function(cc)_b={}cc:setValue({})
cc:updateDraw()return cc end,getItemCount=function(cc)return#_b end,editItem=function(cc,dc,_d,ad,bd,...)
table.remove(_b,dc)
table.insert(_b,dc,{text=_d,bgCol=ad or cc.bgColor,fgCol=bd or cc.fgColor,args={...}})cc:updateDraw()return cc end,selectItem=function(cc,dc)cc:setValue(
_b[dc]or{})cc:updateDraw()return cc end,setSelectedItem=function(cc,dc,_d,ad)ab=
dc or cc.bgColor;bb=_d or cc.fgColor
cb=ad~=nil and ad or true;cc:updateDraw()return cc end,setScrollable=function(cc,dc)
ac=dc;if(dc==nil)then ac=true end;cc:updateDraw()return cc end,setValuesByXMLData=function(cc,dc)
ca.setValuesByXMLData(cc,dc)if(aa("selectionBG",dc)~=nil)then
ab=colors[aa("selectionBG",dc)]end;if(aa("selectionFG",dc)~=nil)then
bb=colors[aa("selectionFG",dc)]end;if(aa("scrollable",dc)~=nil)then
if
(aa("scrollable",dc))then cc:setScrollable(true)else cc:setScrollable(false)end end;if
(aa("offset",dc)~=nil)then _c=aa("offset",dc)end
if(dc["item"]~=nil)then
local _d=dc["item"]if(_d.properties~=nil)then _d={_d}end;for ad,bd in pairs(_d)do
cc:addItem(aa("text",bd),colors[aa("bg",bd)],colors[aa("fg",bd)])end end;return cc end,scrollHandler=function(cc,dc,_d,ad)
if
(ca.scrollHandler(cc,dc,_d,ad))then
if(ac)then local bd,cd=cc:getSize()_c=_c+dc;if(_c<0)then _c=0 end;if(dc>=1)then
if(#_b>cd)then if
(_c>#_b-cd)then _c=#_b-cd end;if(_c>=#_b)then _c=#_b-1 end else _c=_c-1 end end
cc:updateDraw()end;return true end;return false end,mouseHandler=function(cc,dc,_d,ad)
if
(ca.mouseHandler(cc,dc,_d,ad))then
local bd,cd=cc:getAbsolutePosition(cc:getAnchorPosition())local dd,__a=cc:getSize()
if(#_b>0)then for n=1,__a do
if(_b[n+_c]~=nil)then if
(bd<=_d)and(bd+dd>_d)and(cd+n-1 ==ad)then cc:setValue(_b[n+_c])
cc:updateDraw()end end end end;return true end;return false end,dragHandler=function(cc,dc,_d,ad)return
cc:mouseHandler(dc,_d,ad)end,touchHandler=function(cc,dc,_d)
return cc:mouseHandler(1,dc,_d)end,draw=function(cc)
if(ca.draw(cc))then
if(cc.parent~=nil)then
local dc,_d=cc:getAnchorPosition()local ad,bd=cc:getSize()if(cc.bgColor~=false)then
cc.parent:drawBackgroundBox(dc,_d,ad,bd,cc.bgColor)end
for n=1,bd do
if(_b[n+_c]~=nil)then
if(_b[n+_c]==
cc:getValue())then
if(cb)then
cc.parent:writeText(dc,_d+n-1,_a.getTextHorizontalAlign(_b[n+_c].text,ad,db),ab,bb)else
cc.parent:writeText(dc,_d+n-1,_a.getTextHorizontalAlign(_b[n+_c].text,ad,db),_b[
n+_c].bgCol,_b[n+_c].fgCol)end else
cc.parent:writeText(dc,_d+n-1,_a.getTextHorizontalAlign(_b[n+_c].text,ad,db),_b[
n+_c].bgCol,_b[n+_c].fgCol)end end end end end end,init=function(cc)
cc.bgColor=cc.parent:getTheme("ListBG")cc.fgColor=cc.parent:getTheme("ListText")
ab=cc.parent:getTheme("SelectionBG")bb=cc.parent:getTheme("SelectionText")
cc.parent:addEvent("mouse_click",cc)cc.parent:addEvent("mouse_drag",cc)
cc.parent:addEvent("mouse_scroll",cc)end}return setmetatable(bc,ca)end
end; 
project['objects']['Menubar'] = function(...)local _a=require("Object")local aa=require("utils")
local ba=aa.getValueFromXML;local ca=require("tHex")
return
function(da)local _b=_a(da)local ab="Menubar"local bb={}_b.width=30
_b.height=1;_b:setZIndex(5)local cb={}local db;local _c;local ac=true;local bc="left"local cc=0;local dc=1
local _d=false
local function ad()local bd=0;local cd=0;local dd=bb:getWidth()
for n=1,#cb do if(cd+cb[n].text:len()+
dc*2 >dd)then
if(cd<dd)then bd=bd+ (cb[n].text:len()+dc*2 - (
dd-cd))else bd=bd+
cb[n].text:len()+dc*2 end end;cd=cd+
cb[n].text:len()+dc*2 end;return bd end
bb={getType=function(bd)return ab end,addItem=function(bd,cd,dd,__a,...)
table.insert(cb,{text=tostring(cd),bgCol=dd or bd.bgColor,fgCol=__a or bd.fgColor,args={...}})if(#cb==1)then bd:setValue(cb[1])end
bd:updateDraw()return bd end,getAll=function(bd)return
cb end,getItemIndex=function(bd)local cd=bd:getValue()for dd,__a in pairs(cb)do
if(__a==cd)then return dd end end end,clear=function(bd)
cb={}bd:setValue({})bd:updateDraw()return bd end,setSpace=function(bd,cd)dc=
cd or dc;bd:updateDraw()return bd end,setOffset=function(bd,cd)
cc=cd or 0;if(cc<0)then cc=0 end;local dd=ad()if(cc>dd)then cc=dd end;bd:updateDraw()
return bd end,getOffset=function(bd)return cc end,setScrollable=function(bd,cd)
_d=cd;if(cd==nil)then _d=true end;return bd end,setValuesByXMLData=function(bd,cd)
_b.setValuesByXMLData(bd,cd)if(ba("selectionBG",cd)~=nil)then
db=colors[ba("selectionBG",cd)]end;if(ba("selectionFG",cd)~=nil)then
_c=colors[ba("selectionFG",cd)]end;if(ba("scrollable",cd)~=nil)then
if
(ba("scrollable",cd))then bd:setScrollable(true)else bd:setScrollable(false)end end
if
(ba("offset",cd)~=nil)then bd:setOffset(ba("offset",cd))end;if(ba("space",cd)~=nil)then dc=ba("space",cd)end
if(
cd["item"]~=nil)then local dd=cd["item"]if(dd.properties~=nil)then dd={dd}end;for __a,a_a in
pairs(dd)do
bd:addItem(ba("text",a_a),colors[ba("bg",a_a)],colors[ba("fg",a_a)])end end;return bd end,removeItem=function(bd,cd)
table.remove(cb,cd)bd:updateDraw()return bd end,getItem=function(bd,cd)return cb[cd]end,getItemCount=function(bd)return
#cb end,editItem=function(bd,cd,dd,__a,a_a,...)table.remove(cb,cd)
table.insert(cb,cd,{text=dd,bgCol=__a or bd.bgColor,fgCol=
a_a or bd.fgColor,args={...}})bd:updateDraw()return bd end,selectItem=function(bd,cd)bd:setValue(
cb[cd]or{})bd:updateDraw()return bd end,setSelectedItem=function(bd,cd,dd,__a)db=
cd or bd.bgColor;_c=dd or bd.fgColor;ac=__a
bd:updateDraw()return bd end,mouseHandler=function(bd,cd,dd,__a)
if
(_b.mouseHandler(bd,cd,dd,__a))then
local a_a,b_a=bd:getAbsolutePosition(bd:getAnchorPosition())local c_a,d_a=bd:getSize()local _aa=0
for n=1,#cb do
if(cb[n]~=nil)then
if
(a_a+_aa<=dd+cc)and(a_a+_aa+
cb[n].text:len()+ (dc*2)>dd+cc)and(b_a==__a)then bd:setValue(cb[n])
bd:getEventSystem():sendEvent(event,bd,event,0,dd,__a,cb[n])end;_aa=_aa+cb[n].text:len()+dc*2 end end;bd:updateDraw()return true end;return false end,scrollHandler=function(bd,cd,dd,__a)
if
(_b.scrollHandler(bd,cd,dd,__a))then if(_d)then cc=cc+cd;if(cc<0)then cc=0 end;local a_a=ad()if(cc>a_a)then cc=a_a end
bd:updateDraw()end;return true end;return false end,draw=function(bd)
if
(_b.draw(bd))then
if(bd.parent~=nil)then local cd,dd=bd:getAnchorPosition()
local __a,a_a=bd:getSize()if(bd.bgColor~=false)then
bd.parent:drawBackgroundBox(cd,dd,__a,a_a,bd.bgColor)end;local b_a=""local c_a=""local d_a=""
for _aa,aaa in pairs(cb)do
local baa=
(" "):rep(dc)..aaa.text.. (" "):rep(dc)b_a=b_a..baa
if(aaa==bd:getValue())then c_a=c_a..
ca[db or aaa.bgCol or bd.bgColor]:rep(baa:len())d_a=d_a..
ca[_c or aaa.FgCol or
bd.fgColor]:rep(baa:len())else c_a=c_a..
ca[aaa.bgCol or bd.bgColor]:rep(baa:len())d_a=d_a..
ca[aaa.FgCol or bd.fgColor]:rep(baa:len())end end
bd.parent:setText(cd,dd,b_a:sub(cc+1,__a+cc))
bd.parent:setBG(cd,dd,c_a:sub(cc+1,__a+cc))
bd.parent:setFG(cd,dd,d_a:sub(cc+1,__a+cc))end end end,init=function(bd)
bd.bgColor=bd.parent:getTheme("MenubarBG")bd.fgColor=bd.parent:getTheme("MenubarText")
db=bd.parent:getTheme("SelectionBG")_c=bd.parent:getTheme("SelectionText")
bd.parent:addEvent("mouse_click",bd)bd.parent:addEvent("mouse_scroll",bd)end}return setmetatable(bb,_b)end
end; 
project['objects']['Pane'] = function(...)local c=require("Object")local d=require("basaltLogs")
return
function(_a)local aa=c(_a)
local ba="Pane"
local ca={getType=function(da)return ba end,setBackground=function(da,_b,ab,bb)aa.setBackground(da,_b,ab,bb)return da end,init=function(da)if
(aa.init(da))then da.bgColor=da.parent:getTheme("PaneBG")
da.fgColor=da.parent:getTheme("PaneBG")end end}return setmetatable(ca,aa)end
end; 
project['objects']['Program'] = function(...)local ba=require("Object")local ca=require("tHex")
local da=require("process")local _b=require("utils").getValueFromXML
local ab=require("basaltLogs")local bb=string.sub
return
function(cb,db)local _c=ba(cb)local ac="Program"_c:setZIndex(5)local bc;local cc
local function dc(b_a,c_a,d_a,_aa,aaa)
local baa,caa=1,1;local daa,_ba=colors.black,colors.white;local aba=false;local bba=false;local cba={}local dba={}
local _ca={}local aca={}local bca;local cca={}for i=0,15 do local aab=2 ^i
aca[aab]={db:getBasaltInstance().getBaseTerm().getPaletteColour(aab)}end;local function dca()
bca=(" "):rep(d_a)
for n=0,15 do local aab=2 ^n;local bab=ca[aab]cca[aab]=bab:rep(d_a)end end
local function _da()dca()local aab=bca
local bab=cca[colors.white]local cab=cca[colors.black]
for n=1,_aa do
cba[n]=bb(cba[n]==nil and aab or cba[n]..aab:sub(1,
d_a-cba[n]:len()),1,d_a)
_ca[n]=bb(_ca[n]==nil and bab or _ca[n]..
bab:sub(1,d_a-_ca[n]:len()),1,d_a)
dba[n]=bb(dba[n]==nil and cab or dba[n]..
cab:sub(1,d_a-dba[n]:len()),1,d_a)end;_c.updateDraw(_c)end;_da()local function ada()if
baa>=1 and caa>=1 and baa<=d_a and caa<=_aa then else end end
local function bda(aab,bab,cab)
local dab=baa;local _bb=dab+#aab-1
if caa>=1 and caa<=_aa then
if dab<=d_a and _bb>=1 then
if dab==1 and _bb==
d_a then cba[caa]=aab;_ca[caa]=bab;dba[caa]=cab else local abb,bbb,cbb
if dab<1 then local _db=
1 -dab+1;local adb=d_a-dab+1;abb=bb(aab,_db,adb)
bbb=bb(bab,_db,adb)cbb=bb(cab,_db,adb)elseif _bb>d_a then local _db=d_a-dab+1;abb=bb(aab,1,_db)
bbb=bb(bab,1,_db)cbb=bb(cab,1,_db)else abb=aab;bbb=bab;cbb=cab end;local dbb=cba[caa]local _cb=_ca[caa]local acb=dba[caa]local bcb,ccb,dcb
if dab>1 then local _db=dab-1;bcb=
bb(dbb,1,_db)..abb;ccb=bb(_cb,1,_db)..bbb
dcb=bb(acb,1,_db)..cbb else bcb=abb;ccb=bbb;dcb=cbb end
if _bb<d_a then local _db=_bb+1;bcb=bcb..bb(dbb,_db,d_a)
ccb=ccb..bb(_cb,_db,d_a)dcb=dcb..bb(acb,_db,d_a)end;cba[caa]=bcb;_ca[caa]=ccb;dba[caa]=dcb end;bc:updateDraw()end;baa=_bb+1;if(bba)then ada()end end end
local function cda(aab,bab,cab)
if(cab~=nil)then local dab=cba[bab]if(dab~=nil)then
cba[bab]=bb(dab:sub(1,aab-1)..cab..dab:sub(aab+
(cab:len()),d_a),1,d_a)end end;bc:updateDraw()end
local function dda(aab,bab,cab)
if(cab~=nil)then local dab=dba[bab]if(dab~=nil)then
dba[bab]=bb(dab:sub(1,aab-1)..cab..dab:sub(aab+
(cab:len()),d_a),1,d_a)end end;bc:updateDraw()end
local function __b(aab,bab,cab)
if(cab~=nil)then local dab=_ca[bab]if(dab~=nil)then
_ca[bab]=bb(dab:sub(1,aab-1)..cab..dab:sub(aab+
(cab:len()),d_a),1,d_a)end end;bc:updateDraw()end
local a_b=function(aab)
if type(aab)~="number"then
error("bad argument #1 (expected number, got "..type(aab)..")",2)elseif ca[aab]==nil then
error("Invalid color (got "..aab..")",2)end;_ba=aab end
local b_b=function(aab)
if type(aab)~="number"then
error("bad argument #1 (expected number, got "..type(aab)..")",2)elseif ca[aab]==nil then
error("Invalid color (got "..aab..")",2)end;daa=aab end
local c_b=function(aab,bab,cab,dab)if type(aab)~="number"then
error("bad argument #1 (expected number, got "..type(aab)..")",2)end
if ca[aab]==nil then error("Invalid color (got "..
aab..")",2)end;local _bb
if
type(bab)=="number"and cab==nil and dab==nil then _bb={colours.rgb8(bab)}aca[aab]=_bb else if
type(bab)~="number"then
error("bad argument #2 (expected number, got "..type(bab)..")",2)end;if type(cab)~="number"then
error(
"bad argument #3 (expected number, got "..type(cab)..")",2)end;if type(dab)~="number"then
error(
"bad argument #4 (expected number, got "..type(dab)..")",2)end;_bb=aca[aab]_bb[1]=bab
_bb[2]=cab;_bb[3]=dab end end
local d_b=function(aab)if type(aab)~="number"then
error("bad argument #1 (expected number, got "..type(aab)..")",2)end
if ca[aab]==nil then error("Invalid color (got "..
aab..")",2)end;local bab=aca[aab]return bab[1],bab[2],bab[3]end
local _ab={setCursorPos=function(aab,bab)if type(aab)~="number"then
error("bad argument #1 (expected number, got "..type(aab)..")",2)end;if type(bab)~="number"then
error(
"bad argument #2 (expected number, got "..type(bab)..")",2)end;baa=math.floor(aab)
caa=math.floor(bab)if(bba)then ada()end end,getCursorPos=function()return
baa,caa end,setCursorBlink=function(aab)if type(aab)~="boolean"then
error("bad argument #1 (expected boolean, got "..
type(aab)..")",2)end;aba=aab end,getCursorBlink=function()return
aba end,getPaletteColor=d_b,getPaletteColour=d_b,setBackgroundColor=b_b,setBackgroundColour=b_b,setTextColor=a_b,setTextColour=a_b,setPaletteColor=c_b,setPaletteColour=c_b,getBackgroundColor=function()return daa end,getBackgroundColour=function()return daa end,getSize=function()
return d_a,_aa end,getTextColor=function()return _ba end,getTextColour=function()return _ba end,basalt_resize=function(aab,bab)d_a,_aa=aab,bab;_da()end,basalt_reposition=function(aab,bab)
b_a,c_a=aab,bab end,basalt_setVisible=function(aab)bba=aab end,drawBackgroundBox=function(aab,bab,cab,dab,_bb)for n=1,dab do
dda(aab,bab+ (n-1),ca[_bb]:rep(cab))end end,drawForegroundBox=function(aab,bab,cab,dab,_bb)
for n=1,dab do __b(aab,
bab+ (n-1),ca[_bb]:rep(cab))end end,drawTextBox=function(aab,bab,cab,dab,_bb)for n=1,dab do
cda(aab,bab+ (n-1),_bb:rep(cab))end end,writeText=function(aab,bab,cab,dab,_bb)
dab=dab or daa;_bb=_bb or _ba;cda(b_a,bab,cab)
dda(aab,bab,ca[dab]:rep(cab:len()))__b(aab,bab,ca[_bb]:rep(cab:len()))end,basalt_update=function()
if(
db~=nil)then for n=1,_aa do db:setText(b_a,c_a+ (n-1),cba[n])db:setBG(b_a,c_a+
(n-1),dba[n])
db:setFG(b_a,c_a+ (n-1),_ca[n])end end end,scroll=function(aab)if
type(aab)~="number"then
error("bad argument #1 (expected number, got "..type(aab)..")",2)end
if aab~=0 then local bab=bca
local cab=cca[_ba]local dab=cca[daa]
for newY=1,_aa do local _bb=newY+aab
if _bb>=1 and _bb<=_aa then
cba[newY]=cba[_bb]dba[newY]=dba[_bb]_ca[newY]=_ca[_bb]else cba[newY]=bab
_ca[newY]=cab;dba[newY]=dab end end end;if(bba)then ada()end end,isColor=function()return
db:getBasaltInstance().getBaseTerm().isColor()end,isColour=function()return
db:getBasaltInstance().getBaseTerm().isColor()end,write=function(aab)
aab=tostring(aab)if(bba)then
bda(aab,ca[_ba]:rep(aab:len()),ca[daa]:rep(aab:len()))end end,clearLine=function()
if
(bba)then cda(1,caa,(" "):rep(d_a))
dda(1,caa,ca[daa]:rep(d_a))__b(1,caa,ca[_ba]:rep(d_a))end;if(bba)then ada()end end,clear=function()
for n=1,_aa
do cda(1,n,(" "):rep(d_a))
dda(1,n,ca[daa]:rep(d_a))__b(1,n,ca[_ba]:rep(d_a))end;if(bba)then ada()end end,blit=function(aab,bab,cab)if
type(aab)~="string"then
error("bad argument #1 (expected string, got "..type(aab)..")",2)end;if type(bab)~="string"then
error(
"bad argument #2 (expected string, got "..type(bab)..")",2)end;if type(cab)~="string"then
error(
"bad argument #3 (expected string, got "..type(cab)..")",2)end
if
#bab~=#aab or#cab~=#aab then error("Arguments must be the same length",2)end;if(bba)then bda(aab,bab,cab)end end}return _ab end;_c.width=30;_c.height=12;local _d=dc(1,1,_c.width,_c.height)local ad
local bd=false;local cd={}
local function dd(b_a)local c_a,d_a=_d.getCursorPos()
local _aa,aaa=b_a:getAnchorPosition()local baa,caa=b_a:getSize()
if(_aa+c_a-1 >=1 and
_aa+c_a-1 <=_aa+baa-1 and d_a+aaa-1 >=1 and
d_a+aaa-1 <=aaa+caa-1)then
b_a.parent:setCursor(_d.getCursorBlink(),
_aa+c_a-1,d_a+aaa-1,_d.getTextColor())end end
local function __a(b_a,c_a,d_a,_aa,aaa)if(ad==nil)then return false end
if not(ad:isDead())then if not(bd)then
local baa,caa=b_a:getAbsolutePosition(b_a:getAnchorPosition(
nil,nil,true))ad:resume(c_a,d_a,_aa-baa+1,aaa-caa+1)
dd(b_a)end end end
local function a_a(b_a,c_a,d_a,_aa)if(ad==nil)then return false end
if not(ad:isDead())then if not(bd)then if(b_a.draw)then
ad:resume(c_a,d_a,_aa)dd(b_a)end end end end
bc={getType=function(b_a)return ac end,show=function(b_a)_c.show(b_a)
_d.setBackgroundColor(b_a.bgColor)_d.setTextColor(b_a.fgColor)
_d.basalt_setVisible(true)return b_a end,hide=function(b_a)
_c.hide(b_a)_d.basalt_setVisible(false)return b_a end,setPosition=function(b_a,c_a,d_a,_aa)
_c.setPosition(b_a,c_a,d_a,_aa)
_d.basalt_reposition(b_a:getAnchorPosition())return b_a end,setValuesByXMLData=function(b_a,c_a)
_c.setValuesByXMLData(b_a,c_a)if(_b("path",c_a)~=nil)then cc=_b("path",c_a)end
if(
_b("execute",c_a)~=nil)then if(_b("execute",c_a))then
if(cc~=nil)then b_a:execute(cc)end end end end,getBasaltWindow=function()return
_d end,getBasaltProcess=function()return ad end,setSize=function(b_a,c_a,d_a,_aa)_c.setSize(b_a,c_a,d_a,_aa)
_d.basalt_resize(b_a:getWidth(),b_a:getHeight())return b_a end,getStatus=function(b_a)if(ad~=nil)then return
ad:getStatus()end;return"inactive"end,execute=function(b_a,c_a,...)cc=
c_a or cc;ad=da:new(cc,_d,...)
_d.setBackgroundColor(colors.black)_d.setTextColor(colors.white)_d.clear()
_d.setCursorPos(1,1)_d.setBackgroundColor(b_a.bgColor)
_d.setTextColor(b_a.fgColor)_d.basalt_setVisible(true)ad:resume()bd=false
if
(b_a.parent~=nil)then b_a.parent:addEvent("mouse_click",b_a)
b_a.parent:addEvent("mouse_up",b_a)b_a.parent:addEvent("mouse_drag",b_a)
b_a.parent:addEvent("mouse_scroll",b_a)b_a.parent:addEvent("key",b_a)
b_a.parent:addEvent("key_up",b_a)b_a.parent:addEvent("char",b_a)
b_a.parent:addEvent("other_event",b_a)end;return b_a end,stop=function(b_a)if(
ad~=nil)then
if not(ad:isDead())then ad:resume("terminate")if(ad:isDead())then
if(
b_a.parent~=nil)then b_a.parent:setCursor(false)end end end end
b_a.parent:removeEvents(b_a)return b_a end,pause=function(b_a,c_a)bd=
c_a or(not bd)
if(ad~=nil)then if not(ad:isDead())then if not(bd)then
b_a:injectEvents(cd)cd={}end end end;return b_a end,isPaused=function(b_a)return
bd end,injectEvent=function(b_a,c_a,d_a,_aa,aaa,baa,caa)
if(ad~=nil)then
if not(ad:isDead())then if(bd==false)or(caa)then
ad:resume(c_a,d_a,_aa,aaa,baa)else
table.insert(cd,{event=c_a,args={d_a,_aa,aaa,baa}})end end end;return b_a end,getQueuedEvents=function(b_a)return
cd end,updateQueuedEvents=function(b_a,c_a)cd=c_a or cd;return b_a end,injectEvents=function(b_a,c_a)if(ad~=nil)then
if not
(ad:isDead())then for d_a,_aa in pairs(c_a)do
ad:resume(_aa.event,table.unpack(_aa.args))end end end;return b_a end,mouseHandler=function(b_a,c_a,d_a,_aa)
if
(_c.mouseHandler(b_a,c_a,d_a,_aa))then __a(b_a,"mouse_click",c_a,d_a,_aa)return true end;return false end,mouseUpHandler=function(b_a,c_a,d_a,_aa)
if
(_c.mouseUpHandler(b_a,c_a,d_a,_aa))then __a(b_a,"mouse_up",c_a,d_a,_aa)return true end;return false end,scrollHandler=function(b_a,c_a,d_a,_aa)
if
(_c.scrollHandler(b_a,c_a,d_a,_aa))then __a(b_a,"mouse_scroll",c_a,d_a,_aa)return true end;return false end,dragHandler=function(b_a,c_a,d_a,_aa)
if
(_c.dragHandler(b_a,c_a,d_a,_aa))then __a(b_a,"mouse_drag",c_a,d_a,_aa)return true end;return false end,keyHandler=function(b_a,c_a,d_a)if
(_c.keyHandler(b_a,c_a,d_a))then a_a(b_a,"key",c_a,d_a)return true end;return
false end,keyUpHandler=function(b_a,c_a)if
(_c.keyUpHandler(b_a,c_a))then a_a(b_a,"key_up",c_a)return true end
return false end,charHandler=function(b_a,c_a)if
(_c.charHandler(b_a,c_a))then a_a(b_a,"char",c_a)return true end
return false end,getFocusHandler=function(b_a)
_c.getFocusHandler(b_a)
if(ad~=nil)then
if not(ad:isDead())then
if not(bd)then
if(b_a.parent~=nil)then
local c_a,d_a=_d.getCursorPos()local _aa,aaa=b_a:getAnchorPosition()
if(b_a.parent~=nil)then
local baa,caa=b_a:getSize()
if
(_aa+c_a-1 >=1 and _aa+c_a-1 <=_aa+baa-1 and
d_a+aaa-1 >=1 and d_a+aaa-1 <=aaa+caa-1)then
b_a.parent:setCursor(_d.getCursorBlink(),_aa+c_a-1,d_a+aaa-1,_d.getTextColor())end end end end end end end,loseFocusHandler=function(b_a)
_c.loseFocusHandler(b_a)
if(ad~=nil)then if not(ad:isDead())then if(b_a.parent~=nil)then
b_a.parent:setCursor(false)end end end end,eventHandler=function(b_a,c_a,d_a,_aa,aaa,baa)
if
(_c.eventHandler(b_a,c_a,d_a,_aa,aaa,baa))then if(ad==nil)then return end
if(c_a=="dynamicValueEvent")then local caa,daa=_d.getSize()
local _ba,aba=b_a:getSize()
if(caa~=_ba)or(daa~=aba)then _d.basalt_resize(_ba,aba)if not
(ad:isDead())then ad:resume("term_resize")end end
_d.basalt_reposition(b_a:getAnchorPosition())end
if not(ad:isDead())then
if not(bd)then if(c_a~="terminate")then
ad:resume(c_a,d_a,_aa,aaa,baa)end
if(b_a:isFocused())then
local caa,daa=b_a:getAnchorPosition()local _ba,aba=_d.getCursorPos()
if(b_a.parent~=nil)then
local bba,cba=b_a:getSize()
if
(caa+_ba-1 >=1 and caa+_ba-1 <=caa+bba-1 and
aba+daa-1 >=1 and aba+daa-1 <=daa+cba-1)then
b_a.parent:setCursor(_d.getCursorBlink(),caa+_ba-1,aba+daa-1,_d.getTextColor())end end;if(c_a=="terminate")then ab(b_a:isFocused())ad:resume(c_a)
b_a.parent:setCursor(false)return true end end else
table.insert(cd,{event=c_a,args={d_a,_aa,aaa,baa}})end end;return false end end,draw=function(b_a)
if
(_c.draw(b_a))then
if(b_a.parent~=nil)then local c_a,d_a=b_a:getAnchorPosition()
local _aa,aaa=b_a:getSize()_d.basalt_reposition(c_a,d_a)_d.basalt_update()end end end,init=function(b_a)
b_a.bgColor=b_a.parent:getTheme("ProgramBG")end}return setmetatable(bc,_c)end
end; 
project['objects']['Progressbar'] = function(...)local c=require("Object")
local d=require("utils").getValueFromXML
return
function(_a)local aa=c(_a)local ba="Progressbar"local ca=0;aa:setZIndex(5)
aa:setValue(false)aa.width=25;aa.height=1;local da;local _b=""local ab=colors.white;local bb=""local cb=0
local db={init=function(_c)
_c.bgColor=_c.parent:getTheme("ProgressbarBG")_c.fgColor=_c.parent:getTheme("ProgressbarText")
da=_c.parent:getTheme("ProgressbarActiveBG")end,getType=function(_c)return
ba end,setValuesByXMLData=function(_c,ac)aa.setValuesByXMLData(_c,ac)if(d("direction",ac)~=
nil)then cb=d("direction",ac)end
if(
d("progressColor",ac)~=nil)then da=colors[d("progressColor",ac)]end
if(d("progressSymbol",ac)~=nil)then _b=d("progressSymbol",ac)end;if(d("backgroundSymbol",ac)~=nil)then
bb=d("backgroundSymbol",ac)end
if
(d("progressSymbolColor",ac)~=nil)then ab=colors[d("progressSymbolColor",ac)]end;if(d("onDone",ac)~=nil)then
_c:generateXMLEventFunction(_c.onProgressDone,d("onDone",ac))end;return _c end,setDirection=function(_c,ac)
cb=ac;_c:updateDraw()return _c end,setProgressBar=function(_c,ac,bc,cc)da=ac or da
_b=bc or _b;ab=cc or ab;_c:updateDraw()return _c end,setBackgroundSymbol=function(_c,ac)
bb=ac:sub(1,1)_c:updateDraw()return _c end,setProgress=function(_c,ac)if
(ac>=0)and(ac<=100)and(ca~=ac)then ca=ac;_c:setValue(ca)if(ca==100)then
_c:progressDoneHandler()end end
_c:updateDraw()return _c end,getProgress=function(_c)return
ca end,onProgressDone=function(_c,ac)_c:registerEvent("progress_done",ac)
return _c end,progressDoneHandler=function(_c)
_c:sendEvent("progress_done",_c)end,draw=function(_c)
if(aa.draw(_c))then
if(_c.parent~=nil)then
local ac,bc=_c:getAnchorPosition()local cc,dc=_c:getSize()if(_c.bgColor~=false)then
_c.parent:drawBackgroundBox(ac,bc,cc,dc,_c.bgColor)end;if(bb~="")then
_c.parent:drawTextBox(ac,bc,cc,dc,bb)end;if(_c.fgColor~=false)then
_c.parent:drawForegroundBox(ac,bc,cc,dc,_c.fgColor)end
if(cb==1)then
_c.parent:drawBackgroundBox(ac,bc,cc,dc/100 *ca,da)
_c.parent:drawForegroundBox(ac,bc,cc,dc/100 *ca,ab)
_c.parent:drawTextBox(ac,bc,cc,dc/100 *ca,_b)elseif(cb==2)then
_c.parent:drawBackgroundBox(ac,bc+math.ceil(dc-dc/100 *ca),cc,
dc/100 *ca,da)
_c.parent:drawForegroundBox(ac,bc+math.ceil(dc-dc/100 *ca),cc,dc/
100 *ca,ab)
_c.parent:drawTextBox(ac,bc+math.ceil(dc-dc/100 *ca),cc,
dc/100 *ca,_b)elseif(cb==3)then
_c.parent:drawBackgroundBox(ac+math.ceil(cc-cc/100 *ca),bc,
cc/100 *ca,dc,da)
_c.parent:drawForegroundBox(ac+math.ceil(cc-cc/100 *ca),bc,
cc/100 *ca,dc,ab)
_c.parent:drawTextBox(ac+math.ceil(cc-cc/100 *ca),bc,cc/100 *
ca,dc,_b)else
_c.parent:drawBackgroundBox(ac,bc,cc/100 *ca,dc,da)
_c.parent:drawForegroundBox(ac,bc,cc/100 *ca,dc,ab)
_c.parent:drawTextBox(ac,bc,cc/100 *ca,dc,_b)end end end end}return setmetatable(db,aa)end
end; 
project['objects']['Radio'] = function(...)local d=require("Object")local _a=require("utils")
local aa=_a.getValueFromXML
return
function(ba)local ca=d(ba)local da="Radio"ca.width=8;ca:setZIndex(5)local _b={}local ab;local bb;local cb
local db;local _c;local ac;local bc=true;local cc="\7"local dc="left"
local _d={getType=function(ad)return da end,setValuesByXMLData=function(ad,bd)
ca.setValuesByXMLData(ad,bd)if(aa("selectionBG",bd)~=nil)then
ab=colors[aa("selectionBG",bd)]end;if(aa("selectionFG",bd)~=nil)then
bb=colors[aa("selectionFG",bd)]end;if(aa("boxBG",bd)~=nil)then
cb=colors[aa("boxBG",bd)]end;if(aa("inactiveBoxBG",bd)~=nil)then
_c=colors[aa("inactiveBoxBG",bd)]end;if(aa("inactiveBoxFG",bd)~=nil)then
ac=colors[aa("inactiveBoxFG",bd)]end;if(aa("boxFG",bd)~=nil)then
db=colors[aa("boxFG",bd)]end;if(aa("symbol",bd)~=nil)then
cc=aa("symbol",bd)end
if(bd["item"]~=nil)then local cd=bd["item"]if
(cd.properties~=nil)then cd={cd}end;for dd,__a in pairs(cd)do
ad:addItem(aa("text",__a),aa("x",__a),aa("y",__a),colors[aa("bg",__a)],colors[aa("fg",__a)])end end;return ad end,addItem=function(ad,bd,cd,dd,__a,a_a,...)
table.insert(_b,{x=
cd or 1,y=dd or 1,text=bd,bgCol=__a or ad.bgColor,fgCol=a_a or ad.fgColor,args={...}})if(#_b==1)then ad:setValue(_b[1])end
ad:updateDraw()return ad end,getAll=function(ad)return
_b end,removeItem=function(ad,bd)table.remove(_b,bd)ad:updateDraw()return ad end,getItem=function(ad,bd)return
_b[bd]end,getItemIndex=function(ad)local bd=ad:getValue()for cd,dd in pairs(_b)do
if(dd==bd)then return cd end end end,clear=function(ad)
_b={}ad:setValue({})ad:updateDraw()return ad end,getItemCount=function(ad)return
#_b end,editItem=function(ad,bd,cd,dd,__a,a_a,b_a,...)table.remove(_b,bd)
table.insert(_b,bd,{x=dd or 1,y=__a or 1,text=cd,bgCol=a_a or
ad.bgColor,fgCol=b_a or ad.fgColor,args={...}})ad:updateDraw()return ad end,selectItem=function(ad,bd)ad:setValue(
_b[bd]or{})ad:updateDraw()return ad end,setActiveSymbol=function(ad,bd)
cc=bd:sub(1,1)ad:updateDraw()return ad end,setSelectedItem=function(ad,bd,cd,dd,__a,a_a)ab=bd or ab
bb=cd or bb;cb=dd or cb;db=__a or db;bc=a_a~=nil and a_a or true
ad:updateDraw()return ad end,mouseHandler=function(ad,bd,cd,dd)
if(#_b>
0)then
local __a,a_a=ad:getAbsolutePosition(ad:getAnchorPosition())
for b_a,c_a in pairs(_b)do
if(__a+c_a.x-1 <=cd)and(
__a+c_a.x-1 +c_a.text:len()+1 >=cd)and(
a_a+c_a.y-1 ==dd)then ad:setValue(c_a)
local d_a=ad:getEventSystem():sendEvent("mouse_click",ad,"mouse_click",bd,cd,dd)if(d_a==false)then return d_a end;if(ad.parent~=nil)then
ad.parent:setFocusedObject(ad)end;ad:updateDraw()return true end end end;return false end,draw=function(ad)
if(
ad.parent~=nil)then local bd,cd=ad:getAnchorPosition()
for dd,__a in pairs(_b)do
if
(__a==ad:getValue())then if(dc=="left")then
ad.parent:writeText(__a.x+bd-1,__a.y+cd-1,cc,cb,db)
ad.parent:writeText(__a.x+2 +bd-1,__a.y+cd-1,__a.text,ab,bb)end else
ad.parent:drawBackgroundBox(
__a.x+bd-1,__a.y+cd-1,1,1,_c or ad.bgColor)
ad.parent:writeText(__a.x+2 +bd-1,__a.y+cd-1,__a.text,__a.bgCol,__a.fgCol)end end;return true end end,init=function(ad)
ad.bgColor=ad.parent:getTheme("MenubarBG")ad.fgColor=ad.parent:getTheme("MenubarFG")
ab=ad.parent:getTheme("SelectionBG")bb=ad.parent:getTheme("SelectionText")
cb=ad.parent:getTheme("MenubarBG")db=ad.parent:getTheme("MenubarText")
ad.parent:addEvent("mouse_click",ad)end}return setmetatable(_d,ca)end
end; 
project['objects']['Scrollbar'] = function(...)local c=require("Object")
local d=require("utils").getValueFromXML
return
function(_a)local aa=c(_a)local ba="Scrollbar"aa.width=1;aa.height=8;aa:setValue(1)
aa:setZIndex(2)local ca="vertical"local da=" "local _b;local ab="\127"local bb=aa.height;local cb=1;local db=1
local function _c(bc,cc,dc,_d)
local ad,bd=bc:getAbsolutePosition(bc:getAnchorPosition())local cd,dd=bc:getSize()
if(ca=="horizontal")then for _index=0,cd do
if
(ad+_index==dc)and(bd<=_d)and(bd+dd>_d)then
cb=math.min(_index+1,cd- (db-1))bc:setValue(bb/cd* (cb))bc:updateDraw()end end end
if(ca=="vertical")then for _index=0,dd do
if
(bd+_index==_d)and(ad<=dc)and(ad+cd>dc)then cb=math.min(_index+1,dd- (db-1))
bc:setValue(bb/dd* (cb))bc:updateDraw()end end end end
local ac={getType=function(bc)return ba end,setSymbol=function(bc,cc)da=cc:sub(1,1)bc:updateDraw()return bc end,setValuesByXMLData=function(bc,cc)
aa.setValuesByXMLData(bc,cc)
if(d("maxValue",cc)~=nil)then bb=d("maxValue",cc)end;if(d("backgroundSymbol",cc)~=nil)then
ab=d("backgroundSymbol",cc):sub(1,1)end;if(d("symbol",cc)~=nil)then
da=d("symbol",cc):sub(1,1)end;if(d("barType",cc)~=nil)then
ca=d("barType",cc):lower()end;if(d("symbolSize",cc)~=nil)then
bc:setSymbolSize(d("symbolSize",cc))end;if(d("symbolColor",cc)~=nil)then
_b=colors[d("symbolColor",cc)]end;if(d("index",cc)~=nil)then
bc:setIndex(d("index",cc))end end,setIndex=function(bc,cc)
cb=cc;if(cb<1)then cb=1 end;local dc,_d=bc:getSize()
cb=math.min(cb,(ca=="vertical"and _d or
dc)- (db-1))
bc:setValue(bb/ (ca=="vertical"and _d or dc)*cb)bc:updateDraw()return bc end,getIndex=function(bc)return
cb end,setSymbolSize=function(bc,cc)db=tonumber(cc)or 1;local dc,_d=bc:getSize()
if(ca==
"vertical")then
bc:setValue(cb-1 * (bb/ (_d- (db-1)))-
(bb/ (_d- (db-1))))elseif(ca=="horizontal")then
bc:setValue(cb-1 * (bb/ (dc- (db-1)))- (bb/ (dc-
(db-1))))end;bc:updateDraw()return bc end,setMaxValue=function(bc,cc)
bb=cc;bc:updateDraw()return bc end,setBackgroundSymbol=function(bc,cc)
ab=string.sub(cc,1,1)bc:updateDraw()return bc end,setSymbolColor=function(bc,cc)_b=cc
bc:updateDraw()return bc end,setBarType=function(bc,cc)ca=cc:lower()bc:updateDraw()
return bc end,mouseHandler=function(bc,cc,dc,_d)if(aa.mouseHandler(bc,cc,dc,_d))then
_c(bc,cc,dc,_d)return true end;return false end,dragHandler=function(bc,cc,dc,_d)if
(aa.dragHandler(bc,cc,dc,_d))then _c(bc,cc,dc,_d)return true end;return false end,scrollHandler=function(bc,cc,dc,_d)
if
(aa.scrollHandler(bc,cc,dc,_d))then local ad,bd=bc:getSize()cb=cb+cc;if(cb<1)then cb=1 end
cb=math.min(cb,(
ca=="vertical"and bd or ad)- (db-1))
bc:setValue(bb/ (ca=="vertical"and bd or ad)*cb)bc:updateDraw()end end,draw=function(bc)
if
(aa.draw(bc))then
if(bc.parent~=nil)then local cc,dc=bc:getAnchorPosition()
local _d,ad=bc:getSize()
if(ca=="horizontal")then
bc.parent:writeText(cc,dc,ab:rep(cb-1),bc.bgColor,bc.fgColor)
bc.parent:writeText(cc+cb-1,dc,da:rep(db),_b,_b)
bc.parent:writeText(cc+cb+db-1,dc,ab:rep(_d- (cb+db-1)),bc.bgColor,bc.fgColor)end
if(ca=="vertical")then
for n=0,ad-1 do
if(cb==n+1)then for curIndexOffset=0,math.min(db-1,ad)do
bc.parent:writeText(cc,dc+n+curIndexOffset,da,_b,_b)end else if
(n+1 <cb)or(n+1 >cb-1 +db)then
bc.parent:writeText(cc,dc+n,ab,bc.bgColor,bc.fgColor)end end end end end end end,init=function(bc)
bc.bgColor=bc.parent:getTheme("ScrollbarBG")bc.fgColor=bc.parent:getTheme("ScrollbarText")
_b=bc.parent:getTheme("ScrollbarSymbolColor")bc.parent:addEvent("mouse_click",bc)
bc.parent:addEvent("mouse_drag",bc)bc.parent:addEvent("mouse_scroll",bc)end}return setmetatable(ac,aa)end
end; 
project['objects']['Slider'] = function(...)local d=require("Object")local _a=require("basaltLogs")
local aa=require("utils").getValueFromXML
return
function(ba)local ca=d(ba)local da="Slider"ca.width=8;ca.height=1;ca:setValue(1)
local _b="horizontal"local ab=" "local bb;local cb="\140"local db=ca.width;local _c=1;local ac=1
local function bc(dc,_d,ad,bd)
local cd,dd=dc:getAbsolutePosition(dc:getAnchorPosition())local __a,a_a=dc:getSize()
if(_b=="horizontal")then for _index=0,__a do
if
(cd+_index==ad)and(dd<=bd)and(dd+a_a>bd)then
_c=math.min(_index+1,__a- (ac-1))dc:setValue(db/__a* (_c))dc:updateDraw()end end end
if(_b=="vertical")then for _index=0,a_a do
if
(dd+_index==bd)and(cd<=ad)and(cd+__a>ad)then _c=math.min(_index+1,a_a- (ac-1))
dc:setValue(db/a_a* (_c))dc:updateDraw()end end end end
local cc={getType=function(dc)return da end,setSymbol=function(dc,_d)ab=_d:sub(1,1)dc:updateDraw()return dc end,setValuesByXMLData=function(dc,_d)
ca.setValuesByXMLData(dc,_d)
if(aa("maxValue",_d)~=nil)then db=aa("maxValue",_d)end;if(aa("backgroundSymbol",_d)~=nil)then
cb=aa("backgroundSymbol",_d):sub(1,1)end;if(aa("barType",_d)~=nil)then
_b=aa("barType",_d):lower()end;if(aa("symbol",_d)~=nil)then
ab=aa("symbol",_d):sub(1,1)end;if(aa("symbolSize",_d)~=nil)then
dc:setSymbolSize(aa("symbolSize",_d))end;if(aa("symbolColor",_d)~=nil)then
bb=colors[aa("symbolColor",_d)]end;if(aa("index",_d)~=nil)then
dc:setIndex(aa("index",_d))end end,setIndex=function(dc,_d)
_c=_d;if(_c<1)then _c=1 end;local ad,bd=dc:getSize()
_c=math.min(_c,(_b=="vertical"and bd or
ad)- (ac-1))
dc:setValue(db/ (_b=="vertical"and bd or ad)*_c)dc:updateDraw()return dc end,getIndex=function(dc)return
_c end,setSymbolSize=function(dc,_d)ac=tonumber(_d)or 1
if(_b=="vertical")then
dc:setValue(_c-1 * (db/
(h- (ac-1)))- (db/ (h- (ac-1))))elseif(_b=="horizontal")then
dc:setValue(_c-1 * (db/ (w- (ac-1)))- (db/
(w- (ac-1))))end;dc:updateDraw()return dc end,setMaxValue=function(dc,_d)
db=_d;return dc end,setBackgroundSymbol=function(dc,_d)cb=string.sub(_d,1,1)
dc:updateDraw()return dc end,setSymbolColor=function(dc,_d)bb=_d;dc:updateDraw()return dc end,setBarType=function(dc,_d)
_b=_d:lower()dc:updateDraw()return dc end,mouseHandler=function(dc,_d,ad,bd)if
(ca.mouseHandler(dc,_d,ad,bd))then bc(dc,_d,ad,bd)return true end;return false end,dragHandler=function(dc,_d,ad,bd)if
(ca.dragHandler(dc,_d,ad,bd))then bc(dc,_d,ad,bd)return true end;return false end,scrollHandler=function(dc,_d,ad,bd)
if
(ca.scrollHandler(dc,_d,ad,bd))then local cd,dd=dc:getSize()_c=_c+_d;if(_c<1)then _c=1 end
_c=math.min(_c,(
_b=="vertical"and dd or cd)- (ac-1))
dc:setValue(db/ (_b=="vertical"and dd or cd)*_c)dc:updateDraw()return true end;return false end,draw=function(dc)
if
(ca.draw(dc))then
if(dc.parent~=nil)then local _d,ad=dc:getAnchorPosition()
local bd,cd=dc:getSize()
if(_b=="horizontal")then
dc.parent:writeText(_d,ad,cb:rep(_c-1),dc.bgColor,dc.fgColor)
dc.parent:writeText(_d+_c-1,ad,ab:rep(ac),bb,bb)
dc.parent:writeText(_d+_c+ac-1,ad,cb:rep(bd- (_c+ac-1)),dc.bgColor,dc.fgColor)end
if(_b=="vertical")then
for n=0,cd-1 do
if(_c==n+1)then for curIndexOffset=0,math.min(ac-1,cd)do
dc.parent:writeText(_d,ad+n+curIndexOffset,ab,bb,bb)end else if
(n+1 <_c)or(n+1 >_c-1 +ac)then
dc.parent:writeText(_d,ad+n,cb,dc.bgColor,dc.fgColor)end end end end end end end,init=function(dc)
dc.bgColor=dc.parent:getTheme("SliderBG")dc.fgColor=dc.parent:getTheme("SliderText")
bb=dc.parent:getTheme("SliderSymbolColor")dc.parent:addEvent("mouse_click",dc)
dc.parent:addEvent("mouse_drag",dc)dc.parent:addEvent("mouse_scroll",dc)end}return setmetatable(cc,ca)end
end; 
project['objects']['Switch'] = function(...)local c=require("Object")
local d=require("utils").getValueFromXML
return
function(_a)local aa=c(_a)local ba="Switch"aa.width=2;aa.height=1
aa.bgColor=colors.lightGray;aa.fgColor=colors.gray;aa:setValue(false)aa:setZIndex(5)
local ca=colors.black;local da=colors.red;local _b=colors.green
local ab={getType=function(bb)return ba end,setSymbolColor=function(bb,cb)ca=cb
bb:updateDraw()return bb end,setActiveBackground=function(bb,cb)_b=cb;bb:updateDraw()return bb end,setInactiveBackground=function(bb,cb)
da=cb;bb:updateDraw()return bb end,setValuesByXMLData=function(bb,cb)
aa.setValuesByXMLData(bb,cb)if(d("inactiveBG",cb)~=nil)then
da=colors[d("inactiveBG",cb)]end;if(d("activeBG",cb)~=nil)then
_b=colors[d("activeBG",cb)]end;if(d("symbolColor",cb)~=nil)then
ca=colors[d("symbolColor",cb)]end end,mouseHandler=function(bb,cb,db,_c)
if
(aa.mouseHandler(bb,cb,db,_c))then
local ac,bc=bb:getAbsolutePosition(bb:getAnchorPosition())bb:setValue(not bb:getValue())
bb:updateDraw()return true end end,draw=function(bb)
if
(aa.draw(bb))then
if(bb.parent~=nil)then local cb,db=bb:getAnchorPosition()
local _c,ac=bb:getSize()
bb.parent:drawBackgroundBox(cb,db,_c,ac,bb.bgColor)
if(bb:getValue())then
bb.parent:drawBackgroundBox(cb,db,1,ac,_b)bb.parent:drawBackgroundBox(cb+1,db,1,ac,ca)else
bb.parent:drawBackgroundBox(cb,db,1,ac,ca)bb.parent:drawBackgroundBox(cb+1,db,1,ac,da)end end end end,init=function(bb)
bb.bgColor=bb.parent:getTheme("SwitchBG")bb.fgColor=bb.parent:getTheme("SwitchText")
ca=bb.parent:getTheme("SwitchBGSymbol")da=bb.parent:getTheme("SwitchInactive")
_b=bb.parent:getTheme("SwitchActive")bb.parent:addEvent("mouse_click",bb)end}return setmetatable(ab,aa)end
end; 
project['objects']['Textfield'] = function(...)local aa=require("Object")local ba=require("tHex")
local ca=require("basaltLogs")local da=require("utils").getValueFromXML;local _b=string.rep
return
function(ab)
local bb=aa(ab)local cb="Textfield"local db,_c,ac,bc=1,1,1,1;local cc={""}local dc={""}local _d={""}local ad={}local bd={}
bb.width=30;bb.height=12;bb:setZIndex(5)
local function cd(b_a,c_a)local d_a={}
if(b_a:len()>0)then
for _aa in
string.gmatch(b_a,c_a)do local aaa,baa=string.find(b_a,_aa)
if(aaa~=nil)and(baa~=nil)then
table.insert(d_a,aaa)table.insert(d_a,baa)
local caa=string.sub(b_a,1,(aaa-1))local daa=string.sub(b_a,baa+1,b_a:len())b_a=caa..
(":"):rep(_aa:len())..daa end end end;return d_a end
local function dd(b_a,c_a)c_a=c_a or bc
local d_a=ba[b_a.fgColor]:rep(_d[c_a]:len())
local _aa=ba[b_a.bgColor]:rep(dc[c_a]:len())
for aaa,baa in pairs(bd)do local caa=cd(cc[c_a],baa[1])
if(#caa>0)then
for x=1,#caa/2 do local daa=x*2 -1;if(
baa[2]~=nil)then
d_a=d_a:sub(1,caa[daa]-1)..ba[baa[2] ]:rep(caa[daa+1]-
(caa[daa]-1))..
d_a:sub(caa[daa+1]+1,d_a:len())end;if
(baa[3]~=nil)then
_aa=_aa:sub(1,caa[daa]-1)..

ba[baa[3] ]:rep(caa[daa+1]- (caa[daa]-1)).._aa:sub(caa[daa+1]+1,_aa:len())end end end end
for aaa,baa in pairs(ad)do
for caa,daa in pairs(baa)do local _ba=cd(cc[c_a],daa)
if(#_ba>0)then for x=1,#_ba/2 do local aba=x*2 -1
d_a=d_a:sub(1,
_ba[aba]-1)..

ba[aaa]:rep(_ba[aba+1]- (_ba[aba]-1))..d_a:sub(_ba[aba+1]+1,d_a:len())end end end end;_d[c_a]=d_a;dc[c_a]=_aa;b_a:updateDraw()end;local function __a(b_a)for n=1,#cc do dd(b_a,n)end end
local a_a={getType=function(b_a)return cb end,setBackground=function(b_a,c_a)
bb.setBackground(b_a,c_a)__a(b_a)return b_a end,setForeground=function(b_a,c_a)
bb.setForeground(b_a,c_a)__a(b_a)return b_a end,setValuesByXMLData=function(b_a,c_a)
bb.setValuesByXMLData(b_a,c_a)
if(c_a["lines"]~=nil)then local d_a=c_a["lines"]["line"]if
(d_a.properties~=nil)then d_a={d_a}end;for _aa,aaa in pairs(d_a)do
b_a:addLine(aaa:value())end end
if(c_a["keywords"]~=nil)then
for d_a,_aa in pairs(c_a["keywords"])do
if(colors[d_a]~=nil)then
local aaa=_aa;if(aaa.properties~=nil)then aaa={aaa}end;local baa={}
for caa,daa in pairs(aaa)do
local _ba=daa["keyword"]if(daa["keyword"].properties~=nil)then
_ba={daa["keyword"]}end;for aba,bba in pairs(_ba)do
table.insert(baa,bba:value())end end;b_a:addKeywords(colors[d_a],baa)end end end
if(c_a["rules"]~=nil)then
if(c_a["rules"]["rule"]~=nil)then
local d_a=c_a["rules"]["rule"]if(c_a["rules"]["rule"].properties~=nil)then
d_a={c_a["rules"]["rule"]}end
for _aa,aaa in pairs(d_a)do if(da("pattern",aaa)~=nil)then
b_a:addRule(da("pattern",aaa),colors[da("fg",aaa)],colors[da("bg",aaa)])end end end end end,getLines=function(b_a)return
cc end,getLine=function(b_a,c_a)return cc[c_a]end,editLine=function(b_a,c_a,d_a)
cc[c_a]=d_a or cc[c_a]b_a:updateDraw()return b_a end,clear=function(b_a)
cc={""}dc={""}_d={""}db,_c,ac,bc=1,1,1,1;b_a:updateDraw()return b_a end,addLine=function(b_a,c_a,d_a)
if(
c_a~=nil)then if(#cc==1)and(cc[1]=="")then cc[1]=c_a
dc[1]=ba[b_a.bgColor]:rep(c_a:len())_d[1]=ba[b_a.fgColor]:rep(c_a:len())
return b_a end
if(d_a~=nil)then
table.insert(cc,d_a,c_a)
table.insert(dc,d_a,ba[b_a.bgColor]:rep(c_a:len()))
table.insert(_d,ba[b_a.fgColor]:rep(c_a:len()))else table.insert(cc,c_a)
table.insert(dc,ba[b_a.bgColor]:rep(c_a:len()))
table.insert(_d,ba[b_a.fgColor]:rep(c_a:len()))end end;b_a:updateDraw()return b_a end,addKeywords=function(b_a,c_a,d_a)if(
ad[c_a]==nil)then ad[c_a]={}end;for _aa,aaa in pairs(d_a)do
table.insert(ad[c_a],aaa)end;b_a:updateDraw()return b_a end,addRule=function(b_a,c_a,d_a,_aa)
table.insert(bd,{c_a,d_a,_aa})b_a:updateDraw()return b_a end,editRule=function(b_a,c_a,d_a,_aa)for aaa,baa in
pairs(bd)do
if(baa[1]==c_a)then bd[aaa][2]=d_a;bd[aaa][3]=_aa end end;b_a:updateDraw()return b_a end,removeRule=function(b_a,c_a)
for d_a,_aa in
pairs(bd)do if(_aa[1]==c_a)then table.remove(bd,d_a)end end;b_a:updateDraw()return b_a end,setKeywords=function(b_a,c_a,d_a)
ad[c_a]=d_a;b_a:updateDraw()return b_a end,removeLine=function(b_a,c_a)table.remove(cc,c_a or
#cc)
if(#cc<=0)then table.insert(cc,"")end;b_a:updateDraw()return b_a end,getTextCursor=function(b_a)return
ac,bc end,getFocusHandler=function(b_a)bb.getFocusHandler(b_a)
if(b_a.parent~=nil)then
local c_a,d_a=b_a:getAnchorPosition()if(b_a.parent~=nil)then
b_a.parent:setCursor(true,c_a+ac-_c,d_a+bc-db,b_a.fgColor)end end end,loseFocusHandler=function(b_a)
bb.loseFocusHandler(b_a)
if(b_a.parent~=nil)then b_a.parent:setCursor(false)end end,keyHandler=function(b_a,c_a)
if
(bb.keyHandler(b_a,event,c_a))then local d_a,_aa=b_a:getAnchorPosition()local aaa,baa=b_a:getSize()
if(c_a==
keys.backspace)then
if(cc[bc]=="")then
if(bc>1)then table.remove(cc,bc)
table.remove(_d,bc)table.remove(dc,bc)ac=cc[bc-1]:len()+1;_c=
ac-aaa+1;if(_c<1)then _c=1 end;bc=bc-1 end elseif(ac<=1)then
if(bc>1)then ac=cc[bc-1]:len()+1;_c=ac-aaa+1
if(_c<1)then _c=1 end;cc[bc-1]=cc[bc-1]..cc[bc]
_d[bc-1]=_d[bc-1].._d[bc]dc[bc-1]=dc[bc-1]..dc[bc]table.remove(cc,bc)
table.remove(_d,bc)table.remove(dc,bc)bc=bc-1 end else
cc[bc]=cc[bc]:sub(1,ac-2)..cc[bc]:sub(ac,cc[bc]:len())
_d[bc]=_d[bc]:sub(1,ac-2).._d[bc]:sub(ac,_d[bc]:len())
dc[bc]=dc[bc]:sub(1,ac-2)..dc[bc]:sub(ac,dc[bc]:len())if(ac>1)then ac=ac-1 end
if(_c>1)then if(ac<_c)then _c=_c-1 end end end;if(bc<db)then db=db-1 end;dd(b_a)b_a:setValue("")end
if(c_a==keys.delete)then
if(ac>cc[bc]:len())then
if(cc[bc+1]~=nil)then cc[bc]=cc[bc]..
cc[bc+1]table.remove(cc,bc+1)
table.remove(dc,bc+1)table.remove(_d,bc+1)end else
cc[bc]=cc[bc]:sub(1,ac-1)..cc[bc]:sub(ac+1,cc[bc]:len())
_d[bc]=_d[bc]:sub(1,ac-1).._d[bc]:sub(ac+1,_d[bc]:len())
dc[bc]=dc[bc]:sub(1,ac-1)..dc[bc]:sub(ac+1,dc[bc]:len())end;dd(b_a)end
if(c_a==keys.enter)then
table.insert(cc,bc+1,cc[bc]:sub(ac,cc[bc]:len()))
table.insert(_d,bc+1,_d[bc]:sub(ac,_d[bc]:len()))
table.insert(dc,bc+1,dc[bc]:sub(ac,dc[bc]:len()))cc[bc]=cc[bc]:sub(1,ac-1)
_d[bc]=_d[bc]:sub(1,ac-1)dc[bc]=dc[bc]:sub(1,ac-1)bc=bc+1;ac=1;_c=1;if(bc-db>=baa)then
db=db+1 end;b_a:setValue("")end
if(c_a==keys.up)then
if(bc>1)then bc=bc-1;if(ac>cc[bc]:len()+1)then ac=
cc[bc]:len()+1 end;if(_c>1)then if(ac<_c)then _c=ac-aaa+1;if(_c<1)then
_c=1 end end end;if(db>1)then if(
bc<db)then db=db-1 end end end end
if(c_a==keys.down)then
if(bc<#cc)then bc=bc+1;if(ac>cc[bc]:len()+1)then ac=
cc[bc]:len()+1 end;if(_c>1)then if(ac<_c)then _c=ac-aaa+1;if(_c<1)then
_c=1 end end end;if(bc>=
db+baa)then db=db+1 end end end
if(c_a==keys.right)then ac=ac+1;if(bc<#cc)then if(ac>cc[bc]:len()+1)then ac=1
bc=bc+1 end elseif(ac>cc[bc]:len())then
ac=cc[bc]:len()+1 end;if(ac<1)then ac=1 end;if
(ac<_c)or(ac>=aaa+_c)then _c=ac-aaa+1 end
if(_c<1)then _c=1 end end
if(c_a==keys.left)then ac=ac-1;if(ac>=1)then
if(ac<_c)or(ac>=aaa+_c)then _c=ac end end
if(bc>1)then if(ac<1)then bc=bc-1
ac=cc[bc]:len()+1;_c=ac-aaa+1 end end;if(ac<1)then ac=1 end;if(_c<1)then _c=1 end end;local caa=
(ac<=cc[bc]:len()and ac-1 or cc[bc]:len())- (_c-1)if(caa>
b_a.x+aaa-1)then caa=b_a.x+aaa-1 end;local daa=(
bc-db<baa and bc-db or bc-db-1)if(caa<1)then caa=0 end;b_a.parent:setCursor(true,
d_a+caa,_aa+daa,b_a.fgColor)
b_a:updateDraw()return true end end,charHandler=function(b_a,c_a)
if
(bb.charHandler(b_a,c_a))then local d_a,_aa=b_a:getAnchorPosition()local aaa,baa=b_a:getSize()
cc[bc]=cc[bc]:sub(1,
ac-1)..c_a..cc[bc]:sub(ac,cc[bc]:len())
_d[bc]=_d[bc]:sub(1,ac-1)..ba[b_a.fgColor]..
_d[bc]:sub(ac,_d[bc]:len())
dc[bc]=dc[bc]:sub(1,ac-1)..ba[b_a.bgColor]..
dc[bc]:sub(ac,dc[bc]:len())ac=ac+1;if(ac>=aaa+_c)then _c=_c+1 end;dd(b_a)
b_a:setValue("")local caa=
(ac<=cc[bc]:len()and ac-1 or cc[bc]:len())- (_c-1)if(caa>
b_a.x+aaa-1)then caa=b_a.x+aaa-1 end;local daa=(
bc-db<baa and bc-db or bc-db-1)if(caa<1)then caa=0 end;b_a.parent:setCursor(true,
d_a+caa,_aa+daa,b_a.fgColor)
b_a:updateDraw()return true end end,dragHandler=function(b_a,c_a,d_a,_aa)
if
(bb.dragHandler(b_a,c_a,d_a,_aa))then
local aaa,baa=b_a:getAbsolutePosition(b_a:getAnchorPosition())local caa,daa=b_a:getAnchorPosition()local _ba,aba=b_a:getSize()
if(cc[
_aa-baa+db]~=nil)then
if
(caa+_ba>caa+d_a- (aaa+1)+_c)and(caa<caa+d_a-aaa+_c)then
ac=d_a-aaa+_c;bc=_aa-baa+db;if(ac>cc[bc]:len())then
ac=cc[bc]:len()+1 end
if(ac<_c)then _c=ac-1;if(_c<1)then _c=1 end end;if(b_a.parent~=nil)then
b_a.parent:setCursor(true,caa+ac-_c,daa+bc-db,b_a.fgColor)end;b_a:updateDraw()end end;return true end end,scrollHandler=function(b_a,c_a,d_a,_aa)
if
(bb.scrollHandler(b_a,c_a,d_a,_aa))then
local aaa,baa=b_a:getAbsolutePosition(b_a:getAnchorPosition())local caa,daa=b_a:getAnchorPosition()local _ba,aba=b_a:getSize()
db=db+c_a;if(db>#cc- (aba-1))then db=#cc- (aba-1)end
if(db<1)then db=1 end
if(b_a.parent~=nil)then
if

(aaa+ac-_c>=aaa and aaa+ac-_c<aaa+_ba)and(baa+bc-db>=baa and baa+bc-db<baa+aba)then
b_a.parent:setCursor(true,caa+ac-_c,daa+bc-db,b_a.fgColor)else b_a.parent:setCursor(false)end end;b_a:updateDraw()return true end end,mouseHandler=function(b_a,c_a,d_a,_aa)
if
(bb.mouseHandler(b_a,c_a,d_a,_aa))then
local aaa,baa=b_a:getAbsolutePosition(b_a:getAnchorPosition())local caa,daa=b_a:getAnchorPosition()
if(cc[_aa-baa+db]~=nil)then ac=
d_a-aaa+_c;bc=_aa-baa+db;if(ac>cc[bc]:len())then ac=
cc[bc]:len()+1 end
if(ac<_c)then _c=ac-1;if(_c<1)then _c=1 end end end;if(b_a.parent~=nil)then
b_a.parent:setCursor(true,caa+ac-_c,daa+bc-db,b_a.fgColor)end;return true end end,eventHandler=function(b_a,c_a,d_a,_aa,aaa,baa)
if
(bb.eventHandler(b_a,c_a,d_a,_aa,aaa,baa))then
if(c_a=="paste")then
if(b_a:isFocused())then local caa,daa=b_a:getSize()
cc[bc]=
cc[bc]:sub(1,ac-1)..d_a..cc[bc]:sub(ac,cc[bc]:len())
_d[bc]=_d[bc]:sub(1,ac-1)..
ba[b_a.fgColor]:rep(d_a:len()).._d[bc]:sub(ac,_d[bc]:len())
dc[bc]=dc[bc]:sub(1,ac-1)..
ba[b_a.bgColor]:rep(d_a:len())..dc[bc]:sub(ac,dc[bc]:len())ac=ac+d_a:len()if(ac>=caa+_c)then _c=(ac+1)-caa end
local _ba,aba=b_a:getAnchorPosition()
b_a.parent:setCursor(true,_ba+ac-_c,aba+bc-db,b_a.fgColor)dd(b_a)b_a:updateDraw()end end end end,draw=function(b_a)
if
(bb.draw(b_a))then
if(b_a.parent~=nil)then local c_a,d_a=b_a:getAnchorPosition()
local _aa,aaa=b_a:getSize()
for n=1,aaa do local baa=""local caa=""local daa=""if(cc[n+db-1]~=nil)then baa=cc[n+db-1]
daa=_d[n+db-1]caa=dc[n+db-1]end
baa=baa:sub(_c,_aa+_c-1)caa=caa:sub(_c,_aa+_c-1)
daa=daa:sub(_c,_aa+_c-1)local _ba=_aa-baa:len()if(_ba<0)then _ba=0 end
baa=baa.._b(b_a.bgSymbol,_ba)caa=caa.._b(ba[b_a.bgColor],_ba)daa=daa..
_b(ba[b_a.fgColor],_ba)
b_a.parent:setText(c_a,d_a+n-1,baa)b_a.parent:setBG(c_a,d_a+n-1,caa)b_a.parent:setFG(c_a,
d_a+n-1,daa)end;if(b_a:isFocused())then local baa,caa=b_a:getAnchorPosition()
b_a.parent:setCursor(true,
baa+ac-_c,caa+bc-db,b_a.fgColor)end end end end,init=function(b_a)
b_a.bgColor=b_a.parent:getTheme("TextfieldBG")b_a.fgColor=b_a.parent:getTheme("TextfieldText")
b_a.parent:addEvent("mouse_click",b_a)b_a.parent:addEvent("mouse_scroll",b_a)
b_a.parent:addEvent("mouse_drag",b_a)b_a.parent:addEvent("key",b_a)
b_a.parent:addEvent("char",b_a)b_a.parent:addEvent("other_event",b_a)end}return setmetatable(a_a,bb)end
end; 
project['objects']['Thread'] = function(...)local b=require("utils").getValueFromXML
return
function(c)local d;local _a="Thread"local aa;local ba
local ca=false
local da=function(_b,ab)
if(ab:sub(1,1)=="#")then
local bb=_b:getBaseFrame():getDeepObject(ab:sub(2,ab:len()))
if(bb~=nil)and(bb.internalObjetCall~=nil)then return(function()
bb:internalObjetCall()end)end else return _b:getBaseFrame():getVariable(ab)end;return _b end
d={name=c,getType=function(_b)return _a end,getZIndex=function(_b)return 1 end,getName=function(_b)return _b.name end,getBaseFrame=function(_b)if
(_b.parent~=nil)then return _b.parent:getBaseFrame()end
return _b end,setValuesByXMLData=function(_b,ab)local bb;if(b("thread",ab)~=nil)then
bb=da(_b,b("thread",ab))end
if(b("start",ab)~=nil)then if
(b("start",ab))and(bb~=nil)then _b:start(bb)end end;return _b end,start=function(_b,ab)
if(
ab==nil)then error("Function provided to thread is nil")end;aa=ab;ba=coroutine.create(aa)ca=true
local bb,cb=coroutine.resume(ba)if not(bb)then if(cb~="Terminated")then
error("Thread Error Occurred - "..cb)end end
_b.parent:addEvent("other_event",_b)return _b end,getStatus=function(_b,ab)if(
ba~=nil)then return coroutine.status(ba)end;return nil end,stop=function(_b,ab)
ca=false;_b.parent:removeEvent("other_event",_b)return _b end,eventHandler=function(_b,ab,bb,cb,db)
if
(ca)then
if(coroutine.status(ba)~="dead")then
local _c,ac=coroutine.resume(ba,ab,bb,cb,db)if not(_c)then if(ac~="Terminated")then
error("Thread Error Occurred - "..ac)end end else
ca=false end end end}d.__index=d;return d end
end; 
project['objects']['Timer'] = function(...)local c=require("basaltEvent")
local d=require("utils").getValueFromXML
return
function(_a)local aa="Timer"local ba=0;local ca=0;local da=0;local _b;local ab=c()local bb=false
local cb=function(_c,ac,bc)
local cc=function(dc)
if(dc:sub(1,1)=="#")then
local _d=_c:getBaseFrame():getDeepObject(dc:sub(2,dc:len()))
if(_d~=nil)and(_d.internalObjetCall~=nil)then ac(_c,function()
_d:internalObjetCall()end)end else
ac(_c,_c:getBaseFrame():getVariable(dc))end end;if(type(bc)=="string")then cc(bc)elseif(type(bc)=="table")then
for dc,_d in pairs(bc)do cc(_d)end end;return _c end
local db={name=_a,getType=function(_c)return aa end,setValuesByXMLData=function(_c,ac)
if(d("time",ac)~=nil)then ba=d("time",ac)end;if(d("repeat",ac)~=nil)then ca=d("repeat",ac)end
if(
d("start",ac)~=nil)then if(d("start",ac))then _c:start()end end;if(d("onCall",ac)~=nil)then
cb(_c,_c.onCall,d("onCall",ac))end;return _c end,getBaseFrame=function(_c)
if(
_c.parent~=nil)then return _c.parent:getBaseFrame()end;return _c end,getZIndex=function(_c)return 1 end,getName=function(_c)
return _c.name end,setTime=function(_c,ac,bc)ba=ac or 0;ca=bc or 1;return _c end,start=function(_c)if(bb)then
os.cancelTimer(_b)end;da=ca;_b=os.startTimer(ba)bb=true
_c.parent:addEvent("other_event",_c)return _c end,isActive=function(_c)return bb end,cancel=function(_c)if(
_b~=nil)then os.cancelTimer(_b)end;bb=false
_c.parent:removeEvent("other_event",_c)return _c end,onCall=function(_c,ac)
ab:registerEvent("timed_event",ac)return _c end,eventHandler=function(_c,ac,bc)
if
ac=="timer"and bc==_b and bb then ab:sendEvent("timed_event",_c)
if(da>=1)then da=da-1;if(da>=1)then
_b=os.startTimer(ba)end elseif(da==-1)then _b=os.startTimer(ba)end end end}db.__index=db;return db end
end; 
project['libraries']['basaltDraw'] = function(...)local d=require("tHex")local _a,aa=string.sub,string.rep
return
function(ba)
local ca=ba or term.current()local da;local _b,ab=ca.getSize()local bb={}local cb={}local db={}local _c={}local ac={}local bc={}local cc
local dc={}local function _d()cc=aa(" ",_b)
for n=0,15 do local a_a=2 ^n;local b_a=d[a_a]dc[a_a]=aa(b_a,_b)end end;_d()
local function ad()_d()local a_a=cc
local b_a=dc[colors.white]local c_a=dc[colors.black]
for currentY=1,ab do
bb[currentY]=_a(
bb[currentY]==nil and a_a or
bb[currentY]..a_a:sub(1,_b-bb[currentY]:len()),1,_b)
db[currentY]=_a(db[currentY]==nil and b_a or db[currentY]..b_a:sub(1,_b-
db[currentY]:len()),1,_b)
cb[currentY]=_a(cb[currentY]==nil and c_a or cb[currentY]..c_a:sub(1,_b-
cb[currentY]:len()),1,_b)end end;ad()
local function bd(a_a,b_a,c_a)
if(b_a>=1)and(b_a<=ab)then
if
(a_a+c_a:len()>0)and(a_a<=_b)then local d_a=bb[b_a]local _aa;local aaa=a_a+#c_a-1
if(a_a<1)then local baa=1 -a_a+1
local caa=_b-a_a+1;c_a=_a(c_a,baa,caa)elseif(aaa>_b)then local baa=_b-a_a+1;c_a=_a(c_a,1,baa)end
if(a_a>1)then local baa=a_a-1;_aa=_a(d_a,1,baa)..c_a else _aa=c_a end;if aaa<_b then _aa=_aa.._a(d_a,aaa+1,_b)end
bb[b_a]=_aa end end end
local function cd(a_a,b_a,c_a)
if(b_a>=1)and(b_a<=ab)then
if(a_a+c_a:len()>0)and(a_a<=_b)then
local d_a=cb[b_a]local _aa;local aaa=a_a+#c_a-1
if(a_a<1)then
c_a=_a(c_a,1 -a_a+1,_b-a_a+1)elseif(aaa>_b)then c_a=_a(c_a,1,_b-a_a+1)end
if(a_a>1)then _aa=_a(d_a,1,a_a-1)..c_a else _aa=c_a end;if aaa<_b then _aa=_aa.._a(d_a,aaa+1,_b)end
cb[b_a]=_aa end end end
local function dd(a_a,b_a,c_a)
if(b_a>=1)and(b_a<=ab)then
if(a_a+c_a:len()>0)and(a_a<=_b)then
local d_a=db[b_a]local _aa;local aaa=a_a+#c_a-1
if(a_a<1)then local baa=1 -a_a+1;local caa=_b-a_a+1
c_a=_a(c_a,baa,caa)elseif(aaa>_b)then local baa=_b-a_a+1;c_a=_a(c_a,1,baa)end
if(a_a>1)then local baa=a_a-1;_aa=_a(d_a,1,baa)..c_a else _aa=c_a end;if aaa<_b then _aa=_aa.._a(d_a,aaa+1,_b)end
db[b_a]=_aa end end end
local __a={setSize=function(a_a,b_a)_b,ab=a_a,b_a;ad()end,setMirror=function(a_a)da=a_a end,setBG=function(a_a,b_a,c_a)cd(a_a,b_a,c_a)end,setText=function(a_a,b_a,c_a)
bd(a_a,b_a,c_a)end,setFG=function(a_a,b_a,c_a)dd(a_a,b_a,c_a)end,drawBackgroundBox=function(a_a,b_a,c_a,d_a,_aa)for n=1,d_a do
cd(a_a,b_a+ (n-1),aa(d[_aa],c_a))end end,drawForegroundBox=function(a_a,b_a,c_a,d_a,_aa)
for n=1,d_a do dd(a_a,b_a+
(n-1),aa(d[_aa],c_a))end end,drawTextBox=function(a_a,b_a,c_a,d_a,_aa)for n=1,d_a do
bd(a_a,b_a+ (n-1),aa(_aa,c_a))end end,writeText=function(a_a,b_a,c_a,d_a,_aa)
if(c_a~=nil)then
bd(a_a,b_a,c_a)if(d_a~=nil)and(d_a~=false)then
cd(a_a,b_a,aa(d[d_a],c_a:len()))end;if(_aa~=nil)and(_aa~=false)then
dd(a_a,b_a,aa(d[_aa],c_a:len()))end end end,update=function()
local a_a,b_a=ca.getCursorPos()local c_a=false
if(ca.getCursorBlink~=nil)then c_a=ca.getCursorBlink()end;ca.setCursorBlink(false)if(da~=nil)then
ca.setCursorBlink(false)end
for n=1,ab do ca.setCursorPos(1,n)
ca.blit(bb[n],db[n],cb[n])if(da~=nil)then da.setCursorPos(1,n)
da.blit(bb[n],db[n],cb[n])end end;ca.setBackgroundColor(colors.black)
ca.setCursorBlink(c_a)ca.setCursorPos(a_a,b_a)
if(da~=nil)then
da.setBackgroundColor(colors.black)da.setCursorBlink(c_a)da.setCursorPos(a_a,b_a)end end,setTerm=function(a_a)
ca=a_a end}return __a end
end; 
project['libraries']['basaltEvent'] = function(...)
return
function()local a={}local b={}
local c={registerEvent=function(d,_a,aa)if(a[_a]==nil)then a[_a]={}b[_a]=1 end
a[_a][b[_a] ]=aa;b[_a]=b[_a]+1;return b[_a]-1 end,removeEvent=function(d,_a,aa)a[_a][aa[_a] ]=
nil end,sendEvent=function(d,_a,...)local aa
if(a[_a]~=nil)then for ba,ca in pairs(a[_a])do local da=ca(...)if(da==
false)then aa=da end end end;return aa end}c.__index=c;return c end
end; 
project['libraries']['basaltLogs'] = function(...)local _a=""local aa="basaltLog.txt"local ba="Debug"
fs.delete(_a~=""and _a.."/"..aa or aa)
local ca={__call=function(da,_b,ab)if(_b==nil)then return end
local bb=_a~=""and _a.."/"..aa or aa
local cb=fs.open(bb,fs.exists(bb)and"a"or"w")
cb.writeLine("[Basalt][".. (ab and ab or ba).."]: "..tostring(_b))cb.close()end}return setmetatable({},ca)
end; 
project['libraries']['bigfont'] = function(...)local ba=require("tHex")
local ca={{"\32\32\32\137\156\148\158\159\148\135\135\144\159\139\32\136\157\32\159\139\32\32\143\32\32\143\32\32\32\32\32\32\32\32\147\148\150\131\148\32\32\32\151\140\148\151\140\147","\32\32\32\149\132\149\136\156\149\144\32\133\139\159\129\143\159\133\143\159\133\138\32\133\138\32\133\32\32\32\32\32\32\150\150\129\137\156\129\32\32\32\133\131\129\133\131\132","\32\32\32\130\131\32\130\131\32\32\129\32\32\32\32\130\131\32\130\131\32\32\32\32\143\143\143\32\32\32\32\32\32\130\129\32\130\135\32\32\32\32\131\32\32\131\32\131","\139\144\32\32\143\148\135\130\144\149\32\149\150\151\149\158\140\129\32\32\32\135\130\144\135\130\144\32\149\32\32\139\32\159\148\32\32\32\32\159\32\144\32\148\32\147\131\132","\159\135\129\131\143\149\143\138\144\138\32\133\130\149\149\137\155\149\159\143\144\147\130\132\32\149\32\147\130\132\131\159\129\139\151\129\148\32\32\139\131\135\133\32\144\130\151\32","\32\32\32\32\32\32\130\135\32\130\32\129\32\129\129\131\131\32\130\131\129\140\141\132\32\129\32\32\129\32\32\32\32\32\32\32\131\131\129\32\32\32\32\32\32\32\32\32","\32\32\32\32\149\32\159\154\133\133\133\144\152\141\132\133\151\129\136\153\32\32\154\32\159\134\129\130\137\144\159\32\144\32\148\32\32\32\32\32\32\32\32\32\32\32\151\129","\32\32\32\32\133\32\32\32\32\145\145\132\141\140\132\151\129\144\150\146\129\32\32\32\138\144\32\32\159\133\136\131\132\131\151\129\32\144\32\131\131\129\32\144\32\151\129\32","\32\32\32\32\129\32\32\32\32\130\130\32\32\129\32\129\32\129\130\129\129\32\32\32\32\130\129\130\129\32\32\32\32\32\32\32\32\133\32\32\32\32\32\129\32\129\32\32","\150\156\148\136\149\32\134\131\148\134\131\148\159\134\149\136\140\129\152\131\32\135\131\149\150\131\148\150\131\148\32\148\32\32\148\32\32\152\129\143\143\144\130\155\32\134\131\148","\157\129\149\32\149\32\152\131\144\144\131\148\141\140\149\144\32\149\151\131\148\32\150\32\150\131\148\130\156\133\32\144\32\32\144\32\130\155\32\143\143\144\32\152\129\32\134\32","\130\131\32\131\131\129\131\131\129\130\131\32\32\32\129\130\131\32\130\131\32\32\129\32\130\131\32\130\129\32\32\129\32\32\133\32\32\32\129\32\32\32\130\32\32\32\129\32","\150\140\150\137\140\148\136\140\132\150\131\132\151\131\148\136\147\129\136\147\129\150\156\145\138\143\149\130\151\32\32\32\149\138\152\129\149\32\32\157\152\149\157\144\149\150\131\148","\149\143\142\149\32\149\149\32\149\149\32\144\149\32\149\149\32\32\149\32\32\149\32\149\149\32\149\32\149\32\144\32\149\149\130\148\149\32\32\149\32\149\149\130\149\149\32\149","\130\131\129\129\32\129\131\131\32\130\131\32\131\131\32\131\131\129\129\32\32\130\131\32\129\32\129\130\131\32\130\131\32\129\32\129\131\131\129\129\32\129\129\32\129\130\131\32","\136\140\132\150\131\148\136\140\132\153\140\129\131\151\129\149\32\149\149\32\149\149\32\149\137\152\129\137\152\129\131\156\133\149\131\32\150\32\32\130\148\32\152\137\144\32\32\32","\149\32\32\149\159\133\149\32\149\144\32\149\32\149\32\149\32\149\150\151\129\138\155\149\150\130\148\32\149\32\152\129\32\149\32\32\32\150\32\32\149\32\32\32\32\32\32\32","\129\32\32\130\129\129\129\32\129\130\131\32\32\129\32\130\131\32\32\129\32\129\32\129\129\32\129\32\129\32\131\131\129\130\131\32\32\32\129\130\131\32\32\32\32\140\140\132","\32\154\32\159\143\32\149\143\32\159\143\32\159\144\149\159\143\32\159\137\145\159\143\144\149\143\32\32\145\32\32\32\145\149\32\144\32\149\32\143\159\32\143\143\32\159\143\32","\32\32\32\152\140\149\151\32\149\149\32\145\149\130\149\157\140\133\32\149\32\154\143\149\151\32\149\32\149\32\144\32\149\149\153\32\32\149\32\149\133\149\149\32\149\149\32\149","\32\32\32\130\131\129\131\131\32\130\131\32\130\131\129\130\131\129\32\129\32\140\140\129\129\32\129\32\129\32\137\140\129\130\32\129\32\130\32\129\32\129\129\32\129\130\131\32","\144\143\32\159\144\144\144\143\32\159\143\144\159\138\32\144\32\144\144\32\144\144\32\144\144\32\144\144\32\144\143\143\144\32\150\129\32\149\32\130\150\32\134\137\134\134\131\148","\136\143\133\154\141\149\151\32\129\137\140\144\32\149\32\149\32\149\154\159\133\149\148\149\157\153\32\154\143\149\159\134\32\130\148\32\32\149\32\32\151\129\32\32\32\32\134\32","\133\32\32\32\32\133\129\32\32\131\131\32\32\130\32\130\131\129\32\129\32\130\131\129\129\32\129\140\140\129\131\131\129\32\130\129\32\129\32\130\129\32\32\32\32\32\129\32","\32\32\32\32\149\32\32\149\32\32\32\32\32\32\32\32\149\32\32\149\32\32\32\32\32\32\32\32\149\32\32\149\32\32\32\32\32\32\32\32\149\32\32\149\32\32\32\32","\32\32\32\32\32\32\32\32\32\32\32\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\32\32\32\32\32\32\32\32\32\32\32","\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32","\32\32\32\32\149\32\32\149\32\32\32\32\32\32\32\32\149\32\32\149\32\32\32\32\32\32\32\32\149\32\32\149\32\32\32\32\32\32\32\32\149\32\32\149\32\32\32\32","\32\32\32\32\32\32\32\32\32\32\32\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\32\32\32\32\32\32\32\32\32\32\32","\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32","\32\32\32\32\145\32\159\139\32\151\131\132\155\143\132\134\135\145\32\149\32\158\140\129\130\130\32\152\147\155\157\134\32\32\144\144\32\32\32\32\32\32\152\131\155\131\131\129","\32\32\32\32\149\32\149\32\145\148\131\32\149\32\149\140\157\132\32\148\32\137\155\149\32\32\32\149\154\149\137\142\32\153\153\32\131\131\149\131\131\129\149\135\145\32\32\32","\32\32\32\32\129\32\130\135\32\131\131\129\134\131\132\32\129\32\32\129\32\131\131\32\32\32\32\130\131\129\32\32\32\32\129\129\32\32\32\32\32\32\130\131\129\32\32\32","\150\150\32\32\148\32\134\32\32\132\32\32\134\32\32\144\32\144\150\151\149\32\32\32\32\32\32\145\32\32\152\140\144\144\144\32\133\151\129\133\151\129\132\151\129\32\145\32","\130\129\32\131\151\129\141\32\32\142\32\32\32\32\32\149\32\149\130\149\149\32\143\32\32\32\32\142\132\32\154\143\133\157\153\132\151\150\148\151\158\132\151\150\148\144\130\148","\32\32\32\140\140\132\32\32\32\32\32\32\32\32\32\151\131\32\32\129\129\32\32\32\32\134\32\32\32\32\32\32\32\129\129\32\129\32\129\129\130\129\129\32\129\130\131\32","\156\143\32\159\141\129\153\140\132\153\137\32\157\141\32\159\142\32\150\151\129\150\131\132\140\143\144\143\141\145\137\140\148\141\141\144\157\142\32\159\140\32\151\134\32\157\141\32","\157\140\149\157\140\149\157\140\149\157\140\149\157\140\149\157\140\149\151\151\32\154\143\132\157\140\32\157\140\32\157\140\32\157\140\32\32\149\32\32\149\32\32\149\32\32\149\32","\129\32\129\129\32\129\129\32\129\129\32\129\129\32\129\129\32\129\129\131\129\32\134\32\131\131\129\131\131\129\131\131\129\131\131\129\130\131\32\130\131\32\130\131\32\130\131\32","\151\131\148\152\137\145\155\140\144\152\142\145\153\140\132\153\137\32\154\142\144\155\159\132\150\156\148\147\32\144\144\130\145\136\137\32\146\130\144\144\130\145\130\136\32\151\140\132","\151\32\149\151\155\149\149\32\149\149\32\149\149\32\149\149\32\149\149\32\149\152\137\144\157\129\149\149\32\149\149\32\149\149\32\149\149\32\149\130\150\32\32\157\129\149\32\149","\131\131\32\129\32\129\130\131\32\130\131\32\130\131\32\130\131\32\130\131\32\32\32\32\130\131\32\130\131\32\130\131\32\130\131\32\130\131\32\32\129\32\130\131\32\133\131\32","\156\143\32\159\141\129\153\140\132\153\137\32\157\141\32\159\142\32\159\159\144\152\140\144\156\143\32\159\141\129\153\140\132\157\141\32\130\145\32\32\147\32\136\153\32\130\146\32","\152\140\149\152\140\149\152\140\149\152\140\149\152\140\149\152\140\149\149\157\134\154\143\132\157\140\133\157\140\133\157\140\133\157\140\133\32\149\32\32\149\32\32\149\32\32\149\32","\130\131\129\130\131\129\130\131\129\130\131\129\130\131\129\130\131\129\130\130\131\32\134\32\130\131\129\130\131\129\130\131\129\130\131\129\32\129\32\32\129\32\32\129\32\32\129\32","\159\134\144\137\137\32\156\143\32\159\141\129\153\140\132\153\137\32\157\141\32\32\132\32\159\143\32\147\32\144\144\130\145\136\137\32\146\130\144\144\130\145\130\138\32\146\130\144","\149\32\149\149\32\149\149\32\149\149\32\149\149\32\149\149\32\149\149\32\149\131\147\129\138\134\149\149\32\149\149\32\149\149\32\149\149\32\149\154\143\149\32\157\129\154\143\149","\130\131\32\129\32\129\130\131\32\130\131\32\130\131\32\130\131\32\130\131\32\32\32\32\130\131\32\130\131\129\130\131\129\130\131\129\130\131\129\140\140\129\130\131\32\140\140\129"},{"000110000110110000110010101000000010000000100101","000000110110000000000010101000000010000000100101","000000000000000000000000000000000000000000000000","100010110100000010000110110000010100000100000110","000000110000000010110110000110000000000000110000","000000000000000000000000000000000000000000000000","000000110110000010000000100000100000000000000010","000000000110110100010000000010000000000000000100","000000000000000000000000000000000000000000000000","010000000000100110000000000000000000000110010000","000000000000000000000000000010000000010110000000","000000000000000000000000000000000000000000000000","011110110000000100100010110000000100000000000000","000000000000000000000000000000000000000000000000","000000000000000000000000000000000000000000000000","110000110110000000000000000000010100100010000000","000010000000000000110110000000000100010010000000","000000000000000000000000000000000000000000000000","010110010110100110110110010000000100000110110110","000000000000000000000110000000000110000000000000","000000000000000000000000000000000000000000000000","010100010110110000000000000000110000000010000000","110110000000000000110000110110100000000010000000","000000000000000000000000000000000000000000000000","000100011111000100011111000100011111000100011111","000000000000100100100100011011011011111111111111","000000000000000000000000000000000000000000000000","000100011111000100011111000100011111000100011111","000000000000100100100100011011011011111111111111","100100100100100100100100100100100100100100100100","000000110100110110000010000011110000000000011000","000000000100000000000010000011000110000000001000","000000000000000000000000000000000000000000000000","010000100100000000000000000100000000010010110000","000000000000000000000000000000110110110110110000","000000000000000000000000000000000000000000000000","110110110110110110000000110110110110110110110110","000000000000000000000110000000000000000000000000","000000000000000000000000000000000000000000000000","000000000000110110000110010000000000000000010010","000010000000000000000000000000000000000000000000","000000000000000000000000000000000000000000000000","110110110110110110110000110110110110000000000000","000000000000000000000110000000000000000000000000","000000000000000000000000000000000000000000000000","110110110110110110110000110000000000000000010000","000000000000000000000000100000000000000110000110","000000000000000000000000000000000000000000000000"}}local da={}local _b={}
do local cb=0;local db=#ca[1]local _c=#ca[1][1]
for i=1,db,3 do
for j=1,_c,3 do
local ac=string.char(cb)local bc={}bc[1]=ca[1][i]:sub(j,j+2)
bc[2]=ca[1][i+1]:sub(j,j+2)bc[3]=ca[1][i+2]:sub(j,j+2)local cc={}cc[1]=ca[2][i]:sub(j,
j+2)cc[2]=ca[2][i+1]:sub(j,j+2)cc[3]=ca[2][
i+2]:sub(j,j+2)_b[ac]={bc,cc}cb=cb+1 end end;da[1]=_b end
local function ab(cb,db)local _c={["0"]="1",["1"]="0"}if cb<=#da then return true end
for f=#da+1,cb do local ac={}local bc=da[
f-1]
for char=0,255 do local cc=string.char(char)local dc={}local _d={}
local ad=bc[cc][1]local bd=bc[cc][2]
for i=1,#ad do local cd,dd,__a,a_a,b_a,c_a={},{},{},{},{},{}
for j=1,#ad[1]do
local d_a=_b[ad[i]:sub(j,j)][1]table.insert(cd,d_a[1])table.insert(dd,d_a[2])
table.insert(__a,d_a[3])local _aa=_b[ad[i]:sub(j,j)][2]
if
bd[i]:sub(j,j)=="1"then
table.insert(a_a,(_aa[1]:gsub("[01]",_c)))
table.insert(b_a,(_aa[2]:gsub("[01]",_c)))
table.insert(c_a,(_aa[3]:gsub("[01]",_c)))else table.insert(a_a,_aa[1])
table.insert(b_a,_aa[2])table.insert(c_a,_aa[3])end end;table.insert(dc,table.concat(cd))
table.insert(dc,table.concat(dd))table.insert(dc,table.concat(__a))
table.insert(_d,table.concat(a_a))table.insert(_d,table.concat(b_a))
table.insert(_d,table.concat(c_a))end;ac[cc]={dc,_d}if db then db="Font"..f.."Yeld"..char
os.queueEvent(db)os.pullEvent(db)end end;da[f]=ac end;return true end
local function bb(cb,db,_c,ac,bc)
if not type(db)=="string"then error("Not a String",3)end
local cc=type(_c)=="string"and _c:sub(1,1)or ba[_c]or
error("Wrong Front Color",3)
local dc=type(ac)=="string"and ac:sub(1,1)or ba[ac]or
error("Wrong Back Color",3)if(da[cb]==nil)then ab(3,false)end;local _d=da[cb]or
error("Wrong font size selected",3)if db==""then
return{{""},{""},{""}}end;local ad={}
for c_a in db:gmatch('.')do table.insert(ad,c_a)end;local bd={}local cd=#_d[ad[1] ][1]
for nLine=1,cd do local c_a={}
for i=1,#ad do c_a[i]=_d[ad[i] ]and
_d[ad[i] ][1][nLine]or""end;bd[nLine]=table.concat(c_a)end;local dd={}local __a={}local a_a={["0"]=cc,["1"]=dc}local b_a={["0"]=dc,["1"]=cc}
for nLine=1,cd do
local c_a={}local d_a={}
for i=1,#ad do
local _aa=_d[ad[i] ]and _d[ad[i] ][2][nLine]or""
c_a[i]=_aa:gsub("[01]",
bc and{["0"]=_c:sub(i,i),["1"]=ac:sub(i,i)}or a_a)
d_a[i]=_aa:gsub("[01]",
bc and{["0"]=ac:sub(i,i),["1"]=_c:sub(i,i)}or b_a)end;dd[nLine]=table.concat(c_a)
__a[nLine]=table.concat(d_a)end;return{bd,dd,__a}end;return bb
end; 
project['libraries']['geometricPoints'] = function(...)
local function _a(da,_b,ab,bb)local cb={}if da==ab and _b==bb then return{x=da,y=ab}end
local db=math.min(da,ab)local _c,ac,bc;if db==da then ac,_c,bc=_b,ab,bb else ac,_c,bc=bb,da,_b end;local cc,dc=_c-db,
bc-ac
if cc>math.abs(dc)then local _d=ac;local ad=dc/cc;for x=db,_c do table.insert(cb,{x=x,y=math.floor(
_d+0.5)})
_d=_d+ad end else local _d,ad=db,cc/dc
if bc>=ac then for y=ac,bc do table.insert(cb,{x=math.floor(
_d+0.5),y=y})_d=_d+
ad end else for y=ac,bc,-1 do
table.insert(cb,{x=math.floor(_d+0.5),y=y})_d=_d-ad end end end;return cb end
local function aa(da,_b,ab)local bb={}for x=-ab,ab+1 do
local cb=math.floor(math.sqrt(ab*ab-x*x))
for y=-cb,cb+1 do table.insert(bb,{x=da+x,y=_b+y})end end;return bb end
local function ba(da,_b,ab,bb,cb)local db,_c=math.ceil(math.floor(ab-0.5)/2),math.ceil(
math.floor(bb-0.5)/2)local ac,bc=0,_c
local cc=( (
_c*_c)- (db*db*_c)+ (0.25 *db*db))local dc=2 *_c^2 *ac;local _d=2 *db^2 *bc;local ad={}
while dc<_d do
table.insert(ad,{x=ac+da,y=bc+_b})table.insert(ad,{x=-ac+da,y=bc+_b})table.insert(ad,{x=ac+
da,y=-bc+_b})
table.insert(ad,{x=-ac+da,y=-bc+_b})if cb then
for y=-bc+_b+1,bc+_b-1 do table.insert(ad,{x=ac+da,y=y})table.insert(ad,{x=
-ac+da,y=y})end end
if cc<0 then ac=ac+1
dc=dc+2 *_c^2;cc=cc+dc+_c^2 else ac,bc=ac+1,bc-1;dc=dc+2 *_c^2
_d=_d-2 *db^2;cc=cc+dc-_d+_c^2 end end
local bd=( ( (_c*_c)* ( (ac+0.5)* (ac+0.5)))+
( (db*db)* ( (bc-1)* (bc-1)))- (db*db*_c*_c))
while bc>=0 do table.insert(ad,{x=ac+da,y=bc+_b})table.insert(ad,{x=-
ac+da,y=bc+_b})
table.insert(ad,{x=ac+da,y=-bc+_b})table.insert(ad,{x=-ac+da,y=-bc+_b})
if cb then for y=-bc+_b,
bc+_b do table.insert(ad,{x=ac+da,y=y})
table.insert(ad,{x=-ac+da,y=y})end end
if bd>0 then bc=bc-1;_d=_d-2 *db^2;bd=bd+db^2 -_d else bc=bc-1;ac=ac+1;_d=_d-2 *
db^2;dc=dc+2 *_c^2;bd=bd+dc-_d+db^2 end end;return ad end;local function ca(da,_b,ab,bb)return ba(da,_b,ab,ab,bb)end
return
{circle=function(da,_b,ab,bb)
return ca(da,_b,ab,bb)end,rectangle=function(da,_b,ab,bb,cb)local db={}
if(cb)then for y=_b,bb do for x=da,ab do
table.insert(db,{x=x,y=y})end end else for y=_b,bb do
for x=da,ab do if
(x==da)or(x==ab)or(y==_b)or(y==bb)then
table.insert(db,{x=x,y=y})end end end end;return db end,triangle=function(da,_b,ab,bb,cb,db,_c)
local
function ac(dc,_d,ad,bd,cd,dd,__a)local a_a=(dd-_d)/ (__a-ad)local b_a=(dd-bd)/ (__a-cd)local c_a=math.ceil(
ad-0.5)
local d_a=math.ceil(__a-0.5)-1
for y=c_a,d_a do local _aa=a_a* (y+0.5 -ad)+_d
local aaa=b_a* (y+0.5 -cd)+bd;local baa=math.ceil(_aa-0.5)local caa=math.ceil(aaa-0.5)for x=baa,caa do
table.insert(dc,{x=x,y=y})end end end
local function bc(dc,_d,ad,bd,cd,dd,__a)local a_a=(bd-_d)/ (cd-ad)local b_a=(dd-_d)/ (__a-ad)
local c_a=math.ceil(ad-0.5)local d_a=math.ceil(__a-0.5)-1
for y=c_a,d_a do
local _aa=a_a* (y+0.5 -ad)+_d;local aaa=b_a* (y+0.5 -ad)+_d
local baa=math.ceil(_aa-0.5)local caa=math.ceil(aaa-0.5)for x=baa,caa do
table.insert(dc,{x=x,y=y})end end end;local cc={}
if(_c)then if bb<_b then da,_b,ab,bb=ab,bb,da,_b end;if db<bb then
ab,bb,cb,db=cb,db,ab,bb end;if bb<bb then da,_b,ab,bb=ab,bb,da,_b end
if _b==bb then if ab<da then
da,_b,ab,bb=ab,bb,da,_b end;ac(cc,da,_b,ab,bb,cb,db)elseif bb==db then if cb<ab then
cb,db,ab,bb=ab,bb,cb,db end;bc(cc,da,_b,ab,bb,cb,db)else
local dc=(bb-_b)/ (db-_b)local _d=da+ ( (cb-da)*dc)local ad=_b+ ( (db-_b)*dc)
if
ab<_d then bc(cc,da,_b,ab,bb,_d,ad)ac(cc,ab,bb,_d,ad,cb,db)else
bc(cc,da,_b,_d,ad,da,_b)ac(cc,_d,ad,ab,bb,cb,db)end end else cc=_a(da,_b,ab,bb)for dc,_d in pairs(_a(ab,bb,cb,db))do
table.insert(cc,_d)end;for dc,_d in pairs(_a(cb,db,da,_b))do
table.insert(cc,_d)end end;return cc end,line=_a,ellipse=function(da,_b,ab,bb,cb)return
ba(da,_b,ab,bb,cb)end}
end; 
project['libraries']['layout'] = function(...)
local function c(_a)local aa={}aa.___value=nil;aa.___name=_a;aa.___children={}aa.___props={}function aa:value()return
self.___value end
function aa:setValue(ba)self.___value=ba end;function aa:name()return self.___name end
function aa:setName(ba)self.___name=ba end;function aa:children()return self.___children end;function aa:numChildren()return
#self.___children end
function aa:addChild(ba)
if self[ba:name()]~=nil then
if
type(self[ba:name()].name)=="function"then local ca={}
table.insert(ca,self[ba:name()])self[ba:name()]=ca end;table.insert(self[ba:name()],ba)else
self[ba:name()]=ba end;table.insert(self.___children,ba)end;function aa:properties()return self.___props end;function aa:numProperties()
return#self.___props end
function aa:addProperty(ba,ca)local da="@"..ba
if self[da]~=nil then if
type(self[da])=="string"then local _b={}table.insert(_b,self[da])
self[da]=_b end
table.insert(self[da],ca)else self[da]=ca end
table.insert(self.___props,{name=ba,value=self[ba]})end;return aa end;local d={}
function d:ToXmlString(_a)_a=string.gsub(_a,"&","&amp;")
_a=string.gsub(_a,"<","&lt;")_a=string.gsub(_a,">","&gt;")
_a=string.gsub(_a,"\"","&quot;")
_a=string.gsub(_a,"([^%w%&%;%p%\t% ])",function(aa)
return string.format("&#x%X;",string.byte(aa))end)return _a end
function d:FromXmlString(_a)
_a=string.gsub(_a,"&#x([%x]+)%;",function(aa)
return string.char(tonumber(aa,16))end)
_a=string.gsub(_a,"&#([0-9]+)%;",function(aa)return string.char(tonumber(aa,10))end)_a=string.gsub(_a,"&quot;","\"")
_a=string.gsub(_a,"&apos;","'")_a=string.gsub(_a,"&gt;",">")
_a=string.gsub(_a,"&lt;","<")_a=string.gsub(_a,"&amp;","&")return _a end;function d:ParseArgs(_a,aa)
string.gsub(aa,"(%w+)=([\"'])(.-)%2",function(ba,ca,da)
_a:addProperty(ba,self:FromXmlString(da))end)end
function d:ParseXmlText(_a)
local aa={}local ba=c()table.insert(aa,ba)local ca,da,_b,ab,bb;local cb,db=1,1
while true do
ca,db,da,_b,ab,bb=string.find(_a,"<(%/?)([%w_:]+)(.-)(%/?)>",cb)if not ca then break end;local ac=string.sub(_a,cb,ca-1)
if not
string.find(ac,"^%s*$")then
local bc=(ba:value()or"")..self:FromXmlString(ac)aa[#aa]:setValue(bc)end
if bb=="/"then local bc=c(_b)self:ParseArgs(bc,ab)ba:addChild(bc)elseif
da==""then local bc=c(_b)self:ParseArgs(bc,ab)table.insert(aa,bc)
ba=bc else local bc=table.remove(aa)ba=aa[#aa]if#aa<1 then
error("XmlParser: nothing to close with ".._b)end;if bc:name()~=_b then
error("XmlParser: trying to close "..bc.name..
" with ".._b)end;ba:addChild(bc)end;cb=db+1 end;local _c=string.sub(_a,cb)if#aa>1 then
error("XmlParser: unclosed "..aa[#aa]:name())end;return ba end
function d:loadFile(_a,aa)if not aa then aa=system.ResourceDirectory end
local ba=system.pathForFile(_a,aa)local ca,da=io.open(ba,"r")
if ca and not da then local _b=ca:read("*a")
io.close(ca)return self:ParseXmlText(_b),nil else print(da)return nil end end;return d
end; 
project['libraries']['process'] = function(...)local d={}local _a={}local aa=0
function _a:new(ba,ca,...)local da={...}
local _b=setmetatable({path=ba},{__index=self})_b.window=ca;_b.processId=aa
_b.coroutine=coroutine.create(function()
shell.execute(ba,table.unpack(da))end)d[aa]=_b;aa=aa+1;return _b end
function _a:resume(ba,...)term.redirect(self.window)
if(self.filter~=nil)then if
(ba~=self.filter)then return end;self.filter=nil end;local ca,da=coroutine.resume(self.coroutine,ba,...)
self.window=term.current()if ca then self.filter=da else error(da)end end
function _a:isDead()
if(self.coroutine~=nil)then
if
(coroutine.status(self.coroutine)=="dead")then table.remove(d,self.processId)return true end else return true end;return false end
function _a:getStatus()if(self.coroutine~=nil)then
return coroutine.status(self.coroutine)end;return nil end
function _a:start()coroutine.resume(self.coroutine)end;return _a
end; 
project['libraries']['tHex'] = function(...)
return
{[colors.white]="0",[colors.orange]="1",[colors.magenta]="2",[colors.lightBlue]="3",[colors.yellow]="4",[colors.lime]="5",[colors.pink]="6",[colors.gray]="7",[colors.lightGray]="8",[colors.cyan]="9",[colors.purple]="a",[colors.blue]="b",[colors.brown]="c",[colors.green]="d",[colors.red]="e",[colors.black]="f"}
end; 
project['libraries']['utils'] = function(...)
local b=function(c,d)if d==nil then d="%s"end;local _a={}for aa in string.gmatch(c,"([^"..d.."]+)")do
table.insert(_a,aa)end;return _a end
return
{getTextHorizontalAlign=function(c,d,_a,aa)c=string.sub(c,1,d)local ba=d-string.len(c)
if(_a=="right")then c=string.rep(
aa or" ",ba)..c elseif(_a=="center")then
c=string.rep(aa or" ",math.floor(
ba/2))..c..
string.rep(aa or" ",math.floor(ba/2))
c=c.. (string.len(c)<d and(aa or" ")or"")else c=c..string.rep(aa or" ",ba)end;return c end,getTextVerticalAlign=function(c,d)
local _a=0
if(d=="center")then _a=math.ceil(c/2)if(_a<1)then _a=1 end end;if(d=="bottom")then _a=c end;if(_a<1)then _a=1 end;return _a end,rpairs=function(c)
return function(d,_a)_a=
_a-1;if _a~=0 then return _a,d[_a]end end,c,#c+1 end,tableCount=function(c)local d=0;if(c~=nil)then
for _a,aa in pairs(c)do d=d+1 end end;return d end,splitString=b,createText=function(c,d)
local _a=b(c,"\n")local aa={}
for ba,ca in pairs(_a)do local da=""local _b=b(ca," ")
for ab,bb in pairs(_b)do
if(#da+#bb<=d)then da=da==""and bb or da..
" "..bb;if(ab==#_b)then
table.insert(aa,da)end else table.insert(aa,da)da=bb:sub(1,d)if(ab==#_b)then
table.insert(aa,da)end end end end;return aa end,getValueFromXML=function(c,d)
local _a;if(type(d)~="table")then return end;if(d[c]~=nil)then
if(type(d[c])=="table")then if(
d[c].value~=nil)then _a=d[c]:value()end end end
if(_a==nil)then _a=d["@"..c]end;if(_a=="true")then _a=true elseif(_a=="false")then _a=false elseif(tonumber(_a)~=nil)then
_a=tonumber(_a)end;return _a end,numberFromString=function(c)return load(
"return "..c)()end,uuid=function()
local c=math.random
local function d()local _a='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'return
string.gsub(_a,'[xy]',function(aa)local ba=
(aa=='x')and c(0,0xf)or c(8,0xb)
return string.format('%x',ba)end)end;return d()end}
end; 
project['default']['Frame'] = function(...)local cb=require("Object")local db=require("loadObjects")
local _c=require("basaltDraw")local ac=require("utils")local bc=require("layout")local cc=ac.uuid
local dc=ac.rpairs;local _d=ac.getValueFromXML;local ad=ac.tableCount
local bd,cd,dd=string.sub,math.min,math.max
return
function(__a,a_a,b_a,c_a)local d_a=cb(__a)local _aa="Frame"local aaa={}local baa={}local caa={}local daa={}local _ba={}local aba={}
local bba={}local cba={}local dba=0;local _ca=b_a or term.current()local aca=""local bca=false
local cca=false;local dca=0;local _da=0;local ada=false;local bda=0;local cda=false;local dda=false;local __b=""local a_b=false;local b_b=false
local c_b;local d_b;local _ab=true;local aab=true;local bab=false;local cab={}d_a:setZIndex(10)
local dab=_c(_ca)local _bb=false;local abb=1;local bbb=1;local cbb=colors.white;local dbb,_cb=0,0;local acb={}local function bcb(_bc,abc)if(abc~=nil)then
abc:setValuesByXMLData(_bc)end end
local function ccb(_bc,abc,bbc)
if(_bc~=nil)then if(
_bc.properties~=nil)then _bc={_bc}end
for cbc,dbc in pairs(_bc)do
local _cc=abc(bbc,dbc["@id"]or cc())table.insert(acb,_cc)bcb(dbc,_cc)end end end
local function dcb(_bc)for abc,bbc in pairs(aaa)do
for cbc,dbc in pairs(bbc)do if(dbc:getName()==_bc)then return dbc end end end end
local function _db(_bc)local abc=dcb(_bc)if(abc~=nil)then return abc end
for bbc,cbc in pairs(aaa)do
for dbc,_cc in pairs(cbc)do if(
_cc:getType()=="Frame")then local acc=_cc:getDeepObject(_bc)
if(acc~=nil)then return acc end end end end end
local function adb(_bc)local abc=_bc:getZIndex()
if(dcb(_bc.name)~=nil)then return nil end
if(aaa[abc]==nil)then
for x=1,#baa+1 do if(baa[x]~=nil)then if(abc==baa[x])then break end;if
(abc>baa[x])then table.insert(baa,x,abc)break end else
table.insert(baa,abc)end end;if(#baa<=0)then table.insert(baa,abc)end;aaa[abc]={}end;_bc.parent=caa;if(_bc.init~=nil)then _bc:init()end
table.insert(aaa[abc],_bc)return _bc end
local function bdb(_bc,abc)
for bbc,cbc in pairs(daa)do
for dbc,_cc in pairs(cbc)do
for acc,bcc in pairs(_cc)do
if(bcc==abc)then
table.remove(daa[bbc][dbc],acc)if(_bc.parent~=nil)then if(ad(daa[event])<=0)then
_bc.parent:removeEvent(bbc,_bc)end end end end end end end
local function cdb(_bc)for abc,bbc in pairs(aaa)do
for cbc,dbc in pairs(bbc)do if(dbc==_bc)then table.remove(aaa[abc],cbc)
bdb(caa,_bc)return true end end end
return false end;local function ddb(_bc,abc,bbc)
for cbc,dbc in pairs(daa[abc])do for _cc,acc in pairs(dbc)do
if(acc:getName()==bbc)then return acc end end end end
local function __c(_bc,abc,bbc)
local cbc=bbc:getZIndex()if(daa[abc]==nil)then daa[abc]={}end;if(_ba[abc]==nil)then
_ba[abc]={}end
if(ddb(_bc,abc,bbc.name)~=nil)then return nil end
if(_bc.parent~=nil)then _bc.parent:addEvent(abc,_bc)end;cab[abc]=true
if(daa[abc][cbc]==nil)then
for x=1,#_ba[abc]+1 do
if
(_ba[abc][x]~=nil)then if(cbc==_ba[abc][x])then break end;if(cbc>_ba[abc][x])then
table.insert(_ba[abc],x,cbc)break end else
table.insert(_ba[abc],cbc)end end
if(#_ba[abc]<=0)then table.insert(_ba[abc],cbc)end;daa[abc][cbc]={}end;table.insert(daa[abc][cbc],bbc)return bbc end
local function a_c(_bc,abc,bbc)
if(daa[abc]~=nil)then
for cbc,dbc in pairs(daa[abc])do
for _cc,acc in pairs(dbc)do
if(acc==bbc)then
table.remove(daa[abc][cbc],_cc)if(#daa[abc][cbc]<=0)then daa[abc][cbc]=nil
if(_bc.parent~=nil)then if(
ad(daa[abc])<=0)then cab[abc]=false
_bc.parent:removeEvent(abc,_bc)end end end;return
true end end end end;return false end
local function b_c(_bc)local abc,bbc=pcall(load("return ".._bc))
if not(abc)then error(_bc..
" is not a valid dynamic code")end;return load("return ".._bc)()end
local function c_c(_bc,abc,bbc)for cbc,dbc in pairs(cba)do
if(dbc[2]==bbc)and(dbc[4]==abc)then return dbc end end;dba=dba+1
cba[dba]={0,bbc,{},abc,dba}return cba[dba]end
local function d_c(_bc,abc)local bbc={}local cbc={}for dbc in abc:gmatch("%a+%.x")do local _cc=dbc:gsub("%.x","")
if
(_cc~="self")and(_cc~="parent")then table.insert(bbc,_cc)end end
for dbc in
abc:gmatch("%w+%.y")do local _cc=dbc:gsub("%.y","")if(_cc~="self")and(_cc~="parent")then
table.insert(bbc,_cc)end end;for dbc in abc:gmatch("%a+%.w")do local _cc=dbc:gsub("%.w","")
if(_cc~="self")and
(_cc~="parent")then table.insert(bbc,_cc)end end
for dbc in
abc:gmatch("%a+%.h")do local _cc=dbc:gsub("%.h","")if(_cc~="self")and(_cc~="parent")then
table.insert(bbc,_cc)end end
for dbc,_cc in pairs(bbc)do cbc[_cc]=dcb(_cc)if(cbc[_cc]==nil)then
error("Dynamic Values - unable to find object ".._cc)end end;cbc["self"]=_bc;cbc["parent"]=_bc:getParent()return cbc end
local function _ac(_bc,abc)local bbc=_bc;for cbc in _bc:gmatch("%w+%.x")do
bbc=bbc:gsub(cbc,abc[cbc:gsub("%.x","")]:getX())end;for cbc in _bc:gmatch("%w+%.y")do
bbc=bbc:gsub(cbc,abc[cbc:gsub("%.y","")]:getY())end;for cbc in _bc:gmatch("%w+%.w")do
bbc=bbc:gsub(cbc,abc[cbc:gsub("%.w","")]:getWidth())end;for cbc in _bc:gmatch("%w+%.h")do
bbc=bbc:gsub(cbc,abc[cbc:gsub("%.h","")]:getHeight())end;return bbc end
local function aac(_bc)
if(#cba>0)then
for n=1,dba do
if(cba[n]~=nil)then local abc;if(#cba[n][3]<=0)then
cba[n][3]=d_c(cba[n][4],cba[n][2])end
abc=_ac(cba[n][2],cba[n][3])cba[n][1]=b_c(abc)if(cba[n][4]:getType()=="Frame")then
cba[n][4]:recalculateDynamicValues()end end end
for abc,bbc in pairs(baa)do if(aaa[bbc]~=nil)then
for cbc,dbc in pairs(aaa[bbc])do if(dbc.eventHandler~=nil)then
dbc:eventHandler("dynamicValueEvent",_bc)end end end end end end;local function bac(_bc)return cba[_bc][1]end
local function cac(_bc)
for abc,bbc in pairs(aaa)do
for cbc,dbc in pairs(bbc)do
if
(dbc.getHeight~=nil)and(dbc.getY~=nil)then
local _cc,acc=dbc:getHeight(),dbc:getY()if(_cc+acc-_bc:getHeight()>bda)then
bda=dd(_cc+acc-_bc:getHeight(),0)end end end end end;local function dac(_bc)
if(d_b~=c_b)then if(d_b~=nil)then d_b:loseFocusHandler()end;if
(c_b~=nil)then c_b:getFocusHandler()end;d_b=c_b end end
caa={barActive=false,barBackground=colors.gray,barTextcolor=colors.black,barText="New Frame",barTextAlign="left",addEvent=__c,removeEvent=a_c,removeEvents=bdb,getEvent=ddb,newDynamicValue=c_c,recalculateDynamicValues=aac,getDynamicValue=bac,getType=function(_bc)return
_aa end,setFocusedObject=function(_bc,abc)c_b=abc;return _bc end,getVariable=function(_bc,abc)
return c_a.getVariable(abc)end,setSize=function(_bc,abc,bbc,cbc)d_a.setSize(_bc,abc,bbc,cbc)if
(_bc.parent==nil)then dab=_c(_ca)end
for dbc,_cc in pairs(baa)do
if(aaa[_cc]~=nil)then for acc,bcc in pairs(aaa[_cc])do
if(
bcc.eventHandler~=nil)then bcc:eventHandler("basalt_resize",bcc,_bc)end end end end;_bc:recalculateDynamicValues()_ab=false;return _bc end,setTheme=function(_bc,abc,bbc)
if(
type(abc)=="table")then bba=abc elseif(type(abc)=="string")then bba[abc]=bbc end;_bc:updateDraw()return _bc end,getTheme=function(_bc,abc)
return
bba[abc]or(_bc.parent~=nil and _bc.parent:getTheme(abc)or
c_a.getTheme(abc))end,setPosition=function(_bc,abc,bbc,cbc)
d_a.setPosition(_bc,abc,bbc,cbc)
for dbc,_cc in pairs(baa)do if(aaa[_cc]~=nil)then
for acc,bcc in pairs(aaa[_cc])do if(bcc.eventHandler~=nil)then
bcc:eventHandler("basalt_reposition",bcc,_bc)end end end end;_bc:recalculateDynamicValues()return _bc end,getBasaltInstance=function(_bc)return
c_a end,setOffset=function(_bc,abc,bbc)
dbb=abc~=nil and
math.floor(abc<0 and math.abs(abc)or-abc)or dbb
_cb=bbc~=nil and
math.floor(bbc<0 and math.abs(bbc)or-bbc)or _cb;_bc:updateDraw()return _bc end,getOffsetInternal=function(_bc)return
dbb,_cb end,getOffset=function(_bc)
return dbb<0 and math.abs(dbb)or-dbb,
_cb<0 and math.abs(_cb)or-_cb end,removeFocusedObject=function(_bc)c_b=nil;return _bc end,getFocusedObject=function(_bc)
return d_b end,setCursor=function(_bc,abc,bbc,cbc,dbc)
if(_bc.parent~=nil)then local _cc,acc=_bc:getAnchorPosition()
_bc.parent:setCursor(
abc or false,(bbc or 0)+_cc-1,(cbc or 0)+acc-1,dbc or cbb)else
local _cc,acc=_bc:getAbsolutePosition(_bc:getAnchorPosition(_bc:getX(),_bc:getY(),true))_bb=abc or false;if(bbc~=nil)then abb=_cc+bbc-1 end;if(cbc~=nil)then bbb=acc+
cbc-1 end;cbb=dbc or cbb;if(_bb)then
_ca.setTextColor(cbb)_ca.setCursorPos(abb,bbb)_ca.setCursorBlink(_bb)else
_ca.setCursorBlink(false)end end;return _bc end,setMovable=function(_bc,abc)
if(
_bc.parent~=nil)then a_b=abc or not a_b
_bc.parent:addEvent("mouse_click",_bc)cab["mouse_click"]=true
_bc.parent:addEvent("mouse_up",_bc)cab["mouse_up"]=true
_bc.parent:addEvent("mouse_drag",_bc)cab["mouse_drag"]=true end;return _bc end,setScrollable=function(_bc,abc)ada=(
abc or abc==nil)and true or false
if(
_bc.parent~=nil)then _bc.parent:addEvent("mouse_scroll",_bc)end;cab["mouse_scroll"]=true;return _bc end,setScrollAmount=function(_bc,abc)bda=
abc or bda;aab=false;return _bc end,getScrollAmount=function(_bc)return
aab and bda or cac(_bc)end,show=function(_bc)d_a.show(_bc)
if(_bc.parent==nil)then
c_a.setActiveFrame(_bc)if(bca)then c_a.setMonitorFrame(aca,_bc)else
c_a.setMainFrame(_bc)end end;return _bc end,hide=function(_bc)
d_a.hide(_bc)
if(_bc.parent==nil)then if(activeFrame==_bc)then activeFrame=nil end;if(bca)then
if(
c_a.getMonitorFrame(aca)==_bc)then c_a.setActiveFrame(nil)end else
if(c_a.getMainFrame()==_bc)then c_a.setMainFrame(nil)end end end;return _bc end,addLayout=function(_bc,abc)
if(
abc~=nil)then
if(fs.exists(abc))then local bbc=fs.open(abc,"r")
local cbc=bc:ParseXmlText(bbc.readAll())bbc.close()acb={}_bc:setValuesByXMLData(cbc)end end;return _bc end,getLastLayout=function(_bc)return
acb end,addLayoutFromString=function(_bc,abc)if(abc~=nil)then local bbc=bc:ParseXmlText(abc)
_bc:setValuesByXMLData(bbc)end;return _bc end,setValuesByXMLData=function(_bc,abc)
d_a.setValuesByXMLData(_bc,abc)if(_d("movable",abc)~=nil)then if(_d("movable",abc))then
_bc:setMovable(true)end end;if(
_d("scrollable",abc)~=nil)then
if(_d("scrollable",abc))then _bc:setScrollable(true)end end;if
(_d("monitor",abc)~=nil)then
_bc:setMonitor(_d("monitor",abc)):show()end;if(_d("mirror",abc)~=nil)then
_bc:setMirror(_d("mirror",abc))end
if(_d("bar",abc)~=nil)then if(_d("bar",abc))then
_bc:showBar(true)else _bc:showBar(false)end end
if(_d("barText",abc)~=nil)then _bc.barText=_d("barText",abc)end;if(_d("barBG",abc)~=nil)then
_bc.barBackground=colors[_d("barBG",abc)]end;if(_d("barFG",abc)~=nil)then
_bc.barTextcolor=colors[_d("barFG",abc)]end;if(_d("barAlign",abc)~=nil)then
_bc.barTextAlign=_d("barAlign",abc)end;if(_d("layout",abc)~=nil)then
_bc:addLayout(_d("layout",abc))end;if(_d("xOffset",abc)~=nil)then
_bc:setOffset(_d("xOffset",abc),_cb)end;if(_d("yOffset",abc)~=nil)then
_bc:setOffset(_cb,_d("yOffset",abc))end;if(_d("scrollAmount",abc)~=nil)then
_bc:setScrollAmount(_d("scrollAmount",abc))end;local bbc=abc:children()
for cbc,dbc in
pairs(bbc)do if(dbc.___name~="animation")then
local _cc=dbc.___name:gsub("^%l",string.upper)
if(db[_cc]~=nil)then ccb(dbc,_bc["add".._cc],_bc)end end end;ccb(abc["frame"],_bc.addFrame,_bc)
ccb(abc["animation"],_bc.addAnimation,_bc)return _bc end,showBar=function(_bc,abc)_bc.barActive=
abc or not _bc.barActive;_bc:updateDraw()
return _bc end,setBar=function(_bc,abc,bbc,cbc)_bc.barText=abc or""_bc.barBackground=
bbc or _bc.barBackground
_bc.barTextcolor=cbc or _bc.barTextcolor;_bc:updateDraw()return _bc end,setBarTextAlign=function(_bc,abc)_bc.barTextAlign=
abc or"left"_bc:updateDraw()return _bc end,setMirror=function(_bc,abc)if(
_bc.parent~=nil)then
error("Frame has to be a base frame in order to attach a mirror.")end;__b=abc;if(mirror~=nil)then
dab.setMirror(mirror)end;cda=true;return _bc end,removeMirror=function(_bc)mirror=
nil;cda=false;dab.setMirror(nil)return _bc end,setMonitor=function(_bc,abc)
if(
abc~=nil)and(abc~=false)then
if
(peripheral.getType(abc)=="monitor")then _ca=peripheral.wrap(abc)cca=true end
if(_bc.parent~=nil)then _bc.parent:removeObject(_bc)end;bca=true;c_a.setMonitorFrame(abc,_bc)else _ca=parentTerminal
bca=false;if(c_a.getMonitorFrame(aca)==_bc)then
c_a.setMonitorFrame(aca,nil)end end;dab=_c(_ca)_bc:setSize(_ca.getSize())_ab=true
aca=abc or nil;_bc:updateDraw()return _bc end,loseFocusHandler=function(_bc)
d_a.loseFocusHandler(_bc)if(d_b~=nil)then d_b:loseFocusHandler()d_b=nil end end,getFocusHandler=function(_bc)
d_a.getFocusHandler(_bc)
if(_bc.parent~=nil)then
if(a_b)then _bc.parent:removeEvents(_bc)
_bc.parent:removeObject(_bc)_bc.parent:addObject(_bc)for abc,bbc in pairs(cab)do if(bbc)then
_bc.parent:addEvent(abc,_bc)end end
_bc:updateDraw()end end;if(d_b~=nil)then d_b:getFocusHandler()end end,eventHandler=function(_bc,abc,bbc,cbc,dbc,_cc)
d_a.eventHandler(_bc,abc,bbc,cbc,dbc,_cc)
if(daa["other_event"]~=nil)then
for acc,bcc in ipairs(_ba["other_event"])do
if(
daa["other_event"][bcc]~=nil)then for ccc,dcc in dc(daa["other_event"][bcc])do
if
(dcc.eventHandler~=nil)then if(dcc:eventHandler(abc,bbc,cbc,dbc,_cc))then return true end end end end end end;if(_ab)and not(bca)then
if(_bc.parent==nil)then if(abc=="term_resize")then
_bc:setSize(_ca.getSize())_ab=true end end end
if(bca)then
if(_ab)then if
(abc=="monitor_resize")and(bbc==aca)then _bc:setSize(_ca.getSize())
_ab=true;_bc:updateDraw()end end
if(abc=="peripheral")and(bbc==aca)then if
(peripheral.getType(aca)=="monitor")then cca=true;_ca=peripheral.wrap(aca)dab=_c(_ca)
_bc:updateDraw()end end
if(abc=="peripheral_detach")and(bbc==aca)then cca=false end end
if(cda)then if(peripheral.getType(__b)=="monitor")then dda=true
dab.setMirror(peripheral.wrap(__b))end;if(abc=="peripheral_detach")and
(bbc==__b)then cca=false end
if
(abc=="monitor_touch")and(__b==bbc)then _bc:mouseHandler(1,cbc,dbc,true)end end
if(abc=="terminate")and(_bc.parent==nil)then c_a.stop()end end,mouseHandler=function(_bc,abc,bbc,cbc)
if
(d_a.mouseHandler(_bc,abc,bbc,cbc))then
if(daa["mouse_click"]~=nil)then _bc:setCursor(false)
for dbc,_cc in
ipairs(_ba["mouse_click"])do
if(daa["mouse_click"][_cc]~=nil)then
for acc,bcc in
dc(daa["mouse_click"][_cc])do if(bcc.mouseHandler~=nil)then
if(bcc:mouseHandler(abc,bbc,cbc))then dac(_bc)return true end end end end end end
if(a_b)then
local dbc,_cc=_bc:getAbsolutePosition(_bc:getAnchorPosition())if
(bbc>=dbc)and(bbc<=dbc+_bc:getWidth()-1)and(cbc==_cc)then b_b=true;dca=dbc-bbc
_da=yOff and 1 or 0 end end;_bc:removeFocusedObject()dac(_bc)return true end;return false end,mouseUpHandler=function(_bc,abc,bbc,cbc)if
(b_b)then b_b=false end
if(d_a.mouseUpHandler(_bc,abc,bbc,cbc))then
if
(daa["mouse_up"]~=nil)then
for dbc,_cc in ipairs(_ba["mouse_up"])do
if(daa["mouse_up"][_cc]~=nil)then
for acc,bcc in
dc(daa["mouse_up"][_cc])do if(bcc.mouseUpHandler~=nil)then
if(bcc:mouseUpHandler(abc,bbc,cbc))then dac(_bc)return true end end end end end end;dac(_bc)return true end;return false end,scrollHandler=function(_bc,abc,bbc,cbc)
if
(d_a.scrollHandler(_bc,abc,bbc,cbc))then
if(daa["mouse_scroll"]~=nil)then
for _cc,acc in pairs(_ba["mouse_scroll"])do
if(
daa["mouse_scroll"][acc]~=nil)then
for bcc,ccc in dc(daa["mouse_scroll"][acc])do if(ccc.scrollHandler~=
nil)then
if(ccc:scrollHandler(abc,bbc,cbc))then dac(_bc)return true end end end end end end;local dbc=_cb
if(ada)then cac(_bc)if(abc>0)or(abc<0)then
_cb=dd(cd(_cb-abc,0),-bda)_bc:updateDraw()end end;_bc:removeFocusedObject()dac(_bc)
if(_cb==dbc)then return false end;return true end;return false end,dragHandler=function(_bc,abc,bbc,cbc)
if
(b_b)then local dbc,_cc=_bc.parent:getOffsetInternal()dbc=dbc<0 and
math.abs(dbc)or-dbc;_cc=
_cc<0 and math.abs(_cc)or-_cc;local acc=1;local bcc=1;if(_bc.parent~=nil)then
acc,bcc=_bc.parent:getAbsolutePosition(_bc.parent:getAnchorPosition())end
_bc:setPosition(
bbc+dca- (acc-1)+dbc,cbc+_da- (bcc-1)+_cc)_bc:updateDraw()return true end
if(daa["mouse_drag"]~=nil)then
for dbc,_cc in ipairs(_ba["mouse_drag"])do
if(
daa["mouse_drag"][_cc]~=nil)then
for acc,bcc in dc(daa["mouse_drag"][_cc])do if
(bcc.dragHandler~=nil)then
if(bcc:dragHandler(abc,bbc,cbc))then dac(_bc)return true end end end end end end;dac(_bc)d_a.dragHandler(_bc,abc,bbc,cbc)return false end,keyHandler=function(_bc,abc,bbc)
if
(_bc:isFocused())or(_bc.parent==nil)then
local cbc=_bc:getEventSystem():sendEvent("key",_bc,"key",abc)if(cbc==false)then return false end
if(daa["key"]~=nil)then
for dbc,_cc in pairs(_ba["key"])do
if(
daa["key"][_cc]~=nil)then
for acc,bcc in dc(daa["key"][_cc])do if(bcc.keyHandler~=nil)then if
(bcc:keyHandler(abc,bbc))then return true end end end end end end end;return false end,keyUpHandler=function(_bc,abc)
if
(_bc:isFocused())or(_bc.parent==nil)then
local bbc=_bc:getEventSystem():sendEvent("key_up",_bc,"key_up",abc)if(bbc==false)then return false end
if(daa["key_up"]~=nil)then
for cbc,dbc in
pairs(_ba["key_up"])do
if(daa["key_up"][dbc]~=nil)then for _cc,acc in dc(daa["key_up"][dbc])do
if(
acc.keyUpHandler~=nil)then if(acc:keyUpHandler(abc))then return true end end end end end end end;return false end,charHandler=function(_bc,abc)
if
(_bc:isFocused())or(_bc.parent==nil)then
local bbc=_bc:getEventSystem():sendEvent("char",_bc,"char",abc)if(bbc==false)then return false end
if(daa["char"]~=nil)then
for cbc,dbc in
pairs(_ba["char"])do
if(daa["char"][dbc]~=nil)then for _cc,acc in dc(daa["char"][dbc])do
if
(acc.charHandler~=nil)then if(acc:charHandler(abc))then return true end end end end end end end;return false end,setText=function(_bc,abc,bbc,cbc)
local dbc,_cc=_bc:getAnchorPosition()
if(bbc>=1)and(bbc<=_bc:getHeight())then
if(_bc.parent~=nil)then
_bc.parent:setText(dd(
abc+ (dbc-1),dbc),_cc+bbc-1,bd(cbc,dd(1 -abc+1,1),dd(
_bc:getWidth()-abc+1,1)))else
dab.setText(dd(abc+ (dbc-1),dbc),_cc+bbc-1,bd(cbc,dd(1 -abc+1,1),dd(
_bc:getWidth()-abc+1,1)))end end end,setBG=function(_bc,abc,bbc,cbc)
local dbc,_cc=_bc:getAnchorPosition()
if(bbc>=1)and(bbc<=_bc:getHeight())then
if(_bc.parent~=nil)then
_bc.parent:setBG(dd(
abc+ (dbc-1),dbc),_cc+bbc-1,bd(cbc,dd(1 -abc+1,1),dd(
_bc:getWidth()-abc+1,1)))else
dab.setBG(dd(abc+ (dbc-1),dbc),_cc+bbc-1,bd(cbc,dd(1 -abc+1,1),dd(
_bc:getWidth()-abc+1,1)))end end end,setFG=function(_bc,abc,bbc,cbc)
local dbc,_cc=_bc:getAnchorPosition()
if(bbc>=1)and(bbc<=_bc:getHeight())then
if(_bc.parent~=nil)then
_bc.parent:setFG(dd(
abc+ (dbc-1),dbc),_cc+bbc-1,bd(cbc,dd(1 -abc+1,1),dd(
_bc:getWidth()-abc+1,1)))else
dab.setFG(dd(abc+ (dbc-1),dbc),_cc+bbc-1,bd(cbc,dd(1 -abc+1,1),dd(
_bc:getWidth()-abc+1,1)))end end end,writeText=function(_bc,abc,bbc,cbc,dbc,_cc)
local acc,bcc=_bc:getAnchorPosition()
if(bbc>=1)and(bbc<=_bc:getHeight())then
if(_bc.parent~=nil)then
_bc.parent:writeText(dd(
abc+ (acc-1),acc),bcc+bbc-1,bd(cbc,dd(1 -abc+1,1),
_bc:getWidth()-abc+1),dbc,_cc)else
dab.writeText(dd(abc+ (acc-1),acc),bcc+bbc-1,bd(cbc,dd(1 -abc+1,1),dd(
_bc:getWidth()-abc+1,1)),dbc,_cc)end end end,drawBackgroundBox=function(_bc,abc,bbc,cbc,dbc,_cc)
local acc,bcc=_bc:getAnchorPosition()
dbc=(bbc<1 and(
dbc+bbc>_bc:getHeight()and _bc:getHeight()or dbc+bbc-1)or(
dbc+
bbc>_bc:getHeight()and _bc:getHeight()-bbc+1 or dbc))
cbc=(abc<1 and(cbc+abc>_bc:getWidth()and _bc:getWidth()or cbc+
abc-1)or(

cbc+abc>_bc:getWidth()and _bc:getWidth()-abc+1 or cbc))
if(_bc.parent~=nil)then
_bc.parent:drawBackgroundBox(dd(abc+ (acc-1),acc),dd(bbc+ (bcc-1),bcc),cbc,dbc,_cc)else
dab.drawBackgroundBox(dd(abc+ (acc-1),acc),dd(bbc+ (bcc-1),bcc),cbc,dbc,_cc)end end,drawTextBox=function(_bc,abc,bbc,cbc,dbc,_cc)
local acc,bcc=_bc:getAnchorPosition()
dbc=(bbc<1 and(
dbc+bbc>_bc:getHeight()and _bc:getHeight()or dbc+bbc-1)or(
dbc+
bbc>_bc:getHeight()and _bc:getHeight()-bbc+1 or dbc))
cbc=(abc<1 and(cbc+abc>_bc:getWidth()and _bc:getWidth()or cbc+
abc-1)or(

cbc+abc>_bc:getWidth()and _bc:getWidth()-abc+1 or cbc))
if(_bc.parent~=nil)then
_bc.parent:drawTextBox(dd(abc+ (acc-1),acc),dd(bbc+ (bcc-1),bcc),cbc,dbc,bd(_cc,1,1))else
dab.drawTextBox(dd(abc+ (acc-1),acc),dd(bbc+ (bcc-1),bcc),cbc,dbc,bd(_cc,1,1))end end,drawForegroundBox=function(_bc,abc,bbc,cbc,dbc,_cc)
local acc,bcc=_bc:getAnchorPosition()
dbc=(bbc<1 and(
dbc+bbc>_bc:getHeight()and _bc:getHeight()or dbc+bbc-1)or(
dbc+
bbc>_bc:getHeight()and _bc:getHeight()-bbc+1 or dbc))
cbc=(abc<1 and(cbc+abc>_bc:getWidth()and _bc:getWidth()or cbc+
abc-1)or(

cbc+abc>_bc:getWidth()and _bc:getWidth()-abc+1 or cbc))
if(_bc.parent~=nil)then
_bc.parent:drawForegroundBox(dd(abc+ (acc-1),acc),dd(bbc+ (bcc-1),bcc),cbc,dbc,_cc)else
dab.drawForegroundBox(dd(abc+ (acc-1),acc),dd(bbc+ (bcc-1),bcc),cbc,dbc,_cc)end end,draw=function(_bc,abc)if
(bca)and not(cca)then return false end
if(_bc.parent==nil)then if(_bc:getDraw()==
false)then return false end end
if(d_a.draw(_bc))then
local bbc,cbc=_bc:getAbsolutePosition(_bc:getAnchorPosition())local dbc,_cc=_bc:getAnchorPosition()local acc,bcc=_bc:getSize()
if(
_bc.parent==nil)then
if(_bc.bgColor~=false)then
dab.drawBackgroundBox(dbc,_cc,acc,bcc,_bc.bgColor)dab.drawTextBox(dbc,_cc,acc,bcc," ")end;if(_bc.fgColor~=false)then
dab.drawForegroundBox(dbc,_cc,acc,bcc,_bc.fgColor)end end
if(_bc.barActive)then
if(_bc.parent~=nil)then
_bc.parent:writeText(dbc,_cc,ac.getTextHorizontalAlign(_bc.barText,acc,_bc.barTextAlign),_bc.barBackground,_bc.barTextcolor)else
dab.writeText(dbc,_cc,ac.getTextHorizontalAlign(_bc.barText,acc,_bc.barTextAlign),_bc.barBackground,_bc.barTextcolor)end
if(_bc:getBorder("left"))then
if(_bc.parent~=nil)then
_bc.parent:drawBackgroundBox(dbc-1,_cc,1,1,_bc.barBackground)if(_bc.bgColor~=false)then
_bc.parent:drawBackgroundBox(dbc-1,_cc+1,1,bcc-1,_bc.bgColor)end end end
if(_bc:getBorder("top"))then if(_bc.parent~=nil)then
_bc.parent:drawBackgroundBox(dbc-1,_cc-1,acc+1,1,_bc.barBackground)end end end;for ccc,dcc in dc(baa)do
if(aaa[dcc]~=nil)then for _dc,adc in pairs(aaa[dcc])do
if(adc.draw~=nil)then adc:draw()end end end end end end,updateTerm=function(_bc)if
(bca)and not(cca)then return false end;dab.update()end,addObject=function(_bc,abc)return
adb(abc)end,removeObject=function(_bc,abc)return cdb(abc)end,getObject=function(_bc,abc)return dcb(abc)end,getDeepObject=function(_bc,abc)return
_db(abc)end,addFrame=function(_bc,abc)
local bbc=c_a.newFrame(abc or cc(),_bc,nil,c_a)return adb(bbc)end,init=function(_bc)
if not(bab)then
if(a_a~=nil)then
d_a.width,d_a.height=a_a:getSize()
_bc:setBackground(a_a:getTheme("FrameBG"))
_bc:setForeground(a_a:getTheme("FrameText"))else d_a.width,d_a.height=_ca.getSize()
_bc:setBackground(c_a.getTheme("BasaltBG"))
_bc:setForeground(c_a.getTheme("BasaltText"))end;bab=true end end}
for _bc,abc in pairs(db)do caa["add".._bc]=function(bbc,cbc)
return adb(abc(cbc or cc(),bbc))end end;setmetatable(caa,d_a)return caa end
end; 
project['default']['loadObjects'] = function(...)local d={}if(packaged)then
for ba,ca in pairs(getProject("objects"))do d[ba]=ca()end;return d end
local _a=table.pack(...)local aa=fs.getDir(_a[2]or"Basalt")if(aa==nil)then
error("Unable to find directory "..
_a[2].." please report this bug to our discord.")end;for ba,ca in
pairs(fs.list(fs.combine(aa,"objects")))do
if(ca~="example.lua")then local da=ca:gsub(".lua","")d[da]=require(da)end end;return d
end; 
project['default']['Object'] = function(...)local aa=require("basaltEvent")local ba=require("utils")
local ca=ba.splitString;local da=ba.numberFromString;local _b=ba.getValueFromXML
return
function(ab)local bb="Object"local cb={}local db=1
local _c;local ac="topLeft"local bc=false;local cc=true;local dc=false;local _d=false
local ad={left=false,right=false,top=false,bottom=false}local bd=colors.black;local cd=true;local dd=false;local __a,a_a,b_a,c_a=0,0,0,0;local d_a=true;local _aa={}
local aaa=aa()
cb={x=1,y=1,width=1,height=1,bgColor=colors.black,bgSymbol=" ",bgSymbolColor=colors.black,fgColor=colors.white,transparentColor=false,name=ab or"Object",parent=nil,show=function(baa)cc=true
baa:updateDraw()return baa end,hide=function(baa)cc=false;baa:updateDraw()return baa end,enable=function(baa)
cd=true;return baa end,disable=function(baa)cd=false;return baa end,generateXMLEventFunction=function(baa,caa,daa)
local _ba=function(aba)
if
(aba:sub(1,1)=="#")then
local bba=baa:getBaseFrame():getDeepObject(aba:sub(2,aba:len()))
if(bba~=nil)and(bba.internalObjetCall~=nil)then caa(baa,function()
bba:internalObjetCall()end)end else
caa(baa,baa:getBaseFrame():getVariable(aba))end end;if(type(daa)=="string")then _ba(daa)elseif(type(daa)=="table")then
for aba,bba in pairs(daa)do _ba(bba)end end;return baa end,setValuesByXMLData=function(baa,caa)
local daa=baa:getBaseFrame()if(_b("x",caa)~=nil)then
baa:setPosition(_b("x",caa),baa.y)end;if(_b("y",caa)~=nil)then
baa:setPosition(baa.x,_b("y",caa))end;if(_b("width",caa)~=nil)then
baa:setSize(_b("width",caa),baa.height)end;if(_b("height",caa)~=nil)then
baa:setSize(baa.width,_b("height",caa))end;if(_b("bg",caa)~=nil)then
baa:setBackground(colors[_b("bg",caa)])end;if(_b("fg",caa)~=nil)then
baa:setForeground(colors[_b("fg",caa)])end;if(_b("value",caa)~=nil)then
baa:setValue(colors[_b("value",caa)])end
if(_b("visible",caa)~=nil)then if
(_b("visible",caa))then baa:show()else baa:hide()end end
if(_b("enabled",caa)~=nil)then if(_b("enabled",caa))then baa:enable()else
baa:disable()end end;if(_b("zIndex",caa)~=nil)then
baa:setZIndex(_b("zIndex",caa))end;if(_b("anchor",caa)~=nil)then
baa:setAnchor(_b("anchor",caa))end;if(_b("shadowColor",caa)~=nil)then
baa:setShadow(colors[_b("shadowColor",caa)])end;if(_b("border",caa)~=nil)then
baa:setBorder(colors[_b("border",caa)])end;if(_b("borderLeft",caa)~=nil)then
ad["left"]=_b("borderLeft",caa)end;if(_b("borderTop",caa)~=nil)then
ad["top"]=_b("borderTop",caa)end;if(_b("borderRight",caa)~=nil)then
ad["right"]=_b("borderRight",caa)end;if(_b("borderBottom",caa)~=nil)then
ad["bottom"]=_b("borderBottom",caa)end;if(_b("borderColor",caa)~=nil)then
baa:setBorder(colors[_b("borderColor",caa)])end;if
(_b("ignoreOffset",caa)~=nil)then
if(_b("ignoreOffset",caa))then baa:ignoreOffset(true)end end;if
(_b("onClick",caa)~=nil)then
baa:generateXMLEventFunction(baa.onClick,_b("onClick",caa))end;if
(_b("onClickUp",caa)~=nil)then
baa:generateXMLEventFunction(baa.onClickUp,_b("onClickUp",caa))end;if
(_b("onScroll",caa)~=nil)then
baa:generateXMLEventFunction(baa.onScroll,_b("onScroll",caa))end;if
(_b("onDrag",caa)~=nil)then
baa:generateXMLEventFunction(baa.onDrag,_b("onDrag",caa))end;if(_b("onKey",caa)~=nil)then
baa:generateXMLEventFunction(baa.onKey,_b("onKey",caa))end;if(_b("onKeyUp",caa)~=nil)then
baa:generateXMLEventFunction(baa.onKeyUp,_b("onKeyUp",caa))end;if
(_b("onChange",caa)~=nil)then
baa:generateXMLEventFunction(baa.onChange,_b("onChange",caa))end;if
(_b("onResize",caa)~=nil)then
baa:generateXMLEventFunction(baa.onResize,_b("onResize",caa))end;if
(_b("onReposition",caa)~=nil)then
baa:generateXMLEventFunction(baa.onReposition,_b("onReposition",caa))end;if
(_b("onEvent",caa)~=nil)then
baa:generateXMLEventFunction(baa.onEvent,_b("onEvent",caa))end;if
(_b("onGetFocus",caa)~=nil)then
baa:generateXMLEventFunction(baa.onGetFocus,_b("onGetFocus",caa))end;if
(_b("onLoseFocus",caa)~=nil)then
baa:generateXMLEventFunction(baa.onLoseFocus,_b("onLoseFocus",caa))end
baa:updateDraw()return baa end,isVisible=function(baa)return
cc end,setFocus=function(baa)if(baa.parent~=nil)then
baa.parent:setFocusedObject(baa)end;return baa end,setZIndex=function(baa,caa)
db=caa
if(baa.parent~=nil)then baa.parent:removeObject(baa)
baa.parent:addObject(baa)baa:updateEventHandlers()end;return baa end,updateEventHandlers=function(baa)
for caa,daa in
pairs(_aa)do if(daa)then baa.parent:addEvent(caa,baa)end end end,getZIndex=function(baa)return db end,getType=function(baa)return bb end,getName=function(baa)return
baa.name end,remove=function(baa)if(baa.parent~=nil)then
baa.parent:removeObject(baa)end;baa:updateDraw()return baa end,setParent=function(baa,caa)
if(
caa.getType~=nil and caa:getType()=="Frame")then
baa:remove()caa:addObject(baa)if(baa.draw)then baa:show()end end;return baa end,setValue=function(baa,caa)
if(
_c~=caa)then _c=caa;baa:updateDraw()baa:valueChangedHandler()end;return baa end,getValue=function(baa)return _c end,getDraw=function(baa)return
d_a end,updateDraw=function(baa,caa)d_a=caa;if(caa==nil)then d_a=true end;if(d_a)then if(baa.parent~=nil)then
baa.parent:updateDraw()end end;return baa end,getEventSystem=function(baa)return
aaa end,getParent=function(baa)return baa.parent end,setPosition=function(baa,caa,daa,_ba)
if(type(caa)=="number")then baa.x=
_ba and baa:getX()+caa or caa end;if(type(daa)=="number")then
baa.y=_ba and baa:getY()+daa or daa end
if(baa.parent~=nil)then if(type(caa)=="string")then
baa.x=baa.parent:newDynamicValue(baa,caa)end;if(type(daa)=="string")then
baa.y=baa.parent:newDynamicValue(baa,daa)end
baa.parent:recalculateDynamicValues()end;aaa:sendEvent("basalt_reposition",baa)
baa:updateDraw()return baa end,getX=function(baa)return

type(baa.x)=="number"and baa.x or math.floor(baa.x[1]+0.5)end,getY=function(baa)return

type(baa.y)=="number"and baa.y or math.floor(baa.y[1]+0.5)end,getPosition=function(baa)return
baa:getX(),baa:getY()end,getVisibility=function(baa)return cc end,setVisibility=function(baa,caa)
cc=caa or not cc;baa:updateDraw()return baa end,setSize=function(baa,caa,daa,_ba)if(type(caa)==
"number")then
baa.width=_ba and baa.width+caa or caa end
if(type(daa)=="number")then baa.height=_ba and
baa.height+daa or daa end
if(baa.parent~=nil)then if(type(caa)=="string")then
baa.width=baa.parent:newDynamicValue(baa,caa)end;if(type(daa)=="string")then
baa.height=baa.parent:newDynamicValue(baa,daa)end
baa.parent:recalculateDynamicValues()end;aaa:sendEvent("basalt_resize",baa)
baa:updateDraw()return baa end,getHeight=function(baa)
return
type(baa.height)=="number"and baa.height or
math.floor(baa.height[1]+0.5)end,getWidth=function(baa)return

type(baa.width)=="number"and baa.width or math.floor(baa.width[1]+0.5)end,getSize=function(baa)return
baa:getWidth(),baa:getHeight()end,calculateDynamicValues=function(baa)
if(
type(baa.width)=="table")then baa.width:calculate()end
if(type(baa.height)=="table")then baa.height:calculate()end
if(type(baa.x)=="table")then baa.x:calculate()end
if(type(baa.y)=="table")then baa.y:calculate()end;baa:updateDraw()return baa end,setBackground=function(baa,caa,daa,_ba)baa.bgColor=
caa or false
baa.bgSymbol=daa or(baa.bgColor~=false and baa.bgSymbol or
false)baa.bgSymbolColor=_ba or baa.bgSymbolColor
baa:updateDraw()return baa end,setTransparent=function(baa,caa)baa.transparentColor=
caa or false;baa.bgSymbol=false;baa.bgSymbolColor=false
baa:updateDraw()return baa end,getBackground=function(baa)return
baa.bgColor end,setForeground=function(baa,caa)baa.fgColor=caa or false
baa:updateDraw()return baa end,getForeground=function(baa)return baa.fgColor end,setShadow=function(baa,caa)if(
caa==false)then _d=false else bd=caa;_d=true end
baa:updateDraw()return baa end,isShadowActive=function(baa)return _d end,setBorder=function(baa,...)
if(
...~=nil)then local caa={...}
for daa,_ba in pairs(caa)do if(_ba=="left")or(#caa==1)then
ad["left"]=caa[1]end;if(_ba=="top")or(#caa==1)then
ad["top"]=caa[1]end;if(_ba=="right")or(#caa==1)then
ad["right"]=caa[1]end;if(_ba=="bottom")or(#caa==1)then
ad["bottom"]=caa[1]end end end;baa:updateDraw()return baa end,getBorder=function(baa,caa)if(
caa=="left")then return borderLeft end
if(caa=="top")then return borderTop end;if(caa=="right")then return borderRight end;if(caa=="bottom")then
return borderBottom end end,draw=function(baa)
if
(cc)then
if(baa.parent~=nil)then local caa,daa=baa:getAnchorPosition()
local _ba,aba=baa:getSize()local bba,cba=baa.parent:getSize()
if(caa+_ba<1)or(caa>bba)or(daa+
aba<1)or(daa>cba)then return false end;if(baa.transparentColor~=false)then
baa.parent:drawForegroundBox(caa,daa,_ba,aba,baa.transparentColor)end;if(baa.bgColor~=false)then
baa.parent:drawBackgroundBox(caa,daa,_ba,aba,baa.bgColor)end
if(baa.bgSymbol~=false)then
baa.parent:drawTextBox(caa,daa,_ba,aba,baa.bgSymbol)if(baa.bgSymbol~=" ")then
baa.parent:drawForegroundBox(caa,daa,_ba,aba,baa.bgSymbolColor)end end
if(_d)then
baa.parent:drawBackgroundBox(caa+1,daa+aba,_ba,1,bd)
baa.parent:drawBackgroundBox(caa+_ba,daa+1,1,aba,bd)
baa.parent:drawForegroundBox(caa+1,daa+aba,_ba,1,bd)
baa.parent:drawForegroundBox(caa+_ba,daa+1,1,aba,bd)end
if(ad["left"]~=false)then
baa.parent:drawTextBox(caa-1,daa,1,aba,"\149")
baa.parent:drawBackgroundBox(caa-1,daa,1,aba,ad["left"])
baa.parent:drawForegroundBox(caa-1,daa,1,aba,baa.parent.bgColor)end
if(ad["left"]~=false)and(ad["top"]~=false)then baa.parent:drawTextBox(
caa-1,daa-1,1,1,"\151")baa.parent:drawBackgroundBox(
caa-1,daa-1,1,1,ad["left"])
baa.parent:drawForegroundBox(
caa-1,daa-1,1,1,baa.parent.bgColor)end
if(ad["top"]~=false)then
baa.parent:drawTextBox(caa,daa-1,_ba,1,"\131")
baa.parent:drawBackgroundBox(caa,daa-1,_ba,1,ad["top"])
baa.parent:drawForegroundBox(caa,daa-1,_ba,1,baa.parent.bgColor)end
if(ad["top"]~=false)and(ad["right"]~=false)then baa.parent:drawTextBox(
caa+_ba,daa-1,1,1,"\148")
baa.parent:drawForegroundBox(
caa+_ba,daa-1,1,1,ad["right"])end;if(ad["right"]~=false)then
baa.parent:drawTextBox(caa+_ba,daa,1,aba,"\149")
baa.parent:drawForegroundBox(caa+_ba,daa,1,aba,ad["right"])end
if(
ad["right"]~=false)and(ad["bottom"]~=false)then baa.parent:drawTextBox(
caa+_ba,daa+aba,1,1,"\129")
baa.parent:drawForegroundBox(
caa+_ba,daa+aba,1,1,ad["right"])end;if(ad["bottom"]~=false)then
baa.parent:drawTextBox(caa,daa+aba,_ba,1,"\131")
baa.parent:drawForegroundBox(caa,daa+aba,_ba,1,ad["bottom"])end
if(
ad["bottom"]~=false)and(ad["left"]~=false)then baa.parent:drawTextBox(
caa-1,daa+aba,1,1,"\130")
baa.parent:drawForegroundBox(
caa-1,daa+aba,1,1,ad["left"])end end;d_a=false;return true end;return false end,getAbsolutePosition=function(baa,caa,daa)
if(
caa==nil)or(daa==nil)then caa,daa=baa:getAnchorPosition()end
if(baa.parent~=nil)then
local _ba,aba=baa.parent:getAbsolutePosition()caa=_ba+caa-1;daa=aba+daa-1 end;return caa,daa end,getAnchorPosition=function(baa,caa,daa,_ba)if(
caa==nil)then caa=baa:getX()end
if(daa==nil)then daa=baa:getY()end
if(baa.parent~=nil)then local aba,bba=baa.parent:getSize()
if(ac=="top")then caa=math.floor(
aba/2)+caa-1 elseif(ac=="topRight")then
caa=aba+caa-1 elseif(ac=="right")then caa=aba+caa-1
daa=math.floor(bba/2)+daa-1 elseif(ac=="bottomRight")then caa=aba+caa-1;daa=bba+daa-1 elseif(ac=="bottom")then caa=math.floor(
aba/2)+caa-1;daa=bba+daa-1 elseif(ac==
"bottomLeft")then daa=bba+daa-1 elseif(ac=="left")then
daa=math.floor(bba/2)+daa-1 elseif(ac=="center")then caa=math.floor(aba/2)+caa-1;daa=math.floor(
bba/2)+daa-1 end;local cba,dba=baa.parent:getOffsetInternal()if not(bc or _ba)then return caa+
cba,daa+dba end end;return caa,daa end,ignoreOffset=function(baa,caa)
bc=caa;if(caa==nil)then bc=true end;return baa end,getBaseFrame=function(baa)
if(
baa.parent~=nil)then return baa.parent:getBaseFrame()end;return baa end,setAnchor=function(baa,caa)ac=caa
baa:updateDraw()return baa end,getAnchor=function(baa)return ac end,onChange=function(baa,...)
for caa,daa in
pairs(table.pack(...))do if(type(daa)=="function")then
baa:registerEvent("value_changed",daa)end end;return baa end,onClick=function(baa,...)
for caa,daa in
pairs(table.pack(...))do if(type(daa)=="function")then
baa:registerEvent("mouse_click",daa)end end;if(baa.parent~=nil)then
baa.parent:addEvent("mouse_click",baa)_aa["mouse_click"]=true end;return
baa end,onClickUp=function(baa,...)for caa,daa in
pairs(table.pack(...))do
if(type(daa)=="function")then baa:registerEvent("mouse_up",daa)end end;if(baa.parent~=nil)then
baa.parent:addEvent("mouse_up",baa)_aa["mouse_up"]=true end;return baa end,onScroll=function(baa,...)
for caa,daa in
pairs(table.pack(...))do if(type(daa)=="function")then
baa:registerEvent("mouse_scroll",daa)end end
if(baa.parent~=nil)then
baa.parent:addEvent("mouse_scroll",baa)_aa["mouse_scroll"]=true end;return baa end,onDrag=function(baa,...)
for caa,daa in
pairs(table.pack(...))do if(type(daa)=="function")then
baa:registerEvent("mouse_drag",daa)end end
if(baa.parent~=nil)then
baa.parent:addEvent("mouse_drag",baa)_aa["mouse_drag"]=true
baa.parent:addEvent("mouse_click",baa)_aa["mouse_click"]=true
baa.parent:addEvent("mouse_up",baa)_aa["mouse_up"]=true end;return baa end,onEvent=function(baa,...)
for caa,daa in
pairs(table.pack(...))do if(type(daa)=="function")then
baa:registerEvent("other_event",daa)end end;if(baa.parent~=nil)then
baa.parent:addEvent("other_event",baa)_aa["other_event"]=true end;return
baa end,onKey=function(baa,...)
if
(cd)then for caa,daa in pairs(table.pack(...))do
if(type(daa)=="function")then
baa:registerEvent("key",daa)baa:registerEvent("char",daa)end end
if
(baa.parent~=nil)then baa.parent:addEvent("key",baa)
baa.parent:addEvent("char",baa)_aa["key"]=true;_aa["char"]=true end end;return baa end,onResize=function(baa,...)
for caa,daa in
pairs(table.pack(...))do if(type(daa)=="function")then
baa:registerEvent("basalt_resize",daa)end end;return baa end,onReposition=function(baa,...)
for caa,daa in
pairs(table.pack(...))do if(type(daa)=="function")then
baa:registerEvent("basalt_reposition",daa)end end;return baa end,onKeyUp=function(baa,...)for caa,daa in
pairs(table.pack(...))do
if(type(daa)=="function")then baa:registerEvent("key_up",daa)end end;if(baa.parent~=nil)then
baa.parent:addEvent("key_up",baa)_aa["key_up"]=true end;return baa end,isFocused=function(baa)if(
baa.parent~=nil)then
return baa.parent:getFocusedObject()==baa end;return false end,onGetFocus=function(baa,...)
for caa,daa in
pairs(table.pack(...))do if(type(daa)=="function")then
baa:registerEvent("get_focus",daa)end end;if(baa.parent~=nil)then
baa.parent:addEvent("mouse_click",baa)_aa["mouse_click"]=true end;return
baa end,onLoseFocus=function(baa,...)
for caa,daa in
pairs(table.pack(...))do if(type(daa)=="function")then
baa:registerEvent("lose_focus",daa)end end;if(baa.parent~=nil)then
baa.parent:addEvent("mouse_click",baa)_aa["mouse_click"]=true end;return
baa end,registerEvent=function(baa,caa,daa)return
aaa:registerEvent(caa,daa)end,removeEvent=function(baa,caa,daa)
return aaa:removeEvent(caa,daa)end,sendEvent=function(baa,caa,...)return aaa:sendEvent(caa,baa,...)end,isCoordsInObject=function(baa,caa,daa)
if
(cc)and(cd)then
local _ba,aba=baa:getAbsolutePosition(baa:getAnchorPosition())local bba,cba=baa:getSize()
if
(_ba<=caa)and(_ba+bba>caa)and(aba<=daa)and(aba+cba>daa)then return true end end;return false end,mouseHandler=function(baa,caa,daa,_ba,aba)
if
(baa:isCoordsInObject(daa,_ba))then
local bba=aaa:sendEvent("mouse_click",baa,"mouse_click",caa,daa,_ba,aba)if(bba==false)then return false end;if(baa.parent~=nil)then
baa.parent:setFocusedObject(baa)end;dd=true;__a,a_a=daa,_ba;return true end;return false end,mouseUpHandler=function(baa,caa,daa,_ba)
dd=false
if(baa:isCoordsInObject(daa,_ba))then
local aba=aaa:sendEvent("mouse_up",baa,"mouse_up",caa,daa,_ba)if(aba==false)then return false end;return true end;return false end,dragHandler=function(baa,caa,daa,_ba)
if
(dd)then local aba,bba,cba,dba=0,0,1,1
if(baa.parent~=nil)then
aba,bba=baa.parent:getOffsetInternal()aba=aba<0 and math.abs(aba)or-aba;bba=bba<0 and
math.abs(bba)or-bba
cba,dba=baa.parent:getAbsolutePosition(baa.parent:getAnchorPosition())end
local _ca,aca=daa+b_a- (cba-1)+aba,_ba+c_a- (dba-1)+bba
local bca=aaa:sendEvent("mouse_drag",baa,caa,_ca,aca,__a-daa,a_a-_ba,daa,_ba)
local cca,dca=baa:getAbsolutePosition(baa:getAnchorPosition())__a,a_a=daa,_ba;if(bca~=nil)then return bca end;if(baa.parent~=nil)then
baa.parent:setFocusedObject(baa)end;return true end
if(baa:isCoordsInObject(daa,_ba))then
local aba,bba=baa:getAbsolutePosition(baa:getAnchorPosition())__a,a_a=daa,_ba;b_a,c_a=aba-daa,bba-_ba end;return false end,scrollHandler=function(baa,caa,daa,_ba)
if
(baa:isCoordsInObject(daa,_ba))then
local aba=aaa:sendEvent("mouse_scroll",baa,"mouse_scroll",caa,daa,_ba)if(aba==false)then return false end;if(baa.parent~=nil)then
baa.parent:setFocusedObject(baa)end;return true end;return false end,keyHandler=function(baa,caa,daa)if
(cd)and(cc)then
if(baa:isFocused())then
local _ba=aaa:sendEvent("key",baa,"key",caa,daa)if(_ba==false)then return false end;return true end end;return
false end,keyUpHandler=function(baa,caa)if
(cd)and(cc)then
if(baa:isFocused())then
local daa=aaa:sendEvent("key_up",baa,"key_up",caa)if(daa==false)then return false end;return true end end;return
false end,charHandler=function(baa,caa)if
(cd)and(cc)then
if(baa:isFocused())then
local daa=aaa:sendEvent("char",baa,"char",caa)if(daa==false)then return false end;return true end end
return false end,valueChangedHandler=function(baa)
aaa:sendEvent("value_changed",baa,_c)end,eventHandler=function(baa,caa,daa,_ba,aba,bba)
local cba=aaa:sendEvent("other_event",baa,caa,daa,_ba,aba,bba)if(cba~=nil)then return cba end;return true end,getFocusHandler=function(baa)
local caa=aaa:sendEvent("get_focus",baa)if(caa~=nil)then return caa end;return true end,loseFocusHandler=function(baa)
dd=false;local caa=aaa:sendEvent("lose_focus",baa)
if(caa~=nil)then return caa end;return true end,init=function(baa)
if
(baa.parent~=nil)then for caa,daa in pairs(_aa)do
if(daa)then baa.parent:addEvent(caa,baa)end end end;if not(dc)then dc=true;return true end end}cb.__index=cb;return cb end
end; 
project['default']['theme'] = function(...)
return
{BasaltBG=colors.lightGray,BasaltText=colors.black,FrameBG=colors.gray,FrameText=colors.black,ButtonBG=colors.gray,ButtonText=colors.black,CheckboxBG=colors.gray,CheckboxText=colors.black,InputBG=colors.gray,InputText=colors.black,TextfieldBG=colors.gray,TextfieldText=colors.black,ListBG=colors.gray,ListText=colors.black,MenubarBG=colors.gray,MenubarText=colors.black,DropdownBG=colors.gray,DropdownText=colors.black,RadioBG=colors.gray,RadioText=colors.black,SelectionBG=colors.black,SelectionText=colors.lightGray,GraphicBG=colors.black,ImageBG=colors.black,PaneBG=colors.black,ProgramBG=colors.black,ProgressbarBG=colors.gray,ProgressbarText=colors.black,ProgressbarActiveBG=colors.black,ScrollbarBG=colors.lightGray,ScrollbarText=colors.gray,ScrollbarSymbolColor=colors.black,SliderBG=false,SliderText=colors.gray,SliderSymbolColor=colors.black,SwitchBG=colors.lightGray,SwitchText=colors.gray,SwitchBGSymbol=colors.black,SwitchInactive=colors.red,SwitchActive=colors.green,LabelBG=false,LabelText=colors.black}
end; 
local baa=require("basaltEvent")()
local caa=require("Frame")local daa=require("theme")local _ba=require("utils")
local aba=require("basaltLogs")local bba=_ba.uuid;local cba=_ba.createText;local dba=term.current()local _ca="1.6.0"
local aca=true
local bca=fs.getDir(table.pack(...)[2]or"")local cca,dca,_da,ada,bda={},{},{},{},{}local cda,dda,__b,a_b;local b_b={}if not term.isColor or
not term.isColor()then
error('Basalt requires an advanced (golden) computer to run.',0)end;local function c_b()a_b=false
dba.clear()dba.setCursorPos(1,1)end;local d_b=function(cbb,dbb)
ada[cbb]=dbb end
local _ab=function(cbb)return ada[cbb]end;local aab=function(cbb)daa=cbb end
local bab=function(cbb)return daa[cbb]end
local cab={getMainFrame=function()return cda end,setVariable=d_b,getVariable=_ab,getTheme=bab,setMainFrame=function(cbb)cda=cbb end,getActiveFrame=function()return dda end,setActiveFrame=function(cbb)dda=cbb end,getFocusedObject=function()return
__b end,setFocusedObject=function(cbb)__b=cbb end,getMonitorFrame=function(cbb)return _da[cbb]end,setMonitorFrame=function(cbb,dbb)if(cda==dbb)then
cda=nil end;_da[cbb]=dbb end,getBaseTerm=function()return dba end,stop=c_b,newFrame=caa,getDirectory=function()return
bca end}
local dab=function(cbb)dba.clear()dba.setBackgroundColor(colors.black)
dba.setTextColor(colors.red)local dbb,_cb=dba.getSize()
if(b_b.logging)then aba(cbb,"Error")end;local acb=cba("Basalt error: "..cbb,dbb)local bcb=1;for ccb,dcb in pairs(acb)do
dba.setCursorPos(1,bcb)dba.write(dcb)bcb=bcb+1 end;dba.setCursorPos(1,
bcb+1)a_b=false end
local function _bb(cbb,dbb,_cb,acb,bcb)
if(#bda>0)then local ccb={}
for n=1,#bda do
if(bda[n]~=nil)then
if
(coroutine.status(bda[n])=="suspended")then
local dcb,_db=coroutine.resume(bda[n],cbb,dbb,_cb,acb,bcb)if not(dcb)then dab(_db)end else table.insert(ccb,n)end end end
for n=1,#ccb do table.remove(bda,ccb[n]- (n-1))end end end
local function abb()if(a_b==false)then return end;if(cda~=nil)then cda:draw()
cda:updateTerm()end
for cbb,dbb in pairs(_da)do dbb:draw()dbb:updateTerm()end end
local function bbb(cbb,dbb,_cb,acb,bcb)if
(baa:sendEvent("basaltEventCycle",cbb,dbb,_cb,acb,bcb)==false)then return end
if(cda~=nil)then
if(cbb=="mouse_click")then
cda:mouseHandler(dbb,_cb,acb,false)dda=cda elseif(cbb=="mouse_drag")then cda:dragHandler(dbb,_cb,acb,bcb)
dda=cda elseif(cbb=="mouse_up")then cda:mouseUpHandler(dbb,_cb,acb,bcb)dda=cda elseif(cbb==
"mouse_scroll")then cda:scrollHandler(dbb,_cb,acb,bcb)dda=cda end end
if(cbb=="monitor_touch")then if(_da[dbb]~=nil)then
_da[dbb]:mouseHandler(1,_cb,acb,true)dda=_da[dbb]end end
if(cbb=="char")then if(dda~=nil)then dda:charHandler(dbb)end end;if(cbb=="key_up")then if(dda~=nil)then dda:keyUpHandler(dbb)end
cca[dbb]=false end
if(cbb=="key")then if(dda~=nil)then
dda:keyHandler(dbb,_cb)end;cca[dbb]=true end
if(cbb=="terminate")then if(dda~=nil)then dda:eventHandler(cbb)
if(a_b==false)then return end end end
if



(cbb~="mouse_click")and(cbb~="mouse_up")and(cbb~="mouse_scroll")and(cbb~="mouse_drag")and(cbb~="key")and(cbb~="key_up")and(cbb~=
"char")and(cbb~="terminate")then
for ccb,dcb in pairs(dca)do dcb:eventHandler(cbb,dbb,_cb,acb,bcb)end end;_bb(cbb,dbb,_cb,acb,bcb)abb()end
b_b={logging=false,setTheme=aab,getTheme=bab,drawFrames=abb,getVersion=function()return _ca end,setVariable=d_b,getVariable=_ab,setBaseTerm=function(cbb)dba=cbb end,log=function(...)aba(...)end,autoUpdate=function(cbb)
a_b=cbb;if(cbb==nil)then a_b=true end;local function dbb()abb()while a_b do
bbb(os.pullEventRaw())end end
local _cb,acb=xpcall(dbb,debug.traceback)if not(_cb)then dab(acb)return end end,update=function(cbb,dbb,_cb,acb,bcb)
if(
cbb~=nil)then
local ccb,dcb=xpcall(bbb,debug.traceback,cbb,dbb,_cb,acb,bcb)if not(ccb)then dab(dcb)return end end end,stop=c_b,stopUpdate=c_b,isKeyDown=function(cbb)if(
cca[cbb]==nil)then return false end;return cca[cbb]end,getFrame=function(cbb)for dbb,_cb in
pairs(dca)do if(_cb.name==cbb)then return _cb end end end,getActiveFrame=function()return
dda end,setActiveFrame=function(cbb)
if(cbb:getType()=="Frame")then dda=cbb;return true end;return false end,onEvent=function(...)
for cbb,dbb in
pairs(table.pack(...))do if(type(dbb)=="function")then
baa:registerEvent("basaltEventCycle",dbb)end end end,schedule=function(cbb)
assert(cbb~=
"function","Schedule needs a function in order to work!")return
function(...)local dbb=coroutine.create(cbb)
local _cb,acb=coroutine.resume(dbb,...)if(_cb)then table.insert(bda,dbb)else dab(acb)end end end,createFrame=function(cbb)cbb=
cbb or bba()
for _cb,acb in pairs(dca)do if(acb.name==cbb)then return nil end end;local dbb=caa(cbb,nil,nil,cab)dbb:init()
table.insert(dca,dbb)if
(cda==nil)and(dbb:getName()~="basaltDebuggingFrame")then dbb:show()end;return dbb end,removeFrame=function(cbb)dca[cbb]=
nil end,setProjectDir=function(cbb)bca=cbb end,debug=function(...)local cbb={...}if(cda==nil)then
print(...)return end;if(cda.name~="basaltDebuggingFrame")then
if
(cda~=b_b.debugFrame)then b_b.debugLabel:setParent(cda)end end;local dbb=""for _cb,acb in pairs(cbb)do
dbb=dbb..
tostring(acb).. (#cbb~=_cb and", "or"")end
b_b.debugLabel:setText("[Debug] "..dbb)for _cb,acb in pairs(cba(dbb,b_b.debugList:getWidth()))do
b_b.debugList:addItem(acb)end
if(
b_b.debugList:getItemCount()>50)then b_b.debugList:removeItem(1)end
b_b.debugList:setValue(b_b.debugList:getItem(b_b.debugList:getItemCount()))if
(b_b.debugList.getItemCount()>b_b.debugList:getHeight())then
b_b.debugList:setOffset(b_b.debugList:getItemCount()-
b_b.debugList:getHeight())end
b_b.debugLabel:show()end}
b_b.debugFrame=b_b.createFrame("basaltDebuggingFrame"):showBar():setBackground(colors.lightGray):setBar("Debug",colors.black,colors.gray)
b_b.debugFrame:addButton("back"):setAnchor("topRight"):setSize(1,1):setText("\22"):onClick(function()if(
b_b.oldFrame~=nil)then b_b.oldFrame:show()end end):setBackground(colors.red):show()
b_b.debugList=b_b.debugFrame:addList("debugList"):setSize("parent.w - 2","parent.h - 3"):setPosition(2,3):setScrollable(true):show()
b_b.debugLabel=b_b.debugFrame:addLabel("debugLabel"):onClick(function()
b_b.oldFrame=cda;b_b.debugFrame:show()end):setBackground(colors.black):setForeground(colors.white):setAnchor("bottomLeft"):ignoreOffset():setZIndex(20):show()return b_b