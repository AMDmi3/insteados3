-- $Name: ИНСТЕДОЗ 3$
-- $Version: 0.1$
instead_version "1.9.1"
dofile "lib.lua"
require "para"
require "dash"
require "quotes"
require "timer"
require "xact"

main = room {
   nam = "ИНСТЕДОЗ 3"
  ,act = function(s,v)
    local fn = nil;
    if v == "watch" then
      fn = gamefile_("watch.lua");
    end
    fn();
   end
  ,obj = {
    vobj("watch", [[{"Вахта"} Василий Воронков]])
  }
}