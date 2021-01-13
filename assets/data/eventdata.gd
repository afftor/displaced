extends Node

var checks = {
	"Intro": #need to link this event with input_handler signal
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
		{type = "event_finished", name = "Forest 2"},
		#{type = "building", value = 'hall'}
		#хз, если честно, но надо проконтролировать, что из города откуда-то
	],
	"ember 1":[
		{type = "event_finished", name = "Intro 3", delay = 2},
	],
	"ember 2":[
		{type = "event_finished", name = "ember 1", delay = 1},
		{type = "has_material", material = 'elvenwood', value = 1, operant = 'gte'}
	],
	"ember 3":[
		{type = "event_finished", name = "ember 2", delay = 2},
		{type = "hero_level", operant = 'gte', name = 'Ember', value = 3}
	],
	"bridge":
	[
		{type = "has_upgrade", name = "bridge", value = 1}
	],
	
	"Market":
	[
	],
	
	"Market 2":
	[
		{type = "has_upgrade", name = "bridge", value = 1}
	],
	
	"Market 3":
	[
		{type = "event_finished", name = "Forest 2"}
	],
	
	"rose 1":[
		{type = "event_finished", name = "ember 3", delay = 1},#still not sure if this is enough
	],
	"demitrius 1":[
		{type = "has_hero", name = "Erika"},
		{type = "event_finished", name = "ember 3", delay = 2},
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
	"outro":
	[
		{type = "event_finished", name = "demitrius 3"}
	],
};

var characters = {
	'flak':
	["Market 2", "Market 3"],
	'ember':
	['ember 2', 'ember 3'],
	'erika':[],
};

#var buildings = {
#	'flak':["Market"],
#	'ember':['ember 2', 'ember 3'],
#	'erika':["erika 1"]
#};
var signals = {
	ScreenChanged = [],
	BuildingEntered = {
		TownHall = ['erika 1'],
		market = ['Market'],
		HeroGuild = [],
		blacksmith = [],
		
	},
	LocationEntered = {
		village = ['Intro 2']
	},
	ItemObtained = [],
	MaterialObtained  = [],
	ExplorationStarted = [],
	CombatEnded  = ['Forest 1', 'Forest 2', 'demitrius 2', 'demitrius 3'],
	UpgradeUnlocked  = ['bridge'], #can't set directly to unlocking specific upgrade due to format of signal's arg
	EventFinished = ['Intro 2','outro'],
	QuestStarted = [],
	QuestCompleted = [],
	Midday = ['Intro 3', 'ember 1', 'rose 1', 'demitrius 1'] #not sure about rose1
}
var progressdata = {
	0 : "Search for clues for "
	
}

