extends Node

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
	forest_faeries_1  = {
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



var locations = { #suggestion: track unlocked locations in game sate
	init = {
		code = 'init',
		initial_event = 'intro', #followed by intro2, intro3. After intro2 starts road_to_village
		missions = [],
		function = '',
	},
	
	village =  {
		code = 'village',
		initial_event = '',
		events = {
			erika1 = {conditions = []},
		},
		missions = [], #no missions at village
		function = '', #suggestion: launch custom function i.e. open village screen if applicable. Initial event launches first
	},
	forest =  {
		code = 'forest',
		initial_event = '',
		missions = ['forest_erika','forest_faeries_1','forest_faeries_2'],
		function = '',
	},
	cave =  {
		code = 'cave',
		initial_event = '',
		missions = ['caves_demitrius','caves_iola','caves_dwarf','caves_wanderer'],
		function = '',
	},
	road_to_town =  {
		code = 'road_to_town',
		initial_event = '',
		missions = ['road_to_town'],
		function = '',
	},
	town =  { #town could be visited at certain points in game and will only launch events
		code = 'town',
		initial_event = '',
		missions = ['erika_annet','town_viktor_fight','town_siege'],
		function = '',
	},
	castle =  {
		code = 'castle',
		initial_event = '',
		missions = ['castle_rilu','castle_rilu_return'],
		function = '',
	},
	dragon_mountains = {
		code = 'dragon_mountains',
		initial_event = '',
		missions = ['mountains_ember'],
		function = '',
	},
	temple =  {
		code = 'temple',
		initial_event = '',
		missions = ['temple_iola','temple_rose'],
		function = '',
	},
	modern_city =  {
		code = 'modern_city',
		initial_event = '',
		missions = ['dimitrius_finale'],
		function = '',
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
