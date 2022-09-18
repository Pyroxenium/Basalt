-- The minify part is fully made by stravant and can be found here: https://github.com/stravant/LuaMinify/blob/master/RobloxPlugin/Minify.lua
-- Thanks to him for his awesome work!
--
--
-- A compilation of all of the neccesary code to Minify a source file, all into one single
-- script for usage on Roblox. Needed to deal with Roblox' lack of `require`.
--
function lookupify(cd)for dd,__a in pairs(cd)do cd[__a]=true end;return cd end
function CountTable(cd)local dd=0;for __a in pairs(cd)do dd=dd+1 end;return dd end
function PrintTable(cd,dd)if cd.Print then return cd.Print()end;dd=dd or 0
local __a=(CountTable(cd)>1)local a_a=string.rep('    ',dd+1)
local b_a="{".. (__a and'\n'or'')
for c_a,d_a in pairs(cd)do
if type(d_a)~='function'then
b_a=b_a.. (__a and a_a or'')
if type(c_a)=='number'then elseif type(c_a)=='string'and
c_a:match("^[A-Za-z_][A-Za-z0-9_]*$")then b_a=b_a..c_a.." = "elseif
type(c_a)=='string'then b_a=b_a.."[\""..c_a.."\"] = "else b_a=b_a.."["..
tostring(c_a).."] = "end
if type(d_a)=='string'then b_a=b_a.."\""..d_a.."\""elseif type(d_a)==
'number'then b_a=b_a..d_a elseif type(d_a)=='table'then b_a=b_a..
PrintTable(d_a,dd+ (__a and 1 or 0))else
b_a=b_a..tostring(d_a)end;if next(cd,c_a)then b_a=b_a..","end;if __a then b_a=b_a..'\n'end end end;b_a=b_a..
(__a and string.rep('    ',dd)or'').."}"return b_a end;local bb=lookupify{' ','\n','\t','\r'}
local cb={['\r']='\\r',['\n']='\\n',['\t']='\\t',['"']='\\"',["'"]="\\'"}
local db=lookupify{'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'}
local _c=lookupify{'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'}
local ac=lookupify{'0','1','2','3','4','5','6','7','8','9'}
local bc=lookupify{'0','1','2','3','4','5','6','7','8','9','A','a','B','b','C','c','D','d','E','e','F','f'}
local cc=lookupify{'+','-','*','/','^','%',',','{','}','[',']','(',')',';','#'}
local dc=lookupify{'and','break','do','else','elseif','end','false','for','function','goto','if','in','local','nil','not','or','repeat','return','then','true','until','while'}
function LexLua(cd)local dd={}
local __a,a_a=pcall(function()local _aa=1;local aaa=1;local baa=1
local function caa()local cba=cd:sub(_aa,_aa)if cba=='\n'then baa=1
aaa=aaa+1 else baa=baa+1 end;_aa=_aa+1;return cba end
local function daa(cba)cba=cba or 0;return cd:sub(_aa+cba,_aa+cba)end;local function _ba(cba)local dba=daa()
for i=1,#cba do if dba==cba:sub(i,i)then return caa()end end end;local function aba(cba)
return error(">> :"..aaa..":"..
baa..": "..cba,0)end
local function bba()local cba=_aa
if daa()=='['then local dba=0;while
daa(dba+1)=='='do dba=dba+1 end
if daa(dba+1)=='['then for _=0,dba+1 do caa()end
local _ca=_aa
while true do if daa()==''then
aba("Expected `]"..string.rep('=',dba).."]` near <eof>.",3)end;local cca=true;if daa()==']'then for i=1,dba do if daa(i)~='='then
cca=false end end
if daa(dba+1)~=']'then cca=false end else cca=false end;if cca then break else
caa()end end;local aca=cd:sub(_ca,_aa-1)for i=0,dba+1 do caa()end
local bca=cd:sub(cba,_aa-1)return aca,bca else return nil end else return nil end end
while true do local cba=''
while true do local dca=daa()
if bb[dca]then cba=cba..caa()elseif
dca=='-'and daa(1)=='-'then caa()caa()cba=cba..'--'local _da,ada=bba()
if ada then cba=cba..ada else while daa()~='\n'and
daa()~=''do cba=cba..caa()end end else break end end;local dba=aaa;local _ca=baa
local aca=":"..aaa..":"..baa..":> "local bca=daa()local cca=nil
if bca==''then cca={Type='Eof'}elseif
_c[bca]or db[bca]or bca=='_'then local dca=_aa;repeat caa()bca=daa()until not
(_c[bca]or db[bca]or ac[bca]or bca=='_')
local _da=cd:sub(dca,_aa-1)
if dc[_da]then cca={Type='Keyword',Data=_da}else cca={Type='Ident',Data=_da}end elseif ac[bca]or(daa()=='.'and ac[daa(1)])then local dca=_aa
if bca=='0'and
daa(1)=='x'then caa()caa()while bc[daa()]do caa()end;if _ba('Pp')then
_ba('+-')while ac[daa()]do caa()end end else
while ac[daa()]do caa()end;if _ba('.')then while ac[daa()]do caa()end end;if _ba('Ee')then
_ba('+-')while ac[daa()]do caa()end end end;cca={Type='Number',Data=cd:sub(dca,_aa-1)}elseif bca=='\''or bca==
'\"'then local dca=_aa;local _da=caa()local ada=_aa;while true do local dda=caa()
if dda=='\\'then caa()elseif
dda==_da then break elseif dda==''then aba("Unfinished string near <eof>")end end;local bda=cd:sub(ada,
_aa-2)local cda=cd:sub(dca,_aa-1)
cca={Type='String',Data=cda,Constant=bda}elseif bca=='['then local dca,_da=bba()
if _da then cca={Type='String',Data=_da,Constant=dca}else
caa()cca={Type='Symbol',Data='['}end elseif _ba('>=<')then if _ba('=')then cca={Type='Symbol',Data=bca..'='}else
cca={Type='Symbol',Data=bca}end elseif _ba('~')then
if _ba('=')then
cca={Type='Symbol',Data='~='}else aba("Unexpected symbol `~` in source.",2)end elseif _ba('.')then
if _ba('.')then if _ba('.')then cca={Type='Symbol',Data='...'}else
cca={Type='Symbol',Data='..'}end else cca={Type='Symbol',Data='.'}end elseif _ba(':')then if _ba(':')then cca={Type='Symbol',Data='::'}else
cca={Type='Symbol',Data=':'}end elseif cc[bca]then caa()
cca={Type='Symbol',Data=bca}else local dca,_da=bba()if dca then cca={Type='String',Data=_da,Constant=dca}else
aba("Unexpected Symbol `"..
bca.."` in source.",2)end end;cca.LeadingWhite=cba;cca.Line=dba;cca.Char=_ca
cca.Print=function()
return"<".. (cca.Type..string.rep(' ',7 -#
cca.Type))..
"  ".. (cca.Data or'').." >"end;dd[#dd+1]=cca;if cca.Type=='Eof'then break end end end)if not __a then return false,a_a end;local b_a={}local c_a={}local d_a=1
function b_a:Peek(_aa)_aa=_aa or 0;return dd[math.min(
#dd,d_a+_aa)]end
function b_a:Get()local _aa=dd[d_a]d_a=math.min(d_a+1,#dd)return _aa end;function b_a:Is(_aa)return b_a:Peek().Type==_aa end;function b_a:Save()c_a[
#c_a+1]=d_a end
function b_a:Commit()c_a[#c_a]=nil end;function b_a:Restore()d_a=c_a[#c_a]c_a[#c_a]=nil end
function b_a:ConsumeSymbol(_aa)
local aaa=self:Peek()
if aaa.Type=='Symbol'then if _aa then
if aaa.Data==_aa then self:Get()return true else return nil end else self:Get()return aaa end else return
nil end end
function b_a:ConsumeKeyword(_aa)local aaa=self:Peek()if
aaa.Type=='Keyword'and aaa.Data==_aa then self:Get()return true else return nil end end;function b_a:IsKeyword(_aa)local aaa=b_a:Peek()return
aaa.Type=='Keyword'and aaa.Data==_aa end
function b_a:IsSymbol(_aa)
local aaa=b_a:Peek()return aaa.Type=='Symbol'and aaa.Data==_aa end
function b_a:IsEof()return b_a:Peek().Type=='Eof'end;return true,b_a end
function ParseLua(cd)local dd,__a=LexLua(cd)if not dd then return false,__a end
local function a_a(ada)local bda=">> :"..

__a:Peek().Line..":"..__a:Peek().Char..": "..ada.."\n"local cda=0
for dda in
cd:gmatch("[^\n]*\n?")do if dda:sub(-1,-1)=='\n'then dda=dda:sub(1,-2)end;cda=
cda+1
if cda==__a:Peek().Line then bda=bda..">> `"..
dda:gsub('\t','    ').."`\n"for i=1,__a:Peek().Char
do local __b=dda:sub(i,i)
if __b=='\t'then bda=bda..'    'else bda=bda..' 'end end
bda=bda.."   ^---"break end end;return bda end;local b_a=0;local c_a={}local d_a={'_','a','b','c','d'}
local function _aa(ada)local bda={}bda.Parent=ada
bda.LocalList={}bda.LocalMap={}
function bda:RenameVars()
for cda,dda in pairs(bda.LocalList)do local __b;b_a=0
repeat b_a=b_a+1;local a_b=b_a
__b=''while a_b>0 do local b_b=a_b%#d_a;a_b=(a_b-b_b)/#d_a
__b=__b..d_a[b_b+1]end until
not c_a[__b]and
not ada:GetLocal(__b)and not bda.LocalMap[__b]dda.Name=__b;bda.LocalMap[__b]=dda end end
function bda:GetLocal(cda)local dda=bda.LocalMap[cda]if dda then return dda end;if bda.Parent then
local __b=bda.Parent:GetLocal(cda)if __b then return __b end end;return nil end
function bda:CreateLocal(cda)local dda={}dda.Scope=bda;dda.Name=cda;dda.CanRename=true;bda.LocalList[#
bda.LocalList+1]=dda
bda.LocalMap[cda]=dda;return dda end;bda.Print=function()return"<Scope>"end;return bda end;local aaa;local baa
local function caa(ada)local bda=_aa(ada)if not __a:ConsumeSymbol('(')then return false,
a_a("`(` expected.")end;local cda={}local dda=false
while not
__a:ConsumeSymbol(')')do
if __a:Is('Ident')then
local c_b=bda:CreateLocal(__a:Get().Data)cda[#cda+1]=c_b;if not __a:ConsumeSymbol(',')then
if
__a:ConsumeSymbol(')')then break else return false,a_a("`)` expected.")end end elseif
__a:ConsumeSymbol('...')then dda=true
if not __a:ConsumeSymbol(')')then return false,
a_a("`...` must be the last argument of a function.")end;break else return false,a_a("Argument name or `...` expected")end end;local __b,a_b=baa(bda)if not __b then return false,a_b end;if not
__a:ConsumeKeyword('end')then
return false,a_a("`end` expected after function body")end;local b_b={}
b_b.AstType='Function'b_b.Scope=bda;b_b.Arguments=cda;b_b.Body=a_b;b_b.VarArg=dda;return true,b_b end
local function daa(ada)
if __a:ConsumeSymbol('(')then local bda,cda=aaa(ada)
if not bda then return false,cda end
if not __a:ConsumeSymbol(')')then return false,a_a("`)` Expected.")end;cda.ParenCount=(cda.ParenCount or 0)+1;return true,cda elseif
__a:Is('Ident')then local bda=__a:Get()local cda=ada:GetLocal(bda.Data)if not cda then
c_a[bda.Data]=true end;local dda={}dda.AstType='VarExpr'dda.Name=bda.Data
dda.Local=cda;return true,dda else return false,a_a("primary expression expected")end end
local function _ba(ada,bda)local cda,dda=daa(ada)if not cda then return false,dda end
while true do
if __a:IsSymbol('.')or
__a:IsSymbol(':')then local __b=__a:Get().Data;if not __a:Is('Ident')then return false,
a_a("<Ident> expected.")end;local a_b=__a:Get()
local b_b={}b_b.AstType='MemberExpr'b_b.Base=dda;b_b.Indexer=__b;b_b.Ident=a_b;dda=b_b elseif not
bda and __a:ConsumeSymbol('[')then local __b,a_b=aaa(ada)if not __b then
return false,a_b end;if not __a:ConsumeSymbol(']')then
return false,a_a("`]` expected.")end;local b_b={}b_b.AstType='IndexExpr'
b_b.Base=dda;b_b.Index=a_b;dda=b_b elseif not bda and __a:ConsumeSymbol('(')then local __b={}
while not
__a:ConsumeSymbol(')')do local b_b,c_b=aaa(ada)if not b_b then return false,c_b end
__b[#__b+1]=c_b
if not __a:ConsumeSymbol(',')then if __a:ConsumeSymbol(')')then break else return false,
a_a("`)` Expected.")end end end;local a_b={}a_b.AstType='CallExpr'a_b.Base=dda;a_b.Arguments=__b;dda=a_b elseif not bda and
__a:Is('String')then local __b={}__b.AstType='StringCallExpr'__b.Base=dda
__b.Arguments={__a:Get()}dda=__b elseif not bda and __a:IsSymbol('{')then local __b,a_b=aaa(ada)if not __b then
return false,a_b end;local b_b={}b_b.AstType='TableCallExpr'b_b.Base=dda
b_b.Arguments={a_b}dda=b_b else break end end;return true,dda end
local function aba(ada)
if __a:Is('Number')then local bda={}bda.AstType='NumberExpr'bda.Value=__a:Get()return
true,bda elseif __a:Is('String')then local bda={}bda.AstType='StringExpr'
bda.Value=__a:Get()return true,bda elseif __a:ConsumeKeyword('nil')then local bda={}bda.AstType='NilExpr'
return true,bda elseif __a:IsKeyword('false')or __a:IsKeyword('true')then local bda={}
bda.AstType='BooleanExpr'bda.Value=(__a:Get().Data=='true')return true,bda elseif
__a:ConsumeSymbol('...')then local bda={}bda.AstType='DotsExpr'return true,bda elseif __a:ConsumeSymbol('{')then local bda={}
bda.AstType='ConstructorExpr'bda.EntryList={}
while true do
if __a:IsSymbol('[')then __a:Get()local cda,dda=aaa(ada)
if not cda then return
false,a_a("Key Expression Expected")end
if not __a:ConsumeSymbol(']')then return false,a_a("`]` Expected")end
if not __a:ConsumeSymbol('=')then return false,a_a("`=` Expected")end;local __b,a_b=aaa(ada)if not __b then
return false,a_a("Value Expression Expected")end
bda.EntryList[#bda.EntryList+1]={Type='Key',Key=dda,Value=a_b}elseif __a:Is('Ident')then local cda=__a:Peek(1)
if
cda.Type=='Symbol'and cda.Data=='='then local dda=__a:Get()if not __a:ConsumeSymbol('=')then
return false,a_a("`=` Expected")end;local __b,a_b=aaa(ada)if not __b then return false,
a_a("Value Expression Expected")end
bda.EntryList[
#bda.EntryList+1]={Type='KeyString',Key=dda.Data,Value=a_b}else local dda,__b=aaa(ada)
if not dda then return false,a_a("Value Exected")end
bda.EntryList[#bda.EntryList+1]={Type='Value',Value=__b}end elseif __a:ConsumeSymbol('}')then break else local cda,dda=aaa(ada)
bda.EntryList[#bda.EntryList+1]={Type='Value',Value=dda}if not cda then return false,a_a("Value Expected")end end
if __a:ConsumeSymbol(';')or __a:ConsumeSymbol(',')then elseif
__a:ConsumeSymbol('}')then break else return false,a_a("`}` or table entry Expected")end end;return true,bda elseif __a:ConsumeKeyword('function')then local bda,cda=caa(ada)if not bda then
return false,cda end;cda.IsLocal=true;return true,cda else return _ba(ada)end end;local bba=lookupify{'-','not','#'}local cba=8
local dba={['+']={6,6},['-']={6,6},['%']={7,7},['/']={7,7},['*']={7,7},['^']={10,9},['..']={5,4},['==']={3,3},['<']={3,3},['<=']={3,3},['~=']={3,3},['>']={3,3},['>=']={3,3},['and']={2,2},['or']={1,1}}
local function _ca(ada,bda)local cda,dda
if bba[__a:Peek().Data]then local __b=__a:Get().Data
cda,dda=_ca(ada,cba)if not cda then return false,dda end;local a_b={}a_b.AstType='UnopExpr'
a_b.Rhs=dda;a_b.Op=__b;dda=a_b else cda,dda=aba(ada)if not cda then return false,dda end end
while true do local __b=dba[__a:Peek().Data]
if __b and __b[1]>bda then
local a_b=__a:Get().Data;local b_b,c_b=_ca(ada,__b[2])if not b_b then return false,c_b end;local d_b={}
d_b.AstType='BinopExpr'd_b.Lhs=dda;d_b.Op=a_b;d_b.Rhs=c_b;dda=d_b else break end end;return true,dda end;aaa=function(ada)return _ca(ada,0)end
local function aca(ada)local bda=nil
if
__a:ConsumeKeyword('if')then local cda={}cda.AstType='IfStatement'cda.Clauses={}
repeat local dda,__b=aaa(ada)if not dda then
return false,__b end;if not __a:ConsumeKeyword('then')then return false,
a_a("`then` expected.")end
local a_b,b_b=baa(ada)if not a_b then return false,b_b end
cda.Clauses[#cda.Clauses+1]={Condition=__b,Body=b_b}until not __a:ConsumeKeyword('elseif')
if __a:ConsumeKeyword('else')then local dda,__b=baa(ada)
if not dda then return false,__b end;cda.Clauses[#cda.Clauses+1]={Body=__b}end;if not __a:ConsumeKeyword('end')then
return false,a_a("`end` expected.")end;bda=cda elseif __a:ConsumeKeyword('while')then
local cda={}cda.AstType='WhileStatement'local dda,__b=aaa(ada)
if not dda then return false,__b end;if not __a:ConsumeKeyword('do')then
return false,a_a("`do` expected.")end;local a_b,b_b=baa(ada)
if not a_b then return false,b_b end;if not __a:ConsumeKeyword('end')then
return false,a_a("`end` expected.")end;cda.Condition=__b;cda.Body=b_b;bda=cda elseif
__a:ConsumeKeyword('do')then local cda,dda=baa(ada)if not cda then return false,dda end
if not
__a:ConsumeKeyword('end')then return false,a_a("`end` expected.")end;local __b={}__b.AstType='DoStatement'__b.Body=dda;bda=__b elseif
__a:ConsumeKeyword('for')then
if not __a:Is('Ident')then return false,a_a("<ident> expected.")end;local cda=__a:Get()
if __a:ConsumeSymbol('=')then local dda=_aa(ada)
local __b=dda:CreateLocal(cda.Data)local a_b,b_b=aaa(ada)if not a_b then return false,b_b end
if not
__a:ConsumeSymbol(',')then return false,a_a("`,` Expected")end;local c_b,d_b=aaa(ada)if not c_b then return false,d_b end;local _ab,aab
if
__a:ConsumeSymbol(',')then _ab,aab=aaa(ada)if not _ab then return false,aab end end;if not __a:ConsumeKeyword('do')then
return false,a_a("`do` expected")end;local bab,cab=baa(dda)
if not bab then return false,cab end;if not __a:ConsumeKeyword('end')then
return false,a_a("`end` expected")end;local dab={}
dab.AstType='NumericForStatement'dab.Scope=dda;dab.Variable=__b;dab.Start=b_b;dab.End=d_b;dab.Step=aab
dab.Body=cab;bda=dab else local dda=_aa(ada)
local __b={dda:CreateLocal(cda.Data)}
while __a:ConsumeSymbol(',')do if not __a:Is('Ident')then return false,
a_a("for variable expected.")end
__b[#__b+1]=dda:CreateLocal(__a:Get().Data)end;if not __a:ConsumeKeyword('in')then
return false,a_a("`in` expected.")end;local a_b={}local b_b,c_b=aaa(ada)if not b_b then
return false,c_b end;a_b[#a_b+1]=c_b
while __a:ConsumeSymbol(',')do
local bab,cab=aaa(ada)if not bab then return false,cab end;a_b[#a_b+1]=cab end;if not __a:ConsumeKeyword('do')then
return false,a_a("`do` expected.")end;local d_b,_ab=baa(dda)
if not d_b then return false,_ab end;if not __a:ConsumeKeyword('end')then
return false,a_a("`end` expected.")end;local aab={}
aab.AstType='GenericForStatement'aab.Scope=dda;aab.VariableList=__b;aab.Generators=a_b;aab.Body=_ab;bda=aab end elseif __a:ConsumeKeyword('repeat')then local cda,dda=baa(ada)
if not cda then return false,dda end;if not __a:ConsumeKeyword('until')then
return false,a_a("`until` expected.")end;local __b,a_b=aaa(ada)
if not __b then return false,a_b end;local b_b={}b_b.AstType='RepeatStatement'b_b.Condition=a_b;b_b.Body=dda;bda=b_b elseif
__a:ConsumeKeyword('function')then if not __a:Is('Ident')then
return false,a_a("Function name expected")end;local cda,dda=_ba(ada,true)if not cda then
return false,dda end;local __b,a_b=caa(ada)if not __b then return false,a_b end
a_b.IsLocal=false;a_b.Name=dda;bda=a_b elseif __a:ConsumeKeyword('local')then
if __a:Is('Ident')then
local cda={__a:Get().Data}while __a:ConsumeSymbol(',')do if not __a:Is('Ident')then return false,
a_a("local var name expected")end
cda[#cda+1]=__a:Get().Data end;local dda={}if
__a:ConsumeSymbol('=')then
repeat local a_b,b_b=aaa(ada)if not a_b then return false,b_b end
dda[#dda+1]=b_b until not __a:ConsumeSymbol(',')end;for a_b,b_b in
pairs(cda)do cda[a_b]=ada:CreateLocal(b_b)end
local __b={}__b.AstType='LocalStatement'__b.LocalList=cda;__b.InitList=dda;bda=__b elseif
__a:ConsumeKeyword('function')then if not __a:Is('Ident')then
return false,a_a("Function name expected")end;local cda=__a:Get().Data
local dda=ada:CreateLocal(cda)local __b,a_b=caa(ada)if not __b then return false,a_b end;a_b.Name=dda
a_b.IsLocal=true;bda=a_b else
return false,a_a("local var or function def expected")end elseif __a:ConsumeSymbol('::')then if not __a:Is('Ident')then return false,
a_a('Label name expected')end
local cda=__a:Get().Data
if not __a:ConsumeSymbol('::')then return false,a_a("`::` expected")end;local dda={}dda.AstType='LabelStatement'dda.Label=cda;bda=dda elseif
__a:ConsumeKeyword('return')then local cda={}
if not __a:IsKeyword('end')then local __b,a_b=aaa(ada)
if __b then cda[1]=a_b;while
__a:ConsumeSymbol(',')do local b_b,c_b=aaa(ada)if not b_b then return false,c_b end
cda[#cda+1]=c_b end end end;local dda={}dda.AstType='ReturnStatement'dda.Arguments=cda;bda=dda elseif
__a:ConsumeKeyword('break')then local cda={}cda.AstType='BreakStatement'bda=cda elseif __a:IsKeyword('goto')then
if not
__a:Is('Ident')then return false,a_a("Label expected")end;local cda=__a:Get().Data;local dda={}dda.AstType='GotoStatement'
dda.Label=cda;bda=dda else local cda,dda=_ba(ada)if not cda then return false,dda end
if
__a:IsSymbol(',')or __a:IsSymbol('=')then
if(dda.ParenCount or 0)>0 then return false,
a_a("Can not assign to parenthesized expression, is not an lvalue")end;local __b={dda}
while __a:ConsumeSymbol(',')do local _ab,aab=_ba(ada)
if not _ab then return false,aab end;__b[#__b+1]=aab end
if not __a:ConsumeSymbol('=')then return false,a_a("`=` Expected.")end;local a_b={}local b_b,c_b=aaa(ada)if not b_b then return false,c_b end;a_b[1]=c_b;while
__a:ConsumeSymbol(',')do local _ab,aab=aaa(ada)if not _ab then return false,aab end
a_b[#a_b+1]=aab end;local d_b={}
d_b.AstType='AssignmentStatement'd_b.Lhs=__b;d_b.Rhs=a_b;bda=d_b elseif
dda.AstType=='CallExpr'or
dda.AstType=='TableCallExpr'or dda.AstType=='StringCallExpr'then local __b={}__b.AstType='CallStatement'__b.Expression=dda;bda=__b else return false,
a_a("Assignment Statement Expected")end end;bda.HasSemicolon=__a:ConsumeSymbol(';')return true,bda end
local bca=lookupify{'end','else','elseif','until'}
baa=function(ada)local bda={}bda.Scope=_aa(ada)bda.AstType='Statlist'local cda={}
while not
bca[__a:Peek().Data]and not __a:IsEof()do
local dda,__b=aca(bda.Scope)if not dda then return false,__b end;cda[#cda+1]=__b end;bda.Body=cda;return true,bda end;local function cca()local ada=_aa()return baa(ada)end;local dca,_da=cca()
return dca,_da end
local _d=lookupify{'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'}
local ad=lookupify{'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'}
local bd=lookupify{'0','1','2','3','4','5','6','7','8','9'}
function Format_Mini(cd)local dd,__a;local a_a=0
local function b_a(d_a,_aa,aaa)
if a_a>150 then a_a=0;return d_a.."\n".._aa end;aaa=aaa or' 'local baa,caa=d_a:sub(-1,-1),_aa:sub(1,1)
if
ad[baa]or _d[baa]or baa=='_'then
if not
(ad[caa]or _d[caa]or caa=='_'or bd[caa])then return d_a.._aa elseif caa=='('then
return d_a..aaa.._aa else return d_a..aaa.._aa end elseif bd[baa]then
if caa=='('then return d_a.._aa else return d_a..aaa.._aa end elseif baa==''then return d_a.._aa else
if caa=='('then return d_a..aaa.._aa else return d_a.._aa end end end
__a=function(d_a)local _aa=string.rep('(',d_a.ParenCount or 0)
if
d_a.AstType=='VarExpr'then if d_a.Local then _aa=_aa..d_a.Local.Name else
_aa=_aa..d_a.Name end elseif d_a.AstType=='NumberExpr'then _aa=_aa..
d_a.Value.Data elseif d_a.AstType=='StringExpr'then
_aa=_aa..d_a.Value.Data elseif d_a.AstType=='BooleanExpr'then _aa=_aa..tostring(d_a.Value)elseif
d_a.AstType=='NilExpr'then _aa=b_a(_aa,"nil")elseif d_a.AstType=='BinopExpr'then
_aa=b_a(_aa,__a(d_a.Lhs))_aa=b_a(_aa,d_a.Op)_aa=b_a(_aa,__a(d_a.Rhs))elseif d_a.AstType==
'UnopExpr'then _aa=b_a(_aa,d_a.Op)
_aa=b_a(_aa,__a(d_a.Rhs))elseif d_a.AstType=='DotsExpr'then _aa=_aa.."..."elseif d_a.AstType=='CallExpr'then _aa=_aa..
__a(d_a.Base)_aa=_aa.."("for i=1,#d_a.Arguments do _aa=_aa..
__a(d_a.Arguments[i])
if i~=#d_a.Arguments then _aa=_aa..","end end;_aa=_aa..")"elseif d_a.AstType==
'TableCallExpr'then _aa=_aa..__a(d_a.Base)_aa=_aa..
__a(d_a.Arguments[1])elseif d_a.AstType=='StringCallExpr'then
_aa=_aa..__a(d_a.Base)_aa=_aa..d_a.Arguments[1].Data elseif
d_a.AstType=='IndexExpr'then
_aa=_aa..__a(d_a.Base).."["..__a(d_a.Index).."]"elseif d_a.AstType=='MemberExpr'then _aa=_aa..__a(d_a.Base)..
d_a.Indexer..d_a.Ident.Data elseif
d_a.AstType=='Function'then d_a.Scope:RenameVars()
_aa=_aa.."function("
if#d_a.Arguments>0 then for i=1,#d_a.Arguments do
_aa=_aa..d_a.Arguments[i].Name
if i~=#d_a.Arguments then _aa=_aa..","elseif d_a.VarArg then _aa=_aa..",..."end end elseif
d_a.VarArg then _aa=_aa.."..."end;_aa=_aa..")"_aa=b_a(_aa,dd(d_a.Body))
_aa=b_a(_aa,"end")elseif d_a.AstType=='ConstructorExpr'then _aa=_aa.."{"
for i=1,#d_a.EntryList do
local aaa=d_a.EntryList[i]
if aaa.Type=='Key'then _aa=_aa.."["..
__a(aaa.Key).."]="..__a(aaa.Value)elseif aaa.Type==
'Value'then _aa=_aa..__a(aaa.Value)elseif aaa.Type=='KeyString'then
_aa=_aa..
aaa.Key.."="..__a(aaa.Value)end;if i~=#d_a.EntryList then _aa=_aa..","end end;_aa=_aa.."}"end
_aa=_aa..string.rep(')',d_a.ParenCount or 0)a_a=a_a+#_aa;return _aa end
local c_a=function(d_a)local _aa=''
if d_a.AstType=='AssignmentStatement'then
for i=1,#d_a.Lhs do
_aa=_aa..__a(d_a.Lhs[i])if i~=#d_a.Lhs then _aa=_aa..","end end;if#d_a.Rhs>0 then _aa=_aa.."="
for i=1,#d_a.Rhs do
_aa=_aa..__a(d_a.Rhs[i])if i~=#d_a.Rhs then _aa=_aa..","end end end elseif
d_a.AstType=='CallStatement'then _aa=__a(d_a.Expression)elseif d_a.AstType=='LocalStatement'then
_aa=_aa.."local "
for i=1,#d_a.LocalList do _aa=_aa..d_a.LocalList[i].Name;if i~=#
d_a.LocalList then _aa=_aa..","end end
if#d_a.InitList>0 then _aa=_aa.."="for i=1,#d_a.InitList do _aa=_aa..
__a(d_a.InitList[i])
if i~=#d_a.InitList then _aa=_aa..","end end end elseif d_a.AstType=='IfStatement'then
_aa=b_a("if",__a(d_a.Clauses[1].Condition))_aa=b_a(_aa,"then")
_aa=b_a(_aa,dd(d_a.Clauses[1].Body))
for i=2,#d_a.Clauses do local aaa=d_a.Clauses[i]
if aaa.Condition then
_aa=b_a(_aa,"elseif")_aa=b_a(_aa,__a(aaa.Condition))
_aa=b_a(_aa,"then")else _aa=b_a(_aa,"else")end;_aa=b_a(_aa,dd(aaa.Body))end;_aa=b_a(_aa,"end")elseif d_a.AstType=='WhileStatement'then
_aa=b_a("while",__a(d_a.Condition))_aa=b_a(_aa,"do")_aa=b_a(_aa,dd(d_a.Body))
_aa=b_a(_aa,"end")elseif d_a.AstType=='DoStatement'then _aa=b_a(_aa,"do")
_aa=b_a(_aa,dd(d_a.Body))_aa=b_a(_aa,"end")elseif d_a.AstType=='ReturnStatement'then _aa="return"
for i=1,#d_a.Arguments
do _aa=b_a(_aa,__a(d_a.Arguments[i]))if i~=
#d_a.Arguments then _aa=_aa..","end end elseif d_a.AstType=='BreakStatement'then _aa="break"elseif d_a.AstType=='RepeatStatement'then
_aa="repeat"_aa=b_a(_aa,dd(d_a.Body))_aa=b_a(_aa,"until")
_aa=b_a(_aa,__a(d_a.Condition))elseif d_a.AstType=='Function'then d_a.Scope:RenameVars()if d_a.IsLocal then
_aa="local"end;_aa=b_a(_aa,"function ")if d_a.IsLocal then
_aa=_aa..d_a.Name.Name else _aa=_aa..__a(d_a.Name)end;_aa=
_aa.."("
if#d_a.Arguments>0 then
for i=1,#d_a.Arguments do _aa=_aa..
d_a.Arguments[i].Name;if i~=#d_a.Arguments then _aa=_aa..","elseif d_a.VarArg then
_aa=_aa..",..."end end elseif d_a.VarArg then _aa=_aa.."..."end;_aa=_aa..")"_aa=b_a(_aa,dd(d_a.Body))
_aa=b_a(_aa,"end")elseif d_a.AstType=='GenericForStatement'then d_a.Scope:RenameVars()
_aa="for "
for i=1,#d_a.VariableList do
_aa=_aa..d_a.VariableList[i].Name;if i~=#d_a.VariableList then _aa=_aa..","end end;_aa=_aa.." in"
for i=1,#d_a.Generators do
_aa=b_a(_aa,__a(d_a.Generators[i]))if i~=#d_a.Generators then _aa=b_a(_aa,',')end end;_aa=b_a(_aa,"do")_aa=b_a(_aa,dd(d_a.Body))
_aa=b_a(_aa,"end")elseif d_a.AstType=='NumericForStatement'then _aa="for "_aa=_aa..
d_a.Variable.Name.."="_aa=_aa..
__a(d_a.Start)..","..__a(d_a.End)if d_a.Step then
_aa=_aa..","..__a(d_a.Step)end;_aa=b_a(_aa,"do")
_aa=b_a(_aa,dd(d_a.Body))_aa=b_a(_aa,"end")end;a_a=a_a+#_aa;return _aa end
dd=function(d_a)local _aa=''d_a.Scope:RenameVars()for aaa,baa in pairs(d_a.Body)do
_aa=b_a(_aa,c_a(baa),';')end;return _aa end;cd.Scope:RenameVars()return dd(cd)end
return function(cd)local dd,__a=ParseLua(cd)if not dd then return false,__a end
return true,Format_Mini(__a)end