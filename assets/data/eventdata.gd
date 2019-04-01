extends Node

var checks = {
	"Intro":
	[
		{type = "gamestart"}
	],
	"Intro 2":
	[
		{type = "event_finished", name = "Intro"}
	],
	"Intro 3":[
		{type = "date", date = 3}
	],
	"Forest 1":[{
		type = 'area_progress',
		area = 'forestelves',
		operant = 'gte',
		value = 3
	}], 
	"Forest 2":[{
		type = 'area_progress',
		area = 'forestelves',
		operant = 'gte',
		value = 8
	}], 
	"erika 1":[
		{},
		{type = "event_finished", name = "Forest 2"},
		#{type = "building", value = 'hall'}
		#хз, если честно, но надо проконтролировать, что из города откуда-то
	],
	"ember 1":[
		{type = "event_finished", name = "Intro 2", delay = 3},
	],
	"ember 2":[
		{},
		{type = "event_finished", name = "ember 1", delay = 1},
		{type = "has_material", material = 'elvenwood', value = 1, operant = 'gte'}
	],
	"ember 3":[
		{type = 'building', value = 'blacksmith'},
		{type = "event_finished", name = "ember 2", delay = 2},
		{type = "hero_level", operant = 'gte', name = 'EMBER', value = 3}
	],
	"bridge":
	[
		{type = "has_upgrade", name = "bridge", value = 1}
	],
	
	"Market":
	[
		{type = "building", value = "Market"},
	],
	
	"Market 2":
	[
		{},
		{type = "has_upgrade", name = "bridge", value = 1}
	],
	
	"Market 3":
	[
		{},
		{type = "event_finished", name = "Forest 2"}
	],
	
	"rose 1":[
		{type = "event_finished", name = "ember 3", delay = 1},
	],
	"demitrius 1":[
		{type = "event_finished", name = "ember 3", delay = 1},
	],
	"demitrius 2":[{
		type = 'area_progress',
		area = 'cavedemitrius',
		operant = 'gte',
		value = 3
	}], 
	"demitrius 3":[{
		type = 'area_progress',
		area = 'cavedemitrius',
		operant = 'gte',
		value = 10
	}], 
	"Outro":
	[
		{type = "event_finished", name = "demitrius 3"}
	],
};

var characters = {
	'flak':
	["Market 2"],
	'ember':
	['ember 2', 'ember 3'],
	'erika':[],
};

var buildings = {
	'flak':
		["Market"],
	'ember':[],
	'erika':
		["erika 1"]
};
var progressdata = {
	0 : "Search for clues for "
	
}

