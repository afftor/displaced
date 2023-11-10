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
	wood = {name = tr("MATERIALWOOD"),
#	code = 'wood',#set in _ready()
	description = tr("MATERIALWOODDESCRIPT"),
	icon = load("res://assets/images/iconsitems/Wood.png"),
	itemtype = 'material',
	useskill = '',
	price = 50,
	},
	stone = {name = tr("MATERIALSTONE"),
#	code = 'stone',
	description = tr("MATERIALSTONEDESCRIPT"),
	icon = load("res://assets/images/iconsitems/stone.png"),
	itemtype = 'material',
	useskill = '',
	price = 50,
	},
	metal = {name = tr("MATERIALMETAL"),
#	code = 'metal',
	description = tr("MATERIALMETALDESCRIPT"),
	icon = load("res://assets/images/iconsitems/DwarvenMetal.png"),
	itemtype = 'material',
	useskill = '',
	price = 50,
	},
	scales = {name = tr("MATERIALSCALES"),
#	code = 'scales',
	description = tr("MATERIALSCALESDESCRIPT"),
	icon = load("res://assets/images/iconsitems/scales.png"),
	itemtype = 'material',
	useskill = '',
	price = 50,
	},
	otherworld = {name = tr("MATERIALOTHERWORLD"),
#	code = 'otherworld',
	description = tr("MATERIALOTHERWORLDDESCRIPT"),
	icon = load("res://assets/images/iconsitems/otherworld.png"),
	itemtype = 'material',
	useskill = '',
	price = 50,
	},
	chitine = {name = tr("MATERIALCHITINE"),
#	code = 'chitine',
	description = tr("MATERIALCHITINEDESCRIPT"),
	icon = load("res://assets/images/iconsitems/chitin.png"),
	itemtype = 'material',
	useskill = '',
	price = 50,
	},
	leather = {name = tr("MATERIALLEATHER"),
#	code = 'leather',
	description = tr("MATERIALLEATHERDESCRIPT"),
	icon = load("res://assets/images/iconsitems/Leather.png"),
	itemtype = 'material',
	useskill = '',
	price = 50,
	},
	demonic = {name = tr("MATERIALDEMONIC"),
#	code = 'demonic',
	description = tr("MATERIALDEMONICDESCRIPT"),
	icon = load("res://assets/images/iconsitems/demonic.png"),
	itemtype = 'material',
	useskill = '',
	price = 50,
	},

	#usables
#	morsel = {name = tr("USABLEMORSEL"),
##	code = 'morsel',
#	description = tr("USABLEMORSELDESCRIPT"),
#	icon = load("res://assets/images/iconsitems/Morsel.png"),
#	itemtype = 'usable_combat',
#	unlockreqs = [],
#	useeffects = ['heal50'], #for what is this (cause hp are added via skill)? and where is this effect defined?
#	useskill = 'steakheal',
#	tags = [],
#	price = 10,
#	},
#	managrass = {name = tr("USABLEMANAGRASS"),
##	code = 'managrass',
#	description = tr("USABLEMANAGRASSDESCRIPT"),
#	icon = load("res://assets/images/iconsitems/BlueGrass.png"),
#	itemtype = 'usable_combat',
#	unlockreqs = [],
#	useeffects = [],
#	useskill = 'bluegrass',
#	tags = [],
#	price = 25,
#	},
#	protectivecharm = {name = tr("USABLEPROTECTIVECHARM"),
##	code = 'protectivecharm',
#	description = tr("USABLEPROTECTIVECHARMDESCRIPT"),
#	icon = load("res://assets/images/iconsitems/Charm.png"),
#	itemtype = 'usable_combat',
#	unlockreqs = [],
#	useeffects = [],
#	useskill = 'barrier3',
#	tags = [],
#	price = 50,
#	},
#	barricade = {name = tr("USABLEBARRICADE"),
##	code = 'barricade',
#	description = tr("USABLEBARRICADEDESCRIPT"),
#	icon = load("res://assets/images/iconsitems/Barricade.png"),
#	itemtype = 'usable_combat',
#	unlockreqs = [],
#	useeffects = [],
#	useskill = 'barrier2',
#	tags = [],
#	price = 50,
#	},
#	lesserpotion = {name = tr("USABLEELIXIR"),
##	code = 'lesserpotion',
#	description = tr("USABLEELIXIRDESCRIPT"),
#	icon = load("res://assets/images/iconsitems/PotionLesser.png"),
#	itemtype = 'usable_combat',
#	unlockreqs = [],
#	useeffects = [],
#	useskill = 'elixir',
#	tags = [],
#	price = 50,
#	},
	
	item_heal_1 = {
		name = tr("ITEMITEM_HEAL_1NAME"),
#		code = 'item_heal_1',
		description = tr("ITEMITEM_HEAL_1DESCRIPT"),
		icon = load("res://assets/images/iconsitems/carrot.png"),
		itemtype = 'usable_combat',
		useskill = 'item_heal_1_effect',
		price = 25,
	},
	item_heal_2 = {
		name = tr("ITEMITEM_HEAL_2NAME"),
#		code = 'item_heal_2',
		description = tr("ITEMITEM_HEAL_2DESCRIPT"),
		icon = load("res://assets/images/iconsitems/Morsel.png"),
		itemtype = 'usable_combat',
		useskill = 'item_heal_2_effect',
		price = 125,
	},
	item_heal_3 = {
		name = tr("ITEMITEM_HEAL_3NAME"),
#		code = 'item_heal_3',
		description = tr("ITEMITEM_HEAL_3DESCRIPT"),
		icon = load("res://assets/images/iconsitems/meat2.png"),
		itemtype = 'usable_combat',
		useskill = 'item_heal_3_effect',
		price = 500,
	},
	item_heal_aoe_1 = {
		name = tr("ITEMITEM_HEAL_AOE_1NAME"),
#		code = 'item_heal_aoe_1',
		description = tr("ITEMITEM_HEAL_AOE_1DESCRIPT"),
		icon = load("res://assets/images/iconsitems/shroom.png"),
		itemtype = 'usable_combat',
		useskill = 'item_heal_aoe_1_effect',
		price = 25,
	},
	item_heal_aoe_2 = {
		name = tr("ITEMITEM_HEAL_AOE_2NAME"),
#		code = 'item_heal_aoe_2',
		description = tr("ITEMITEM_HEAL_AOE_2DESCRIPT"),
		icon = load("res://assets/images/iconsitems/leaf.png"),
		itemtype = 'usable_combat',
		useskill = 'item_heal_aoe_2_effect',
		price = 25,
	},
	item_heal_aoe_3 = {
		name = tr("ITEMITEM_HEAL_AOE_3NAME"),
#		code = 'item_heal_aoe_3',
		description = tr("ITEMITEM_HEAL_AOE_3DESCRIPT"),
		icon = load("res://assets/images/iconsitems/flower.png"),
		itemtype = 'usable_combat',
		useskill = 'item_heal_aoe_3_effect',
		price = 25,
	},
	item_dispel_1 = {
		name = tr("ITEMITEM_DISPEL_1NAME"),
#		code = 'item_dispel_1',
		description = tr("ITEMITEM_DISPEL_1DESCRIPT"),
		icon = load("res://assets/images/iconsitems/apple.png"),
		itemtype = 'usable_combat',
		useskill = 'item_dispel_1_effect',
		price = 25,
	},
	item_dispel_2 = {
		name = tr("ITEMITEM_DISPEL_2NAME"),
#		code = 'item_3_2',
		description = tr("ITEMITEM_DISPEL_2DESCRIPT"),
		icon = load("res://assets/images/iconsitems/apple2.png"),
		itemtype = 'usable_combat',
		useskill = 'item_dispel_2_effect',
		price = 25,
	},
	item_res_1 = {
		name = tr("ITEMITEM_RES_1NAME"),
#		code = 'item_res_1',
		description = tr("ITEMITEM_RES_1DESCRIPT"),
		icon = load("res://assets/images/iconsitems/item_res.png"),
		itemtype = 'usable_combat',
		useskill = 'item_res_1_effect',
		price = 25,
	},
	item_res_2 = {
		name = tr("ITEMITEM_RES_2NAME"),
#		code = 'item_res_2',
		description = tr("ITEMITEM_RES_2DESCRIPT"),
		icon = load("res://assets/images/iconsitems/item_res3.png"),
		itemtype = 'usable_combat',
		useskill = 'item_res_2_effect',
		price = 25,
	},
	item_res_3 = {
		name = tr("ITEMITEM_RES_3NAME"),
#		code = 'item_res_3',
		description = tr("ITEMITEM_RES_3DESCRIPT"),
		icon = load("res://assets/images/iconsitems/item_res2.png"),
		itemtype = 'usable_combat',
		useskill = 'item_res_3_effect',
		price = 25,
	},
	item_res_4 = {
		name = tr("ITEMITEM_RES_4NAME"),
#		code = 'item_res_4',
		description = tr("ITEMITEM_RES_4DESCRIPT"),
		icon = load("res://assets/images/iconsitems/item_res4.png"),
		itemtype = 'usable_combat',
		useskill = 'item_res_4_effect',
		price = 25,
	},
	item_barrier_1 = {
		name = tr("ITEMITEM_BARRIER_1NAME"),
#		code = 'item_barrier_1',
		description = tr("ITEMITEM_BARRIER_1DESCRIPT"),
		icon = load("res://assets/images/iconsitems/feather3.png"),
		itemtype = 'usable_combat',
		useskill = 'item_barrier_1_effect',
		price = 25,
	},
	item_barrier_2 = {
		name = tr("ITEMITEM_BARRIER_2NAME"),
#		code = 'item_barrier_2',
		description = tr("ITEMITEM_BARRIER_2DESCRIPT"),
		icon = load("res://assets/images/iconsitems/feather1.png"),
		itemtype = 'usable_combat',
		useskill = 'item_barrier_2_effect',
		price = 25,
	},
	item_barrier_3 = {
		name = tr("ITEMITEM_BARRIER_3NAME"),
#		code = 'item_barrier_3',
		description = tr("ITEMITEM_BARRIER_3DESCRIPT"),
		icon = load("res://assets/images/iconsitems/feather2.png"),
		itemtype = 'usable_combat',
		useskill = 'item_barrier_3_effect',
		price = 25,
	},
	item_damage_1 = {
		name = tr("ITEMITEM_DAMAGE_1NAME"),
#		code = 'item_damage_1',
		description = tr("ITEMITEM_DAMAGE_1DESCRIPT"),
		icon = load("res://assets/images/iconsitems/bomb.png"),
		itemtype = 'usable_combat',
		useskill = 'item_damage_1_effect',
		price = 25,
	},
	item_damage_2 = {
		name = tr("ITEMITEM_DAMAGE_2NAME"),
#		code = 'item_damage_2',
		description = tr("ITEMITEM_DAMAGE_2DESCRIPT"),
		icon = load("res://assets/images/iconsitems/bomb_adv.png"),
		itemtype = 'usable_combat',
		useskill = 'item_damage_2_effect',
		price = 25,
	},
	item_buff_atk = {
		name = tr("ITEMITEM_BUFF_ATKNAME"),
#		code = 'item_buff_atk',
		description = tr("ITEMITEM_BUFF_ATKDESCRIPT"),
		icon = load("res://assets/images/iconsitems/scroll_sword.png"),
		itemtype = 'usable_combat',
		useskill = 'item_buff_atk_effect',
		price = 25,
	},
	item_buff_def = {
		name = tr("ITEMITEM_BUFF_DEFNAME"),
#		code = 'item_buff_def',
		description = tr("ITEMITEM_BUFF_DEFDESCRIPT"),
		icon = load("res://assets/images/iconsitems/scroll_shield.png"),
		itemtype = 'usable_combat',
		useskill = 'item_buff_def_effect',
		price = 25,
	},
}

#to delete
#func gainhealth(target, value):
#	target.hp += value

#func itemtofood(item):
#	state.food += item.foodvalue

#to delete
#var bonustatsarray = ['damage','evasion', 'hitrate','hp','speed','resistfire', 'resistearth', 'resistair', 'resistwater'] #2fix, possibly obsolete

var hero_items_data = {
	arron_weapon1 = {
		name = 'WEAPON_ARRON1',
		description = 'descript',
		weaponrange = 'melee',
		damagetype = 'slash',
		weaponsound = 'dodge',
		leveldata = {
			1:{
				icon = "res://assets/images/iconsgear/arron_weapon1_1.png",
				lvldesc = "WEAPON_ARRON1_EFFECT1",
				cost = {},
				},
			2:{
				icon = "res://assets/images/iconsgear/arron_weapon1_2.png",
				lvldesc = "WEAPON_ARRON1_EFFECT2",
				cost = {wood = 10, gold = 1000},
				},
			3:{
				icon = "res://assets/images/iconsgear/arron_weapon1_3.png",
				lvldesc = "WEAPON_ARRON1_EFFECT3",
				cost = {chitine = 15, gold = 8000},
				},
			4:{
				icon = "res://assets/images/iconsgear/arron_weapon1_4.png",
				lvldesc = "WEAPON_ARRON1_EFFECT4",
				cost = {demonic = 10, gold = 17000},
				},
		}
	},
	arron_weapon2 = {
		name = 'WEAPON_ARRON2',
		description = 'descript',
		weaponrange = 'melee',
		damagetype = 'slash',
		weaponsound = 'dodge',
		leveldata = {
			0:{ #for possible use later
				icon = "res://assets/images/gui/forge/panel_forge_gear_disabled.png",
				lvldesc = "Not forged yet",
				cost = {},
				},
			1:{
				icon = "res://assets/images/iconsgear/arron_weapon2_1.png",
				lvldesc = "WEAPON_ARRON2_EFFECT1",
				cost = {wood = 15, gold = 500},
				},
			2:{
				icon = "res://assets/images/iconsgear/arron_weapon2_2.png",
				lvldesc = "WEAPON_ARRON2_EFFECT2",
				cost = {metal = 20, gold = 5000},
				},
			3:{
				icon = "res://assets/images/iconsgear/arron_weapon2_3.png",
				lvldesc = "WEAPON_ARRON2_EFFECT3",
				cost = {scales = 10, gold = 10000},
				},
			4:{
				icon = "res://assets/images/iconsgear/arron_weapon2_4.png",
				lvldesc = "WEAPON_ARRON2_EFFECT4",
				cost = {demonic = 10, gold = 15000},
				},
		}
	},
	arron_armor = {
		name = 'ARMOR_ARRON',
		description = 'descript',
		leveldata = {
			1:{
				icon = "res://assets/images/iconsgear/arron_armor_1.png",
				lvldesc = "ARMOR_ARRON_EFFECT1",
				cost = {},
				},
			2:{
				icon = "res://assets/images/iconsgear/arron_armor_2.png",
				lvldesc = "ARMOR_ARRON_EFFECT2",
				cost = {stone = 10, gold = 700},
				},
			3:{
				icon = "res://assets/images/iconsgear/arron_armor_3.png",
				lvldesc = "ARMOR_ARRON_EFFECT3",
				cost = {metal = 15, gold = 4000},
				},
			4:{
				icon = "res://assets/images/iconsgear/arron_armor_4.png",
				lvldesc = "ARMOR_ARRON_EFFECT4",
				cost = {otherworld = 10, gold = 10000},
				},
		}
	},
	rilu_weapon1 = {
		name = 'WEAPON_RILU1',
		description = 'descript',
		weaponrange = 'melee',
		damagetype = 'dark',
		weaponsound = 'dodge',
		leveldata = {
			1:{
				icon = "res://assets/images/iconsgear/rilu_weapon1_1.png",
				lvldesc = "WEAPON_RILU1_EFFECT1",
				cost = {},
				},
			2:{
				icon = "res://assets/images/iconsgear/rilu_weapon1_2.png",
				lvldesc = "WEAPON_RILU1_EFFECT2",
				cost = {metal = 15, gold = 1000},
				},
			3:{
				icon = "res://assets/images/iconsgear/rilu_weapon1_3.png",
				lvldesc = "WEAPON_RILU1_EFFECT3",
				cost = {leather = 10, gold = 8000},
				},
			4:{
				icon = "res://assets/images/iconsgear/rilu_weapon1_4.png",
				lvldesc = "WEAPON_RILU1_EFFECT4",
				cost = {demonic = 10, gold = 17000},
				},
		}
	},
	rilu_weapon2 = {
		name = 'WEAPON_RILU2',
		description = 'descript',
		weaponrange = 'melee',
		damagetype = 'light',
		weaponsound = 'dodge',
		leveldata = {
			0:{ #for possible use later
				icon = "res://assets/images/gui/forge/panel_forge_gear_disabled.png",
				lvldesc = "Not forged yet",
				cost = {},
				},
			1:{
				icon = "res://assets/images/iconsgear/rilu_weapon2_1.png",
				lvldesc = "WEAPON_RILU2_EFFECT1",
				cost = {stone = 15, gold = 500},
				},
			2:{
				icon = "res://assets/images/iconsgear/rilu_weapon2_2.png",
				lvldesc = "WEAPON_RILU2_EFFECT2",
				cost = {chitine = 15, gold = 5000},
				},
			3:{
				icon = "res://assets/images/iconsgear/rilu_weapon2_3.png",
				lvldesc = "WEAPON_RILU2_EFFECT3",
				cost = {leather = 10, gold = 10000},
				},
			4:{
				icon = "res://assets/images/iconsgear/rilu_weapon2_4.png",
				lvldesc = "WEAPON_RILU2_EFFECT4",
				cost = {otherworld = 10, gold = 15000},
				},
		}
	},
	rilu_armor = {
		name = 'ARMOR_RILU',
		description = 'descript',
		leveldata = {
			1:{
				icon = "res://assets/images/iconsgear/rilu_armor_1.png",
				lvldesc = "ARMOR_RILU_EFFECT1",
				cost = {},
				},
			2:{
				icon = "res://assets/images/iconsgear/rilu_armor_2.png",
				lvldesc = "ARMOR_RILU_EFFECT2",
				cost = {chitine = 10, gold = 700},
				},
			3:{
				icon = "res://assets/images/iconsgear/rilu_armor_3.png",
				lvldesc = "ARMOR_RILU_EFFECT3",
				cost = {scales = 10, gold = 4000},
				},
			4:{
				icon = "res://assets/images/iconsgear/rilu_armor_4.png",
				lvldesc = "ARMOR_RILU_EFFECT4",
				cost = {otherworld = 10, gold = 10000},
				},
		}
	},
	iola_weapon1 = {
		name = 'WEAPON_IOLA1',
		description = 'descript',
		weaponrange = 'melee',
		damagetype = 'air',
		weaponsound = 'dodge',
		leveldata = {
			1:{
				icon = "res://assets/images/iconsgear/iola_weapon1_1.png",
				lvldesc = "WEAPON_IOLA1_EFFECT1",
				cost = {},
				},
			2:{
				icon = "res://assets/images/iconsgear/iola_weapon1_2.png",
				lvldesc = "WEAPON_IOLA1_EFFECT2",
				cost = {chitine = 10, gold = 1000},
				},
			3:{
				icon = "res://assets/images/iconsgear/iola_weapon1_3.png",
				lvldesc = "WEAPON_IOLA1_EFFECT3",
				cost = {scales = 15, gold = 8000},
				},
			4:{
				icon = "res://assets/images/iconsgear/iola_weapon1_4.png",
				lvldesc = "WEAPON_IOLA1_EFFECT4",
				cost = {otherworld = 10, gold = 17000},
				},
		}
	},
	iola_weapon2 = {
		name = 'WEAPON_IOLA2',
		description = 'descript',
		weaponrange = 'melee',
		damagetype = 'water',
		weaponsound = 'dodge',
		leveldata = {
			0:{ #for possible use later
				icon = "res://assets/images/gui/forge/panel_forge_gear_disabled.png",
				lvldesc = "Not forged yet",
				cost = {},
				},
			1:{
				icon = "res://assets/images/iconsgear/iola_weapon2_1.png",
				lvldesc = "WEAPON_IOLA2_EFFECT1",
				cost = {wood = 15, gold = 500},
				},
			2:{
				icon = "res://assets/images/iconsgear/iola_weapon2_2.png",
				lvldesc = "WEAPON_IOLA2_EFFECT2",
				cost = {metal = 20, gold = 5000},
				},
			3:{
				icon = "res://assets/images/iconsgear/iola_weapon2_3.png",
				lvldesc = "WEAPON_IOLA2_EFFECT3",
				cost = {leather = 10, gold = 10000},
				},
			4:{
				icon = "res://assets/images/iconsgear/iola_weapon2_4.png",
				lvldesc = "WEAPON_IOLA2_EFFECT4",
				cost = {otherworld = 10, gold = 15000},
				},
		}
	},
	iola_armor = {
		name = 'ARMOR_IOLA',
		description = 'descript',
		leveldata = {
			1:{
				icon = "res://assets/images/iconsgear/iola_armor_1.png",
				lvldesc = "ARMOR_IOLA_EFFECT1",
				cost = {},
				},
			2:{
				icon = "res://assets/images/iconsgear/iola_armor_2.png",
				lvldesc = "ARMOR_IOLA_EFFECT2",
				cost = {metal = 10, gold = 700},
				},
			3:{
				icon = "res://assets/images/iconsgear/iola_armor_3.png",
				lvldesc = "ARMOR_IOLA_EFFECT3",
				cost = {leather = 10, gold = 4000},
				},
			4:{
				icon = "res://assets/images/iconsgear/iola_armor_4.png",
				lvldesc = "ARMOR_IOLA_EFFECT4",
				cost = {demonic = 10, gold = 10000},
				},
		}
	},
	rose_weapon1 = {
		name = 'WEAPON_ROSE1',
		description = 'descript',
		weaponrange = 'melee',
		damagetype = 'fire',
		weaponsound = 'dodge',
		leveldata = {
			1:{
				icon = "res://assets/images/iconsgear/rose_weapon1_1.png",
				lvldesc = "WEAPON_ROSE1_EFFECT1",
				cost = {},
				},
			2:{
				icon = "res://assets/images/iconsgear/rose_weapon1_2.png",
				lvldesc = "WEAPON_ROSE1_EFFECT2",
				cost = {stone = 15, gold = 1000},
				},
			3:{
				icon = "res://assets/images/iconsgear/rose_weapon1_3.png",
				lvldesc = "WEAPON_ROSE1_EFFECT3",
				cost = {scales = 10, gold = 8000},
				},
			4:{
				icon = "res://assets/images/iconsgear/rose_weapon1_4.png",
				lvldesc = "WEAPON_ROSE1_EFFECT4",
				cost = {demonic = 5, gold = 17000},
				},
		}
	},
	rose_weapon2 = {
		name = 'WEAPON_ROSE2',
		description = 'descript',
		weaponrange = 'melee',
		damagetype = 'dark',
		weaponsound = 'dodge',
		leveldata = {
			0:{ #for possible use later
				icon = "res://assets/images/gui/forge/panel_forge_gear_disabled.png",
				lvldesc = "Not forged yet",
				cost = {},
				},
			1:{
				icon = "res://assets/images/iconsgear/rose_weapon2_1.png",
				lvldesc = "WEAPON_ROSE2_EFFECT1",
				cost = {wood = 10, gold = 500},
				},
			2:{
				icon = "res://assets/images/iconsgear/rose_weapon2_2.png",
				lvldesc = "WEAPON_ROSE2_EFFECT2",
				cost = {metal = 15, gold = 5000},
				},
			3:{
				icon = "res://assets/images/iconsgear/rose_weapon2_3.png",
				lvldesc = "WEAPON_ROSE2_EFFECT3",
				cost = {scales = 5, gold = 10000},
				},
			4:{
				icon = "res://assets/images/iconsgear/rose_weapon2_4.png",
				lvldesc = "WEAPON_ROSE2_EFFECT4",
				cost = {demonic = 10, gold = 15000},
				},
		}
	},
	rose_armor = {
		name = 'ARMOR_ROSE',
		description = 'descript',
		leveldata = {
			1:{
				icon = "res://assets/images/iconsgear/rose_armor_1.png",
				lvldesc = "ARMOR_ROSE_EFFECT1",
				cost = {},
				},
			2:{
				icon = "res://assets/images/iconsgear/rose_armor_2.png",
				lvldesc = "ARMOR_ROSE_EFFECT2",
				cost = {stone = 15, gold = 700},
				},
			3:{
				icon = "res://assets/images/iconsgear/rose_armor_3.png",
				lvldesc = "ARMOR_ROSE_EFFECT3",
				cost = {chitine = 15, gold = 4000},
				},
			4:{
				icon = "res://assets/images/iconsgear/rose_armor_4.png",
				lvldesc = "ARMOR_ROSE_EFFECT4",
				cost = {demonic = 5, gold = 10000},
				},
		}
	},
	ember_weapon1 = {
		name = 'WEAPON_EMBER1',
		description = 'descript',
		weaponrange = 'melee',
		damagetype = 'bludgeon',
		weaponsound = 'dodge',
		leveldata = {
			1:{
				icon = "res://assets/images/iconsgear/ember_weapon1_1.png",
				lvldesc = "WEAPON_EMBER1_EFFECT1",
				cost = {},
				},
			2:{
				icon = "res://assets/images/iconsgear/ember_weapon1_2.png",
				lvldesc = "WEAPON_EMBER1_EFFECT2",
				cost = {stone = 15, gold = 1000},
				},
			3:{
				icon = "res://assets/images/iconsgear/ember_weapon1_3.png",
				lvldesc = "WEAPON_EMBER1_EFFECT3",
				cost = {chitine = 15, gold = 8000},
				},
			4:{
				icon = "res://assets/images/iconsgear/ember_weapon1_4.png",
				lvldesc = "WEAPON_EMBER1_EFFECT4",
				cost = {otherworld = 5, gold = 17000},
				},
		}
	},
	ember_weapon2 = {
		name = 'WEAPON_EMBER2',
		description = 'descript',
		weaponrange = 'melee',
		damagetype = 'bludgeon',
		weaponsound = 'dodge',
		leveldata = {
			0:{ #for possible use later
				icon = "res://assets/images/gui/forge/panel_forge_gear_disabled.png",
				lvldesc = "Not forged yet",
				cost = {},
				},
			1:{
				icon = "res://assets/images/iconsgear/ember_weapon2_1.png",
				lvldesc = "WEAPON_EMBER2_EFFECT1",
				cost = {stone = 15, gold = 500},
				},
			2:{
				icon = "res://assets/images/iconsgear/ember_weapon2_2.png",
				lvldesc = "WEAPON_EMBER2_EFFECT2",
				cost = {chitine = 15, gold = 5000},
				},
			3:{
				icon = "res://assets/images/iconsgear/ember_weapon2_3.png",
				lvldesc = "WEAPON_EMBER2_EFFECT3",
				cost = {scales = 10, gold = 10000},
				},
			4:{
				icon = "res://assets/images/iconsgear/ember_weapon2_4.png",
				lvldesc = "WEAPON_EMBER2_EFFECT4",
				cost = {demonic = 10, gold = 15000},
				},
		}
	},
	ember_armor = {
		name = 'ARMOR_EMBER',
		description = 'descript',
		leveldata = {
			1:{
				icon = "res://assets/images/iconsgear/ember_armor_1.png",
				lvldesc = "ARMOR_EMBER_EFFECT1",
				cost = {},
				},
			2:{
				icon = "res://assets/images/iconsgear/ember_armor_2.png",
				lvldesc = "ARMOR_EMBER_EFFECT2",
				cost = {wood = 15, gold = 700},
				},
			3:{
				icon = "res://assets/images/iconsgear/ember_armor_3.png",
				lvldesc = "ARMOR_EMBER_EFFECT3",
				cost = {leather = 15, gold = 4000},
				},
			4:{
				icon = "res://assets/images/iconsgear/ember_armor_4.png",
				lvldesc = "ARMOR_EMBER_EFFECT4",
				cost = {demonic = 10, gold = 10000},
				},
		}
	},
	erika_weapon1 = {
		name = 'WEAPON_ERIKA1',
		description = 'descript',
		weaponrange = 'melee',
		damagetype = 'pierce',
		weaponsound = 'dodge',
		leveldata = {
			1:{
				icon = "res://assets/images/iconsgear/erika_weapon1_1.png",
				lvldesc = "WEAPON_ERIKA1_EFFECT1",
				cost = {},
				},
			2:{
				icon = "res://assets/images/iconsgear/erika_weapon1_2.png",
				lvldesc = "WEAPON_ERIKA1_EFFECT2",
				cost = {wood = 15, gold = 1000},
				},
			3:{
				icon = "res://assets/images/iconsgear/erika_weapon1_3.png",
				lvldesc = "WEAPON_ERIKA1_EFFECT3",
				cost = {scales = 10, gold = 8000},
				},
			4:{
				icon = "res://assets/images/iconsgear/erika_weapon1_4.png",
				lvldesc = "WEAPON_ERIKA1_EFFECT4",
				cost = {otherworld = 10, gold = 17000},
				},
		}
	},
	erika_weapon2 = {
		name = 'WEAPON_ERIKA2',
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
				lvldesc = "WEAPON_ERIKA2_EFFECT1",
				cost = {stone = 10, gold = 500},
				},
			2:{
				icon = "res://assets/images/iconsgear/erika_weapon2_2.png",
				lvldesc = "WEAPON_ERIKA2_EFFECT2",
				cost = {chitine = 20, gold = 5000},
				},
			3:{
				icon = "res://assets/images/iconsgear/erika_weapon2_3.png",
				lvldesc = "WEAPON_ERIKA2_EFFECT3",
				cost = {leather = 10, gold = 10000},
				},
			4:{
				icon = "res://assets/images/iconsgear/erika_weapon2_4.png",
				lvldesc = "WEAPON_ERIKA2_EFFECT4",
				cost = {otherworld = 5, gold = 15000},
				},
		}
	},
	erika_armor = {
		name = 'ARMOR_ERIKA',
		description = 'descript',
		leveldata = {
			1:{
				icon = "res://assets/images/iconsgear/erika_armor_1.png",
				lvldesc = "ARMOR_ERIKA_EFFECT1",
				cost = {},
				},
			2:{
				icon = "res://assets/images/iconsgear/erika_armor_2.png",
				lvldesc = "ARMOR_ERIKA_EFFECT2",
				cost = {wood = 10, gold = 700},
				},
			3:{
				icon = "res://assets/images/iconsgear/erika_armor_3.png",
				lvldesc = "ARMOR_ERIKA_EFFECT3",
				cost = {metal = 15, gold = 4000},
				},
			4:{
				icon = "res://assets/images/iconsgear/erika_armor_4.png",
				lvldesc = "ARMOR_ERIKA_EFFECT4",
				cost = {demonic = 10, gold = 10000},
				},
		}
	},
}


func _ready():
	for i in Items:
		Items[i].code = i
		if Items[i].has('waponsound'):
			resources.preload_res("sound/%s" % Items[i].waponsound)
