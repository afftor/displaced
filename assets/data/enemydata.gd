extends Node


var predeterminatedgroups = {
	forestboss = {weight = 0.1, group = {5 : 'bigtreant'}, code = 'forestboss', music = 'boss'},
	
	
	
}

var randomgroups = {
	foresteasy = {units = {elvenrat = [1,2]}, weight = 1, code = 'foresteasy', reqs = [{type = "party_level", operant = "lte", value = 3}]},
	foresteasymed = {units = {elvenrat = [2,4]}, weight = 1, code = 'foresteasymed', reqs = []},
	forestmedium = {units = {elvenrat = [1,3], treant = [0,1]}, weight = 1, code = 'forestmedium',reqs = [{type = "party_level", operant = "gte", value = 2}]},
	forestmedium2 = {units = {elvenrat = [1,2], treant = [1,2]}, weight = 1, code = 'forestmedium2',reqs = [{type = "party_level", operant = "gte", value = 2}]},
	foresthard = {units = {treant = [2,3], elvenrat = [1,2]}, weight = 1, code = 'foresthard',reqs = [{type = "party_level", operant = "gte", value = 5}]},
	foresthard2 = {units = {spider = [1,2], treant = [1,2]}, weight = 1, code = 'foresthard2',reqs = [{type = "party_level", operant = "gte", value = 4}]},
	foresthard3 = {units = {fairies = [1,1], treant = [1,2]}, weight = 1, code = 'foresthard3',reqs = [{type = "party_level", operant = "gte", value = 4}]},
	forestextraboss = {units = {bigtreant = [1,1], treant = [1,2]}, weight = 0.2, code = 'forestextraboss',reqs = [{type = "party_level", operant = "gte", value = 8}]},
	
	#caves
	
	caveeasy = {units = {spider = [1,2]}, weight = 1, code = 'caveeasy',reqs = [{type = "party_level", operant = "lte", value = 4}]},
	cavemedium = {units = {spider = [1,2], earthgolem = [1,2]}, weight = 1, code = 'cavemedium',reqs = [{type = "party_level", operant = "gte", value = 4}]},
	cavemedium2 = {units = {earthgolem = [1,2], angrydwarf = [1,1]}, weight = 1, code = 'cavemedium2',reqs = [{type = "party_level", operant = "gte", value = 4}]},
	cavemedium3 = {units = {angrydwarf = [2,2]}, weight = 1, code = 'cavemedium3',reqs = [{type = "party_level", operant = "gte", value = 5}]},
	
}

var enemylist = {
	elvenrat = {
		code = 'elvenrat',
		name = tr("MONSTERELVENRAT"),
		flavor = tr("MONSTERELVENRATFLAVOR"),
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
		name = tr("MONSTERTREANT"),
		flavor = tr("MONSTERTREANTFLAVOR"),
		race = 'plant',
		skills = ['attack'],
		passives = [],
		traits = ['treant_barrier'],
		basehp = 75,
		basemana = 0,
		armor = 0,
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
		name = tr("MONSTERBIGTREANT"),
		flavor = tr("MONSTERBIGTREANTFLAVOR"),
		race = 'plant',
		skills = ['attack', 'summontreant'],
		passives = [],
		basehp = 250,
		basemana = 150,
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
		
		combaticon = 'bigent',
		bodyimage = null,
		aiposition = 'ranged',
		loottable = 'bigtreantloot',
	},
	earthgolem = {
		code = 'earthgolem',
		name = tr("MONSTEREARTHGOLEM"),
		flavor = tr("MONSTEREARTHGOLEMFLAVOR"),
		race = 'rock',
		skills = ['attack'],
		passives = [],
		traits = ['weakbarrier'],
		basehp = 100,
		basemana = 0,
		armor = 50,
		armorpenetration = 0,
		mdef = 10,
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
		loottable = 'earthgolemloot',
	},
	spider = {
		code = 'spider',
		name = tr("MONSTERSPIDER"),
		flavor = tr("MONSTERSPIDERFLAVOR"),
		race = 'animal',
		skills = ['spiderattack'],
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
		
		combaticon = 'spider',
		bodyimage = null,
		aiposition = 'melee',
		loottable = 'spiderloot',
	},
	fairies = {
		code = 'fairies',
		name = tr("MONSTERFAIRIES"),
		flavor = tr("MONSTERFAIRIESFLAVOR"),
		race = 'humanoid',
		skills = ['fairyattack'],
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
		
		combaticon = 'fairies',
		bodyimage = null,
		aiposition = 'ranged',
		loottable = 'fairiesloot',
	},
	angrydwarf = {
		code = 'angrydwarf',
		name = tr("MONSTERANGRYDWARF"),
		flavor = tr("MONSTERANGRYDWARFFLAVOR"),
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
		
		combaticon = 'dwarf',
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
		usables = [{code = 'managrass', min = 1, max = 1, chance = 15}],
	},
	bigtreantloot = {
		materials = [{code = 'wood', min = 3, max = 5, chance = 100}, {code = 'elvenwood', min = 1, max = 3, chance = 30}],
		usables = [{code = 'managrass', min = 1, max = 3, chance = 100}],
	},
	spiderloot = {
		materials = [{code = 'cloth', min = 1, max = 1, chance = 35}],
		usables = [{code = 'morsel', min = 1, max = 1, chance = 35}],
	},
	earthgolemloot = {
		materials = [{code = 'goblinmetal', min = 1, max = 1, chance = 35}],
		usables = [{code = 'protectivecharm', min = 1, max = 1, chance = 10}],
	},
	fairiesloot = {
		
		usables = [{code = 'managrass', min = 1, max = 2, chance = 25},{code = 'lesserpotion', min = 1, max = 1, chance = 15},{code = 'protectivecharm', min = 1, max = 1, chance = 5}],
	},
	dwarfloot = {
		materials = [{code = 'goblinmetal', min = 1, max = 1, chance = 35}],
	},
}
