extends Node

var areas = {
	forestexplore = {
		name = 'Roam at Forest', 
		category = 'forest',
		image = '',
		stages = 0, 
		enemygroups = ['foresteasy', 'foresteasymed', 'forestmedium', 'forestmedium2', 'foresthard'], 
		requirements = [], 
		stagedenemies = {}
		},
	forestelves = {
		name = 'Search for elves', 
		category = 'forest',
		image = '',
		stages = 6, 
		enemygroups = ['foresteasy', 'foresteasymed', 'forestmedium', 'forestmedium2', 'foresthard'], 
		requirements = [{type = "main_progress", operant = "eq", value = 1}], 
		stagedenemies = {6 : ""}
		},
	caveexplore = {
		name = 'Roam at Caves', 
		category = 'cave',
		image = '',
		stages = 0, 
		enemygroups = [], 
		requirements = [{type = "main_progress", operant = "gte", value = 2}], 
		stagedenemies = {}
		},
	
	
	
}