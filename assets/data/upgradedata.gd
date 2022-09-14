extends Node

var upgradelist = {#2 fix data
	bridge = {
		code = 'bridge',
		name = tr("BRIDGEUPGRADE"),
		positionorder = 1,
		descript = tr("UPGRADEBRIDGEDESCRIPT"),
		levels = {
			1:{
				unlockreqs = [],
				icon = load('res://assets/images/buildings/upgrade_bridge.png'),
				node = load('res://assets/images/buildings/gate.png'),
				bonusdescript = tr("UPGRADEBRIDGEBONUS"),
				cost = {wood = 5, gold = 10},
			}
		}
	},
	townhall = {
		code = 'townhall',
		name = tr("TOWNHALLUPGRADE"),
		positionorder = 1,
		descript = tr("UPGRADEBRIDGEDESCRIPT"),
		levels = {
			1:{
				unlockreqs = [],
				icon = load('res://assets/images/buildings/city_hall.png'), #no normal icon
				node = load('res://assets/images/buildings/city_hall.png'),
				bonusdescript = tr("UPGRADEBRIDGEBONUS"),
				cost = {wood = 5, gold = 10},
			}
		}
	},
	market = {
		code = 'market',
		name = tr("MARKETUPGRADE"),
		positionorder = 1,
		descript = tr("UPGRADEBRIDGEDESCRIPT"),
		levels = {
			1:{
				unlockreqs = [],
				icon = load("res://assets/images/buildings/market.png"), #no onormal icon
				node = load("res://assets/images/buildings/market.png"),
				bonusdescript = tr("UPGRADEBRIDGEBONUS"),
				cost = {wood = 5, gold = 10},
			}
		}
	},
#	lumbermill = {
#		code = 'lumbermill',
#		name = tr("LUMBERMILLUPGRADE"),
#		positionorder = 2,
#		descript = tr("UPGRADELUMBERMILLDESCRIPT"),
#		levels = {
#			1:{
#				unlockreqs = [],
#				icon = load("res://assets/images/buildings/upgrade_lumbermill.png"),
#				bonusdescript = tr("UPGRADELUMBERMILLBONUS"),
#				townnode = "lumbermill",
#				cost = {goblinmetal = 5, cloth = 5},
#				limitchange = 4
#			}
#		}
#	},
#	mine = {
#		code = 'mine',
#		name = tr("MINEUPGRADE"),
#		positionorder = 2,
#		descript = tr("UPGRADEMINEDESCRIPT"),
#		levels = {
#			1:{
#				unlockreqs = [{type = "has_upgrade", name = "bridge", value = 1}],
#				icon = load("res://assets/images/buildings/upgrade_mine.png"),
#				bonusdescript = tr("UPGRADEMINEBONUS"),
#				townnode = "mine",
#				cost = {wood = 5, elvenwood = 5},
#				limitchange = 2
#			}
#		}
#	},
#	farm = {
#		code = 'farm',
#		name = tr("FARMUPGRADE"),
#		positionorder = 3,
#		descript = tr("UPGRADEFARMDESCRIPT"),
#		levels = {
#			1:{
#				unlockreqs = [{type = "has_upgrade", name = "bridge", value = 1}],
#				icon = load('res://assets/images/buildings/upgrade_farm.png'),
#				bonusdescript = tr("UPGRADEFARMBONUS"),
#				townnode = "farm",
#				cost = {wood = 10},
#				limitchange = 2
#			}
#		}
#	},
#	houses = {
#		code = 'houses',
#		name = tr("HOUSESUPGRADE"),
#		positionorder = 4,
#		descript = tr("UPGRADEHOUSESDESCRIPT"),
#		levels = {
#			1:{
#				unlockreqs = [],
#				icon = load("res://assets/images/buildings/upgrade_house.png"),
#				bonusdescript = tr("UPGRADHOUSEBONUS1"),
#				cost = {wood = 10},
#				townnode = "house",
#				limitchange = 4,
#			},
#			2:{
#				unlockreqs = [],
#				icon = load("res://assets/images/buildings/upgrade_house.png"),
#				bonusdescript = tr("UPGRADHOUSEBONUS2"),
#				cost = {wood = 10, elvenwood = 5},
#				limitchange = 6
#			}
#		}
#	},
#	blacksmith = {
#		code = 'blacksmith',
#		name = tr("BLACKSMITHUPGRADE"),
#		positionorder = 5,
#		descript = tr("UPGRADEBLACKSMITHDESCRIPT"),
#		levels = {
#			1:{
#				unlockreqs = [{type = "has_hero", name = "Ember"}],
#				icon = load('res://assets/images/buildings/upgrade_forge.png'),
#				bonusdescript = tr("UPGRADEBLACKSMITHBONUS1"),
#				townnode = "BlacksmithNode",
#				cost = {goblinmetal = 10},
#			},
#			2:{
#				unlockreqs = [],
#				icon = load('res://assets/images/buildings/upgrade_forge2.png'),
#				bonusdescript = tr("UPGRADEBLACKSMITHBONUS1"),
#				townnode = "BlacksmithNode",
#				cost = {goblinmetal = 10, elvenmetal = 10},
#			},
#		}
#	},

	#new ones
	forge = {
		code = 'forge',
		name = tr(""),
		positionorder = 1,
		descript = tr(""),
		levels = { #only two sprites for a forge currently
			1:{
				unlockreqs = [],#should be disabled
				icon = load("res://assets/images/buildings/upgrade_forge.png"),
				node = load("res://assets/images/buildings/forge_1.png"),
				bonusdescript = tr(""),
				cost = {wood = 5, gold = 10},
			},
			2:{
				unlockreqs = [],
				icon = load("res://assets/images/buildings/upgrade_forge2.png"),
				node = load("res://assets/images/buildings/forge_2.png"),
				bonusdescript = tr(""),
				cost = {wood = 5, gold = 10},#do not fill till materials rework
			},
			3:{
				unlockreqs = [],
				icon = load("res://assets/images/buildings/upgrade_forge2.png"),
				node = load("res://assets/images/buildings/forge_2.png"),
				bonusdescript = tr(""),
				cost = {wood = 5, gold = 10},#do not fill till materials rework
			},
			4:{
				unlockreqs = [],
				icon = load("res://assets/images/buildings/upgrade_forge2.png"),
				node = load("res://assets/images/buildings/forge_2.png"),
				bonusdescript = tr(""),
				cost = {wood = 5, gold = 10},#do not fill till materials rework
			}
		}
	},
	tavern = { #only one sprite and no icon
		code = 'tavern',
		name = tr(""),
		positionorder = 1,
		descript = tr(""),
		levels = {
			1:{
				unlockreqs = [],
				icon = load("res://assets/images/buildings/tavern.png"),
				node = load("res://assets/images/buildings/tavern.png"),
				bonusdescript = tr(""),
				cost = {wood = 5, gold = 10},#do not fill till materials rework
			},
			2:{
				unlockreqs = [],
				icon = load("res://assets/images/buildings/tavern.png"),
				node = load("res://assets/images/buildings/tavern.png"),
				bonusdescript = tr(""),
				cost = {wood = 5, gold = 10},#do not fill till materials rework
			},
			3:{
				unlockreqs = [],
				icon = load("res://assets/images/buildings/tavern.png"),
				node = load("res://assets/images/buildings/tavern.png"),
				bonusdescript = tr(""),
				cost = {wood = 5, gold = 10},#do not fill till materials rework
			},
			4:{
				unlockreqs = [],
				icon = load("res://assets/images/buildings/tavern.png"),
				node = load("res://assets/images/buildings/tavern.png"),
				bonusdescript = tr(""),
				cost = {wood = 5, gold = 10},#do not fill till materials rework
			}
		}
	},
	mine = { #only one sprite and icon
		code = 'mine',
		name = tr(""),
		positionorder = 1,
		descript = tr(""),
		levels = {
			1:{
				unlockreqs = [],
				icon = load("res://assets/images/buildings/upgrade_mine.png"),
				node = load("res://assets/images/buildings/mine.png"),
				bonusdescript = tr(""),
				cost = {wood = 5, gold = 10},#do not fill till materials rework
			},
			2:{
				unlockreqs = [],
				icon = load("res://assets/images/buildings/upgrade_mine.png"),
				node = load("res://assets/images/buildings/mine.png"),
				bonusdescript = tr(""),
				cost = {wood = 5, gold = 10},#do not fill till materials rework
			},
			3:{
				unlockreqs = [],
				icon = load("res://assets/images/buildings/upgrade_mine.png"),
				node = load("res://assets/images/buildings/mine.png"),
				bonusdescript = tr(""),
				cost = {wood = 5, gold = 10},#do not fill till materials rework
			},
			4:{
				unlockreqs = [],
				icon = load("res://assets/images/buildings/upgrade_mine.png"),
				node = load("res://assets/images/buildings/mine.png"),
				bonusdescript = tr(""),
				cost = {wood = 5, gold = 10},#do not fill till materials rework
			}
		}
	},
	farm = { #only one sprite and icon
		code = 'farm',
		name = tr(""),
		positionorder = 1,
		descript = tr(""),
		levels = {
			1:{
				unlockreqs = [],#should be disabled
				icon = load("res://assets/images/buildings/upgrade_farm.png"),
				node = load("res://assets/images/buildings/farm.png"),
				bonusdescript = tr(""),
				cost = {wood = 5, gold = 10},#do not fill till materials rework
			},
			2:{
				unlockreqs = [],
				icon = load("res://assets/images/buildings/upgrade_farm.png"),
				node = load("res://assets/images/buildings/farm.png"),
				bonusdescript = tr(""),
				cost = {wood = 5, gold = 10},#do not fill till materials rework
			},
			3:{
				unlockreqs = [],
				icon = load("res://assets/images/buildings/upgrade_farm.png"),
				node = load("res://assets/images/buildings/farm.png"),
				bonusdescript = tr(""),
				cost = {wood = 5, gold = 10},#do not fill till materials rework
			},
			4:{
				unlockreqs = [],
				icon = load("res://assets/images/buildings/upgrade_farm.png"),
				node = load("res://assets/images/buildings/farm.png"),
				bonusdescript = tr(""),
				cost = {wood = 5, gold = 10},#do not fill till materials rework
			}
		}
	},
	mill = { #only one sprite and icon
		code = 'mill',
		name = tr(""),
		positionorder = 1,
		descript = tr(""),
		levels = {
			1:{
				unlockreqs = [],#should be disabled
				icon = load("res://assets/images/buildings/upgrade_lumbermill.png"),
				node = load("res://assets/images/buildings/sawmill.png"),
				bonusdescript = tr(""),
				cost = {wood = 5, gold = 10},#do not fill till materials rework
			},
			2:{
				unlockreqs = [],
				icon = load("res://assets/images/buildings/upgrade_lumbermill.png"),
				node = load("res://assets/images/buildings/sawmill.png"),
				bonusdescript = tr(""),
				cost = {wood = 5, gold = 10},#do not fill till materials rework
			},
			3:{
				unlockreqs = [],
				icon = load("res://assets/images/buildings/upgrade_lumbermill.png"),
				node = load("res://assets/images/buildings/sawmill.png"),
				bonusdescript = tr(""),
				cost = {wood = 5, gold = 10},#do not fill till materials rework
			},
			4:{
				unlockreqs = [],
				icon = load("res://assets/images/buildings/upgrade_lumbermill.png"),
				node = load("res://assets/images/buildings/sawmill.png"),
				bonusdescript = tr(""),
				cost = {wood = 5, gold = 10},#do not fill till materials rework
			}
		}
	},
}


func _ready():
	for code in upgradelist:
		var data = upgradelist[code]
		data.code = code #currently ok, but for safety
		data.name = "%sUPGRADE" % code.to_upper()
		data.descript = "UPGRADE%sDESCRIPT" % code.to_upper()
		for lv in data.levels:
			var ldata = data.levels[lv]
			ldata.bonusdescript = "UPGRADE%sDESCRIPT_LV%d" % [code.to_upper(), lv]
	print("+")
