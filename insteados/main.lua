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
    local fn = gamefile_(v..".lua");
    fn();
   end
  ,obj = {
    vobj("watch", [[{"Вахта"} Василий Воронков^]]),
    vobj("longwork", [[{"Долгая служба"} Василий Воронков^]]),
    vobj("repair", [[{"Ремонт"} Василий Воронков^]]),
    vobj("crio", [[{"Отсек 0007"} Пётр Косых^]]),
    vobj("brokencycle", [[{"Разорванный цикл"} Андрей Лобанов^]])
  }
}