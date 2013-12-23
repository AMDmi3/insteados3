-- $Name: ИНСТЕДОЗ 3$
-- $Version: 0.1$
instead_version "1.9.1"
require "lib"
require "para"
require "dash"
require "quotes"
require "timer"
require "xact"

main = room {
   nam = "Об игре"
  ,enter = music_("railroad",0)
  ,pic = "gfx/caption.png"
  ,dsc =
    [["ИНСТЕДОЗ 3" -- это сборник небольших текстовых игр, написанных разными авторами в рамках единого сюжета. Сборник включает в себя
      17 самостоятельных игр, однако все они складываются в отдельную историю, поэтому мы советуем вам пройти "ИНСТЕДОЗ 3" последовательно,
      начиная с пролога и до самого конца.^^
      "ИНСТЕДОЗ 3" проводился в 2013 году. В создании этого сборника принимали участие двенадцать авторов. Подробную информацию о создателях
      смотрите в разделе "Создатели".^^
      Версия 0.1]]
}

credits = room {
   nam = "Создатели"
  ,pic = "gfx/caption.png"
  ,dsc = 
    txtb("Платформа INSTEAD:").. " Пётр Косых^" ..
    txtb("Подготовка сборника:").." Василий Воронков^^"..
    txtb("Авторы игр:")..
    [[^Андрей Лобанов ("Разорванный цикл", "Сон")
      ^Антон и Ольга Колосовы ("Пробуждение-2")
      ^Василий Воронков ("Вахта", "Долгая служба", "Ремонт", "Банкет", "Крысиная нора")
      ^Дмитрий Дударь ("Пояс астероидов")
      ^Дмитрий Колесников ("Пробуждение")
      ^Егор Харват ("Подготовка к вечеринке")
      ^Максим Клиш ("Старый друг")
      ^Максим "j-maks" ("Робот, который видит...")
      ^Пётр Косых ("Отсек К007", "Прибытие")
      ^Роман "Irreman" ("Инженер")
      ^zerg.pro ("Личность")^^]]..
    txtb("Музыка:")..
    [[^8bit Betty ("Spooky Loop")
      ^J. Arthur Keenes ("The Day Before Boxing Day Eve")
      ^Rolemusic ("Ladybug Castle", "Spell", "Scape from the city", "Death on the battlefield")
      ^Goto80 ("this machine thinks", "square and enjoy", "influensa", "datagroove", "5pyhun73r 3l337 v3r")
      ^Edward Shallow ("The Infinite Railroad")
      (Подробную информацию об используемой в игре музыке см. в прилагаемом файле music.txt)
    ]]
}

function chapter(s)
  local nam = s.nam;
  s.nam = function(s)
    if iscomplete(deref(s)) then
      return img("pad:0 5 0 0,gfx/dot2.png")..nam;
    else
      return img("pad:0 5 0 0,gfx/dot.png")..nam;
    end
  end
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

test = timerpause(999, 813, "main");
test2 = room {
  nam = ""
  ,title = { "К", "Р", "Ы", "С", "И", "Н", "А", "Я", " ", "Н", "О", "Р", "А" }
  ,num = 17
}

empty = menu { nam = "" }
empty2 = menu { nam = "" }


prologue = chapter {
  nam = "Пролог"
}
rat = chapter {
  nam = "Крысиная нора"
}
longwork = chapter {
  nam = "Долгая служба"
}
repair = chapter {
  nam = "Ремонт"
}
crio = chapter {
  nam = "Отсек 007"
}
watch = chapter {
  nam = "Вахта"
}
brokencycle = chapter {
  nam = "Разорванный цикл"
}
meteor = chapter {
  nam = "Пояс астероидов"
}
robot = chapter {
  nam = "Робот, который видит"
}
engineer = chapter {
  nam = "Инженер"
}
oldfriend = chapter {
  nam = "Старый друг"
}
cook = chapter {
  nam = "Повар"
}
dream = chapter {
  nam = "Сон"
}
nightmare = chapter {
  nam = "Банкет"
}
persona = chapter {
  nam = "Личность"
}
wake = chapter {
  nam = "Пробуждение"
}
wake2 = chapter {
  nam = "Пробуждение 2"
}
arrival = chapter {
  nam = "Прибытие"
}

function init()
  take(before_About);
  take(before_Credits);
  take(empty);
  take(prologue);
  take(rat);
  take(longwork);
  take(repair);
  take(crio);
  take(watch);
  take(brokencycle);
  take(meteor);
  take(robot);
  take(engineer);
  take(oldfriend);
  take(cook);
  take(dream);
  take(nightmare);
  take(persona);
  take(wake);
  take(wake2);
  take(arrival);
end