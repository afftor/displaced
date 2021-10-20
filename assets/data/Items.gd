extends Node



var stats = {
	damage = tr('DAMAGE'),
	damagemod = tr('DAMAGEMOD'),
	armor = tr('ARMOR'),
	evasion = tr('EVASION'),
	hitrate = tr('HITRATE'),
	hpmod = tr("HEALTHPERCENT"),
	manamod = tr("MANAPERCENT"),
	critchance = tr("CRITCHANCE"),
	critmod = tr("CRITMOD"),
	hpmax = tr("HEALTH"),
	speed = tr("SPEED"),
	armorpenetration = tr("ARMORPENETRATION"),
	durability = tr("DURABILITY"),
	durabilitymod = tr("DURABILITYMOD"),
	resistfire = tr('RESISTFIRE'),
	resistwater = tr('RESISTWATER'),
	resistearth = tr('RESISTEARTH'),
	resistair = tr('RESISTAIR'),
	mdef = tr("MDEF"),

}



var Items = {

	#materials
	wood = {name = tr("MATERIAL_WOOD"),
	code = 'wood',
	description = tr("USABLEELIXIRDESCRIPT"),
	icon = load("res://assets/images/iconsitems/PotionLesser.png"),
	itemtype = 'mareial',
	unlockreqs = [],
	useeffects = [],
	useskill = '',
	tags = [],
	price = 50,
	},
	stone = {name = tr("MATERIAL_STONE"),
	code = 'stone', 
	description = tr("USABLEELIXIRDESCRIPT"),
	icon = load("res://assets/images/iconsitems/PotionLesser.png"),
	itemtype = 'mareial',
	unlockreqs = [],
	useeffects = [],
	useskill = '',
	tags = [],
	price = 50,
	},

	#usables
	morsel = {name = tr("USABLEMORSEL"), code = 'morsel', description = tr("USABLEMORSELDESCRIPT"),
	icon = load("res://assets/images/iconsitems/Morsel.png"),
	itemtype = 'usable_combat',
	unlockreqs = [],
	useeffects = ['heal50'], #for what is this (cause hp are added via skill)? and where is this effect defined?
	useskill = 'steakheal',
	tags = [],
	price = 10,
	},
	managrass = {name = tr("USABLEMANAGRASS"), code = 'managrass', description = tr("USABLEMANAGRASSDESCRIPT"),
	icon = load("res://assets/images/iconsitems/BlueGrass.png"),
	itemtype = 'usable_combat',
	unlockreqs = [],
	useeffects = [],
	useskill = 'bluegrass',
	tags = [],
	price = 25,
	},
	protectivecharm = {name = tr("USABLEPROTECTIVECHARM"), code = 'protectivecharm', description = tr("USABLEPROTECTIVECHARMDESCRIPT"),
	icon = load("res://assets/images/iconsitems/Charm.png"),
	itemtype = 'usable_combat',
	unlockreqs = [],
	useeffects = [],
	useskill = 'barrier3',
	tags = [],
	price = 50,
	},
	barricade = {name = tr("USABLEBARRICADE"), code = 'barricade', description = tr("USABLEBARRICADEDESCRIPT"),
	icon = load("res://assets/images/iconsitems/Barricade.png"),
	itemtype = 'usable_combat',
	unlockreqs = [],
	useeffects = [],
	useskill = 'barrier2',
	tags = [],
	price = 50,
	},
	lesserpotion = {name = tr("USABLEELIXIR"), code = 'lesserpotion', description = tr("USABLEELIXIRDESCRIPT"),
	icon = load("res://assets/images/iconsitems/PotionLesser.png"),
	itemtype = 'usable_combat',
	unlockreqs = [],
	useeffects = [],
	useskill = 'elixir',
	tags = [],
	price = 50,
	},
	#new ones, 2fix data
	item_1_1 = {
		name = tr("USABLEMANAGRASS"),
		code = 'item_1_1',
		description = tr("USABLEMANAGRASSDESCRIPT"),
		icon = load("res://assets/images/iconsitems/BlueGrass.png"),
		itemtype = 'usable_combat',
		unlockreqs = [],
		useeffects = [],
		useskill = 'item_1_1',
		tags = [],
		price = 25,
	},
	item_1_2 = {
		name = tr("USABLEMANAGRASS"),
		code = 'item_1_2',
		description = tr("USABLEMANAGRASSDESCRIPT"),
		icon = load("res://assets/images/iconsitems/BlueGrass.png"),
		itemtype = 'usable_combat',
		unlockreqs = [],
		useeffects = [],
		useskill = 'item_1_2',
		tags = [],
		price = 25,
	},
	item_1_3 = {
		name = tr("USABLEMANAGRASS"),
		code = 'item_1_3',
		description = tr("USABLEMANAGRASSDESCRIPT"),
		icon = load("res://assets/images/iconsitems/BlueGrass.png"),
		itemtype = 'usable_combat',
		unlockreqs = [],
		useeffects = [],
		useskill = 'item_1_3',
		tags = [],
		price = 25,
	},
	item_2_1 = {
		name = tr("USABLEMANAGRASS"),
		code = 'item_2_1',
		description = tr("USABLEMANAGRASSDESCRIPT"),
		icon = load("res://assets/images/iconsitems/BlueGrass.png"),
		itemtype = 'usable_combat',
		unlockreqs = [],
		useeffects = [],
		useskill = 'item_2_1',
		tags = [],
		price = 25,
	},
	item_2_2 = {
		name = tr("USABLEMANAGRASS"),
		code = 'item_2_2',
		description = tr("USABLEMANAGRASSDESCRIPT"),
		icon = load("res://assets/images/iconsitems/BlueGrass.png"),
		itemtype = 'usable_combat',
		unlockreqs = [],
		useeffects = [],
		useskill = 'item_2_2',
		tags = [],
		price = 25,
	},
	item_2_3 = {
		name = tr("USABLEMANAGRASS"),
		code = 'item_2_3',
		description = tr("USABLEMANAGRASSDESCRIPT"),
		icon = load("res://assets/images/iconsitems/BlueGrass.png"),
		itemtype = 'usable_combat',
		unlockreqs = [],
		useeffects = [],
		useskill = 'item_2_3',
		tags = [],
		price = 25,
	},
	item_3_1 = {
		name = tr("USABLEMANAGRASS"),
		code = 'item_3_1',
		description = tr("USABLEMANAGRASSDESCRIPT"),
		icon = load("res://assets/images/iconsitems/BlueGrass.png"),
		itemtype = 'usable_combat',
		unlockreqs = [],
		useeffects = [],
		useskill = 'item_3_1',
		tags = [],
		price = 25,
	},
	item_3_2 = {
		name = tr("USABLEMANAGRASS"),
		code = 'item_3_2',
		description = tr("USABLEMANAGRASSDESCRIPT"),
		icon = load("res://assets/images/iconsitems/BlueGrass.png"),
		itemtype = 'usable_combat',
		unlockreqs = [],
		useeffects = [],
		useskill = 'item_3_2',
		tags = [],
		price = 25,
	},
	item_4_1 = {
		name = tr("USABLEMANAGRASS"),
		code = 'item_4_1',
		description = tr("USABLEMANAGRASSDESCRIPT"),
		icon = load("res://assets/images/iconsitems/BlueGrass.png"),
		itemtype = 'usable_combat',
		unlockreqs = [],
		useeffects = [],
		useskill = 'item_4_1',
		tags = [],
		price = 25,
	},
	item_4_2 = {
		name = tr("USABLEMANAGRASS"),
		code = 'item_4_2',
		description = tr("USABLEMANAGRASSDESCRIPT"),
		icon = load("res://assets/images/iconsitems/BlueGrass.png"),
		itemtype = 'usable_combat',
		unlockreqs = [],
		useeffects = [],
		useskill = 'item_4_2',
		tags = [],
		price = 25,
	},
	item_4_3 = {
		name = tr("USABLEMANAGRASS"),
		code = 'item_4_3',
		description = tr("USABLEMANAGRASSDESCRIPT"),
		icon = load("res://assets/images/iconsitems/BlueGrass.png"),
		itemtype = 'usable_combat',
		unlockreqs = [],
		useeffects = [],
		useskill = 'item_4_3',
		tags = [],
		price = 25,
	},
	item_4_4 = {
		name = tr("USABLEMANAGRASS"),
		code = 'item_4_4',
		description = tr("USABLEMANAGRASSDESCRIPT"),
		icon = load("res://assets/images/iconsitems/BlueGrass.png"),
		itemtype = 'usable_combat',
		unlockreqs = [],
		useeffects = [],
		useskill = 'item_4_4',
		tags = [],
		price = 25,
	},
	item_5_1 = {
		name = tr("USABLEMANAGRASS"),
		code = 'item_5_1',
		description = tr("USABLEMANAGRASSDESCRIPT"),
		icon = load("res://assets/images/iconsitems/BlueGrass.png"),
		itemtype = 'usable_combat',
		unlockreqs = [],
		useeffects = [],
		useskill = 'item_5_1',
		tags = [],
		price = 25,
	},
	item_5_2 = {
		name = tr("USABLEMANAGRASS"),
		code = 'item_5_2',
		description = tr("USABLEMANAGRASSDESCRIPT"),
		icon = load("res://assets/images/iconsitems/BlueGrass.png"),
		itemtype = 'usable_combat',
		unlockreqs = [],
		useeffects = [],
		useskill = 'item_5_2',
		tags = [],
		price = 25,
	},
	item_5_3 = {
		name = tr("USABLEMANAGRASS"),
		code = 'item_5_3',
		description = tr("USABLEMANAGRASSDESCRIPT"),
		icon = load("res://assets/images/iconsitems/BlueGrass.png"),
		itemtype = 'usable_combat',
		unlockreqs = [],
		useeffects = [],
		useskill = 'item_1_1',
		tags = [],
		price = 25,
	},
	item_6_1 = {
		name = tr("USABLEMANAGRASS"),
		code = 'item_6_1',
		description = tr("USABLEMANAGRASSDESCRIPT"),
		icon = load("res://assets/images/iconsitems/BlueGrass.png"),
		itemtype = 'usable_combat',
		unlockreqs = [],
		useeffects = [],
		useskill = 'item_6_1',
		tags = [],
		price = 25,
	},
	item_6_2 = {
		name = tr("USABLEMANAGRASS"),
		code = 'item_6_2',
		description = tr("USABLEMANAGRASSDESCRIPT"),
		icon = load("res://assets/images/iconsitems/BlueGrass.png"),
		itemtype = 'usable_combat',
		unlockreqs = [],
		useeffects = [],
		useskill = 'item_6_2',
		tags = [],
		price = 25,
	},
	item_7_1 = {
		name = tr("USABLEMANAGRASS"),
		code = 'item_7_1',
		description = tr("USABLEMANAGRASSDESCRIPT"),
		icon = load("res://assets/images/iconsitems/BlueGrass.png"),
		itemtype = 'usable_combat',
		unlockreqs = [],
		useeffects = [],
		useskill = 'item_7_1',
		tags = [],
		price = 25,
	},
	item_7_2 = {
		name = tr("USABLEMANAGRASS"),
		code = 'item_7_2',
		description = tr("USABLEMANAGRASSDESCRIPT"),
		icon = load("res://assets/images/iconsitems/BlueGrass.png"),
		itemtype = 'usable_combat',
		unlockreqs = [],
		useeffects = [],
		useskill = 'item_7_2',
		tags = [],
		price = 25,
	},
}

func gainhealth(target, value):
	target.hp += value

#func itemtofood(item):
#	state.food += item.foodvalue

var bonustatsarray = ['damage','evasion', 'hitrate','hp','speed','resistfire', 'resistearth', 'resistair', 'resistwater'] #2fix, possibly obsolete

var hero_items_data = {
	arron_weapon1 = {
		name = 'weapon1',
		description = 'descript',
		weaponrange = 'melee',
		damagetype = 'pierce',
		weaponsound = 'dodge',
		leveldata = {
			1:{
				icon = "res://assets/images/iconsgear/arron_weapon1_1.png",
				lvldesc = "1",
				cost = {},
				},
			2:{
				icon = "res://assets/images/iconsgear/arron_weapon1_2.png",
				lvldesc = "2",
				cost = {wood = 10, stone = 10},
				},
			3:{
				icon = "res://assets/images/iconsgear/arron_weapon1_3.png",
				lvldesc = "3",
				cost = {wood = 10},
				},
			4:{
				icon = "res://assets/images/iconsgear/arron_weapon1_4.png",
				lvldesc = "4",
				cost = {wood = 10},
				},
		}
	},
	arron_weapon2 = {
		name = 'weapon2',
		description = 'descript',
		weaponrange = 'melee',
		damagetype = 'pierce',
		weaponsound = 'dodge',
		leveldata = {
			0:{ #for possible use later
				icon = "res://assets/images/gui/forge/panel_forge_gear_disabled.png",
				lvldesc = "Not forged yet",
				cost = {},
				},
			1:{
				icon = "res://assets/images/iconsgear/arron_weapon2_1.png",
				lvldesc = "5",
				cost = {wood = 10},
				},
			2:{
				icon = "res://assets/images/iconsgear/arron_weapon2_2.png",
				lvldesc = "6",
				cost = {wood = 10},
				},
			3:{
				icon = "res://assets/images/iconsgear/arron_weapon2_3.png",
				lvldesc = "7",
				cost = {wood = 10},
				},
			4:{
				icon = "res://assets/images/iconsgear/arron_weapon2_4.png",
				lvldesc = "8",
				cost = {wood = 10},
				},
		}
	},
	arron_armor = {
		name = 'armor',
		description = 'descript',
		leveldata = {
			1:{
				icon = "res://assets/images/iconsgear/arron_armor_1.png",
				lvldesc = "1",
				cost = {},
				},
			2:{
				icon = "res://assets/images/iconsgear/arron_armor_2.png",
				lvldesc = "2",
				cost = {},
				},
			3:{
				icon = "res://assets/images/iconsgear/arron_armor_3.png",
				lvldesc = "3",
				cost = {},
				},
			4:{
				icon = "res://assets/images/iconsgear/arron_armor_4.png",
				lvldesc = "4",
				cost = {},
				},
		}
	},
	rilu_weapon1 = {
		name = 'weapon1',
		description = 'descript',
		weaponrange = 'melee',
		damagetype = 'pierce',
		weaponsound = 'dodge',
		leveldata = {
			1:{
				icon = "res://assets/images/iconsgear/rilu_weapon1_1.png",
				lvldesc = "1",
				cost = {},
				},
			2:{
				icon = "res://assets/images/iconsgear/rilu_weapon1_2.png",
				lvldesc = "2",
				cost = {},
				},
			3:{
				icon = "res://assets/images/iconsgear/rilu_weapon1_3.png",
				lvldesc = "3",
				cost = {},
				},
			4:{
				icon = "res://assets/images/iconsgear/rilu_weapon1_4.png",
				lvldesc = "4",
				},
		}
	},
	rilu_weapon2 = {
		name = 'weapon2',
		description = 'descript',
		weaponrange = 'melee',
		damagetype = 'pierce',
		weaponsound = 'dodge',
		leveldata = {
			0:{ #for possible use later
				icon = "res://assets/images/gui/forge/panel_forge_gear_disabled.png",
				lvldesc = "Not forged yet",
				cost = {},
				},
			1:{
				icon = "res://assets/images/iconsgear/rilu_weapon2_1.png",
				lvldesc = "5",
				cost = {},
				},
			2:{
				icon = "res://assets/images/iconsgear/rilu_weapon2_2.png",
				lvldesc = "6",
				cost = {},
				},
			3:{
				icon = "res://assets/images/iconsgear/rilu_weapon2_3.png",
				lvldesc = "7",
				cost = {},
				},
			4:{
				icon = "res://assets/images/iconsgear/rilu_weapon2_4.png",
				lvldesc = "8",
				cost = {},
				},
		}
	},
	rilu_armor = {
		name = 'armor',
		description = 'descript',
		leveldata = {
			1:{
				icon = "res://assets/images/iconsgear/rilu_armor_1.png",
				lvldesc = "1",
				cost = {},
				},
			2:{
				icon = "res://assets/images/iconsgear/rilu_armor_2.png",
				lvldesc = "2",
				cost = {},
				},
			3:{
				icon = "res://assets/images/iconsgear/rilu_armor_3.png",
				lvldesc = "3",
				cost = {},
				},
			4:{
				icon = "res://assets/images/iconsgear/rilu_armor_4.png",
				lvldesc = "4",
				cost = {},
				},
		}
	},
	iola_weapon1 = {
		name = 'weapon1',
		description = 'descript',
		weaponrange = 'melee',
		damagetype = 'pierce',
		weaponsound = 'dodge',
		leveldata = {
			1:{
				icon = "res://assets/images/iconsgear/iola_weapon1_1.png",
				lvldesc = "1",
				cost = {},
				},
			2:{
				icon = "res://assets/images/iconsgear/iola_weapon1_2.png",
				lvldesc = "2",
				cost = {},
				},
			3:{
				icon = "res://assets/images/iconsgear/iola_weapon1_3.png",
				lvldesc = "3",
				cost = {},
				},
			4:{
				icon = "res://assets/images/iconsgear/iola_weapon1_4.png",
				lvldesc = "4",
				cost = {},
				},
		}
	},
	iola_weapon2 = {
		name = 'weapon2',
		description = 'descript',
		weaponrange = 'melee',
		damagetype = 'pierce',
		weaponsound = 'dodge',
		leveldata = {
			0:{ #for possible use later
				icon = "res://assets/images/gui/forge/panel_forge_gear_disabled.png",
				lvldesc = "Not forged yet",
				cost = {},
				},
			1:{
				icon = "res://assets/images/iconsgear/iola_weapon2_1.png",
				lvldesc = "5",
				cost = {},
				},
			2:{
				icon = "res://assets/images/iconsgear/iola_weapon2_2.png",
				lvldesc = "6",
				cost = {},
				},
			3:{
				icon = "res://assets/images/iconsgear/iola_weapon2_3.png",
				lvldesc = "7",
				cost = {},
				},
			4:{
				icon = "res://assets/images/iconsgear/iola_weapon2_4.png",
				lvldesc = "8",
				cost = {},
				},
		}
	},
	iola_armor = {
		name = 'armor',
		description = 'descript',
		leveldata = {
			1:{
				icon = "res://assets/images/iconsgear/iola_armor_1.png",
				lvldesc = "1",
				cost = {},
				},
			2:{
				icon = "res://assets/images/iconsgear/iola_armor_2.png",
				lvldesc = "2",
				cost = {},
				},
			3:{
				icon = "res://assets/images/iconsgear/iola_armor_3.png",
				lvldesc = "3",
				cost = {},
				},
			4:{
				icon = "res://assets/images/iconsgear/iola_armor_4.png",
				lvldesc = "4",
				cost = {},
				},
		}
	},
	rose_weapon1 = {
		name = 'weapon1',
		description = 'descript',
		weaponrange = 'melee',
		damagetype = 'pierce',
		weaponsound = 'dodge',
		leveldata = {
			1:{
				icon = "res://assets/images/iconsgear/rose_weapon1_1.png",
				lvldesc = "1",
				cost = {},
				},
			2:{
				icon = "res://assets/images/iconsgear/rose_weapon1_2.png",
				lvldesc = "2",
				cost = {},
				},
			3:{
				icon = "res://assets/images/iconsgear/rose_weapon1_3.png",
				lvldesc = "3",
				cost = {},
				},
			4:{
				icon = "res://assets/images/iconsgear/rose_weapon1_4.png",
				lvldesc = "4",
				cost = {},
				},
		}
	},
	rose_weapon2 = {
		name = 'weapon2',
		description = 'descript',
		weaponrange = 'melee',
		damagetype = 'pierce',
		weaponsound = 'dodge',
		leveldata = {
			0:{ #for possible use later
				icon = "res://assets/images/gui/forge/panel_forge_gear_disabled.png",
				lvldesc = "Not forged yet",
				cost = {},
				},
			1:{
				icon = "res://assets/images/iconsgear/rose_weapon2_1.png",
				lvldesc = "5",
				cost = {},
				},
			2:{
				icon = "res://assets/images/iconsgear/rose_weapon2_2.png",
				lvldesc = "6",
				cost = {},
				},
			3:{
				icon = "res://assets/images/iconsgear/rose_weapon2_3.png",
				lvldesc = "7",
				cost = {},
				},
			4:{
				icon = "res://assets/images/iconsgear/rose_weapon2_4.png",
				lvldesc = "8",
				cost = {},
				},
		}
	},
	rose_armor = {
		name = 'armor',
		description = 'descript',
		leveldata = {
			1:{
				icon = "res://assets/images/iconsgear/rose_armor_1.png",
				lvldesc = "1",
				cost = {},
				},
			2:{
				icon = "res://assets/images/iconsgear/rose_armor_2.png",
				lvldesc = "2",
				cost = {},
				},
			3:{
				icon = "res://assets/images/iconsgear/rose_armor_3.png",
				lvldesc = "3",
				cost = {},
				},
			4:{
				icon = "res://assets/images/iconsgear/rose_armor_4.png",
				lvldesc = "4",
				cost = {},
				},
		}
	},
	ember_weapon1 = {
		name = 'weapon1',
		description = 'descript',
		weaponrange = 'melee',
		damagetype = 'pierce',
		weaponsound = 'dodge',
		leveldata = {
			1:{
				icon = "res://assets/images/iconsgear/ember_weapon1_1.png",
				lvldesc = "1",
				cost = {},
				},
			2:{
				icon = "res://assets/images/iconsgear/ember_weapon1_2.png",
				lvldesc = "2",
				cost = {},
				},
			3:{
				icon = "res://assets/images/iconsgear/ember_weapon1_3.png",
				lvldesc = "3",
				cost = {},
				},
			4:{
				icon = "res://assets/images/iconsgear/ember_weapon1_4.png",
				lvldesc = "4",
				cost = {},
				},
		}
	},
	ember_weapon2 = {
		name = 'weapon2',
		description = 'descript',
		weaponrange = 'melee',
		damagetype = 'pierce',
		weaponsound = 'dodge',
		leveldata = {
			0:{ #for possible use later
				icon = "res://assets/images/gui/forge/panel_forge_gear_disabled.png",
				lvldesc = "Not forged yet",
				cost = {},
				},
			1:{
				icon = "res://assets/images/iconsgear/ember_weapon2_1.png",
				lvldesc = "5",
				cost = {},
				},
			2:{
				icon = "res://assets/images/iconsgear/ember_weapon2_2.png",
				lvldesc = "6",
				cost = {},
				},
			3:{
				icon = "res://assets/images/iconsgear/ember_weapon2_3.png",
				lvldesc = "7",
				cost = {},
				},
			4:{
				icon = "res://assets/images/iconsgear/ember_weapon2_4.png",
				lvldesc = "8",
				cost = {},
				},
		}
	},
	ember_armor = {
		name = 'armor',
		description = 'descript',
		leveldata = {
			1:{
				icon = "res://assets/images/iconsgear/ember_armor_1.png",
				lvldesc = "1",
				cost = {},
				},
			2:{
				icon = "res://assets/images/iconsgear/ember_armor_2.png",
				lvldesc = "2",
				cost = {},
				},
			3:{
				icon = "res://assets/images/iconsgear/ember_armor_3.png",
				lvldesc = "3",
				cost = {},
				},
			4:{
				icon = "res://assets/images/iconsgear/ember_armor_4.png",
				lvldesc = "4",
				cost = {},
				},
		}
	},
	erika_weapon1 = {
		name = 'weapon1',
		description = 'descript',
		weaponrange = 'melee',
		damagetype = 'pierce',
		weaponsound = 'dodge',
		leveldata = {
			1:{
				icon = "res://assets/images/iconsgear/erika_weapon1_1.png",
				lvldesc = "1",
				cost = {},
				},
			2:{
				icon = "res://assets/images/iconsgear/erika_weapon1_2.png",
				lvldesc = "2",
				cost = {},
				},
			3:{
				icon = "res://assets/images/iconsgear/erika_weapon1_3.png",
				lvldesc = "3",
				cost = {},
				},
			4:{
				icon = "res://assets/images/iconsgear/erika_weapon1_4.png",
				lvldesc = "4",
				cost = {},
				},
		}
	},
	erika_weapon2 = {
		name = 'weapon2',
		description = 'descript',
		weaponrange = 'melee',
		damagetype = 'pierce',
		weaponsound = 'dodge',
		leveldata = {
			0:{ #for possible use later
				icon = "res://assets/images/gui/forge/panel_forge_gear_disabled.png",
				lvldesc = "Not forged yet",
				cost = {},
				},
			1:{
				icon = "res://assets/images/iconsgear/erika_weapon2_1.png",
				lvldesc = "5",
				cost = {},
				},
			2:{
				icon = "res://assets/images/iconsgear/erika_weapon2_2.png",
				lvldesc = "6",
				cost = {},
				},
			3:{
				icon = "res://assets/images/iconsgear/erika_weapon2_3.png",
				lvldesc = "7",
				cost = {},
				},
			4:{
				icon = "res://assets/images/iconsgear/erika_weapon2_4.png",
				lvldesc = "8",
				cost = {},
				},
		}
	},
	erika_armor = {
		name = 'armor',
		description = 'descript',
		leveldata = {
			1:{
				icon = "res://assets/images/iconsgear/erika_armor_1.png",
				lvldesc = "1",
				cost = {},
				},
			2:{
				icon = "res://assets/images/iconsgear/erika_armor_2.png",
				lvldesc = "2",
				cost = {},
				},
			3:{
				icon = "res://assets/images/iconsgear/erika_armor_3.png",
				lvldesc = "3",
				cost = {},
				},
			4:{
				icon = "res://assets/images/iconsgear/erika_armor_4.png",
				lvldesc = "4",
				cost = {},
				},
		}
	},
}
