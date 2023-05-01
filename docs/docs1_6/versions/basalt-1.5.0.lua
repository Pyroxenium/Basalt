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
project['objects'] = {}project['libraries'] = {}project['default'] = {}project['objects']['Animation'] = function(...)local ab=require("utils").getValueFromXML
local bb=require("basaltEvent")local cb=math.floor
local db=function(ad,bd,cd)return ad+ (bd-ad)*cd end;local _c=function(ad)return ad end
local ac=function(ad)return 1 -ad end;local bc=function(ad)return ad*ad*ad end;local cc=function(ad)
return ac(bc(ac(ad)))end;local dc=function(ad)
return db(bc(ad),cc(ad),ad)end
local _d={linear=_c,lerp=db,flip=ac,easeIn=bc,easeOut=cc,easeInOut=dc}
return
function(ad)local bd={}local cd="Animation"local dd;local __a={}local a_a=0;local b_a=false;local c_a=1;local d_a=false;local _aa=bb()
local aaa=0;local baa;local caa=false;local daa=false;local _ba="easeOut"local aba;local function bba(aca)for bca,cca in pairs(aca)do
cca(bd,__a[c_a].t,c_a)end end
local function cba(aca)if(c_a==1)then
aca:animationStartHandler()end;if(__a[c_a]~=nil)then bba(__a[c_a].f)
a_a=__a[c_a].t end;c_a=c_a+1
if(__a[c_a]==nil)then if(d_a)then c_a=1;a_a=0 else
aca:animationDoneHandler()return end end;if(__a[c_a].t>0)then
dd=os.startTimer(__a[c_a].t-a_a)else cba(aca)end end
local function dba(aca,bca)for n=1,#__a do
if(__a[n].t==aca)then table.insert(__a[n].f,bca)return end end
for n=1,#__a do
if(__a[n].t>aca)then if
(__a[n-1]~=nil)then if(__a[n-1].t<aca)then
table.insert(__a,n-1,{t=aca,f={bca}})return end else
table.insert(__a,n,{t=aca,f={bca}})return end end end
if(#__a<=0)then table.insert(__a,1,{t=aca,f={bca}})return elseif(
__a[#__a].t<aca)then table.insert(__a,{t=aca,f={bca}})end end
local function _ca(aca,bca,cca,dca,_da,ada)local bda,cda
dba(dca+0.05,function()bda,cda=_da(aba)end)
for n=0.05,cca,0.05 do
dba(dca+n,function()
local dda=math.floor(_d.lerp(bda,aca,_d[_ba](n/cca))+0.5)
local __b=math.floor(_d.lerp(cda,bca,_d[_ba](n/cca))+0.5)ada(aba,dda,__b)end)end end
bd={name=ad,getType=function(aca)return cd end,getBaseFrame=function(aca)if(aca.parent~=nil)then
return aca.parent:getBaseFrame()end;return aca end,setMode=function(aca,bca)
_ba=bca;return aca end,generateXMLEventFunction=function(aca,bca,cca)
local dca=function(_da)
if(_da:sub(1,1)=="#")then
local ada=aca:getBaseFrame():getDeepObject(_da:sub(2,_da:len()))
if(ada~=nil)and(ada.internalObjetCall~=nil)then bca(aca,function()
ada:internalObjetCall()end)end else
bca(aca,aca:getBaseFrame():getVariable(_da))end end;if(type(cca)=="string")then dca(cca)elseif(type(cca)=="table")then
for _da,ada in pairs(cca)do dca(ada)end end;return aca end,setValuesByXMLData=function(aca,bca)caa=
ab("loop",bca)==true and true or false
if(
ab("object",bca)~=nil)then
local cca=aca:getBaseFrame():getDeepObject(ab("object",bca))if(cca==nil)then
cca=aca:getBaseFrame():getVariable(ab("object",bca))end
if(cca~=nil)then aca:setObject(cca)end end
if(bca["move"]~=nil)then local cca=ab("x",bca["move"])
local dca=ab("y",bca["move"])local _da=ab("duration",bca["move"])
local ada=ab("time",bca["move"])aca:move(cca,dca,_da,ada)end
if(bca["size"]~=nil)then local cca=ab("width",bca["size"])
local dca=ab("height",bca["size"])local _da=ab("duration",bca["size"])
local ada=ab("time",bca["size"])aca:size(cca,dca,_da,ada)end
if(bca["offset"]~=nil)then local cca=ab("x",bca["offset"])
local dca=ab("y",bca["offset"])local _da=ab("duration",bca["offset"])
local ada=ab("time",bca["offset"])aca:offset(cca,dca,_da,ada)end
if(bca["textColor"]~=nil)then
local cca=ab("duration",bca["textColor"])local dca=ab("time",bca["textColor"])local _da={}
local ada=bca["textColor"]["color"]
if(ada~=nil)then if(ada.properties~=nil)then ada={ada}end;for bda,cda in pairs(ada)do
table.insert(_da,colors[cda:value()])end end;if(cca~=nil)and(#_da>0)then
aca:changeTextColor(cca,dca or 0,table.unpack(_da))end end
if(bca["background"]~=nil)then
local cca=ab("duration",bca["background"])local dca=ab("time",bca["background"])local _da={}
local ada=bca["background"]["color"]
if(ada~=nil)then if(ada.properties~=nil)then ada={ada}end;for bda,cda in pairs(ada)do
table.insert(_da,colors[cda:value()])end end;if(cca~=nil)and(#_da>0)then
aca:changeBackground(cca,dca or 0,table.unpack(_da))end end
if(bca["text"]~=nil)then local cca=ab("duration",bca["text"])
local dca=ab("time",bca["text"])local _da={}local ada=bca["text"]["text"]
if(ada~=nil)then if(ada.properties~=nil)then
ada={ada}end;for bda,cda in pairs(ada)do
table.insert(_da,cda:value())end end;if(cca~=nil)and(#_da>0)then
aca:changeText(cca,dca or 0,table.unpack(_da))end end;if(ab("onDone",bca)~=nil)then
aca:generateXMLEventFunction(aca.onDone,ab("onDone",bca))end;if(ab("onStart",bca)~=nil)then
aca:generateXMLEventFunction(aca.onDone,ab("onStart",bca))end
if
(ab("autoDestroy",bca)~=nil)then if(ab("autoDestroy",bca))then daa=true end end;_ba=ab("mode",bca)or _ba
if(ab("play",bca)~=nil)then if
(ab("play",bca))then aca:play(caa)end end;return aca end,getZIndex=function(aca)return
1 end,getName=function(aca)return aca.name end,setObject=function(aca,bca)aba=bca;return aca end,move=function(aca,bca,cca,dca,_da,ada)aba=
ada or aba
_ca(bca,cca,dca,_da or 0,aba.getPosition,aba.setPosition)return aca end,offset=function(aca,bca,cca,dca,_da,ada)
aba=ada or aba
_ca(bca,cca,dca,_da or 0,aba.getOffset,aba.setOffset)return aca end,size=function(aca,bca,cca,dca,_da,ada)
aba=ada or aba;_ca(bca,cca,dca,_da or 0,aba.getSize,aba.setSize)return
aca end,changeText=function(aca,bca,cca,...)local dca={...}cca=
cca or 0;aba=obj or aba;for n=1,#dca do
dba(cca+n* (bca/#dca),function()
aba.setText(aba,dca[n])end)end;return aca end,changeBackground=function(aca,bca,cca,...)
local dca={...}cca=cca or 0;aba=obj or aba;for n=1,#dca do
dba(cca+n* (bca/#dca),function()
aba.setBackground(aba,dca[n])end)end;return aca end,changeTextColor=function(aca,bca,cca,...)
local dca={...}cca=cca or 0;aba=obj or aba;for n=1,#dca do
dba(cca+n* (bca/#dca),function()
aba.setForeground(aba,dca[n])end)end;return aca end,add=function(aca,bca,cca)
baa=bca
dba((cca or aaa)+
(__a[#__a]~=nil and __a[#__a].t or 0),bca)return aca end,wait=function(aca,bca)aaa=bca;return aca end,rep=function(aca,bca)
if(
baa~=nil)then for n=1,bca or 1 do
dba((wait or aaa)+
(__a[#__a]~=nil and __a[#__a].t or 0),baa)end end;return aca end,onDone=function(aca,bca)
_aa:registerEvent("animation_done",bca)return aca end,onStart=function(aca,bca)
_aa:registerEvent("animation_start",bca)return aca end,setAutoDestroy=function(aca,bca)
daa=bca~=nil and bca or true;return aca end,animationDoneHandler=function(aca)
_aa:sendEvent("animation_done",aca)
if(daa)then aca.parent:removeObject(aca)aca=nil end end,animationStartHandler=function(aca)
_aa:sendEvent("animation_start",aca)end,clear=function(aca)__a={}baa=nil;aaa=0;c_a=1;a_a=0;d_a=false;return aca end,play=function(aca,bca)
aca:cancel()b_a=true;d_a=bca and true or false;c_a=1;a_a=0
if(__a[c_a]~=nil)then
if(
__a[c_a].t>0)then dd=os.startTimer(__a[c_a].t)else cba()end else aca:animationDoneHandler()end;return aca end,cancel=function(aca)if(
dd~=nil)then os.cancelTimer(dd)d_a=false end;b_a=false;return
aca end,internalObjetCall=function(aca)aca:play(caa)end,eventHandler=function(aca,bca,cca)if
(b_a)then
if(bca=="timer")and(cca==dd)then if(__a[c_a]~=nil)then cba(aca)else
aca:animationDoneHandler()end end end end}bd.__index=bd;return bd end
end; 
project['objects']['Button'] = function(...)local d=require("Object")local _a=require("utils")
local aa=_a.getValueFromXML
return
function(ba)local ca=d(ba)local da="Button"local _b="center"local ab="center"ca:setZIndex(5)
ca:setValue("Button")ca.width=12;ca.height=3
local bb={init=function(cb)
cb.bgColor=cb.parent:getTheme("ButtonBG")cb.fgColor=cb.parent:getTheme("ButtonText")end,getType=function(cb)return
da end,setHorizontalAlign=function(cb,db)_b=db end,setVerticalAlign=function(cb,db)ab=db end,setText=function(cb,db)ca:setValue(db)
return cb end,setValuesByXMLData=function(cb,db)ca.setValuesByXMLData(cb,db)
if(aa("text",db)~=
nil)then cb:setText(aa("text",db))end;if(aa("horizontalAlign",db)~=nil)then
_b=aa("horizontalAlign",db)end;if(aa("verticalAlign",db)~=nil)then
ab=aa("verticalAlign",db)end;return cb end,draw=function(cb)
if
(ca.draw(cb))then
if(cb.parent~=nil)then local db,_c=cb:getAnchorPosition()
local ac,bc=cb:getSize()local cc=_a.getTextVerticalAlign(bc,ab)
if(cb.bgColor~=false)then
cb.parent:drawBackgroundBox(db,_c,ac,bc,cb.bgColor)cb.parent:drawTextBox(db,_c,ac,bc," ")end;if(cb.fgColor~=false)then
cb.parent:drawForegroundBox(db,_c,ac,bc,cb.fgColor)end
for n=1,bc do if(n==cc)then
cb.parent:setText(db,_c+ (n-1),_a.getTextHorizontalAlign(cb:getValue(),ac,_b))end end end;cb:setVisualChanged(false)end end}return setmetatable(bb,ca)end
end; 
project['objects']['Checkbox'] = function(...)local d=require("Object")local _a=require("utils")
local aa=_a.getValueFromXML
return
function(ba)local ca=d(ba)local da="Checkbox"ca:setZIndex(5)ca:setValue(false)
ca.width=1;ca.height=1
local _b={symbol="\42",init=function(ab)
ab.bgColor=ab.parent:getTheme("CheckboxBG")ab.fgColor=ab.parent:getTheme("CheckboxText")end,getType=function(ab)return
da end,mouseHandler=function(ab,bb,cb,db,_c)
if(ca.mouseHandler(ab,bb,cb,db,_c))then
if
( (bb=="mouse_click")and(cb==1))or(bb=="monitor_touch")then
if(ab:getValue()~=true)and(
ab:getValue()~=false)then ab:setValue(false)else ab:setValue(not
ab:getValue())end end;return true end;return false end,setValuesByXMLData=function(ab,bb)
ca.setValuesByXMLData(ab,bb)
if(aa("checked",bb)~=nil)then if(aa("checked",bb))then ab:setValue(true)else
ab:setValue(false)end end;return ab end,draw=function(ab)
if
(ca.draw(ab))then
if(ab.parent~=nil)then local bb,cb=ab:getAnchorPosition()
local db,_c=ab:getSize()local ac=_a.getTextVerticalAlign(_c,"center")if
(ab.bgColor~=false)then
ab.parent:drawBackgroundBox(bb,cb,db,_c,ab.bgColor)end
for n=1,_c do
if(n==ac)then
if(ab:getValue()==true)then
ab.parent:writeText(bb,
cb+ (n-1),_a.getTextHorizontalAlign(ab.symbol,db,"center"),ab.bgColor,ab.fgColor)else
ab.parent:writeText(bb,cb+ (n-1),_a.getTextHorizontalAlign(" ",db,"center"),ab.bgColor,ab.fgColor)end end end end;ab:setVisualChanged(false)end end}return setmetatable(_b,ca)end
end; 
project['objects']['Dropdown'] = function(...)local d=require("Object")local _a=require("utils")
local aa=require("utils").getValueFromXML
return
function(ba)local ca=d(ba)local da="Dropdown"ca.width=12;ca.height=1;ca:setZIndex(6)
local _b={}local ab;local bb;local cb=true;local db="left"local _c=0;local ac=16;local bc=6;local cc="\16"local dc="\31"local _d=false
local ad={getType=function(bd)
return da end,init=function(bd)
bd.bgColor=bd.parent:getTheme("DropdownBG")bd.fgColor=bd.parent:getTheme("DropdownText")
ab=bd.parent:getTheme("SelectionBG")bb=bd.parent:getTheme("SelectionText")end,setValuesByXMLData=function(bd,cd)
ca.setValuesByXMLData(bd,cd)if(aa("selectionBG",cd)~=nil)then
ab=colors[aa("selectionBG",cd)]end;if(aa("selectionFG",cd)~=nil)then
bb=colors[aa("selectionFG",cd)]end;if(aa("dropdownWidth",cd)~=nil)then
ac=aa("dropdownWidth",cd)end;if(aa("dropdownHeight",cd)~=nil)then
bc=aa("dropdownHeight",cd)end;if(aa("offset",cd)~=nil)then
_c=aa("offset",cd)end
if(cd["item"]~=nil)then local dd=cd["item"]if
(dd.properties~=nil)then dd={dd}end;for __a,a_a in pairs(dd)do
bd:addItem(aa("text",a_a),colors[aa("bg",a_a)],colors[aa("fg",a_a)])end end end,setOffset=function(bd,cd)
_c=cd;return bd end,getOffset=function(bd)return _c end,addItem=function(bd,cd,dd,__a,...)
table.insert(_b,{text=cd,bgCol=dd or bd.bgColor,fgCol=__a or bd.fgColor,args={...}})return bd end,getAll=function(bd)return _b end,removeItem=function(bd,cd)
table.remove(_b,cd)return bd end,getItem=function(bd,cd)return _b[cd]end,getItemIndex=function(bd)
local cd=bd:getValue()for dd,__a in pairs(_b)do if(__a==cd)then return dd end end end,clear=function(bd)
_b={}bd:setValue({})return bd end,getItemCount=function(bd)return#_b end,editItem=function(bd,cd,dd,__a,a_a,...)
table.remove(_b,cd)
table.insert(_b,cd,{text=dd,bgCol=__a or bd.bgColor,fgCol=a_a or bd.fgColor,args={...}})return bd end,selectItem=function(bd,cd)bd:setValue(
_b[cd]or{})return bd end,setSelectedItem=function(bd,cd,dd,__a)
ab=cd or bd.bgColor;bb=dd or bd.fgColor;cb=__a;return bd end,setDropdownSize=function(bd,cd,dd)
ac,bc=cd,dd;return bd end,mouseHandler=function(bd,cd,dd,__a,a_a)
if(_d)then
local b_a,c_a=bd:getAbsolutePosition(bd:getAnchorPosition())
if
( (cd=="mouse_click")and(dd==1))or(cd=="monitor_touch")then if(#_b>0)then
for n=1,bc do if(_b[n+_c]~=nil)then
if
(b_a<=__a)and(b_a+ac>__a)and(c_a+n==a_a)then bd:setValue(_b[n+_c])return true end end end end end
if(cd=="mouse_scroll")then _c=_c+dd;if(_c<0)then _c=0 end;if(dd==1)then
if(#_b>bc)then if(_c>#_b-bc)then _c=#_b-
bc end else _c=math.min(#_b-1,0)end end;return true end;bd:setVisualChanged()end
if(ca.mouseHandler(bd,cd,dd,__a,a_a))then _d=true else _d=false end end,draw=function(bd)
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
_c].bgCol,_b[n+_c].fgCol)end end end end end;bd:setVisualChanged(false)end end}return setmetatable(ad,ca)end
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
ba end,loadImage=function(cb,db)ca=paintutils.loadImage(db)_b=false;return cb end,shrink=function(cb)
ab()_b=true;return cb end,setValuesByXMLData=function(cb,db)aa.setValuesByXMLData(cb,db)
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
db+xPos-1,_c+yPos-1,1,1,cc[xPos])end end end end end end;cb:setVisualChanged(false)end end}return setmetatable(bb,aa)end
end; 
project['objects']['Input'] = function(...)local d=require("Object")local _a=require("utils")
local aa=_a.getValueFromXML
return
function(ba)local ca=d(ba)local da="Input"local _b="text"local ab=0;ca:setZIndex(5)
ca:setValue("")ca.width=10;ca.height=1;local bb=1;local cb=1;local db=""local _c;local ac;local bc=db;local cc=false
local dc={init=function(_d)
_d.bgColor=_d.parent:getTheme("InputBG")_d.fgColor=_d.parent:getTheme("InputFG")end,getType=function(_d)return
da end,setInputType=function(_d,ad)if
(ad=="password")or(ad=="number")or(ad=="text")then _b=ad end;return _d end,setDefaultText=function(_d,ad,bd,cd)
db=ad;_c=cd or _c;ac=bd or ac;if(_d:isFocused())then bc=""else bc=db end
return _d end,getInputType=function(_d)return _b end,setValue=function(_d,ad)
ca.setValue(_d,tostring(ad))
if not(cc)then bb=tostring(ad):len()+1 end;return _d end,getValue=function(_d)
local ad=ca.getValue(_d)return _b=="number"and tonumber(ad)or ad end,setInputLimit=function(_d,ad)ab=
tonumber(ad)or ab;return _d end,getInputLimit=function(_d)return ab end,setValuesByXMLData=function(_d,ad)
ca.setValuesByXMLData(_d,ad)local bd,cd
if(aa("defaultBG",ad)~=nil)then bd=aa("defaultBG",ad)end
if(aa("defaultFG",ad)~=nil)then cd=aa("defaultFG",ad)end;if(aa("default",ad)~=nil)then
_d:setDefaultText(aa("default",ad),cd~=nil and colors[cd],
bd~=nil and colors[bd])end
if
(aa("limit",ad)~=nil)then _d:setInputLimit(aa("limit",ad))end
if(aa("type",ad)~=nil)then _d:setInputType(aa("type",ad))end;return _d end,getFocusHandler=function(_d)
ca.getFocusHandler(_d)
if(_d.parent~=nil)then local ad,bd=_d:getAnchorPosition()bc=""if(_d.parent~=nil)then
_d.parent:setCursor(true,
ad+bb-cb,bd+math.floor(_d.height/2),_d.fgColor)end end end,loseFocusHandler=function(_d)
ca.loseFocusHandler(_d)
if(_d.parent~=nil)then _d.parent:setCursor(false)bc=db end end,keyHandler=function(_d,ad,bd)
if(ca.keyHandler(_d,ad,bd))then
local cd,dd=_d:getSize()cc=true
if(ad=="key")then
if(bd==keys.backspace)then
local d_a=tostring(ca.getValue())if(bb>1)then
_d:setValue(d_a:sub(1,bb-2)..d_a:sub(bb,d_a:len()))if(bb>1)then bb=bb-1 end
if(cb>1)then if(bb<cb)then cb=cb-1 end end end end;if(bd==keys.enter)then if(_d.parent~=nil)then end end
if(bd==
keys.right)then
local d_a=tostring(ca.getValue()):len()bb=bb+1;if(bb>d_a)then bb=d_a+1 end;if(bb<1)then bb=1 end;if
(bb<cb)or(bb>=cd+cb)then cb=bb-cd+1 end;if(cb<1)then cb=1 end end
if(bd==keys.left)then bb=bb-1;if(bb>=1)then
if(bb<cb)or(bb>=cd+cb)then cb=bb end end;if(bb<1)then bb=1 end;if(cb<1)then cb=1 end end end
if(ad=="char")then local d_a=ca.getValue()
if(d_a:len()<ab or ab<=0)then
if
(_b=="number")then local _aa=d_a;if(bd==".")or(tonumber(bd)~=nil)then
_d:setValue(d_a:sub(1,bb-1)..
bd..d_a:sub(bb,d_a:len()))bb=bb+1 end;if(
tonumber(ca.getValue())==nil)then _d:setValue(_aa)end else
_d:setValue(d_a:sub(1,
bb-1)..bd..d_a:sub(bb,d_a:len()))bb=bb+1 end;if(bb>=cd+cb)then cb=cb+1 end end end;local __a,a_a=_d:getAnchorPosition()
local b_a=tostring(ca.getValue())
local c_a=(bb<=b_a:len()and bb-1 or b_a:len())- (cb-1)if(c_a>_d.x+cd-1)then c_a=_d.x+cd-1 end;if
(_d.parent~=nil)then
_d.parent:setCursor(true,__a+c_a,a_a+math.floor(dd/2),_d.fgColor)end;cc=false end end,mouseHandler=function(_d,ad,bd,cd,dd)
if
(ca.mouseHandler(_d,ad,bd,cd,dd))then if(ad=="mouse_click")and(bd==1)then end;return true end;return false end,draw=function(_d)
if
(ca.draw(_d))then
if(_d.parent~=nil)then local ad,bd=_d:getAnchorPosition()
local cd,dd=_d:getSize()local __a=_a.getTextVerticalAlign(dd,"center")if
(_d.bgColor~=false)then
_d.parent:drawBackgroundBox(ad,bd,cd,dd,_d.bgColor)end
for n=1,dd do
if(n==__a)then
local a_a=tostring(ca.getValue())local b_a=_d.bgColor;local c_a=_d.fgColor;local d_a;if(a_a:len()<=0)then d_a=bc;b_a=_c or b_a;c_a=
ac or c_a end;d_a=bc
if(a_a~="")then d_a=a_a end;d_a=d_a:sub(cb,cd+cb-1)local _aa=cd-d_a:len()
if(_aa<0)then _aa=0 end;if(_b=="password")and(a_a~="")then
d_a=string.rep("*",d_a:len())end
d_a=d_a..string.rep(" ",_aa)_d.parent:writeText(ad,bd+ (n-1),d_a,b_a,c_a)end end end;_d:setVisualChanged(false)end end}return setmetatable(dc,ca)end
end; 
project['objects']['Label'] = function(...)local ba=require("Object")local ca=require("utils")
local da=ca.getValueFromXML;local _b=ca.createText;local ab=require("tHex")local bb=require("bigfont")
return
function(cb)
local db=ba(cb)local _c="Label"db:setZIndex(3)local ac=true;db:setValue("Label")
db.width=5;local bc="left"local cc="top"local dc=0;local _d,ad=false,false
local bd={getType=function(cd)return _c end,setText=function(cd,dd)
dd=tostring(dd)db:setValue(dd)if(ac)then cd.width=dd:len()end
if not(_d)then cd.fgColor=
cd.parent:getForeground()or colors.white end;if not(ad)then
cd.bgColor=cd.parent:getBackground()or colors.black end;return cd end,setBackground=function(cd,dd)
db.setBackground(cd,dd)ad=true;return cd end,setForeground=function(cd,dd)
db.setForeground(cd,dd)_d=true;return cd end,setTextAlign=function(cd,dd,__a)bc=dd or bc;cc=__a or cc
cd:setVisualChanged()return cd end,setFontSize=function(cd,dd)if(dd>0)and(dd<=4)then
dc=dd-1 or 0 end;return cd end,getFontSize=function(cd)return dc+1 end,setValuesByXMLData=function(cd,dd)
db.setValuesByXMLData(cd,dd)
if(da("text",dd)~=nil)then cd:setText(da("text",dd))end
if(da("verticalAlign",dd)~=nil)then cc=da("verticalAlign",dd)end;if(da("horizontalAlign",dd)~=nil)then
bc=da("horizontalAlign",dd)end;if(da("font",dd)~=nil)then
cd:setFontSize(da("font",dd))end;return cd end,setSize=function(cd,dd,__a)
db.setSize(cd,dd,__a)ac=false;cd:setVisualChanged()return cd end,draw=function(cd)
if
(db.draw(cd))then
if(cd.parent~=nil)then local dd,__a=cd:getAnchorPosition()
local a_a,b_a=cd:getSize()local c_a=ca.getTextVerticalAlign(b_a,cc)
if(cd.bgColor~=false)then
cd.parent:drawBackgroundBox(dd,__a,a_a,b_a,cd.bgColor)cd.parent:drawTextBox(dd,__a,a_a,b_a," ")end;if(cd.fgColor~=false)then
cd.parent:drawForegroundBox(dd,__a,a_a,b_a,cd.fgColor)end
if(dc==0)then
if not(ac)then
local d_a=_b(cd:getValue(),cd:getWidth())
for _aa,aaa in pairs(d_a)do cd.parent:setText(dd,__a+_aa-1,aaa)end else
for n=1,b_a do if(n==c_a)then
cd.parent:setText(dd,__a+ (n-1),ca.getTextHorizontalAlign(cd:getValue(),a_a,bc))end end end else
local d_a=bb(dc,cd:getValue(),cd.fgColor,cd.bgColor or colors.black)
if(ac)then cd:setSize(#d_a[1][1],#d_a[1]-1)end
for n=1,b_a do
if(n==c_a)then local _aa,aaa=cd.parent:getSize()
local baa,caa=#d_a[1][1],#d_a[1]
dd=dd or math.floor((_aa-baa)/2)+1
__a=__a or math.floor((aaa-caa)/2)+1
for i=1,caa do
cd.parent:setFG(dd,__a+i+n-2,ca.getTextHorizontalAlign(d_a[2][i],a_a,bc))
cd.parent:setBG(dd,__a+i+n-2,ca.getTextHorizontalAlign(d_a[3][i],a_a,bc,ab[cd.bgColor or colors.black]))
cd.parent:setText(dd,__a+i+n-2,ca.getTextHorizontalAlign(d_a[1][i],a_a,bc))end end end end end;cd:setVisualChanged(false)end end}return setmetatable(bd,db)end
end; 
project['objects']['List'] = function(...)local d=require("Object")local _a=require("utils")
local aa=_a.getValueFromXML
return
function(ba)local ca=d(ba)local da="List"ca.width=16;ca.height=6;ca:setZIndex(5)local _b={}
local ab;local bb;local cb=true;local db="left"local _c=0;local ac=true
local bc={init=function(cc)
cc.bgColor=cc.parent:getTheme("ListBG")cc.fgColor=cc.parent:getTheme("ListText")
ab=cc.parent:getTheme("SelectionBG")bb=cc.parent:getTheme("SelectionText")end,getType=function(cc)return
da end,addItem=function(cc,dc,_d,ad,...)
table.insert(_b,{text=dc,bgCol=_d or cc.bgColor,fgCol=ad or cc.fgColor,args={...}})if(#_b==1)then cc:setValue(_b[1])end;return cc end,setOffset=function(cc,dc)
_c=dc;return cc end,getOffset=function(cc)return _c end,removeItem=function(cc,dc)table.remove(_b,dc)
return cc end,getItem=function(cc,dc)return _b[dc]end,getAll=function(cc)return _b end,getItemIndex=function(cc)
local dc=cc:getValue()for _d,ad in pairs(_b)do if(ad==dc)then return _d end end end,clear=function(cc)
_b={}cc:setValue({})return cc end,getItemCount=function(cc)return#_b end,editItem=function(cc,dc,_d,ad,bd,...)
table.remove(_b,dc)
table.insert(_b,dc,{text=_d,bgCol=ad or cc.bgColor,fgCol=bd or cc.fgColor,args={...}})return cc end,selectItem=function(cc,dc)cc:setValue(
_b[dc]or{})return cc end,setSelectedItem=function(cc,dc,_d,ad)
ab=dc or cc.bgColor;bb=_d or cc.fgColor;cb=ad;return cc end,setScrollable=function(cc,dc)
ac=dc;return cc end,setValuesByXMLData=function(cc,dc)ca.setValuesByXMLData(cc,dc)
if(
aa("selectionBG",dc)~=nil)then ab=colors[aa("selectionBG",dc)]end;if(aa("selectionFG",dc)~=nil)then
bb=colors[aa("selectionFG",dc)]end;if(aa("scrollable",dc)~=nil)then
if
(aa("scrollable",dc))then cc:setScrollable(true)else cc:setScrollable(false)end end;if
(aa("offset",dc)~=nil)then _c=aa("offset",dc)end
if(dc["item"]~=nil)then
local _d=dc["item"]if(_d.properties~=nil)then _d={_d}end;for ad,bd in pairs(_d)do
cc:addItem(aa("text",bd),colors[aa("bg",bd)],colors[aa("fg",bd)])end end;return cc end,mouseHandler=function(cc,dc,_d,ad,bd)
local cd,dd=cc:getAbsolutePosition(cc:getAnchorPosition())local __a,a_a=cc:getSize()
if

(cd<=ad)and(cd+__a>ad)and(dd<=bd)and(dd+a_a>bd)and(cc:isVisible())then
if
( ( (dc=="mouse_click")or(dc=="mouse_drag"))and(_d==1))or(dc=="monitor_touch")then
if(#_b>0)then
for n=1,a_a do
if(
_b[n+_c]~=nil)then if(cd<=ad)and(cd+__a>ad)and(dd+n-1 ==bd)then cc:setValue(_b[
n+_c])
cc:getEventSystem():sendEvent("mouse_click",cc,"mouse_click",0,ad,bd,_b[
n+_c])end end end end end
if(dc=="mouse_scroll")and(ac)then _c=_c+_d;if(_c<0)then _c=0 end
if(_d>=1)then if(#_b>a_a)then if(
_c>#_b-a_a)then _c=#_b-a_a end
if(_c>=#_b)then _c=#_b-1 end else _c=_c-1 end end end;cc:setVisualChanged()return true end end,draw=function(cc)
if
(ca.draw(cc))then
if(cc.parent~=nil)then local dc,_d=cc:getAnchorPosition()
local ad,bd=cc:getSize()if(cc.bgColor~=false)then
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
n+_c].bgCol,_b[n+_c].fgCol)end end end end;cc:setVisualChanged(false)end end}return setmetatable(bc,ca)end
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
bb={init=function(bd)bd.bgColor=bd.parent:getTheme("MenubarBG")
bd.fgColor=bd.parent:getTheme("MenubarText")db=bd.parent:getTheme("SelectionBG")
_c=bd.parent:getTheme("SelectionText")end,getType=function(bd)return
ab end,addItem=function(bd,cd,dd,__a,...)
table.insert(cb,{text=tostring(cd),bgCol=dd or bd.bgColor,fgCol=__a or bd.fgColor,args={...}})if(#cb==1)then bd:setValue(cb[1])end;return bd end,getAll=function(bd)return
cb end,getItemIndex=function(bd)local cd=bd:getValue()for dd,__a in pairs(cb)do
if(__a==cd)then return dd end end end,clear=function(bd)
cb={}bd:setValue({})return bd end,setSpace=function(bd,cd)dc=cd or dc;return bd end,setOffset=function(bd,cd)cc=
cd or 0;if(cc<0)then cc=0 end;local dd=ad()if(cc>dd)then cc=dd end;return bd end,getOffset=function(bd)return
cc end,setScrollable=function(bd,cd)_d=cd;if(cd==nil)then _d=true end;return bd end,setValuesByXMLData=function(bd,cd)
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
table.remove(cb,cd)return bd end,getItem=function(bd,cd)return cb[cd]end,getItemCount=function(bd)return#cb end,editItem=function(bd,cd,dd,__a,a_a,...)
table.remove(cb,cd)
table.insert(cb,cd,{text=dd,bgCol=__a or bd.bgColor,fgCol=a_a or bd.fgColor,args={...}})return bd end,selectItem=function(bd,cd)bd:setValue(
cb[cd]or{})return bd end,setSelectedItem=function(bd,cd,dd,__a)
db=cd or bd.bgColor;_c=dd or bd.fgColor;ac=__a;return bd end,mouseHandler=function(bd,cd,dd,__a,a_a)
if
(_b.mouseHandler(bd,cd,dd,__a,a_a))then
local b_a,c_a=bd:getAbsolutePosition(bd:getAnchorPosition())local d_a,_aa=bd:getSize()
if

(b_a<=__a)and(b_a+d_a>__a)and(c_a<=a_a)and(c_a+_aa>a_a)and(bd:isVisible())then
if(bd.parent~=nil)then bd.parent:setFocusedObject(bd)end
if(cd=="mouse_click")or(cd=="monitor_touch")then local aaa=0
for n=1,#cb do
if
(cb[n]~=nil)then
if
(b_a+aaa<=__a+cc)and(
b_a+aaa+cb[n].text:len()+ (dc*2)>__a+cc)and(c_a==a_a)then bd:setValue(cb[n])
bd:getEventSystem():sendEvent(cd,bd,cd,0,__a,a_a,cb[n])end;aaa=aaa+cb[n].text:len()+dc*2 end end end;if(cd=="mouse_scroll")and(_d)then cc=cc+dd;if(cc<0)then cc=0 end;local aaa=ad()if
(cc>aaa)then cc=aaa end end
bd:setVisualChanged(true)return true end end;return false end,draw=function(bd)
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
bd.parent:setFG(cd,dd,d_a:sub(cc+1,__a+cc))end;bd:setVisualChanged(false)end end}return setmetatable(bb,_b)end
end; 
project['objects']['Pane'] = function(...)local b=require("Object")
return
function(c)local d=b(c)local _a="Pane"
local aa={init=function(ba)
ba.bgColor=ba.parent:getTheme("PaneBG")ba.fgColor=ba.parent:getTheme("PaneBG")end,getType=function(ba)return
_a end,draw=function(ba)
if(d.draw(ba))then
if(ba.parent~=nil)then
local ca,da=ba:getAnchorPosition()local _b,ab=ba:getSize()
ba.parent:drawBackgroundBox(ca,da,_b,ab,ba.bgColor)
ba.parent:drawForegroundBox(ca,da,_b,ab,ba.fgColor)end;ba:setVisualChanged(false)end end}return setmetatable(aa,d)end
end; 
project['objects']['Program'] = function(...)local aa=require("Object")local ba=require("tHex")
local ca=require("process")local da=require("utils").getValueFromXML;local _b=string.sub
return
function(ab,bb)
local cb=aa(ab)local db="Program"cb:setZIndex(5)local _c;local ac
local function bc(bd,cd,dd,__a)local a_a,b_a=1,1
local c_a,d_a=colors.black,colors.white;local _aa=false;local aaa=false;local baa={}local caa={}local daa={}local _ba={}local aba;local bba={}for i=0,15 do local __b=2 ^i
_ba[__b]={bb:getBasaltInstance().getBaseTerm().getPaletteColour(__b)}end;local function cba()aba=(" "):rep(dd)
for n=0,15
do local __b=2 ^n;local a_b=ba[__b]bba[__b]=a_b:rep(dd)end end
local function dba()cba()local __b=aba
local a_b=bba[colors.white]local b_b=bba[colors.black]
for n=1,__a do
baa[n]=_b(baa[n]==nil and __b or baa[n]..__b:sub(1,dd-
baa[n]:len()),1,dd)
daa[n]=_b(daa[n]==nil and a_b or daa[n]..
a_b:sub(1,dd-daa[n]:len()),1,dd)
caa[n]=_b(caa[n]==nil and b_b or caa[n]..
b_b:sub(1,dd-caa[n]:len()),1,dd)end end;dba()local function _ca()
if a_a>=1 and b_a>=1 and a_a<=dd and b_a<=__a then else end end
local function aca(__b,a_b,b_b)local c_b=a_a;local d_b=c_b+#__b-1
if
b_a>=1 and b_a<=__a then
if c_b<=dd and d_b>=1 then
if c_b==1 and d_b==dd then
baa[b_a]=__b;daa[b_a]=a_b;caa[b_a]=b_b else local _ab,aab,bab
if c_b<1 then local dbb=1 -c_b+1
local _cb=dd-c_b+1;_ab=_b(__b,dbb,_cb)aab=_b(a_b,dbb,_cb)bab=_b(b_b,dbb,_cb)elseif
d_b>dd then local dbb=dd-c_b+1;_ab=_b(__b,1,dbb)aab=_b(a_b,1,dbb)
bab=_b(b_b,1,dbb)else _ab=__b;aab=a_b;bab=b_b end;local cab=baa[b_a]local dab=daa[b_a]local _bb=caa[b_a]local abb,bbb,cbb
if c_b>1 then local dbb=c_b-1;abb=
_b(cab,1,dbb).._ab;bbb=_b(dab,1,dbb)..aab
cbb=_b(_bb,1,dbb)..bab else abb=_ab;bbb=aab;cbb=bab end
if d_b<dd then local dbb=d_b+1;abb=abb.._b(cab,dbb,dd)
bbb=bbb.._b(dab,dbb,dd)cbb=cbb.._b(_bb,dbb,dd)end;baa[b_a]=abb;daa[b_a]=bbb;caa[b_a]=cbb end end;a_a=d_b+1;if(aaa)then _ca()end end end
local function bca(__b,a_b,b_b)
if(b_b~=nil)then local c_b=baa[a_b]if(c_b~=nil)then
baa[a_b]=_b(c_b:sub(1,__b-1)..b_b..c_b:sub(__b+
(b_b:len()),dd),1,dd)end end end
local function cca(__b,a_b,b_b)
if(b_b~=nil)then local c_b=caa[a_b]if(c_b~=nil)then
caa[a_b]=_b(c_b:sub(1,__b-1)..b_b..c_b:sub(__b+
(b_b:len()),dd),1,dd)end end end
local function dca(__b,a_b,b_b)
if(b_b~=nil)then local c_b=daa[a_b]if(c_b~=nil)then
daa[a_b]=_b(c_b:sub(1,__b-1)..b_b..c_b:sub(__b+
(b_b:len()),dd),1,dd)end end end
local _da=function(__b)
if type(__b)~="number"then
error("bad argument #1 (expected number, got "..type(__b)..")",2)elseif ba[__b]==nil then
error("Invalid color (got "..__b..")",2)end;d_a=__b end
local ada=function(__b)
if type(__b)~="number"then
error("bad argument #1 (expected number, got "..type(__b)..")",2)elseif ba[__b]==nil then
error("Invalid color (got "..__b..")",2)end;c_a=__b end
local bda=function(__b,a_b,b_b,c_b)if type(__b)~="number"then
error("bad argument #1 (expected number, got "..type(__b)..")",2)end
if ba[__b]==nil then error("Invalid color (got "..
__b..")",2)end;local d_b
if
type(a_b)=="number"and b_b==nil and c_b==nil then d_b={colours.rgb8(a_b)}_ba[__b]=d_b else if
type(a_b)~="number"then
error("bad argument #2 (expected number, got "..type(a_b)..")",2)end;if type(b_b)~="number"then
error(
"bad argument #3 (expected number, got "..type(b_b)..")",2)end;if type(c_b)~="number"then
error(
"bad argument #4 (expected number, got "..type(c_b)..")",2)end;d_b=_ba[__b]d_b[1]=a_b
d_b[2]=b_b;d_b[3]=c_b end end
local cda=function(__b)if type(__b)~="number"then
error("bad argument #1 (expected number, got "..type(__b)..")",2)end
if ba[__b]==nil then error("Invalid color (got "..
__b..")",2)end;local a_b=_ba[__b]return a_b[1],a_b[2],a_b[3]end
local dda={setCursorPos=function(__b,a_b)if type(__b)~="number"then
error("bad argument #1 (expected number, got "..type(__b)..")",2)end;if type(a_b)~="number"then
error(
"bad argument #2 (expected number, got "..type(a_b)..")",2)end;a_a=math.floor(__b)
b_a=math.floor(a_b)if(aaa)then _ca()end end,getCursorPos=function()return
a_a,b_a end,setCursorBlink=function(__b)if type(__b)~="boolean"then
error("bad argument #1 (expected boolean, got "..
type(__b)..")",2)end;_aa=__b end,getCursorBlink=function()return
_aa end,getPaletteColor=cda,getPaletteColour=cda,setBackgroundColor=ada,setBackgroundColour=ada,setTextColor=_da,setTextColour=_da,setPaletteColor=bda,setPaletteColour=bda,getBackgroundColor=function()return c_a end,getBackgroundColour=function()return c_a end,getSize=function()return dd,__a end,getTextColor=function()return
d_a end,getTextColour=function()return d_a end,basalt_resize=function(__b,a_b)dd,__a=__b,a_b;dba()end,basalt_reposition=function(__b,a_b)
bd,cd=__b,a_b end,basalt_setVisible=function(__b)aaa=__b end,drawBackgroundBox=function(__b,a_b,b_b,c_b,d_b)for n=1,c_b do
cca(__b,a_b+ (n-1),ba[d_b]:rep(b_b))end end,drawForegroundBox=function(__b,a_b,b_b,c_b,d_b)
for n=1,c_b do dca(__b,
a_b+ (n-1),ba[d_b]:rep(b_b))end end,drawTextBox=function(__b,a_b,b_b,c_b,d_b)for n=1,c_b do
bca(__b,a_b+ (n-1),d_b:rep(b_b))end end,writeText=function(__b,a_b,b_b,c_b,d_b)
c_b=c_b or c_a;d_b=d_b or d_a;bca(bd,a_b,b_b)
cca(__b,a_b,ba[c_b]:rep(b_b:len()))dca(__b,a_b,ba[d_b]:rep(b_b:len()))end,basalt_update=function()if(
bb~=nil)then
for n=1,__a do bb:setText(bd,cd+ (n-1),baa[n])
bb:setBG(bd,cd+ (n-1),caa[n])bb:setFG(bd,cd+ (n-1),daa[n])end end end,scroll=function(__b)if
type(__b)~="number"then
error("bad argument #1 (expected number, got "..type(__b)..")",2)end
if __b~=0 then local a_b=aba
local b_b=bba[d_a]local c_b=bba[c_a]
for newY=1,__a do local d_b=newY+__b
if d_b>=1 and d_b<=__a then
baa[newY]=baa[d_b]caa[newY]=caa[d_b]daa[newY]=daa[d_b]else baa[newY]=a_b
daa[newY]=b_b;caa[newY]=c_b end end end;if(aaa)then _ca()end end,isColor=function()return
bb:getBasaltInstance().getBaseTerm().isColor()end,isColour=function()return
bb:getBasaltInstance().getBaseTerm().isColor()end,write=function(__b)
__b=tostring(__b)if(aaa)then
aca(__b,ba[d_a]:rep(__b:len()),ba[c_a]:rep(__b:len()))end end,clearLine=function()
if
(aaa)then bca(1,b_a,(" "):rep(dd))
cca(1,b_a,ba[c_a]:rep(dd))dca(1,b_a,ba[d_a]:rep(dd))end;if(aaa)then _ca()end end,clear=function()
for n=1,__a
do bca(1,n,(" "):rep(dd))
cca(1,n,ba[c_a]:rep(dd))dca(1,n,ba[d_a]:rep(dd))end;if(aaa)then _ca()end end,blit=function(__b,a_b,b_b)if
type(__b)~="string"then
error("bad argument #1 (expected string, got "..type(__b)..")",2)end;if type(a_b)~="string"then
error(
"bad argument #2 (expected string, got "..type(a_b)..")",2)end;if type(b_b)~="string"then
error(
"bad argument #3 (expected string, got "..type(b_b)..")",2)end
if
#a_b~=#__b or#b_b~=#__b then error("Arguments must be the same length",2)end;if(aaa)then aca(__b,a_b,b_b)end end}return dda end;cb.width=30;cb.height=12;local cc=bc(1,1,cb.width,cb.height)local dc
local _d=false;local ad={}
_c={init=function(bd)bd.bgColor=bd.parent:getTheme("ProgramBG")end,getType=function(bd)return
db end,show=function(bd)cb.show(bd)
cc.setBackgroundColor(bd.bgColor)cc.setTextColor(bd.fgColor)
cc.basalt_setVisible(true)return bd end,hide=function(bd)
cb.hide(bd)cc.basalt_setVisible(false)return bd end,setPosition=function(bd,cd,dd,__a)
cb.setPosition(bd,cd,dd,__a)
cc.basalt_reposition(bd:getAnchorPosition())return bd end,setValuesByXMLData=function(bd,cd)
cb.setValuesByXMLData(bd,cd)if(da("path",cd)~=nil)then ac=da("path",cd)end;if(
da("execute",cd)~=nil)then
if(da("execute",cd))then if(ac~=nil)then bd:execute(ac)end end end end,getBasaltWindow=function()return
cc end,getBasaltProcess=function()return dc end,setSize=function(bd,cd,dd,__a)cb.setSize(bd,cd,dd,__a)
cc.basalt_resize(bd:getSize())return bd end,getStatus=function(bd)if(dc~=nil)then
return dc:getStatus()end;return"inactive"end,execute=function(bd,cd,...)
ac=cd or ac;dc=ca:new(ac,cc,...)
cc.setBackgroundColor(colors.black)cc.setTextColor(colors.white)cc.clear()
cc.setCursorPos(1,1)cc.setBackgroundColor(bd.bgColor)
cc.setTextColor(bd.fgColor)cc.basalt_setVisible(true)dc:resume()_d=false;return bd end,stop=function(bd)if(
dc~=nil)then
if not(dc:isDead())then dc:resume("terminate")if(dc:isDead())then
if(
bd.parent~=nil)then bd.parent:setCursor(false)end end end end
return bd end,pause=function(bd,cd)_d=
cd or(not _d)
if(dc~=nil)then if not(dc:isDead())then if not(_d)then
bd:injectEvents(ad)ad={}end end end;return bd end,isPaused=function(bd)
return _d end,injectEvent=function(bd,cd,dd,__a,a_a,b_a,c_a)
if(dc~=nil)then
if not(dc:isDead())then if(_d==false)or(c_a)then
dc:resume(cd,dd,__a,a_a,b_a)else
table.insert(ad,{event=cd,args={dd,__a,a_a,b_a}})end end end;return bd end,getQueuedEvents=function(bd)return
ad end,updateQueuedEvents=function(bd,cd)ad=cd or ad;return bd end,injectEvents=function(bd,cd)if(dc~=nil)then
if
not(dc:isDead())then for dd,__a in pairs(cd)do
dc:resume(__a.event,table.unpack(__a.args))end end end;return bd end,mouseHandler=function(bd,cd,dd,__a,a_a)
if
(cb.mouseHandler(bd,cd,dd,__a,a_a))then if(dc==nil)then return false end
if not(dc:isDead())then
if not(_d)then
local b_a,c_a=bd:getAbsolutePosition(bd:getAnchorPosition(
nil,nil,true))dc:resume(cd,dd,__a-b_a+1,a_a-c_a+1)end end;return true end end,keyHandler=function(bd,cd,dd)
cb.keyHandler(bd,cd,dd)if(bd:isFocused())then if(dc==nil)then return false end
if not(dc:isDead())then if not(_d)then if
(bd.draw)then dc:resume(cd,dd)end end end end end,getFocusHandler=function(bd)
cb.getFocusHandler(bd)
if(dc~=nil)then
if not(dc:isDead())then
if not(_d)then
if(bd.parent~=nil)then
local cd,dd=cc.getCursorPos()local __a,a_a=bd:getAnchorPosition()
if(bd.parent~=nil)then
local b_a,c_a=bd:getSize()
if
(__a+cd-1 >=1 and __a+cd-1 <=__a+b_a-1 and
dd+a_a-1 >=1 and dd+a_a-1 <=a_a+c_a-1)then
bd.parent:setCursor(cc.getCursorBlink(),__a+cd-1,dd+a_a-1,cc.getTextColor())end end end end end end end,loseFocusHandler=function(bd)
cb.loseFocusHandler(bd)
if(dc~=nil)then if not(dc:isDead())then if(bd.parent~=nil)then
bd.parent:setCursor(false)end end end end,eventHandler=function(bd,cd,dd,__a,a_a,b_a)if
(dc==nil)then return end
if not(dc:isDead())then
if not(_d)then
if



(cd~="mouse_click")and
(cd~="monitor_touch")and(cd~="mouse_up")and(cd~=
"mouse_scroll")and(cd~="mouse_drag")and(cd~="key_up")and(
cd~="key")and(cd~="char")and(cd~="terminate")then dc:resume(cd,dd,__a,a_a,b_a)end
if(bd:isFocused())then local c_a,d_a=bd:getAnchorPosition()
local _aa,aaa=cc.getCursorPos()
if(bd.parent~=nil)then local baa,caa=bd:getSize()
if
(
c_a+_aa-1 >=1 and c_a+_aa-1 <=
c_a+baa-1 and aaa+d_a-1 >=1 and aaa+d_a-1 <=d_a+caa-1)then
bd.parent:setCursor(cc.getCursorBlink(),c_a+_aa-1,aaa+d_a-1,cc.getTextColor())end end
if(cd=="terminate")and(bd:isFocused())then bd:stop()end end else
if




(cd~="mouse_click")and(cd~="monitor_touch")and(cd~="mouse_up")and(cd~="mouse_scroll")and
(cd~="mouse_drag")and(cd~="key_up")and(cd~="key")and(cd~="char")and(cd~="terminate")then
table.insert(ad,{event=cd,args={dd,__a,a_a,b_a}})end end end end,draw=function(bd)
if
(cb.draw(bd))then
if(bd.parent~=nil)then local cd,dd=bd:getAnchorPosition()
local __a,a_a=bd:getSize()cc.basalt_reposition(cd,dd)if(bd.bgColor~=false)then
bd.parent:drawBackgroundBox(cd,dd,__a,a_a,bd.bgColor)end;cc.basalt_update()end;bd:setVisualChanged(false)end end}return setmetatable(_c,cb)end
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
cb=ac;return _c end,setProgressBar=function(_c,ac,bc,cc)da=ac or da;_b=bc or _b;ab=cc or ab;return _c end,setBackgroundSymbol=function(_c,ac)
bb=ac:sub(1,1)return _c end,setProgress=function(_c,ac)
if(ac>=0)and(ac<=100)and(ca~=ac)then ca=ac
_c:setValue(ca)if(ca==100)then _c:progressDoneHandler()end end;return _c end,getProgress=function(_c)
return ca end,onProgressDone=function(_c,ac)_c:registerEvent("progress_done",ac)return _c end,progressDoneHandler=function(_c)
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
_c.parent:drawTextBox(ac,bc,cc/100 *ca,dc,_b)end end;_c:setVisualChanged(false)end end}return setmetatable(db,aa)end
end; 
project['objects']['Radio'] = function(...)local d=require("Object")local _a=require("utils")
local aa=_a.getValueFromXML
return
function(ba)local ca=d(ba)local da="Radio"ca.width=8;ca:setZIndex(5)local _b={}local ab;local bb;local cb
local db;local _c;local ac;local bc=true;local cc="\7"local dc="left"
local _d={init=function(ad)
ad.bgColor=ad.parent:getTheme("MenubarBG")ad.fgColor=ad.parent:getTheme("MenubarFG")
ab=ad.parent:getTheme("SelectionBG")bb=ad.parent:getTheme("SelectionText")
cb=ad.parent:getTheme("MenubarBG")db=ad.parent:getTheme("MenubarText")end,getType=function(ad)return
da end,setValuesByXMLData=function(ad,bd)ca.setValuesByXMLData(ad,bd)
if(
aa("selectionBG",bd)~=nil)then ab=colors[aa("selectionBG",bd)]end;if(aa("selectionFG",bd)~=nil)then
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
cd or 1,y=dd or 1,text=bd,bgCol=__a or ad.bgColor,fgCol=a_a or ad.fgColor,args={...}})if(#_b==1)then ad:setValue(_b[1])end;return ad end,getAll=function(ad)return
_b end,removeItem=function(ad,bd)table.remove(_b,bd)return ad end,getItem=function(ad,bd)return
_b[bd]end,getItemIndex=function(ad)local bd=ad:getValue()for cd,dd in pairs(_b)do
if(dd==bd)then return cd end end end,clear=function(ad)
_b={}ad:setValue({})return ad end,getItemCount=function(ad)return#_b end,editItem=function(ad,bd,cd,dd,__a,a_a,b_a,...)
table.remove(_b,bd)
table.insert(_b,bd,{x=dd or 1,y=__a or 1,text=cd,bgCol=a_a or ad.bgColor,fgCol=b_a or ad.fgColor,args={...}})return ad end,selectItem=function(ad,bd)ad:setValue(
_b[bd]or{})return ad end,setActiveSymbol=function(ad,bd)
cc=bd:sub(1,1)return ad end,setSelectedItem=function(ad,bd,cd,dd,__a,a_a)ab=bd or ab;bb=cd or bb;cb=dd or cb
db=__a or db;bc=a_a~=nil and a_a or true;return ad end,mouseHandler=function(ad,bd,cd,dd,__a)
local a_a,b_a=ad:getAbsolutePosition(ad:getAnchorPosition())
if
( (bd=="mouse_click")and(cd==1))or(bd=="monitor_touch")then
if(#_b>0)then
for c_a,d_a in pairs(_b)do
if(a_a+d_a.x-1 <=dd)and(
a_a+d_a.x-1 +d_a.text:len()+2 >=dd)and(
b_a+d_a.y-1 ==__a)then
ad:setValue(d_a)
if(ad.parent~=nil)then ad.parent:setFocusedObject(ad)end
ad:getEventSystem():sendEvent(bd,ad,bd,cd,dd,__a)ad:setVisualChanged()return true end end end end;return false end,draw=function(ad)
if
(ca.draw(ad))then
if(ad.parent~=nil)then local bd,cd=ad:getAnchorPosition()
for dd,__a in pairs(_b)do
if(__a==
ad:getValue())then if(dc=="left")then
ad.parent:writeText(__a.x+bd-1,__a.y+cd-1,cc,cb,db)
ad.parent:writeText(__a.x+2 +bd-1,__a.y+cd-1,__a.text,ab,bb)end else
ad.parent:drawBackgroundBox(
__a.x+bd-1,__a.y+cd-1,1,1,_c or ad.bgColor)
ad.parent:writeText(__a.x+2 +bd-1,__a.y+cd-1,__a.text,__a.bgCol,__a.fgCol)end end end;ad:setVisualChanged(false)end end}return setmetatable(_d,ca)end
end; 
project['objects']['Scrollbar'] = function(...)local c=require("Object")
local d=require("utils").getValueFromXML
return
function(_a)local aa=c(_a)local ba="Scrollbar"aa.width=1;aa.height=8;aa:setValue(1)
aa:setZIndex(2)local ca="vertical"local da=" "local _b;local ab="\127"local bb=aa.height;local cb=1;local db=1
local _c={init=function(ac)
ac.bgColor=ac.parent:getTheme("ScrollbarBG")ac.fgColor=ac.parent:getTheme("ScrollbarText")
_b=ac.parent:getTheme("ScrollbarSymbolColor")end,getType=function(ac)return
ba end,setSymbol=function(ac,bc)da=bc:sub(1,1)ac:setVisualChanged()return ac end,setValuesByXMLData=function(ac,bc)
aa.setValuesByXMLData(ac,bc)
if(d("maxValue",bc)~=nil)then bb=d("maxValue",bc)end;if(d("backgroundSymbol",bc)~=nil)then
ab=d("backgroundSymbol",bc):sub(1,1)end;if(d("symbol",bc)~=nil)then
da=d("symbol",bc):sub(1,1)end;if(d("barType",bc)~=nil)then
ca=d("barType",bc):lower()end;if(d("symbolSize",bc)~=nil)then
ac:setSymbolSize(d("symbolSize",bc))end;if(d("symbolColor",bc)~=nil)then
_b=colors[d("symbolColor",bc)]end;if(d("index",bc)~=nil)then
ac:setIndex(d("index",bc))end end,setIndex=function(ac,bc)
cb=bc;if(cb<1)then cb=1 end;local cc,dc=ac:getSize()
cb=math.min(cb,(ca=="vertical"and dc or
cc)- (db-1))
ac:setValue(bb/ (ca=="vertical"and dc or cc)*cb)return ac end,getIndex=function(ac)return
cb end,setSymbolSize=function(ac,bc)db=tonumber(bc)or 1;local cc,dc=ac:getSize()
if(ca==
"vertical")then
ac:setValue(cb-1 * (bb/ (dc- (db-1)))-
(bb/ (dc- (db-1))))elseif(ca=="horizontal")then
ac:setValue(cb-1 * (bb/ (cc- (db-1)))- (bb/ (cc-
(db-1))))end;ac:setVisualChanged()return ac end,setMaxValue=function(ac,bc)
bb=bc;return ac end,setBackgroundSymbol=function(ac,bc)ab=string.sub(bc,1,1)
ac:setVisualChanged()return ac end,setSymbolColor=function(ac,bc)_b=bc
ac:setVisualChanged()return ac end,setBarType=function(ac,bc)ca=bc:lower()return ac end,mouseHandler=function(ac,bc,cc,dc,_d)
if
(aa.mouseHandler(ac,bc,cc,dc,_d))then
local ad,bd=ac:getAbsolutePosition(ac:getAnchorPosition())local cd,dd=ac:getSize()
if
(
( (bc=="mouse_click")or(bc=="mouse_drag"))and(cc==1))or(bc=="monitor_touch")then
if(ca=="horizontal")then
for _index=0,cd do
if
(ad+_index==dc)and(bd<=_d)and(bd+dd>_d)then cb=math.min(_index+1,cd- (db-1))
ac:setValue(bb/cd* (cb))ac:setVisualChanged()end end end
if(ca=="vertical")then
for _index=0,dd do
if
(bd+_index==_d)and(ad<=dc)and(ad+cd>dc)then cb=math.min(_index+1,dd- (db-1))
ac:setValue(bb/dd* (cb))ac:setVisualChanged()end end end end
if(bc=="mouse_scroll")then cb=cb+cc;if(cb<1)then cb=1 end
cb=math.min(cb,(
ca=="vertical"and dd or cd)- (db-1))
ac:setValue(bb/ (ca=="vertical"and dd or cd)*cb)end;return true end end,draw=function(ac)
if
(aa.draw(ac))then
if(ac.parent~=nil)then local bc,cc=ac:getAnchorPosition()
local dc,_d=ac:getSize()
if(ca=="horizontal")then
ac.parent:writeText(bc,cc,ab:rep(cb-1),ac.bgColor,ac.fgColor)
ac.parent:writeText(bc+cb-1,cc,da:rep(db),_b,_b)
ac.parent:writeText(bc+cb+db-1,cc,ab:rep(dc- (cb+db-1)),ac.bgColor,ac.fgColor)end
if(ca=="vertical")then
for n=0,_d-1 do
if(cb==n+1)then for curIndexOffset=0,math.min(db-1,_d)do
ac.parent:writeText(bc,cc+n+curIndexOffset,da,_b,_b)end else if
(n+1 <cb)or(n+1 >cb-1 +db)then
ac.parent:writeText(bc,cc+n,ab,ac.bgColor,ac.fgColor)end end end end end;ac:setVisualChanged(false)end end}return setmetatable(_c,aa)end
end; 
project['objects']['Slider'] = function(...)local c=require("Object")
local d=require("utils").getValueFromXML
return
function(_a)local aa=c(_a)local ba="Slider"aa.width=8;aa.height=1;aa:setValue(1)
local ca="horizontal"local da=" "local _b;local ab="\140"local bb=aa.width;local cb=1;local db=1
local _c={init=function(ac)
ac.bgColor=ac.parent:getTheme("SliderBG")ac.fgColor=ac.parent:getTheme("SliderText")
_b=ac.parent:getTheme("SliderSymbolColor")end,getType=function(ac)
return ba end,setSymbol=function(ac,bc)da=bc:sub(1,1)ac:setVisualChanged()return ac end,setValuesByXMLData=function(ac,bc)
aa.setValuesByXMLData(ac,bc)
if(d("maxValue",bc)~=nil)then bb=d("maxValue",bc)end;if(d("backgroundSymbol",bc)~=nil)then
ab=d("backgroundSymbol",bc):sub(1,1)end;if(d("barType",bc)~=nil)then
ca=d("barType",bc):lower()end;if(d("symbol",bc)~=nil)then
da=d("symbol",bc):sub(1,1)end;if(d("symbolSize",bc)~=nil)then
ac:setSymbolSize(d("symbolSize",bc))end;if(d("symbolColor",bc)~=nil)then
_b=colors[d("symbolColor",bc)]end;if(d("index",bc)~=nil)then
ac:setIndex(d("index",bc))end end,setIndex=function(ac,bc)
cb=bc;if(cb<1)then cb=1 end;local cc,dc=ac:getSize()
cb=math.min(cb,(ca=="vertical"and dc or
cc)- (db-1))
ac:setValue(bb/ (ca=="vertical"and dc or cc)*cb)return ac end,getIndex=function(ac)return
cb end,setSymbolSize=function(ac,bc)db=tonumber(bc)or 1
if(ca=="vertical")then
ac:setValue(cb-1 * (bb/
(h- (db-1)))- (bb/ (h- (db-1))))elseif(ca=="horizontal")then
ac:setValue(cb-1 * (bb/ (w- (db-1)))- (bb/
(w- (db-1))))end;ac:setVisualChanged()return ac end,setMaxValue=function(ac,bc)
bb=bc;return ac end,setBackgroundSymbol=function(ac,bc)ab=string.sub(bc,1,1)
ac:setVisualChanged()return ac end,setSymbolColor=function(ac,bc)_b=bc
ac:setVisualChanged()return ac end,setBarType=function(ac,bc)ca=bc:lower()return ac end,mouseHandler=function(ac,bc,cc,dc,_d)
if
(aa.mouseHandler(ac,bc,cc,dc,_d))then
local ad,bd=ac:getAbsolutePosition(ac:getAnchorPosition())local cd,dd=ac:getSize()
if
(
( (bc=="mouse_click")or(bc=="mouse_drag"))and(cc==1))or(bc=="monitor_touch")then
if(ca=="horizontal")then
for _index=0,cd do
if
(ad+_index==dc)and(bd<=_d)and(bd+dd>_d)then cb=math.min(_index+1,cd- (db-1))
ac:setValue(bb/cd* (cb))ac:setVisualChanged()end end end
if(ca=="vertical")then
for _index=0,dd do
if
(bd+_index==_d)and(ad<=dc)and(ad+cd>dc)then cb=math.min(_index+1,dd- (db-1))
ac:setValue(bb/dd* (cb))ac:setVisualChanged()end end end end
if(bc=="mouse_scroll")then cb=cb+cc;if(cb<1)then cb=1 end
cb=math.min(cb,(
ca=="vertical"and dd or cd)- (db-1))
ac:setValue(bb/ (ca=="vertical"and dd or cd)*cb)end;return true end end,draw=function(ac)
if
(aa.draw(ac))then
if(ac.parent~=nil)then local bc,cc=ac:getAnchorPosition()
local dc,_d=ac:getSize()
if(ca=="horizontal")then
ac.parent:writeText(bc,cc,ab:rep(cb-1),ac.bgColor,ac.fgColor)
ac.parent:writeText(bc+cb-1,cc,da:rep(db),_b,_b)
ac.parent:writeText(bc+cb+db-1,cc,ab:rep(dc- (cb+db-1)),ac.bgColor,ac.fgColor)end
if(ca=="vertical")then
for n=0,_d-1 do
if(cb==n+1)then for curIndexOffset=0,math.min(db-1,_d)do
ac.parent:writeText(bc,cc+n+curIndexOffset,da,_b,_b)end else if
(n+1 <cb)or(n+1 >cb-1 +db)then
ac.parent:writeText(bc,cc+n,ab,ac.bgColor,ac.fgColor)end end end end end;ac:setVisualChanged(false)end end}return setmetatable(_c,aa)end
end; 
project['objects']['Switch'] = function(...)local c=require("Object")
local d=require("utils").getValueFromXML
return
function(_a)local aa=c(_a)local ba="Switch"aa.width=2;aa.height=1
aa.bgColor=colors.lightGray;aa.fgColor=colors.gray;aa:setValue(false)aa:setZIndex(5)
local ca=colors.black;local da=colors.red;local _b=colors.green
local ab={init=function(bb)
bb.bgColor=bb.parent:getTheme("SwitchBG")bb.fgColor=bb.parent:getTheme("SwitchText")
ca=bb.parent:getTheme("SwitchBGSymbol")da=bb.parent:getTheme("SwitchInactive")
_b=bb.parent:getTheme("SwitchActive")end,getType=function(bb)return
ba end,setSymbolColor=function(bb,cb)ca=cb;bb:setVisualChanged()return bb end,setActiveBackground=function(bb,cb)
_b=cb;bb:setVisualChanged()return bb end,setInactiveBackground=function(bb,cb)da=cb
bb:setVisualChanged()return bb end,setValuesByXMLData=function(bb,cb)aa.setValuesByXMLData(bb,cb)
if(
d("inactiveBG",cb)~=nil)then da=colors[d("inactiveBG",cb)]end
if(d("activeBG",cb)~=nil)then _b=colors[d("activeBG",cb)]end;if(d("symbolColor",cb)~=nil)then
ca=colors[d("symbolColor",cb)]end end,mouseHandler=function(bb,cb,db,_c,ac)
if
(aa.mouseHandler(bb,cb,db,_c,ac))then
local bc,cc=bb:getAbsolutePosition(bb:getAnchorPosition())
if
( (cb=="mouse_click")and(db==1))or(cb=="monitor_touch")then bb:setValue(not bb:getValue())end;return true end end,draw=function(bb)
if
(aa.draw(bb))then
if(bb.parent~=nil)then local cb,db=bb:getAnchorPosition()
local _c,ac=bb:getSize()
bb.parent:drawBackgroundBox(cb,db,_c,ac,bb.bgColor)
if(bb:getValue())then
bb.parent:drawBackgroundBox(cb,db,1,ac,_b)bb.parent:drawBackgroundBox(cb+1,db,1,ac,ca)else
bb.parent:drawBackgroundBox(cb,db,1,ac,ca)bb.parent:drawBackgroundBox(cb+1,db,1,ac,da)end end;bb:setVisualChanged(false)end end}return setmetatable(ab,aa)end
end; 
project['objects']['Textfield'] = function(...)local d=require("Object")local _a=require("tHex")
local aa=require("utils").getValueFromXML
return
function(ba)local ca=d(ba)local da="Textfield"local _b,ab,bb,cb=1,1,1,1;local db={""}local _c={""}local ac={""}
local bc={}local cc={}ca.width=30;ca.height=12;ca:setZIndex(5)
local function dc(cd,dd)local __a={}
if(cd:len()>0)then
for a_a in
string.gmatch(cd,dd)do local b_a,c_a=string.find(cd,a_a)
if(b_a~=nil)and(c_a~=nil)then
table.insert(__a,b_a)table.insert(__a,c_a)
local d_a=string.sub(cd,1,(b_a-1))local _aa=string.sub(cd,c_a+1,cd:len())cd=d_a..
(":"):rep(a_a:len()).._aa end end end;return __a end
local function _d(cd,dd)dd=dd or cb
local __a=_a[cd.fgColor]:rep(ac[dd]:len())
local a_a=_a[cd.bgColor]:rep(_c[dd]:len())
for b_a,c_a in pairs(cc)do local d_a=dc(db[dd],c_a[1])
if(#d_a>0)then
for x=1,#d_a/2 do local _aa=x*2 -1;if(
c_a[2]~=nil)then
__a=__a:sub(1,d_a[_aa]-1).._a[c_a[2] ]:rep(d_a[_aa+1]-
(d_a[_aa]-1))..
__a:sub(d_a[_aa+1]+1,__a:len())end;if
(c_a[3]~=nil)then
a_a=a_a:sub(1,d_a[_aa]-1)..

_a[c_a[3] ]:rep(d_a[_aa+1]- (d_a[_aa]-1))..a_a:sub(d_a[_aa+1]+1,a_a:len())end end end end
for b_a,c_a in pairs(bc)do
for d_a,_aa in pairs(c_a)do local aaa=dc(db[dd],_aa)
if(#aaa>0)then for x=1,#aaa/2 do local baa=x*2 -1
__a=__a:sub(1,
aaa[baa]-1)..

_a[b_a]:rep(aaa[baa+1]- (aaa[baa]-1))..__a:sub(aaa[baa+1]+1,__a:len())end end end end;ac[dd]=__a;_c[dd]=a_a end;local function ad(cd)for n=1,#db do _d(cd,n)end end
local bd={init=function(cd)
cd.bgColor=cd.parent:getTheme("TextfieldBG")cd.fgColor=cd.parent:getTheme("TextfieldText")end,getType=function(cd)return
da end,setBackground=function(cd,dd)ca.setBackground(cd,dd)ad(cd)return cd end,setForeground=function(cd,dd)
ca.setForeground(cd,dd)ad(cd)return cd end,setValuesByXMLData=function(cd,dd)
ca.setValuesByXMLData(cd,dd)
if(dd["lines"]~=nil)then local __a=dd["lines"]["line"]if
(__a.properties~=nil)then __a={__a}end;for a_a,b_a in pairs(__a)do
cd:addLine(b_a:value())end end
if(dd["keywords"]~=nil)then
for __a,a_a in pairs(dd["keywords"])do
if(colors[__a]~=nil)then
local b_a=a_a;if(b_a.properties~=nil)then b_a={b_a}end;local c_a={}
for d_a,_aa in pairs(b_a)do
local aaa=_aa["keyword"]if(_aa["keyword"].properties~=nil)then
aaa={_aa["keyword"]}end;for baa,caa in pairs(aaa)do
table.insert(c_a,caa:value())end end;cd:addKeywords(colors[__a],c_a)end end end
if(dd["rules"]~=nil)then
if(dd["rules"]["rule"]~=nil)then
local __a=dd["rules"]["rule"]if(dd["rules"]["rule"].properties~=nil)then
__a={dd["rules"]["rule"]}end
for a_a,b_a in pairs(__a)do if(aa("pattern",b_a)~=nil)then
cd:addRule(aa("pattern",b_a),colors[aa("fg",b_a)],colors[aa("bg",b_a)])end end end end end,getLines=function(cd)return
db end,getLine=function(cd,dd)return db[dd]end,editLine=function(cd,dd,__a)db[dd]=__a or db[dd]
return cd end,clear=function(cd)db={""}_c={""}ac={""}_b,ab,bb,cb=1,1,1,1;return cd end,addLine=function(cd,dd,__a)
if(
dd~=nil)then
if(#db==1)and(db[1]=="")then db[1]=dd
_c[1]=_a[cd.bgColor]:rep(dd:len())ac[1]=_a[cd.fgColor]:rep(dd:len())return cd end
if(__a~=nil)then table.insert(db,__a,dd)
table.insert(_c,__a,_a[cd.bgColor]:rep(dd:len()))
table.insert(ac,_a[cd.fgColor]:rep(dd:len()))else table.insert(db,dd)
table.insert(_c,_a[cd.bgColor]:rep(dd:len()))
table.insert(ac,_a[cd.fgColor]:rep(dd:len()))end end;return cd end,addKeywords=function(cd,dd,__a)if(
bc[dd]==nil)then bc[dd]={}end;for a_a,b_a in pairs(__a)do
table.insert(bc[dd],b_a)end;return cd end,addRule=function(cd,dd,__a,a_a)
table.insert(cc,{dd,__a,a_a})return cd end,editRule=function(cd,dd,__a,a_a)
for b_a,c_a in pairs(cc)do if(c_a[1]==dd)then
cc[b_a][2]=__a;cc[b_a][3]=a_a end end;return cd end,removeRule=function(cd,dd)
for __a,a_a in pairs(cc)do if(
a_a[1]==dd)then table.remove(cc,__a)end end;return cd end,setKeywords=function(cd,dd,__a)bc[dd]=__a;return cd end,removeLine=function(cd,dd)table.remove(db,
dd or#db)
if(#db<=0)then table.insert(db,"")end;return cd end,getTextCursor=function(cd)return bb,cb end,getFocusHandler=function(cd)
ca.getFocusHandler(cd)
if(cd.parent~=nil)then local dd,__a=cd:getAnchorPosition()if(cd.parent~=nil)then
cd.parent:setCursor(true,
dd+bb-ab,__a+cb-_b,cd.fgColor)end end end,loseFocusHandler=function(cd)
ca.loseFocusHandler(cd)
if(cd.parent~=nil)then cd.parent:setCursor(false)end end,keyHandler=function(cd,dd,__a)
if(ca.keyHandler(cd,dd,__a))then
local a_a,b_a=cd:getAnchorPosition()local c_a,d_a=cd:getSize()
if(dd=="key")then
if(__a==keys.backspace)then
if(db[cb]=="")then
if(cb>1)then
table.remove(db,cb)table.remove(ac,cb)table.remove(_c,cb)bb=
db[cb-1]:len()+1;ab=bb-c_a+1;if(ab<1)then ab=1 end;cb=cb-1 end elseif(bb<=1)then
if(cb>1)then bb=db[cb-1]:len()+1;ab=bb-c_a+1
if(ab<1)then ab=1 end;db[cb-1]=db[cb-1]..db[cb]
ac[cb-1]=ac[cb-1]..ac[cb]_c[cb-1]=_c[cb-1].._c[cb]table.remove(db,cb)
table.remove(ac,cb)table.remove(_c,cb)cb=cb-1 end else
db[cb]=db[cb]:sub(1,bb-2)..db[cb]:sub(bb,db[cb]:len())
ac[cb]=ac[cb]:sub(1,bb-2)..ac[cb]:sub(bb,ac[cb]:len())
_c[cb]=_c[cb]:sub(1,bb-2).._c[cb]:sub(bb,_c[cb]:len())if(bb>1)then bb=bb-1 end
if(ab>1)then if(bb<ab)then ab=ab-1 end end end;if(cb<_b)then _b=_b-1 end;_d(cd)cd:setValue("")end
if(__a==keys.delete)then
if(bb>db[cb]:len())then
if(db[cb+1]~=nil)then db[cb]=db[cb]..
db[cb+1]table.remove(db,cb+1)
table.remove(_c,cb+1)table.remove(ac,cb+1)end else
db[cb]=db[cb]:sub(1,bb-1)..db[cb]:sub(bb+1,db[cb]:len())
ac[cb]=ac[cb]:sub(1,bb-1)..ac[cb]:sub(bb+1,ac[cb]:len())
_c[cb]=_c[cb]:sub(1,bb-1).._c[cb]:sub(bb+1,_c[cb]:len())end;_d(cd)end
if(__a==keys.enter)then
table.insert(db,cb+1,db[cb]:sub(bb,db[cb]:len()))
table.insert(ac,cb+1,ac[cb]:sub(bb,ac[cb]:len()))
table.insert(_c,cb+1,_c[cb]:sub(bb,_c[cb]:len()))db[cb]=db[cb]:sub(1,bb-1)
ac[cb]=ac[cb]:sub(1,bb-1)_c[cb]=_c[cb]:sub(1,bb-1)cb=cb+1;bb=1;ab=1;if(cb-_b>=d_a)then
_b=_b+1 end;cd:setValue("")end
if(__a==keys.up)then
if(cb>1)then cb=cb-1;if(bb>db[cb]:len()+1)then bb=
db[cb]:len()+1 end;if(ab>1)then if(bb<ab)then ab=bb-c_a+1;if(ab<1)then
ab=1 end end end;if(_b>1)then if(
cb<_b)then _b=_b-1 end end end end
if(__a==keys.down)then if(cb<#db)then cb=cb+1;if(bb>db[cb]:len()+1)then bb=
db[cb]:len()+1 end
if(cb>=_b+d_a)then _b=_b+1 end end end
if(__a==keys.right)then bb=bb+1;if(cb<#db)then if(bb>db[cb]:len()+1)then bb=1
cb=cb+1 end elseif(bb>db[cb]:len())then
bb=db[cb]:len()+1 end;if(bb<1)then bb=1 end;if
(bb<ab)or(bb>=c_a+ab)then ab=bb-c_a+1 end
if(ab<1)then ab=1 end end
if(__a==keys.left)then bb=bb-1;if(bb>=1)then
if(bb<ab)or(bb>=c_a+ab)then ab=bb end end
if(cb>1)then if(bb<1)then cb=cb-1
bb=db[cb]:len()+1;ab=bb-c_a+1 end end;if(bb<1)then bb=1 end;if(ab<1)then ab=1 end end end
if(dd=="char")then db[cb]=db[cb]:sub(1,bb-1)..__a..
db[cb]:sub(bb,db[cb]:len())ac[cb]=ac[cb]:sub(1,
bb-1)..
_a[cd.fgColor]..ac[cb]:sub(bb,ac[cb]:len())_c[cb]=_c[cb]:sub(1,
bb-1)..
_a[cd.bgColor].._c[cb]:sub(bb,_c[cb]:len())
bb=bb+1;if(bb>=c_a+ab)then ab=ab+1 end;_d(cd)cd:setValue("")end;local _aa=
(bb<=db[cb]:len()and bb-1 or db[cb]:len())- (ab-1)if(_aa>
cd.x+c_a-1)then _aa=cd.x+c_a-1 end;local aaa=(
cb-_b<d_a and cb-_b or cb-_b-1)if(_aa<1)then _aa=0 end;cd.parent:setCursor(true,
a_a+_aa,b_a+aaa,cd.fgColor)
return true end end,mouseHandler=function(cd,dd,__a,a_a,b_a)
if
(ca.mouseHandler(cd,dd,__a,a_a,b_a))then
local c_a,d_a=cd:getAbsolutePosition(cd:getAnchorPosition())local _aa,aaa=cd:getAnchorPosition()local baa,caa=cd:getSize()
if
(dd=="mouse_click")or(dd=="monitor_touch")then
if(db[b_a-d_a+_b]~=nil)then bb=
a_a-c_a+ab;cb=b_a-d_a+_b;if(bb>db[cb]:len())then bb=
db[cb]:len()+1 end
if(bb<ab)then ab=bb-1;if(ab<1)then ab=1 end end;if(cd.parent~=nil)then
cd.parent:setCursor(true,_aa+bb-ab,aaa+cb-_b,cd.fgColor)end end end
if(dd=="mouse_drag")then
if(db[b_a-d_a+_b]~=nil)then bb=a_a-c_a+ab;cb=
b_a-d_a+_b
if(bb>db[cb]:len())then bb=db[cb]:len()+1 end;if(bb<ab)then ab=bb-1;if(ab<1)then ab=1 end end;if(cd.parent~=nil)then
cd.parent:setCursor(true,
_aa+bb-ab,aaa+cb-_b,cd.fgColor)end end end
if(dd=="mouse_scroll")then _b=_b+__a
if(_b>#db- (caa-1))then _b=#db- (caa-1)end;if(_b<1)then _b=1 end
if(cd.parent~=nil)then
if(c_a+bb-ab>=c_a and
c_a+bb-ab<c_a+baa)and
(d_a+cb-_b>=d_a and d_a+cb-_b<d_a+caa)then
cd.parent:setCursor(true,_aa+bb-ab,aaa+cb-_b,cd.fgColor)else cd.parent:setCursor(false)end end end;cd:setVisualChanged()return true end end,draw=function(cd)
if
(ca.draw(cd))then
if(cd.parent~=nil)then local dd,__a=cd:getAnchorPosition()
local a_a,b_a=cd:getSize()if(cd.bgColor~=false)then
cd.parent:drawBackgroundBox(dd,__a,a_a,b_a,cd.bgColor)end;if(cd.fgColor~=false)then
cd.parent:drawForegroundBox(dd,__a,a_a,b_a,cd.fgColor)end
for n=1,b_a do local c_a=""local d_a=""local _aa=""
if(
db[n+_b-1]~=nil)then c_a=db[n+_b-1]_aa=ac[n+_b-1]d_a=_c[n+_b-1]end;c_a=c_a:sub(ab,a_a+ab-1)
d_a=d_a:sub(ab,a_a+ab-1)_aa=_aa:sub(ab,a_a+ab-1)local aaa=a_a-c_a:len()if(aaa<0)then
aaa=0 end;c_a=c_a..string.rep(" ",aaa)d_a=d_a..
string.rep(_a[cd.bgColor],aaa)_aa=_aa..
string.rep(_a[cd.fgColor],aaa)
cd.parent:setText(dd,__a+n-1,c_a)cd.parent:setBG(dd,__a+n-1,d_a)
cd.parent:setFG(dd,__a+n-1,_aa)end end;cd:setVisualChanged(false)end end}return setmetatable(bd,ca)end
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
error("Thread Error Occurred - "..cb)end end;return
_b end,getStatus=function(_b,ab)if(
ba~=nil)then return coroutine.status(ba)end;return nil end,stop=function(_b,ab)
ca=false;return _b end,eventHandler=function(_b,ab,bb,cb,db)
if(ca)then
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
os.cancelTimer(_b)end;da=ca;_b=os.startTimer(ba)bb=true;return _c end,isActive=function(_c)return
bb end,cancel=function(_c)if(_b~=nil)then os.cancelTimer(_b)end
bb=false;return _c end,onCall=function(_c,ac)
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
local function ad()local a_a=cc
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
local __a={setMirror=function(a_a)da=a_a end,setBG=function(a_a,b_a,c_a)cd(a_a,b_a,c_a)end,setText=function(a_a,b_a,c_a)
bd(a_a,b_a,c_a)end,setFG=function(a_a,b_a,c_a)dd(a_a,b_a,c_a)end,drawBackgroundBox=function(a_a,b_a,c_a,d_a,_aa)for n=1,d_a do
cd(a_a,b_a+ (n-1),aa(d[_aa],c_a))end end,drawForegroundBox=function(a_a,b_a,c_a,d_a,_aa)
for n=1,d_a do dd(a_a,b_a+
(n-1),aa(d[_aa],c_a))end end,drawTextBox=function(a_a,b_a,c_a,d_a,_aa)for n=1,d_a do
bd(a_a,b_a+ (n-1),aa(_aa,c_a))end end,writeText=function(a_a,b_a,c_a,d_a,_aa)d_a=d_a or
ca.getBackgroundColor()
_aa=_aa or ca.getTextColor()bd(a_a,b_a,c_a)
cd(a_a,b_a,aa(d[d_a],c_a:len()))dd(a_a,b_a,aa(d[_aa],c_a:len()))end,update=function()
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
function _a:new(ba,ca,...)local da=table.pack(...)
local _b=setmetatable({path=ba},{__index=self})_b.window=ca;_b.processId=aa
_b.coroutine=coroutine.create(function()
os.run({},ba,table.unpack(da))end)d[aa]=_b;aa=aa+1;return _b end
function _a:resume(ba,...)term.redirect(self.window)
local ca,da=coroutine.resume(self.coroutine,ba,...)self.window=term.current()if ca then self.filter=da else
basalt.debug(da)end end
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
_a-1;if _a~=0 then return _a,d[_a]end end,c,#c+1 end,splitString=b,createText=function(c,d)local _a=b(c,"\n")local aa={}
for ba,ca in
pairs(_a)do local da=""local _b=b(ca," ")
for ab,bb in pairs(_b)do
if(#da+#bb<=d)then
da=da==""and bb or da.." "..bb;if(ab==#_b)then table.insert(aa,da)end else
table.insert(aa,da)da=bb:sub(1,d)if(ab==#_b)then table.insert(aa,da)end end end end;return aa end,getValueFromXML=function(c,d)
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
project['default']['Frame'] = function(...)local bb=require("Object")local cb=require("loadObjects")
local db=require("basaltDraw")local _c=require("utils")local ac=require("layout")local bc=_c.uuid
local cc=_c.rpairs;local dc=_c.getValueFromXML;local _d,ad,bd=string.sub,math.min,math.max
return
function(cd,dd,__a,a_a)
local b_a=bb(cd)local c_a="Frame"local d_a={}local _aa={}local aaa={}local baa={}local caa={}local daa={}local _ba=0;local aba=__a or
term.current()local bba=""local cba=false;local dba=false;local _ca=0;local aca=0;local bca=false
local cca=0;local dca=10;local _da=false;local ada=false;local bda=""local cda=false;local dda;local __b
b_a:setZIndex(10)local a_b=db(aba)local b_b=false;local c_b=1;local d_b=1;local _ab=colors.white;local aab,bab=0,0;local cab={}
local function dab(adb,bdb)if(bdb~=
nil)then bdb:setValuesByXMLData(adb)end end
local function _bb(adb,bdb,cdb)
if(adb~=nil)then if(adb.properties~=nil)then adb={adb}end;for ddb,__c in pairs(adb)do local a_c=bdb(cdb,
__c["@id"]or bc())
table.insert(cab,a_c)dab(__c,a_c)end end end
if(dd~=nil)then b_a.parent=dd;b_a.width,b_a.height=dd:getSize()
b_a.bgColor=dd:getTheme("FrameBG")b_a.fgColor=dd:getTheme("FrameText")else
b_a.width,b_a.height=aba.getSize()b_a.bgColor=a_a.getTheme("BasaltBG")
b_a.fgColor=a_a.getTheme("BasaltText")end
local function abb(adb)for bdb,cdb in pairs(d_a)do
for ddb,__c in pairs(cdb)do if(__c:getName()==adb)then return __c end end end end
local function bbb(adb)local bdb=abb(adb)if(bdb~=nil)then return bdb end
for cdb,ddb in pairs(d_a)do
for __c,a_c in pairs(ddb)do if(
a_c:getType()=="Frame")then local b_c=a_c:getDeepObject(adb)
if(b_c~=nil)then return b_c end end end end end
local function cbb(adb)local bdb=adb:getZIndex()
if(abb(adb.name)~=nil)then return nil end
if(d_a[bdb]==nil)then
for x=1,#_aa+1 do if(_aa[x]~=nil)then if(bdb==_aa[x])then break end;if
(bdb>_aa[x])then table.insert(_aa,x,bdb)break end else
table.insert(_aa,bdb)end end;if(#_aa<=0)then table.insert(_aa,bdb)end;d_a[bdb]={}end;adb.parent=aaa;if(adb.init~=nil)then adb:init()end
table.insert(d_a[bdb],adb)return adb end
local function dbb(adb)
for bdb,cdb in pairs(d_a)do for ddb,__c in pairs(cdb)do if(__c==adb)then table.remove(d_a[bdb],ddb)
return true end end end;return false end
local function _cb(adb)local bdb,cdb=pcall(load("return "..adb))
if not(bdb)then error(adb..
" is not a valid dynamic code")end;return load("return "..adb)()end
local function acb(adb,bdb,cdb)for ddb,__c in pairs(daa)do
if(__c[2]==cdb)and(__c[4]==bdb)then return __c end end;_ba=_ba+1
daa[_ba]={0,cdb,{},bdb,_ba}return daa[_ba]end
local function bcb(adb,bdb)local cdb={}local ddb={}for __c in bdb:gmatch("%a+%.x")do local a_c=__c:gsub("%.x","")
if
(a_c~="self")and(a_c~="parent")then table.insert(cdb,a_c)end end
for __c in
bdb:gmatch("%w+%.y")do local a_c=__c:gsub("%.y","")if(a_c~="self")and(a_c~="parent")then
table.insert(cdb,a_c)end end;for __c in bdb:gmatch("%a+%.w")do local a_c=__c:gsub("%.w","")
if(a_c~="self")and
(a_c~="parent")then table.insert(cdb,a_c)end end
for __c in
bdb:gmatch("%a+%.h")do local a_c=__c:gsub("%.h","")if(a_c~="self")and(a_c~="parent")then
table.insert(cdb,a_c)end end
for __c,a_c in pairs(cdb)do ddb[a_c]=abb(a_c)if(ddb[a_c]==nil)then
error("Dynamic Values - unable to find object "..a_c)end end;ddb["self"]=adb;ddb["parent"]=adb:getParent()return ddb end
local function ccb(adb,bdb)local cdb=adb;for ddb in adb:gmatch("%w+%.x")do
cdb=cdb:gsub(ddb,bdb[ddb:gsub("%.x","")]:getX())end;for ddb in adb:gmatch("%w+%.y")do
cdb=cdb:gsub(ddb,bdb[ddb:gsub("%.y","")]:getY())end;for ddb in adb:gmatch("%w+%.w")do
cdb=cdb:gsub(ddb,bdb[ddb:gsub("%.w","")]:getWidth())end;for ddb in adb:gmatch("%w+%.h")do
cdb=cdb:gsub(ddb,bdb[ddb:gsub("%.h","")]:getHeight())end;return cdb end
local function dcb()
if(#daa>0)then
for n=1,_ba do
if(daa[n]~=nil)then local adb;if(#daa[n][3]<=0)then
daa[n][3]=bcb(daa[n][4],daa[n][2])end
adb=ccb(daa[n][2],daa[n][3])daa[n][1]=_cb(adb)end end end end;local function _db(adb)return daa[adb][1]end
aaa={barActive=false,barBackground=colors.gray,barTextcolor=colors.black,barText="New Frame",barTextAlign="left",isMoveable=false,newDynamicValue=acb,recalculateDynamicValues=dcb,getDynamicValue=_db,getType=function(adb)return
c_a end,setFocusedObject=function(adb,bdb)dda=bdb;return adb end,getVariable=function(adb,bdb)
return a_a.getVariable(bdb)end,setSize=function(adb,bdb,cdb,ddb)b_a.setSize(adb,bdb,cdb,ddb)
for __c,a_c in pairs(_aa)do if(
d_a[a_c]~=nil)then
for b_c,c_c in pairs(d_a[a_c])do if(c_c.eventHandler~=nil)then
c_c:sendEvent("basalt_resize",c_c,adb)end end end end;return adb end,setTheme=function(adb,bdb)
caa=bdb;return adb end,getTheme=function(adb,bdb)return
caa[bdb]or(adb.parent~=nil and
adb.parent:getTheme(bdb)or a_a.getTheme(bdb))end,setPosition=function(adb,bdb,cdb,ddb)
b_a.setPosition(adb,bdb,cdb,ddb)
for __c,a_c in pairs(_aa)do if(d_a[a_c]~=nil)then
for b_c,c_c in pairs(d_a[a_c])do if(c_c.eventHandler~=nil)then
c_c:sendEvent("basalt_reposition",c_c,adb)end end end end;return adb end,getBasaltInstance=function(adb)return
a_a end,setOffset=function(adb,bdb,cdb)
aab=bdb~=nil and
math.floor(bdb<0 and math.abs(bdb)or-bdb)or aab
bab=cdb~=nil and
math.floor(cdb<0 and math.abs(cdb)or-cdb)or bab;return adb end,getOffsetInternal=function(adb)return
aab,bab end,getOffset=function(adb)
return aab<0 and math.abs(aab)or-aab,
bab<0 and math.abs(bab)or-bab end,removeFocusedObject=function(adb)dda=nil;return adb end,getFocusedObject=function(adb)
return __b end,setCursor=function(adb,bdb,cdb,ddb,__c)
if(adb.parent~=nil)then local a_c,b_c=adb:getAnchorPosition()
adb.parent:setCursor(
bdb or false,(cdb or 0)+a_c-1,(ddb or 0)+b_c-1,__c or _ab)else
local a_c,b_c=adb:getAbsolutePosition(adb:getAnchorPosition(adb:getX(),adb:getY(),true))b_b=bdb or false;if(cdb~=nil)then c_b=a_c+cdb-1 end;if(ddb~=nil)then d_b=b_c+
ddb-1 end;_ab=__c or _ab
adb:setVisualChanged()end;return adb end,setMoveable=function(adb,bdb)adb.isMoveable=
bdb or not adb.isMoveable
adb:setVisualChanged()return adb end,setScrollable=function(adb,bdb)
bca=bdb and true or false;return adb end,setImportantScroll=function(adb,bdb)cda=bdb and true or false
return adb end,setMaxScroll=function(adb,bdb)dca=bdb or dca;return adb end,setMinScroll=function(adb,bdb)cca=
bdb or cca;return adb end,getMaxScroll=function(adb)return dca end,getMinScroll=function(adb)return cca end,show=function(adb)
b_a.show(adb)
if(adb.parent==nil)then a_a.setActiveFrame(adb)if(cba)then
a_a.setMonitorFrame(bba,adb)else a_a.setMainFrame(adb)end end;return adb end,hide=function(adb)
b_a.hide(adb)
if(adb.parent==nil)then if(activeFrame==adb)then activeFrame=nil end;if(cba)then
if(
a_a.getMonitorFrame(bba)==adb)then a_a.setActiveFrame(nil)end else
if(a_a.getMainFrame()==adb)then a_a.setMainFrame(nil)end end end;return adb end,addLayout=function(adb,bdb)
if(
bdb~=nil)then
if(fs.exists(bdb))then local cdb=fs.open(bdb,"r")
local ddb=ac:ParseXmlText(cdb.readAll())cdb.close()cab={}adb:setValuesByXMLData(ddb)end end;return adb end,getLastLayout=function(adb)return
cab end,addLayoutFromString=function(adb,bdb)if(bdb~=nil)then local cdb=ac:ParseXmlText(bdb)
adb:setValuesByXMLData(cdb)end;return adb end,setValuesByXMLData=function(adb,bdb)
b_a.setValuesByXMLData(adb,bdb)if(dc("moveable",bdb)~=nil)then if(dc("moveable",bdb))then
adb:setMoveable(true)end end;if(
dc("scrollable",bdb)~=nil)then
if(dc("scrollable",bdb))then adb:setScrollable(true)end end;if
(dc("monitor",bdb)~=nil)then
adb:setMonitor(dc("monitor",bdb)):show()end;if(dc("mirror",bdb)~=nil)then
adb:setMirror(dc("mirror",bdb))end
if(dc("bar",bdb)~=nil)then if(dc("bar",bdb))then
adb:showBar(true)else adb:showBar(false)end end
if(dc("barText",bdb)~=nil)then adb.barText=dc("barText",bdb)end;if(dc("barBG",bdb)~=nil)then
adb.barBackground=colors[dc("barBG",bdb)]end;if(dc("barFG",bdb)~=nil)then
adb.barTextcolor=colors[dc("barFG",bdb)]end;if(dc("barAlign",bdb)~=nil)then
adb.barTextAlign=dc("barAlign",bdb)end;if(dc("layout",bdb)~=nil)then
adb:addLayout(dc("layout",bdb))end;if(dc("xOffset",bdb)~=nil)then
adb:setOffset(dc("xOffset",bdb),bab)end;if(dc("yOffset",bdb)~=nil)then
adb:setOffset(bab,dc("yOffset",bdb))end;if(dc("maxScroll",bdb)~=nil)then
adb:setMaxScroll(dc("maxScroll",bdb))end;if(dc("minScroll",bdb)~=nil)then
adb:setMaxScroll(dc("minScroll",bdb))end;if
(dc("importantScroll",bdb)~=nil)then
adb:setImportantScroll(dc("importantScroll",bdb))end;local cdb=bdb:children()
for ddb,__c in
pairs(cdb)do if(__c.___name~="animation")then
local a_c=__c.___name:gsub("^%l",string.upper)
if(cb[a_c]~=nil)then _bb(__c,adb["add"..a_c],adb)end end end;_bb(bdb["frame"],adb.addFrame,adb)
_bb(bdb["animation"],adb.addAnimation,adb)return adb end,showBar=function(adb,bdb)adb.barActive=
bdb or not adb.barActive
adb:setVisualChanged()return adb end,setBar=function(adb,bdb,cdb,ddb)
adb.barText=bdb or""adb.barBackground=cdb or adb.barBackground
adb.barTextcolor=ddb or adb.barTextcolor;adb:setVisualChanged()return adb end,setBarTextAlign=function(adb,bdb)adb.barTextAlign=
bdb or"left"adb:setVisualChanged()return adb end,setMirror=function(adb,bdb)
bda=bdb;if(mirror~=nil)then a_b.setMirror(mirror)end;_da=true
return adb end,removeMirror=function(adb)mirror=nil;_da=false
a_b.setMirror(nil)return adb end,setMonitor=function(adb,bdb)
if(bdb~=nil)and(bdb~=false)then
if(
peripheral.getType(bdb)=="monitor")then aba=peripheral.wrap(bdb)dba=true end
if(adb.parent~=nil)then adb.parent:removeObject(adb)end;cba=true else aba=parentTerminal;cba=false;if(a_a.getMonitorFrame(bba)==adb)then a_a.setMonitorFrame(bba,
nil)end end;a_b=db(aba)bba=bdb or nil;return adb end,getVisualChanged=function(adb)
local bdb=b_a.getVisualChanged(adb)
for cdb,ddb in pairs(_aa)do if(d_a[ddb]~=nil)then
for __c,a_c in pairs(d_a[ddb])do if(a_c.getVisualChanged~=nil and
a_c:getVisualChanged())then bdb=true end end end end;return bdb end,loseFocusHandler=function(adb)
b_a.loseFocusHandler(adb)if(dda~=nil)then dda:loseFocusHandler()dda=nil end end,getFocusHandler=function(adb)
b_a.getFocusHandler(adb)if(adb.parent~=nil)then adb.parent:removeObject(adb)
adb.parent:addObject(adb)end end,keyHandler=function(adb,bdb,cdb)
if(
__b~=nil)then if(__b~=adb)then if(__b.keyHandler~=nil)then
if(__b:keyHandler(bdb,cdb))then return true end end else
b_a.keyHandler(adb,bdb,cdb)end end;return false end,backgroundKeyHandler=function(adb,bdb,cdb)
b_a.backgroundKeyHandler(adb,bdb,cdb)
for ddb,__c in pairs(_aa)do if(d_a[__c]~=nil)then
for a_c,b_c in pairs(d_a[__c])do if(b_c.backgroundKeyHandler~=nil)then
b_c:backgroundKeyHandler(bdb,cdb)end end end end end,eventHandler=function(adb,bdb,cdb,ddb,__c,a_c)
b_a.eventHandler(adb,bdb,cdb,ddb,__c,a_c)
for b_c,c_c in pairs(_aa)do if(d_a[c_c]~=nil)then
for d_c,_ac in pairs(d_a[c_c])do if(_ac.eventHandler~=nil)then
_ac:eventHandler(bdb,cdb,ddb,__c,a_c)end end end end
if(cba)then if(bdb=="peripheral")and(cdb==bba)then
if
(peripheral.getType(bba)=="monitor")then dba=true;aba=peripheral.wrap(bba)a_b=db(aba)end end
if(bdb==
"peripheral_detach")and(cdb==bba)then dba=false end end
if(_da)then if(peripheral.getType(bda)=="monitor")then ada=true
a_b.setMirror(peripheral.wrap(bda))end;if(bdb=="peripheral_detach")and
(cdb==bda)then dba=false end
if
(bdb=="monitor_touch")then adb:mouseHandler(bdb,cdb,ddb,__c,a_c)end end;if(bdb=="terminate")then aba.setCursorPos(1,1)aba.clear()
a_a.stop()end end,mouseHandler=function(adb,bdb,cdb,ddb,__c)
if
(adb.drag)then local d_c,_ac=adb.parent:getOffsetInternal()d_c=d_c<0 and
math.abs(d_c)or-d_c;_ac=
_ac<0 and math.abs(_ac)or-_ac
if(bdb=="mouse_drag")then local aac=1;local bac=1;if
(adb.parent~=nil)then
aac,bac=adb.parent:getAbsolutePosition(adb.parent:getAnchorPosition())end
adb:setPosition(
ddb+_ca- (aac-1)+d_c,__c+aca- (bac-1)+_ac)end;if(bdb=="mouse_up")then adb.drag=false end;return true end
local a_c,b_c=adb:getAbsolutePosition(adb:getAnchorPosition())local c_c=false;if(b_c-1 ==__c)and(adb:getBorder("top"))then __c=__c+1
c_c=true end
if(b_a.mouseHandler(adb,bdb,cdb,ddb,__c))then
a_c=a_c+aab;b_c=b_c+bab;if(bca)and(cda)then
if(bdb=="mouse_scroll")then if(cdb>0)or(cdb<0)then bab=bd(ad(bab-cdb,-cca),
-dca)end end end
for d_c,_ac in pairs(_aa)do
if
(d_a[_ac]~=nil)then
for aac,bac in cc(d_a[_ac])do if(bac.mouseHandler~=nil)then if(bac:mouseHandler(bdb,cdb,ddb,__c))then
return true end end end end end;adb:removeFocusedObject()
if(adb.isMoveable)then
if
(ddb>=a_c)and(ddb<=
a_c+adb:getWidth()-1)and(__c==b_c)and(bdb=="mouse_click")then adb.drag=true;_ca=a_c-
ddb;aca=c_c and 1 or 0 end end;if(bca)and(not cda)then
if(bdb=="mouse_scroll")then if(cdb>0)or(cdb<0)then bab=bd(ad(bab-cdb,-cca),
-dca)end end end;return true end;return false end,setText=function(adb,bdb,cdb,ddb)
local __c,a_c=adb:getAnchorPosition()
if(cdb>=1)and(cdb<=adb:getHeight())then
if(adb.parent~=nil)then
adb.parent:setText(bd(
bdb+ (__c-1),__c),a_c+cdb-1,_d(ddb,bd(1 -bdb+1,1),bd(
adb:getWidth()-bdb+1,1)))else
a_b.setText(bd(bdb+ (__c-1),__c),a_c+cdb-1,_d(ddb,bd(1 -bdb+1,1),bd(
adb:getWidth()-bdb+1,1)))end end end,setBG=function(adb,bdb,cdb,ddb)
local __c,a_c=adb:getAnchorPosition()
if(cdb>=1)and(cdb<=adb:getHeight())then
if(adb.parent~=nil)then
adb.parent:setBG(bd(
bdb+ (__c-1),__c),a_c+cdb-1,_d(ddb,bd(1 -bdb+1,1),bd(
adb:getWidth()-bdb+1,1)))else
a_b.setBG(bd(bdb+ (__c-1),__c),a_c+cdb-1,_d(ddb,bd(1 -bdb+1,1),bd(
adb:getWidth()-bdb+1,1)))end end end,setFG=function(adb,bdb,cdb,ddb)
local __c,a_c=adb:getAnchorPosition()
if(cdb>=1)and(cdb<=adb:getHeight())then
if(adb.parent~=nil)then
adb.parent:setFG(bd(
bdb+ (__c-1),__c),a_c+cdb-1,_d(ddb,bd(1 -bdb+1,1),bd(
adb:getWidth()-bdb+1,1)))else
a_b.setFG(bd(bdb+ (__c-1),__c),a_c+cdb-1,_d(ddb,bd(1 -bdb+1,1),bd(
adb:getWidth()-bdb+1,1)))end end end,writeText=function(adb,bdb,cdb,ddb,__c,a_c)
local b_c,c_c=adb:getAnchorPosition()
if(cdb>=1)and(cdb<=adb:getHeight())then
if(adb.parent~=nil)then
adb.parent:writeText(bd(
bdb+ (b_c-1),b_c),c_c+cdb-1,_d(ddb,bd(1 -bdb+1,1),
adb:getWidth()-bdb+1),__c,a_c)else
a_b.writeText(bd(bdb+ (b_c-1),b_c),c_c+cdb-1,_d(ddb,bd(1 -bdb+1,1),bd(
adb:getWidth()-bdb+1,1)),__c,a_c)end end end,drawBackgroundBox=function(adb,bdb,cdb,ddb,__c,a_c)
local b_c,c_c=adb:getAnchorPosition()
__c=(cdb<1 and(
__c+cdb>adb:getHeight()and adb:getHeight()or __c+cdb-1)or(
__c+
cdb>adb:getHeight()and adb:getHeight()-cdb+1 or __c))
ddb=(bdb<1 and(ddb+bdb>adb:getWidth()and adb:getWidth()or ddb+
bdb-1)or(

ddb+bdb>adb:getWidth()and adb:getWidth()-bdb+1 or ddb))
if(adb.parent~=nil)then
adb.parent:drawBackgroundBox(bd(bdb+ (b_c-1),b_c),bd(cdb+ (c_c-1),c_c),ddb,__c,a_c)else
a_b.drawBackgroundBox(bd(bdb+ (b_c-1),b_c),bd(cdb+ (c_c-1),c_c),ddb,__c,a_c)end end,drawTextBox=function(adb,bdb,cdb,ddb,__c,a_c)
local b_c,c_c=adb:getAnchorPosition()
__c=(cdb<1 and(
__c+cdb>adb:getHeight()and adb:getHeight()or __c+cdb-1)or(
__c+
cdb>adb:getHeight()and adb:getHeight()-cdb+1 or __c))
ddb=(bdb<1 and(ddb+bdb>adb:getWidth()and adb:getWidth()or ddb+
bdb-1)or(

ddb+bdb>adb:getWidth()and adb:getWidth()-bdb+1 or ddb))
if(adb.parent~=nil)then
adb.parent:drawTextBox(bd(bdb+ (b_c-1),b_c),bd(cdb+ (c_c-1),c_c),ddb,__c,_d(a_c,1,1))else
a_b.drawTextBox(bd(bdb+ (b_c-1),b_c),bd(cdb+ (c_c-1),c_c),ddb,__c,_d(a_c,1,1))end end,drawForegroundBox=function(adb,bdb,cdb,ddb,__c,a_c)
local b_c,c_c=adb:getAnchorPosition()
__c=(cdb<1 and(
__c+cdb>adb:getHeight()and adb:getHeight()or __c+cdb-1)or(
__c+
cdb>adb:getHeight()and adb:getHeight()-cdb+1 or __c))
ddb=(bdb<1 and(ddb+bdb>adb:getWidth()and adb:getWidth()or ddb+
bdb-1)or(

ddb+bdb>adb:getWidth()and adb:getWidth()-bdb+1 or ddb))
if(adb.parent~=nil)then
adb.parent:drawForegroundBox(bd(bdb+ (b_c-1),b_c),bd(cdb+ (c_c-1),c_c),ddb,__c,a_c)else
a_b.drawForegroundBox(bd(bdb+ (b_c-1),b_c),bd(cdb+ (c_c-1),c_c),ddb,__c,a_c)end end,draw=function(adb)if
(cba)and not(dba)then return false end
if(adb:getVisualChanged())then
if
(b_a.draw(adb))then
if(__b~=dda)then if(dda~=nil)then dda:getFocusHandler()end;if
(__b~=nil)then __b:loseFocusHandler()end;__b=dda end
local bdb,cdb=adb:getAbsolutePosition(adb:getAnchorPosition())local ddb,__c=adb:getAnchorPosition()local a_c,b_c=adb:getSize()
if(
adb.parent~=nil)then
if(adb.bgColor~=false)then
adb.parent:drawBackgroundBox(ddb,__c,a_c,b_c,adb.bgColor)adb.parent:drawTextBox(ddb,__c,a_c,b_c," ")end;if(adb.bgColor~=false)then
adb.parent:drawForegroundBox(ddb,__c,a_c,b_c,adb.fgColor)end else
if(adb.bgColor~=false)then
a_b.drawBackgroundBox(ddb,__c,a_c,b_c,adb.bgColor)a_b.drawTextBox(ddb,__c,a_c,b_c," ")end;if(adb.fgColor~=false)then
a_b.drawForegroundBox(ddb,__c,a_c,b_c,adb.fgColor)end end;aba.setCursorBlink(false)
if(adb.barActive)then
if(adb.parent~=nil)then
adb.parent:writeText(ddb,__c,_c.getTextHorizontalAlign(adb.barText,a_c,adb.barTextAlign),adb.barBackground,adb.barTextcolor)else
a_b.writeText(ddb,__c,_c.getTextHorizontalAlign(adb.barText,a_c,adb.barTextAlign),adb.barBackground,adb.barTextcolor)end
if(adb:getBorder("left"))then
if(adb.parent~=nil)then
adb.parent:drawBackgroundBox(ddb-1,__c,1,1,adb.barBackground)if(adb.bgColor~=false)then
adb.parent:drawBackgroundBox(ddb-1,__c+1,1,b_c-1,adb.bgColor)end end end
if(adb:getBorder("top"))then if(adb.parent~=nil)then
adb.parent:drawBackgroundBox(ddb-1,__c-1,a_c+1,1,adb.barBackground)end end end;for c_c,d_c in cc(_aa)do
if(d_a[d_c]~=nil)then for _ac,aac in pairs(d_a[d_c])do
if(aac.draw~=nil)then aac:draw()end end end end
if(b_b)then
aba.setTextColor(_ab)aba.setCursorPos(c_b,d_b)
if(adb.parent~=nil)then
aba.setCursorBlink(adb:isFocused())else aba.setCursorBlink(b_b)end end;adb:setVisualChanged(false)end end end,drawUpdate=function(adb)if
(cba)and not(dba)then return false end;a_b.update()end,addObject=function(adb,bdb)return
cbb(bdb)end,removeObject=function(adb,bdb)return dbb(bdb)end,getObject=function(adb,bdb)return abb(bdb)end,getDeepObject=function(adb,bdb)return
bbb(bdb)end,addFrame=function(adb,bdb)
local cdb=a_a.newFrame(bdb or bc(),adb,nil,a_a)return cbb(cdb)end}
for adb,bdb in pairs(cb)do aaa["add"..adb]=function(cdb,ddb)
return cbb(bdb(ddb or bc(),cdb))end end;setmetatable(aaa,b_a)return aaa end
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
local _c;local ac="topLeft"local bc=false;local cc=true;local dc=false;local _d=false;local ad=false;local bd=false
local cd=false;local dd=colors.black;local __a=colors.black;local a_a=true;local b_a=false;local c_a,d_a,_aa,aaa=0,0,0,0
local baa=true;local caa=aa()
cb={x=1,y=1,width=1,height=1,bgColor=colors.black,fgColor=colors.white,name=ab or"Object",parent=nil,show=function(daa)cc=true;baa=true;return daa end,hide=function(daa)
cc=false;baa=true;return daa end,enable=function(daa)a_a=true;return daa end,disable=function(daa)
a_a=false;return daa end,generateXMLEventFunction=function(daa,_ba,aba)
local bba=function(cba)
if(cba:sub(1,1)=="#")then
local dba=daa:getBaseFrame():getDeepObject(cba:sub(2,cba:len()))
if(dba~=nil)and(dba.internalObjetCall~=nil)then _ba(daa,function()
dba:internalObjetCall()end)end else
_ba(daa,daa:getBaseFrame():getVariable(cba))end end;if(type(aba)=="string")then bba(aba)elseif(type(aba)=="table")then
for cba,dba in pairs(aba)do bba(dba)end end;return daa end,setValuesByXMLData=function(daa,_ba)
local aba=daa:getBaseFrame()if(_b("x",_ba)~=nil)then
daa:setPosition(_b("x",_ba),daa.y)end;if(_b("y",_ba)~=nil)then
daa:setPosition(daa.x,_b("y",_ba))end;if(_b("width",_ba)~=nil)then
daa:setSize(_b("width",_ba),daa.height)end;if(_b("height",_ba)~=nil)then
daa:setSize(daa.width,_b("height",_ba))end;if(_b("bg",_ba)~=nil)then
daa:setBackground(colors[_b("bg",_ba)])end;if(_b("fg",_ba)~=nil)then
daa:setForeground(colors[_b("fg",_ba)])end;if(_b("value",_ba)~=nil)then
daa:setValue(colors[_b("value",_ba)])end
if(_b("visible",_ba)~=nil)then if
(_b("visible",_ba))then daa:show()else daa:hide()end end
if(_b("enabled",_ba)~=nil)then if(_b("enabled",_ba))then daa:enable()else
daa:disable()end end;if(_b("zIndex",_ba)~=nil)then
daa:setZIndex(_b("zIndex",_ba))end;if(_b("anchor",_ba)~=nil)then
daa:setAnchor(_b("anchor",_ba))end;if(_b("shadow",_ba)~=nil)then if(_b("shadow",_ba))then
daa:showShadow(true)end end;if(
_b("shadowColor",_ba)~=nil)then
daa:setShadow(colors[_b("shadowColor",_ba)])end
if(_b("border",_ba)~=nil)then if
(_b("border",_ba))then _d,ad,bd,cd=true,true,true,true end end;if(_b("borderLeft",_ba)~=nil)then
if(_b("borderLeft",_ba))then _d=true else _d=false end end
if
(_b("borderTop",_ba)~=nil)then if(_b("borderTop",_ba))then ad=true else ad=false end end;if(_b("borderRight",_ba)~=nil)then
if(_b("borderRight",_ba))then bd=true else bd=false end end
if
(_b("borderBottom",_ba)~=nil)then if(_b("borderBottom",_ba))then cd=true else cd=false end end;if(_b("borderColor",_ba)~=nil)then
daa:setBorder(colors[_b("borderColor",_ba)])end;if
(_b("ignoreOffset",_ba)~=nil)then
if(_b("ignoreOffset",_ba))then daa:ignoreOffset(true)end end;if
(_b("onClick",_ba)~=nil)then
daa:generateXMLEventFunction(daa.onClick,_b("onClick",_ba))end;if
(_b("onClickUp",_ba)~=nil)then
daa:generateXMLEventFunction(daa.onClickUp,_b("onClickUp",_ba))end;if
(_b("onScroll",_ba)~=nil)then
daa:generateXMLEventFunction(daa.onScroll,_b("onScroll",_ba))end;if
(_b("onDrag",_ba)~=nil)then
daa:generateXMLEventFunction(daa.onDrag,_b("onDrag",_ba))end;if(_b("onKey",_ba)~=nil)then
daa:generateXMLEventFunction(daa.onKey,_b("onKey",_ba))end;if(_b("onKeyUp",_ba)~=nil)then
daa:generateXMLEventFunction(daa.onKeyUp,_b("onKeyUp",_ba))end;if
(_b("onChange",_ba)~=nil)then
daa:generateXMLEventFunction(daa.onChange,_b("onChange",_ba))end;if
(_b("onResize",_ba)~=nil)then
daa:generateXMLEventFunction(daa.onResize,_b("onResize",_ba))end;if
(_b("onReposition",_ba)~=nil)then
daa:generateXMLEventFunction(daa.onReposition,_b("onReposition",_ba))end;if
(_b("onEvent",_ba)~=nil)then
daa:generateXMLEventFunction(daa.onEvent,_b("onEvent",_ba))end;if
(_b("onGetFocus",_ba)~=nil)then
daa:generateXMLEventFunction(daa.onGetFocus,_b("onGetFocus",_ba))end;if
(_b("onLoseFocus",_ba)~=nil)then
daa:generateXMLEventFunction(daa.onLoseFocus,_b("onLoseFocus",_ba))end;if(
_b("onBackgroundKey",_ba)~=nil)then
daa:generateXMLEventFunction(daa.onBackgroundKey,_b("onBackgroundKey",_ba))end;if(
_b("onBackgroundKeyUp",_ba)~=nil)then
daa:generateXMLEventFunction(daa.onBackgroundKeyUp,_b("onBackgroundKeyUp",_ba))end;return daa end,isVisible=function(daa)return
cc end,setFocus=function(daa)if(daa.parent~=nil)then
daa.parent:setFocusedObject(daa)end;return daa end,setZIndex=function(daa,_ba)
db=_ba;if(daa.parent~=nil)then daa.parent:removeObject(daa)
daa.parent:addObject(daa)end;return daa end,getZIndex=function(daa)return
db end,getType=function(daa)return bb end,getName=function(daa)return daa.name end,remove=function(daa)
if
(daa.parent~=nil)then daa.parent:removeObject(daa)end;return daa end,setParent=function(daa,_ba)
if(_ba.getType~=nil and
_ba:getType()=="Frame")then daa:remove()
_ba:addObject(daa)if(daa.draw)then daa:show()end end;return daa end,setValue=function(daa,_ba)
if(
_c~=_ba)then _c=_ba;baa=true;daa:valueChangedHandler()end;return daa end,getValue=function(daa)return _c end,getVisualChanged=function(daa)
return baa end,setVisualChanged=function(daa,_ba)baa=_ba or true;if(_ba==nil)then baa=true end;return daa end,getEventSystem=function(daa)return
caa end,getParent=function(daa)return daa.parent end,getObjectReferencesForDynVal=function(daa,_ba)end,setPosition=function(daa,_ba,aba,bba)
if
(type(_ba)=="number")then daa.x=bba and daa:getX()+_ba or _ba end;if(type(aba)=="number")then
daa.y=bba and daa:getY()+aba or aba end
if(daa.parent~=nil)then if(type(_ba)=="string")then
daa.x=daa.parent:newDynamicValue(daa,_ba)end;if(type(aba)=="string")then
daa.y=daa.parent:newDynamicValue(daa,aba)end
daa.parent:recalculateDynamicValues()end;caa:sendEvent("basalt_reposition",daa)baa=true;return daa end,getX=function(daa)return

type(daa.x)=="number"and daa.x or math.floor(daa.x[1]+0.5)end,getY=function(daa)return

type(daa.y)=="number"and daa.y or math.floor(daa.y[1]+0.5)end,getPosition=function(daa)return
daa:getX(),daa:getY()end,getVisibility=function(daa)return cc end,setVisibility=function(daa,_ba)
cc=_ba or not cc;baa=true;return daa end,setSize=function(daa,_ba,aba,bba)
if(type(_ba)=="number")then daa.width=bba and
daa.width+_ba or _ba end;if(type(aba)=="number")then
daa.height=bba and daa.height+aba or aba end
if(daa.parent~=nil)then if(type(_ba)=="string")then
daa.width=daa.parent:newDynamicValue(daa,_ba)end;if(type(aba)=="string")then
daa.height=daa.parent:newDynamicValue(daa,aba)end
daa.parent:recalculateDynamicValues()end;caa:sendEvent("basalt_resize",daa)baa=true;return daa end,getHeight=function(daa)
return
type(daa.height)=="number"and daa.height or
math.floor(daa.height[1]+0.5)end,getWidth=function(daa)return

type(daa.width)=="number"and daa.width or math.floor(daa.width[1]+0.5)end,getSize=function(daa)return
daa:getWidth(),daa:getHeight()end,calculateDynamicValues=function(daa)
if(
type(daa.width)=="table")then daa.width:calculate()end
if(type(daa.height)=="table")then daa.height:calculate()end
if(type(daa.x)=="table")then daa.x:calculate()end
if(type(daa.y)=="table")then daa.y:calculate()end;return daa end,setBackground=function(daa,_ba)daa.bgColor=
_ba or false;baa=true;return daa end,getBackground=function(daa)return
daa.bgColor end,setForeground=function(daa,_ba)daa.fgColor=_ba or false;baa=true;return daa end,getForeground=function(daa)return
daa.fgColor end,showShadow=function(daa,_ba)dc=_ba or(not dc)return daa end,setShadow=function(daa,_ba)
dd=_ba;return daa end,isShadowActive=function(daa)return dc end,showBorder=function(daa,...)
for _ba,aba in pairs(table.pack(...))do if(
aba=="left")then _d=true end;if(aba=="top")then ad=true end;if
(aba=="right")then bd=true end;if(aba=="bottom")then cd=true end end;return daa end,setBorder=function(daa,_ba)
__a=_ba;return daa end,getBorder=function(daa,_ba)if(_ba=="left")then return _d end
if(_ba=="top")then return ad end;if(_ba=="right")then return bd end;if(_ba=="bottom")then return cd end end,draw=function(daa)
if
(cc)then
if(daa.parent~=nil)then local _ba,aba=daa:getAnchorPosition()
local bba,cba=daa:getSize()
if(dc)then
daa.parent:drawBackgroundBox(_ba+1,aba+cba,bba,1,dd)
daa.parent:drawBackgroundBox(_ba+bba,aba+1,1,cba,dd)
daa.parent:drawForegroundBox(_ba+1,aba+cba,bba,1,dd)
daa.parent:drawForegroundBox(_ba+bba,aba+1,1,cba,dd)end
if(_d)then
daa.parent:drawTextBox(_ba-1,aba,1,cba,"\149")
daa.parent:drawForegroundBox(_ba-1,aba,1,cba,__a)if(daa.bgColor~=false)then
daa.parent:drawBackgroundBox(_ba-1,aba,1,cba,daa.bgColor)end end
if(_d)and(ad)then
daa.parent:drawTextBox(_ba-1,aba-1,1,1,"\151")
daa.parent:drawForegroundBox(_ba-1,aba-1,1,1,__a)if(daa.bgColor~=false)then
daa.parent:drawBackgroundBox(_ba-1,aba-1,1,1,daa.bgColor)end end
if(ad)then
daa.parent:drawTextBox(_ba,aba-1,bba,1,"\131")
daa.parent:drawForegroundBox(_ba,aba-1,bba,1,__a)if(daa.bgColor~=false)then
daa.parent:drawBackgroundBox(_ba,aba-1,bba,1,daa.bgColor)end end;if(ad)and(bd)then
daa.parent:drawTextBox(_ba+bba,aba-1,1,1,"\149")
daa.parent:drawForegroundBox(_ba+bba,aba-1,1,1,__a)end
if(bd)then daa.parent:drawTextBox(
_ba+bba,aba,1,cba,"\149")daa.parent:drawForegroundBox(
_ba+bba,aba,1,cba,__a)end;if(bd)and(cd)then
daa.parent:drawTextBox(_ba+bba,aba+cba,1,1,"\129")
daa.parent:drawForegroundBox(_ba+bba,aba+cba,1,1,__a)end
if(cd)then daa.parent:drawTextBox(_ba,
aba+cba,bba,1,"\131")daa.parent:drawForegroundBox(_ba,
aba+cba,bba,1,__a)end;if(cd)and(_d)then
daa.parent:drawTextBox(_ba-1,aba+cba,1,1,"\131")
daa.parent:drawForegroundBox(_ba-1,aba+cba,1,1,__a)end end;return true end;return false end,getAbsolutePosition=function(daa,_ba,aba)
if(
_ba==nil)or(aba==nil)then _ba,aba=daa:getAnchorPosition()end
if(daa.parent~=nil)then
local bba,cba=daa.parent:getAbsolutePosition()_ba=bba+_ba-1;aba=cba+aba-1 end;return _ba,aba end,getAnchorPosition=function(daa,_ba,aba,bba)if(
_ba==nil)then _ba=daa:getX()end
if(aba==nil)then aba=daa:getY()end
if(daa.parent~=nil)then local cba,dba=daa.parent:getSize()
if(ac=="top")then _ba=math.floor(
cba/2)+_ba-1 elseif(ac=="topRight")then
_ba=cba+_ba-1 elseif(ac=="right")then _ba=cba+_ba-1
aba=math.floor(dba/2)+aba-1 elseif(ac=="bottomRight")then _ba=cba+_ba-1;aba=dba+aba-1 elseif(ac=="bottom")then _ba=math.floor(
cba/2)+_ba-1;aba=dba+aba-1 elseif(ac==
"bottomLeft")then aba=dba+aba-1 elseif(ac=="left")then
aba=math.floor(dba/2)+aba-1 elseif(ac=="center")then _ba=math.floor(cba/2)+_ba-1;aba=math.floor(
dba/2)+aba-1 end;local _ca,aca=daa.parent:getOffsetInternal()if not(bc or bba)then return _ba+
_ca,aba+aca end end;return _ba,aba end,ignoreOffset=function(daa,_ba)
bc=_ba;if(_ba==nil)then bc=true end;return daa end,getBaseFrame=function(daa)
if(
daa.parent~=nil)then return daa.parent:getBaseFrame()end;return daa end,setAnchor=function(daa,_ba)ac=_ba;baa=true;return daa end,getAnchor=function(daa)return
ac end,onChange=function(daa,...)
for _ba,aba in pairs(table.pack(...))do if(type(aba)=="function")then
daa:registerEvent("value_changed",aba)end end;return daa end,onClick=function(daa,...)
for _ba,aba in
pairs(table.pack(...))do
if(type(aba)=="function")then
daa:registerEvent("mouse_click",aba)daa:registerEvent("monitor_touch",aba)end end;return daa end,onClickUp=function(daa,...)for _ba,aba in
pairs(table.pack(...))do
if(type(aba)=="function")then daa:registerEvent("mouse_up",aba)end end;return daa end,onScroll=function(daa,...)
for _ba,aba in
pairs(table.pack(...))do if(type(aba)=="function")then
daa:registerEvent("mouse_scroll",aba)end end;return daa end,onDrag=function(daa,...)if
(a_a)then
for _ba,aba in pairs(table.pack(...))do if(type(aba)=="function")then
daa:registerEvent("mouse_drag",aba)end end end;return daa end,onEvent=function(daa,...)
for _ba,aba in
pairs(table.pack(...))do if(type(aba)=="function")then
daa:registerEvent("custom_event_handler",aba)end end;return daa end,onKey=function(daa,...)
for _ba,aba in
pairs(table.pack(...))do if(type(aba)=="function")then daa:registerEvent("key",aba)
daa:registerEvent("char",aba)end end;return daa end,onResize=function(daa,...)
for _ba,aba in
pairs(table.pack(...))do if(type(aba)=="function")then
daa:registerEvent("basalt_resize",aba)end end;return daa end,onReposition=function(daa,...)
for _ba,aba in
pairs(table.pack(...))do if(type(aba)=="function")then
daa:registerEvent("basalt_reposition",aba)end end;return daa end,onKeyUp=function(daa,...)for _ba,aba in
pairs(table.pack(...))do
if(type(aba)=="function")then daa:registerEvent("key_up",aba)end end;return daa end,onBackgroundKey=function(daa,...)
for _ba,aba in
pairs(table.pack(...))do
if(type(aba)=="function")then
daa:registerEvent("background_key",aba)daa:registerEvent("background_char",aba)end end;return daa end,onBackgroundKeyUp=function(daa,...)
for _ba,aba in
pairs(table.pack(...))do if(type(aba)=="function")then
daa:registerEvent("background_key_up",aba)end end;return daa end,isFocused=function(daa)if(
daa.parent~=nil)then
return daa.parent:getFocusedObject()==daa end;return false end,onGetFocus=function(daa,...)
for _ba,aba in
pairs(table.pack(...))do if(type(aba)=="function")then
daa:registerEvent("get_focus",aba)end end;return daa end,onLoseFocus=function(daa,...)
for _ba,aba in
pairs(table.pack(...))do if(type(aba)=="function")then
daa:registerEvent("lose_focus",aba)end end;return daa end,registerEvent=function(daa,_ba,aba)return
caa:registerEvent(_ba,aba)end,removeEvent=function(daa,_ba,aba)
return caa:removeEvent(_ba,aba)end,sendEvent=function(daa,_ba,...)return caa:sendEvent(_ba,daa,...)end,mouseHandler=function(daa,_ba,aba,bba,cba)
if
(a_a)and(cc)then
local dba,_ca=daa:getAbsolutePosition(daa:getAnchorPosition())local aca,bca=daa:getSize()local cca=false;if
(_ca-1 ==cba)and(daa:getBorder("top"))then cba=cba+1;cca=true end;if(_ba=="mouse_up")then
b_a=false end
if(b_a)and(_ba=="mouse_drag")then local dca,_da,ada,bda=0,0,1,1
if(daa.parent~=
nil)then dca,_da=daa.parent:getOffsetInternal()dca=dca<0 and
math.abs(dca)or-dca;_da=
_da<0 and math.abs(_da)or-_da
ada,bda=daa.parent:getAbsolutePosition(daa.parent:getAnchorPosition())end
local cda,dda=bba+_aa- (ada-1)+dca,cba+aaa- (bda-1)+_da
local __b=caa:sendEvent(_ba,daa,_ba,aba,cda,dda,c_a,d_a,bba,cba)end
if(dba<=bba)and(dba+aca>bba)and(_ca<=cba)and
(_ca+bca>cba)then if(_ba=="mouse_click")then b_a=true;c_a,d_a=bba,cba;_aa,aaa=dba-bba,
_ca-cba end
if(_ba~="mouse_drag")then if(
_ba~="mouse_up")then if(daa.parent~=nil)then
daa.parent:setFocusedObject(daa)end end
local dca=caa:sendEvent(_ba,daa,_ba,aba,bba,cba)if(dca~=nil)then return dca end end;return true end end;return false end,keyHandler=function(daa,_ba,aba)if
(a_a)then
if(daa:isFocused())then local bba=caa:sendEvent(_ba,daa,_ba,aba)if(bba~=nil)then
return bba end;return true end end;return false end,backgroundKeyHandler=function(daa,_ba,aba)
if
(a_a)then
local bba=caa:sendEvent("background_".._ba,daa,_ba,aba)if(bba~=nil)then return bba end end;return true end,valueChangedHandler=function(daa)
caa:sendEvent("value_changed",daa)end,eventHandler=function(daa,_ba,aba,bba,cba,dba)
caa:sendEvent("custom_event_handler",daa,_ba,aba,bba,cba,dba)end,getFocusHandler=function(daa)
local _ba=caa:sendEvent("get_focus",daa)if(_ba~=nil)then return _ba end;return true end,loseFocusHandler=function(daa)
local _ba=caa:sendEvent("lose_focus",daa)if(_ba~=nil)then return _ba end;return true end}cb.__index=cb;return cb end
end; 
project['default']['theme'] = function(...)
return
{BasaltBG=colors.lightGray,BasaltText=colors.black,FrameBG=colors.gray,FrameText=colors.black,ButtonBG=colors.gray,ButtonText=colors.black,CheckboxBG=colors.gray,CheckboxText=colors.black,InputBG=colors.gray,InputText=colors.black,TextfieldBG=colors.gray,TextfieldText=colors.black,ListBG=colors.gray,ListText=colors.black,MenubarBG=colors.gray,MenubarText=colors.black,DropdownBG=colors.gray,DropdownText=colors.black,RadioBG=colors.gray,RadioText=colors.black,SelectionBG=colors.black,SelectionText=colors.lightGray,GraphicBG=colors.black,ImageBG=colors.black,PaneBG=colors.black,ProgramBG=colors.black,ProgressbarBG=colors.gray,ProgressbarText=colors.black,ProgressbarActiveBG=colors.black,ScrollbarBG=colors.lightGray,ScrollbarText=colors.gray,ScrollbarSymbolColor=colors.black,SliderBG=colors.lightGray,SliderText=colors.gray,SliderSymbolColor=colors.black,SwitchBG=colors.lightGray,SwitchText=colors.gray,SwitchBGSymbol=colors.black,SwitchInactive=colors.red,SwitchActive=colors.green}
end; 
local aaa=require("basaltEvent")()
local baa=require("Frame")local caa=require("theme")local daa=require("utils")local _ba=daa.uuid
local aba=daa.createText;local bba=term.current()local cba=5;local dba=true
local _ca=fs.getDir(table.pack(...)[2]or"")local aca,bca,cca,dca,_da={},{},{},{},{}local ada,bda,cda,dda;if not term.isColor or
not term.isColor()then
error('Basalt requires an advanced (golden) computer to run.',0)end
local function __b()dda=false end;local a_b=function(abb,bbb)dca[abb]=bbb end
local b_b=function(abb)return dca[abb]end;local c_b=function(abb)caa=abb end
local d_b=function(abb)return caa[abb]end
local _ab={getMainFrame=function()return ada end,setVariable=a_b,getVariable=b_b,getTheme=d_b,setMainFrame=function(abb)ada=abb end,getActiveFrame=function()return bda end,setActiveFrame=function(abb)bda=abb end,getFocusedObject=function()return
cda end,setFocusedObject=function(abb)cda=abb end,getMonitorFrame=function(abb)return cca[abb]end,setMonitorFrame=function(abb,bbb)
cca[abb]=bbb end,getBaseTerm=function()return bba end,stop=__b,newFrame=baa,getDirectory=function()return _ca end}
local aab=function(abb)bba.clear()bba.setBackgroundColor(colors.black)
bba.setTextColor(colors.red)local bbb,cbb=bba.getSize()
local dbb=function(ccb,dcb)if dcb==nil then dcb="%s"end;local _db={}
for adb in string.gmatch(ccb,
"([^"..dcb.."]+)")do table.insert(_db,adb)end;return _db end;local _cb=dbb(abb," ")local acb="Basalt error: "local bcb=1
for n=1,#_cb do
bba.setCursorPos(1,bcb)if(#acb+#_cb[n]<bbb)then acb=acb.." ".._cb[n]else
bba.write(acb)acb=_cb[n]bcb=bcb+1 end;if(n==#_cb)then
bba.write(acb)end end;bba.setCursorPos(1,bcb+1)end
local function bab(abb,bbb,cbb,dbb,_cb)
if(#_da>0)then local acb={}
for n=1,#_da do
if(_da[n]~=nil)then
if
(coroutine.status(_da[n])=="suspended")then
local bcb,ccb=coroutine.resume(_da[n],abb,bbb,cbb,dbb,_cb)if not(bcb)then aab(ccb)end else table.insert(acb,n)end end end
for n=1,#acb do table.remove(_da,acb[n]- (n-1))end end end;local function cab()
if(dda)then if(ada~=nil)then ada:draw()ada:drawUpdate()end;for abb,bbb in
pairs(cca)do bbb:draw()bbb:drawUpdate()end end end
local function dab(abb,bbb,cbb,dbb,_cb)
if(
aaa:sendEvent("basaltEventCycle",abb,bbb,cbb,dbb,_cb)==false)then return end
if(ada~=nil)then
if(abb=="mouse_click")then
ada:mouseHandler(abb,bbb,cbb,dbb,_cb)bda=ada elseif(abb=="mouse_drag")then
ada:mouseHandler(abb,bbb,cbb,dbb,_cb)bda=ada elseif(abb=="mouse_up")then
ada:mouseHandler(abb,bbb,cbb,dbb,_cb)bda=ada elseif(abb=="mouse_scroll")then
ada:mouseHandler(abb,bbb,cbb,dbb,_cb)bda=ada elseif(abb=="monitor_touch")then if(cca[bbb]~=nil)then
cca[bbb]:mouseHandler(abb,bbb,cbb,dbb,_cb)bda=cca[bbb]end end end;if(abb=="key")or(abb=="char")then
if(bda~=nil)then
bda:keyHandler(abb,bbb)bda:backgroundKeyHandler(abb,bbb)end end;if(abb=="key")then
aca[bbb]=true end;if(abb=="key_up")then aca[bbb]=false end
for acb,bcb in
pairs(bca)do bcb:eventHandler(abb,bbb,cbb,dbb,_cb)end;bab(abb,bbb,cbb,dbb,_cb)cab()end;local _bb={}
_bb={setTheme=c_b,getTheme=d_b,getVersion=function()return cba end,setVariable=a_b,getVariable=b_b,setBaseTerm=function(abb)bba=abb end,autoUpdate=function(abb)local bbb=pcall;dda=abb;if
(abb==nil)then dda=true end;cab()
while dda do local cbb,dbb,_cb,acb,bcb=os.pullEventRaw()
local ccb,dcb=bbb(dab,cbb,dbb,_cb,acb,bcb)if not(ccb)then aab(dcb)return end end end,update=function(abb,bbb,cbb,dbb,_cb)if(
abb~=nil)then dab(abb,bbb,cbb,dbb,_cb)end end,stop=__b,isKeyDown=function(abb)if(
aca[abb]==nil)then return false end;return aca[abb]end,getFrame=function(abb)for bbb,cbb in
pairs(bca)do if(cbb.name==abb)then return cbb end end end,getActiveFrame=function()return
bda end,setActiveFrame=function(abb)
if(abb:getType()=="Frame")then bda=abb;return true end;return false end,onEvent=function(...)
for abb,bbb in
pairs(table.pack(...))do if(type(bbb)=="function")then
aaa:registerEvent("basaltEventCycle",bbb)end end end,schedule=function(abb)
assert(abb~=
"function","Schedule needs a function in order to work!")return
function(...)local bbb=coroutine.create(abb)
local cbb,dbb=coroutine.resume(bbb,...)if(cbb)then table.insert(_da,bbb)else aab(dbb)end end end,createFrame=function(abb)abb=
abb or _ba()
for cbb,dbb in pairs(bca)do if(dbb.name==abb)then return nil end end;local bbb=baa(abb,nil,nil,_ab)table.insert(bca,bbb)
if(ada==nil)and(
bbb:getName()~="basaltDebuggingFrame")then bbb:show()end;return bbb end,removeFrame=function(abb)bca[abb]=
nil end,setProjectDir=function(abb)_ca=abb end,debug=function(...)local abb={...}if
(ada.name~="basaltDebuggingFrame")then
if(ada~=_bb.debugFrame)then _bb.debugLabel:setParent(ada)end end;local bbb=""for cbb,dbb in pairs(abb)do
bbb=bbb..
tostring(dbb).. (#abb~=cbb and", "or"")end
_bb.debugLabel:setText("[Debug] "..bbb)for cbb,dbb in pairs(aba(bbb,_bb.debugList:getWidth()))do
_bb.debugList:addItem(dbb)end
if(
_bb.debugList:getItemCount()>50)then _bb.debugList:removeItem(1)end
_bb.debugList:setValue(_bb.debugList:getItem(_bb.debugList:getItemCount()))if
(_bb.debugList.getItemCount()>_bb.debugList:getHeight())then
_bb.debugList:setOffset(_bb.debugList:getItemCount()-
_bb.debugList:getHeight())end
_bb.debugLabel:show()end}
_bb.debugFrame=_bb.createFrame("basaltDebuggingFrame"):showBar():setBackground(colors.lightGray):setBar("Debug",colors.black,colors.gray)
_bb.debugFrame:addButton("back"):setAnchor("topRight"):setSize(1,1):setText("\22"):onClick(function()if(
_bb.oldFrame~=nil)then _bb.oldFrame:show()end end):setBackground(colors.red):show()
_bb.debugList=_bb.debugFrame:addList("debugList"):setSize(
_bb.debugFrame.width-2,_bb.debugFrame.height-3):setPosition(2,3):setScrollable(true):show()
_bb.debugLabel=_bb.debugFrame:addLabel("debugLabel"):onClick(function()
_bb.oldFrame=ada;_bb.debugFrame:show()end):setBackground(colors.black):setForeground(colors.white):setAnchor("bottomLeft"):ignoreOffset():setZIndex(20):show()return _bb