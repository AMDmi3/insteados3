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
  return old_room(r);
end

function string:charat(i)
  local c = 0;
  for uchar in string.gfind(self, "([%z\1-\127\194-\244][\128-\191]*)") do
    c = c + 1;
    if c == i then
      return uchar;
    end
  end
end

function timerpause(snum,enum,next)
  local sh = 1;
  if enum < snum then
    sh = -1;
    enum = enum - 1;
  else
    enum = enum + 1;
  end 
  return room {
    enum = enum, sh = sh, snum = snum,
    _cur = snum, _fr=0,
    nam = "",
    enter = function()
      timer:set(50);
    end,
    pic = function()
      if game.cache2 == nil then
        game.cache2 = sprite.load("gfx/timer1.png");
      end
      return game.cache2;
    end,
    pad = function(s,n)
      local sn = tostring(n);
      if string.len(sn) < 4 then
        return s:pad("0"..sn);
      end
      return sn;
    end,
    loadnum = function(s,n)
      if game["cache_"..n] == nil then
        game["cache_"..n] = sprite.load("gfx/"..n..".png");
      end
      return game["cache_"..n];
    end,
    draw = function(s,d)
      local d = tostring(d);
      local n1,n2,n3,n4 = d:charat(1),d:charat(2),d:charat(3),d:charat(4);
      local y = 67;
      if s.s1 ~= n1 then
        sprite.copy(s:loadnum(n1), game.cache2, 150+(50*0), y);
        s.s1 = n1;
      end
      if s.s2 ~= n2 then
        sprite.copy(s:loadnum(n2), game.cache2, 150+(50*1), y);
        s.s2 = n2;
      end
      if s.s3 ~= n3 then
        sprite.copy(s:loadnum(n3), game.cache2, 150+(50*2), y);
        s.s3 = n3;
      end
      if s.s4 ~= n4 then
        sprite.copy(s:loadnum(n4), game.cache2, 150+(50*3), y);
        s.s4 = n4;
      end
      if s._cur ~= s.snum then
        play_sound("tick");
      end
    end,
    timer = function(s)
      s._fr = s._fr + 1;
      if not s._nodraw then
        local sn = s:pad(s._cur);
        s:draw(sn);
        if s._fr > 40 then
          s._cur = s._cur + s.sh;
        end
      end
      if s._cur == s.enum then
        if s._nodraw == nil then
          s._nodraw = 0;
        end
        s._nodraw = s._nodraw + 1;
      end
      if s._nodraw ~= nil and s._nodraw == 80 then
        timer:stop();
        s._cur = s.snum;
        s._nodraw = nil;
        s._fr = 0;
        s.s1 = nil;
        s.s2 = nil;
        s.s3 = nil;
        s.s4 = nil;
        walk(next);
      end
    end,
  }
end

game.pic = 
function()
  local s = here();
  if s.pxa == nil then
    return;
  end
  local pxa = tc(s.pxa,s);
  if pxa == nil then
    return;
  end
  if game.cache == nil then
    game.cache = sprite.load("gfx/pic.png");
  else
    local pt = sprite.blank(500, 200);
    sprite.copy(pt, game.cache, 0, 0);
    sprite.free(pt);
  end
  for _,v in ipairs(pxa) do
    local vv = tc(v[1],s);
    if vv ~= nil then
      local spr = game["sprite_"..vv];
      if spr == nil then
        spr = sprite.load("gfx/"..vv..".png");
        game["sprite_"..vv] = spr;
      end
      local y = 0;
      if vv == "panel" or vv == "panel_broken" then
        y = 60;
      elseif vv == "door1" or vv == "door1_open" then
        y = 35;
      elseif vv == "door2" or vv == "door3" or vv == "door4" or vv == "door2_open" then
        y = 60;
      elseif vv == "window" or vv == "window2" then
        y = 62;
      elseif vv == "toolbox" then
        y = 171;
      elseif vv == "crio" or vv == "crio_blood" then
        y = 45;
      elseif vv == "robot" or vv == "robot_nohand" or vv == "robot_nohand_blaster" or vv == "robot_cargo" then
        y = 75;
      elseif vv == "box" then
        y = 145;
      elseif vv == "shelf" then
        y = 60;
      elseif vv == "box2" then
        y = 50;
      elseif vv == "rat" then
        y = 135;
      elseif vv == "rat_dead" then
        y = 100;
      elseif vv == "box3" then
        y = 110;
      elseif vv == "blood" then
        y = 107;
      elseif vv == "shaft" or vv == "shaft_open" then
        y = 55;
      elseif vv == "mutant" then
        y = 28;
      elseif vv == "med" then
        y = 60;
      elseif vv == "zombi" then
        y = 75;
      elseif vv == "device" then
        y = 65;
      elseif vv == "bfg" then
        y = 40;
      elseif vv == "hole" then
        y = 65;
      elseif vv == "hole2" then
        y = 35;
      elseif vv == "washer" then
        y = 55;
      elseif vv == "toilet" then
        y = 90;
      elseif vv == "communicator" then
        y = 80;
      elseif vv == "table" then
        y = 110;
      elseif vv == "extin" then
        y = 145;
      elseif vv == "zombi_dead" then
        y = 145;
      elseif vv == "blaster" or vv == "knife" then
        y = 40;
      elseif vv == "vase_flower" or vv == "vase" then
        y = 70;
      elseif vv == "repair" or vv == "repair_broken" or vv == "repair_meteor" then
        y = 95;
      end
      sprite.compose(spr, game.cache, tc(v[2],s), y);
    end
  end
  return game.cache;
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

function sound_(snd)
  return function() 
    play_sound(snd);
  end
end

function music_(mus, loop, fadeout, fadein)
  return function() 
    play_music(mus, loop, fadeout, fadein);
  end
end

function mute_(fadeout,fadein)
  return function()
    play_music(nil, nil, fadeout, fadein);
  end
end

function playonce_(file,loop)
  return function()
    local hw = here();
    if hw["_"..file] == nil then
      play_music(file,loop);
      hw["_"..file] = true;
    end
  end
end

function play_music(file,loop,fadeout,fadein)
  local fl = file;
  local fout,fin = 2000,2000;
  if file ~= nil and file ~= "" then
    fl = "mus/"..file..".ogg";
  end
  if fadeout ~= nil then    
    fout = fadeout;
  end
  if fadein ~= nil then
    fin = fadein;
  end
  set_music_fading(fadeout, fadein);
  if loop == nil then
    loop = 1;
  end
  if fl ~= nil then
    set_music(fl, loop);
  else
    stop_music();
    mute_sound();
    _lastsound = nil;
  end
end

function play_sound(file,loop,ch)
  local fl = "mus/"..file..".ogg";
  if ch == nil then
    ch = 2;
  end
  set_sound(fl, ch, loop);
  if loop ~= nil then
    _lastsound = {file,loop,ch};
  end
end

function mute_sound()
  stop_sound(2);
  stop_sound(3);
  stop_sound(4);
end