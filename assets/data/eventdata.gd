extends Node
#old conditions
#2move to new format
var checks = {
	"intro": #need to link this event with input_handler signal
	[
		{type = "gamestart"}
	],
	"intro_2":
	[
#		{type = "event_finished", name = "Intro"}
	],
	"intro_3":[
		{type = "date", date = 3}
	],
	"Forest_1":[{
		type = 'area_progress',
		area = 'forestelves',
		operant = 'gte',
		value = 3
	}], 
	"Forest_2":[{
		type = 'area_progress',
		area = 'forestelves',
		operant = 'gte',
		value = 8
	}], 
	"erika_1":[
		{type = "event_finished", name = "Forest 2"},
		#{type = "building", value = 'hall'}
		#хз, если честно, но надо проконтролировать, что из города откуда-то
	],
	"ember_1":[
		{type = "event_finished", name = "intro 3", delay = 2},
	],
	"ember_2":[
		{type = "event_finished", name = "ember 1", delay = 1},
		{type = "has_material", material = 'elvenwood', value = 1, operant = 'gte'}
	],
	"ember_3":[
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
	
	"Market_2":
	[
		{type = "has_upgrade", name = "bridge", value = 1}
	],
	
	"Market_3":
	[
		{type = "event_finished", name = "Forest 2"}
	],
	
	"rose_1":[
		{type = "event_finished", name = "ember 3", delay = 1},#still not sure if this is enough
	],
	"demitrius_1":[
		{type = "has_hero", name = "Erika"},
		{type = "event_finished", name = "ember 3", delay = 2},
	],
	"demitrius_2":[{
		type = 'area_progress',
		area = 'cavedemitrius',
		operant = 'gte',
		value = 3
	}], 
	"demitrius_3":[{
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

#new format
var events = {
	#sample
	#obviously - for arron cant be unlocking character
	'eventname':{
		name = "Somename",
		description = "somedescription",
		conditions = [], 
		unlock_conditions = [], #not reqired if not unlock_before_seen
		cost = {'arron':10},
		icon = "bg/villagenight",
		unlock_before_seen = false,
		auto_unlocks = false,
		onetime = false #for scenes to not be replayed in exploration missions replays
	},
} setget , get_localized_events

#start event triggers
var characters = {
	'flak':
	["Market_2", "Market_3"],
	'ember':
	['ember_2', 'ember_3'],
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
		TownHall = ['erika_1'],
		market = [],#'Market'],
		HeroGuild = [],
		blacksmith = [],
		
	},
	LocationEntered = {
		village = ['intro_2']
	},
	ItemObtained = [],
	MaterialObtained  = [],
	ExplorationStarted = [],
	CombatEnded  = ['Forest_1', 'Forest_2', 'demitrius_2', 'demitrius_3'],
	UpgradeUnlocked  = ['bridge'], #can't set directly to unlocking specific upgrade due to format of signal's arg
	EventFinished = ['intro_2','outro'],
	QuestStarted = [],
	QuestCompleted = [],
	Midday = ['intro_3', 'ember_1', 'rose_1', 'demitrius_1'] #not sure about rose1
}

#something, idk what it is
var progressdata = {
	0 : "Search for clues for "
	
}

func get_localized_events():
	var res = events.duplicate(true)
	for ev in res.values():
		ev.name = tr(ev.name)
		ev.description = tr(ev.description)
	return res
