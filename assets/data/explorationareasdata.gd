extends Node


var event_triggers = {#reworked to same syntax as seqs
	intro_1 = [
		{type = 'mission', value = 'road_to_village', auto_advance = true, no_autosave = true},
	],
	intro_2 = [
		{type = 'scene', value = 'intro_3'},
		{type = 'system', value = 'unlock_area', arg = 'forest'},
		{type = 'system', value = 'unlock_mission', arg = 'forest_erika'},
#		{type = 'show_screen', value = 'village'},
#		{type = 'system', value = 'unlock_building', arg = 'bridge'}#unlocked from very beginning
	],
	intro_3 = [
		{type = 'tutorial', value = 'exploration_menu'},
	],
	forest_2 = [
		{type = 'system', value = 'enable_character', arg = ['erika', true]},
		{type = 'show_screen', value = 'map'},
	],
	erika_1 = [
		{type = 'show_screen', value = 'village'},
		{type = 'tutorial', value = 'quest_character'}
	],
	ember_1_1 = [
		{type = 'tutorial', value = 'building_upgrades'},#mind that tutorial here must precede enable_character for node order
#		{type = 'system', value = 'unlock_building', arg = 'forge'},#done by hand with tutorial now
		{type = 'system', value = 'enable_character', arg = ['ember', true]},
	],
	ember_1_2 = [
		{type = 'tutorial', value = 'forge'},
	],
	dimitrius_1_3 = [
		{type = 'scene', value = 'dimitrius_1_4'},
	],
	dimitrius_1_4 = [
		{type = 'show_screen', value = 'map'},
	],
	aeros_1 = [
		{type = 'system', value = 'unlock_mission', arg = 'caves_dwarf'},
		{type = 'show_screen', value = 'map'},
	],
	aeros_2 = [
		{type = 'scene', value = 'flak_2'},
	],
	aeros_3 = [
		{type = 'system', value = 'unlock_mission', arg = 'forest_faeries_1'},
	],
	erika_annet_2_1 = [
		{type = 'scene', value = 'erika_annet_2_2', reqs = [{type = 'rule', value = 'forced_content', arg = 'true'}]},#skip if forced content is disabled 
	],
	iola_2_2_1 = [
		{type = 'system', value = 'unlock_area', arg = 'cult'},
		{type = 'show_screen', value = 'map'},
	],
#	rilu_1_2 = [
#		{type = 'system', value = 'heal_team'},
#	],
	rilu_1_3 = [
		{type = 'system', value = 'enable_character', arg = ['rilu', true]},
		{type = 'system', value = 'add_to_party', arg = ['rilu', 3]},
#		{type = 'system', value = 'heal_team'},
	],
	faery_queen_1 = [
		{type = 'scene', value = 'faery_queen_1_a', reqs = [{type = 'decision', name = 'portal'}]},
		{type = 'scene', value = 'faery_queen_1_b'},
	],
	faery_queen_1_a = [
		{type = 'scene', value = 'faery_queen_1_b'},
	],
	faery_queen_1_b = [
		{type = 'system', value = 'unlock_mission', arg = 'forest_faeries_2'},
#		{type = 'show_screen', value = 'map'},#not tested
	],
	faery_queen_2 = [
		{type = 'system', value = 'unlock_mission', arg = 'forest_faeries_3'},
#		{type = 'show_screen', value = 'map'},#not tested
	],
	
	faery_queen_4 = [
		{type = 'show_screen', value = 'map'},
	],
	
	victor_2_3 = [
		{type = 'mission', value = 'town_viktor_fight'},
	],
	rilu_2_3_1 = [
		{type = 'system', value = 'enable_character', arg = ['rilu', false]}
	],
	rilu_2_3_2 = [
		{type = 'system', value = 'enable_character', arg = ['ember', false, false]},
		{type = 'system', value = 'enable_character', arg = ['iola', false, false]},
		{type = 'system', value = 'enable_character', arg = ['rose', false, false]},
		{type = 'system', value = 'enable_character', arg = ['erika', false, false]},
		{type = 'system', value = 'add_to_party', arg = ['arron', 2]},
		{type = 'mission', value = 'castle_rilu'},
	],
	rilu_2_4 = [
		{type = 'system', value = 'enable_character', arg = ['ember', true, false]},
		{type = 'system', value = 'enable_character', arg = ['iola', true, false]},
		{type = 'system', value = 'enable_character', arg = ['rose', true, false]},
		{type = 'system', value = 'enable_character', arg = ['erika', true, false]},
		{type = 'system', value = 'enable_character', arg = ['rilu', true]},
	],
	ember_2_4 = [
#		{code = 'system', value = 'start_next_scene', args = 'viktor_2_1'},
		{type = 'scene', value = 'victor_2_1'},
	],
	victor_2_1 = [
		{type = 'show_screen', value = 'map'},
	],
	iola_2_4 = [
#		{code = 'system', value = 'show_screen', args = 'village'},
		{type = 'show_screen', value = 'village'},
	],
	dimitrius_2_1_2 = [
		{type = 'system', value = 'unlock_mission', arg = 'cult_rose_rescue'},
	],
	dimitrius_2_2 = [
		{type = 'system', value = 'enable_character', arg = ['iola', true] },
	],
	dimitrius_ending_1 = [
		{type = 'show_screen', value = 'exploration', arg = 'modern_city'},
	],
	dimitrius_ending_3 = [
		{type = 'system', value = 'unlock_mission', arg = 'final_battle_sewers' },
	],
	dimitrius_ending_4 = [
		{type = 'system', value = 'unlock_mission', arg = 'final_battle_plant' },
	],
	dimitrius_ending_6 = [
		{type = 'system', value = 'enable_character', arg = ['arron', false, false] },
		{type = 'system', value = 'enable_character', arg = ['ember', false, false] },
		{type = 'system', value = 'enable_character', arg = ['iola', false, false] },
		{type = 'system', value = 'enable_character', arg = ['rilu', false, false] },
		{type = 'system', value = 'add_to_party', arg = ['rose', 1]},
		{type = 'system', value = 'add_to_party', arg = ['erika', 2]},
	],
	dimitrius_ending_7 = [
		{type = 'system', value = 'enable_character', arg = ['ember',true, false] },
		{type = 'system', value = 'enable_character', arg = ['iola',true, false] },
		{type = 'system', value = 'enable_character', arg = ['rilu',true, false] },
		{type = 'system', value = 'enable_character', arg = ['rose',false, false] },
		{type = 'system', value = 'enable_character', arg = ['erika',false, false] },
		{type = 'system', value = 'add_to_party', arg = ['ember', 1]},
		{type = 'system', value = 'add_to_party', arg = ['iola', 2]},
		{type = 'system', value = 'add_to_party', arg = ['rilu', 3]},
	],
	dimitrius_ending_8 = [
		{type = 'system', value = 'enable_character', arg = ['arron', true, false] },
		{type = 'system', value = 'enable_character', arg = ['ember', false, false] },
		{type = 'system', value = 'enable_character', arg = ['iola', false, false] },
		{type = 'system', value = 'enable_character', arg = ['rilu', false, false] },
		{type = 'system', value = 'add_to_party', arg = ['arron', 2]},
	],
	dimitrius_ending_9 = [
		{type = 'scene', value = 'ending_1'},
	],
	ending_1 = [
		{type = 'system', value = 'credits'},
	],
}

var locations = { #added seqs bindings and other fields
	village =  {
		code = 'village',
		background = null, 
		missions = [],
		events = ['erika_at_village','dimitrius_2_1_2']
	},
	forest =  {
		code = 'forest',
		background = 'forest',
		missions = ['forest_erika','forest_faeries_1','forest_faeries_2','forest_faeries_3','forest_erika_sidequest'],
		events = []
	},
	cave =  {
		code = 'cave',
		background = 'cave', 
		missions = ['caves_demitrius','caves_iola','caves_dwarf','caves_wanderer'],
		events = []
	},
#	road_to_town =  { #needs rebinding or adding a dedicated map location
#		code = 'desert',
#		background = '',
#		missions = ['road_to_town'],
#	},
	town =  { #should have differnet custom handling
		#idk for what reason
		code = 'town',
		background = 'town_in',
#		missions = ['town_viktor_fight','town_siege'],
		missions = ['road_to_town', 'town_siege'],
#		function = '',
		events = ['town_gates', 'search_clues', 'viktor_introduction', 'annet_introduction', 'erika_meet_annet', 'arron_meet_annet', 'rose_annet_rescue', 'viktor_duel', 'city_raid']
	},
	castle =  {
		code = 'castle',
		background = 'castle_interior', 
		missions = ['castle_iola','castle_rilu_return'],
		events = ['rilu_castle']
	},
	dragon_mountains = {
		code = 'dragon_mountains',
		background = 'mountainsday',
		missions = ['dragon_mountains'],
		events = []
	},
	cult =  {
		code = 'cult',
		background = 'cult',
		missions = ['cult_iola_rescue','cult_rose_rescue'],
		events = ['iola_gets_caught', 'iola_rescue_start', ]
	},
	modern_city =  {
		code = 'modern_city',
		background = 'future_city',
		missions = ['final_battle_stage1', 'final_battle_sewers', 'final_battle_plant'],
		events = ["dimitrius_ending_1"]
	},
}


var buildings = { #for binding village buidings events
	townhall = {
		events = ['rose_reunion']
	},
	forge = {
		events = ['ember_smith']
	},
}


var characters = { #for binding village characters events
	#i was forced to use scendata keys due to having characters that are not heroes here and reqirement to get their portarits
	Em = ['ember_arrival', 'ember_arc_initiate', 'viktor_sends_threat'],
	I = ['iola_arrival', 'iola_second_visit', 'iola_recruited', 'iola_wanderer'],
	D = ['dimitrius_arrival'], #there is a problem in this - it appears directly after closing ember arrival scene, that is not good
	F = ['flak_task', 'flak_task_return', 'flak_town_raid', 'flak_modern_city'],
	Ri = ['rilu_accepted', 'rilu_reports_iola', 'rilu_disappear'],
	Ro = ['rose_kidnap'],
	Er = ['erika_rose_init'],
}


var scene_sequences = { 
	
	intro = {
#		initiate_signal = 'game_start', #can be signals like 'click specific location'
		initiate_reqs = [], #all sequences only playable once, unless specified
		actions = [
		{type = 'scene', value = 'intro_1'},
		#actually stops here
#		{type = 'mission', value = 'road_to_village'},
#		{type = 'scene', value = 'intro_2'},
#		{type = 'scene', value = 'intro_3'},
##		{type = 'system', value = 'start_game'},
#		{type = 'system', value = 'unlock_character', arg = 'arron'}, #there should be rose for sure
#		{type = 'system', value = 'unlock_area', arg = 'village'} #Suggestion: hardcode similar unlocks into single function i.e. start_game one
		]
	},
	intro_finish = {
		initiate_reqs = [],
		actions = [
			{type = 'scene', value = 'intro_2'},
#			{type = 'system', value = 'unlock_character', arg = 'rose'},
			{type = 'system', value = 'unlock_area', arg = 'village'},
			{type = 'show_screen', value = 'village'},
		]
	},
	erika_at_village = {
#		initiate_signal = 'village_activate', 
		initiate_reqs = [{type = 'mission_complete', value = 'forest_erika'}],
		actions = [
		{type = 'scene', value = 'erika_1'},
#		{type = 'system', value = 'unlock_character', arg = 'erika'},#duplicate of postscene action
		]
	},
	
	ember_arrival = {
#		initiate_signal = 'village_townhall_ember', 
		initiate_reqs = [{type = 'mission_complete', value = 'forest_erika'}],
		actions = [
		{type = 'scene', value = 'ember_1_1'},
		]
	},
	
	ember_smith = {
#		initiate_signal = 'village_smith', 
		initiate_reqs = [{type = 'seq_seen', value = 'ember_arrival'}],
		actions = [
		{type = 'scene', value = 'ember_1_2'},
		]
	},
	
	dimitrius_arrival = {
#		initiate_signal = 'village_townhall_dimitrius', 
		initiate_reqs = [{type = 'seq_seen', value = 'ember_arrival'}],
		actions = [
		{type = 'scene', value = 'dimitrius_1_1'},
		{type = 'system', value = 'unlock_area', arg = 'cave'},
		{type = 'system', value = 'unlock_mission', arg = 'caves_demitrius'}
		]
	},
	
	iola_arrival = {
#		initiate_signal = 'village_townhall_iola', 
		initiate_reqs = [{type = 'mission_complete', value = 'caves_demitrius'}],
		actions = [
		{type = 'scene', value = 'iola_1_1'},
		{type = 'system', value = 'unlock_mission', arg = 'caves_iola'}
		]
	},
	
	flak_task = {
#		initiate_signal = 'village_townhall_fask', 
		initiate_reqs = [{type = 'mission_complete', value = 'caves_iola'}],
		actions = [
		{type = 'scene', value = 'flak_1'},
		{type = 'system', value = 'unlock_area', arg = 'town'},
		{type = 'system', value = 'unlock_mission', arg = 'road_to_town'}
		]
	},
	
	town_gates = {
#		initiate_signal = 'town', 
		initiate_reqs = [{type = 'mission_complete', value = 'caves_dwarf'}],
		actions = [{type = 'scene', value = 'aeros_2'}]
	},
	
	flak_task_return = {
#		initiate_signal = 'village_townhall_fask', 
		initiate_reqs = [{type = 'scene_seen', value = 'flak_2'}],
		actions = [
		{type = 'scene', value = 'flak_3'},
		]
	},
	
	rilu_accepted = {
		initiate_reqs = [{type = 'mission_complete', value = 'caves_dwarf'}],
		actions = [{type = 'scene', value = 'rilu_1_5'}]
	},
	
	search_clues = {
		initiate_reqs = [{type = 'scene_seen', value = 'rilu_1_5'}],
		actions = [
		{type = 'scene', value = 'aeros_3'},
		]
	},
	
	viktor_introduction = {
#		initiate_signal = 'town', 
		initiate_reqs = [{type = 'scene_seen', value = 'aeros_2'}],
		actions = [
		{type = 'scene', value = 'victor_1'},
		]
	},
	annet_introduction = {
#		initiate_signal = 'town', 
		initiate_reqs = [{type = 'mission_complete', value = 'forest_faeries_1'}],
		actions = [
		{type = 'scene', value = 'erika_annet_1'},
		]
	},
	erika_meet_annet = {
#		initiate_signal = 'town', 
		initiate_reqs = [{type = 'mission_complete', value = 'forest_faeries_3'}],
		actions = [
		{type = 'scene', value = 'erika_annet_2_1'}, 
		{type = 'system', value = 'enable_character', arg = ['erika', false] },
#		{type = 'scene', value = 'erika_annet_2_2', reqs = [{type = 'rule', value = 'forced_content', arg = 'true'}]},#skip if forced content is disabled 
		
		]
	},
	arron_meet_annet = {
#		initiate_signal = 'town', 
		initiate_reqs = [{type = 'seq_seen', value = 'erika_meet_annet'}],
		actions = [
		{type = 'scene', value = 'erika_annet_2_3'}, 
		]
	
	},
	rose_annet_rescue = {
#		initiate_signal = 'town', 
		initiate_reqs = [{type = 'seq_seen', value = 'arron_meet_annet'}],
		actions = [
		{type = 'scene', value = 'erika_annet_2_4'},
		{type = 'system', value = 'game_stage', arg = 'erika_rescued'},
		{type = 'system', value = 'enable_character', arg = ['erika', true] },
		]
	},
	
	iola_second_visit = {
#		initiate_signal = 'village_townhall_iola', 
		initiate_reqs = [{type = 'seq_seen', value = 'rose_annet_rescue'}],
		actions = [
		{type = 'scene', value = 'iola_2_1'},
		{type = 'system', value = 'unlock_area', arg = 'castle'},
		{type = 'system', value = 'unlock_mission', arg = 'castle_iola'}
		]
	},
	iola_gets_caught = {
#		initiate_signal = 'cult_grounds', #?
		initiate_reqs = [{type = 'mission_complete', value = 'castle_iola'}],
		actions = [
		{type = 'scene', value = 'iola_2_2_2'},
		]
	},
	rilu_reports_iola = {
#		initiate_signal = 'village_townhall_rilu', 
		initiate_reqs = [{type = 'seq_seen', value = 'iola_gets_caught'}],
		actions = [
		{type = 'scene', value = 'iola_2_2_3'},
		{type = 'system', value = 'unlock_mission', arg = 'cult_iola_rescue'}
		]
	},
	iola_rescue_start = {
#		initiate_signal = 'cult', 
		initiate_reqs = [{type = 'seq_seen', value = 'rilu_reports_iola'}],
		actions = [
		{type = 'scene', value = 'iola_2_3'},
		{type = 'system', value = 'unlock_mission', arg = 'cult_iola_rescue'}
		]
	},
	iola_recruited = {
#		initiate_signal = 'village_townhall_iola', 
		initiate_reqs = [{type = 'mission_complete', value = 'cult_iola_rescue'}],
		actions = [
		{type = 'scene', value = 'iola_2_5'},
		{type = 'system', value = 'enable_character', arg = ['iola', true]},
		]
	},
	
	ember_arc_initiate = {
#		initiate_signal = 'village_townhall_ember', 
		initiate_reqs = [{type = 'seq_seen', value = 'iola_recruited'}],
		actions = [
		{type = 'scene', value = 'ember_2_1'},
		{type = 'system', value = 'unlock_area', arg = 'dragon_mountains'},
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
#		initiate_signal = 'village_townhall_ember', 
		initiate_reqs = [{type = 'scene_seen', value = 'victor_2_1'}],
		actions = [
		{type = 'scene', value = 'victor_2_2'},
#		{type = 'system', value = 'unlock_mission', arg = 'town_viktor_fight'}
		]
	},
	viktor_duel = {
#		initiate_signal = 'town', 
		initiate_reqs = [{type = 'seq_seen', value = 'viktor_sends_threat'}],
		actions = [
		{type = 'scene', value = 'victor_2_3'}, 
#		{type = 'mission', value = 'town_viktor_fight'},
#		{type = 'scene', value = 'victor_2_4'}
		]
	},
	rilu_disappear =  {
#		initiate_signal = 'village_townhall_rilu', 
		initiate_reqs = [{type = 'mission_complete', value = 'town_viktor_fight'}],
		actions = [
		{type = 'scene', value = 'rilu_2_3_1'},
		]
	},
	rilu_castle = {
#		initiate_signal = 'castle', 
		initiate_reqs = [{type = 'seq_seen', value = 'rilu_disappear'}],
		actions = [
		{type = 'scene', value = 'rilu_2_3_2'},
#		{type = 'mission', value = 'castle_rilu'},
#		{type = 'scene', value = 'rilu_2_4'},
		]
	},
	iola_wanderer = {
#		initiate_signal = 'village_townhall_iola', 
		initiate_reqs = [{type = 'mission_complete', value = 'castle_rilu'}],
		actions = [
		{type = 'scene', value = 'iola_3_1'},
		{type = 'system', value = 'unlock_mission', arg = 'caves_wanderer'}
		]
	},
	flak_town_raid = {
#		initiate_signal = 'village_townhall_flak', 
		initiate_reqs = [{type = 'mission_complete', value = 'caves_wanderer'}],
		actions = [
		{type = 'scene', value = 'flak_city_raid'}
		]
	},
	city_raid = {
#		initiate_signal = 'town',
		initiate_reqs = [{type = 'seq_seen', value = 'flak_town_raid'}],
		actions = [
		{type = 'scene', value = 'city_raid'},
		{type = 'system', value = 'unlock_mission', arg = 'town_siege'}
		]
	},
	
	rose_kidnap = {
#		initiate_signal = 'village_townhall_rose', 
		initiate_reqs = [{type = 'mission_complete', value = 'town_siege'}],
		actions = [
		{type = 'scene', value = 'dimitrius_2_1'},
		{type = 'system', value = 'unlock_mission', arg = 'castle_rilu_return'},
		{type = 'system', value = 'enable_character', arg = ['rose', false] },
		{type = 'system', value = 'enable_character', arg = ['iola', false] },
		]
	},
	dimitrius_2_1_2 = {
#		initiate_signal = 'village', 
		initiate_reqs = [{type = 'mission_complete', value = 'castle_rilu_return'}],
		actions = [
		{type = 'scene', value = 'dimitrius_2_1_2'},
		]
	},
	rose_reunion = {
#		initiate_signal = 'village_townhall', 
		initiate_reqs = [{type = 'mission_complete', value = 'cult_rose_rescue'}],
		actions = [
		{type = 'scene', value = 'rose_2'},
		{type = 'system', value = 'enable_character', arg = ['rose', true] },
		]
	},
	
	flak_modern_city = {
#		initiate_signal = 'village_townhall_flak', 
		initiate_reqs = [{type = 'seq_seen', value = 'rose_reunion'}],
		actions = [
		{type = 'scene', value = 'flak_future_city'},
		{type = 'system', value = 'unlock_area', arg = 'modern_city'},
		]
	},
	
	erika_rose_init = {
#		initiate_signal = 'village_townhall_erika', 
		initiate_reqs = [
#			{type = 'seq_seen', value = 'erika_doggy'},
			{type = 'decision', name = 'erika_2_true'},
		],
		actions = [
		{type = 'scene', value = 'erika_rose_1'},
		{type = 'system', value = 'unlock_mission', arg = 'forest_erika_sidequest'}
		]
		
	},
	dimitrius_ending_1 = {
		initiate_reqs = [{type = 'seq_seen', value = 'flak_modern_city'}],
		actions = [
		{type = 'scene', value = 'dimitrius_ending_1'},
		{type = 'system', value = 'unlock_mission', arg = 'final_battle_stage1'},
		]
	},
	
	
	
	#Gallery scenes
	ember_boobs = {
		name = "GALLERY_EMBER_BOOBS",
		descript = "",
		gallery = true,
		preview = 'ember_boobs',
		initiate_reqs = [{type = 'seq_seen', value = 'ember_arrival'}],
		unlock_price = {ember = 50},
		actions = [
		{type = 'scene', value = 'ember_1_3'},
		{type = 'unlock_scene', value = 'ember_boobs'},#for gallery
		]
	},
	rose_night = {
		name = "GALLERY_ROSE_NIGHT",
		descript = "",
		gallery = true,
		preview = 'rose_night',
		initiate_reqs = [{type = 'seq_seen', value = 'ember_boobs'}],
		unlock_price = {rose = 50},
		actions = [
		{type = 'scene', value = 'rose_1'},
		{type = 'unlock_scene', value = 'rose_night'},
		]
	},
	rose_public = {
		name = "GALLERY_ROSE_PUBLIC",
		descript = "",
		gallery = true,
		preview = 'rose_public',
		initiate_reqs = [{type = 'scene_seen', value = 'aeros_2'},{type = 'seq_seen', value = 'rose_night'}],
		unlock_price = {rose = 250},
		actions = [
		{type = 'scene', value = 'rose_3'},
		{type = 'unlock_scene', value = 'rose_public'},
		]
	},
	erika_doggy = {
		name = "GALLERY_ERIKA_DOGGY",
		descript = "",
		gallery = true,
		preview = 'erika_doggy',
		initiate_reqs = [],
		unlock_price = {erika = 50},
		actions = [
		{type = 'scene', value = 'erika_2'},
		{type = 'unlock_scene', value = 'erika_doggy'},
		]
	},
	erika_rose_three = {
		name = "GALLERY_ERIKA_ROSE_THREE",
		descript = "",
		gallery = true,
		preview = 'erika_rose_three',
		unlock_price = {rose = 100, erika = 100},
		initiate_reqs = [{type = 'mission_complete', value = 'forest_erika_sidequest'}],
		actions = [
		{type = 'scene', value = 'erika_rose_2'},
		{type = 'unlock_scene', value = 'erika_rose_three'},
		]
	},
	ember_missionary = {
		name = "GALLERY_EMBER_MISSIONARY",
		descript = "",
		gallery = true,
		preview = 'ember_missionary',
		unlock_price = {ember = 100},
		initiate_reqs = [{type = 'mission_complete', value = 'road_to_town'}],
		actions = [
		{type = 'scene', value = 'ember_1_4'},
		{type = 'unlock_scene', value = 'ember_missionary'},
		]
	},
	ember_titjob = {
		name = "GALLERY_EMBER_TITJOB",
		descript = "",
		gallery = true,
		preview = 'ember_titjob',
		unlock_price = {ember = 250},
		initiate_reqs = [{type = 'seq_seen', value = 'ember_missionary'}],
		actions = [
		{type = 'scene', value = 'ember_1_5'},
		{type = 'unlock_scene', value = 'ember_titjob'},
		]
	},
	ember_doggy = {
		name = "GALLERY_EMBER_DOGGY",
		descript = "",
		gallery = true,
		preview = 'ember_doggy',
		unlock_price = {ember = 500},
		initiate_reqs = [{type = 'seq_seen', value = 'ember_titjob'}],
		actions = [
		{type = 'scene', value = 'ember_1_6'},
		{type = 'unlock_scene', value = 'ember_doggy'},
		]
	},
	rilu_cowgirl = {
		name = "GALLERY_RILU_COWGIRL",
		descript = "",
		gallery = true,
		preview = 'rilu_cowgirl',
		unlock_price = {rilu = 100},
		initiate_reqs = [],
		actions = [
		{type = 'scene', value = 'rilu_1_6'},
		{type = 'unlock_scene', value = 'rilu_cowgirl'},
		]
	},
	rilu_doggy = {
		name = "GALLERY_RILU_DOGGY",
		descript = "",
		gallery = true,
		preview = 'rilu_doggy',
		initiate_reqs = [{type = 'seq_seen', value = 'rilu_cowgirl'}],
		unlock_price = {rilu = 250},
		actions = [
		{type = 'scene', value = 'rilu_2_1'},
		{type = 'unlock_scene', value = 'rilu_doggy'},
		]
	},
	rilu_anal = {
		name = "GALLERY_RILU_ANAL",
		descript = "",
		gallery = true,
		preview = 'rilu_anal',
		initiate_reqs = [{type = 'seq_seen', value = 'rilu_doggy'}],
		unlock_price = {rilu = 500},
		actions = [
		{type = 'scene', value = 'rilu_2_2'},
		{type = 'unlock_scene', value = 'rilu_anal'},
		]
	},
	
	iola_blowjob = {
		name = "GALLERY_IOLA_BLOWJOB",
		descript = "",
		gallery = true,
		preview = 'iola_blowjob',
		initiate_reqs = [{type = 'seq_seen', value = 'iola_recruited' }],
		unlock_price = {iola = 50},
		actions = [
		{type = 'scene', value = 'iola_2_6'},
		{type = 'unlock_scene', value = 'iola_blowjob'},
		]
	},
	iola_cunnilingus = {
		name = "GALLERY_IOLA_CUNNILINGUS",
		descript = "",
		gallery = true,
		preview = 'iola_cunnilingus',
		initiate_reqs = [{type = 'seq_seen', value = 'iola_blowjob' }],
		unlock_price = {iola = 100},
		actions = [
		{type = 'scene', value = 'iola_1_5'},
		{type = 'unlock_scene', value = 'iola_cunnilingus'},
		]
	},
	iola_riding = {
		name = "GALLERY_IOLA_RIDING",
		descript = "",
		gallery = true,
		preview = 'iola_riding',
		initiate_reqs = [{type = 'seq_seen', value = 'iola_cunnilingus' }],
		unlock_price = {iola = 250},
		actions = [
		{type = 'scene', value = 'iola_1_6'},
		{type = 'unlock_scene', value = 'iola_riding'},
		]
	},
	iola_foursome = {
		name = "GALLERY_IOLA_FOURSOME",
		descript = "",
		gallery = true,
		preview = 'iola_foursome',
		initiate_reqs = [{type = 'seq_seen', value = 'iola_riding' }],
		unlock_price = {iola = 250, erika = 250, rose = 250},
		actions = [
		{type = 'scene', value = 'iola_2_7'},
		{type = 'unlock_scene', value = 'iola_foursome'},
		]
	},
}

var areas = { #missions in new terminology
	road_to_village = { #tutorial mission during intro sequence. Does not allow to not progress it
		code = 'road_to_village',
		name = 'Init mission', #is it valid?
		descript = "",
		image = ['combat_desert_1', 'combat_desert_2', 'combat_desert_3'],
		explore_image = 'combat_desert',
		stages = 2, 
		enemygroups = [], 
		level = 1,
		no_escape = true,
		auto_advance = true,
		tutorials = {
			1: "first_battle",
			2: "second_battle"
		},
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
		code = 'forest_erika',
		name = '',
		descript = "",
		image = ['combat_forest_1', 'combat_forest_2', 'combat_forest_3'], 
		explore_image = 'combat_forest', #or not
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
				{2 : ['faery_2'], 5 : ['faery']},
				],
			5 : [
				{2 : ['bigtreant']},
				],
			},
		},
	caves_demitrius = {
		code = 'caves_demitrius',
		name = '', 
		descript = "",
		image = ['combat_cave_1', 'combat_cave_2', 'combat_cave_3'],
		explore_image = 'combat_cave',
		stages = 6, 
		level = 4,
		tutorials = {
			1: "party_battle"
		},
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
				{1 : ['spider'], 3 : ['spider'], 4 : ['spider'], 6 : ['spider_2']},
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
				{1 : ['spider'], 2 : ['spider_2'], 3 : ['spider']},
				{2 : ['earthgolemboss']},
				],
			},
		},
		
	caves_iola = {
		code = 'caves_iola',
		name = "Demitrius' Daughter", 
		descript = "",
		image = ['combat_cave_1', 'combat_cave_2', 'combat_cave_3'],
		explore_image = 'combat_cave',
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
				{ 1 : ['spider'], 2 : ['spider'], 3 : ['spider'], 4 : ['spider_2'], 5 : ['spider'], 6 : ['spider_2']},
				],
			5 : [
				{1 : ['angrydwarf'], 2 : ['angrydwarf'], 3 : ['angrydwarf']},
				],
			6 : [
				{1 : ['spider'], 2 : ['spider_2', 9], 3 : ['spider']},
				],
			},
		},
	road_to_town = {
		code = 'road_to_town',
		name = '', 
		descript = "",
		image = ['combat_desert_1', 'combat_desert_2', 'combat_desert_3'],
		explore_image = 'combat_desert',
		stages = 4, 
		level = 8,
		events = {
			on_complete = "aeros_1",
		},
		enemies = {
			1 : [
				{ 1 : ['spider'], 2 : ['spider'], 5 : ['spider'], 6 : ['spider']},
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
		name = '', 
		descript = "",
		image = ['combat_dwarvencave_1', 'combat_dwarvencave_2', 'combat_dwarvencave_3'],
		explore_image = 'combat_cave2',
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
				{2 : ['spider_2', 15]},
				],
			6 : [
				{ 1 : ['spider'], 2 : ['spider_2'], 3 : ['spider'], 4 : ['earthgolem'], 6: ['earthgolem']},
				
			],
			7 : [
				{1 : ['angrydwarf'], 2: ['angrydwarf'], 3: ['angrydwarf'], 4: ['dwarfwarrior'], 6: ['dwarfwarrior']},
				{1 : ['dwarfwarrior'], 2: ['dwarvenking'], 3: ['dwarfwarrior']},
				],
			8 : [
				{1 : ['dwarfwarrior'], 5: ['dwarvenking_2'], 3: ['dwarfwarrior']},
				],
			},
		},
	
	forest_erika_sidequest = {#stub
		code = 'forest_erika_sidequest',
		name = '', 
		descript = "",
		image = ['combat_elvenforest_1', 'combat_elvenforest_2', 'combat_elvenforest_3'],
		explore_image = 'combat_forest1',
		stages = 4, 
		level = 12,
		events = {
			on_complete = "erika_3",
		},
		enemies = {
			1 : [
				{ 1 : ['spider'], 2 : ['spider'],  5 : ['faery_2'], 6 : ['faery_2']},
				],
			2 : [
				{1 : ['treant'], 3 : ['treant'], 4: ['faery'], 6:['faery']},
				],
			3 : [
				{1 : ['faery_2'], 2 : ['faery_2'], 3: ['faery_2'], 4:['faery'], 6:['faery']},
				],
			4 : [
				{1 : ['treant'], 2 : ['faery_2'], 3: ['treant'], 4:['faery'], 6:['faery']},
				],
			},
	},
	
	forest_faeries_1 = {
		code = 'forest_faeries_1',
		name = '', 
		descript = "",
		image = ['combat_elvenforest_1', 'combat_elvenforest_2', 'combat_elvenforest_3'],
		explore_image = 'combat_forest1',
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
				{1 : ['treant'], 3 : ['treant'], 4: ['faery'], 6:['faery_2']},
				],
			3 : [
				{1 : ['faery_2'], 2 : ['faery'], 3: ['faery_2'], 4:['faery'], 6:['faery']},
				],
			4 : [
				{1 : ['treant'], 2 : ['faery_2'], 3: ['treant'], 4:['faery'], 6:['faery']},
				],
			5 : [
				{1 : ['treant'], 3 : ['treant'], 4: ['treant'], 6:['treant']},
				
				],
			6 : [
				{1 : ['faery_2'], 3 : ['faery_2'], 4: ['faery'], 6:['faery']},
				{4 : ['faery'], 5 : ['faery_2'], 6 : ['faery']}
				],
			},
		},
	forest_faeries_2 = {
		code = 'forest_faeries_2',
		name = '', 
		descript = "",
		image = ['combat_elvenforest_1', 'combat_elvenforest_2', 'combat_elvenforest_3'],
		explore_image = 'combat_forest1',
		stages = 5, 
		level = 14,
		events = {
			on_complete = "faery_queen_2",
		},
		enemies = {
			1 : [
				{ 1 : ['spider_2'], 2 : ['spider'],  5 : ['faery'], 6 : ['faery']},
				],
			2 : [
				{1 : ['treant'], 3 : ['treant'], 4: ['faery'], 6:['faery']},
				],
			3 : [
				{1 : ['faery_2'], 2 : ['faery'], 3: ['faery_2'], 4:['faery'], 6:['faery']},
				],
			4 : [
				{1 : ['treant'], 2 : ['faery'], 3: ['treant'], 4:['faery'], 6:['faery_2']},
				],
			5 : [
				{1 : ['treant'], 3 : ['treant'], 4: ['treant'], 6:['treant']},
				],
			},
		},
	forest_faeries_3 = {
		code = 'forest_faeries_3',
		name = '', 
		descript = "",
		image = ['combat_elvenforest_1', 'combat_elvenforest_2', 'combat_elvenforest_3'],
		explore_image = 'combat_forest1',
		stages = 3, 
		level = 14,
		events = {
			after_fight_2 = "faery_queen_3",
			on_complete = "faery_queen_4",
		},
		enemies = {
			1 : [
				{ 1 : ['spider_2'], 2 : ['spider_2'],  5 : ['faery_2'], 6 : ['faery_2']},
				],
			2 : [
				{1 : ['treant'], 3 : ['treant'], 4: ['faery_2'], 6:['faery_2']},
				],
			3 : [
				{1 : ['faery'], 5 : ['fearyqueen'], 3: ['faery']},
				],
			},
		},
	castle_iola = {
		code = 'castle_iola',
		name = '', 
		descript = "",
		image = ['combat_palace_1', 'combat_palace_2', 'combat_palace_3'],
		explore_image = 'combat_palace',
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
		name = "", 
		descript = "",
		image = ['combat_temple_1', 'combat_temple_2', 'combat_temple_3'],
		explore_image = 'combat_temple',
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
		
	dragon_mountains = {
		code = 'dragon_mountains',
		name = '', 
		descript = "",
		image = ['combat_mountains_1', 'combat_mountains_2', 'combat_mountains_3'],
		explore_image = 'combat_mountains',
		stages = 8, 
		level = 21,
		events = {
			after_fight_4 = 'ember_2_2',
			after_fight_7 = "ember_2_3",
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
				{ 1 : ['hatchling'], 2 : ['giant_toad'],  3 : ['hatchling']},
				],
			5 : [
				{ 1 : ['wyvern'], 2 : ['armored_beast'], 3: ['wyvern']},
				],
			6 : [
				{ 1 : ['armored_beast'], 2 : ['giant_toad'], 3: ['armored_beast'], 5 : ['giant_toad']},
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
		name = '', 
		descript = "",
		image = ['combat_forest_1', 'combat_forest_2', 'combat_forest_3'], 
		explore_image = 'forest', #better make unique one
		no_escape = true, #added due to possible inability to return to it from explore
		stages = 1, 
		level = 23,
		events = {on_complete = 'victor_2_4'},
		enemies = {
			1 : [
				{2 : ['viktor_boss']},
				],
			},
		},
	caves_wanderer = {
		code = 'caves_wanderer',
		name = '', 
		descript = "",
		image = ['combat_cave_1', 'combat_cave_2', 'combat_cave_3'],
		explore_image = 'combat_cave',
		stages = 6, 
		level = 24,
		events = {
			after_fight_3 = 'iola_3_2',
			on_complete = "iola_3_3",
		},
		enemies = {
			1 : [
				{ 1 : ['spider'], 2 : ['earthgolem'],  3 : ['spider'], 4 : ['spider_2'], 5 : ['spider_2'], 6 : ['spider_2']},
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
				{ 1 : ['spider'], 2 : ['spider_2'], 3: ['spider'], 4 : ['earthgolem'], 6 : ['earthgolem']},
				],
			6 : [
				{ 1 : ['earthgolemboss'], 3: ['earthgolemboss']},
				],
			},
		},
		
	town_siege = {
		code = 'town_siege',
		name = '', 
		descript = "",
		image = ['burning_city_1', 'burning_city_2', 'burning_city_3'],
		explore_image = 'burning_city',
		stages = 7, 
		level = 25,
		events = {
			after_fight_3 = 'town_siege_intermission',
			after_fight_6 = 'annet_1',
			on_complete = "annet_2",
		},
		enemies = {
			1 : [
				{ 1 : ['spider'], 2 : ['demon1'],  3 : ['spider'], 4 : ['spider'], 5 : ['spider_2'], 6 : ['spider']},
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
				{ 1 : ['spider'], 2 : ['spider_2'], 3: ['spider'], 4 : ['earthgolem'], 6 : ['earthgolem']},
				],
			6 : [
				{ 1 : ['earthgolemboss'], 3: ['earthgolemboss'], 5: ['demon2']},
				],
			7: [
				{2: ['annet']}
			]
			},
		},
	castle_rilu = {
		code = 'castle_rilu',
		name = '', 
		descript = "",
		image = ['combat_palace_1', 'combat_palace_2', 'combat_palace_3'],
		explore_image = 'castle_interior', #or not
		no_escape = true, #added due to possible inability to return to it from explore
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
		name = '', 
		descript = "",
		image = ['combat_palace_1', 'combat_palace_2', 'combat_palace_3'],
		explore_image = 'combat_palace',
		stages = 7, 
		level = 27,
		events = {
#			pre_boss = 'zelroth_1',
			after_fight_6 = 'zelroth_1',
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
		name = '', 
		descript = "",
		image = ['combat_temple_1', 'combat_temple_2', 'combat_temple_3'],
		explore_image = 'combat_temple',
		stages = 4,#9 
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
	
	final_battle_stage1 = {
		code = 'final_battle_stage1',
		name = '', 
		descript = "",
		image = ['combat_future_city_1', 'combat_future_city_2', 'combat_future_city_3'],
		explore_image = 'combat_futurecity',
		stages = 8, 
		level = 30,
		events = {
			after_fight_7 = 'dimitrius_ending_2',
			on_complete = 'dimitrius_ending_3'
		},
		enemies = {
			1 : [
				{ 2 : ['soldier'], 4 : ['soldier'], 6 : ['drone']},
				{ 1 : ['soldier'], 3 : ['soldier'], 5 : ['bomber']},
				],
			2 : [
				{ 2 : ['drone'], 4 : ['soldier'], 5 : ['drone']},
				{ 1 : ['demon1'], 3 : ['drone']},
				],
			3 : [
				{ 1 : ['soldier'], 2 : ['soldier'], 3 : ['drone']},
				{ 1 : ['demon1'], 2 : ['demon1']},
				{ 2 : ['demon2'], 3 : ['demon1']},
				],
			4 : [
				{ 2 : ['demon1'], 3 : ['demon1'], 5 : ['demon2']},
				{ 1 : ['demon2'], 2 : ['demon2'], 3 : ['demon2']},
				],
			5 : [
				{ 1 : ['demon2'], 3 : ['demon2'], 5 : ['drone']},
				{ 1 : ['drone'], 3 : ['drone'], 4 : ['drone'], 6 : ['drone']},
				{ 1 : ['soldier'], 2 : ['demon2'], 3 : ['soldier']},
				],
			6 : [
				{ 2 : ['demon1'], 3 : ['demon2']},
				{ 1 : ['demon1'], 2 : ['demon1'], 5 : ['demon2'], 6 : ['demon2']},
				],
			7 : [
				{ 1 : ['drone'], 2 : ['drone'], 3 : ['drone'], 4 : ['drone'], 5 : ['drone'], 6 : ['drone']},
				{ 1 : ['soldier'], 2 : ['soldier'], 3 : ['soldier'], 4 : ['soldier'], 5 : ['soldier'], 6 : ['soldier']},
				{ 1 : ['demon2'], 2 : ['demon1'], 3 : ['demon2']},
				],
			8 : [
				{ 2 : ['demitrius1']},
				],
			},
		},
	
	final_battle_sewers = {
		code = 'final_battle_sewers',
		name = '', 
		descript = "",
		image = ['combat_interior_2'],
		explore_image = 'combat_interior_2',
		stages = 4, 
		level = 30,
		events = {
			on_complete = 'dimitrius_ending_4'
		},
		enemies = {
			1 : [
				{ 1 : ['drone']},
				{ 2 : ['drone'], 4 : ['drone'], 5 : ['drone'], 6 : ['drone']},
				],
			2 : [
				{ 1 : ['soldier'], 5 : ['drone'], 4 : ['drone'], 6 : ['drone']},
				{ 1 : ['soldier'], 2 : ['soldier'], 3 : ['soldier'], 6 : ['drone']},
				],
			3 : [
				{ 1 : ['drone'], 2 : ['drone'], 6 : ['soldier']},
				{ 1 : ['demon1'], 5 : ['drone'], 6 : ['drone']},
				{ 1 : ['demon1'], 3 : ['demon1'], 5 : ['demon2']},
				],
			4 : [
				{ 1 : ['bomber'], 2 : ['bomber'], 3 : ['bomber'], 4 : ['soldier'], 5 : ['soldier'], 6 : ['soldier']},
				{ 1 : ['drone'], 2 : ['drone'], 3 : ['drone'], 4 : ['drone'], 6 : ['drone'], 5 : ['demon2']},
				],
			},
		},
	
	final_battle_plant = {
		code = 'final_battle_plant',
		name = '', 
		descript = "",
		image = ['combat_interior_1', 'combat_interior_3'],
		explore_image = 'combat_interior',
		auto_advance = true,
		no_escape = true,
		stages = 5,
		level = 31,
		final = true,
		events = {
			after_fight_1 = 'dimitrius_ending_5',
			after_fight_2 = 'dimitrius_ending_6',
			after_fight_3 = 'dimitrius_ending_7',
			after_fight_4 = 'dimitrius_ending_8',
			on_complete = 'dimitrius_ending_9'
		},
		enemies = {
			1 : [
				{ 1 : ['soldier'], 5 : ['drone']},
				{ 1 : ['soldier'], 2 : ['drone'], 3 : ['soldier'], 4 : ['drone'], 6 : ['drone']},
				{ 1 : ['demon1'], 2 : ['demon1'], 5 : ['demon2'], 6 : ['demon2']},
				],
			2 : [
				{ 2 : ['demitrius2']},
				],
			3 : [
				{ 1 : ['demon1'], 4 : ['demon2']},
				{ 2 : ['demon2'], 5 : ['drone'], 6 : ['drone']},
				],
			4 : [
				{ 2 : ['demon1'], 5 : ['demon1']},
				{ 2 : ['demon1'], 3 : ['demon1'], 4 : ['demon2'], 5 : ['demon2']},
				],
			5 : [
				{ 2 : ['demitrius3']},
				]
			},
		},
	

#	forest_erika_rose_mission = {
#		code = 'forest_erika_rose_mission',
#		name = '',
#		descript = "",
#		image = ['combat_elvenforest_1', 'combat_elvenforest_2', 'combat_elvenforest_3'],
#		explore_image = 'combat_forest1',
#		stages = 6, 
#		level = 20,
#		},
}


func _ready():
	for i in locations.values():
		i.name = "AREA" + i.code.to_upper() + "NAME"
		i.descript = "AREA" + i.code.to_upper() + "DESCRIPT"
	
	for i in areas.values():
		i.name = i.code.to_upper() + "NAME"
		i.descript = i.code.to_upper() + "DESCRIPT"


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
		if rec.has('explore_image') and rec.explore_image != null and rec.explore_image != '':
			print("bg/%s" % rec.explore_image)
			resources.preload_res("bg/%s" % rec.explore_image)
		if rec.has('image') and rec.image != null:
			if rec.image is Array:
				for img in rec.image:
					print("bg/%s" % img)
					resources.preload_res("bg/%s" % img)
			elif rec.image != '':
				print("bg/%s" % rec.image)
				resources.preload_res("bg/%s" % rec.image)

#"needs autosave" means action starts mission with no "no_autosave" flag
func is_action_needs_autosave(action :Dictionary) ->bool:
	if action.type == 'mission' and (!action.has("no_autosave") or !action.no_autosave):
		return true
	if action.type == 'scene' and is_event_needs_autosave(action.value):
		return true
	return false

func is_event_needs_autosave(event_id :String) -> bool:
	if !event_triggers.has(event_id):
		return false
	for action in event_triggers[event_id]:
		if is_action_needs_autosave(action):
			return true
	return false

func is_seq_needs_autosave(seq_id :String) -> bool:
	assert(scene_sequences.has(seq_id), "no such scene in scene_sequences (%s)" % seq_id)
	for action in scene_sequences[seq_id].actions:
		if is_action_needs_autosave(action):
			return true
	return false

