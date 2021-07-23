extends Node

var areas = { #missions in new terminology
	forest_erika = {
		code = 'forestelves',
		name = 'Search for Elves',
		image = '',
		stages = 8, 
		enemygroups = ['foresteasy', 'foresteasymed', 'forestmedium', 'forestmedium2', 'foresthard'], 
		requirements = [{type = "quest_stage", name = 'erika', operant = "eq", value = 1}], 
		level = 1,
		stagedenemies = {8 : {enemy = 'forestboss', level = 1}} #{8 : "forestboss"}, level indikates that bossfight is +1 to area level
		},
	cavedemitrius = {
		code = 'cavedemitrius',
		name = 'Escort Demitrius', 
		category = 'cave',
		image = '',
		stages = 10, 
		enemygroups = ['caveeasy','cavemedium','cavemedium2','cavemedium3'], 
		requirements = [{type = "quest_stage", name = 'demitrius_arrival', operant = 'eq', value = 1}], 
		level = 1,
		stagedenemies = {10 : "caveboss"}
		},
		
}



var locations = { #suggestion: track unlocked locations in game sate
	village =  {
		code = 'village',
		initial_event = '',
		missions = [], #no missions at village
		function = '', #suggestion: launch custom function i.e. open village screen if applicable. Initial event launches first
	},
	forest =  {
		code = 'forest',
		initial_event = '',
		missions = ['forest_erika','forest_faeries'],
		function = '',
	},
	cave =  {
		code = 'cave',
		initial_event = '',
		missions = ['cave_demitrius','cave_iola','caves_dwarves','caves_wandererr'],
		function = '',
	},
	town =  { #town could be visited at certain points in game and will only launch events
		code = 'town',
		initial_event = '',
		missions = ['erika_annet','ember_viktor','town_siege'],
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
