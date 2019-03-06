extends Node

var checks = {
	"ember 3":[
		{},
		{type = "event_finished", name = "ember 2", delay = 2},
	],
	"ember 2":[
		{},
		{type = "event_finished", name = "ember 1"},
		{type = "no_check"} #здесь, очевидно, проверка на эльвенвуд, но её не мне прописывать, да и тестить надо
	],
	"ember 1":[
		{type = "date", date = 3},
		{type = "no_check"} #условие не анонсировалось, воткнул третий день
	],
	"erika 1":[
		{type = "event_finished", name = "Forest 2"},
		{type = "building", value = 'hall'} #хз, если честно, но надо проконтролировать, что из города откуда-то
	],
	"Intro 2":
	[
		{type = "event_finished", name = "Intro"}
	],
	"Intro 3":[
		{type = "date", date = 2}
	],
	"Market":
	[
		{type = "building", value = "slave"},
		#{type = "event_finished", name = "Intro 2"}
	],
	"Intro":
	[
		{type = "gamestart"}
	],
	"Market 2":
	[
		{},
		{type = "event_finished", name = "Market"}
	],
	"Forest 1":[{}], #пока нет условия на эксплор
	"Forest 2":[{}], #аналогично
	"rose 1":[
		{type = "event_finished", name = "ember 3", delay = 3},
		{type = "event_finished", name = "erika 1", delay = 1} # в ТЗ нет, но по смыслу должно быть
	],
};

var characters = {
	'flak':
	["Market 2"],
	'ember':
	['ember 2', 'ember 3']
};
