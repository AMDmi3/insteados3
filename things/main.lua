-- $Name: Неизбежные вещи$
-- $Version: 0.1$
-- $Author: Николай Коновалов$ 
instead_version '1.9.1'
require 'xact'
require 'nouse'
require 'wroom'
require "hideinv"
require 'format'
format.para 	= true	-- отступы в начале абзаца;
format.dash 	= true	-- замена двойного - на длинное тире;
format.quotes 	= true	-- замена " " на типографские << >>;
game.use = function()
	ans = { "А это тут причем?";	"Не стоит отвлекаться."; "Куда-то не туда мыль завела..."; "Э... О чем это я?.."	};
	p (ans[rnd(#ans)]);
end
main = room{
	nam = "Неизбежные вещи",
	enter = function() walk "plot0"; end,
};
plot0 = room{
	nam = "...",
	forcedsc = true;
	var{	part = 1; };
	enemy = "Кусочки его лица приходится вылавливать между красных пятен. Одно перекрывает нос... Но и видимых деталей достаточно, чтобы понять: \"Они нашли меня\".";
	dsc = function(s)
		pn();
		if s.part == 2 then	p "{he|Он}"; else	p "Он"; end
		p "поддерживает мою голову и пристально вглядывался в лицо, словно стараясь запечатлеть мельчайшую черточку.^ А, может, у них нет камеры? Тогда действительно запоминает. Я с трудом фокусирую взгляд,";
		if s.part == 3 then
			p "{blood|красная пелена}";
		else
			p "красная пелена";
		end
		p "застилает мой взор..."; 
		if s.part == 1 then
			p "^^^ {next|Вглядеться}";
		end
	end;
	obj = {
		xact("next", code[[plot0.part = 2; return true;]]),
		xact("he", code[[p (plot0.enemy); plot0.part = 3; return true;]]);
		xact("blood", code[[walk ("plot"); return true;]] ),
	},
};
plot = room{
	nam = "...";
	entered = "\"Вжи-и-и-п\" -- что-то скрипнуло у самого лица. Видимость немного улучшилась и пятна перестали туманить взгляд. Я скашиваю глаза и узнаю в мелькнувшей полоске меленький дворник.^ Ну да, в моем шлеме есть такой! Это хорошо. Значит, глаза меня не подводят.",
	dsc = nil;
	take_blood = function()
		p "Я стараюсь вдохнуть поглубже...^ Острая пронзает мою грудь и словно что-то тяжелое на неё опускается. Паника захлестывает.^ Я пытаюсь отодвинутся от страшной железки - и не могу пошевелится. Я пытаюсь повернуть голову - и ничего. Стараюсь пошевелить хоть чем-то - и не чувствую тела.^ Я хочу вдохнуть, но ком в горле не дает мне этого сделать. Пытаюсь прокашляться..."; 
		take "blood"; 
	end,
	obj = {
		"had", "pin";
		xact("breast", code[[plot:take_blood();]]),
	};
};
had = obj{
	nam = "Противник",
	dsc = function(s)
		if s._lvl == 1 then
			p "{Он}, очевидно, стоит передо мной на коленях.";
		elseif s._lvl == 2 then
			p "Он встретился со мной взглядом и замер. Что-то крикнул по радио и бережно приподнял мою голову, чтобы свет попал на лицо.";
		elseif s._lvl > 2 and s._lvl < 9 then
			p "{Убийца} смотрит куда-то в сторону, его губы шевелятся...";
		elseif s._lvl >= 9 and s._lvl < 11 then
			p "На мгновенье меня накрыла тень. {Стоявший предо мной} провел отбросившего её взглядом.";
		elseif s._lvl >= 11 then
			p "{Убийца} склонил голову так низко, что наши шлемы соприкоснулись.";
		end
	end,
	_lvl = 1;
	desc = {
		"- Эй! Он, кажется, жив, - читаю я по губам. В принципе, мой скафандр может подстроится под их волну, но для этого нужно найти силы скомандовать.";
		"- БД нашли? ^ - ... - пауза. Очевидно, говорят другие.^ - Отлично.";
		"^ - Да он просто исполнитель!^ - ...";
		"- ... ^ - Убери! Они заметят дыру от термоснаряда!^ - ... 	^ - ... ^ - Вот-вот. А на фоне потрескавшейся оболочки, никто и не заметит в скафандре маленький прокол.";
		"- ...? - скорее всего, это был вопрос. Мой убийца задумался.";
		"- Да, разряд из ионистра его точно поджарит.";
		"- Погоди! При тщательном вскрытии это всплывет. Не стоит рисковать. ^ - ... 	^ - Да, опасно. Но может он и так подохнет?	^ - ...	^ - Ты после такой раны уже бы в котлах варился.";
		"- ...	^ - Сейчас гляну.";
	};
	act = function(s)
		if s._lvl == 1 then
			p "Я снова взглянул на него. Вполне стандартное европейское лицо с чрезвычайно большим, прямо-таки гигантским носом. Наше бюро особо любит такие шнобели за то, что люди концентрируются на нем одном и, потом, больше ничего вспомнить не могут.";
			s._lvl = 2;
			enable "pin";
		else
			if s._lvl-3 < #s.desc then
				s._lvl = s._lvl + 1;
				p (s.desc[s._lvl - 3]);
				if s._lvl == 7 then
					take "puncture";
				elseif s._lvl == 5 then 
					take "mis_failed";
				end
			else
				local a = { "- Эй, ты живой? - доносится до меня его голос. ^ Я закрываю глаза, в надежде обмануть. Но он тормошит меня и от боли веки сами распахиваются. Мучитель хмурится.";
					"- У нас есть аптечка!";
					"- Ау, ты слышишь меня? Моргни в знак согласия!";};
				p (a[rnd(#a)]);
			end
		end
	end,
	used = function(s, w)
		if w == puncture then
			p "Так он мне и объяснит...";
		end
	end,
};
pin = obj{
	nam = "Штырь",
	dsc = function(s)
		if had._lvl == 2 then
			p "^В поле зрения появился {штырь}.";
		else
			p "^Из моей груди торчит {штырь}.";
		end
	end,
	act = function(s)
		p "Заостренный на конце металлический штырь, в два пальца толщиной. Серебристую поверхность покрывает красная пленка. Чем ниже опускается мой взгляд, тем плотнее она покрывает стержень. И так до тех пор, пока не скрывается в озерце кипящей в вакууме крови. Штырь торчит аккурат меж двух {breast|нагрудных} карманов моего скафандра...";
		if had._lvl == 2 then
			had._lvl = 3;
		end
	end,
}:disable();
blood = obj{
	nam = "Кровь",
	dsc = nil;
	inv = function(s)
		p "Рот наполняет солоноватая жидкость, не вздохнуть!.. Я выжимаю в кашле еще чуть-чуть воздуха - и сплевываю пробку.";
		drop "blood";
	end,
	use = function(s, w)
		if w == had and w._lvl >= 11 then
			p "Я набираю побольше воздуха и лицо не притворно кривится от боли. Ловлю взгляд убийцы, тот сгибает шею, уже почти упирается носом в щиток... ^ И я плюю сквозь смеженные зубы! Розовые брызги шикарно залепляют с половину стекла. Закатываю глаза. Ужасно хочется увидеть его реакцию - но нельзя. Сердце отсчитывает десятый удар, когда он убирает руку и шлем ударяется о перекрытие. Я ликую, несмотря на нахлынувшее головокружение...^ Меня переворачивают! Боль выжигает мир, когда штырь соударяется с полом и я почти не замечаю тяжести чьего-то сапога на моей спине. О нет! Сейчас выде...^^ {start|>>>}";
			drop(s);
			path("control_cabin", rocket_centre):disable();
			path("stern", rocket_centre):disable();
			walk "rocket_centre";
		end
	end,
};
rocket_centre = room{
	nam = "Грузовая площадка",
	_was = 1;
	dsc = function(s)
		if s._was == 1 then
			return nil;
		elseif s._was == 2 then
			p "^^^^^^{next|Вжи-и-и-п}";
		elseif s._was == 3 then
			p "^^Назойливый шум на задворках сознания... ^Назойливый гул вне зоны внимания... ^Пульсирующая нить сквозь Я...^^ {next|>>>}";
		elseif s._was == 4 then
			p "^^Назойливый шум на задворках сознания... ^Назойливый гул вне зоны внимания... ^Пульсирующая нить сквозь Я...^^ {next|ВЖИ--И--И--П}";
		elseif s._was == 5 then
			p "Глаза распахиваются и внешний мир бесцеремонно вторгается по моей сенсорной системе. Назойливый звук снова повторяется, что-то сбоку давит на кончик носа. Потом перестает и снова поскрипывает.^ Дворник. Точно. Я лежу на животе, лбом упершись в смотровой щиток собственного шлема. Заляпанный кровью щиток. Который дворник старается очистить, но упирается в мой нос.^^ {refresh|>>>}";
			enable "miracle";
			s.forcedsc = false;
			s._was = 6;
			enable "containers";
			enable "space1";
			enable "corpse";
		elseif s._was == 6 then
			s._was = 7;
			return nil;
		else
			p "Ракеты этого класса представляют собой вытянутый прямоугольник \"киля\", в котором сосредоточены все органы ракеты: от навигационного компьютера, до движущего реактора. Сверху кладут пластину - \"плато\" - которая служит грузовым отсеком. Всё.";
		end
	end,
	entered = function(s)
		if control_cabin._was and stern._was then
			take "alone";
		end
	end,
	start = function(s)
		s.forcedsc = true;
		s._was = 2;
	end,
	obj = {
		"miracle", "containers", "space1", "corpse";
		xact("start", code[[rocket_centre:start(); return true;]]),
		xact("next", code[[rocket_centre._was = rocket_centre._was + 1; return true;]]),
		xact("refresh", code[[path("control_cabin",rocket_centre):enable(); path("stern", rocket_centre):enable(); return true;]]);
	},
	way = {
		"control_cabin", "stern";
	};
};
stranger =	xact("stranger", code[[ p"Так проект числится в наших записях. Кажется, подобное имя использует и Китай. Русские называют его \"Королёв\". Мне думается, официальным именем станет какая-то западная толерантно-мифическая ерунда, вроде Орфея..."; take "ship"]]);
containers = obj{
	nam = "_",
	dsc = "Я нахожусь на рукотворном \"плато\" посреди ничто. Большая его часть заставлена {контейнерами}, но посредине оставлена дорожка.",
	see = false,
	act = function(s)
		if not s.see then
			p "Контейнеры обладали специальными пазами и при транспортировке собирались в огромные блоки. Оставалось укрепить их в посадочных гнездах и можно быть уверенным, что они не улетят в открытый космос.";
			s.see = true;
		else
			p "Каждый контейнер запирается на магнитный замок - чтобы случайно не раскрылся при полете. Или чтобы рабочие не шарили в них...";
		end
	end,
}:disable();
space1 = obj{
	nam = "_",
	dsc = "Это дает ощущение защищенности, так как человеческая психика сильно сдает при длительном общении с безбрежными просторами {космоса}.",
	act = function(s)
		if have "burn_up" and have "broken_panel" then
			walk "end_of_story";
		else
			p "Я поднял взгляд кверху и увидел профиль гигантского остова \"{stranger|Скитальца}\". Мой вестибулярный аппарат тут же взбунтовался, так как я привык летать в его плоскости и использовать Корабль как маяк. А тут оказалось, что мой \"вверх\" оказался \"боком\" и мозг тут же начал поворачивать \"пол\".";
		end
	end,
}:disable();
control_cabin = room{
	nam = "Рубка",
	_was = false;
	entered = function(s)
		s._was = true;
	end,
	dsc = "Гордое название \"рубка\" эти пару квадратных метров получили в дань традиции.",
	obj = {
		"chair", "space2", "control_panel", "radio"; 
		xact("overhang", "Знавал я одного мужика из Китая, который лично контролировал посадку, обхватив ногами тумбу стула и свесив голову за край \"плато\".");
		xact("tak_moon", code[[take "moon"; return true;]]);
	},
	way = { "rocket_centre", };
};
chair = obj{
	nam = "_",
	dsc = "{Кресло} приварено на самом краю \"плато\",",
	act = function(s)
		p "Два стальные пластины сваренные перпендикулярно и покрытые инертным пластиком. Эта конструкция снабжена ремнями и поставлена на тумбу, которая укрывает куцый \"мозг\" ракеты.";
	end,
};
space2 = obj{
	nam = "_",
	dsc = "так что пилот получает в обозрение всю полу-сферу {пространства} перед ракетой.",
	act = function(s)
		if have "burn_up" and have "broken_panel" then	walk "end_of_story";
		else	p "Весь нижний угол занимает белый лик {tak_moon|Луны} и краешек Земли.";
		end
	end,
};
control_panel = obj{
	nam = "_",
	dsc = "Небольшой клочок, конечно, перекрывает {панель управления}, но всегда можно {overhang|свесится} через неё.",
	_see = false;
	act = function(s)
		if not s._see then
			p "Вообще-то, эта модель ракеты управляется автопилотом. На ней даже запрещено перевозить людей. Но из-за дешевизны их закупают сотнями, врезают в компьютер пульт - и отдают рабочим. Подобное неизбежно, когда правила безопасности диктует главный ракетостроитель.";
			s._see = true;
		else
			if not have "burn_up" then
				p "Сначала нужно разобраться во всем этом! Вдруг они знали, что я выживу и ждут пока я приведу их к Бюро?...";
			else
				p "\"Нужно срочно менять траекторию!\" - истерично мечется в моей голове одна-единственная мысль. Я хватаюсь за рычаги, вношу коррекцию - и ничего.^  \"Что за...\" - начинаю думать и тут же спрыгиваю со стула. Панели управления вынесена вперед на пластмассовой ножке. К ней крупными скобами прибит кабель. Вот он перелазит на тумбу, спускает ниже... Обрыв! Толстый кабель потерял в этом месте всю свою оплетку и чем-то перекушен. Теперь ракета неуправляема.";
				take "broken_panel";	
			end
		end
	end,
};
radio = obj{
	nam = "_",
	dsc = "^Скромная коробочка с компьютером ручного управления и {радио} упрятана под стул.",
	_check = false;
	act = function(s)
		if not s._check then
			pn "Я командую скафандру установить связь с рацией - но получаю ошибку в ответ. Повторяю попытку - \"Устройство не отвечает\".";
			s._checl = true;
		end
		p "Опускаюсь на колени перед тумбой, вскрываю её. Моим глазам открывается огромное черное пятно и ошметки текстолита. Наружу выплывает бесформенный комок метала - все что осталось от системы термобаланса. Я ошеломленно беру его в руки. Осматриваю. С одной стороны металл имеет странный бирюзовый оттенок... ^ Бомба! Часть вещества не детонировала и осела на металле...";
		broken_panel._radiooff = true;
	end,
};
stern = room{
	nam = "Корма",
	_was = false;
	dsc = nil,
	entered = function(s)
		s._was = true;
	end,
	obj = {
		"space3", "jet";
		xact("tak_jet", code[[take "jet_mind"; return true;]]),
	},
	way = { "rocket_centre", };
};
space3 = obj{
	nam = "_",
	dsc = "Ряд контейнеров резко обрывается и взору предстает колоссальная {пустота}, густо приправленная звездами.",
	act = function(s)
		if have "burn_up" and have "broken_panel" then	walk "end_of_story";
		else 
			p "Судя по открывшемуся виду, ракета летит куда-то прочь от ядра Стройки... Пространство тут не так загажено выхлопом, да и кораблей куда меньше, чем я привык...^ Эй, а это что?! Одно {space3|судно} словно зависло в пространстве. А это может означать только одно - оно следует той же траекторией, с той же скоростью...";
		end
	end,
};
jet = obj{
	nam = "_",
	dsc = "{Сопло} двигателя старательно разбавляет межгалактический хаос своим упорядочено-конусообразным выхлопом.",
	act = function(s)
		if not have "burn_up" then
			pn "Сопло представляет из себя огромную магнитную катушку, что концентрирует распавшееся вещество в реактивную струю.";
			if not have "jet_mind" then
				p "Отработавшая нейтронная {tak_jet|плазма} стоимостью с приличный коттедж просто распыляется в пространстве. Хорошо, что её собирают зонды.";
			end
		else
			if have "broken_panel" then
				p "Прыгнуть в ядерный факел? Самоубийство - не выход!";
			else
				p "Если бы мне удалось его наклонить... Но нет. Сопло - часть \"киля\".";
			end
		end
	end,
};
ship = obj{
	nam = "Корабль",
	inv = "Строительство идет восьмой год, а мы только завершаем шпангоуты... Говорят лишь одна очистка воздуха пожирает столько энергии, как Лас-Вегас.";
};
moon = obj{
	nam = "Луна",
	inv = function(s)
		p "Виднеется пояс фотоприемников. Любопытно, что все там построено получены из реголита - лунной пыли, ошметков разбившихся о Луну метеоритов.";
	end,
	use = function(s, w) s:used(w) end;
	used = function(s, w)
		if w == jet_mind then
			p "\"Поля\" фотоприемников поместили на Луну только из-за реголита. Богатая на элементы лунная пыль послужила отличным сырьем для строительства. В остальном это была классическая цепочка Ньюманна с синтезом энергоемкого вещества (первоначально, урана) и транспортировкой его к реакторам. КПД такой системы около 13%, но при таких масштабах это никого не смущало.^ Кроме парней из Стразбургского университета, которые и придумали перенести синтез на орбиту Земли, выиграв еще три с четвертью процента.";
			take "satellite";
		elseif w == satellite then
			p "Энергия с Луны на спутники передается лазером.";
			take "communication_laser";
		elseif w == ship then
			p "И лунные \"поля\" и {stranger|Корабль} называют эпохальными событиями. Ха, много ли историки понимают! По техническим данным мы могли начать оба проекта минимум на пол столетия раньше. Но, как и в случае с Луной, никто не хотел вкладывать ресурсы в такой дорогой проект - и обескровить, тем самым, себя лет на двадцать. Бюро всерьез интересуется причинами столь серьезных перемен...";
		end;
	end,
};
jet_mind = obj{
	nam = "Нейтронное топливо",
	inv = function(s)
		if have "communication_laser" then
			p "Аккумулированная фотополями Луны энергия пересылается лазером (в виде волны) на орбитальные приемники, где происходит синтез.";
		else
			p "Синтез нейтронного вещества - жутко энергоемкая штука. Земля-матушка столько не выдает...";
		end
	end,
};
satellite = obj{
	nam = "Энерго-приемники",
	inv = "Огромная концентрирующая тарелка, резервуары с водородом и реактор. Их вещают на жуткую эллипсоиду, чтобы увеличить время прямой видимости с Луной.";
	used = function(s, w)
		if w == ship then
			p "Рядом с {stranger|Кораблем} зависли три таких.";
		elseif w == jet_mind then
			p "С помощью полученной энергии на спутниках производится синтез вещества. В том числе - и нейтронного топлива";
		elseif w == communication_laser	then
			p "Энергетическая пуповина Земли...";
		end
	end,
	use = function(s, w) s:used(w) end;
};
communication_laser =obj{
	nam = "Коммуникационный лазер",
	inv = "Излучаемая волна настолько коротка, что несет колоссальную энергию.";
	use = function(s, w) s:used(w) end;
	used = function(s, w)
		if w == ship then
			p "Строительство таких масштабов неизбежно пожирает ресурсы мегаеденицами. Для обеспечения энергией {stranger|\"Скитальца\"} рядом повесели три энерго-приемника и достроили еще одну транспортную установку на Луне.";
			take "power_line";
		end;
	end,
};
power_line = obj{
	nam = "Энерголуч",
	inv = "\"Энергетическая пуповина человечества\". Ага, огромная сверхгорячая нить потихоньку сжигающая атмосферу планеты...",
	use = function(s, w) s:used(w) end;
	used = function(s, w)
		if w == masking then
			p [[Ну конечно! Луна уже почти скрылась за краем "плато", а Корабль - в "зените". Что скроет все следы лучше, чем поджарится в транспортном луче?^ Боюсь что уже сейчас в инфосети, во все мои сообщения вставляются паразитарные кусочки текста, что при прогонке через психоанализатор сложатся в суицидальное расстройство...]];
			take "burn_up";
		end;
	end,
};
burn_up = obj{
	nam = "Зажариться",
	inv = function(s)
		if not have "broken_panel" then	p "Нужно срочно изменить курс!";
		else	p "Это самая большая передряга в которую я когда-либо попадал...";
		end
	end,
	use = function(s, w) s:used(w) end;
	used = function(s, w)
		if w == puncture then
			p "О да, это скроет следы... Если корабли с их броней стараются не соваться под лазер, то что останется от скафандра? А от человека в нем?..";
		end;
	end,
};
puncture = obj{
	nam = "Потрескавшаяся оболочка",
	inv = function(s)
		if here() == "plot" then	p "Потрескавшаяся?..";
		else	p "Они сказали, что из-за потрескавшейся оболочки скафандра не будет видно дыры от штыря... Штыря в два пальца толщиной!";
		end
	end,
	use = function(s, w) s:used(w) end;
	used = function(s, w)
		if w == blood then
			p "Вряд ли от этого - моя кровь не настолько токсична.";
		elseif w == satellite then
			p "Думаю, мне не стоит здесь долго находится: целостность скафандра повреждена, а радиация от распада ядер - штука отнюдь не ласковая...";
		end
	end,
};
corpse = obj{
	nam = function(s)
		if not s._flag then
			p "Меня хотели убить";
		else
			p "Чем скрыть убийство?";
		end
	end,
	_flag = false;
	dsc = "^У моих ног буреет пятно {крови}.",
	inv = function(s)
		p "Они не собирались прятать, расчленять или испепелять мое тело. Иначе бы уже сделали это.";
		p "Его должны были бы найти, но, ";
		if have("communication_laser") then
			p "из-за воздействия коммуникационного лазера,";
		else
			p "почему-то,";
		end
		p "не обратили бы внимание на дырочку в груди.";
	end,
	tak = "Моей крови!";
	use = function(s, w) s:used(w) end;
	used = function(s, w)
		if w == puncture then
			p "Почему они бросили меня здесь? Ракету бы точно догнали, обнаружили меня, начали бы расследование...";
			take "masking";
		elseif w == miracle then
			p "Они не могли знать про КИРП. Это точно было убийство.";
		elseif w == alone then
			if not have "burn_up" then
				p "Они ушли. Скафандр цел. Логично предположить, что покорежить оболочку они собирались не собственноручно... Хотя не похоже, что её хоть чем-то обработали...";
			else
				p "Свалили всю работу на коммуникационный лазер и ушли.";
			end;
		end
	end,
}:disable();
masking = obj{
	nam = "Отвод глаз",
	use = function(s, w) s:used(w) end;
	inv = "Что же такое должно произойти со скафандром, чтобы дырка в груди стала незаметной?";
	used = function(s, w)
		if w == space1 or w == space2 or w == space3 then
			p "Открытый космос - вещь, конечно, страшная. Но - медлительная. Меня бы запеленговали и нашли бы дня за три-четыре. Тут не то что скафандр, даже тело в целости будет.";
		elseif w == jet then
			p "Неплохо. Реактивная струя вполне способно обуглить скафандр в головешку. Вот только как бы я попал туда мертвый? В смысле, расследование еще бы и задумалось на тему моей неосторожности, но убийцы-то не могли надеяться на вставший и кинувшийся в ядерный огонь труп...";
		end
	end,
};
miracle = obj{
	nam = "Чудо",
	dsc = "Тело совершенно не ощущается, но это анестетики. Голова слегка кружится. У меня дырка в груди. Легкие потихоньку заполняются жидкостью. Но я жив!^ Упираюсь взглядом в самую яркую звезду в поле зрения. Возношу безмолвную молитву мирозданию и партии за это маленькое, плановое {чудо}.^^",
	tak = function()
		p "Это называется КИРП: Компонентный Инъективный Реанимационный Пакет. Жуткий коктейль из анестетиков, коагулянтов и энергетиков, разделенный на сотни капсул. При больших потрясениях, шоке, надпочечники начинают синтезировать адреналин, который разъедает оболочку и высвобождает препараты наружу.^ Адская смесь. Мне приходилось отфильтровывать в комнате мочу от неё, прежде чем слить в унитаз - чтобы мед. анализатор сан. узла не забил тревогу.";
	end,
	inv = "Выкарабкаюсь - воспою такие дифирамбы в отчете, что Бюро точно выпишет премию изобретателю.";
	use = function(s, w) s:used(w) end;
	used = function(s, w)
		if w == corpse then
			p "Только благодаря КИРП я до сих пор жив.";
		elseif w == burn_up then
			p "Вряд ли в моей крови есть капсулы, способные спасти от этого... Волна с такой энергией просто разрушит белок!";
		elseif w == alone then
			p "Они бы не оставили меня, если бы не были уверены в моей смерти.";
		end
	end,
}:disable();
alone = obj{
	nam = "Они ушли",
	inv = function(s)
		if not s._knowAbout_anemyShip then
			p "Какой бы маленькой не была ракета - я осмотрел её всю и не обнаружил следов противника.";
		else
			p "Они \"сошли\". Думаю сфероид летит этим курсом специально чтобы их подобрать.";
		end
	end,
	_knowAbout_anemyShip = false;
	use = function(s, w) s:used(w) end;
	used = function(s, w)
		if w == space3 then
			p "Я вглядываюсь в преследующий корабль. Судя по размерам и сфрероидной форме - он собран здесь, на стройке. Я присматриваюсь по внимательнее... И замечаю три точки районе её экватора.^ \"Это они!\". Вот куда они делись: вывели ракету на курс и спрыгнули. А идущий следом сфероид их подберет. Если в их скафандрах отключены маячки, то никто и не догадается, что со мной кто-то был.";
		s._knowAbout_anemyShip = true;
		elseif w == burn_up then
			p "Ну конечно! Как только нашли мой труп - началось бы расследование. Запросили бы карту маршрутов и проверили судна, приближающиеся к моей ракете. Но если я пролечу сквозь луч коммуникационного лазера, то Центр Управления Полетами уже просчитал это и переполошил весь эфир! Сфероид может даже летел другой траекторией, пока не получил сообщение с командой рвануть за мной и спасать! Умно, чтобы их...";
		end
	end,
};
mis_failed = obj{
	nam = "Миссия провалена",
	inv = "Я должен был просто пришвартоваться к станции и забрать контейнер с информационными кристаллами. В инструктаже, к стати, значилось, что секретность обеспеченна и столкновение с противником исключено...",
	use = function(s, w) s:used(w) end;
	used = function(s, w)
		if w == containers then
			p [[Ради какой-то призрачной надежды я осмотрел контейнеры, составляющие стену прохода. Даже нашел пару с пометкой: "Содержит инфокристаллы". Но ни один не содержал желтой наклейки со стилизованным Солнцем...]];
		elseif w == alone then
			p [[Они забрали "посылку"... Шесть месяцев агентурной работы коту под хвост!]];
		elseif w == miracle then
			p "Хоть жив остался. Хотя мое прикрытие уже нельзя использовать... Может партия спишет меня на пенсию?";
		elseif w == corpse then
			p "Подобное неизбежно, при моей-то профессии.";
		elseif w == ship then
			p "Проект строительства предложили с полвека назад. Конструкция двигателя была предложена 20 лет назад. И только сейчас началось строительство...^ Моя страна выигрывала за счет раскрытия технической информации. А в чем была выгода остальных?.. Это я и выяснял.";
		end;
	end,
};
broken_panel = obj{
	nam = function(s)
		if s._radiooff then
			p "Диверсия";
		else
			p "Разорванные кабель";
		end
	end,
	inv = "А зачем им портить приборы наблюдения? Это же делает абсурдной версию с самоубийством.";
	use = function(s, w)
		if w == alone then
			p "Но какой смысл им портить ракету? Они знали, что я жив? Но при расследовании это порча выплывет. Сразу заподозрят убийство. Зачем тогда маяться с выводом ракеты на этот курс? Почему просто не добить и следовать плану дальше?..";
		elseif w == mis_failed then
			p "";
		end
	end,
};
end_of_story = room{
	nam = "В открытом космосе",
	hideinv = true;
	forcedsc = true;
	_vis = 1;
	dsc = function(s)
		local fin = {
			"Да. Это единственные шанс.";
			"Бегать в невесомости - задачка не из легких. Но мне нужно набрать ускорение что бы не столкнутся со сфероидом.";
			"Паника захлестнула меня, когда подошвы оторвались от борта ракеты. Словно космос рванул мне на встречу.";
			"Попытки с десятой мне удается уравновесить моменты и развернутся лицом к удаляющейся ракете.";
			"Даже с рециркуляцией у меня будет только девять часов.";
			"Сознание не справляется с НАСТОЛЬКО статичной картинкой. Мысли против воли замедляются... Я должен сопротивляется, иначе эффект Лао сделает из меня овощь!";
			""; "эээ"; "199"; "324"; "325"; 
			"...";
			"Сфероид! Это они!";
			"Проходит мимо! Меня не заметили!";
			"...";
			"1254; 674; 121; a"; "5488; 4908; 701; эпсилон";
			"...";
			"О! Сфероид меняет траекторию! Значит перехватить ракету уже математически невозможно и ЦУП скомандовал отбой. А ту груду металла словят зонды-мусорщики.";
			"0х77A9; 0xBCD; 0x10; z; Черный конь на е3";
			"...";
			"Вспыхивает красная точка. Это ракета пересекает луч...";
			"...";
			"Пора. Включать. Аварийный. Маяк. Скафандра.";
		}
		if s._vis == #fin+1 then
			walk "theEnd";
		end
		p(fin[s._vis]);
		p "^^^{next|>>>}";
	end,
	obj = { xact("next", function() end_of_story._vis = end_of_story._vis + 1; return true; end); };
};
theEnd = room{
	hideinv = true;
	nam = "Конец",
	dsc = nil,
};
