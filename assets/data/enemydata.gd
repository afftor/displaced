extends Node

var locationgroups = {
	forest = ['foresteasy', 'foresteasymed', 'forestmedium', 'forestmedium2', 'foresthard'],
}

var predeterminatedgroups = {
	boss = {weight = 0.1, group = {2 : 'bigtreant'}},
	
	
	
}

var randomgroups = {
	foresteasy = {units = {elvenrat = [1,2]}, weight = 1},
	foresteasymed = {units = {elvenrat = [2,4]}, weight = 1},
	forestmedium = {units = {elvenrat = [1,3], treant = [0,1]}, weight = 1},
	forestmedium2 = {units = {elvenrat = [1,2], treant = [1,2]}, weight = 1},
	foresthard = {units = {treant = [2,3], elvenrat = [1,2]}, weight = 1},
	
	
}

var enemylist = {
	elvenrat = {
		code = 'elvenrat',
		name = tr('ELVENRAT'),
		description = tr("ELVENRATDESCRIPT"),
		race = 'animal',
		skills = ['attack'],
		passives = [],
		basehp = 50,
		basemana = 0,
		armor = 0,
		armorpenetration = 0,
		mdef = 0,
		evasion = 0,
		hitrate = 80,
		damage = 15,
		speed = 50,
		resists = {},
		xpreward = 10,
		
		icon = 'rat',
		bodyimage = null,
		aiposition = 'melee',
		loottable = 'elvenratloot',
	},
	treant = {
		code = 'treant',
		name = tr('TREANT'),
		description = tr("TREANTDESCRIPT"),
		race = 'tree',
		skills = ['attack'],
		passives = [],
		basehp = 120,
		basemana = 0,
		armor = 25,
		armorpenetration = 0,
		mdef = 0,
		evasion = 0,
		hitrate = 75,
		damage = 35,
		speed = 30,
		resists = {},
		xpreward = 10,
		
		icon = 'ent',
		bodyimage = null,
		aiposition = 'melee',
		loottable = 'treantloot',
	},
	bigtreant = {
		code = 'bigtreant',
		name = tr('BIGTREANT'),
		description = tr("BIGTREANTDESCRIPT"),
		race = 'tree',
		skills = ['attack', 'summontreant'],
		passives = [],
		basehp = 300,
		basemana = 0,
		armor = 40,
		armorpenetration = 0,
		mdef = 0,
		evasion = 0,
		hitrate = 70,
		damage = 70,
		speed = 20,
		resists = {},
		xpreward = 50,
		
		icon = null,
		bodyimage = null,
		aiposition = 'ranged',
		loottable = 'bigtreantloot',
	},
	earthelemental = {
		code = 'earthelemental',
		name = tr('EARTHELEMENTAL'),
		description = tr("EARTHELEMENTALDESCRIPT"),
		race = 'rock',
		skills = ['attack'],
		passives = ['weakbarrier'],
		basehp = 150,
		basemana = 0,
		armor = 40,
		armorpenetration = 0,
		mdef = 0,
		evasion = 0,
		hitrate = 80,
		damage = 40,
		speed = 40,
		resists = {earth = 75},
		xpreward = 30,
		
		icon = null,
		bodyimage = null,
		aiposition = 'melee',
		loottable = 'earthelementalloot',
	},
}







var loottables = {
	elvenratloot = {
		materials = {leather = [1,2]},
	},
	treantloot = {
		materials = {wood = [2,3]},
	},
}
