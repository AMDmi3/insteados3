require "sprites"

local old_title = instead.get_title;
instead.get_title = function()
  local r = old_title();
  r = string.gsub(r, "\n", "");
  return r.."\n\n\n";
end

function if_(cnd,x,y)
  return function(s)
    if apply(cnd,s) then
      return x;
    else
      return y;
    end
  end
end

local old_room = room;
function room(r)
  if r.dsc2 ~= nil then
    local dsc = r.dsc;
    r.dsc = function(s)
      local ret = tc(dsc,s);
      if ret ~= nil then
        return "^"..ret;
      end
    end
  end
  if r.pxa ~= nil then
    r.pic = function(s)
      local pxa = tc(s.pxa,s);
      if pxa == nil then
        return;
      end
      local px = sprite.load("gfx/pic.jpg");
      for _,v in ipairs(pxa) do
        local vv = tc(v[1],s);
        if vv ~= nil then
          local spr = sprite.load("gfx/"..vv..".jpg");
          local y = 0;
          if vv == "panel" then
            y = 60;
          elseif vv == "door1" or vv == "door1_open" then
            y = 34;
          elseif vv == "door2" or vv == "door2_open" then
            y = 60;
          elseif vv == "door3" then
            y = 59;
          elseif vv == "window" then
            y = 70;
          elseif vv == "toolbox" then
            y = 171;
          elseif vv == "crio" then
            y = 44;
          elseif vv == "robot" or vv == "robot_nohand" then
            y = 70;
          elseif vv == "box" then
            y = 145;
          elseif vv == "shelf" then
            y = 60;
          elseif vv == "box2" then
            y = 50;
          elseif vv == "rat" then
            y = 135;
          elseif vv == "box3" then
            y = 110;
          elseif vv == "shaft" or vv == "shaft_open" then
            y = 55;
          end
          sprite.copy(spr, px, v[2], y);
          sprite.free(spr);
        end
      end
      return px;
    end
  end
  return old_room(r);
end

function exec_(s)
  return function(this)
    return exec(s,this);
  end
end

function apply(c,this)
  local f = assert(loadstring("return function(s) return ("..c.."); end"))();
  return f(this);
end

local oob = obj;
function tc(f,s)
if type(f) == "function" then return tc(f(s),s) else return f end
end
function obj(t)
local d = t.dsc;
t.dsc = function(s) if s.cnd == nil or s:cnd() then return tc(d,s) end end
return oob(t);
end

function gamefile_(fl)
  return function()
    gamefile(fl, true);
  end
end