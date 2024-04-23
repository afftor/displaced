extends Node

var upgradelist = {#2 fix data
	bridge = {
#		code = 'bridge',#set by _ready()
		name = "BRIDGEUPGRADE",
		positionorder = 1,
		descript = "UPGRADEBRIDGEDESCRIPT",
		levels = {
			1:{
				icon = load('res://assets/images/buildings/upgrade_bridge.png'),
				node = load('res://assets/images/buildings/gate.png'),
				bonusdescript = "UPGRADEBRIDGEBONUS1",
				cost = {},
			}
		}
	},
	townhall = {
#		code = 'townhall',
		name = "TOWNHALLUPGRADE",
		positionorder = 1,
		descript = "UPGRADETOWNHALLDESCRIPT",
		levels = {
			1:{
				icon = load('res://assets/images/buildings/city_hall.png'), #no normal icon
				node = load('res://assets/images/buildings/city_hall.png'),
				bonusdescript = "UPGRADETOWNHALLBONUS1",
				cost = {},
			}
		}
	},
	market = {
#		code = 'market',
		name = "MARKETUPGRADE",
		positionorder = 1,
		descript = "UPGRADEMARKETDESCRIPT",
		townnode = "market",
		levels = {
			1:{
				icon = load("res://assets/images/buildings/market.png"), #no onormal icon
				node = load("res://assets/images/buildings/market.png"),
				bonusdescript = "UPGRADEMARKETBONUS1",
				cost = {},
			}
		}
	},
	forge = {
#		code = 'forge',
		name = "BLACKSMITHUPGRADE",
		positionorder = 1,
		descript = "UPGRADEBLACKSMITHDESCRIPT",
		townnode = "forge",
		levels = { #only two sprites for a forge currently
			1:{
				unlock_reqs = [{type = 'seq_seen', value = 'ember_arrival'}],
				icon = load("res://assets/images/buildings/upgrade_forge.png"),
				node = load("res://assets/images/buildings/forge_1.png"),
				animatebuilding = true,
				bonusdescript = "UPGRADEBLACKSMITHBONUS1",
				cost = {},
			},
			2:{
				icon = load("res://assets/images/buildings/upgrade_forge2.png"),
				node = load("res://assets/images/buildings/forge_2.png"),
				animatebuilding = true,
				bonusdescript = "UPGRADEBLACKSMITHBONUS2",
				cost = {stone = 20, gold = 2500},
			},
			3:{
				icon = load("res://assets/images/buildings/upgrade_forge2.png"),
				node = load("res://assets/images/buildings/forge_2.png"),
				bonusdescript = "UPGRADEBLACKSMITHBONUS3",
				cost = {scales = 15, leather = 15, gold = 5000},
			},
			4:{
				icon = load("res://assets/images/buildings/upgrade_forge2.png"),
				node = load("res://assets/images/buildings/forge_2.png"),
				bonusdescript = "UPGRADEBLACKSMITHBONUS4",
				cost = {demonic = 20, otherworld = 20, gold = 7500},
			}
		}
	},
	tavern = { #only one sprite and no icon
#		code = 'tavern',
		name = "TAVERNUPGRADE",
		positionorder = 1,
		descript = "UPGRADETAVERNDESCRIPT",
		townnode = "tavern",
		effects_hp = true,
		levels = {
			1:{
				icon = load("res://assets/images/buildings/tavern.png"),
				node = load("res://assets/images/buildings/tavern.png"),
#				bonusdescript = "UPGRADETAVERNBONUS1",
				animatebuilding = true,
				cost = {stone = 10, gold = 1500},
			},
			2:{
				icon = load("res://assets/images/buildings/tavern.png"),
				node = load("res://assets/images/buildings/tavern.png"),
#				bonusdescript = "UPGRADETAVERNBONUS2",
				cost = {metal = 20, gold = 2500},
			},
			3:{
				icon = load("res://assets/images/buildings/tavern.png"),
				node = load("res://assets/images/buildings/tavern.png"),
#				bonusdescript = "UPGRADETAVERNBONUS3",
				cost = {scales = 20, gold = 5000},
			},
			4:{
				icon = load("res://assets/images/buildings/tavern.png"),
				node = load("res://assets/images/buildings/tavern.png"),
#				bonusdescript = "UPGRADETAVERNBONUS4",
				cost = {otherworld = 25, gold = 7500},
			}
		}
	},
	mine = { #only one sprite and icon
#		code = 'mine',
		name = "MINEUPGRADE",
		positionorder = 1,
		descript = "UPGRADEMINEDESCRIPT",
		townnode = "mine",
		levels = {
			1:{
				icon = load("res://assets/images/buildings/upgrade_mine.png"),
				node = load("res://assets/images/buildings/mine.png"),
#				bonusdescript = "UPGRADEMINEBONUS1",
				animatebuilding = true,
				cost = {stone = 5, gold = 1500},
			},
			2:{
				icon = load("res://assets/images/buildings/upgrade_mine.png"),
				node = load("res://assets/images/buildings/mine.png"),
#				bonusdescript = "UPGRADEMINEBONUS2",
				cost = {metal = 15, gold = 2500},
			},
			3:{
				icon = load("res://assets/images/buildings/upgrade_mine.png"),
				node = load("res://assets/images/buildings/mine.png"),
#				bonusdescript = "UPGRADEMINEBONUS3",
				cost = {scales = 15, gold = 5000},
			},
			4:{
				icon = load("res://assets/images/buildings/upgrade_mine.png"),
				node = load("res://assets/images/buildings/mine.png"),
#				bonusdescript = "UPGRADEMINEBONUS4",
				cost = {otherworld = 20, gold = 7500},
			}
		}
	},
	farm = { #only one sprite and icon
#		code = 'farm',
		name = "FARMUPGRADE",
		positionorder = 1,
		descript = "UPGRADEFARMDESCRIPT",
		townnode = "farm",
		effects_hp = true,
		levels = {
			1:{
				icon = load("res://assets/images/buildings/upgrade_farm.png"),
				node = load("res://assets/images/buildings/farm.png"),
#				bonusdescript = "UPGRADEFARMBONUS1",
				animatebuilding = true,
				cost = {wood = 5, gold = 1500},
			},
			2:{
				icon = load("res://assets/images/buildings/upgrade_farm.png"),
				node = load("res://assets/images/buildings/farm.png"),
#				bonusdescript = "UPGRADEFARMBONUS2",
				cost = {chitine = 15, gold = 2500},
			},
			3:{
				icon = load("res://assets/images/buildings/upgrade_farm.png"),
				node = load("res://assets/images/buildings/farm.png"),
#				bonusdescript = "UPGRADEFARMBONUS3",
				cost = {leather = 15, gold = 5000},
			},
			4:{
				icon = load("res://assets/images/buildings/upgrade_farm.png"),
				node = load("res://assets/images/buildings/farm.png"),
#				bonusdescript = "UPGRADEFARMBONUS4",
				cost = {demonic = 15, gold = 7500},
			}
		}
	},
	mill = { #only one sprite and icon
#		code = 'mill',
		name = "MILLUPGRADE",
		positionorder = 1,
		descript = "UPGRADEMILLDESCRIPT",
		townnode = "mill",
		levels = {
			1:{
				icon = load("res://assets/images/buildings/upgrade_lumbermill.png"),
				node = load("res://assets/images/buildings/sawmill.png"),
#				bonusdescript = "UPGRADEMILLBONUS1",
				animatebuilding = true,
				cost = {wood = 5, gold = 1500},
			},
			2:{
				icon = load("res://assets/images/buildings/upgrade_lumbermill.png"),
				node = load("res://assets/images/buildings/sawmill.png"),
#				bonusdescript = "UPGRADEMILLBONUS2",
				cost = {chitine = 20, gold = 2500},
			},
			3:{
				icon = load("res://assets/images/buildings/upgrade_lumbermill.png"),
				node = load("res://assets/images/buildings/sawmill.png"),
#				bonusdescript = "UPGRADEMILLBONUS3",
				cost = {leather = 20, gold = 5000},
			},
			4:{
				icon = load("res://assets/images/buildings/upgrade_lumbermill.png"),
				node = load("res://assets/images/buildings/sawmill.png"),
#				bonusdescript = "UPGRADEMILLBONUS4",
				cost = {demonic = 10, gold = 7500},
			}
		}
	},
}

var descript_refine_list = {
	tavern = {
		chars = ['arron', 'ember', 'erika'],
		bonusdescript = "UPGRADETAVERNBONUSREFINE",
		level_value = {1: "15", 2: "30", 3: "45", 4: "60"}
	},
	mine = {
		chars = ['arron', 'ember', 'erika'],
		bonusdescript = "UPGRADEMINEBONUSREFINE",
		level_value = {1: "15", 2: "30", 3: "45", 4: "60"}
	},
	farm = {
		chars = ['rose', 'rilu', 'iola'],
		bonusdescript = "UPGRADEFARMBONUSREFINE",
		level_value = {1: "15", 2: "30", 3: "45", 4: "60"}
	},
	mill = {
		chars = ['rose', 'rilu', 'iola'],
		bonusdescript = "UPGRADEMILLBONUSREFINE",
		level_value = {1: "15", 2: "30", 3: "45", 4: "60"}
	}
}


func _ready():
	for code in upgradelist:
		upgradelist[code].code = code

func get_refined_bonusdescript(upgrade :String, level :int) ->String:
	if !descript_refine_list.has(upgrade):
		return tr(upgradelist[upgrade].levels[level].bonusdescript)
	
	var data = descript_refine_list[upgrade]
	#it is only a char list for now, so no ifs
	var char_list = []
	for id in data.chars:
		var char_data = state.heroes[id]
		if char_data.unlocked:
			char_list.append(char_data.name)
	var char_str = ''
	for i in range(char_list.size()):
		if i == 0:
			pass
		elif i == char_list.size()-1:
			char_str += " and "
		else:
			char_str += ", "
		char_str += char_list[i]
	return tr(data.bonusdescript) % [char_str, data.level_value[level]]
