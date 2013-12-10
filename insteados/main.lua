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
   nam = "Об игре"
  ,dsc = "Что-то об игре"
}

credits = room {
   nam = "Создатели"
  ,dsc = "Создатели игры"
}

function chapter(s)
  s.inv = function(s)
    local nm = deref(s);
    gamefile_(nm..".lua")();
  end
  return menu(s);
end

before_About = menu {
   nam = "Об игре"
  ,inv = function() walk(main) end
}

before_Credits = menu {
   nam = "Создатели"
  ,inv = function() walk(credits) end
}

empty = menu { nam = "" }

watch = chapter {
  nam = "1. Вахта"
}

longwork = chapter {
  nam = "2. Долгая служба"
}

repair = chapter {
  nam = "3. Ремонт"
}

crio = chapter {
  nam = "4. Отсек 007"
}

brokencycle = chapter {
  nam = "5. Разорванный цикл"
}

meteor = chapter {
  nam = "6. Пояс астероидов"
}

wake = chapter {
  nam = "7. Пробуждение"
}

cook = chapter {
  nam = "8. Подготовка к вечеринке"
}

engineer = chapter {
  nam = "9. Инженер"
}

function init()
  take(before_About);
  take(before_Credits);
  take(empty);
  take(watch);
  take(longwork);
  take(repair);
  take(crio);
  take(brokencycle);
  take(meteor);
  take(wake);
  take(cook);
  take(engineer);
end