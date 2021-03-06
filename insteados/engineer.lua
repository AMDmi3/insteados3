-- $Name: Инженер$
-- $Version: 0.1$
instead_version "1.9.1"
require "lib"
require "para";
require "dash";
require "quotes";
require "timer";
require "xact";
require "hideinv";

game.use = 'Что-то не то.';
forcedsc = true;

global {
	sc = 0;
	Oxigen = 12;
	vc = 0;
	bolt = 11;
	q = 0;
};

main = timerpause(315, 105, "main2");

main2 = room {
	nam = '...';
  title = { "И", "Н", "Ж", "Е", "Н", "Е", "Р" };
  num = 9;
  enter = music_("spookyloop",0);
	dsc = 'Сознание толчками выплывало откуда-то из молочно-белого океана. Зрение с трудом сфокусировалось, что-то ярко-красное мигает прямо перед глазами. Это текст, сияющая надпись. Он все-таки смог распознать буквы.^^"Внимание. Аварийное пробуждение."^^Но смысл их ускользал обратно в белый океан спящего сознания. Впрочем вдолбленный в космошколе рефлекс сработал как нужно. Правая рука конвульсивно дернула рычаг, на котором и лежала все это время и запотевшая крышка с грохотом отвалилась. Он выпал из капсулы на пол.';
	act = function() walk(cabin) end;
  obj = { vobj("next", "{Далее}") }
};

cabin = room {
	nam = 'Криокамерный отсек';
  pxa = {
    { "crio", 300 }
  };
	dsc = 'Через некоторое время он смог подняться с пола, хватаясь за стенку непослушными руками. Что-то в подсознании не дало ему просто лежать дальше. Упершись лбом в стенку он решил немного отдышаться. В полированной металлической стенке отражался слегка небритый худощавый субъект в спецовке. На кармане желтела {xwalk(stripe)|какая-то нашивка}.';
};

stripe = room {
	nam = 'Криокамерный отсек';
  pxa = {
    { if_("vc==1","door2_open","door4"), 10 },
    { "panel", 150 },
    { "crio", 300 }
  };
	enter = function()
		if visits() == 0 then p '"Вереск" -- было написано на нашивке. На этот раз чтение уже не стало проблемой как раньше.^-- Это нормально после криосна. -- откуда-то пришла мысль. Остальная память пока не отвечала, но возвращение своего имени уже приободрило его. Он оглянулся.';
		end;
		Ox();
	end;
	dsc = 'Вереск находился в покрытом пылью отсеке.';
	obj = {'criocabin', 'case', 'hatch'};
};

criocabin = obj {
	nam = 'Криокамера';
	dsc = 'У стены установлена {криокамера}, в которой он и находился ранее в анабиозе.';
	act = function()
		if vc == 0 and q == 2 then p 'Вереск снял скафандр, положил в шкафчик гиперключ и залез обратно в криокамеру. Кажется наконец все закончилось.';
			walk(happyend);
		elseif q == 2 then p 'Камера готова к использованию, только вот в скафандре туда не залезешь, а снять его в вакууме тоже не получится.';
		else p 'Краткий осмотр показал, что потекло соединение одного из шлангов с баллоном криожидкости. Видимо когда давление упало ниже критического уровня криокамера инициировала экстренное пробуждение. Индикатор на баллоне показывает, что криожидкости почти не осталось.';
		end;
	end;
};

case = obj {
	nam = 'Шкафчик';
	dsc = 'На стене закреплен {небольшой шкафчик}.';
	act = function()
		if have 'hyperkey' then
			p 'Больше ничего интересного тут нет.';
		else
			p 'В шкафчике оказался простой гиперключ и сложенный мягкий скафандр.';
			take 'hyperkey';
			take 'vsuit';
		end;
	end;
};

hatch = obj {
	nam = 'Люк';
	dsc = function()
		if seen('deck', ways(here())) then p 'За {открытой гермодверью} виден тускло освещенный коридор.';
		else p 'На {панели у выходного люка} мигает огонек.'; end;
	end;
	act = function()
		walk(crio_dlg);
	end;
};

hyperkey = obj {
	nam = 'Гиперключ';
	inv = 'Это простой гиперключ, применяемый для ремонтных работ. Открутить, закрутить. При этом достаточно увесистый и может применяться и в других целях. Верный спутник технаря. Индикатор мигает зеленым, заряда еще достаточно.';
	use = function(s,w)
		if w == door then
			bolt = bolt - 1;
			p('Вереск захватил гиперключом одну из крупных болтовых шляпок на двери. Минута работы и болт упал на пол. Осталось '..bolt..'.');
			Oxigen = Oxigen - 1;
		elseif w == window then p 'Вереск с размаху ударил по стеклу иллюминатора. Но результат оказался скромным. Только небольшая царапина.';
			Oxigen = Oxigen - 1;
		elseif w == criocabin2 then p 'Немного повозившись при помощи гиперключа Вереск скрутил баллон.';
			Oxigen = Oxigen - 1;
			take 'ballon';
		elseif w == case2 then p 'Хороший удар гиперключом и шкафчик не особо и пострадал. Нужно что-то потяжелее.';
		else p 'Гиперключ тут не поможет.';
		end;
		if Oxigen == 0 then
			p 'Запас кислорода подошел к концу, темные пятна заплясали в глазах. Вереск споткнулся и упал на пол.';
			walk(badend);
		end;
	end;
};

key = obj {
	nam = 'Магнитный ключ';
	inv = 'Ключ открывает некоторые двери соответственно уровню доступа.';
	use = function(s,w)
		if w == gate then
      gate._open = true;
			p 'Вереск вставил карту в слот и переборка начала медленно подниматься. За переборкой оказался знакомый участок коридора.';
			ways():add('right');
		elseif w == door then p 'Ключ подошел. Дверь открылась. Вереск сразу схватил один из баллонов с кислородом и подключил его к скафандру. Больше ничего интересного тут нет.';
			Oxigen = 10;
			objs():del('door');
			objs():del('window');
		else p 'Ключ еще пригодится.';
		end;
	end;

};

ballon = obj {
	nam = 'Баллон криожидкости';
	inv = 'Баллон с криожидкостью, необходимой для анабиоза.';
	use = function(s,w)
		if w == case2 then p 'Хороший удар баллоном и шкафчик распахнулся. Кроме такого же скафандра, как надетый на Вереске, из шкафчика выпала магнитная карта-ключ.';
			take 'key';
		elseif w == criocabin then
			p 'Вереск приделал свежий баллон к криокамере. Теперь еще на 500 лет хватит.';
			inv():del('ballon');
			q = 2;
		else p 'Баллон криожидкости еще пригодится.';
		end;
	end;

};

vsuit = obj {
	nam = function()
		if sc == 0 then p 'Скафандр';
		else p 'Скафандр (надет)';
		end;
	end;
	inv = function()
		if sc == 0 then p 'Это обычный корабельный скафандр типа "снегирь". Подумав, Вереск натянул его на себя. Кажется скоро он пригодится.';
			sc = 1;
		elseif vc == 1 then p 'Снимать скафандр в вакууме явно не лучшая идея.';
		else
			p 'Это обычный корабельный скафандр типа "снегирь". Подумав, Вереск снял скафандр. Кажется пока он не нужен.';
			sc = 0;
		end;
	end;
};

crio_dlg = dlg {
	nam = 'Гермодверь';
  pxa = {
    { "panel", 217 }
  };
	enter = function()
		p 'Мигающий красный индикатор предупреждает об отсутствии атмосферы за дверью.';
		if vc == 0 then pon 'open';
		elseif vc == 1 then pon 'close';
		end;
	end;
	phr = {
		{tag = 'open', false, 'Открыть гермодверь.', code[[if sc == 0 then
			p 'Индикатор не врал, за дверью оказался вакуум. Теперь неплохо сохранившееся тело Вереска найдут только через пару сотен лет.';
			walk 'badend';
		else p 'Скафандр оказался весьма кстати. Воздух из отсека с криокамерой со свистом рванулся в вакуум. Вереск посмотрел на индикатор кислорода. Это может стать проблемой, если не начать действовать.';
		inv():add('status', 1);
		ways(from()):add('deck');
		vc = 1;
		back();
		end;]]};
		{tag = 'close', false, 'Закрыть гермодверь.', code[[
		p 'Гермодверь закрылась и автоматически воздух с шипением стал заполнять помещение. Теперь можно снять скафандр.';
		inv():del('status');
		ways(from()):del('deck');
		vc = 0;
		back();]]};
		{always = true, 'Отойти.', nil, [[back();]]};
	};
};

badend = room {
	nam = 'Конец';
	hideinv = true;
	dsc = 'Это конец.';
  act = gamefile_("engineer.lua");
  obj = { vobj("next", '{Начать с начала?}') }
};

status = stat {
	nam = function()
		local i;
		for i = 1, Oxigen do
			p (img 'box:4x6,cyan,128');
		end;
		p '^';
	end;
};

deck = room {
	nam = 'Палуба';
  pxa = {
    { "window", 100 },
    { "door1_open", 190 },
    { "window", 380 }
  };
	enter = function()
		Ox();
	end;
	dsc = 'Покрытые каким-то налетом стенные световые панели едва светили. Направо или налево?';
	way = {vroom('Налево', 'left'), 'stripe', vroom('Направо', 'right')};
};

left = room {
	nam = 'Палуба';
  pxa = {
    { "hatch", 20 },
    { "hole", 60 },
    { "window", 400 }
  };
	enter = function()
		Ox();
	end;
	dsc = 'Вскоре Вереск уперся в одну из {pere|автоматических переборок}, опускающихся при разгерметизации. А в стене коридора нашел и причину.';
	way = {vroom('К криоотсеку', 'deck')};
	obj = {'hole', xact('pere', 'Эта переборка поднимется только если Вереск восстановит давление в коридоре.')};
};

right = room {
	nam = 'Палуба';
  pxa = {
    { if_("exist(door)","door1","door1_open"), 10 },
    { "window", 140 },
    { "hatch", 400 }
  };
	enter = function()
		Ox();
	end;
	dsc = 'Вскоре Вереск уперся в одну из {pere|автоматических переборок}, опускающихся при разгерметизации.';
	way = {vroom('К криоотсеку', 'deck')};
	obj = {'door', 'window', xact('pere', 'Эта переборка поднимется только если Вереск восстановит давление в коридоре.')};
};

door = obj {
	nam = 'Дверь';
	act = function()
		p 'Замок двери активируется или голосовой командой, или магнитным ключом. Вариант с голосом в вакууме не пройдет. А ключа у Вереска нет. Может все-таки поискать выход в другой стороне?';
		q = 1;
	end;
	dsc = 'Зато в стене коридора обнаружилась {дверь}';
};

window = obj {
	nam = 'Иллюминатор';
	act = 'Сквозь мутное стекло видны баллоны с кислородом и какие-то ящики. Кажется это одна из аварийных кладовых.';
	dsc = 'с {иллюминатором}.';
};

hole = obj {
	nam = 'Дыра';
	act = function()
		p 'Вереск выглянул наружу и повертев головой обнаружил на обшивке корабля скобы для ремонтников.';
		ways():add('cover');
	end;
	dsc = function()
		if q == 0 then p 'Сквозь огромную дыру с рваными краями мрачно светили звезды.';
		else p 'Сквозь {огромную дыру с рваными краями} мрачно светили звезды.';
		end;
	end;
};

cover = room {
	nam = 'Обшивка';
  pxa = {
    { "hole2", 50 }
  };
	enter = function()
		Ox();
		if have 'ballon' then Oxigen = Oxigen - 2;
			p 'Баллон все время мешался и Вереск истратил много времени и ругательств на дорогу.';
		end;
	end;
	dsc = 'Вереск выбрался наружу и цепляясь за скобы осторожно стал перемещаться по корпусу корабля. Вскоре он наткнулся на еще одну дыру в корпусе. Кажется корабль попал в серьезную переделку.';
	way = {vroom('Вернуться', 'left'), vroom('Влезть в дыру', 'cabin2')};
};

cover2 = room {
	nam = 'Обшивка';
  pxa = {
    { "hole2", 300 }
  };
	enter = function()
		Ox();
		if have 'ballon' then Oxigen = Oxigen - 1;
			p 'Баллон все время мешался и Вереск истратил много времени и ругательств на дорогу.';
		end;
	end;
	dsc = 'Наконец Вереск добрался до первой дыры.';
	way = {vroom('Вернуться', 'cabin2'), vroom('Влезть в дыру', 'left')};
};

Ox = function()
	if vc == 1 then Oxigen = Oxigen - 1; end;
	if Oxigen == 0 then
		p 'Запас кислорода подошел к концу, темные пятна заплясали в глазах. Вереск споткнулся и упал на пол.';
		walk(badend);
	end;
end;

cabin2 = room {
	nam = 'Отсек';
  pxa = {
    { "door2_open", 10 },
    { "panel", 150 },
    { "crio", 300 }
  };
	enter = function()
		Ox();
	end;
	dsc = 'Вереск попал в такой же отсек, как и его собственный.';
	obj = {'criocabin2', 'case2'};
	way = {vroom('Вылезти в дыру', 'cover2'), vroom('Выйти через дверь', 'deck2')};
};

criocabin2 = obj {
	nam = 'Криокамера';
	dsc = 'У стены установлена {криокамера} с разбитой крышкой. Но тела внутри почему-то не оказалось.';
	act = function()
		p 'Баллон с криожидкостью цел. Это хорошая новость.';
	end;
};

case2 = obj {
	nam = 'Шкафчик';
	dsc = 'На стене закреплен {небольшой шкафчик}.';
	act = 'Шкафчик заперт.';
};

deck2 = room {
	nam = 'Палуба';
  pxa = {
    { "window", 100 },
    { "door1_open", 190 },
    { "window", 380 }
  };
	enter = function()
		Ox();
	end;
	dsc = 'Покрытые каким-то налетом стенные световые панели едва светили. Направо или налево?';
	way = {vroom('Налево', 'left2'), 'cabin2', vroom('Направо', 'right2')};
};

left2 = room {
	nam = 'Палуба';
  pxa = {
    { if_("gate._open", "hatch2", "hatch"), 50 },
    { "window", 120 },
    { "window", 420 }
  };
	enter = function()
		Ox();
	end;
	way = {vroom('Назад', 'deck2')};
	obj = {'gate'};
};

right2 = room {
	nam = 'Палуба';
  pxa = {
    { "hatch", 50 },
    { "window", 120 },
    { "window", 420 }
  };
	enter = function()
		Ox();
	end;
	dsc = 'Вскоре Вереск уперся в одну из {pere|автоматических переборок}, опускающихся при разгерметизации.';
	way = {vroom('Назад', 'deck2')};
	obj = {xact('pere', 'Эта переборка поднимется только если Вереск восстановит давление в коридоре.')};
};

gate = obj {
	nam = 'Переборка';
	act = 'Впрочем на этой переборке имеется панель управления со слотом под магнитную карту.';
	dsc = 'Вскоре Вереск уперся в одну из {автоматических переборок}, опускающихся при разгерметизации.';
};

happyend = room {
	nam = 'Конец';
  enter = function() mute_()(); complete_("engineer")() end;
	dsc = 'Это и правда конец, полет продолжается, экипаж спит.';
	hideinv = true;  act = gamefile_("oldfriend.lua")
  ,obj = { vobj("next", txtc("^{КОНЕЦ?}")) }
};