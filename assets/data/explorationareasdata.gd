extends Node



var locations = {
	village =  {
		code = 'village',
		missions = [],
	},
	forest =  {
		code = 'forest',
		missions = ['forest_erika','forest_faeries_1','forest_faeries_2'],
	},
	cave =  {
		code = 'cave',
		missions = ['caves_demitrius','caves_iola','caves_dwarf','caves_wanderer'],
	},
	road_to_town =  {
		code = 'road_to_town',
		missions = ['road_to_town'],
	},
	town =  { #town could be visited at certain points in game and will only launch events
		code = 'town',
		missions = ['erika_annet','town_viktor_fight','town_siege'],
		function = '',
	},
	castle =  {
		code = 'castle',
		missions = ['castle_rilu','castle_rilu_return'],
	},
	dragon_mountains = {
		code = 'dragon_mountains',
		missions = ['mountains_ember'],
	},
	temple =  {
		code = 'temple',
		missions = ['temple_iola','temple_rose'],
	},
	modern_city =  {
		code = 'modern_city',
		missions = ['dimitrius_finale'],
	},
}


var scene_sequences = { 
	
	intro = {
		initiate_signal = 'game_start', #can be signals like 'click specific location'
		initiate_reqs = [], #all sequences only playable once, unless specified
		actions = [
		{type = 'scene', value = 'intro1'},
		{type = 'mission', value = 'road_to_village'},
		{type = 'scene', value = 'intro2'},
		{type = 'scene', value = 'intro3'},
		{type = 'system', value = 'start_game'},
		{type = 'system', value = 'unlock_character', arg = 'arron'},
		{type = 'system', value = 'unlock_location', arg = 'village'} #Suggestion: hardcode similar unlocks into single function i.e. start_game one
		]
	},
	erika_at_village = {
		initiate_signal = 'village_activate', 
		initiate_reqs = [{code = 'mission_completed', value = 'forest_erika'}],
		actions = [
		{type = 'scene', value = 'erika_1'},
		{type = 'system', value = 'unlock_character', arg = 'erika'},
		]
	},
	
	ember_arrival = {
		initiate_signal = 'village_townhall_ember', 
		initiate_reqs = [{code = 'mission_completed', value = 'forest_erika'}],
		actions = [
		{type = 'scene', value = 'ember_1_1'},
		{type = 'system', value = 'unlock_character', arg = 'ember'},
		{type = 'system', value = 'unlock_building', arg = 'smith'},
		]
	},
	
	ember_smith = {
		initiate_signal = 'village_smith', 
		initiate_reqs = [{code = 'scene_seen', value = 'ember_recruited'}],
		actions = [
		{type = 'scene', value = 'ember_1_2'},
		]
	},
	
	dimitrius_arrival = {
		initiate_signal = 'village_townhall_dimitrius', 
		initiate_reqs = [{code = 'scene_seen', value = 'ember_arrival'}],
		actions = [
		{type = 'scene', value = 'dimitrius_1_1'},
		{type = 'system', value = 'unlock_area', arg = 'caves'},
		{type = 'system', value = 'unlock_mission', arg = 'caves_demitrius'}
		]
	},
	
	iola_arrival = {
		initiate_signal = 'village_townhall_iola', 
		initiate_reqs = [{type = 'mission_completed', value = 'caves_demitrius'}],
		actions = [
		{type = 'scene', value = 'iola_1'},
		{type = 'system', value = 'unlock_mission', arg = 'caves_iola'}
		]
	},
	
	flak_task = {
		initiate_signal = 'village_townhall_fask', 
		initiate_reqs = [{type = 'mission_completed', value = 'caves_iola'}],
		actions = [
		{type = 'scene', value = 'flak_1'}, #not currently existing,
		{type = 'system', value = 'unlock_area', arg = 'town'},
		{type = 'system', value = 'unlock_mission', arg = 'road_to_town'}
		]
	},
	
	town_gates = {
		initiate_signal = 'town', 
		initiate_reqs = [{type = 'mission_completed', value = 'road_to_town'}],
		actions = [
		{type = 'scene', value = 'aeros_2'},
		{type = 'scene', value = 'aeros_3'},
		{type = 'system', value = 'unlock_area', arg = 'faery_forest'},
		{type = 'system', value = 'unlock_mission', arg = 'forest_faeries_1'}
		]
	},
	
	flak_task_return = {
		initiate_signal = 'village_townhall_fask', 
		initiate_reqs = [{type = 'scene_seen', value = 'aeros_2'}],
		actions = [
		{type = 'scene', value = 'flak_2'}, #not currently existing,
		]
	},
	
	viktor_introduction = {
		initiate_signal = 'town', 
		initiate_reqs = [{type = 'scene_seen', value = 'aeros_3'}],
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
		{type = 'scene', value = 'erika_annet_2'}, 
		{type = 'scene', value = 'erika_annet_2_1', reqs = [{code = 'rule', value = 'forced_content', arg = 'true'}]},#skip if forced content is disabled 
		{type = 'system', value = 'enable_character', arg = ['erika',false] },
		]
	},
	arron_meet_annet = {
		initiate_signal = 'town', 
		initiate_reqs = [{type = 'scene_seen', value = 'erika_meet_annet'}],
		actions = [
		{type = 'scene', value = 'erika_annet_2_2'}, 
		]
	
	},
	rose_annet_rescue = {
		initiate_signal = 'town', 
		initiate_reqs = [{type = 'scene_seen', value = 'arron_meet_annet'}],
		actions = [
		{type = 'scene', value = 'erika_annet_2_3'},
		{type = 'system', value = 'game_stage', arg = 'erika_rescued'},
		{type = 'system', value = 'enable_character', arg = ['erika',true] },
		]
	},
	
	iola_second_visit = {
		initiate_signal = 'village_townhall_iola', 
		initiate_reqs = [{type = 'scene_seen', value = 'rose_annet_rescue'}],
		actions = [
		{type = 'scene', value = 'iola_2_1'},#split scenes and revisit
		{type = 'system', value = 'unlock_area', arg = 'castle'},
		{type = 'system', value = 'unlock_mission', arg = 'castle_iola'}
		]
	},
	iola_gets_caught = {
		initiate_signal = 'cult_grounds', 
		initiate_reqs = [{type = 'mission_complete', value = 'castle_iola'}],
		actions = [
		{type = 'scene', value = 'iola_2_3'},
		]
	},
	rilu_reports_iola = {
		initiate_signal = 'village_townhall_rilu', 
		initiate_reqs = [{type = 'scene_seen', value = 'iola_gets_caught'}],
		actions = [
		{type = 'scene', value = 'iola_2_4'},
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
		initiate_reqs = [{type = 'scene_seen', value = 'iola_recruited'}],
		actions = [
		{type = 'scene', value = 'ember_2_1'},
		{type = 'system', value = 'unlock_area', arg = 'mountains'},
		{type = 'system', value = 'unlock_mission', arg = 'dragon_mountains'}
		]
	},
	viktor_kills_dragon = {
		initiate_signal = 'mountains', 
		initiate_reqs = [{type = 'mission_complete', value = 'dragon_mountains'}],
		actions = [
		{type = 'scene', value = 'viktor_2_1'}, 
		]
	},
	viktor_sends_threat = {
		initiate_signal = 'village_townhall_ember', 
		initiate_reqs = [{type = 'scene_seen', value = 'viktor_kills_dragon'}],
		actions = [
		{type = 'scene', value = 'viktor_2_2'},
		{type = 'system', value = 'unlock_mission', arg = 'town_viktor_fight'}
		]
	},
	viktor_duel = {
		initiate_signal = 'town', 
		initiate_reqs = [{type = 'scene_seen', value = 'viktor_sends_threat'}],
		actions = [
		{type = 'scene', value = 'viktor_2_3'}, 
		{type = 'mission', value = 'town_viktor_fight'},
		]
	},
	rilu_disappear =  {
		initiate_signal = 'village_townhall_rilu', 
		initiate_reqs = [{type = 'mission_complete', value = 'town_viktor_fight'}],
		actions = [
		{type = 'scene', value = 'rilu_2_3'},
		]
	},
	rilu_castle =  {
		initiate_signal = 'castle', 
		initiate_reqs = [{type = 'scene_seen', value = 'rilu_disappear'}],
		actions = [
		{type = 'scene', value = 'rilu_2_3'},
		{type = 'mission', value = 'castle_rilu'},
		]
	},
	iola_wanderer = {
		initiate_signal = 'village_townhall_iola', 
		initiate_reqs = [{type = 'mission_complete', value = 'castle_rilu'}],
		actions = [
		{type = 'scene', value = 'iola_3_1'},#split scenes and revisit
		{type = 'system', value = 'unlock_mission', arg = 'caves_wanderer'}
		]
	},
	flak_town_raid = {
		initiate_signal = 'village_townhall_flak', 
		initiate_reqs = [{type = 'mission_complete', value = 'caves_wanderer'}],
		actions = [
		{type = 'scene', value = 'flak_city_raid'},#split scenes and revisit
		{type = 'system', value = 'unlock_mission', arg = 'town_siege'}
		]
	},
	
	rose_kidnap = {
		initiate_signal = 'village_townhall_rose', 
		initiate_reqs = [{type = 'mission_complete', value = 'town_siege'}],
		actions = [
		{type = 'scene', value = 'dimitrius_2_1'},#split scenes and revisit
		{type = 'system', value = 'unlock_mission', arg = 'castle_rilu_return'},
		{type = 'system', value = 'enable_character', arg = ['rose',false] },
		]
	},
	flak_modern_city = {
		initiate_signal = 'village_townhall_flak', 
		initiate_reqs = [{type = 'mission_complete', value = 'cult_rose_rescue'}],
		actions = [
		{type = 'scene', value = 'flak_future_city'},#split scenes and revisit
		{type = 'system', value = 'unlock_mission', arg = 'modern_city_1'},
		{type = 'system', value = 'unlock_area', arg = 'modern_city'}
		]
	},
	
	erika_rose_init = {
		initiate_signal = 'village_townhall_erika', 
		initiate_reqs = [{type = 'scene_seen', value = 'erika_doggy'}],
		actions = [
		{type = 'scene', value = 'erika_rose_1'}, #must unlock new area/mission if agreed during the scene
		]
		
	},
	
	#Gallery scenes
	
	
	ember_boobs = { #should be free to unlock
		initiate_signal = 'village_townhall_ember_unlock', 
		initiate_reqs = [{code = 'game_stage', value = 'ember_recruited'}],
		actions = [
		{type = 'scene', value = 'ember_1_3'},
		{type = 'unlock_scene', value = 'ember_boobs'},#for gallery
		]
	},
	rose_night = { #should be free to unlock
		initiate_signal = 'village_townhall_ember_unlock', 
		initiate_reqs = [{code = 'scene_seen', value = 'ember_boobs'}],
		actions = [
		{type = 'scene', value = 'rose_1'},
		{type = 'unlock_scene', value = 'rose_night'},
		]
	},
	erika_doggy = {
		initiate_signal = 'village_townhall_erika_unlock', 
		initiate_reqs = [],
		actions = [
		{type = 'scene', value = 'erika_2'},
		{type = 'unlock_scene', value = 'erika_doggy'},
		]
	},
	erika_rose_three = {
		initiate_signal = 'village_townhall_erika_unlock', 
		initiate_reqs = [{type = 'mission_complete', value = 'forest_erika_sidequest'}],
		actions = [
		{type = 'scene', value = 'erika_rose_2'},
		{type = 'unlock_scene', value = 'erika_rose_three'},
		]
		
	},
	ember_misisonary = {
		initiate_signal = 'village_townhall_ember_unlock', 
		initiate_reqs = [{type = 'mission_complete', value = 'road_to_town'}],
		actions = [
		{type = 'scene', value = 'ember_1_4'},
		{type = 'unlock_scene', value = 'ember_misisonary'},
		]
		
	},
	rilu_cowgirl = {
		initiate_signal = 'village_townhall_rilu_unlock', 
		initiate_reqs = [],
		actions = [
		{type = 'scene', value = 'rilu_1_6'},
		{type = 'unlock_scene', value = 'rilu_cowgirl'},
		]
	},
	rilu_doggy = {
		initiate_signal = 'village_townhall_rilu_unlock', 
		initiate_reqs = [{code = 'scene_seen', value = 'rilu_cowgirl'}],
		actions = [
		{type = 'scene', value = 'rilu_2_1'},
		{type = 'unlock_scene', value = 'rilu_doggy'},
		]
	},
	rilu_anal = {
		initiate_signal = 'village_townhall_rilu_unlock', 
		initiate_reqs = [{code = 'scene_seen', value = 'rilu_doggy'}],
		actions = [
		{type = 'scene', value = 'rilu_2_2'},
		{type = 'unlock_scene', value = 'rilu_anal'},
		]
	},
	
	iola_blowjob = {
		initiate_signal = 'village_townhall_iola_unlock', 
		initiate_reqs = [{code = 'scene_seen', value = 'iola_recruited' }],
		actions = [
		{type = 'scene', value = 'iola_2_6'},
		{type = 'unlock_scene', value = 'iola_blowjob'},
		]
	},
	iola_missionary = {
		initiate_signal = 'village_townhall_iola_unlock', 
		initiate_reqs = [{code = 'scene_seen', value = 'iola_blowjob' }],
		actions = [
		{type = 'scene', value = 'iola_2_7'},
		{type = 'unlock_scene', value = 'iola_missionary'},
		]
	},
	iola_foursome = {
		initiate_signal = 'village_townhall_iola_unlock', 
		initiate_reqs = [{code = 'scene_seen', value = 'iola_missionary' }],
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
		image = '',
		stages = 2, 
		enemygroups = [], 
		level = 1,
		events = {
			on_complete = 'intro2'
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
		image = '',
		stages = 5, 
		level = 2,
		events = {
			after_fight_3 = 'forest1',
			on_complete = "forest2",
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
		image = '',
		stages = 6, 
		level = 4,
		events = {
			after_fight_3 = 'dimitrius2',
			on_complete = "dimitrius3",
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
		image = '',
		stages = 6, 
		level = 6,
		events = {
			after_fight_3 = 'iola2',
			on_complete = "iola3",
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
		image = '',
		stages = 4, 
		level = 8,
		events = {
			on_complete = "aeros1",
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
		image = '',
		stages = 8, 
		level = 11,
		events = {
			after_fight_5 = 'rilu1',#heal team
			on_complete = "rilu4",
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
				{1 : ['angrydwarf'], 2: ['angrydwarf'], 3: ['angrydwarf'], 4: ['dwarfwarrior'], 6: ['dwarfwarrior']},
				{1 : ['dwarfwarrior'], 2: ['dwarfwarrior'], 3: ['dwarfwarrior']},
				],
			7 : [
				{1 : ['dwarfwarrior'], 5: ['dwarfking'], 3: ['dwarfwarrior']},
				],
			},
		},
	
	forest_erika_sidequest = {#stub
		code = 'forest_erika_sidequest',
		name = 'Elven Medicine', 
		descript = "",
		image = '',
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
		image = '',
		stages = 6, 
		level = 14,
		events = {
			on_complete = "faeryqueen1",
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
				{1 : ['faery'], 5 : ['faerqueen'], 3: ['faery']},
				],
			},
		},
	forest_faeries_2 = {
		code = 'forest_faeries_2',
		name = 'Faering Dirty Laundry', 
		descript = "",
		image = '',
		stages = 5, 
		level = 14,
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
		image = '',
		stages = 3, 
		level = 14,
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
		name = 'Dragon Climbing', 
		descript = "",
		image = '',
		stages = 8, 
		level = 21,
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
	if !state.checkreqs(area.requirements): return false
#	if state.areaprogress.has(area.code) and state.areaprogress[area.code] >= area.stages and area.stages != 0: return false
	return true


func check_location_activity(loc):
	if !locations[loc].combat:
		return true
	for i in areas.values():
		if i.category != loc : continue
		if !check_area_avail(i): continue
		return true
	return false
