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
		
		bodyhitsound = 'flesh',
		
		combaticon = 'rat',
		bodyimage = null,
		aiposition = 'melee',
		loottable = 'elvenratloot',
	},
	treant = {
		code = 'treant',
		name = tr('TREANT'),
		description = tr("TREANTDESCRIPT"),
		race = 'plant',
		skills = ['attack'],
		passives = [],
		basehp = 50,
		basemana = 0,
		armor = 50,
		armorpenetration = 0,
		mdef = 0,
		evasion = 0,
		hitrate = 75,
		damage = 30,
		speed = 30,
		resists = {},
		xpreward = 10,
		
		bodyhitsound = 'wood',
		
		combaticon = 'ent',
		bodyimage = null,
		aiposition = 'melee',
		loottable = 'treantloot',
	},
	bigtreant = {
		code = 'bigtreant',
		name = tr('BIGTREANT'),
		description = tr("BIGTREANTDESCRIPT"),
		race = 'plant',
		skills = ['attack', 'summontreant'],
		passives = [],
		basehp = 250,
		basemana = 0,
		armor = 0,
		armorpenetration = 0,
		mdef = 0,
		evasion = 0,
		hitrate = 70,
		damage = 70,
		speed = 20,
		resists = {},
		xpreward = 50,
		
		bodyhitsound = 'wood',
		
		combaticon = null,
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
		basehp = 125,
		basemana = 0,
		armor = 0,
		armorpenetration = 0,
		mdef = 0,
		evasion = 0,
		hitrate = 80,
		damage = 40,
		speed = 40,
		resists = {earth = 50, air = 50},
		xpreward = 30,
		
		bodyhitsound = 'stone',
		
		combaticon = null,
		bodyimage = null,
		aiposition = 'melee',
		loottable = 'earthelementalloot',
	},
	spider = {
		code = 'spider',
		name = tr('SPIDER'),
		description = tr("SPIDERDESCRIPT"),
		race = 'animal',
		skills = ['attack'],
		passives = [],
		basehp = 75,
		basemana = 0,
		armor = 0,
		armorpenetration = 15,
		mdef = 15,
		evasion = 40,
		hitrate = 75,
		damage = 30,
		speed = 40,
		resists = {},
		xpreward = 20,
		
		bodyhitsound = 'flesh',
		
		combaticon = null,
		bodyimage = null,
		aiposition = 'melee',
		loottable = 'spiderloot',
	},
	fairies = {
		code = 'fairies',
		name = tr('FAIRIES'),
		description = tr("FAIRIESDESCRIPT"),
		race = 'humanoid',
		skills = ['attack'],
		passives = [],
		basehp = 100,
		basemana = 0,
		armor = 0,
		armorpenetration = 0,
		mdef = 25,
		evasion = 50,
		hitrate = 75,
		damage = 35,
		speed = 60,
		resists = {},
		xpreward = 20,
		
		bodyhitsound = 'flesh',
		
		combaticon = null,
		bodyimage = null,
		aiposition = 'melee',
		loottable = 'fairiesloot',
	},
	angrydwarf = {
		code = 'angrydwarf',
		name = tr('ANGRYDWARF'),
		description = tr("ANGRYDWARFDESCRIPT"),
		race = 'humanoid',
		skills = ['attack'],
		passives = [],
		basehp = 125,
		basemana = 0,
		armor = 20,
		armorpenetration = 0,
		mdef = 0,
		evasion = 0,
		hitrate = 80,
		damage = 45,
		speed = 45,
		resists = {},
		xpreward = 20,
		
		combaticon = null,
		bodyimage = null,
		aiposition = 'melee',
		loottable = 'angrydwarfloot',
	},

}







var loottables = {
	elvenratloot = {
		materials = [{code = 'leather', min = 1, max = 1, chance = 35}, {code = 'bone', min = 1, max = 1, chance = 25}],
		usables = [{code = 'morsel', min = 1, max = 1, chance = 25}],
	},
	treantloot = {
		materials = [{code = 'wood', min = 1, max = 1, chance = 25}],
	},
	bigtreantloot = {
		materials = [{code = 'wood', min = 3, max = 5, chance = 100}, {code = 'elvenwood', min = 1, max = 3, chance = 30}],
	},
	spiderloot = {
		materials = [{code = 'cloth', min = 1, max = 1, chance = 35}],
	},
	earthelementalloot = {
		materials = [{code = 'goblinmetal', min = 1, max = 1, chance = 35}],
	},
	dwarfloot = {
		materials = [{code = 'goblinmetal', min = 1, max = 1, chance = 35}],
	},
}
