-- $Name: Старый друг$
-- $Version: 1.0$
-- $Author: Клиш Максим$
instead_version "1.9.1"
require "para" 
require "dash"
require "quotes"
require "xact" 
require "hideinv" 
require "snapshots"
game.act = "Гм.....";
game.use = "Не сработает";
game.inv = "Зачем это мне";

main = room {
	forcedsc = true,
	nam = "Меню",
	dsc =[[{start|Начать игру}]],
	obj = {
		xact("start", code[[walk(bell)]]),
	},
};
bell = room {
	nam = "...",
	dsc = [[Я прилетел ночью. Город встретил меня стеной дождя и пронизывающим ветром. 
		Перелет длинной в десять часов дался мне нелегко, и я хотел немного отдохнуть.  
		Пора перестать мотаться по работе через всю страну три раза в неделю.^^  
		Сигнал личного {next|терминала}, разбудивший меня, был словно гром среди ясного неба.
 		Я неохотно поднялся и пошел посмотреть, кто  потревожил меня в столь не уместный час.]],	
	obj = {
		xact("next", code[[walk(terminal);]]),
	},
};
terminal = room {
	forcedsc = true,
	nam = "...",
	dsc = [[На экране терминала мерцал значок нового {message|сообщения}. 
		Адресатом был мой старый друг Джордж. Странно. 
		Он всегда предпочитал звонок взамен электронному письму.]],
	obj = {
		xact("message", [[Привет дружище!^^
		Я знаю, ты только что вернулся, но мне нужно с тобой срочно поговорить. 
		Это может изменить всю твою жизнь.  Жду тебя через час в кофе на набережной.^^ 
		Джордж^^
		{next|Далее}]]),
		xact("next", code[[walk(block);]])
	},
};

block = room {
	entered = [[Все это очень странно. Джордж не часто влезал во всякие авантюры. 
	Здравый смысл отчаянно кричал мне – оставайся дома. А если это действительно важно? 
	Я решил поехать. Вот только нужно сначала найти свои ключи.]],
	nam = "Жилой блок",
	dsc = [[Мой жилой блок. Из-за постоянных разъездов я редко здесь бываю, 
	но все же считаю его домом. ]],
	obj = {
		"bookshelf",
		"table",
		"window",
		"door",
		},
	way = {
	"kitchen",
	},
};
bookshelf = obj {
		nam = "Книжная полка",
		dsc = [[ У дальней стены стоит, сделанная из дешевого пластика, {книжная полка}.]],
		act = [[Пару книг и несколько старых фотографий, имен половины людей на которых я уже не помню. 
		В центре мое фото с Анджелой. Жаль, что у нас так ничего не получилось.]],
		};
table = obj {
		nam = "Стол",
		dsc = [[Небольшой столик посреди комнаты завален разным 
		{хламом}.]],
		act = [[Старые журналы, выписка из банка и кусок засохшей пиццы. 
		Мне здесь ничего не нужно.]]
	};

window = obj {
	nam = "Окно",
	dsc = [[На стене расположено небольшое {окно} с жалюзи.]],
	act = [[Жалюзи закрыты. Не люблю, когда глазеют в окна.]],
	};
door = obj {
	nam = "Дверь",
	dsc = [[В комнате есть {дверь} на улицу.]],
	act = "Без ключа не выйти",
	
};
kitchen = room {
	nam = "Кухня",
	dsc = [[Маленькая кухня. Тут едва можно уместиться вдвоем.]],
	obj = {
		"fridge",
		"kitchen_table",
	},	
	way = {
	"block",
	},
};
fridge = obj {
	nam = "Холодильник",
	dsc = [[Здесь стоит мой старый {холодильник}.]],
	act = [[Скорее всего, пуст – даже не буду заглядывать. 
	На дверце приклеена бумажка с номером – 5188349.
	 Это номер моих родителей, постоянно его забываю.]],
};
key = obj {
		nam = "Ключ",
		dsc = [[Рядом с вазой лежат {ключи}.]],
		tak = [[Я взял ключ со стола. Теперь можно идти.]],
		inv = [[Ключ от двери моего блока]],
		use = function(s,w)
			if w == door then
				walk(middle);
				remove(s, me());
			else
				p [[Зачем?]];
			end;
		end;
	};
kitchen_table = obj {
	nam = "Кухонный столик",
	dsc = [[На {кухонном столике} стоит стеклянная ваза для фруктов]],
	act = [[Ваза пуста]],
	obj = {
			"key",
		},
};
middle = room {
	nam = "По дороге в кафе",
	dsc = [[Чем ближе я подходил к кафе, тем сильнее чувствовал тревогу.
	Слова Джорджа: "Это может изменить твою жизнь" - не выходили у меня из головы.^^
	{next|Далее}]],
	obj = {
		xact("next", code[[walk(cafe);]]),
	},	
};
cafe = room {
	nam = "Кафе на набережной",
	dsc = [[Наше старое место. В молодости мы часто собирались здесь по вечерам.
	Сейчас же я бываю тут  два - три раза в месяц]],
	obj = {
		"men",
		"computer",
		"bartender",
	},
};
men = obj {
	nam = "Джордж",
	dsc = [[{Джордж} уже сидел за столиком и ждал меня. Рядом на столике 
	стоит чашка ароматного кофе.]],
	act = function ()
		walk(mendlg);
	end;
};
bartender = obj {
	nam = "Бармен",
	dsc = [[За стойкой {бармен} тщательно протирает стаканы.]],
	act = [[Я ничего не хочу. Не буду его отвлекать]],	
};
computer = obj {
	nam = "Переносной терминал",
	dsc = [[Возле Джорджа лежит его переносной {терминал}. Он 
	никогда с ним не расстается.]],
	act = [[Терминал одной из новых моделей. Очень дорогой.]]
};
mendlg = dlg {
	nam = "Разговор в Кофе",
	entered = [[Джордж казался очень возбужденным. Его глаза быстро 
	бегали по экрану терминала.]],
	phr = {
		{1, always = true, "Здравствуй Джордж. ",
						"Привет дружище! Рад тебя видеть. Выглядишь не очень.", [[pon(2);poff(1);]]};
		{2, false, always = true, [[Да, просто не выспался. Рассказывай, что произошло? Почему такая спешка?]],
						[[Да садись ты. Сейчас все расскажу.
						Помнишь ту контору, с которой я связался год назад?]], [[pon(3);poff(2);]]};
		{3, false, always = true, [[Ты что-то упоминал. Вроде как ты искал определенных людей для них.]],
						[[Да. Так вот, эти "яйцаголовые"  сделали заказ на поиск одного человека. 
						Не богат, не умен, не красавец – вообще никто. Я сразу удивился, но за такие деньги я бы нашел 
						кого угодно. На поиски ушло четыре месяца. Поймал его в аэропорту Бангкока, летели вместе. 
						По дороге рассказал ему, что да как. Мол, передовые исследования, наука, будущее, деньги. 
						Заказчики обычно не жалеют денег на оплату. Он отказался. Я дал ему свою визитку и сказал, 
						что если он передумает, то пусть мне позвонит.^^
						Прошло два месяца. Вчера мне домой принесли посылку. 
						Там было это – он достал из кармана стандартный блок памяти и положил его на стол.]], [[pon(4);poff(3);]]};
		{4, false, always = true, [[Ты смотрел, что на нем?]],
									[[Да]], [[pon(5);poff(4);]]};
		{5, false, always = true, [[И что там??]],
									[[Понимаешь, я не могу тебе рассказать. Ты должен все увидеть сам.
									Ты  найдешь все ответы на блоке памяти.^^
									(С этими словами он встал и вышел из кофе.)]],
									[[take(memory_block);pon(6);poff(5);]]};
		{6, false, always = true, "Далее", code = [[walk(block_2);]]};
						
	};
};
memory_block = obj {
	nam = "Блок памяти",
	inv = [[Блок памяти, который передал мне Джордж]],
	use = function(s,w)
		if w == terminal_2 then
			walk(terminaldlg);
			remove(s, me());
		else
			p [[Не думаю, что это хорошая идея.]];
		end;
	end;
};
kitchen_2 = room {
	nam = "Кухня",
	dsc = [[Маленькая кухня. Тут едва можно уместиться вдвоем.]],
	obj = {
		"fridge",
		"kitchen_table",
	},	
	way = {
	"block_2",
	},
};
block_2 = room {
	nam = "Жилой блок",
	entered = code[[make_snapshot()]],
	dsc = [[Мой жилой блок. Из-за постоянных путешествий я 
	редко здесь бываю, но все же считаю его домом. С каждой минутой все произошедши события пугали меня все больше и больше.
	Я держал в руке блок памяти не решаясь подойти к терминалу.]],
	obj = {
		"bookshelf",
		"table",
		"window",
		"door_2",
		"terminal_2",
		},
	way = {
	"kitchen_2",
	},
};
door_2 = obj {
	nam = "Дверь",
	dsc = [[В комнате есть {дверь} на улицу.]],
	act = "Мне не зачем туда идти",
};
terminal_2 = obj {
	nam = "Личный терминал",
	dsc = [[На кровати лежит мой личный {терминал}]],
	act = [[Нужно вставить в него блок памяти, который дал мне Джордж]],
};
terminaldlg = dlg {
	nam = "Личный терминал",
	entered = [[Привет Алекс. Я почти уверен что это ты, но небольшой тест на подтверждение личности не повредит.
	Я бы не хотел, что бы эта информация попала не в те руки.^^
	Выбери последовательность:]],
	phr = {
		{1, always = true, "5188439",
						[[В блоке памяти что-то щелкнуло, и он стал полностью белым. Из открывшегося отверстия стал выходить полупрозрачный газ. 
						Стало тяжело дышать. Через несколько секунд я провалился в пустоту.]], [[pon(10);poff(1,2,3)]]};
		{2, always = true, "5188340",
						[[В блоке памяти что-то щелкнуло, и он стал полностью белым. Из открывшегося отверстия стал выходить полупрозрачный газ. 
						Стало тяжело дышать. Через несколько секунд я провалился в пустоту.]], [[pon(10);poff(1,2,3)]]};
		{3, always = true, "5188349",
						"Выбери имя", [[pon(4,5,6);poff(1,2,3);]]};
		{4, false, always = true, "София",
							[[В блоке памяти что-то щелкнуло, и он стал полностью белым. Из открывшегося отверстия стал выходить полупрозрачный газ. 
						Стало тяжело дышать. Через несколько секунд я провалился в пустоту.]], [[pon(10);poff(4,5,6)]]};
		{5, false, always = true, "Анджела",
							"Выбери место", [[pon(7,8,9);poff(4,5,6);]]};
		{6, false, always = true, "Виктория",
							[[В блоке памяти что-то щелкнуло, и он стал полностью белым. Из открывшегося отверстия стал выходить полупрозрачный газ. 
						Стало тяжело дышать. Через несколько секунд я провалился в пустоту.]], [[pon(10);poff(4,5,6)]]};
		{7, false, always = true, "Окраины",
							[[В блоке памяти что-то щелкнуло, и он стал полностью белым. Из открывшегося отверстия стал выходить полупрозрачный газ. 
						Стало тяжело дышать. Через несколько секунд я провалился в пустоту.]], [[pon(10);poff(7,8,9)]]};
		{8, false, always = true, "Набережная",
							[[Личность подтверждена^^
							Приветствуем вас^^
							Мы рады, что вы решили принять участие в нашей программе полетов. 
							Для более детальной информации выберете раздел:]], 
							[[pon(11,12,13);poff(7,8,9);]]};
		{9, false, always = true, "Центр",
							[[В блоке памяти что-то щелкнуло, и он стал полностью белым. Из открывшегося отверстия стал выходить полупрозрачный газ. 
						Стало тяжело дышать. Через несколько секунд я провалился в пустоту.]], [[pon(10);poff(7,8,9)]]};
		{10, false, always = true, "Возможно, все было совсем иначе", "",
							[[restore_snapshot();]]};
		{11, false, always = true, "Общая информация",
								[[В блоке памяти что-то щелкнуло, и он стал полностью черным. Из открывшегося отверстия стал выходить полупрозрачный газ. 
								Стало тяжело дышать. Через несколько секунд я провалился в пустоту.]], [[pon(14);poff(11,12,13);]]};
		{12, false, always = true, "Программа полета",
								[[В блоке памяти что-то щелкнуло, и он стал полностью черным. Из открывшегося отверстия стал выходить полупрозрачный газ. 
								Стало тяжело дышать. Через несколько секунд я провалился в пустоту.]], [[pon(14);poff(11,12,13);]]};
		{13, false, always = true, "Участники",
								[[В блоке памяти что-то щелкнуло, и он стал полностью черным. Из открывшегося отверстия стал выходить полупрозрачный газ. 
								Стало тяжело дышать. Через несколько секунд я провалился в пустоту.]], [[pon(14);poff(11,12,13);]]};
		{14, false, always = true, "Далее", "", [[walk(final);]]}
	};	
};
final = room {
	nam = "...",
	dsc = [[Пассажир Алекс Кессади^^
		Возраст 32 года^^
		Роль - Журналист^^
		Статус – выход из криосна^^
		Все показатели в норме^^
		Начинаю процедуру разморозки^^
		До окончания процедуры осталось четыре часа]],
};