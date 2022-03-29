if not table.pack then table.pack = function(...) return { n = select("#", ...), ... } end end
if not table.unpack then table.unpack = unpack end
local load = load if _VERSION:find("5.1") then load = function(x, n, _, env) local f, e = loadstring(x, n) if not f then return f, e end if env then setfenv(f, env) end return f end end
local _select, _unpack, _pack, _error = select, table.unpack, table.pack, error
local _libs = {}
local _3d_1, _3c3d_1, _2b_1, len_23_1, getIdx1, setIdx_21_1, error1, print1, require1, setmetatable1, type_23_1, format1, n1, type1, traceback1, demandFailure_2d3e_string1, _2a_demandFailureMt_2a_1, demandFailure1, push_21_1, read1, write1, mode1, ps1, getKey1, buttons1, stack1, home1
_3d_1 = function(v1, v2) return v1 == v2 end
_3c3d_1 = function(v1, v2) return v1 <= v2 end
_2b_1 = function(x, ...) local t = x + ... for i = 2, _select('#', ...) do t = t + _select(i, ...) end return t end
len_23_1 = function(v1) return #v1 end
getIdx1 = function(v1, v2) return v1[v2] end
setIdx_21_1 = function(v1, v2, v3) v1[v2] = v3 end
error1 = error
print1 = print
require1 = require
setmetatable1 = setmetatable
type_23_1 = type
format1 = string.format
n1 = function(x)
  if type_23_1(x) == "table" then
    return x["n"]
  else
    return #x
  end
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
read1 = io.read
write1 = io.write
mode1 = nil
ps1 = function(x, y, msg)
  return write1(format1("\27[%d;%df%s", y, x, msg))
end
getKey1 = function()
  return read1(1)
end
buttons1 = {}
buttons1["EXIT"] = "e"
buttons1["NUM"] = "a"
buttons1["SYM"] = "s"
buttons1["MENU"] = "h"
stack1 = {tag="list", n=0}
push_21_1(stack1, 1)
push_21_1(stack1, 2)
push_21_1(stack1, 3)
push_21_1(stack1, 4)
push_21_1(stack1, 5)
push_21_1(stack1, 6)
push_21_1(stack1, 7)
push_21_1(stack1, 8)
push_21_1(stack1, 9)
push_21_1(stack1, 10)
home1 = {}
home1[buttons1["SYM"]] = function()
  return print1("symbol")
end
home1[buttons1["NUM"]] = function()
  return print1("number")
end
home1["draw"] = function()
  local i = 1
  while i <= 15 do
    ps1(0, i, "│")
    i = i + 1
  end
  local i = 1
  while i <= 15 do
    ps1(29, i, "│")
    i = i + 1
  end
  local i = 1
  while i <= 15 do
    ps1(39, i, "│")
    i = i + 1
  end
  ps1(0, 0, "┌────────────────────────────┬─────────┐")
  ps1(0, 14, "├────────────────────────────┼─────────┤")
  return ps1(0, 16, "└────────────────────────────┴─────────┘")
end
mode1 = home1
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
