-- $Name: Подготовка к пробуждению$
-- $Version: 0.1$
instead_version "1.9.1"
require "para"
require "dash"
require "quotes"
require "xact"

game.use = "Вариантов успешного завершения инструкций 0... Отмена действия."
main = room {
    nam = "Подготовка к празднику",
    act = function(s) walk("sylo") end,
    dsc = "WR021 активирован.^Я один из роботов, обслуживающих космический корабль.^Меньше слов, больше выполненых заданийиз списка, как говорил наладчик моих модулей индивидуальности.",
    obj = { vobj("next", '{Выехать из отсека}') },
}

sylo = room {
    nam = "Технический блок №11",
    dsc = "Один из многих технических блоков. Здесь всего две камеры с роботами WR, две стальные двери. Хорошо что мне удалось воспользоваться модулем индивидуальности и выкрасить свою дверь в оранжевый. Хоть что-то среди этого набора из сотни зануд.",
    obj = {"todo", "gates"},
	exit = function (s, w)
		if not todo._acted then
			p 'И зачем мне выезжать из блока? Открытых заданий нет.'
			return false;
		end
	end
}

main_deck = room {
	nam = "Главная палуба",
	dsc = "Главная палуба. Отсюда я могу добраться к любому другому отсеку.",
	obj = {"button"},
	way = {"elevator"},
}

organic = room {
	nam = "Камера органического синтеза",
	dsc = "Борщ, пиво, стейк с кровью. Тут можно синтезировать всё, кроме заливной рыбы, которая была запрещена восемь циклов назад.",
	act = function(s) walk("synthesizer") end,
	obj = {"button", vobj("next", '{Подключиться} к синтезатору')},
	way = {"elevator"},
}

elevator = room {
	nam = "Лифт",
	dsc = "Кабина лифта. Ничего необычного.",
	obj = {"level_buttons"},
	way = {"main_deck", "store"},
}

synthesizer = room {
	nam = "Органический синтезатор",
	dsc = "Органический синтезатор соединён с клеточными наполнителями. Вся синтезированая продукция поступает непосредственно на склад.",
	obj = {"wishlist", "ingridients", "mixer", "separator"},
	way = {"organic"},
}

virtual_store = room {
	nam = "Виртуальный склад",
	dsc = "Продукты из виртуального склада синтезируются из субклеточной эмульсии. После выбора синтезированые продукты автоматически будут добавлены в миксер.",
	obj = {"malt", "yeast", "watermelon", "pineapple", "mayonnaise", "potato"},
	way = {"synthesizer"},
}

store = room {
	nam = "Склад",
	dsc = "Склад продуктов, которые нельзя просто так синтезировать.",
	obj = {"malt", "yeast", "rat"},
	way = {"elevator"},
	exit = function (s, w)
		if have("destructor") then
			p "Распылитель лучше положить на место.";
			return false;
		end;
	end,
	enter = function (s)
		put("rat", here());
	end,
}:disable();

wishlist = obj {
	nam = "Список пожеланий",
	act = "Список блюд на вечеринку:^- Пиво^- Фруктовый салат^- Жареная картошка^",
	dsc = "{Список пожеланий персонала}^",
}

ingridients = obj {
	nam = "Ингридиенты",
	act = function(s) walk("virtual_store"); end,
	dsc = "{Выбор ингридиентов}^",
}

mixer = obj {
	var {content = {}},
	act = function (s)
		
		s.content = {};
		return "Заглушка";
	end,
	nam = "Миксер",
	dsc = "{Миксер}^",
}

separator = obj {
	nam = "Сепаратор",
	dsc = "{Молекулярный сепаратор}^",
}

todo = obj {
    nam = "todo",
    var { _acted },
	act = function (s)
		if not s._acted then
			s._acted = true;
		end
		return "Всего один пункт:^   - Подготовка к вечеринке перед приземлением.^Что ж, это должно быть 101 из 101 по шкале интересности.";
	end,
    dsc = "{Список задач} доступен для чтения.",
}

button = obj {
	nam = "elevator call",
	act = "Никогда не понимал эти кнопки. Итак ведь ясно что я хочу куда то ехать. Зачем ещё её нажимать.",
	dsc = "На стене находится {кнопка вызова лифта}.^",
}

level_buttons = obj {
	nam = "level buttons",
	act = function (s)
		if not s._acted then
			s._acted = true;
			ways():add("organic");
		end
		return "Так, что у нас тут... Машинный зал, отсек криокамер, о, камера органического синтеза, то, что нужно."
	end,
	dsc = "Справа находятся {кнопки отсеков}^",
}

gates = obj {
	nam = "ворота",
	var { _state = "закрыты" },
	dsc = function(s) 
		return "{Ворота}, ведущие из технического отсека "..s._state.."."; 
	end,
	act = function (s)
		if not s._acted then
			s._acted = true;
			s._state = "открыты";
			ways():add("main_deck");
			return "Я приложил правую руку к считывателю и ворота открылись.";
		else
			return "Ворота на главную палубу уже открыты.";
		end
	end,
}

malt = obj {
	nam = "Солод",
	dsc = function (s)
		if here() == "store" then
			return "Мешки с {солодом}^";
		else
			return "{Солод}^";
		end;
	end,
	act = function (s)
		if here() ~= "store" then
			store:enable();
			return "Этот ингридиент невозможно синтезировать. Придётся идти на склад."
		end;
	end,
}

yeast = obj {
	nam = "Дрожжи",
	dsc = function (s)
		if here() == "store" then
			return "Пробирки с {дрожжами}^";
		else
			return "{Дрожжи}^";
		end;
	end,
	act = function (s)
		if here() ~= "store" then
			store:enable();
			return "Этот ингридиент невозможно синтезировать. Придётся идти на склад."
		end;
	end,
}

watermelon = obj {
	nam = "Арбузные кубики",
	dsc = "Сухие {арбузные кубики}^",
	act = function (s)
		return s.nam.." добавлены в миксер.";
	end,
}

pineapple = obj {
	nam = "Ананасовые кубики",
	dsc = "Сухие {ананасовые кубики}^",
	act = function (s)
		return s.nam.." добавлены в миксер.";
	end,
}

mayonnaise = obj {
	nam = "Майонез",
	dsc = "Взбитый {концетрат жира с яйцами}^",
	act = function (s)
		return s.nam.." добавлен в миксер.";
	end,
}

potato = obj {
	nam = "Картофельные бруски",
	dsc = "Синтезированый {картофель}^",
	act = function (s)
		return s.nam.." добавлены в миксер.";
	end,
}

rat = obj {
	var {_fired = false},
	nam = "Крыса",
	dsc = "В углу сидит бесстрашная {тощая тварь}^",
	act = function (s)
		if not have("rat") then
			take(rat);
			return "Я ловким движением правой руки поймал крысу и положил в один из внутренних отсеков.";
		else
			return "Все подходящие отсеки заполнены. Отмена операции.";
		end
	end,
	use = function (s, w)
		if w == separator then
			remove(s, me());
			take(water);
			take(trash);
			return "Думаю стоит тебя немного разделить.";
		end;
	end,
	inv = "Если тыкнуть крысу, она запищит.",
}

water = obj {
	nam = "Вода",
	dsc = "Вода, что тут ещё сказать.",
	use = function (s, w)
		if w == mixer then
			remove(s, me());
			return s.nam.." добавлена в миксер.";
		end;
	end,
}

trash = obj {
	nam = "Крысиная требуха",
	dsc = "Молекулярная суспензия. Всё что осталось от крысы после отделения воды.",
}

destructor = obj {
	nam = "Термический распылитель",
	dsc = "Справа от двери висит {термический распылитель}^",
	act = function (s) 
		take(s);
		p "Распылитель пригодится. Мало ли каких тварей привлекают к себе заготовленые ингридиенты.";
	end,
}