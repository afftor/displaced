extends Node

var combatant = preload("res://src/combatant.gd");

var lootlist = {
	elvenratloot = {
		
		
	}
	
}

var classlist = {
	warrior = {
		code = 'warrior',
		name = tr("WARRIOR"),
		description = tr("WARRIORDESCRIPT"),
		gearsubtypes = ['dagger','sword','axe','spear'],
		basehp = 200,
		basemana = 25,
		speed = 50,
		damage = 15,
		skills = ['attack','slash'],
		learnableskills = [],
		icon = null,
	},
	mage = {
		code = 'mage',
		name = tr("MAGE"),
		description = tr("MAGEDESCRIPT"),
		gearsubtypes = ['rod','dagger'],
		basehp = 100,
		basemana = 100,
		speed = 30,
		damage = 15,
		skills = ['attack', 'firebolt', 'concentrate'],
		learnableskills = [],
		icon = null,
	},
	archer = {
		code = 'archer',
		name = tr("ARCHER"),
		description = tr("ARCHERDESCRIPT"),
		gearsubtypes = ['bow', 'dagger'],
		basehp = 150,
		basemana = 50,
		speed = 55,
		damage = 15,
		skills = ['attack', 'firebolt', 'concentrate'],
		learnableskills = [],
		icon = null,
	},
	brawler = {
		code = 'brawler',
		name = tr("BRAWLER"),
		description = tr("BRAWLERDESCRIPT"),
		gearsubtypes = [],
		basehp = 175,
		basemana = 50,
		speed = 40,
		damage = 15,
		skills = ['attack'],
		learnableskills = [],
		icon = null,
	}
}

var charlist = {
	Arron = {
		code = 'Arron',
		name = tr('ARRON'),
		icon = 'ArronSmile',
		combaticon = 'arron',
		image = 'Arron',
		subclass = 'warrior',
	},
	Rose = {
		code = 'Rose',
		name = tr('ROSE'),
		icon = 'RoseNormal',
		combaticon = 'rose',
		image = 'Rose',
		subclass = 'mage',
	},
	Erika = {
		code = 'Erika',
		name = tr('ERIKA'),
		icon = 'ErikaNormal',
		combaticon = 'erika',
		image = 'Erika',
		subclass = 'archer',
	},
	Ember = {
		code = 'Ember',
		name = tr('EMBER'),
		icon = 'EmberFriendly',
		combaticon = 'ember',
		image = 'Ember',
		subclass = 'brawler',
	},
}
#
#
var namesarray = ['name1','name2','name3','name4','name5']
#
#
#
#var traitlist = {
#	fencer = { #+20 hit when using sword
#		code = 'fencer',
#		name = tr("FENCER"),
#		description = tr("FENCERDESCRIPT"),
#		effects = ['fencer'],
#		type = 'fighter',
#		weight = 1,
#		},
#	destroyer = { #+20% dmg, equipment breaks 25% faster
#		code = 'destroyer',
#		name = tr("DESTROYER"),
#		description = tr("DESTROYERDESCRIPT"),
#		effects = ["destroyer"],
#		type = 'starter',
#		weight = 1,
#		},
#	speedster = { #+20% speed, -15 hit
#		code = 'speedster',
#		name = tr("SPEEDSTER"),
#		description = tr("SPEEDSTERDESCRIPT"),
#		effects = ['speedster'],
#		type = 'starter',
#		weight = 1,
#		},
#	slayer = { #+15 armorpen, -20% hp
#		code = 'slayer',
#		name = tr("SLAYER"),
#		description = tr("SLAYERDESCRIPT"),
#		effects = ['slayer'],
#		type = 'starter',
#		weight = 1,
#		},
#	brute = { #+20%hp, -20 evasion
#		code = 'brute',
#		name = tr("BRUTE"),
#		description = tr("BRUTEDESCRIPT"),
#		effects = ['brute'],
#		type = 'starter',
#		weight = 1,
#		},
#	arcane = { #+15 mdef, -15% hp
#		code = 'arcane',
#		name = tr("ARCANE"),
#		description = tr("ARCANEDESCRIPT"),
#		effects = ['arcane'],
#		type = 'starter',
#		weight = 1,
#		},
#	precise = { #+20 hit, -15 armor
#		code = 'precise',
#		name = tr("PRECISE"),
#		description = tr("PRECISEDESCRIPT"),
#		effects = ['precise'],
#		type = 'starter',
#		weight = 1,
#		},
#	resourceful = { #+drop, -15 dmg, hp
#		code = 'resourceful',
#		name = tr("RESOURCEFUL"),
#		description = tr("RESOURCEFULDESCRIPT"),
#		effects = ['resourceful', 'resourcefulaftercombat'],
#		type = 'starter',
#		weight = 1,
#		},
#	elusive = { #+dodge, -mdef
#		code = 'elusive',
#		name = tr("ELUSIVE"),
#		description = tr("ELUSIVEDESCRIPT"),
#		effects = ['elusive'],
#		type = 'starter',
#		weight = 1,
#		},
#	thick = { #+armor, -hp after combat
#		code = 'thick',
#		name = tr("THICK"),
#		description = tr("THICKDESCRIPT"),
#		effects = ['thick', 'thickaftercombat'],
#		type = 'starter',
#		weight = 1,
#		},
#	bookworm = { #+mana, -damage
#		code = 'bookworm',
#		name = tr("BOOKWORM"),
#		description = tr("BOOKWORMDESCRIPT"),
#		effects = ['bookworm'],
#		type = 'starter',
#		weight = 1,
#		},
#	}
#
#
#
#
#var effectlist = {
#	fencer = {
#		code = 'fencer',
#		trigger = 'onequip',
#		reqs = [{type = 'gear',slot = 'any', operant = 'eq', name = 'subtype', value = 'sword'}],
#		effects = [{effect = 'hitrate', value = 20}],
#	},
#	destroyer = {
#		code = 'destroyer',
#		trigger = 'always',
#		reqs = [],
#		effects = [{effect = 'damagemod', value = 0.2},{effect = 'detoriatemod', value = 0.25}],
#	},
#	speedster = {
#		code = 'speedster',
#		trigger = 'always',
#		reqs = [],
#		effects = [{effect = 'speed', value = 20},{effect = 'hitrate', value = -15}],
#	},
#	slayer = {
#		code = 'slayer',
#		trigger = 'always',
#		reqs = [],
#		effects = [{effect = 'armorpenetration', value = 15},{effect = 'hpmod', value = -0.2}],
#	},
#	brute = {
#		code = 'brute',
#		trigger = 'always',
#		reqs = [],
#		effects = [{effect = 'hpmod', value = 0.2},{effect = 'evasion', value = -20}],
#	},
#	arcane = {
#		code = 'arcane',
#		trigger = 'always',
#		reqs = [],
#		effects = [{effect = 'hpmod', value = -0.15},{effect = 'mdef', value = 15}],
#	},
#	precise = {
#		code = 'precise',
#		trigger = 'always',
#		reqs = [],
#		effects = [{effect = 'hitrate', value = 20},{effect = 'armor', value = -15}],
#	},
#	resourceful = {
#		code = 'resourceful',
#		trigger = 'always',
#		reqs = [],
#		effects = [{effect = 'damagemod', value = -15},{effect = 'hpmod', value = -0.15}],
#	},
#	resourcefulaftercombat = {
#		code = 'resourcefulaftercombat',
#		trigger = 'aftercombatglobal',
#		reqs = [],
#		effects = [{effect = 'droprate', value = 15}],
#	},
#	elusive = {
#		code = 'elusive',
#		trigger = 'always',
#		reqs = [],
#		effects = [{effect = 'mdef', value = -15},{effect = 'evasion', value = 20}],
#	},
#	thick = {
#		code = 'thick',
#		trigger = 'always',
#		reqs = [],
#		effects = [{effect = 'armor', value = 20},{effect = 'mdef', value = 15}],
#	},
#	thickaftercombat = {
#		code = 'thickaftercombat',
#		trigger = 'aftercombatself',
#		reqs = [],
#		effects = [{effect = 'hp', value = 5}],
#	},
#	bookworm = {
#		code = 'bookworm',
#		trigger = 'always',
#		reqs = [],
#		effects = [{effect = 'manamod', value = 20},{effect = 'damagemod', value = -15}],
#	},
#
#}
