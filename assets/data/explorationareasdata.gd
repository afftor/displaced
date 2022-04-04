extends Node


var event_triggers = {#reworked to same syntax as seqs
	intro_1 = [
		{type = 'mission', value = 'road_to_village'},
	],
	intro_2 = [
		{type = 'scene', value = 'intro_3'},
		{type = 'system', value = 'unlock_area', arg = 'forest'},
		{type = 'system', value = 'unlock_mission', arg = 'forest_erika'},
		{type = 'show_screen', value = 'village'},
		{type = 'system', value = 'unlock_building', arg = 'bridge'}
	],
	forest2 = [
		{type = 'system', value = 'unlock_character', arg = 'erika'},
#		{code = 'system', value = 'show_screen', args = 'exploration'},
		{type = 'show_screen', value = 'exploration'},
	],
	dimitrius_1_3 = [
#		{code = 'system', value = 'start_next_scene', args = 'dimitrius_1_4'},
		{type = 'scene', value = 'dimitrius_1_4'},
	],
	dimitrius_1_4 = [
#		{code = 'system', value = 'show_screen', args = 'exploration'},
		{type = 'show_screen', value = 'exploration'},
	],
	aeros_1 = [
		{type = 'system', value = 'unlock_mission', arg = 'caves_dwarf'},
		{type = 'show_screen', value = 'exploration'},
	],
	aeros_2 = [
		{type = 'scene', value = 'aeros_3'},
	],
	erika_annet_2_1 = [
		{type = 'scene', value = 'erika_annet_2_2', reqs = [{type = 'rule', value = 'forced_content', arg = 'true'}]},#skip if forced content is disabled 
	],
	iola_2_2_1 = [
		{type = 'system', value = 'unlock_area', arg = 'cult'},
#		{code = 'system', value = 'show_screen', args = 'exploration'},
		{type = 'show_screen', value = 'exploration'},
	],
	rilu_1_2 = [
		{type = 'system', value = 'heal_team'},
	],
	rilu_1_3 = [
		{type = 'system', value = 'unlock_character', arg = 'rilu'},
		{type = 'system', value = 'add_member_to_active_party', slot = 3, member = 'rilu'},
		{type = 'system', value = 'heal_team'},
	],
	faery_queen_1 = [
		{type = 'scene', value = 'faery_queen_1_a', reqs = [{type = 'decision', name = 'portal'}]},
		{type = 'scene', value = 'faery_queen_1_b'},
	],
	faery_queen_1_a = [
		{type = 'scene', value = 'faeryqueen_1_b'},
#		{type = 'system', value = 'unlock_mission', arg = 'forest_faeries_2'},
	],
	faery_queen_1_b = [
		{type = 'system', value = 'unlock_mission', arg = 'forest_faeries_2'},
		{type = 'show_screen', value = 'exploration'},
	],
	faery_queen_2 = [
		{type = 'system', value = 'unlock_mission', arg = 'forest_faeries_3'},
		{type = 'show_screen', value = 'exploration'},
	],
	
	faery_queen_4 = [
		{type = 'show_screen', value = 'exploration'},
	],
	
	viktor_2_3 = [
		{type = 'mission', value = 'town_viktor_fight'},
	],
	rilu_2_3_2 = [
		{type = 'mission', value = 'castle_rilu'},
	],
	ember_2_4 = [
#		{code = 'system', value = 'start_next_scene', args = 'viktor_2_1'},
		{type = 'scene', value = 'viktor_2_1'},
	],
	viktor_2_1 = [
#		{code = 'system', value = 'show_screen', args = 'exploration'},
		{type = 'show_screen', value = 'exploration'},
	],
	iola_2_4 = [
#		{code = 'system', value = 'show_screen', args = 'village'},
		{type = 'show_screen', value = 'village'},
	],
	zelroth_2 = [
		{type = 'system', value = 'unlock_mission', arg = 'cult_rose_rescue'},
	],
}

var locations = { #added seqs bindings and other fields
	village =  {
		code = 'village',
		background = null, 
		missions = [],
		events = ['erika_at_village',]
	},
	forest =  {
		code = 'forest',
		background = null, #2fill
		missions = ['forest_erika','forest_faeries_1','forest_faeries_2','forest_erika_sidequest'],
		events = []
	},
	cave =  {
		code = 'cave',
		background = null, #2fill
		missions = ['caves_demitrius','caves_iola','caves_dwarf','caves_wanderer'],
		events = []
	},
	road_to_town =  { #needs rebinding or adding a dedicated map location
		code = 'road_to_town',
		background = null, #2fill
		missions = ['road_to_town'],
	},
	town =  { #should have differnet custom handling
		#idk for what reason
		code = 'town',
		background = null, #2fill
#		missions = ['town_viktor_fight','town_siege'],
		missions = ['road_to_town'],
		function = '',
		events = ['town_gates', 'viktor_introduction', 'annet_introduction', 'erika_meet_annet', 'arron_meet_annet', 'rose_annet_rescue', 'viktor_duel', ]
	},
	castle =  {
		code = 'castle',
		background = null, #2fill
		missions = ['castle_rilu_return'],
		events = ['rilu_castle', ]
	},
	dragon_mountains = {
		code = 'dragon_mountains',
		background = null, #2fill
		missions = ['mountains_ember'],
		events = []
	},
	cult =  {
		code = 'cult',
		background = null, #2fill
		missions = ['cult_iola_rescue','cult_rose_rescue'],
		events = ['iola_gets_caught', 'iola_rescue_start', ]
	},
	modern_city =  {
		code = 'modern_city',
		background = null, #2fill
		missions = ['dimitrius_finale'],
		events = []
	},
}


var buildings = { #for binding village buidings events
	town_hall = {
		events = ['rose_reunion']
	},
	smith = {
		events = ['ember_smith']
	},
}


var characters = { #for binding village characters events
	#i was forced to use scendata keys due to having characters that are not heroes here and reqirement to get their portarits
	Em = ['ember_arrival', 'ember_arc_initiate', 'viktor_sends_threat'],
	I = ['iola_arrival', 'iola_second_visit', 'iola_recruited', 'iola_wanderer'],
	D = ['dimitrius_arrival'], #there is a problem in this - it appears directly after closing ember arrival scene, that is not good
	F = ['flak_task', 'flak_task_return', 'flak_town_raid', 'flak_modern_city'],
	Ri = ['rilu_reports_iola', 'rilu_disappear'],
	Ro = ['rose_kidnap'],
	Er = ['erika_rose_init'],
}


var scene_sequences = { 
	
	intro = {
		initiate_signal = 'game_start', #can be signals like 'click specific location'
		initiate_reqs = [], #all sequences only playable once, unless specified
		actions = [
		{type = 'scene', value = 'intro_1'},
		{type = 'mission', value = 'road_to_village'}, #actually stops here
		{type = 'scene', value = 'intro_2'},
		{type = 'scene', value = 'intro_3'},
#		{type = 'system', value = 'start_game'},
		{type = 'system', value = 'unlock_character', arg = 'arron'}, #there should be rose for sure
		{type = 'system', value = 'unlock_area', arg = 'village'} #Suggestion: hardcode similar unlocks into single function i.e. start_game one
		]
	},
	intro_finish = {
		initiate_reqs = [],
		actions = [
			{type = 'scene', value = 'intro_2'},
			{type = 'system', value = 'unlock_character', arg = 'rose'},
			{type = 'system', value = 'unlock_area', arg = 'village'}
		]
	},
	erika_at_village = {
		initiate_signal = 'village_activate', 
		initiate_reqs = [{type = 'mission_complete', value = 'forest_erika'}],
		actions = [
		{type = 'scene', value = 'erika_1'},
		{type = 'system', value = 'unlock_character', arg = 'erika'},#duplicate of postscene action
		]
	},
	
	ember_arrival = {
		initiate_signal = 'village_townhall_ember', 
		initiate_reqs = [{type = 'mission_complete', value = 'forest_erika'}],
		actions = [
		{type = 'scene', value = 'ember_1_1'},
		{type = 'system', value = 'unlock_character', arg = 'ember'},
		{type = 'system', value = 'unlock_building', arg = 'forge'},
		]
	},
	
	ember_smith = {
		initiate_signal = 'village_smith', 
		initiate_reqs = [{type = 'seq_seen', value = 'ember_arrival'}],
		actions = [
		{type = 'scene', value = 'ember_1_2'},
		]
	},
	
	dimitrius_arrival = {
		initiate_signal = 'village_townhall_dimitrius', 
		initiate_reqs = [{type = 'seq_seen', value = 'ember_arrival'}],
		actions = [
		{type = 'scene', value = 'dimitrius_1_1'},
		{type = 'system', value = 'unlock_area', arg = 'cave'},
		{type = 'system', value = 'unlock_mission', arg = 'caves_demitrius'}
		]
	},
	
	iola_arrival = {
		initiate_signal = 'village_townhall_iola', 
		initiate_reqs = [{type = 'mission_complete', value = 'caves_demitrius'}],
		actions = [
		{type = 'scene', value = 'iola_1_1'},
		{type = 'system', value = 'unlock_mission', arg = 'caves_iola'}
		]
	},
	
	flak_task = {
		initiate_signal = 'village_townhall_fask', 
		initiate_reqs = [{type = 'mission_complete', value = 'caves_iola'}],
		actions = [
		{type = 'scene', value = 'flak_1'}, #not currently existing,
		{type = 'system', value = 'unlock_area', arg = 'town'},
		{type = 'system', value = 'unlock_mission', arg = 'road_to_town'}
		]
	},
	
	town_gates = {
		initiate_signal = 'town', 
		initiate_reqs = [{type = 'mission_complete', value = 'caves_dwarf'}],
		actions = [
		{type = 'scene', value = 'aeros_2'},
#		{type = 'system', value = 'unlock_area', arg = 'faery_forest'}, 
		{type = 'system', value = 'unlock_mission', arg = 'forest_faeries_1'},
		{type = 'scene', value = 'aeros_3'},
		]
	},
	
	flak_task_return = {
		initiate_signal = 'village_townhall_fask', 
		initiate_reqs = [{type = 'seq_seen', value = 'aeros_2'}],
		actions = [
		{type = 'scene', value = 'flak_2'}, #not currently existing,
		]
	},
	
	viktor_introduction = {
		initiate_signal = 'town', 
		initiate_reqs = [{type = 'seq_seen', value = 'aeros_3'}],
		actions = [
		{type = 'scene', value = 'viktor_1'},
		]
	},
	annet_introduction = {
		initiate_signal = 'town', 
		initiate_reqs = [{type = 'mission_complete', value = 'forest_faeries_1'}],
		actions = [
		{type = 'scene', value = 'erika_annet_1'},
		]
	},
	erika_meet_annet = {
		initiate_signal = 'town', 
		initiate_reqs = [{type = 'mission_complete', value = 'forest_faeries_3'}],
		actions = [
		{type = 'scene', value = 'erika_annet_2_1'}, 
		{type = 'system', value = 'enable_character', arg = ['erika',false] },
		{type = 'scene', value = 'erika_annet_2_2', reqs = [{type = 'rule', value = 'forced_content', arg = 'true'}]},#skip if forced content is disabled 
		
		]
	},
	arron_meet_annet = {
		initiate_signal = 'town', 
		initiate_reqs = [{type = 'seq_seen', value = 'erika_meet_annet'}],
		actions = [
		{type = 'scene', value = 'erika_annet_2_3'}, 
		]
	
	},
	rose_annet_rescue = {
		initiate_signal = 'town', 
		initiate_reqs = [{type = 'seq_seen', value = 'arron_meet_annet'}],
		actions = [
		{type = 'scene', value = 'erika_annet_2_4'},
		{type = 'system', value = 'game_stage', arg = 'erika_rescued'},
		{type = 'system', value = 'enable_character', arg = ['erika',true] },
		]
	},
	
	iola_second_visit = {
		initiate_signal = 'village_townhall_iola', 
		initiate_reqs = [{type = 'seq_seen', value = 'rose_annet_rescue'}],
		actions = [
		{type = 'scene', value = 'iola_2_1'},
		{type = 'system', value = 'unlock_area', arg = 'castle'},
		{type = 'system', value = 'unlock_mission', arg = 'castle_iola'}
		]
	},
	iola_gets_caught = {
		initiate_signal = 'cult_grounds', #?
		initiate_reqs = [{type = 'mission_complete', value = 'castle_iola'}],
		actions = [
		{type = 'scene', value = 'iola_2_2_2'},
		]
	},
	rilu_reports_iola = {
		initiate_signal = 'village_townhall_rilu', 
		initiate_reqs = [{type = 'seq_seen', value = 'iola_gets_caught'}],
		actions = [
		{type = 'scene', value = 'iola_2_2_3'},
		{type = 'system', value = 'unlock_mission', arg = 'cult_iola_rescue'}
		]
	},
	iola_rescue_start = {
		initiate_signal = 'cult', 
		initiate_reqs = [{type = 'seq_seen', value = 'rilu_reports_iola'}],
		actions = [
		{type = 'scene', value = 'iola_2_3'},
		{type = 'system', value = 'unlock_mission', arg = 'cult_iola_rescue'}
		]
	},
	iola_recruited = {
		initiate_signal = 'village_townhall_iola', 
		initiate_reqs = [{type = 'mission_complete', value = 'cult_iola_rescue'}],
		actions = [
		{type = 'scene', value = 'iola_2_5'},
		{type = 'system', value = 'unlock_character', arg = 'iola'},
		]
	},
	
	ember_arc_initiate = {
		initiate_signal = 'village_townhall_ember', 
		initiate_reqs = [{type = 'seq_seen', value = 'iola_recruited'}],
		actions = [
		{type = 'scene', value = 'ember_2_1'},
		{type = 'system', value = 'unlock_area', arg = 'mountains'},
		{type = 'system', value = 'unlock_mission', arg = 'dragon_mountains'}
		]
	},
#	viktor_kills_dragon = { 				Automatic on mountains completion
#		initiate_signal = 'mountains', 
#		initiate_reqs = [{type = 'mission_complete', value = 'dragon_mountains'}],
#		actions = [
#		{type = 'scene', value = 'viktor_2_1'}, 
#		]
#	},
	viktor_sends_threat = {
		initiate_signal = 'village_townhall_ember', 
		initiate_reqs = [{type = 'scene_seen', value = 'viktor_2_1'}],
		actions = [
		{type = 'scene', value = 'viktor_2_2'},
#		{type = 'system', value = 'unlock_mission', arg = 'town_viktor_fight'}
		]
	},
	viktor_duel = {
		initiate_signal = 'town', 
		initiate_reqs = [{type = 'seq_seen', value = 'viktor_sends_threat'}],
		actions = [
		{type = 'scene', value = 'viktor_2_3'}, 
		{type = 'mission', value = 'town_viktor_fight'},
		{type = 'scene', value = 'viktor_2_4'}
		]
	},
	rilu_disappear =  {
		initiate_signal = 'village_townhall_rilu', 
		initiate_reqs = [{type = 'mission_complete', value = 'town_viktor_fight'}],
		actions = [
		{type = 'scene', value = 'rilu_2_3_1'},
		]
	},
	rilu_castle =  {
		initiate_signal = 'castle', 
		initiate_reqs = [{type = 'seq_seen', value = 'rilu_disappear'}],
		actions = [
		{type = 'scene', value = 'rilu_2_3_2'},
		{type = 'mission', value = 'castle_rilu'},
		{type = 'scene', value = 'rilu_2_4'},
		]
	},
	iola_wanderer = {
		initiate_signal = 'village_townhall_iola', 
		initiate_reqs = [{type = 'mission_complete', value = 'castle_rilu'}],
		actions = [
		{type = 'scene', value = 'iola_3_1'},
		{type = 'system', value = 'unlock_mission', arg = 'caves_wanderer'}
		]
	},
	flak_town_raid = {
		initiate_signal = 'village_townhall_flak', 
		initiate_reqs = [{type = 'mission_complete', value = 'caves_wanderer'}],
		actions = [
		{type = 'scene', value = 'flak_city_raid'},
		{type = 'system', value = 'unlock_mission', arg = 'town_siege'}
		]
	},
	
	rose_kidnap = {
		initiate_signal = 'village_townhall_rose', 
		initiate_reqs = [{type = 'mission_complete', value = 'town_siege'}],
		actions = [
		{type = 'scene', value = 'dimitrius_2_1'},
		{type = 'system', value = 'unlock_mission', arg = 'castle_rilu_return'},
		{type = 'system', value = 'enable_character', arg = ['rose',false] },
		{type = 'system', value = 'enable_character', arg = ['iola',false] },
		]
	},
	rose_reunion = {
		initiate_signal = 'village_townhall', 
		initiate_reqs = [{type = 'mission_complete', value = 'cult_rose_rescue'}],
		actions = [
		{type = 'scene', value = 'rose_2'},
		{type = 'system', value = 'enable_character', arg = ['rose',true] },
		{type = 'system', value = 'enable_character', arg = ['iola',true] },
		]
	},
	
	flak_modern_city = {
		initiate_signal = 'village_townhall_flak', 
		initiate_reqs = [{type = 'seq_seen', value = 'rose_reunion'}],
		actions = [
		{type = 'scene', value = 'flak_future_city'},
		{type = 'system', value = 'unlock_mission', arg = 'modern_city_1'},
		{type = 'system', value = 'unlock_area', arg = 'modern_city'}
		]
	},
	
	erika_rose_init = {
		initiate_signal = 'village_townhall_erika', 
		initiate_reqs = [{type = 'seq_seen', value = 'erika_doggy'}],
		actions = [
		{type = 'scene', value = 'erika_rose_1'}, #must unlock new area/mission if agreed during the scene
		]
		
	},
	
	#Gallery scenes
	
	
	ember_boobs = {
		name = "",
		descript = "",
		category  = 'ember',
		initiate_reqs = [{type = 'seq_seen', value = 'ember_arrival'}],
		unlock_price = {ember = 100},
		actions = [
		{type = 'scene', value = 'ember_1_3'},
		{type = 'unlock_scene', value = 'ember_boobs'},#for gallery
		]
	},
	rose_night = {
		name = "",
		descript = "",
		category  = 'rose',
		initiate_reqs = [{type = 'seq_seen', value = 'ember_boobs'}],
		unlock_price = {rose = 100},
		actions = [
		{type = 'scene', value = 'rose_1'},
		{type = 'unlock_scene', value = 'rose_night'},
		]
	},
	rose_public = {
		name = "",
		descript = "",
		category  = 'rose',
		initiate_reqs = [{type = 'seq_seen', value = 'aeros_3'},{type = 'seq_seen', value = 'rose_night'}],
		unlock_price = {rose = 500},
		actions = [
		{type = 'scene', value = 'rose_3'},
		{type = 'unlock_scene', value = 'rose_night'},#rly?
		]
	},
	erika_doggy = {
		name = "",
		descript = "",
		category  = 'erika',
		initiate_reqs = [],
		unlock_price = {erika = 100},
		actions = [
		{type = 'scene', value = 'erika_2'},
		{type = 'unlock_scene', value = 'erika_doggy'},
		]
	},
	erika_rose_three = {
		name = "",
		descript = "",
		category  = 'group',
		unlock_price = {rose = 200, erika = 200},
		initiate_reqs = [{type = 'mission_complete', value = 'forest_erika_sidequest'}],
		actions = [
		{type = 'scene', value = 'erika_rose_2'},
		{type = 'unlock_scene', value = 'erika_rose_three'},
		]
	},
	ember_missionary = {
		name = "",
		descript = "",
		category  = 'ember',
		unlock_price = {ember = 200},
		initiate_reqs = [{type = 'mission_complete', value = 'road_to_town'}],
		actions = [
		{type = 'scene', value = 'ember_1_4'},
		{type = 'unlock_scene', value = 'ember_missionary'},
		]
	},
	ember_titjob = {
		name = "",
		descript = "",
		category  = 'ember',
		unlock_price = {ember = 500},
		initiate_reqs = [{type = 'mission_complete', value = 'road_to_town'}, {type = 'seq_seen', value = 'ember_missionary'}],
		actions = [
		{type = 'scene', value = 'ember_1_5'},
		{type = 'unlock_scene', value = 'ember_titjob'},
		]
	},
	ember_doggy = {
		name = "",
		descript = "",
		category  = 'ember',
		unlock_price = {ember = 1000},
		initiate_reqs = [{type = 'mission_complete', value = 'road_to_town'}, {type = 'seq_seen', value = 'ember_titjob'}],
		actions = [
		{type = 'scene', value = 'ember_1_6'},
		{type = 'unlock_scene', value = 'ember_doggy'},
		]
	},
	rilu_cowgirl = {
		name = "",
		descript = "",
		category  = 'rilu',
		unlock_price = {rilu = 200},
		initiate_reqs = [],
		actions = [
		{type = 'scene', value = 'rilu_1_6'},
		{type = 'unlock_scene', value = 'rilu_cowgirl'},
		]
	},
	rilu_doggy = {
		name = "",
		descript = "",
		category  = 'rilu',
		initiate_reqs = [{type = 'seq_seen', value = 'rilu_cowgirl'}],
		unlock_price = {rilu = 500},
		actions = [
		{type = 'scene', value = 'rilu_2_1'},
		{type = 'unlock_scene', value = 'rilu_doggy'},
		]
	},
	rilu_anal = {
		name = "",
		descript = "",
		category  = 'rilu',
		initiate_reqs = [{type = 'seq_seen', value = 'rilu_doggy'}],
		unlock_price = {rilu = 1000},
		actions = [
		{type = 'scene', value = 'rilu_2_2'},
		{type = 'unlock_scene', value = 'rilu_anal'},
		]
	},
	
	iola_blowjob = {
		name = "",
		descript = "",
		category  = 'iola',
		initiate_reqs = [{type = 'seq_seen', value = 'iola_recruited' }],
		unlock_price = {iola = 200},
		actions = [
		{type = 'scene', value = 'iola_2_6'},
		{type = 'unlock_scene', value = 'iola_blowjob'},
		]
	},
	iola_riding = {
		name = "",
		descript = "",
		category  = 'iola',
		initiate_reqs = [{type = 'seq_seen', value = 'iola_blowjob' }],
		unlock_price = {iola = 500},
		actions = [
		{type = 'scene', value = 'iola_2_7'},
		{type = 'unlock_scene', value = 'iola_riding'},
		]
	},
	iola_foursome = {
		name = "",
		descript = "",
		category  = 'group',
		initiate_reqs = [{type = 'seq_seen', value = 'iola_missionary' }],
		unlock_price = {iola = 500, erika = 500, rose = 500},
		actions = [
		{type = 'scene', value = 'iola_2_8'},
		{type = 'unlock_scene', value = 'iola_foursome'},
		]
	},
}

var areas = { #missions in new terminology
	road_to_village = { #tutorial mission during intro sequence. Does not allow to not progress it
		code = 'road_to_village',
		name = 'Init mission',
		descript = "",
		image = 'combat_desert',
		stages = 2, 
		enemygroups = [], 
		level = 1,
		no_escape = true,
		events = {
			on_complete_seq = 'intro_finish'
		},
		enemies = {
			1 : [
				{1 : ['elvenrat'], 3 : ['elvenrat']},
				],
			
			2 : [
				{1 : ['elvenrat']},
				{1 : ['elvenrat'], 3 : ['elvenrat'], 5 : ['elvenrat']},
				]
			
		},
		},
	forest_erika = {
		code = 'forestelves',
		name = 'Search for Elves',
		descript = "You've learned that the elves live at the ancient forest and might be able to help you ",
		image = 'combat_forest', #or not
		stages = 5, 
		level = 2,
		events = {
			after_fight_3 = 'forest_1',
			on_complete = "forest_2",
		},
		enemies = {
			1 : [
				{1 : ['elvenrat'], 2 : ['treant']},
				],
			2 : [
				{1 : ['treant'], 3 : ['treant'], 5 : ['elvenrat']},
				],
			3 : [
				{1 : ['elvenrat'], 3 : ['elvenrat'], 5 : ['elvenrat']},
				{1 : ['treant'], 3 : ['treant'], 5 : ['faery']},
				],
			4 : [
				{1 : ['treant'], 2 : ['treant'], 4 : ['treant'], 6 : ['treant']},
				{2 : ['faery'], 5 : ['faery']},
				],
			5 : [
				{2 : ['bigtreant']},
				],
			},
		},
	caves_demitrius = {
		code = 'caves_demitrius',
		name = 'Escort Demitrius', 
		descript = "",
		image = 'combat_cave',
		stages = 6, 
		level = 4,
		events = {
			after_fight_3 = 'dimitrius_1_2',
			on_complete = "dimitrius_1_3",
		},
		enemies = {
			1 : [
				{1 : ['elvenrat'], 2 : ['elvenrat'], 3 : ['elvenrat']},
				],
			2 : [
				{1 : ['spider'], 3 : ['spider']},
				],
			3 : [
				{1 : ['spider'], 3 : ['spider'], 4 : ['spider'], 6 : ['spider']},
				{1 : ['elvenrat'], 2 : ['elvenrat'], 3 : ['elvenrat']},
				{2 : ['earthgolem']},
				],
			4 : [
				{1 : ['elvenrat'], 2 : ['elvenrat'], 3 : ['elvenrat']},
				{1 : ['earthgolem'],3 : ['earthgolem']},
				],
			5 : [
				{2 : ['earthgolem',7]},
				{1 : ['spider'], 3 : ['angrydwarf']},
				],
			6 : [
				{1 : ['elvenrat', 6], 2 : ['elvenrat', 6], 3 : ['elvenrat', 6]},
				{1 : ['spider'], 2 : ['spider'], 3 : ['spider']},
				{2 : ['earthgolemboss']},
				],
			},
		},
		
	caves_iola = {
		code = 'caves_iola',
		name = "Demitrius' Daughter", 
		descript = "",
		image = 'combat_cave',
		stages = 6, 
		level = 6,
		events = {
			after_fight_3 = 'iola_1_2',
			on_complete = "iola_1_3",
		},
		enemies = {
			1 : [
				{1 : ['elvenrat'], 2 : ['mole'], 3 : ['elvenrat']},
				],
			2 : [
				{1 : ['spider'], 2:['mole'], 3 : ['mole']},
				],
			3 : [
				{2 : ['earthgolem'], 5 : ['spider']},
				],
			4 : [
				{ 1 : ['spider'], 2 : ['spider'], 3 : ['spider'], 4 : ['spider'], 5 : ['spider'], 6 : ['spider']},
				],
			5 : [
				{1 : ['angrydwarf'], 2 : ['angrydwarf'], 3 : ['angrydwarf']},
				],
			6 : [
				{1 : ['spider'], 2 : ['spider', 9], 3 : ['spider']},
				],
			},
		},
	road_to_town = {
		code = 'road_to_town',
		name = 'Road to Aeros', 
		descript = "",
		image = 'combat_desert',
		stages = 4, 
		level = 8,
		events = {
			on_complete = "aeros_1",
		},
		enemies = {
			1 : [
				{ 1 : ['spider'], 2 : ['spider'],  5 : ['spider'], 6 : ['spider']},
				],
			2 : [
				{1 : ['mole'], 3 : ['mole'], 4: ['mole'], 6:['vulture']},
				],
			3 : [
				{1 : ['vulture'], 4: ['vulture'], 5: ['vulture'], 6:['vulture']},
				],
			4 : [
				{1 : ['vulture', 12], 3 : ['mole', 12]},
				],
			},
		},
	caves_dwarf = {
		code = 'caves_dwarf',
		name = 'Dwarfing Problems', 
		descript = "",
		image = 'combat_cave2',
		stages = 8, 
		level = 11,
		events = {
			after_fight_5 = 'rilu_1_1',
			after_fight_6 = 'rilu_1_2',
			after_fight_7 = 'rilu_1_3',
			on_complete = "rilu_1_4",
		},
		enemies = {
			1 : [
				{ 1 : ['spider'], 2 : ['angrydwarf'], 3 : ['spider']},
				],
			2 : [
				{ 1 : ['angrydwarf'], 3 : ['angrydwarf']},
				],
			3 : [
				{2 : ['dwarfwarrior'], 4: ['angrydwarf'], 6: ['angrydwarf']},
				],
			4 : [
				{1 : ['angrydwarf'], 3: ['dwarfwarrior'], 4: ['spider'], 6: ['spider']},
				],
			5 : [
				{1 : ['dwarfwarrior'], 3: ['dwarfwarrior']},
				{2 : ['angrydwarf'], 5: ['angrydwarf']},
				{2 : ['spider', 15]},
				],
			6 : [
				{ 1 : ['spider'], 2 : ['spider'], 3 : ['spider'], 4 : ['earthgolem'], 6: ['earthgolem']},
				
			],
			7 : [
				{1 : ['angrydwarf'], 2: ['angrydwarf'], 3: ['angrydwarf'], 4: ['dwarfwarrior'], 6: ['dwarfwarrior']},
				{1 : ['dwarfwarrior'], 2: ['dwarfwarrior'], 3: ['dwarfwarrior']},
				],
			8 : [
				{1 : ['dwarfwarrior'], 5: ['dwarvenking'], 3: ['dwarfwarrior']},
				],
			},
		},
	
	forest_erika_sidequest = {#stub
		code = 'forest_erika_sidequest',
		name = 'Elven Medicine', 
		descript = "",
		image = 'combat_forest1',
		stages = 4, 
		level = 12,
		events = {
			#on_complete = "", To be added
		},
		enemies = {
			1 : [
				{ 1 : ['spider'], 2 : ['spider'],  5 : ['faery'], 6 : ['faery']},
				],
			2 : [
				{1 : ['treant'], 3 : ['treant'], 4: ['faery'], 6:['faery']},
				],
			3 : [
				{1 : ['faery'], 2 : ['faery'], 3: ['faery'], 4:['faery'], 6:['faery']},
				],
			4 : [
				{1 : ['treant'], 2 : ['faery'], 3: ['treant'], 4:['faery'], 6:['faery']},
				],
			},
	},
	
	forest_faeries_1 = {
		code = 'forest_faeries_1',
		name = 'Faery Queen', 
		descript = "",
		image = 'combat_forest1',
		stages = 6, 
		level = 14,
		events = {
			on_complete = "faery_queen_1",
		},
		enemies = {
			1 : [
				{ 1 : ['spider'], 2 : ['spider'],  5 : ['faery'], 6 : ['faery']},
				],
			2 : [
				{1 : ['treant'], 3 : ['treant'], 4: ['faery'], 6:['faery']},
				],
			3 : [
				{1 : ['faery'], 2 : ['faery'], 3: ['faery'], 4:['faery'], 6:['faery']},
				],
			4 : [
				{1 : ['treant'], 2 : ['faery'], 3: ['treant'], 4:['faery'], 6:['faery']},
				],
			5 : [
				{1 : ['treant'], 3 : ['treant'], 4: ['treant'], 6:['treant']},
				
				],
			6 : [
				{1 : ['faery'], 3 : ['faery'], 4: ['faery'], 6:['faery']},
				{4 : ['faery'], 5 : ['faery'], 6 : ['faery']}
				],
			},
		},
	forest_faeries_2 = {
		code = 'forest_faeries_2',
		name = 'Faering Dirty Laundry', 
		descript = "",
		image = 'combat_forest1',
		stages = 5, 
		level = 14,
		events = {
			on_complete = "faery_queen_2",
		},
		enemies = {
			1 : [
				{ 1 : ['spider'], 2 : ['spider'],  5 : ['faery'], 6 : ['faery']},
				],
			2 : [
				{1 : ['treant'], 3 : ['treant'], 4: ['faery'], 6:['faery']},
				],
			3 : [
				{1 : ['faery'], 2 : ['faery'], 3: ['faery'], 4:['faery'], 6:['faery']},
				],
			4 : [
				{1 : ['treant'], 2 : ['faery'], 3: ['treant'], 4:['faery'], 6:['faery']},
				],
			5 : [
				{1 : ['treant'], 3 : ['treant'], 4: ['treant'], 6:['treant']},
				],
			},
		},
	forest_faeries_3 = {
		code = 'forest_faeries_3',
		name = 'Trapping the Royalty', 
		descript = "",
		image = 'combat_forest1',
		stages = 3, 
		level = 14,
		events = {
			after_fight_2 = "faery_queen_3",
			on_complete = "faery_queen_4",
		},
		enemies = {
			1 : [
				{ 1 : ['spider'], 2 : ['spider'],  5 : ['faery'], 6 : ['faery']},
				],
			2 : [
				{1 : ['treant'], 3 : ['treant'], 4: ['faery'], 6:['faery']},
				],
			3 : [
				{1 : ['faery'], 5 : ['fearyqueen'], 3: ['faery']},
				],
			},
		},
	castle_iola = {
		code = 'castle_iola',
		name = 'Fetch Quest', 
		descript = "",
		image = '',
		stages = 6, 
		level = 16,
		events = {
			on_complete = "iola_2_2_1",
		},
		enemies = {
			1 : [
				{ 1 : ['zombie'], 3 : ['zombie'],  4 : ['skeleton_archer'], 6 : ['zombie']},
				],
			2 : [
				{1 : ['skeleton_warrior'], 2 : ['zombie'], 3: ['zombie'], 4:['skeleton_archer'], 5:['skeleton_archer']},
				],
			3 : [
				{1 : ['zombie'], 2 : ['zombie'], 3: ['zombie'], 4:['skeleton_warrior'], 6:['skeleton_warrior']},
				],
			4 : [
				{1 : ['wraith'], 3 : ['wraith'], 4:['skeleton_archer'], 6:['skeleton_archer']},
				],
			5 : [
				{2 : ['skeleton_warrior'], 4:['skeleton_archer'], 6:['skeleton_archer']},
				{1 : ['zombie', 20], 2 : ['zombie',20], 3 : ['zombie',20] },
				],
			6 : [
				{1 : ['skeleton_warrior'], 2 : ['wraith'], 3: ['wraith'], 4:['skeleton_archer'], 5:['skeleton_archer'], 6:['skeleton_archer']},
				{1 : ['wraith'], 2 : ['wraith'], 3: ['zombie'], 4:['skeleton_archer'], 5:['zombie'], 6:['skeleton_archer']},
				],
			},
		},
	cult_iola_rescue = {
		code = 'cult_iola_rescue',
		name = "Iola's Rescue", 
		descript = "",
		image = '',
		stages = 4, 
		level = 18,
		events = {
			on_complete = "iola_2_4",
		},
		enemies = {
			1 : [
				{ 1 : ['cult_soldier'], 3 : ['cult_soldier']},
				],
			2 : [
				{ 1 : ['cult_soldier'], 3 : ['cult_soldier'], 5 : ['cult_mage']},
				],
			3 : [
				{ 1 : ['cult_soldier'], 2 : ['cult_soldier'], 4 : ['cult_archer'], 6 : ['cult_archer']},
				{ 1 : ['cult_soldier'], 2 : ['cult_soldier'], 3 : ['cult_soldier'], 4 : ['cult_archer'], 6 : ['cult_archer']},
				],
			4 : [
				{ 1 : ['cult_soldier'], 2 : ['cult_soldier'], 3 : ['cult_soldier'], 4 : ['cult_archer'], 5: ['cult_mage'], 6 : ['cult_archer']},
				{ 1 : ['cult_soldier'], 2 : ['cult_mage'], 3 : ['cult_soldier'], 4 : ['cult_archer'], 5: ['cult_archer'], 6 : ['cult_archer']},
				{ 1 : ['cult_soldier'], 2 : ['cult_soldier'], 3 : ['cult_soldier'], 4 : ['cult_mage'], 5: ['cult_archer'], 6 : ['cult_mage']},
				],
			},
		},
		
	mountains_ember = {
		code = 'mountains_ember',
		name = 'Dragon Climbing', 
		descript = "",
		image = '',
		stages = 8, 
		level = 21,
		events = {
			after_fight_4 = 'ember_2_2',
			pre_boss_fight = "ember_2_3",
			on_complete = "ember_2_4",
		},
		enemies = {
			1 : [
				{ 1 : ['hatchling'], 3 : ['hatchling'],  4 : ['hatchling']},
				],
			2 : [
				{ 1 : ['hatchling'], 2 : ['armored_beast'], 3: ['hatchling'],5:['hatchling']},
				],
			3 : [
				{ 1 : ['wyvern'], 2 : ['wyvern'], 4 : ['hatchling'], 6 : ['hatchling']},
				],
			4 : [
				{ 1 : ['wyvern'], 3 : ['wyvern']},
				{ 1 : ['hatchling'], 2 : ['hatchling'],  3 : ['hatchling']},
				],
			5 : [
				{ 1 : ['wyvern'], 2 : ['armored_beast'], 3: ['wyvern']},
				],
			6 : [
				{ 1 : ['armored_beast'], 2 : ['hatchling'], 3: ['armored_beast'], 5 : ['hatchling']},
				],
			7 : [
				{ 1 : ['wyvern'], 3 : ['wyvern'], 5 : ['wyvern'] },
				{ 1 : ['hatchling'], 2 : ['hatchling'], 3 : ['hatchling'],  4 : ['wyvern'], 5 : ['wyvern'], 6 : ['wyvern'] },
				],
			8 : [
				{2 : ['dragon_boss']},
				],
			},
		},
		
	town_viktor_fight = {
		code = 'town_viktor_fight',
		name = 'Vengence', 
		descript = "",
		image = '',
		stages = 1, 
		level = 23,
		events = {on_complete = 'viktor_2_4'},
		enemies = {
			1 : [
				{2 : ['viktor_boss']},
				],
			},
		},
	caves_wanderer = {
		code = 'caves_iola',
		name = '', 
		descript = "",
		image = '',
		stages = 6, 
		level = 24,
		events = {
			after_fight_3 = 'iola_3_2',
			on_complete = "iola_3_3",
		},
		enemies = {
			1 : [
				{ 1 : ['spider'], 2 : ['earthgolem'],  3 : ['spider'], 4 : ['spider'], 5 : ['spider'], 6 : ['spider']},
				],
			2 : [
				{ 1 : ['dwarfwarrior'], 2 : ['dwarfwarrior'], 3: ['earthgolem'],5:['angrydwarf']},
				],
			3 : [
				{ 1 : ['dwarfwarrior'], 2 : ['dwarfwarrior'], 3 : ['dwarfwarrior'], 4 : ['angrydwarf'], 6 : ['angrydwarf']},
				],
			4 : [
				{ 1 : ['earthgolem'], 3 : ['earthgolem'], 4 : ['spider'], 6 : ['spider']},
				{ 1 : ['angrydwarf'], 2 : ['dwarfwarrior'], 3 : ['angrydwarf'], 4 : ['dwarfwarrior'], 5 : ['angrydwarf'], 6 : ['dwarfwarrior']},
				],
			5 : [
				{ 1 : ['spider'], 2 : ['spider'], 3: ['spider'], 4 : ['earthgolem'], 6 : ['earthgolem']},
				],
			6 : [
				{ 1 : ['earthgolemboss'], 3: ['earthgolemboss']},
				],
			},
		},
		
	town_siege = {
		code = 'town_siege',
		name = 'Pandemonium', 
		descript = "",
		image = '',
		stages = 7, 
		level = 25,
		events = {
			after_fight_3 = 'town_siege_intermission',#to be added
			pre_boss = 'annet_1',
			on_complete = "annet_2",
		},
		enemies = {
			1 : [
				{ 1 : ['spider'], 2 : ['earthgolem'],  3 : ['spider'], 4 : ['spider'], 5 : ['spider'], 6 : ['spider']},
				],
			2 : [
				{ 1 : ['dwarfwarrior'], 2 : ['dwarfwarrior'], 3: ['earthgolem'],5:['angrydwarf']},
				],
			3 : [
				{ 1 : ['dwarfwarrior'], 2 : ['dwarfwarrior'], 3 : ['dwarfwarrior'], 4 : ['angrydwarf'], 6 : ['angrydwarf']},
				],
			4 : [
				{ 1 : ['earthgolem'], 3 : ['earthgolem'], 4 : ['spider'], 6 : ['spider']},
				{ 1 : ['angrydwarf'], 2 : ['dwarfwarrior'], 3 : ['angrydwarf'], 4 : ['dwarfwarrior'], 5 : ['angrydwarf'], 6 : ['dwarfwarrior']},
				],
			5 : [
				{ 1 : ['spider'], 2 : ['spider'], 3: ['spider'], 4 : ['earthgolem'], 6 : ['earthgolem']},
				],
			6 : [
				{ 1 : ['earthgolemboss'], 3: ['earthgolemboss']},
				],
			},
		},
	castle_rilu = {
		code = 'castle_rilu',
		name = 'Escort Demitrius', 
		descript = "",
		image = '',
		stages = 4, 
		level = 25,
		events = {
			on_complete = 'rilu_2_4'
		},
		enemies = {
			
			1 : [
				{ 1 : ['zombie'], 3 : ['zombie']},
				],
			2 : [
				{2 : ['skeleton_warrior'], 5 : ['skeleton_archer']},
				],
			3 : [
				{1 : ['zombie'], 3:['skeleton_warrior']},
				],
			4 : [
				{ 2:['skeleton_warrior',30]},
				],
			},
		},
	castle_rilu_return = {
		code = 'castle_rilu_return',
		name = 'Escort Demitrius', 
		descript = "",
		image = '',
		stages = 7, 
		level = 27,
		events = {
			pre_boss = 'zelroth_1',
			on_complete = "zelroth_2",
		},
		enemies = {
			
			1 : [
				{ 1 : ['zombie'], 2 : ['zombie'], 3 : ['zombie'], 4 : ['skeleton_archer'], 5 : ['zombie'], 6 : ['skeleton_archer']},
				],
			2 : [
				{ 1 : ['zombie'], 2 : ['zombie'], 3 : ['zombie'], 4 : ['skeleton_archer'], 5 : ['zombie'], 6 : ['skeleton_archer']},
				{ 1 : ['skeleton_warrior'], 2 : ['zombie'], 3 : ['skeleton_warrior'], 4 : ['skeleton_archer'], 5 : ['skeleton_archer'], 6 : ['skeleton_archer']},
				],
			3 : [
				{ 1 : ['skeleton_warrior'], 2 : ['skeleton_warrior'], 3 : ['skeleton_warrior'], 4 : ['zombie'], 5 : ['zombie'], 6 : ['zombie']},
				{ 1 : ['zombie'], 2 : ['zombie'], 3 : ['zombie'], 4 : ['skeleton_archer'], 5 : ['skeleton_archer'], 6 : ['skeleton_archer']},
				],
			4 : [
				{ 1 : ['skeleton_warrior'], 2 : ['wraith'], 3 : ['skeleton_warrior'], 4 : ['skeleton_warrior'], 5 : ['wraith'], 6 : ['zombie']},
				],
			5 : [
				{ 1 : ['wraith'], 2 : ['wraith'], 3 : ['zombie'], 4 : ['skeleton_warrior'], 5 : ['skeleton_archer'], 6 : ['skeleton_archer']},
				],
				
			6 : [
				{ 1 : ['zombie'], 2 : ['zombie'], 3 : ['zombie'], 4 : ['zombie'], 5 : ['zombie'], 6 : ['zombie']},
				{ 1 : ['skeleton_warrior'], 2 : ['skeleton_warrior'], 3 : ['skeleton_warrior'], 4 : ['skeleton_archer'], 5 : ['skeleton_archer'], 6 : ['skeleton_archer']},
				{ 1 : ['wraith'], 2 : ['wraith'], 3 : ['wraith'], 4 : ['wraith'], 5 : ['wraith'], 6 : ['wraith']},
				],
				
			7 : [
				{ 5:['scientist_boss'], 2:['caliban']},
				],
			},
		},
	
	cult_rose_rescue = {
		code = 'cult_rose_rescue',
		name = 'Escort Demitrius', 
		descript = "",
		image = '',
		stages = 9, 
		level = 28,
		events = {
			on_complete = 'dimitrius_2_2',
		},
		enemies = {
			1 : [
				{ 1 : ['cult_soldier'], 3 : ['cult_soldier']},
				],
			2 : [
				{ 1 : ['cult_soldier'], 3 : ['cult_soldier'], 5 : ['cult_mage']},
				],
			3 : [
				{ 1 : ['cult_soldier'], 2 : ['cult_soldier'], 4 : ['cult_archer'], 6 : ['cult_archer']},
				{ 1 : ['cult_soldier'], 2 : ['cult_soldier'], 3 : ['cult_soldier'], 4 : ['cult_archer'], 6 : ['cult_archer']},
				],
			4 : [
				{ 1 : ['cult_soldier'], 2 : ['cult_soldier'], 3 : ['cult_soldier'], 4 : ['cult_archer'], 5: ['cult_mage'], 6 : ['cult_archer']},
				{ 1 : ['cult_soldier'], 2 : ['cult_mage'], 3 : ['cult_soldier'], 4 : ['cult_archer'], 5: ['cult_archer'], 6 : ['cult_archer']},
				{ 1 : ['cult_soldier'], 2 : ['cult_soldier'], 3 : ['cult_soldier'], 4 : ['cult_mage'], 5: ['cult_archer'], 6 : ['cult_mage']},
				],
			},
		},
	modern_city_stage1 = {
		code = 'modern_city_stage1',
		name = 'Escort Demitrius', 
		descript = "",
		image = '',
		stages = 10, 
		level = 30,
		},
	
	forest_erika_rose_mission = {
		code = 'forest_erika_rose_mission',
		name = 'Search for Elves',
		descript = "",
		image = '',
		stages = 6, 
		level = 20,
		},
}




func check_area_avail(area):
	if !state.areaprogress.has(area): return false #for not implemented missions
	return state.areaprogress[area].unlocked
#	if !state.checkreqs(area.requirements): return false
#	if state.areaprogress.has(area.code) and state.areaprogress[area.code] >= area.stages and area.stages != 0: return false
#	return true


func check_location_activity(loc): #if there is mission avail
	if locations[loc].missions.empty():
		return true
	for i in locations[loc].missions:
		if !check_area_avail(i): continue
		return true
	return false


func check_area_new_avail(area):
	if !state.areaprogress.has(area): return false #for not implemented missions
	if !state.areaprogress[area].unlocked: return false
	return !state.areaprogress[area].completed


func check_new_location_activity(loc): #if there is non-completed mission avail
	if locations[loc].missions.empty():
		return true
	for i in locations[loc].missions:
		if !check_area_new_avail(i): continue
		return true
	return false


func preload_resources():
	for rec in locations.values():
		print("bg/%s" % rec.background) 
		resources.preload_res("bg/%s" % rec.background)
	for rec in areas.values():
		if rec.has('image') and rec.image != null and rec.image != '':
			print("bg/%s" % rec.image)
			resources.preload_res("bg/%s" % rec.image)
		
