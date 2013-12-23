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
  ,enter = music_("datagroove",0)
  ,pic = "gfx/caption.png"
  ,dsc =
    [["ИНСТЕДОЗ 3" -- это сборник небольших текстовых игр, написанных разными авторами в рамках единого сюжета. Сборник включает в себя
      17 самостоятельных игр, однако все они складываются в отдельную историю, поэтому мы советуем вам пройти "ИНСТЕДОЗ 3" последовательно,
      начиная с пролога и до самого конца.^^
      "ИНСТЕДОЗ 3" проводился в 2013 году. В создании этого сборника принимали участие двенадцать авторов. Подробную информацию о создателях
      смотрите в разделе "Создатели".]]
}

credits = room {
   nam = "Создатели"
  ,pic = "gfx/caption.png"
  ,dsc = 
    txtb("Платформа INSTEAD:").. " Пётр Косых^" ..
    txtb("Подготовка сборника:").." Василий Воронков^"..
    txtb("Музыка:").. " (вакантно)^"..
    txtb("Звуковые эффекты:").. " (вакантно)^^"..
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
      ^zerg.pro ("Личность")]]
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

test = timerpause(999, 813, "main");
test2 = room {
  nam = ""
  ,title = { "К", "Р", "Ы", "С", "И", "Н", "А", "Я", " ", "Н", "О", "Р", "А" }
  ,num = 17
}

empty = menu { nam = "" }
empty2 = menu { nam = "" }


prologue = chapter {
  nam = "0. Пролог"
}
rat = chapter {
  nam = "1. Крысиная нора"
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
watch = chapter {
  nam = "5. Вахта"
}
brokencycle = chapter {
  nam = "6. Разорванный цикл"
}
meteor = chapter {
  nam = "7. Пояс астероидов"
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

nightmare = chapter {
  nam = "10. Банкет"
}

oldfriend = chapter {
  nam = "11. Старый друг"
}

wake2 = chapter {
  nam = "12. Пробуждение-2"
}

robot = chapter {
  nam = "14. Робот, который видит..."
}

dream = chapter {
  nam = "15. Сон"
}


persona = chapter {
  nam = "16. Личность"
}

arrival = chapter {
  nam = "17. Прибытие"
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
  
  take(empty2);
  take(wake);
  take(cook);
  take(engineer);
  take(nightmare);
  take(oldfriend);
  take(wake2);
  take(robot);
  take(dream);
  take(persona);
  take(arrival);
end