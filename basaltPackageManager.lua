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
project['objects'] = {}project['libraries'] = {}project['default'] = {}project['objects']['Animation'] = function(...)
return
function(a)local b={}local c="Animation"local d;local _a={}local aa=1;local ba=false;local ca=0;local da;local _b
local function ab()if(_a[aa]~=nil)then
_a[aa].f(b,aa)end;aa=aa+1
if(_a[aa]==nil)then if(ba)then aa=1 else return end end
if(_a[aa].t>0)then d=os.startTimer(_a[aa].t)else ab()end end
b={name=a,getType=function(bb)return c end,getZIndex=function(bb)return 1 end,getName=function(bb)return bb.name end,add=function(bb,cb,db)da=cb;table.insert(_a,{f=cb,t=
db or ca})return bb end,setObject=function(bb,cb)
_b=cb;return bb end,move=function(bb,cb,db,_c,ac,bc)if(bc~=nil)then _b=bc end;if(_b.setPosition==nil)or(_b.getPosition==
nil)then return bb end
local cc,dc=_b:getPosition()if(cc==cb)and(dc==db)then return bb end;local _d=cc<=cb and(cb-cc)/ac or
(cc-cb)/ac;local ad=dc<=db and(db-dc)/ac or
(dc-db)/ac;local bd,cd=cc>cb and true or false,
dc>db and true or false
for n=1,math.floor(ac)do local dd
if
(n==ac)then dd=function()_b:setPosition(cb,db)end else
dd=function()
_b:setPosition(math.floor(
bd and cc+ (-_d*n)or cc+_d*n),math.floor(cd and dc+ (-
ad*n)or dc+ad*n))end end;table.insert(_a,{f=dd,t=_c/ac})end;return bb end,offset=function(bb,cb,db,_c,ac,bc)if(
bc~=nil)then _b=bc end;if
(_b.setOffset==nil)or(_b.getOffset==nil)then return bb end;local cc,dc=_b:getOffset()
cc=math.abs(cc)dc=math.abs(dc)if(cc==cb)and(dc==db)then return bb end;local _d=cc<=cb and
(cb-cc)/ac or(cc-cb)/ac;local ad=dc<=db and
(db-dc)/ac or(dc-db)/ac;local bd,cd=
cc>cb and true or false,dc>db and true or false
for n=1,math.floor(ac)
do local dd
if(n==ac)then dd=function()_b:setOffset(cb,db)end else
dd=function()
_b:setOffset(math.floor(
bd and cc+ (-_d*n)or cc+_d*n),math.floor(cd and dc+ (-
ad*n)or dc+ad*n))end end;table.insert(_a,{f=dd,t=_c/ac})end;return bb end,textColoring=function(bb,cb,...)
local db=table.pack(...)for n=1,#db do
table.insert(_a,{f=function()_b:setForeground(db[n])end,t=cb/#db})end;return bb end,backgroundColoring=function(bb,cb,...)
local db=table.pack(...)for n=1,#db do
table.insert(_a,{f=function()_b:setBackground(db[n])end,t=cb/#db})end;return bb end,setText=function(bb,cb,db)
if(
_b.setText~=nil)then for n=1,db:len()do
table.insert(_a,{f=function()_b:setText(db:sub(1,n))end,t=
cb/db:len()})end end;return bb end,changeText=function(bb,cb,...)
if(
_b.setText~=nil)then local db=table.pack(...)for n=1,#db do
table.insert(_a,{f=function()
_b:setText(db[n])end,t=cb/#db})end end;return bb end,coloring=function(bb,cb,...)
local db=table.pack(...)
for n=1,#db do
if(type(db[n]=="table"))then
table.insert(_a,{f=function()if(db[n][1]~=nil)then
_b:setBackground(db[n][1])end;if(db[n][2]~=nil)then
_b:setForeground(db[n][2])end end,t=
cb/#db})end end;return bb end,wait=function(bb,cb)
ca=cb;return bb end,rep=function(bb,cb)
for n=1,cb do table.insert(_a,{f=da,t=ca})end;return bb end,clear=function(bb)_a={}da=nil;ca=0;aa=1;ba=false;return bb end,play=function(bb,cb)ba=
cb and true or false;aa=1;if(_a[aa]~=nil)then if(_a[aa].t>0)then
d=os.startTimer(_a[aa].t)else ab()end end
return bb end,cancel=function(bb)
os.cancelTimer(d)ba=false;return bb end,eventHandler=function(bb,cb,db)if(cb=="timer")and(db==d)then if
(_a[aa]~=nil)then ab()end end end}b.__index=b;return b end
end;
project['objects']['Button'] = function(...)local d=require("Object")local _a=require("theme")
local aa=require("utils")
return
function(ba)local ca=d(ba)local da="Button"ca:setValue("Button")
ca:setZIndex(5)ca.width=8;ca.bgColor=_a.ButtonBG;ca.fgColor=_a.ButtonFG;local _b="center"
local ab="center"
local bb={getType=function(cb)return da end,setHorizontalAlign=function(cb,db)_b=db end,setVerticalAlign=function(cb,db)ab=db end,setText=function(cb,db)ca:setValue(db)
return cb end,draw=function(cb)
if(ca.draw(cb))then
if(cb.parent~=nil)then
local db,_c=cb:getAnchorPosition()local ac=aa.getTextVerticalAlign(cb.height,ab)if
(cb.bgColor~=false)then
cb.parent:drawBackgroundBox(db,_c,cb.width,cb.height,cb.bgColor)
cb.parent:drawTextBox(db,_c,cb.width,cb.height," ")end;if(
cb.fgColor~=false)then
cb.parent:drawForegroundBox(db,_c,cb.width,cb.height,cb.fgColor)end
for n=1,cb.height do if(n==ac)then
cb.parent:setText(db,_c+
(n-1),aa.getTextHorizontalAlign(cb:getValue(),cb.width,_b))end end end;cb:setVisualChanged(false)end end}return setmetatable(bb,ca)end
end; 
project['objects']['Checkbox'] = function(...)local d=require("Object")local _a=require("theme")
local aa=require("utils")
return
function(ba)local ca=d(ba)local da="Checkbox"ca:setZIndex(5)ca:setValue(false)
ca.width=1;ca.height=1;ca.bgColor=_a.CheckboxBG;ca.fgColor=_a.CheckboxFG
local _b={symbol="\42",getType=function(ab)return da end,mouseHandler=function(ab,bb,cb,db,_c)
if
(ca.mouseHandler(ab,bb,cb,db,_c))then
if
( (bb=="mouse_click")and(cb==1))or(bb=="monitor_touch")then
if(ab:getValue()~=true)and(ab:getValue()~=false)then
ab:setValue(false)else ab:setValue(not ab:getValue())end end;return true end;return false end,draw=function(ab)
if
(ca.draw(ab))then
if(ab.parent~=nil)then local bb,cb=ab:getAnchorPosition()
local db=aa.getTextVerticalAlign(ab.height,"center")if(ab.bgColor~=false)then
ab.parent:drawBackgroundBox(bb,cb,ab.width,ab.height,ab.bgColor)end
for n=1,ab.height do
if(n==db)then
if
(ab:getValue()==true)then
ab.parent:writeText(bb,cb+ (n-1),aa.getTextHorizontalAlign(ab.symbol,ab.width,"center"),ab.bgColor,ab.fgColor)else
ab.parent:writeText(bb,cb+ (n-1),aa.getTextHorizontalAlign(" ",ab.width,"center"),ab.bgColor,ab.fgColor)end end end end;ab:setVisualChanged(false)end end}return setmetatable(_b,ca)end
end; 
project['objects']['Dropdown'] = function(...)local d=require("Object")local _a=require("theme")
local aa=require("utils")
return
function(ba)local ca=d(ba)local da="Dropdown"ca.width=12;ca.height=1;ca.bgColor=_a.dropdownBG
ca.fgColor=_a.dropdownFG;ca:setZIndex(6)local _b={}local ab=_a.selectionBG;local bb=_a.selectionFG
local cb=true;local db="left"local _c=0;local ac=16;local bc=6;local cc="\16"local dc="\31"local _d=false
local ad={getType=function(bd)return da end,setIndexOffset=function(bd,cd)
_c=cd;return bd end,getIndexOffset=function(bd)return _c end,addItem=function(bd,cd,dd,__a,...)
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
if(cd=="mouse_scroll")then _c=_c+dd;if(_c<0)then _c=0 end
if(dd==1)then if(#_b>bc)then if(_c>#_b-bc)then _c=#_b-
bc end else _c=_b-1 end end;return true end;bd:setVisualChanged()end
if(ca.mouseHandler(bd,cd,dd,__a,a_a))then _d=true else _d=false end end,draw=function(bd)
if
(ca.draw(bd))then local cd,dd=bd:getAnchorPosition()
if(bd.parent~=nil)then if(bd.bgColor~=false)then
bd.parent:drawBackgroundBox(cd,dd,bd.width,bd.height,bd.bgColor)end;local __a=bd:getValue()
local a_a=aa.getTextHorizontalAlign((
__a~=nil and __a.text or""),bd.width,db):sub(1,
bd.width-1).. (_d and dc or cc)
bd.parent:writeText(cd,dd,a_a,bd.bgColor,bd.fgColor)
if(_d)then
for n=1,bc do
if(_b[n+_c]~=nil)then
if(_b[n+_c]==__a)then
if(cb)then
bd.parent:writeText(cd,dd+n,aa.getTextHorizontalAlign(_b[n+
_c].text,ac,db),ab,bb)else
bd.parent:writeText(cd,dd+n,aa.getTextHorizontalAlign(_b[n+_c].text,ac,db),_b[n+
_c].bgCol,_b[n+_c].fgCol)end else
bd.parent:writeText(cd,dd+n,aa.getTextHorizontalAlign(_b[n+_c].text,ac,db),_b[n+
_c].bgCol,_b[n+_c].fgCol)end end end end end;bd:setVisualChanged(false)end end}return setmetatable(ad,ca)end
end; 
project['objects']['Label'] = function(...)local aa=require("Object")local ba=require("theme")
local ca=require("utils")local da=require("tHex")local _b=require("bigfont")
return
function(ab)local bb=aa(ab)
local cb="Label"bb:setZIndex(3)local db=true;bb:setValue("")local _c="left"local ac="top"
local bc=0;local cc,dc=false,false
local _d={getType=function(ad)return cb end,setText=function(ad,bd)bd=tostring(bd)
bb:setValue(bd)if(db)then ad.width=bd:len()end
if not(cc)then ad.fgColor=
ad.parent:getForeground()or colors.white end;if not(dc)then
ad.bgColor=ad.parent:getBackground()or colors.black end;return ad end,setBackground=function(ad,bd)
bb.setBackground(ad,bd)dc=true;return ad end,setForeground=function(ad,bd)
bb.setForeground(ad,bd)cc=true;return ad end,setTextAlign=function(ad,bd,cd)_c=bd or _c;ac=cd or ac
ad:setVisualChanged()return ad end,setFontSize=function(ad,bd)if(bd>0)and(bd<=4)then
bc=bd-1 or 0 end;return ad end,getFontSize=function(ad)return bc+1 end,setSize=function(ad,bd,cd)
bb.setSize(ad,bd,cd)db=false;ad:setVisualChanged()return ad end,draw=function(ad)
if
(bb.draw(ad))then
if(ad.parent~=nil)then local bd,cd=ad:getAnchorPosition()
local dd=ca.getTextVerticalAlign(ad.height,ac)if(ad.bgColor~=false)then
ad.parent:drawBackgroundBox(bd,cd,ad.width,ad.height,ad.bgColor)
ad.parent:drawTextBox(bd,cd,ad.width,ad.height," ")end;if(
ad.fgColor~=false)then
ad.parent:drawForegroundBox(bd,cd,ad.width,ad.height,ad.fgColor)end
if(bc==0)then
for n=1,ad.height do if(n==dd)then
ad.parent:setText(bd,
cd+ (n-1),ca.getTextHorizontalAlign(ad:getValue(),ad.width,_c))end end else
local __a=_b(bc,ad:getValue(),ad.fgColor,ad.bgColor or colors.black)
if(db)then ad.height=#__a[1]-1;ad.width=#__a[1][1]end
for n=1,ad.height do
if(n==dd)then local a_a,b_a=ad.parent:getSize()
local c_a,d_a=#__a[1][1],#__a[1]
bd=bd or math.floor((a_a-c_a)/2)+1
cd=cd or math.floor((b_a-d_a)/2)+1
for i=1,d_a do
ad.parent:setFG(bd,cd+i+n-2,ca.getTextHorizontalAlign(__a[2][i],ad.width,_c))
ad.parent:setBG(bd,cd+i+n-2,ca.getTextHorizontalAlign(__a[3][i],ad.width,_c,da[ad.bgColor or colors.black]))
ad.parent:setText(bd,cd+i+n-2,ca.getTextHorizontalAlign(__a[1][i],ad.width,_c))end end end end end;ad:setVisualChanged(false)end end}return setmetatable(_d,bb)end
end; 
project['objects']['List'] = function(...)local d=require("Object")local _a=require("theme")
local aa=require("utils")
return
function(ba)local ca=d(ba)local da="List"ca.width=16;ca.height=6;ca.bgColor=_a.listBG
ca.fgColor=_a.listFG;ca:setZIndex(5)local _b={}local ab=_a.selectionBG;local bb=_a.selectionFG
local cb=true;local db="left"local _c=0;local ac=true
local bc={getType=function(cc)return da end,addItem=function(cc,dc,_d,ad,...)
table.insert(_b,{text=dc,bgCol=_d or cc.bgColor,fgCol=ad or cc.fgColor,args={...}})if(#_b==1)then cc:setValue(_b[1])end;return cc end,setIndexOffset=function(cc,dc)
_c=dc;return cc end,getIndexOffset=function(cc)return _c end,removeItem=function(cc,dc)table.remove(_b,dc)
return cc end,getItem=function(cc,dc)return _b[dc]end,getAll=function(cc)return _b end,getItemIndex=function(cc)
local dc=cc:getValue()for _d,ad in pairs(_b)do if(ad==dc)then return _d end end end,clear=function(cc)
_b={}cc:setValue({})return cc end,getItemCount=function(cc)return#_b end,editItem=function(cc,dc,_d,ad,bd,...)
table.remove(_b,dc)
table.insert(_b,dc,{text=_d,bgCol=ad or cc.bgColor,fgCol=bd or cc.fgColor,args={...}})return cc end,selectItem=function(cc,dc)cc:setValue(
_b[dc]or{})return cc end,setSelectedItem=function(cc,dc,_d,ad)
ab=dc or cc.bgColor;bb=_d or cc.fgColor;cb=ad;return cc end,setScrollable=function(cc,dc)
ac=dc;return cc end,mouseHandler=function(cc,dc,_d,ad,bd)
local cd,dd=cc:getAbsolutePosition(cc:getAnchorPosition())
if
(cd<=ad)and(cd+cc.width>ad)and(dd<=bd)and(
dd+cc.height>bd)and(cc:isVisible())then
if
( ( (dc=="mouse_click")or(dc=="mouse_drag"))and(_d==1))or(dc=="monitor_touch")then
if(#_b>0)then
for n=1,cc.height do
if(
_b[n+_c]~=nil)then
if
(cd<=ad)and(cd+cc.width>ad)and(dd+n-1 ==bd)then cc:setValue(_b[n+_c])
cc:getEventSystem():sendEvent("mouse_click",cc,"mouse_click",0,ad,bd,_b[
n+_c])end end end end end
if(dc=="mouse_scroll")and(ac)then _c=_c+_d;if(_c<0)then _c=0 end;if(_d>=1)then
if
(#_b>cc.height)then if(_c>#_b-cc.height)then _c=#_b-cc.height end;if
(_c>=#_b)then _c=#_b-1 end else _c=_c-1 end end end;cc:setVisualChanged()return true end end,draw=function(cc)
if
(ca.draw(cc))then
if(cc.parent~=nil)then local dc,_d=cc:getAnchorPosition()if(cc.bgColor~=false)then
cc.parent:drawBackgroundBox(dc,_d,cc.width,cc.height,cc.bgColor)end
for n=1,cc.height do
if(_b[n+_c]~=nil)then
if(
_b[n+_c]==cc:getValue())then
if(cb)then
cc.parent:writeText(dc,_d+n-1,aa.getTextHorizontalAlign(_b[n+_c].text,cc.width,db),ab,bb)else
cc.parent:writeText(dc,_d+n-1,aa.getTextHorizontalAlign(_b[n+_c].text,cc.width,db),_b[
n+_c].bgCol,_b[n+_c].fgCol)end else
cc.parent:writeText(dc,_d+n-1,aa.getTextHorizontalAlign(_b[n+_c].text,cc.width,db),_b[
n+_c].bgCol,_b[n+_c].fgCol)end end end end;cc:setVisualChanged(false)end end}return setmetatable(bc,ca)end
end; 
project['objects']['List'] = function(...)local d=require("Object")local _a=require("theme")
local aa=require("utils")
return
function(ba)local ca=d(ba)local da="List"ca.width=16;ca.height=6;ca.bgColor=_a.listBG
ca.fgColor=_a.listFG;ca:setZIndex(5)local _b={}local ab=_a.selectionBG;local bb=_a.selectionFG
local cb=true;local db="left"local _c=0;local ac=true
local bc={getType=function(cc)return da end,addItem=function(cc,dc,_d,ad,...)
table.insert(_b,{text=dc,bgCol=_d or cc.bgColor,fgCol=ad or cc.fgColor,args={...}})if(#_b==1)then cc:setValue(_b[1])end;return cc end,setIndexOffset=function(cc,dc)
_c=dc;return cc end,getIndexOffset=function(cc)return _c end,removeItem=function(cc,dc)table.remove(_b,dc)
return cc end,getItem=function(cc,dc)return _b[dc]end,getAll=function(cc)return _b end,getItemIndex=function(cc)
local dc=cc:getValue()for _d,ad in pairs(_b)do if(ad==dc)then return _d end end end,clear=function(cc)
_b={}cc:setValue({})return cc end,getItemCount=function(cc)return#_b end,editItem=function(cc,dc,_d,ad,bd,...)
table.remove(_b,dc)
table.insert(_b,dc,{text=_d,bgCol=ad or cc.bgColor,fgCol=bd or cc.fgColor,args={...}})return cc end,selectItem=function(cc,dc)cc:setValue(
_b[dc]or{})return cc end,setSelectedItem=function(cc,dc,_d,ad)
ab=dc or cc.bgColor;bb=_d or cc.fgColor;cb=ad;return cc end,setScrollable=function(cc,dc)
ac=dc;return cc end,mouseHandler=function(cc,dc,_d,ad,bd)
local cd,dd=cc:getAbsolutePosition(cc:getAnchorPosition())
if
(cd<=ad)and(cd+cc.width>ad)and(dd<=bd)and(
dd+cc.height>bd)and(cc:isVisible())then
if
( ( (dc=="mouse_click")or(dc=="mouse_drag"))and(_d==1))or(dc=="monitor_touch")then
if(#_b>0)then
for n=1,cc.height do
if(
_b[n+_c]~=nil)then
if
(cd<=ad)and(cd+cc.width>ad)and(dd+n-1 ==bd)then cc:setValue(_b[n+_c])
cc:getEventSystem():sendEvent("mouse_click",cc,"mouse_click",0,ad,bd,_b[
n+_c])end end end end end
if(dc=="mouse_scroll")and(ac)then _c=_c+_d;if(_c<0)then _c=0 end;if(_d>=1)then
if
(#_b>cc.height)then if(_c>#_b-cc.height)then _c=#_b-cc.height end;if
(_c>=#_b)then _c=#_b-1 end else _c=_c-1 end end end;cc:setVisualChanged()return true end end,draw=function(cc)
if
(ca.draw(cc))then
if(cc.parent~=nil)then local dc,_d=cc:getAnchorPosition()if(cc.bgColor~=false)then
cc.parent:drawBackgroundBox(dc,_d,cc.width,cc.height,cc.bgColor)end
for n=1,cc.height do
if(_b[n+_c]~=nil)then
if(
_b[n+_c]==cc:getValue())then
if(cb)then
cc.parent:writeText(dc,_d+n-1,aa.getTextHorizontalAlign(_b[n+_c].text,cc.width,db),ab,bb)else
cc.parent:writeText(dc,_d+n-1,aa.getTextHorizontalAlign(_b[n+_c].text,cc.width,db),_b[
n+_c].bgCol,_b[n+_c].fgCol)end else
cc.parent:writeText(dc,_d+n-1,aa.getTextHorizontalAlign(_b[n+_c].text,cc.width,db),_b[
n+_c].bgCol,_b[n+_c].fgCol)end end end end;cc:setVisualChanged(false)end end}return setmetatable(bc,ca)end
end; 
project['objects']['Menubar'] = function(...)local _a=require("Object")local aa=require("theme")
local ba=require("utils")local ca=require("tHex")
return
function(da)local _b=_a(da)local ab="Menubar"local bb={}_b.width=30
_b.height=1;_b.bgColor=colors.gray;_b.fgColor=colors.lightGray
_b:setZIndex(5)local cb={}local db=aa.selectionBG;local _c=aa.selectionFG;local ac=true;local bc="left"local cc=0
local dc=1;local _d=false
local function ad()local bd=0;local cd=0
for n=1,#cb do
if(cd+cb[n].text:len()+dc*2 >
bb.width)then
if(cd<bb.width)then bd=bd+ (cb[n].text:len()+dc*2 - (
bb.width-cd))else bd=
bd+cb[n].text:len()+dc*2 end end;cd=cd+cb[n].text:len()+dc*2 end;return bd end
bb={getType=function(bd)return ab end,addItem=function(bd,cd,dd,__a,...)
table.insert(cb,{text=cd,bgCol=dd or bd.bgColor,fgCol=__a or bd.fgColor,args={...}})if(#cb==1)then bd:setValue(cb[1])end;return bd end,getAll=function(bd)return
cb end,getItemIndex=function(bd)local cd=bd:getValue()for dd,__a in pairs(cb)do
if(__a==cd)then return dd end end end,clear=function(bd)
cb={}bd:setValue({})return bd end,setSpace=function(bd,cd)dc=cd or dc;return bd end,setPositionOffset=function(bd,cd)cc=
cd or 0;if(cc<0)then cc=0 end;local dd=ad()if(cc>dd)then cc=dd end;return bd end,getPositionOffset=function(bd)return
cc end,setScrollable=function(bd,cd)_d=cd;if(cd==nil)then _d=true end;return bd end,removeItem=function(bd,cd)
table.remove(cb,cd)return bd end,getItem=function(bd,cd)return cb[cd]end,getItemCount=function(bd)return#cb end,editItem=function(bd,cd,dd,__a,a_a,...)
table.remove(cb,cd)
table.insert(cb,cd,{text=dd,bgCol=__a or bd.bgColor,fgCol=a_a or bd.fgColor,args={...}})return bd end,selectItem=function(bd,cd)bd:setValue(
cb[cd]or{})return bd end,setSelectedItem=function(bd,cd,dd,__a)
db=cd or bd.bgColor;_c=dd or bd.fgColor;ac=__a;return bd end,mouseHandler=function(bd,cd,dd,__a,a_a)
if
(_b.mouseHandler(bd,cd,dd,__a,a_a))then
local b_a,c_a=bd:getAbsolutePosition(bd:getAnchorPosition())
if

(b_a<=__a)and(b_a+bd.width>__a)and(c_a<=a_a)and(c_a+bd.height>a_a)and(bd:isVisible())then
if(bd.parent~=nil)then bd.parent:setFocusedObject(bd)end
if(cd=="mouse_click")or(cd=="monitor_touch")then local d_a=0
for n=1,#cb do
if
(cb[n]~=nil)then
if
(b_a+d_a<=__a+cc)and(
b_a+d_a+cb[n].text:len()+ (dc*2)>__a+cc)and(c_a==a_a)then bd:setValue(cb[n])
bd:getEventSystem():sendEvent(cd,bd,cd,0,__a,a_a,cb[n])end;d_a=d_a+cb[n].text:len()+dc*2 end end end;if(cd=="mouse_scroll")and(_d)then cc=cc+dd;if(cc<0)then cc=0 end;local d_a=ad()if
(cc>d_a)then cc=d_a end end
bd:setVisualChanged(true)return true end end;return false end,draw=function(bd)
if
(_b.draw(bd))then
if(bd.parent~=nil)then local cd,dd=bd:getAnchorPosition()if(bd.bgColor~=false)then
bd.parent:drawBackgroundBox(cd,dd,bd.width,bd.height,bd.bgColor)end;local __a=""local a_a=""local b_a=""
for c_a,d_a in
pairs(cb)do
local _aa=(" "):rep(dc)..d_a.text.. (" "):rep(dc)__a=__a.._aa
if(d_a==bd:getValue())then a_a=a_a..
ca[db or d_a.bgCol or bd.bgColor]:rep(_aa:len())b_a=b_a..
ca[_c or d_a.FgCol or
bd.fgColor]:rep(_aa:len())else a_a=a_a..
ca[d_a.bgCol or bd.bgColor]:rep(_aa:len())b_a=b_a..
ca[d_a.FgCol or bd.fgColor]:rep(_aa:len())end end
bd.parent:setText(cd,dd,__a:sub(cc+1,bd.width+cc))
bd.parent:setBG(cd,dd,a_a:sub(cc+1,bd.width+cc))
bd.parent:setFG(cd,dd,b_a:sub(cc+1,bd.width+cc))end;bd:setVisualChanged(false)end end}return setmetatable(bb,_b)end
end; 
project['objects']['Radio'] = function(...)local d=require("Object")local _a=require("theme")
local aa=require("utils")
return
function(ba)local ca=d(ba)local da="Radio"ca.width=8;ca.bgColor=_a.listBG
ca.fgColor=_a.listFG;ca:setZIndex(5)local _b={}local ab=_a.selectionBG;local bb=_a.selectionFG
local cb=ca.bgColor;local db=ca.fgColor;local _c=true;local ac="\7"local bc="left"
local cc={getType=function(dc)return da end,addItem=function(dc,_d,ad,bd,cd,dd,...)
table.insert(_b,{x=ad or 1,y=
bd or 1,text=_d,bgCol=cd or dc.bgColor,fgCol=dd or dc.fgColor,args={...}})if(#_b==1)then dc:setValue(_b[1])end;return dc end,getAll=function(dc)return
_b end,removeItem=function(dc,_d)table.remove(_b,_d)return dc end,getItem=function(dc,_d)return
_b[_d]end,getItemIndex=function(dc)local _d=dc:getValue()for ad,bd in pairs(_b)do
if(bd==_d)then return ad end end end,clear=function(dc)
_b={}dc:setValue({})return dc end,getItemCount=function(dc)return#_b end,editItem=function(dc,_d,ad,bd,cd,dd,__a,...)
table.remove(_b,_d)
table.insert(_b,_d,{x=bd or 1,y=cd or 1,text=ad,bgCol=dd or dc.bgColor,fgCol=__a or dc.fgColor,args={...}})return dc end,selectItem=function(dc,_d)dc:setValue(
_b[_d]or{})return dc end,setSelectedItem=function(dc,_d,ad,bd,cd,dd)ab=_d or ab;bb=
ad or bb;cb=bd or cb;db=cd or db;_c=dd;return dc end,mouseHandler=function(dc,_d,ad,bd,cd)
local dd,__a=dc:getAbsolutePosition(dc:getAnchorPosition())
if
( (_d=="mouse_click")and(ad==1))or(_d=="monitor_touch")then
if(#_b>0)then
for a_a,b_a in pairs(_b)do
if(dd+b_a.x-1 <=bd)and(
dd+b_a.x-1 +b_a.text:len()+2 >=bd)and(
__a+b_a.y-1 ==cd)then dc:setValue(b_a)
if(
dc.parent~=nil)then dc.parent:setFocusedObject(dc)end;dc:setVisualChanged()return true end end end end;return false end,draw=function(dc)
if
(ca.draw(dc))then
if(dc.parent~=nil)then local _d,ad=dc:getAnchorPosition()
for bd,cd in pairs(_b)do
if(cd==
dc:getValue())then if(bc=="left")then
dc.parent:writeText(cd.x+_d-1,cd.y+ad-1,ac,cb,db)
dc.parent:writeText(cd.x+2 +_d-1,cd.y+ad-1,cd.text,ab,bb)end else
dc.parent:drawBackgroundBox(
cd.x+_d-1,cd.y+ad-1,1,1,dc.bgColor)
dc.parent:writeText(cd.x+2 +_d-1,cd.y+ad-1,cd.text,cd.bgCol,cd.fgCol)end end end;dc:setVisualChanged(false)end end}return setmetatable(cc,ca)end
end; 
project['objects']['Scrollbar'] = function(...)local c=require("Object")local d=require("theme")
return
function(_a)local aa=c(_a)
local ba="Scrollbar"aa.width=1;aa.height=8;aa.bgColor=colors.lightGray
aa.fgColor=colors.gray;aa:setValue(1)aa:setZIndex(2)local ca="vertical"local da=" "
local _b=colors.black;local ab="\127"local bb=aa.height;local cb=1;local db=1
local _c={getType=function(ac)return ba end,setSymbol=function(ac,bc)da=bc:sub(1,1)
ac:setVisualChanged()return ac end,setSymbolSize=function(ac,bc)db=tonumber(bc)or 1
if
(ca=="vertical")then
ac:setValue(cb-1 * (bb/ (ac.height- (db-1)))- (bb/ (
ac.height- (db-1))))elseif(ca=="horizontal")then
ac:setValue(
cb-1 * (bb/ (ac.width- (db-1)))- (bb/ (ac.width- (db-1))))end;ac:setVisualChanged()return ac end,setMaxValue=function(ac,bc)
bb=bc;return ac end,setBackgroundSymbol=function(ac,bc)ab=string.sub(bc,1,1)
ac:setVisualChanged()return ac end,setSymbolColor=function(ac,bc)_b=bc
ac:setVisualChanged()return ac end,setBarType=function(ac,bc)ca=bc:lower()return ac end,mouseHandler=function(ac,bc,cc,dc,_d)
if
(aa.mouseHandler(ac,bc,cc,dc,_d))then
local ad,bd=ac:getAbsolutePosition(ac:getAnchorPosition())
if
( ( (bc=="mouse_click")or(bc=="mouse_drag"))and(cc==1))or(bc=="monitor_touch")then
if(ca=="horizontal")then
for _index=0,ac.width
do if
(ad+_index==dc)and(bd<=_d)and(bd+ac.height>_d)then cb=math.min(_index+1,ac.width- (db-1))ac:setValue(
bb/ac.width* (cb))
ac:setVisualChanged()end end end
if(ca=="vertical")then
for _index=0,ac.height do if(bd+_index==_d)and(ad<=dc)and
(ad+ac.width>dc)then
cb=math.min(_index+1,ac.height- (db-1))ac:setValue(bb/ac.height* (cb))
ac:setVisualChanged()end end end end
if(bc=="mouse_scroll")then cb=cb+cc;if(cb<1)then cb=1 end
cb=math.min(cb,(
ca=="vertical"and ac.height or ac.width)- (db-1))
ac:setValue(
bb/ (ca=="vertical"and ac.height or ac.width)*cb)end;return true end end,draw=function(ac)
if
(aa.draw(ac))then
if(ac.parent~=nil)then local bc,cc=ac:getAnchorPosition()
if(ca=="horizontal")then
ac.parent:writeText(bc,cc,ab:rep(
cb-1),ac.bgColor,ac.fgColor)
ac.parent:writeText(bc+cb-1,cc,da:rep(db),_b,_b)
ac.parent:writeText(bc+cb+db-1,cc,ab:rep(ac.width- (cb+db-1)),ac.bgColor,ac.fgColor)end
if(ca=="vertical")then
for n=0,ac.height-1 do
if(cb==n+1)then for curIndexOffset=0,math.min(db-1,ac.height)do
ac.parent:writeText(bc,
cc+n+curIndexOffset,da,_b,_b)end else if(n+1 <cb)or
(n+1 >cb-1 +db)then
ac.parent:writeText(bc,cc+n,ab,ac.bgColor,ac.fgColor)end end end end end;ac:setVisualChanged(false)end end}return setmetatable(_c,aa)end
end; 
project['objects']['Thread'] = function(...)
return
function(a)local b;local c="Thread"local d;local _a;local aa=false
b={name=a,getType=function(ba)return c end,getZIndex=function(ba)return 1 end,getName=function(ba)
return ba.name end,start=function(ba,ca)if(ca==nil)then
error("Function provided to thread is nil")end;d=ca;_a=coroutine.create(d)
aa=true;local da,_b=coroutine.resume(_a)if not(da)then
if(_b~="Terminated")then error(
"Thread Error Occurred - ".._b)end end;return ba end,getStatus=function(ba,ca)if(
_a~=nil)then return coroutine.status(_a)end;return nil end,stop=function(ba,ca)
aa=false;return ba end,eventHandler=function(ba,ca,da,_b,ab)
if(aa)then
if(coroutine.status(_a)~="dead")then
local bb,cb=coroutine.resume(_a,ca,da,_b,ab)if not(bb)then if(cb~="Terminated")then
error("Thread Error Occurred - "..cb)end end else
aa=false end end end}b.__index=b;return b end
end; 
project['libraries']['basaltDraw'] = function(...)local d=require("tHex")local _a,aa=string.sub,string.rep
return
function(ba)
local ca=ba or term.current()local da,_b=ca.getSize()local ab={}local bb={}local cb={}local db={}local _c={}local ac={}local bc;local cc={}local function dc()
bc=aa(" ",da)
for n=0,15 do local __a=2 ^n;local a_a=d[__a]cc[__a]=aa(a_a,da)end end;dc()
local function _d()local __a=bc
local a_a=cc[colors.white]local b_a=cc[colors.black]
for currentY=1,_b do
ab[currentY]=_a(
ab[currentY]==nil and __a or
ab[currentY]..__a:sub(1,da-ab[currentY]:len()),1,da)
cb[currentY]=_a(cb[currentY]==nil and a_a or cb[currentY]..a_a:sub(1,da-
cb[currentY]:len()),1,da)
bb[currentY]=_a(bb[currentY]==nil and b_a or bb[currentY]..b_a:sub(1,da-
bb[currentY]:len()),1,da)end end;_d()
local function ad(__a,a_a,b_a)
if(a_a>=1)and(a_a<=_b)then
if
(__a+b_a:len()>0)and(__a<=da)then local c_a=ab[a_a]local d_a;local _aa=__a+#b_a-1
if(__a<1)then local aaa=1 -__a+1
local baa=da-__a+1;b_a=_a(b_a,aaa,baa)elseif(_aa>da)then local aaa=da-__a+1;b_a=_a(b_a,1,aaa)end
if(__a>1)then local aaa=__a-1;d_a=_a(c_a,1,aaa)..b_a else d_a=b_a end;if _aa<da then d_a=d_a.._a(c_a,_aa+1,da)end
ab[a_a]=d_a end end end
local function bd(__a,a_a,b_a)
if(a_a>=1)and(a_a<=_b)then
if(__a+b_a:len()>0)and(__a<=da)then
local c_a=bb[a_a]local d_a;local _aa=__a+#b_a-1
if(__a<1)then
b_a=_a(b_a,1 -__a+1,da-__a+1)elseif(_aa>da)then b_a=_a(b_a,1,da-__a+1)end
if(__a>1)then d_a=_a(c_a,1,__a-1)..b_a else d_a=b_a end;if _aa<da then d_a=d_a.._a(c_a,_aa+1,da)end
bb[a_a]=d_a end end end
local function cd(__a,a_a,b_a)
if(a_a>=1)and(a_a<=_b)then
if(__a+b_a:len()>0)and(__a<=da)then
local c_a=cb[a_a]local d_a;local _aa=__a+#b_a-1
if(__a<1)then local aaa=1 -__a+1;local baa=da-__a+1
b_a=_a(b_a,aaa,baa)elseif(_aa>da)then local aaa=da-__a+1;b_a=_a(b_a,1,aaa)end
if(__a>1)then local aaa=__a-1;d_a=_a(c_a,1,aaa)..b_a else d_a=b_a end;if _aa<da then d_a=d_a.._a(c_a,_aa+1,da)end
cb[a_a]=d_a end end end
local dd={setBG=function(__a,a_a,b_a)bd(__a,a_a,b_a)end,setText=function(__a,a_a,b_a)ad(__a,a_a,b_a)end,setFG=function(__a,a_a,b_a)
cd(__a,a_a,b_a)end,drawBackgroundBox=function(__a,a_a,b_a,c_a,d_a)for n=1,c_a do
bd(__a,a_a+ (n-1),aa(d[d_a],b_a))end end,drawForegroundBox=function(__a,a_a,b_a,c_a,d_a)
for n=1,c_a do cd(__a,a_a+
(n-1),aa(d[d_a],b_a))end end,drawTextBox=function(__a,a_a,b_a,c_a,d_a)for n=1,c_a do
ad(__a,a_a+ (n-1),aa(d_a,b_a))end end,writeText=function(__a,a_a,b_a,c_a,d_a)c_a=c_a or
ca.getBackgroundColor()
d_a=d_a or ca.getTextColor()ad(__a,a_a,b_a)
bd(__a,a_a,aa(d[c_a],b_a:len()))cd(__a,a_a,aa(d[d_a],b_a:len()))end,update=function()
local __a,a_a=ca.getCursorPos()local b_a=false
if(ca.getCursorBlink~=nil)then b_a=ca.getCursorBlink()end;ca.setCursorBlink(false)for n=1,_b do ca.setCursorPos(1,n)
ca.blit(ab[n],cb[n],bb[n])end
ca.setBackgroundColor(colors.black)ca.setCursorBlink(b_a)ca.setCursorPos(__a,a_a)end,setTerm=function(__a)
ca=__a end}return dd end
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
project['libraries']['bigfont'] = function(...)
local aa={{"\32\32\32\137\156\148\158\159\148\135\135\144\159\139\32\136\157\32\159\139\32\32\143\32\32\143\32\32\32\32\32\32\32\32\147\148\150\131\148\32\32\32\151\140\148\151\140\147","\32\32\32\149\132\149\136\156\149\144\32\133\139\159\129\143\159\133\143\159\133\138\32\133\138\32\133\32\32\32\32\32\32\150\150\129\137\156\129\32\32\32\133\131\129\133\131\132","\32\32\32\130\131\32\130\131\32\32\129\32\32\32\32\130\131\32\130\131\32\32\32\32\143\143\143\32\32\32\32\32\32\130\129\32\130\135\32\32\32\32\131\32\32\131\32\131","\139\144\32\32\143\148\135\130\144\149\32\149\150\151\149\158\140\129\32\32\32\135\130\144\135\130\144\32\149\32\32\139\32\159\148\32\32\32\32\159\32\144\32\148\32\147\131\132","\159\135\129\131\143\149\143\138\144\138\32\133\130\149\149\137\155\149\159\143\144\147\130\132\32\149\32\147\130\132\131\159\129\139\151\129\148\32\32\139\131\135\133\32\144\130\151\32","\32\32\32\32\32\32\130\135\32\130\32\129\32\129\129\131\131\32\130\131\129\140\141\132\32\129\32\32\129\32\32\32\32\32\32\32\131\131\129\32\32\32\32\32\32\32\32\32","\32\32\32\32\149\32\159\154\133\133\133\144\152\141\132\133\151\129\136\153\32\32\154\32\159\134\129\130\137\144\159\32\144\32\148\32\32\32\32\32\32\32\32\32\32\32\151\129","\32\32\32\32\133\32\32\32\32\145\145\132\141\140\132\151\129\144\150\146\129\32\32\32\138\144\32\32\159\133\136\131\132\131\151\129\32\144\32\131\131\129\32\144\32\151\129\32","\32\32\32\32\129\32\32\32\32\130\130\32\32\129\32\129\32\129\130\129\129\32\32\32\32\130\129\130\129\32\32\32\32\32\32\32\32\133\32\32\32\32\32\129\32\129\32\32","\150\156\148\136\149\32\134\131\148\134\131\148\159\134\149\136\140\129\152\131\32\135\131\149\150\131\148\150\131\148\32\148\32\32\148\32\32\152\129\143\143\144\130\155\32\134\131\148","\157\129\149\32\149\32\152\131\144\144\131\148\141\140\149\144\32\149\151\131\148\32\150\32\150\131\148\130\156\133\32\144\32\32\144\32\130\155\32\143\143\144\32\152\129\32\134\32","\130\131\32\131\131\129\131\131\129\130\131\32\32\32\129\130\131\32\130\131\32\32\129\32\130\131\32\130\129\32\32\129\32\32\133\32\32\32\129\32\32\32\130\32\32\32\129\32","\150\140\150\137\140\148\136\140\132\150\131\132\151\131\148\136\147\129\136\147\129\150\156\145\138\143\149\130\151\32\32\32\149\138\152\129\149\32\32\157\152\149\157\144\149\150\131\148","\149\143\142\149\32\149\149\32\149\149\32\144\149\32\149\149\32\32\149\32\32\149\32\149\149\32\149\32\149\32\144\32\149\149\130\148\149\32\32\149\32\149\149\130\149\149\32\149","\130\131\129\129\32\129\131\131\32\130\131\32\131\131\32\131\131\129\129\32\32\130\131\32\129\32\129\130\131\32\130\131\32\129\32\129\131\131\129\129\32\129\129\32\129\130\131\32","\136\140\132\150\131\148\136\140\132\153\140\129\131\151\129\149\32\149\149\32\149\149\32\149\137\152\129\137\152\129\131\156\133\149\131\32\150\32\32\130\148\32\152\137\144\32\32\32","\149\32\32\149\159\133\149\32\149\144\32\149\32\149\32\149\32\149\150\151\129\138\155\149\150\130\148\32\149\32\152\129\32\149\32\32\32\150\32\32\149\32\32\32\32\32\32\32","\129\32\32\130\129\129\129\32\129\130\131\32\32\129\32\130\131\32\32\129\32\129\32\129\129\32\129\32\129\32\131\131\129\130\131\32\32\32\129\130\131\32\32\32\32\140\140\132","\32\154\32\159\143\32\149\143\32\159\143\32\159\144\149\159\143\32\159\137\145\159\143\144\149\143\32\32\145\32\32\32\145\149\32\144\32\149\32\143\159\32\143\143\32\159\143\32","\32\32\32\152\140\149\151\32\149\149\32\145\149\130\149\157\140\133\32\149\32\154\143\149\151\32\149\32\149\32\144\32\149\149\153\32\32\149\32\149\133\149\149\32\149\149\32\149","\32\32\32\130\131\129\131\131\32\130\131\32\130\131\129\130\131\129\32\129\32\140\140\129\129\32\129\32\129\32\137\140\129\130\32\129\32\130\32\129\32\129\129\32\129\130\131\32","\144\143\32\159\144\144\144\143\32\159\143\144\159\138\32\144\32\144\144\32\144\144\32\144\144\32\144\144\32\144\143\143\144\32\150\129\32\149\32\130\150\32\134\137\134\134\131\148","\136\143\133\154\141\149\151\32\129\137\140\144\32\149\32\149\32\149\154\159\133\149\148\149\157\153\32\154\143\149\159\134\32\130\148\32\32\149\32\32\151\129\32\32\32\32\134\32","\133\32\32\32\32\133\129\32\32\131\131\32\32\130\32\130\131\129\32\129\32\130\131\129\129\32\129\140\140\129\131\131\129\32\130\129\32\129\32\130\129\32\32\32\32\32\129\32","\32\32\32\32\149\32\32\149\32\32\32\32\32\32\32\32\149\32\32\149\32\32\32\32\32\32\32\32\149\32\32\149\32\32\32\32\32\32\32\32\149\32\32\149\32\32\32\32","\32\32\32\32\32\32\32\32\32\32\32\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\32\32\32\32\32\32\32\32\32\32\32","\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32","\32\32\32\32\149\32\32\149\32\32\32\32\32\32\32\32\149\32\32\149\32\32\32\32\32\32\32\32\149\32\32\149\32\32\32\32\32\32\32\32\149\32\32\149\32\32\32\32","\32\32\32\32\32\32\32\32\32\32\32\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\32\32\32\32\32\32\32\32\32\32\32","\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32","\32\32\32\32\145\32\159\139\32\151\131\132\155\143\132\134\135\145\32\149\32\158\140\129\130\130\32\152\147\155\157\134\32\32\144\144\32\32\32\32\32\32\152\131\155\131\131\129","\32\32\32\32\149\32\149\32\145\148\131\32\149\32\149\140\157\132\32\148\32\137\155\149\32\32\32\149\154\149\137\142\32\153\153\32\131\131\149\131\131\129\149\135\145\32\32\32","\32\32\32\32\129\32\130\135\32\131\131\129\134\131\132\32\129\32\32\129\32\131\131\32\32\32\32\130\131\129\32\32\32\32\129\129\32\32\32\32\32\32\130\131\129\32\32\32","\150\150\32\32\148\32\134\32\32\132\32\32\134\32\32\144\32\144\150\151\149\32\32\32\32\32\32\145\32\32\152\140\144\144\144\32\133\151\129\133\151\129\132\151\129\32\145\32","\130\129\32\131\151\129\141\32\32\142\32\32\32\32\32\149\32\149\130\149\149\32\143\32\32\32\32\142\132\32\154\143\133\157\153\132\151\150\148\151\158\132\151\150\148\144\130\148","\32\32\32\140\140\132\32\32\32\32\32\32\32\32\32\151\131\32\32\129\129\32\32\32\32\134\32\32\32\32\32\32\32\129\129\32\129\32\129\129\130\129\129\32\129\130\131\32","\156\143\32\159\141\129\153\140\132\153\137\32\157\141\32\159\142\32\150\151\129\150\131\132\140\143\144\143\141\145\137\140\148\141\141\144\157\142\32\159\140\32\151\134\32\157\141\32","\157\140\149\157\140\149\157\140\149\157\140\149\157\140\149\157\140\149\151\151\32\154\143\132\157\140\32\157\140\32\157\140\32\157\140\32\32\149\32\32\149\32\32\149\32\32\149\32","\129\32\129\129\32\129\129\32\129\129\32\129\129\32\129\129\32\129\129\131\129\32\134\32\131\131\129\131\131\129\131\131\129\131\131\129\130\131\32\130\131\32\130\131\32\130\131\32","\151\131\148\152\137\145\155\140\144\152\142\145\153\140\132\153\137\32\154\142\144\155\159\132\150\156\148\147\32\144\144\130\145\136\137\32\146\130\144\144\130\145\130\136\32\151\140\132","\151\32\149\151\155\149\149\32\149\149\32\149\149\32\149\149\32\149\149\32\149\152\137\144\157\129\149\149\32\149\149\32\149\149\32\149\149\32\149\130\150\32\32\157\129\149\32\149","\131\131\32\129\32\129\130\131\32\130\131\32\130\131\32\130\131\32\130\131\32\32\32\32\130\131\32\130\131\32\130\131\32\130\131\32\130\131\32\32\129\32\130\131\32\133\131\32","\156\143\32\159\141\129\153\140\132\153\137\32\157\141\32\159\142\32\159\159\144\152\140\144\156\143\32\159\141\129\153\140\132\157\141\32\130\145\32\32\147\32\136\153\32\130\146\32","\152\140\149\152\140\149\152\140\149\152\140\149\152\140\149\152\140\149\149\157\134\154\143\132\157\140\133\157\140\133\157\140\133\157\140\133\32\149\32\32\149\32\32\149\32\32\149\32","\130\131\129\130\131\129\130\131\129\130\131\129\130\131\129\130\131\129\130\130\131\32\134\32\130\131\129\130\131\129\130\131\129\130\131\129\32\129\32\32\129\32\32\129\32\32\129\32","\159\134\144\137\137\32\156\143\32\159\141\129\153\140\132\153\137\32\157\141\32\32\132\32\159\143\32\147\32\144\144\130\145\136\137\32\146\130\144\144\130\145\130\138\32\146\130\144","\149\32\149\149\32\149\149\32\149\149\32\149\149\32\149\149\32\149\149\32\149\131\147\129\138\134\149\149\32\149\149\32\149\149\32\149\149\32\149\154\143\149\32\157\129\154\143\149","\130\131\32\129\32\129\130\131\32\130\131\32\130\131\32\130\131\32\130\131\32\32\32\32\130\131\32\130\131\129\130\131\129\130\131\129\130\131\129\140\140\129\130\131\32\140\140\129"},{"000110000110110000110010101000000010000000100101","000000110110000000000010101000000010000000100101","000000000000000000000000000000000000000000000000","100010110100000010000110110000010100000100000110","000000110000000010110110000110000000000000110000","000000000000000000000000000000000000000000000000","000000110110000010000000100000100000000000000010","000000000110110100010000000010000000000000000100","000000000000000000000000000000000000000000000000","010000000000100110000000000000000000000110010000","000000000000000000000000000010000000010110000000","000000000000000000000000000000000000000000000000","011110110000000100100010110000000100000000000000","000000000000000000000000000000000000000000000000","000000000000000000000000000000000000000000000000","110000110110000000000000000000010100100010000000","000010000000000000110110000000000100010010000000","000000000000000000000000000000000000000000000000","010110010110100110110110010000000100000110110110","000000000000000000000110000000000110000000000000","000000000000000000000000000000000000000000000000","010100010110110000000000000000110000000010000000","110110000000000000110000110110100000000010000000","000000000000000000000000000000000000000000000000","000100011111000100011111000100011111000100011111","000000000000100100100100011011011011111111111111","000000000000000000000000000000000000000000000000","000100011111000100011111000100011111000100011111","000000000000100100100100011011011011111111111111","100100100100100100100100100100100100100100100100","000000110100110110000010000011110000000000011000","000000000100000000000010000011000110000000001000","000000000000000000000000000000000000000000000000","010000100100000000000000000100000000010010110000","000000000000000000000000000000110110110110110000","000000000000000000000000000000000000000000000000","110110110110110110000000110110110110110110110110","000000000000000000000110000000000000000000000000","000000000000000000000000000000000000000000000000","000000000000110110000110010000000000000000010010","000010000000000000000000000000000000000000000000","000000000000000000000000000000000000000000000000","110110110110110110110000110110110110000000000000","000000000000000000000110000000000000000000000000","000000000000000000000000000000000000000000000000","110110110110110110110000110000000000000000010000","000000000000000000000000100000000000000110000110","000000000000000000000000000000000000000000000000"}}local ba={}local ca={}
do local ab=0;local bb=#aa[1]local cb=#aa[1][1]
for i=1,bb,3 do
for j=1,cb,3 do
local db=string.char(ab)local _c={}_c[1]=aa[1][i]:sub(j,j+2)
_c[2]=aa[1][i+1]:sub(j,j+2)_c[3]=aa[1][i+2]:sub(j,j+2)local ac={}ac[1]=aa[2][i]:sub(j,
j+2)ac[2]=aa[2][i+1]:sub(j,j+2)ac[3]=aa[2][
i+2]:sub(j,j+2)ca[db]={_c,ac}ab=ab+1 end end;ba[1]=ca end
local function da(ab,bb)local cb={["0"]="1",["1"]="0"}if ab<=#ba then return true end
for f=#ba+1,ab do local db={}local _c=ba[
f-1]
for char=0,255 do local ac=string.char(char)local bc={}local cc={}
local dc=_c[ac][1]local _d=_c[ac][2]
for i=1,#dc do local ad,bd,cd,dd,__a,a_a={},{},{},{},{},{}
for j=1,#dc[1]do
local b_a=ca[dc[i]:sub(j,j)][1]table.insert(ad,b_a[1])table.insert(bd,b_a[2])
table.insert(cd,b_a[3])local c_a=ca[dc[i]:sub(j,j)][2]
if
_d[i]:sub(j,j)=="1"then
table.insert(dd,(c_a[1]:gsub("[01]",cb)))
table.insert(__a,(c_a[2]:gsub("[01]",cb)))
table.insert(a_a,(c_a[3]:gsub("[01]",cb)))else table.insert(dd,c_a[1])
table.insert(__a,c_a[2])table.insert(a_a,c_a[3])end end;table.insert(bc,table.concat(ad))
table.insert(bc,table.concat(bd))table.insert(bc,table.concat(cd))
table.insert(cc,table.concat(dd))table.insert(cc,table.concat(__a))
table.insert(cc,table.concat(a_a))end;db[ac]={bc,cc}if bb then bb="Font"..f.."Yeld"..char
os.queueEvent(bb)os.pullEvent(bb)end end;ba[f]=db end;return true end
local function _b(ab,bb,cb,db,_c)
if not type(bb)=="string"then error("Not a String",3)end
local ac=
type(cb)=="string"and cb:sub(1,1)or tHex[cb]or error("Wrong Front Color",3)
local bc=
type(db)=="string"and db:sub(1,1)or tHex[db]or error("Wrong Back Color",3)if(ba[ab]==nil)then da(3,false)end;local cc=ba[ab]or
error("Wrong font size selected",3)if bb==""then
return{{""},{""},{""}}end;local dc={}
for a_a in bb:gmatch('.')do table.insert(dc,a_a)end;local _d={}local ad=#cc[dc[1] ][1]
for nLine=1,ad do local a_a={}
for i=1,#dc do a_a[i]=cc[dc[i] ]and
cc[dc[i] ][1][nLine]or""end;_d[nLine]=table.concat(a_a)end;local bd={}local cd={}local dd={["0"]=ac,["1"]=bc}local __a={["0"]=bc,["1"]=ac}
for nLine=1,ad do
local a_a={}local b_a={}
for i=1,#dc do
local c_a=cc[dc[i] ]and cc[dc[i] ][2][nLine]or""
a_a[i]=c_a:gsub("[01]",
_c and{["0"]=cb:sub(i,i),["1"]=db:sub(i,i)}or dd)
b_a[i]=c_a:gsub("[01]",
_c and{["0"]=db:sub(i,i),["1"]=cb:sub(i,i)}or __a)end;bd[nLine]=table.concat(a_a)
cd[nLine]=table.concat(b_a)end;return{_d,bd,cd}end;return _b
end; 
project['libraries']['tHex'] = function(...)
return
{[colors.white]="0",[colors.orange]="1",[colors.magenta]="2",[colors.lightBlue]="3",[colors.yellow]="4",[colors.lime]="5",[colors.pink]="6",[colors.gray]="7",[colors.lightGray]="8",[colors.cyan]="9",[colors.purple]="a",[colors.blue]="b",[colors.brown]="c",[colors.green]="d",[colors.red]="e",[colors.black]="f"}
end; 
project['libraries']['utils'] = function(...)
return
{getTextHorizontalAlign=function(a,b,c,d)a=string.sub(a,1,b)local _a=b-string.len(a)
if(c=="right")then a=string.rep(
d or" ",_a)..a elseif(c=="center")then
a=string.rep(d or" ",math.floor(
_a/2))..a..
string.rep(d or" ",math.floor(_a/2))
a=a.. (string.len(a)<b and(d or" ")or"")else a=a..string.rep(d or" ",_a)end;return a end,getTextVerticalAlign=function(a,b)
local c=0
if(b=="center")then c=math.ceil(a/2)if(c<1)then c=1 end end;if(b=="bottom")then c=a end;if(c<1)then c=1 end;return c end,rpairs=function(a)
return function(b,c)c=
c-1;if c~=0 then return c,b[c]end end,a,#a+1 end,shrink=function(a,b)
local c={[0]={8,4,3,6,5},{4,14,8,7},{6,10,8,7},{9,11,8,0},{1,14,8,0},{13,12,8,0},{2,10,8,0},{15,8,10,11,12,14},{0,7,1,9,2,13},{3,11,8,7},{2,6,7,15},{9,3,7,15},{13,5,7,15},{5,12,8,7},{1,4,7,15},{7,10,11,12,14}}local d,_a,aa={},{},{}for i=0,15 do _a[2 ^i]=i end
do local cb="0123456789abcdef"
for i=1,16 do d[cb:sub(i,i)]=
i-1;d[i-1]=cb:sub(i,i)
aa[cb:sub(i,i)]=2 ^ (i-1)aa[2 ^ (i-1)]=cb:sub(i,i)local db=c[i-1]
for i=1,#db do db[i]=2 ^db[i]end end end
local function ba(cb)local db=c[_a[cb[#cb][1] ] ]if(db~=nil)then
for j=1,#db do local _c=db[j]for i=1,#cb-1 do if
cb[i][1]==_c then return i end end end end;return 1 end
local function ca(cb,db)
if not db then local ac={}db={}for i=1,6 do local bc=cb[i]local cc=db[bc]
db[bc],ac[i]=cc and(cc+1)or 1,bc end;cb=ac end;local _c={}for ac,bc in pairs(db)do _c[#_c+1]={ac,bc}end
if#_c>1 then
while#_c>2 do
table.sort(_c,function(ad,bd)return
ad[2]>bd[2]end)local bc,cc=ba(_c),#_c;local dc,_d=_c[cc][1],_c[bc][1]
for i=1,6 do if cb[i]==dc then cb[i]=_d;_c[bc][2]=
_c[bc][2]+1 end end;_c[cc]=nil end;local ac=128
for i=1,#cb-1 do if cb[i]~=cb[6]then ac=ac+2 ^ (i-1)end end;return string.char(ac),
aa[_c[1][1]==cb[6]and _c[2][1]or _c[1][1] ],aa[cb[6] ]else
return"\128",aa[cb[1] ],aa[cb[1] ]end end;local da,_b,ab,bb={{},{},{}},0,#a+#a%3,b or colors.black;for i=1,#a do if
#a[i]>_b then _b=#a[i]end end
for y=0,ab-1,3 do local cb,db,_c,ac={},{},{},1
for x=0,_b-1,2 do
local bc,cc={},{}
for yy=1,3 do
for xx=1,2 do
bc[#bc+1]=
(a[y+yy]and a[y+yy][x+xx])and(
a[y+yy][x+xx]==0 and bb or a[y+yy][x+xx])or bb
cc[bc[#bc] ]=cc[bc[#bc] ]and(cc[bc[#bc] ]+1)or 1 end end;cb[ac],db[ac],_c[ac]=ca(bc,cc)ac=ac+1 end
da[1][#da[1]+1],da[2][#da[2]+1],da[3][#da[3]+1]=table.concat(cb),table.concat(db),table.concat(_c)end;da.width,da.height=#da[1][1],#da[1]return da end}
end; 
project['default']['Frame'] = function(...)local ca=require("Object")local da=require("loadObjects")
local _b=require("basaltDraw")local ab=require("theme")local bb=require("utils")local cb=bb.rpairs
local db=string.sub
return
function(_c,ac,bc,cc)local dc=ca(_c)local _d="Frame"local ad={}local bd={}local cd={}
local dd=bc or term.current()local __a=""local a_a=false;local b_a=false;local c_a=0;local d_a=0;dc:setZIndex(10)
local _aa=_b(dd)local aaa=false;local baa=1;local caa=1;local daa=colors.white;local _ba,aba=0,0
if(ac~=nil)then dc.parent=ac
dc.width,dc.height=ac:getSize()dc.bgColor=ab.FrameBG;dc.fgColor=ab.FrameFG else
dc.width,dc.height=dd.getSize()dc.bgColor=ab.basaltBG;dc.fgColor=ab.basaltFG end
local function bba(_ca)for aca,bca in pairs(ad)do
for cca,dca in pairs(bca)do if(dca.name==_ca)then return bca end end end end
local function cba(_ca)local aca=_ca:getZIndex()
if(bba(_ca.name)~=nil)then return nil end
if(ad[aca]==nil)then for x=1,#bd+1 do
if(bd[x]~=nil)then if(aca==bd[x])then break end;if(aca>bd[x])then
table.insert(bd,x,aca)break end else table.insert(bd,aca)end end;if(
#bd<=0)then table.insert(bd,aca)end;ad[aca]={}end;_ca.parent=cd;table.insert(ad[aca],_ca)return _ca end
local function dba(_ca)
for aca,bca in pairs(ad)do for cca,dca in pairs(bca)do
if(dca==_ca)then table.remove(ad[aca],cca)return true end end end;return false end
cd={barActive=false,barBackground=colors.gray,barTextcolor=colors.black,barText="New Frame",barTextAlign="left",isMoveable=false,getType=function(_ca)return _d end,setFocusedObject=function(_ca,aca)
if
(cc.getFocusedObject()~=nil)then
cc.getFocusedObject():loseFocusHandler()cc.setFocusedObject(nil)end;if(aca~=nil)then cc.setFocusedObject(aca)
aca:getFocusHandler()end;return _ca end,setSize=function(_ca,aca,bca)
dc.setSize(_ca,aca,bca)
for cca,dca in pairs(bd)do if(ad[dca]~=nil)then
for _da,ada in pairs(ad[dca])do if(ada.eventHandler~=nil)then
ada:sendEvent("basalt_resize",ada,_ca)end end end end;return _ca end,getBasaltInstance=function(_ca)return
cc end,setOffset=function(_ca,aca,bca)
_ba=aca~=nil and
math.floor(aca<0 and math.abs(aca)or-aca)or _ba
aba=bca~=nil and
math.floor(bca<0 and math.abs(bca)or-bca)or aba;return _ca end,getOffset=function(_ca)return
_ba,aba end,removeFocusedObject=function(_ca)if(cc.getFocusedObject()~=nil)then
cc.getFocusedObject():loseFocusHandler()end;cc.setFocusedObject(nil)return
_ca end,getFocusedObject=function(_ca)return
cc.getFocusedObject()end,setCursor=function(_ca,aca,bca,cca,dca)
if(_ca.parent~=nil)then
local _da,ada=_ca:getAnchorPosition()
_ca.parent:setCursor(aca or false,(bca or 0)+_da-1,(cca or 0)+ada-1,
dca or daa)else
local _da,ada=_ca:getAbsolutePosition(_ca:getAnchorPosition())aaa=aca or false;if(bca~=nil)then baa=_da+bca-1 end;if(cca~=nil)then caa=ada+
cca-1 end;daa=dca or daa
_ca:setVisualChanged()end;return _ca end,setMoveable=function(_ca,aca)_ca.isMoveable=
aca or not _ca.isMoveable
_ca:setVisualChanged()return _ca end,show=function(_ca)dc.show(_ca)
if(
_ca.parent==nil)then cc.setActiveFrame(_ca)if(a_a)then
cc.setMonitorFrame(__a,_ca)else cc.setMainFrame(_ca)end end;return _ca end,hide=function(_ca)
dc.hide(_ca)
if(_ca.parent==nil)then if(activeFrame==_ca)then activeFrame=nil end;if(a_a)then
if(
cc.getMonitorFrame(__a)==_ca)then cc.setActiveFrame(nil)end else
if(cc.getMainFrame()==_ca)then cc.setMainFrame(nil)end end end;return _ca end,showBar=function(_ca,aca)_ca.barActive=
aca or not _ca.barActive
_ca:setVisualChanged()return _ca end,setBar=function(_ca,aca,bca,cca)
_ca.barText=aca or""_ca.barBackground=bca or _ca.barBackground
_ca.barTextcolor=cca or _ca.barTextcolor;_ca:setVisualChanged()return _ca end,setBarTextAlign=function(_ca,aca)_ca.barTextAlign=
aca or"left"_ca:setVisualChanged()return _ca end,setMonitor=function(_ca,aca)
if(
aca~=nil)and(aca~=false)then
if
(peripheral.getType(aca)=="monitor")then dd=peripheral.wrap(aca)b_a=true end;a_a=true else dd=parentTerminal;a_a=false;if(cc.getMonitorFrame(__a)==_ca)then cc.setMonitorFrame(__a,
nil)end end;_aa=_aa(dd)__a=aca or nil;return _ca end,getVisualChanged=function(_ca)
local aca=dc.getVisualChanged(_ca)
for bca,cca in pairs(bd)do if(ad[cca]~=nil)then
for dca,_da in pairs(ad[cca])do if(_da.getVisualChanged~=nil and
_da:getVisualChanged())then aca=true end end end end;return aca end,loseFocusHandler=function(_ca)
dc.loseFocusHandler(_ca)end,getFocusHandler=function(_ca)dc.getFocusHandler(_ca)
if(_ca.parent~=nil)then
_ca.parent:removeObject(_ca)_ca.parent:addObject(_ca)end end,keyHandler=function(_ca,aca,bca)
local cca=cc.getFocusedObject()
if(cca~=nil)then if(cca~=_ca)then if(cca.keyHandler~=nil)then
if(cca:keyHandler(aca,bca))then return true end end else
dc.keyHandler(_ca,aca,bca)end end;return false end,backgroundKeyHandler=function(_ca,aca,bca)
dc.backgroundKeyHandler(_ca,aca,bca)
for cca,dca in pairs(bd)do if(ad[dca]~=nil)then
for _da,ada in pairs(ad[dca])do if(ada.backgroundKeyHandler~=nil)then
ada:backgroundKeyHandler(aca,bca)end end end end end,eventHandler=function(_ca,aca,bca,cca,dca,_da)
dc.eventHandler(_ca,aca,bca,cca,dca,_da)
for ada,bda in pairs(bd)do if(ad[bda]~=nil)then
for cda,dda in pairs(ad[bda])do if(dda.eventHandler~=nil)then
dda:eventHandler(aca,bca,cca,dca,_da)end end end end
if(a_a)then if(aca=="peripheral")and(bca==__a)then
if
(peripheral.getType(__a)=="monitor")then b_a=true;dd=peripheral.wrap(__a)_aa=_aa(dd)end end
if(aca==
"peripheral_detach")and(bca==__a)then b_a=false end end
if(aca=="terminate")then dd.clear()dd.setCursorPos(1,1)cc.stop()end end,mouseHandler=function(_ca,aca,bca,cca,dca)
local _da,ada=_ca:getOffset()_da=_da<0 and math.abs(_da)or-_da;ada=ada<0 and
math.abs(ada)or-ada
if(_ca.drag)then
if(aca=="mouse_drag")then
local __b=1;local a_b=1;if(_ca.parent~=nil)then
__b,a_b=_ca.parent:getAbsolutePosition(_ca.parent:getAnchorPosition())end
_ca:setPosition(
cca+c_a- (__b-1)+_da,dca+d_a- (a_b-1)+ada)end;if(aca=="mouse_up")then _ca.drag=false end;return true end
local bda,cda=_ca:getAbsolutePosition(_ca:getAnchorPosition())local dda=false;if(cda-1 ==dca)and(_ca:getBorder("top"))then dca=dca+1
dda=true end
if(dc.mouseHandler(_ca,aca,bca,cca,dca))then
local __b,a_b=_ca:getAbsolutePosition(_ca:getAnchorPosition())__b=__b+_ba;a_b=a_b+aba
for b_b,c_b in pairs(bd)do
if(ad[c_b]~=nil)then for d_b,_ab in cb(ad[c_b])do
if
(_ab.mouseHandler~=nil)then if(_ab:mouseHandler(aca,bca,cca,dca))then return true end end end end end
if(_ca.isMoveable)then
local b_b,c_b=_ca:getAbsolutePosition(_ca:getAnchorPosition())
if
(cca>=b_b)and(cca<=b_b+_ca.width-1)and(dca==c_b)and(aca=="mouse_click")then _ca.drag=true
c_a=b_b-cca;d_a=dda and 1 or 0 end end
if(cc.getFocusedObject()~=nil)then
cc.getFocusedObject():loseFocusHandler()cc.setFocusedObject(nil)end;return true end;return false end,setText=function(_ca,aca,bca,cca)
local dca,_da=_ca:getAbsolutePosition(_ca:getAnchorPosition())
if(bca>=1)and(bca<=_ca.height)then
if(_ca.parent~=nil)then
local ada,bda=_ca.parent:getAnchorPosition()
_ca.parent:setText(math.max(aca+ (dca-1),dca)- (ada-1),
_da+bca-1 - (bda-1),db(cca,math.max(1 -aca+1,1),math.max(_ca.width-aca+1,1)))else
_aa.setText(math.max(aca+ (dca-1),dca),_da+bca-1,db(cca,math.max(1 -aca+1,1),math.max(
_ca.width-aca+1,1)))end end end,setBG=function(_ca,aca,bca,cca)
local dca,_da=_ca:getAbsolutePosition(_ca:getAnchorPosition())
if(bca>=1)and(bca<=_ca.height)then
if(_ca.parent~=nil)then
local ada,bda=_ca.parent:getAnchorPosition()
_ca.parent:setBG(math.max(aca+ (dca-1),dca)- (ada-1),
_da+bca-1 - (bda-1),db(cca,math.max(1 -aca+1,1),math.max(_ca.width-aca+1,1)))else
_aa.setBG(math.max(aca+ (dca-1),dca),_da+bca-1,db(cca,math.max(1 -aca+1,1),math.max(
_ca.width-aca+1,1)))end end end,setFG=function(_ca,aca,bca,cca)
local dca,_da=_ca:getAbsolutePosition(_ca:getAnchorPosition())
if(bca>=1)and(bca<=_ca.height)then
if(_ca.parent~=nil)then
local ada,bda=_ca.parent:getAnchorPosition()
_ca.parent:setFG(math.max(aca+ (dca-1),dca)- (ada-1),
_da+bca-1 - (bda-1),db(cca,math.max(1 -aca+1,1),math.max(_ca.width-aca+1,1)))else
_aa.setFG(math.max(aca+ (dca-1),dca),_da+bca-1,db(cca,math.max(1 -aca+1,1),math.max(
_ca.width-aca+1,1)))end end end,writeText=function(_ca,aca,bca,cca,dca,_da)
local ada,bda=_ca:getAbsolutePosition(_ca:getAnchorPosition())
if(bca>=1)and(bca<=_ca.height)then
if(_ca.parent~=nil)then
local cda,dda=_ca.parent:getAnchorPosition()
_ca.parent:writeText(math.max(aca+ (ada-1),ada)- (cda-1),bda+
bca-1 - (dda-1),db(cca,math.max(1 -aca+1,1),_ca.width-aca+1),dca,_da)else
_aa.writeText(math.max(aca+ (ada-1),ada),bda+bca-1,db(cca,math.max(1 -aca+1,1),math.max(
_ca.width-aca+1,1)),dca,_da)end end end,drawBackgroundBox=function(_ca,aca,bca,cca,dca,_da)
local ada,bda=_ca:getAbsolutePosition(_ca:getAnchorPosition())
dca=(bca<1 and
(dca+bca>_ca.height and _ca.height or dca+bca-1)or(
dca+bca>_ca.height and _ca.height-bca+1 or dca))
cca=(aca<1 and
(cca+aca>_ca.width and _ca.width or cca+aca-1)or(
cca+aca>_ca.width and _ca.width-aca+1 or cca))
if(_ca.parent~=nil)then local cda,dda=_ca.parent:getAnchorPosition()
_ca.parent:drawBackgroundBox(math.max(
aca+ (ada-1),ada)- (cda-1),
math.max(bca+ (bda-1),bda)- (dda-1),cca,dca,_da)else
_aa.drawBackgroundBox(math.max(aca+ (ada-1),ada),math.max(bca+ (bda-1),bda),cca,dca,_da)end end,drawTextBox=function(_ca,aca,bca,cca,dca,_da)
local ada,bda=_ca:getAbsolutePosition(_ca:getAnchorPosition())
dca=(bca<1 and
(dca+bca>_ca.height and _ca.height or dca+bca-1)or(
dca+bca>_ca.height and _ca.height-bca+1 or dca))
cca=(aca<1 and
(cca+aca>_ca.width and _ca.width or cca+aca-1)or(
cca+aca>_ca.width and _ca.width-aca+1 or cca))
if(_ca.parent~=nil)then local cda,dda=_ca.parent:getAnchorPosition()
_ca.parent:drawTextBox(math.max(
aca+ (ada-1),ada)- (cda-1),
math.max(bca+ (bda-1),bda)- (dda-1),cca,dca,_da:sub(1,1))else
_aa.drawTextBox(math.max(aca+ (ada-1),ada),math.max(bca+ (bda-1),bda),cca,dca,_da:sub(1,1))end end,drawForegroundBox=function(_ca,aca,bca,cca,dca,_da)
local ada,bda=_ca:getAbsolutePosition(_ca:getAnchorPosition())
dca=(bca<1 and
(dca+bca>_ca.height and _ca.height or dca+bca-1)or(
dca+bca>_ca.height and _ca.height-bca+1 or dca))
cca=(aca<1 and
(cca+aca>_ca.width and _ca.width or cca+aca-1)or(
cca+aca>_ca.width and _ca.width-aca+1 or cca))
if(_ca.parent~=nil)then local cda,dda=_ca.parent:getAnchorPosition()
_ca.parent:drawForegroundBox(math.max(
aca+ (ada-1),ada)- (cda-1),
math.max(bca+ (bda-1),bda)- (dda-1),cca,dca,_da)else
_aa.drawForegroundBox(math.max(aca+ (ada-1),ada),math.max(bca+ (bda-1),bda),cca,dca,_da)end end,draw=function(_ca)if
(a_a)and not(b_a)then return false end
if(_ca:getVisualChanged())then
if
(dc.draw(_ca))then
local aca,bca=_ca:getAbsolutePosition(_ca:getAnchorPosition())local cca,dca=_ca:getAnchorPosition()
if(_ca.parent~=nil)then
if
(_ca.bgColor~=false)then
_ca.parent:drawBackgroundBox(cca,dca,_ca.width,_ca.height,_ca.bgColor)
_ca.parent:drawTextBox(cca,dca,_ca.width,_ca.height," ")end;if(_ca.bgColor~=false)then
_ca.parent:drawForegroundBox(cca,dca,_ca.width,_ca.height,_ca.fgColor)end else
if(_ca.bgColor~=false)then
_aa.drawBackgroundBox(aca,bca,_ca.width,_ca.height,_ca.bgColor)_aa.drawTextBox(aca,bca,_ca.width,_ca.height," ")end;if(_ca.fgColor~=false)then
_aa.drawForegroundBox(aca,bca,_ca.width,_ca.height,_ca.fgColor)end end;dd.setCursorBlink(false)
if(_ca.barActive)then
if(_ca.parent~=nil)then
_ca.parent:writeText(cca,dca,bb.getTextHorizontalAlign(_ca.barText,_ca.width,_ca.barTextAlign),_ca.barBackground,_ca.barTextcolor)else
_aa.writeText(aca,bca,bb.getTextHorizontalAlign(_ca.barText,_ca.width,_ca.barTextAlign),_ca.barBackground,_ca.barTextcolor)end
if(_ca:getBorder("left"))then
if(_ca.parent~=nil)then
_ca.parent:drawBackgroundBox(cca-1,dca,1,1,_ca.barBackground)if(_ca.bgColor~=false)then
_ca.parent:drawBackgroundBox(cca-1,dca+1,1,_ca.height-1,_ca.bgColor)end end end
if(_ca:getBorder("top"))then if(_ca.parent~=nil)then
_ca.parent:drawBackgroundBox(cca-1,dca-1,_ca.width+1,1,_ca.barBackground)end end end;for _da,ada in cb(bd)do
if(ad[ada]~=nil)then for bda,cda in pairs(ad[ada])do
if(cda.draw~=nil)then cda:draw()end end end end;if(aaa)then
dd.setTextColor(daa)dd.setCursorPos(baa,caa)
if(_ca.parent~=nil)then
dd.setCursorBlink(_ca:isFocused())else dd.setCursorBlink(aaa)end end
_ca:setVisualChanged(false)end end end,drawUpdate=function(_ca)if
(a_a)and not(b_a)then return false end;_aa.update()end,addObject=function(_ca,aca)return
cba(aca)end,removeObject=function(_ca,aca)return dba(aca)end,getObject=function(_ca,aca)return bba(aca)end,addFrame=function(_ca,aca)local bca=cc.newFrame(aca,_ca,
nil,cc)return cba(bca)end}for _ca,aca in pairs(da)do
cd["add".._ca]=function(bca,cca)return cba(aca(cca,bca))end end;setmetatable(cd,dc)
return cd end
end; 
project['default']['loadObjects'] = function(...)local b={}if(packaged)then
for c,d in pairs(getProject("objects"))do b[c]=d()end;return b end;for c,d in
pairs(fs.list(fs.combine("Basalt","objects")))do
if(d~="example.lua")then local _a=d:gsub(".lua","")b[_a]=require(_a)end end;return b
end; 
project['default']['Object'] = function(...)local b=require("basaltEvent")
return
function(c)local d="Object"local _a;local aa=1;local ba="topLeft"
local ca=false;local da=false;local _b=false;local ab=false;local bb=false;local cb=false;local db=false
local _c=colors.black;local ac=colors.black;local bc=true;local cc=b()
local dc={x=1,y=1,width=1,height=1,bgColor=colors.black,fgColor=colors.white,name=c or"Object",parent=nil,show=function(_d)da=true
bc=true;return _d end,hide=function(_d)da=false;bc=true;return _d end,isVisible=function(_d)return da end,setFocus=function(_d)
if(
_d.parent~=nil)then _d.parent:setFocusedObject(_d)end;return _d end,setZIndex=function(_d,ad)aa=ad
if(_d.parent~=nil)then
_d.parent:removeObject(_d)_d.parent:addObject(_d)end;return _d end,getZIndex=function(_d)return aa end,getType=function(_d)return
d end,getName=function(_d)return _d.name end,remove=function(_d)if(_d.parent~=nil)then
_d.parent:removeObject(_d)end;return _d end,setParent=function(_d,ad)
if(
ad.getType~=nil and ad:getType()=="Frame")then _d:remove()
ad:addObject(_d)if(_d.draw)then _d:show()end end;return _d end,setValue=function(_d,ad)
if(
_a~=ad)then _a=ad;bc=true;_d:valueChangedHandler()end;return _d end,getValue=function(_d)return _a end,getVisualChanged=function(_d)return bc end,setVisualChanged=function(_d,ad)bc=
ad or true;if(ad==nil)then bc=true end;return _d end,getEventSystem=function(_d)return
cc end,getParent=function(_d)return _d.parent end,setPosition=function(_d,ad,bd,cd)if(cd)then _d.x,_d.y=math.floor(_d.x+ad),math.floor(
_d.y+bd)else
_d.x,_d.y=math.floor(ad),math.floor(bd)end;bc=true;return _d end,getPosition=function(_d)return
_d.x,_d.y end,getVisibility=function(_d)return da end,setVisibility=function(_d,ad)da=ad or not da;bc=true
return _d end,setSize=function(_d,ad,bd)_d.width,_d.height=ad,bd
cc:sendEvent("basalt_resize",_d)bc=true;return _d end,getHeight=function(_d)return _d.height end,getWidth=function(_d)return
_d.width end,getSize=function(_d)return _d.width,_d.height end,setBackground=function(_d,ad)
_d.bgColor=ad;bc=true;return _d end,getBackground=function(_d)return _d.bgColor end,setForeground=function(_d,ad)
_d.fgColor=ad;bc=true;return _d end,getForeground=function(_d)return _d.fgColor end,showShadow=function(_d,ad)_b=ad or
(not _b)return _d end,setShadow=function(_d,ad)_c=ad;return _d end,isShadowActive=function(_d)
return _b end,showBorder=function(_d,...)
for ad,bd in pairs(table.pack(...))do if(bd=="left")then ab=true end;if(
bd=="top")then bb=true end;if(bd=="right")then cb=true end;if(bd=="bottom")then
db=true end end;return _d end,setBorder=function(_d,ad)
_c=ad;return _d end,getBorder=function(_d,ad)if(ad=="left")then return ab end
if(ad=="top")then return bb end;if(ad=="right")then return cb end;if(ad=="bottom")then return db end end,draw=function(_d)
if
(da)then
if(_d.parent~=nil)then local ad,bd=_d:getAnchorPosition()
if(_b)then
_d.parent:drawBackgroundBox(
ad+1,bd+_d.height,_d.width,1,_c)
_d.parent:drawBackgroundBox(ad+_d.width,bd+1,1,_d.height,_c)
_d.parent:drawForegroundBox(ad+1,bd+_d.height,_d.width,1,_c)
_d.parent:drawForegroundBox(ad+_d.width,bd+1,1,_d.height,_c)end
if(ab)then
_d.parent:drawTextBox(ad-1,bd,1,_d.height,"\149")
_d.parent:drawForegroundBox(ad-1,bd,1,_d.height,ac)if(_d.bgColor~=false)then
_d.parent:drawBackgroundBox(ad-1,bd,1,_d.height,_d.bgColor)end end
if(ab)and(bb)then
_d.parent:drawTextBox(ad-1,bd-1,1,1,"\151")_d.parent:drawForegroundBox(ad-1,bd-1,1,1,ac)if(
_d.bgColor~=false)then
_d.parent:drawBackgroundBox(ad-1,bd-1,1,1,_d.bgColor)end end
if(bb)then
_d.parent:drawTextBox(ad,bd-1,_d.width,1,"\131")
_d.parent:drawForegroundBox(ad,bd-1,_d.width,1,ac)if(_d.bgColor~=false)then
_d.parent:drawBackgroundBox(ad,bd-1,_d.width,1,_d.bgColor)end end;if(bb)and(cb)then
_d.parent:drawTextBox(ad+_d.width,bd-1,1,1,"\149")
_d.parent:drawForegroundBox(ad+_d.width,bd-1,1,1,ac)end;if(cb)then
_d.parent:drawTextBox(
ad+_d.width,bd,1,_d.height,"\149")
_d.parent:drawForegroundBox(ad+_d.width,bd,1,_d.height,ac)end;if(cb)and(db)then
_d.parent:drawTextBox(
ad+_d.width,bd+_d.height,1,1,"\129")
_d.parent:drawForegroundBox(ad+_d.width,bd+_d.height,1,1,ac)end;if(db)then
_d.parent:drawTextBox(ad,
bd+_d.height,_d.width,1,"\131")
_d.parent:drawForegroundBox(ad,bd+_d.height,_d.width,1,ac)end
if(db)and(ab)then _d.parent:drawTextBox(
ad-1,bd+_d.height,1,1,"\131")_d.parent:drawForegroundBox(
ad-1,bd+_d.height,1,1,ac)end end;return true end;return false end,getAbsolutePosition=function(_d,ad,bd)
if(
ad==nil)or(bd==nil)then ad,bd=_d:getAnchorPosition()end
if(_d.parent~=nil)then
local cd,dd=_d.parent:getAbsolutePosition(_d.parent:getAnchorPosition())ad=cd+ad-1;bd=dd+bd-1 end;return ad,bd end,getAnchorPosition=function(_d,ad,bd,cd)if(
ad==nil)then ad=_d.x end;if(bd==nil)then bd=_d.y end
if(ba=="top")then
ad=math.floor(
_d.parent.width/2)+ad-1 elseif(ba=="topRight")then ad=_d.parent.width+ad-1 elseif(ba=="right")then ad=
_d.parent.width+ad-1;bd=
math.floor(_d.parent.height/2)+bd-1 elseif(ba=="bottomRight")then ad=
_d.parent.width+ad-1
bd=_d.parent.height+bd-1 elseif(ba=="bottom")then
ad=math.floor(_d.parent.width/2)+ad-1;bd=_d.parent.height+bd-1 elseif(ba=="bottomLeft")then bd=
_d.parent.height+bd-1 elseif(ba=="left")then bd=
math.floor(_d.parent.height/2)+bd-1 elseif(ba=="center")then
ad=math.floor(
_d.parent.width/2)+ad-1
bd=math.floor(_d.parent.height/2)+bd-1 end
if(_d.parent~=nil)then local dd,__a=_d.parent:getOffset()if not(ca or cd)then return
ad+dd,bd+__a end end;return ad,bd end,ignoreOffset=function(_d,ad)
ca=ad;if(ad==nil)then ca=true end;return _d end,getBaseFrame=function(_d)if
(_d.parent~=nil)then return _d.parent:getBaseFrame()end
return _d end,setAnchor=function(_d,ad)ba=ad;bc=true;return _d end,getAnchor=function(_d)return
ba end,onChange=function(_d,...)
for ad,bd in pairs(table.pack(...))do if(type(bd)=="function")then
_d:registerEvent("value_changed",bd)end end;return _d end,onClick=function(_d,...)
for ad,bd in
pairs(table.pack(...))do if(type(bd)=="function")then _d:registerEvent("mouse_click",bd)
_d:registerEvent("monitor_touch",bd)end end;return _d end,onClickUp=function(_d,...)for ad,bd in
pairs(table.pack(...))do
if(type(bd)=="function")then _d:registerEvent("mouse_up",bd)end end;return _d end,onScroll=function(_d,...)for ad,bd in
pairs(table.pack(...))do
if(type(bd)=="function")then _d:registerEvent("mouse_scroll",bd)end end;return _d end,onDrag=function(_d,...)for ad,bd in
pairs(table.pack(...))do
if(type(bd)=="function")then _d:registerEvent("mouse_drag",bd)end end;return _d end,onEvent=function(_d,...)
for ad,bd in
pairs(table.pack(...))do if(type(bd)=="function")then
_d:registerEvent("custom_event_handler",bd)end end;return _d end,onKey=function(_d,...)
for ad,bd in
pairs(table.pack(...))do if(type(bd)=="function")then _d:registerEvent("key",bd)
_d:registerEvent("char",bd)end end;return _d end,onResize=function(_d,...)
for ad,bd in
pairs(table.pack(...))do if(type(bd)=="function")then
_d:registerEvent("basalt_resize",bd)end end;return _d end,onKeyUp=function(_d,...)for ad,bd in
pairs(table.pack(...))do
if(type(bd)=="function")then _d:registerEvent("key_up",bd)end end;return _d end,onBackgroundKey=function(_d,...)for ad,bd in
pairs(table.pack(...))do
if(type(bd)=="function")then
_d:registerEvent("background_key",bd)_d:registerEvent("background_char",bd)end end;return
_d end,onBackgroundKeyUp=function(_d,...)
for ad,bd in
pairs(table.pack(...))do if(type(bd)=="function")then
_d:registerEvent("background_key_up",bd)end end;return _d end,isFocused=function(_d)if(
_d.parent~=nil)then
return _d.parent:getFocusedObject()==_d end;return false end,onGetFocus=function(_d,...)for ad,bd in
pairs(table.pack(...))do
if(type(bd)=="function")then _d:registerEvent("get_focus",bd)end end;return _d end,onLoseFocus=function(_d,...)for ad,bd in
pairs(table.pack(...))do
if(type(bd)=="function")then _d:registerEvent("lose_focus",bd)end end;return _d end,registerEvent=function(_d,ad,bd)return
cc:registerEvent(ad,bd)end,removeEvent=function(_d,ad,bd)return cc:removeEvent(ad,bd)end,sendEvent=function(_d,ad,...)return
cc:sendEvent(ad,_d,...)end,mouseHandler=function(_d,ad,bd,cd,dd)
local __a,a_a=_d:getAbsolutePosition(_d:getAnchorPosition())local b_a=false
if(a_a-1 ==dd)and(_d:getBorder("top"))then dd=dd+1;b_a=true end
if
(__a<=cd)and(__a+_d.width>cd)and(a_a<=dd)and(a_a+
_d.height>dd)and(da)then
if(_d.parent~=nil)then _d.parent:setFocusedObject(_d)end;local c_a=cc:sendEvent(ad,_d,ad,bd,cd,dd)
if(c_a~=nil)then return c_a end;return true end;return false end,keyHandler=function(_d,ad,bd)
if
(_d:isFocused())then local cd=cc:sendEvent(ad,_d,ad,bd)if(cd~=nil)then return cd end;return true end;return false end,backgroundKeyHandler=function(_d,ad,bd)local cd=cc:sendEvent(
"background_"..ad,_d,ad,bd)
if(cd~=nil)then return cd end;return true end,valueChangedHandler=function(_d)
cc:sendEvent("value_changed",_d)end,eventHandler=function(_d,ad,bd,cd,dd,__a)
cc:sendEvent("custom_event_handler",_d,ad,bd,cd,dd,__a)end,getFocusHandler=function(_d)
local ad=cc:sendEvent("get_focus",_d)if(ad~=nil)then return ad end;return true end,loseFocusHandler=function(_d)
local ad=cc:sendEvent("lose_focus",_d)if(ad~=nil)then return ad end;return true end}dc.__index=dc;return dc end
end; 
project['default']['theme'] = function(...)
return
{basaltBG=colors.lightGray,basaltFG=colors.black,FrameBG=colors.gray,FrameFG=colors.black,ButtonBG=colors.gray,ButtonFG=colors.black,CheckboxBG=colors.gray,CheckboxFG=colors.black,InputBG=colors.gray,InputFG=colors.black,textfieldBG=colors.gray,textfieldFG=colors.black,listBG=colors.gray,listFG=colors.black,dropdownBG=colors.gray,dropdownFG=colors.black,radioBG=colors.gray,radioFG=colors.black,selectionBG=colors.black,selectionFG=colors.lightGray}
end; 
local dc=require("basaltEvent")()
local _d=require("Frame")local ad=term.current()local bd=1.1;local cd=true
local dd=fs.getDir(table.pack(...)[2]or"")local __a,a_a,b_a={},{},{}local c_a,d_a,_aa,aaa;local function baa()aaa=false end
local caa={getMainFrame=function()return c_a end,setMainFrame=function(bba)
c_a=bba end,getActiveFrame=function()return d_a end,setActiveFrame=function(bba)d_a=bba end,getFocusedObject=function()return _aa end,setFocusedObject=function(bba)_aa=bba end,getMonitorFrame=function(bba)return
b_a[bba]end,setMonitorFrame=function(bba,cba)b_a[bba]=cba end,getBaseTerm=function()return ad end,stop=baa,newFrame=_d,getDirectory=function()
return dd end}
local function daa()c_a:draw()c_a:drawUpdate()for bba,cba in pairs(b_a)do cba:draw()
cba:drawUpdate()end end
local function _ba(bba,cba,dba,_ca,aca)if
(dc:sendEvent("basaltEventCycle",bba,cba,dba,_ca,aca)==false)then return end
if(c_a~=nil)then
if(bba=="mouse_click")then
c_a:mouseHandler(bba,cba,dba,_ca,aca)d_a=c_a elseif(bba=="mouse_drag")then
c_a:mouseHandler(bba,cba,dba,_ca,aca)d_a=c_a elseif(bba=="mouse_up")then
c_a:mouseHandler(bba,cba,dba,_ca,aca)d_a=c_a elseif(bba=="mouse_scroll")then
c_a:mouseHandler(bba,cba,dba,_ca,aca)d_a=c_a elseif(bba=="monitor_touch")then if(b_a[cba]~=nil)then
b_a[cba]:mouseHandler(bba,cba,dba,_ca,aca)d_a=b_a[cba]end end end;if(bba=="key")or(bba=="char")then d_a:keyHandler(bba,cba)
d_a:backgroundKeyHandler(bba,cba)end
if(bba=="key")then __a[cba]=true end;if(bba=="key_up")then __a[cba]=false end;for bca,cca in pairs(a_a)do
cca:eventHandler(bba,cba,dba,_ca,aca)end;daa()end;local aba={}
aba={setBaseTerm=function(bba)ad=bba end,autoUpdate=function(bba)aaa=bba;if(bba==nil)then aaa=true end;daa()while aaa do
local cba,dba,_ca,aca,bca=os.pullEventRaw()_ba(cba,dba,_ca,aca,bca)end end,update=function(bba,cba,dba,_ca,aca)if(
bba~=nil)then _ba(bba,cba,dba,_ca,aca)end end,stop=baa,isKeyDown=function(bba)if(
__a[bba]==nil)then return false end;return __a[bba]end,getFrame=function(bba)for cba,dba in
pairs(a_a)do if(dba.name==bba)then return dba end end end,getActiveFrame=function()return
d_a end,setActiveFrame=function(bba)
if(bba:getType()=="Frame")then d_a=bba;return true end;return false end,onEvent=function(...)
for bba,cba in
pairs(table.pack(...))do if(type(cba)=="function")then
dc:registerEvent("basaltEventCycle",cba)end end end,createFrame=function(bba)for dba,_ca in
pairs(a_a)do if(_ca.name==bba)then return nil end end;local cba=_d(bba,
nil,nil,caa)table.insert(a_a,cba)return cba end,removeFrame=function(bba)a_a[bba]=
nil end,setProjectDir=function(bba)dd=bba end}

-- Basalt installer beginns here:
local basalt = aba
local projectDir = "Basalt"

local animTime = 0.2
local animFrames = 8

local function download(url, file)
local httpReq = http.get(url, _G._GIT_API_KEY and {Authorization = "token ".._G._GIT_API_KEY})
    if(httpReq~=nil)then
    local content = httpReq.readAll()
        if not content then
        error("Could not connect to website")
        end
        local f = fs.open(file, "w")
        f.write(content)
        f.close()
    end
end

local function createTree(page)
local tree = {}
    local request = http.get(page, _G._GIT_API_KEY and {Authorization = "token ".._G._GIT_API_KEY})
    if not(request)then return end
    for k,v in pairs(textutils.unserialiseJSON(request.readAll()).tree)do
        if(v.type=="blob")then
            table.insert(tree, v.path)
        elseif(v.type=="tree")then
            tree[v.path] = createTree(page.."/"..v.path)
        end
    end
    return tree
end

local projectFiles = {base={}}

local w, h = term.getSize()
local main = basalt.createFrame("InstallerFrame"):show()
local anim = main:addAnimation("movingFrameAnimation")
local libFrame = main:addFrame("LibraryFrame"):setBackground(colors.lightGray):setForeground(colors.black):show()
local objFrame = main:addFrame("ObjectFrame"):setBackground(colors.lightGray):setForeground(colors.black):setPosition(w+1,1):show()
local configFrame = main:addFrame("ConfigFrame"):setBackground(colors.lightGray):setForeground(colors.black):setPosition(w+w+1,1):show()
local installFrame = main:addFrame("installFrame"):setBackground(colors.lightGray):setForeground(colors.black):setPosition(w+w+w+1,1):show()

local fileTreeInfo = main:addLabel("getFileTree"):setText("Downloading file structure..."):setForeground(colors.red):ignoreOffset():setAnchor("bottomLeft"):setPosition(2,1):setZIndex(15):show()

libFrame:addLabel("setupMessage"):setText("Basalt Libary List:"):setPosition(2, 1):show()
libFrame:addLabel("included"):setText("Included"):setPosition(2, 3):show()
local libInc = libFrame:addList("includedLibList"):setPosition(2,4):setSize(20,11):show()
local libExc = libFrame:addList("exludedLibList"):setPosition(31,4):setSize(20,11):show()
libFrame:addLabel("excluded"):setText("Excluded"):setPosition(43, 3):show()
libFrame:addButton("excludeItem"):setPosition(25,5):setSize(3,1):setText(">"):onClick(function()
    local item = libInc:getItem(libInc:getItemIndex())
    if(item~=nil)then
        libInc:removeItem(libInc:getItemIndex())
        libExc:addItem(item.text)
    end
end):show()
libFrame:addButton("includeItem"):setSize(3,1):setText("<"):setPosition(25,7):onClick(function()
    local item = libExc:getItem(libExc:getItemIndex())
    if(item~=nil)then
        libExc:removeItem(libExc:getItemIndex())
        libInc:addItem(item.text)
    end
end):show()
libFrame:addButton("includeItems"):setSize(5,1):setText("<<<"):setPosition(24,10):onClick(function()
    local item = libExc:getItem(libExc:getItemIndex())
    if(item~=nil)then
        libExc:removeItem(libExc:getItemIndex())
        libInc:addItem(item.text)
    end
end):show()
libFrame:addButton("excludeItems"):setSize(5,1):setText(">>>"):setPosition(24,12):onClick(function()
    local item = libExc:getItem(libExc:getItemIndex())
    if(item~=nil)then
        libExc:removeItem(libExc:getItemIndex())
        libInc:addItem(item.text)
    end
end):show()
libFrame:addButton("nextBtn"):setAnchor("bottomRight"):setPosition(-11,-2):setSize(10,3):setText("Next"):onClick(function()
    anim:clear():setObject(main):offset(w,0,animTime,animFrames):play()
end):show()

objFrame:addLabel("setupMessage"):setText("Basalt Object List:"):setPosition(2, 1):show()
objFrame:addLabel("included"):setText("Included"):setPosition(2, 3):show()
local objInc = objFrame:addList("includedObjList"):setPosition(2,4):setSize(20,11):show()

local objExc = objFrame:addList("exludedObjList"):setPosition(31,4):setSize(20,11):show()
objFrame:addLabel("excluded"):setText("Excluded"):setPosition(43, 3):show()

objFrame:addButton("excludeItem"):setPosition(25,5):setSize(3,1):setText(">"):onClick(function()
    local item = objInc:getItem(objInc:getItemIndex())
    if(item~=nil)then
        objInc:removeItem(objInc:getItemIndex())
        objExc:addItem(item.text)
    end
end):show()
objFrame:addButton("includeItem"):setSize(3,1):setText("<"):setPosition(25,7):onClick(function()
    local item = objExc:getItem(objExc:getItemIndex())
    if(item~=nil)then
        objExc:removeItem(objExc:getItemIndex())
        objInc:addItem(item.text)
    end
end):show()

objFrame:addButton("includeItems"):setSize(5,1):setText("<<<"):setPosition(24,10):onClick(function()
    local item = libExc:getItem(libExc:getItemIndex())
    if(item~=nil)then
        libExc:removeItem(libExc:getItemIndex())
        libInc:addItem(item.text)
    end
end):show()

objFrame:addButton("excludeItems"):setSize(5,1):setText(">>>"):setPosition(24,12):onClick(function()
    local item = libExc:getItem(libExc:getItemIndex())
    if(item~=nil)then
        libExc:removeItem(libExc:getItemIndex())
        libInc:addItem(item.text)
    end
end):show()

objFrame:addButton("nextBtn"):setAnchor("bottomRight"):setPosition(-11,-2):setSize(10,3):setText("Next"):onClick(function()
    anim:clear():setObject(main):offset(w*2,0,animTime,animFrames):play()
end):show()
objFrame:addButton("backBtn"):setAnchor("bottomLeft"):setPosition(2,-2):setSize(10,3):setText("Back"):onClick(function()
    anim:clear():setObject(main):offset(0,0,animTime,animFrames):play()
end):show()

configFrame:addButton("backBtn"):setAnchor("bottomLeft"):setPosition(2,-2):setSize(10,3):setText("Back"):onClick(function()
    anim:clear():setObject(main):offset(w,0,animTime,animFrames):play()
end):show()


configFrame:addLabel("configInfo"):setPosition(2,2):setText("Setup the configuration:"):show()
local sOrM = configFrame:addRadio("singleOrMultiFile"):setPosition(2,4):addItem("Single file project",1,1,colors.lightGray,colors.black,true):addItem("Multiple files project",1,3,colors.lightGray,colors.black,false):setSelectedItem(colors.lightGray,colors.black):show()
local minProject = configFrame:addCheckbox("minify"):setPosition(2,8):show()
configFrame:addLabel("minifyInfo"):setPosition(4,8):setText("Minify the project"):show()
configFrame:addLabel("betaInfo"):setPosition(2,11):setText("The Basalt Package Manager is still in alpha!"):setForeground(colors.red):show()
configFrame:addLabel("discord"):setPosition(2,12):setText("Checkout discord.com/invite/yNNnmBVBpE if you get"):setForeground(colors.red):show()
configFrame:addLabel("discord2"):setPosition(2,13):setText("into errors."):setForeground(colors.red):show()

installFrame:addLabel("installingInfo"):setPosition(2,2):setText("Installing Menu:"):show()
local state = installFrame:addLabel("installStatus"):setAnchor("bottomLeft"):setPosition(2,-1):setText("Currently installing..."):show()
local installLog = installFrame:addList("installLog"):setPosition(2,4):setSize(w-2, 11):show()
local doneButton = installFrame:addButton("doneButton"):setText("Done"):setAnchor("bottomRight"):setPosition(-13,-2):setSize(12, 3):onClick(function()
    basalt.stop()
    term.clear()
end)
installLog:addItem("Installing Basalt...")

local function addToInstallLog(text)
    installLog:addItem(text)
    installLog:setValue(installLog:getItem(installLog:getItemCount()))
    if(installLog.getItemCount() > installLog:getHeight())then
        installLog:setIndexOffset(installLog:getItemCount() - installLog:getHeight())
    end
end

local installThread = installFrame:addThread("installingThread")
local function installProject()
    fs.makeDir(projectDir)
    fs.makeDir(projectDir.."/objects")
    fs.makeDir(projectDir.."/libraries")
    for _,v in pairs(libInc:getAll())do
        download("https://raw.githubusercontent.com/Pyroxenium/Basalt/master/Basalt/libraries/"..v.text, projectDir.."/libraries/"..v.text)
        addToInstallLog("Installed: "..projectDir.."/libraries/"..v.text)
    end
    for _,v in pairs(objInc:getAll())do
        download("https://raw.githubusercontent.com/Pyroxenium/Basalt/master/Basalt/objects/"..v.text, projectDir.."/objects/"..v.text)
        addToInstallLog("Installed: "..projectDir.."/objects/"..v.text)
    end
    for _,v in pairs(projectFiles.base)do        
        download("https://raw.githubusercontent.com/Pyroxenium/Basalt/master/Basalt/"..v, projectDir.."/"..v)
        addToInstallLog("Installed: "..projectDir.."/"..v)
    end
    addToInstallLog("Finished downloading!")
    if(sOrM:getValue().args[1])then
        if(minProject:getValue())then
            addToInstallLog("Packaging and minifying project to a single file...")
        else
            addToInstallLog("Packaging project to a single file...")
        end
        download("https://raw.githubusercontent.com/Pyroxenium/Basalt/master/basaltPackager.lua", "basaltPackager.lua")
        shell.run("basaltPackager.lua "..projectDir.." "..tostring(minProject:getValue()))
        fs.delete("basaltPackager.lua")
        fs.delete("Basalt")
    end
    addToInstallLog("Done!")
    state:setText("Finished installing!")
    doneButton:show()
end

local installBtn = configFrame:addButton("installBtn"):setAnchor("bottomRight"):setPosition(-11,-2):setSize(11,3):setText("Install"):onClick(function()
    installLog:addItem("Creating directory: "..projectDir)
    anim:clear():setObject(main):offset(w*3,0,animTime,animFrames):play()
    installThread:start(installProject)
end)


local function getProjectFileTree()
    local projTree = createTree("https://api.github.com/repos/Pyroxenium/Basalt/git/trees/master:Basalt")
    if(projTree~=nil)then
        for k,v in pairs(projTree)do
            if(k=="objects")then
                projectFiles.objects = v
            elseif(k=="libraries")then
                projectFiles.libraries = v
            else
                table.insert(projectFiles.base, v)
            end
        end
        for _,v in pairs(projectFiles.libraries)do
            libInc:addItem(v)
        end
        for _,v in pairs(projectFiles.objects)do
            objInc:addItem(v)
        end
        fileTreeInfo:hide()
        installBtn:show()
    else
        fileTreeInfo:setText("Error: Unable to download file structure...")
    end
end
main:addThread("fileTreeThread"):start(getProjectFileTree)

basalt.autoUpdate()
