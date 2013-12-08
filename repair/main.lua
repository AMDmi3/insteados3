-- $Name: Ремонт$
-- $Version: 0.1$
instead_version "1.9.1"
require "para"
require "dash"
require "quotes"
require "xact"

game.use = "Нет, думаю так делать не стоит."
local old = obj;
function tcall(f,s)
  if type(f) == "function" then
    return tcall(f(s),s);
  else
    return f;
  end
end
function obj(tab)
  if tab.nam == nil then tab.nam = "" end
  local dsc = tab.dsc;
  tab.dsc = function(s)
    if s.cnd == nil or s:cnd() then
      return tcall(dsc,s);
    end
  end
  return old(tab);
end

main = room {
   nam = "Ремонт"
  ,act = function(s) walk("crio") end
  ,dsc = "Ну и дела! Мне через пару часов в холодильник отправляться, а главный инженер меня к себе вызывает -- говорит, неотложные проблемы какие-то, никто кроме меня помочь не может.^Прихожу, а оказывается, что в K007 все криокапсулы отрубились. Ремонт требуется.^-- Ну, а роботы на что? -- спрашиваю я. -- Они же должны такими вещами заниматься.^-- Вот они и постарались, -- говорит главный инженер. -- Пришел тут один лампочку заменить. Свет говорит, да. Но зато весь криоблок отрубился.^Ну и дела!"
  ,obj = { vobj("next", '{Начать игру}') }
}

crio = room {
   nam          = "К007"
  ,dsc          = "Я в криоблоке К007. Здесь стоят шесть крио-капсул."
  ,obj          = { }
}

capsula = obj {
   _exam        = false
  ,dsc          = "На одной из {капсул} можно заметить подпалинку."
  ,act          = function(s)
                    if not s._exam then
                      s._exam = true;
                      return "Я осматриваю капсулу. Всё понятно, сгорел трансформатор.";
                    else
                      return "Я уже разобрался, в чём проблема.";
                    end
                  end
}

burnblock = obj {
   dsc          = "Судя по всему, сгорел {трансформатор}. Думаю, достаточно будет заменить его на запасной, и всё заработает."
  ,act          = "Нет, тут нужны инструменты."
  ,cnd          = function() return capsula._exam end
}

toolbox = obj {
   dsc          = "На полу стоит мой {ящик с инструментами}."
  ,act          = function()
                    if not have(screw) then
                      take(screw);
                      return "Я взял из ящика с инструментами свою электрическую отвёртку. Что ж, дело осталось за малым.";
                    else
                      return "Я уже взял всё, что мне нужно.";
                    end
                  end
}

screw = obj {
   nam          = "Отвёртка"
  ,inv          = "Моя любимая электрическая отвёртка. Всегда выручает."
}