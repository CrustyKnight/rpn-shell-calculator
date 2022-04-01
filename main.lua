if not table.pack then table.pack = function(...) return { n = select("#", ...), ... } end end
if not table.unpack then table.unpack = unpack end
local load = load if _VERSION:find("5.1") then load = function(x, n, _, env) local f, e = loadstring(x, n) if not f then return f, e end if env then setfenv(f, env) end return f end end
local _select, _unpack, _pack, _error = select, table.unpack, table.pack, error
local _libs = {}
local _3d_1, _3c_1, _3c3d_1, _3e3d_1, _2b_1, _2d_1, _2a_1, _2f_1, expt1, _2e2e_1, len_23_1, getIdx1, setIdx_21_1, arg_23_1, error1, print1, require1, setmetatable1, tonumber1, tostring1, type_23_1, format1, len1, sub1, n1, _2a_arguments_2a_1, type1, traceback1, demandFailure_2d3e_string1, _2a_demandFailureMt_2a_1, demandFailure1, acos1, asin1, atan1, cos1, exp1, log1, sin1, sqrt1, tan1, nth1, push_21_1, popLast_21_1, read1, write1, mode1, ps1, getKey1, sc1, cls1, v_5f_line1, h_5f_line11, h_5f_line21, h_5f_line31, buttons1, numbers1, func_5f_symbols1, factorial1, symbol_5f_funcs_21_1, print_5f_nstack_5f_r1, number_5f_entry1, symbol_5f_entry1, stack1, entryNumber1, home1
_3d_1 = function(v1, v2) return v1 == v2 end
_3c_1 = function(v1, v2) return v1 < v2 end
_3c3d_1 = function(v1, v2) return v1 <= v2 end
_3e3d_1 = function(v1, v2) return v1 >= v2 end
_2b_1 = function(x, ...) local t = x + ... for i = 2, _select('#', ...) do t = t + _select(i, ...) end return t end
_2d_1 = function(x, ...) local t = x - ... for i = 2, _select('#', ...) do t = t - _select(i, ...) end return t end
_2a_1 = function(x, ...) local t = x * ... for i = 2, _select('#', ...) do t = t * _select(i, ...) end return t end
_2f_1 = function(x, ...) local t = x / ... for i = 2, _select('#', ...) do t = t / _select(i, ...) end return t end
expt1 = function(x, ...) local n = _select('#', ...) local t = _select(n, ...) for i = n - 1, 1, -1 do t = _select(i, ...) ^ t end return x ^ t end
_2e2e_1 = function(x, ...) local n = _select('#', ...) local t = _select(n, ...) for i = n - 1, 1, -1 do t = _select(i, ...) .. t end return x .. t end
len_23_1 = function(v1) return #v1 end
getIdx1 = function(v1, v2) return v1[v2] end
setIdx_21_1 = function(v1, v2, v3) v1[v2] = v3 end
arg_23_1 = arg or {...}
error1 = error
print1 = print
require1 = require
setmetatable1 = setmetatable
tonumber1 = tonumber
tostring1 = tostring
type_23_1 = type
format1 = string.format
len1 = string.len
sub1 = string.sub
n1 = function(x)
  if type_23_1(x) == "table" then
    return x["n"]
  else
    return #x
  end
end
if nil == arg_23_1 then
  _2a_arguments_2a_1 = {tag="list", n=0}
else
  arg_23_1["tag"] = "list"
  if not arg_23_1["n"] then
    arg_23_1["n"] = #arg_23_1
  end
  _2a_arguments_2a_1 = arg_23_1
end
type1 = function(val)
  local ty = type_23_1(val)
  if ty == "table" then
    return val["tag"] or "table"
  else
    return ty
  end
end
traceback1 = debug and debug.traceback
demandFailure_2d3e_string1 = function(failure)
  if failure["message"] then
    return format1("demand not met: %s (%s).\n%s", failure["condition"], failure["message"], failure["traceback"])
  else
    return format1("demand not met: %s.\n%s", failure["condition"], failure["traceback"])
  end
end
_2a_demandFailureMt_2a_1 = {__tostring=demandFailure_2d3e_string1}
demandFailure1 = function(message, condition)
  return setmetatable1({tag="demand-failure", message=message, traceback=(function()
    if traceback1 then
      return traceback1("", 2)
    else
      return ""
    end
  end)(), condition=condition}, _2a_demandFailureMt_2a_1)
end
acos1 = math.acos
asin1 = math.asin
atan1 = math.atan
cos1 = math.cos
exp1 = math.exp
log1 = math.log
sin1 = math.sin
sqrt1 = math.sqrt
tan1 = math.tan
nth1 = function(xs, idx)
  if idx >= 0 then
    return xs[idx]
  else
    return xs[xs["n"] + 1 + idx]
  end
end
push_21_1 = function(xs, ...)
  local vals = _pack(...) vals.tag = "list"
  if not (type1(xs) == "list") then
    error1(demandFailure1(nil, "(= (type xs) \"list\")"))
  end
  local nxs = n1(xs)
  xs["n"] = (nxs + n1(vals))
  local forLimit = n1(vals)
  local i = 1
  while i <= forLimit do
    xs[nxs + i] = vals[i]
    i = i + 1
  end
  return xs
end
popLast_21_1 = function(xs)
  if not (type1(xs) == "list") then
    error1(demandFailure1(nil, "(= (type xs) \"list\")"))
  end
  local x = xs[n1(xs)]
  xs[n1(xs)] = nil
  xs["n"] = n1(xs) - 1
  return x
end
read1 = io.read
write1 = io.write
mode1 = nil
ps1 = function(x, y, msg)
  return write1(format1("\27[%d;%df%s", y, x, msg))
end
getKey1 = function()
  return read1("*l")
end
sc1 = function(x, y)
  return write1(format1("\27[%d;%df", y, x))
end
cls1 = function()
  return write1("\27[2J")
end
v_5f_line1 = "|"
h_5f_line11 = "+----------------------------+---------+"
h_5f_line21 = "+----------------------------+---------+"
h_5f_line31 = "+----------------------------+---------+"
if _2a_arguments_2a_1[1] == "-u" then
  v_5f_line1 = "│"
  h_5f_line11 = "┌────────────────────────────┬─────────┐"
  h_5f_line21 = "├────────────────────────────┼─────────┤"
  h_5f_line31 = "└────────────────────────────┴─────────┘"
end
buttons1 = {}
buttons1["EXIT"] = "e"
buttons1["NUM"] = "a"
buttons1["SYM"] = "s"
buttons1["MENU"] = "h"
buttons1[1] = "a"
buttons1[2] = "o"
buttons1[3] = "e"
buttons1[4] = "u"
buttons1[5] = "h"
buttons1[6] = "t"
buttons1[7] = "n"
buttons1[8] = "s"
buttons1["ENTER"] = " "
numbers1 = {}
numbers1["a"] = 16
numbers1["o"] = 12
numbers1["e"] = 8
numbers1["u"] = 4
numbers1["h"] = 0
numbers1["t"] = 1
numbers1["n"] = 2
numbers1["s"] = 3
func_5f_symbols1 = {tag="list", n=3, {tag="list", n=2, {tag="symbol", contents="quote"}, {tag="list", n=8, "add", "min", "mul", "div", "pow", "sqrt", "sqr", "inv"}}, {tag="list", n=2, {tag="symbol", contents="quote"}, {tag="list", n=8, "sin", "cos", "tan", "_NIL", "asin", "acos", "atan", "_NIL"}}, {tag="list", n=2, {tag="symbol", contents="quote"}, {tag="list", n=8, "log", "10xp", "ln", "exp", "fac", "_NIL", "_NIL", "_NIL"}}}
factorial1 = function(n)
  if n <= 0 then
    return 1
  else
    return n * factorial1(n - 1)
  end
end
symbol_5f_funcs_21_1 = {}
symbol_5f_funcs_21_1["add"] = function(s)
  return push_21_1(s, popLast_21_1(s) + popLast_21_1(s))
end
symbol_5f_funcs_21_1["min"] = function(s)
  local b, a = popLast_21_1(s), popLast_21_1(s)
  return push_21_1(s, a - b)
end
symbol_5f_funcs_21_1["mul"] = function(s)
  return push_21_1(s, popLast_21_1(s) * popLast_21_1(s))
end
symbol_5f_funcs_21_1["div"] = function(s)
  local b, a = popLast_21_1(s), popLast_21_1(s)
  return push_21_1(s, a / b)
end
symbol_5f_funcs_21_1["pow"] = function(s)
  local b, a = popLast_21_1(s), popLast_21_1(s)
  return push_21_1(s, a ^ b)
end
symbol_5f_funcs_21_1["sqrt"] = function(s)
  return push_21_1(s, sqrt1(popLast_21_1(s)))
end
symbol_5f_funcs_21_1["sqr"] = function(s)
  return push_21_1(s, popLast_21_1(s) ^ 2)
end
symbol_5f_funcs_21_1["inv"] = function(s)
  return push_21_1(s, 1 / popLast_21_1(s))
end
symbol_5f_funcs_21_1["sin"] = function(s)
  return push_21_1(s, sin1(popLast_21_1(s)))
end
symbol_5f_funcs_21_1["cos"] = function(s)
  return push_21_1(s, cos1(popLast_21_1(s)))
end
symbol_5f_funcs_21_1["tan"] = function(s)
  return push_21_1(s, tan1(popLast_21_1(s)))
end
symbol_5f_funcs_21_1["asin"] = function(s)
  return push_21_1(s, asin1(popLast_21_1(s)))
end
symbol_5f_funcs_21_1["acos"] = function(s)
  return push_21_1(s, acos1(popLast_21_1(s)))
end
symbol_5f_funcs_21_1["atan"] = function(s)
  return push_21_1(s, atan1(popLast_21_1(s)))
end
symbol_5f_funcs_21_1["log10"] = function(s)
  return push_21_1(s, log1(popLast_21_1(s), 10))
end
symbol_5f_funcs_21_1["10xp"] = function(s)
  return push_21_1(s, 10 ^ popLast_21_1(s))
end
symbol_5f_funcs_21_1["ln"] = function(s)
  return push_21_1(s, log1(popLast_21_1(s)))
end
symbol_5f_funcs_21_1["exp"] = function(s)
  return push_21_1(s, exp1(popLast_21_1(s)))
end
symbol_5f_funcs_21_1["fac"] = function(s)
  return push_21_1(s, factorial1(popLast_21_1(s)))
end
symbol_5f_funcs_21_1["_NIL"] = function(s)
  return nil
end
print_5f_nstack_5f_r1 = function(s, area)
  local x, y, w, h = nth1(area, 1), nth1(area, 2), nth1(area, 3), nth1(area, 4)
  local start, forLimit = n1(s) - h, n1(s)
  local i = start
  while i <= forLimit do
    if len1(tostring1(nth1(s, i))) < w then
      ps1(x, y + (i - start), format1("%" .. w .. "d", nth1(s, i)))
    else
      ps1(x, y + (i - start), format1("%1." .. w - 7 .. "e", nth1(s, i)))
    end
    i = i + 1
  end
  return nil
end
number_5f_entry1 = function()
  ps1(3, 3, "[a] 16")
  ps1(3, 4, "[o] 12")
  ps1(3, 5, "[e] 08")
  ps1(3, 6, "[u] 04")
  ps1(10, 3, "[h] 00")
  ps1(10, 4, "[t] 01")
  ps1(10, 5, "[n] 02")
  ps1(10, 6, "[s] 03")
  ps1(31, 15, "   ")
  sc1(31, 15)
  local str = read1("*l")
  local a, b = sub1(str, 1, 1), sub1(str, 2, 2)
  print1(a, b)
  return numbers1[a] + numbers1[b]
end
symbol_5f_entry1 = function(l, s)
  ps1(3, 3, "[a] " .. nth1(nth1(func_5f_symbols1, l), 1))
  ps1(3, 4, "[o] " .. nth1(nth1(func_5f_symbols1, l), 2))
  ps1(3, 5, "[e] " .. nth1(nth1(func_5f_symbols1, l), 3))
  ps1(3, 6, "[u] " .. nth1(nth1(func_5f_symbols1, l), 4))
  ps1(12, 3, "[h] " .. nth1(nth1(func_5f_symbols1, l), 5))
  ps1(12, 4, "[t] " .. nth1(nth1(func_5f_symbols1, l), 6))
  ps1(12, 5, "[n] " .. nth1(nth1(func_5f_symbols1, l), 7))
  ps1(12, 6, "[s] " .. nth1(nth1(func_5f_symbols1, l), 8))
  ps1(7, 7, "[ ] Next")
  local str = read1("*l")
  if str == "a" then
    symbol_5f_funcs_21_1[nth1(nth1(func_5f_symbols1, l), 1)](s)
  elseif str == "o" then
    symbol_5f_funcs_21_1[nth1(nth1(func_5f_symbols1, l), 2)](s)
  elseif str == "e" then
    symbol_5f_funcs_21_1[nth1(nth1(func_5f_symbols1, l), 3)](s)
  elseif str == "u" then
    symbol_5f_funcs_21_1[nth1(nth1(func_5f_symbols1, l), 4)](s)
  elseif str == "h" then
    symbol_5f_funcs_21_1[nth1(nth1(func_5f_symbols1, l), 5)](s)
  elseif str == "t" then
    symbol_5f_funcs_21_1[nth1(nth1(func_5f_symbols1, l), 6)](s)
  elseif str == "n" then
    symbol_5f_funcs_21_1[nth1(nth1(func_5f_symbols1, l), 7)](s)
  elseif str == "s" then
    symbol_5f_funcs_21_1[nth1(nth1(func_5f_symbols1, l), 8)](s)
  elseif str == " " then
    symbol_5f_entry1()
  else
    _error("unmatched item")
  end
  return nil
end
stack1 = {tag="list", n=0}
push_21_1(stack1, 0)
push_21_1(stack1, 0)
push_21_1(stack1, 0)
push_21_1(stack1, 0)
push_21_1(stack1, 0)
push_21_1(stack1, 0)
push_21_1(stack1, 0)
push_21_1(stack1, 0)
push_21_1(stack1, 0)
push_21_1(stack1, 0)
push_21_1(stack1, 0)
push_21_1(stack1, 0)
push_21_1(stack1, 0)
entryNumber1 = "0"
home1 = {}
home1[buttons1["SYM"]] = function()
  return symbol_5f_entry1(1)
end
home1[buttons1["NUM"]] = function()
  entryNumber1 = entryNumber1 .. tostring1(number_5f_entry1())
  return nil
end
home1[buttons1["ENTER"]] = function()
  push_21_1(stack1, tonumber1(entryNumber1))
  entryNumber1 = "0"
  return nil
end
home1["draw"] = function()
  cls1()
  local i = 1
  while i <= 15 do
    ps1(0, i, v_5f_line1)
    i = i + 1
  end
  local i = 1
  while i <= 15 do
    ps1(30, i, v_5f_line1)
    i = i + 1
  end
  local i = 1
  while i <= 15 do
    ps1(40, i, v_5f_line1)
    i = i + 1
  end
  ps1(0, 0, h_5f_line11)
  ps1(0, 14, h_5f_line21)
  ps1(0, 16, h_5f_line31)
  print_5f_nstack_5f_r1(stack1, {tag="list", n=4, 31, 2, 9, 11})
  ps1(2, 15, format1("%27d", tonumber1(entryNumber1)))
  return sc1(31, 15)
end
mode1 = home1
mode1["draw"]()
while true do
  local action = getKey1()
  if action == buttons1["EXIT"] then
    require1("os")["exit"]()
  elseif action == buttons1["MENU"] then
    print1("still working on menu :)")
  elseif mode1[action] then
    mode1[action]()
  end
  mode1["draw"]()
end
