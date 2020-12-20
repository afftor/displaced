extends Node

var areas = {
	forestexplore = {
		code = 'forestexplore',
		name = 'Roam at Forest', 
		category = 'forest',
		image = '',
		stages = 0, 
		enemygroups = ['foresteasy', 'foresteasymed', 'forestmedium', 'forestmedium2', 'foresthard','foresthard2','foresthard3','forestextraboss'], 
		requirements = [], 
		level = 1,
		stagedenemies = {}
		},
	forestelves = {
		code = 'forestelves',
		name = 'Search for Elves',
		category = 'forest',
		image = '',
		stages = 8, 
		enemygroups = ['foresteasy', 'foresteasymed', 'forestmedium', 'forestmedium2', 'foresthard'], 
		requirements = [{type = "quest_stage", name = 'elves', operant = "eq", value = 1}], 
		level = 1,
		stagedenemies = {8 : "forestboss"}
		},
	caveexplore = {
		code = 'caveexplore',
		name = 'Roam at Caves', 
		category = 'cave',
		image = '',
		stages = 0, 
		enemygroups = ['caveeasy','cavemedium','cavemedium2','cavemedium3'], 
		requirements = [{type = "quest_completed", name = 'elves'}], 
		level = 1,
		stagedenemies = {}
		},
	cavedemitrius = {
		code = 'cavedemitrius',
		name = 'Escort Demitrius', 
		category = 'cave',
		image = '',
		stages = 10, 
		enemygroups = ['caveeasy','cavemedium','cavemedium2','cavemedium3'], 
		requirements = [{type = "quest_stage", name = 'demitrus', operant = 'eq', value = 1}], 
		level = 1,
		stagedenemies = {10 : "caveboss"}
		},
}

var locations = {
	dragon_mountains = {
		code = 'dragon_mountains',
		background = 'mountainsday',
		combat = true
	},
	castle =  {
		code = 'castle',
		background = 'mountainsday',
		combat = true
	},
	cave =  {
		code = 'cave',
		background = 'cave',
		combat = true
	},
	forest =  {
		code = 'forest',
		background = 'forest',
		combat = true
	},
	temple =  {
		code = 'temple',
		background = 'mountainsday',
		combat = true
	},
	village =  {
		code = 'village',
		background = 'mountainsday',
		combat = false
	},
	town =  {
		code = 'town',
		background = 'mountainsday',
		combat = false
	},
}



func check_area_avail(area):
	if !state.checkreqs(area.requirements): return false
	if state.areaprogress.has(area.code) and state.areaprogress[area.code] >= area.stages and area.stages != 0: return false
	return true


func check_location_activity(loc):
	if !locations[loc].combat:
		return true
	for i in areas.values():
		if i.category != loc : continue
		if !check_area_avail(i): continue
		return true
	return false
