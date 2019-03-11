extends Node

var upgradelist = {
	bridge = {
		code = 'bridge',
		name = tr("BRIDGEUPGRADE"),
		positionorder = 1,
		descript = tr("UPGRADEBRIDGEDESCRIPT"),
		levels = {
			1:{
				unlockreqs = [], 
				bonusdescript = tr("UPGRADEBRIDGEBONUS"),
				cost = {wood = 5},
			}
		}
	},
	lumbermill = {
		code = 'lumbermill',
		name = tr("LUMBERMILLUPGRADE"),
		positionorder = 2,
		descript = tr("UPGRADELUMBERMILLDESCRIPT"),
		levels = {
			1:{
				unlockreqs = [], 
				bonusdescript = tr("UPGRADELUMBERMILLBONUS"),
				cost = {goblinmetal = 5, cloth = 5},
				limitchange = 4
			}
		}
	},
	mine = {
		code = 'mine',
		name = tr("MINEUPGRADE"),
		positionorder = 2,
		descript = tr("UPGRADEMINEDESCRIPT"),
		levels = {
			1:{
				unlockreqs = [{type = "has_upgrade", name = "bridge", value = 1}], 
				bonusdescript = tr("UPGRADEMINEBONUS"),
				cost = {wood = 5, elvenwood = 5},
				limitchange = 2
			}
		}
	},
	farm = {
		code = 'farm',
		name = tr("FARMUPGRADE"),
		positionorder = 3,
		descript = tr("UPGRADEFARMDESCRIPT"),
		levels = {
			1:{
				unlockreqs = [{type = "has_upgrade", name = "bridge", value = 1}], 
				bonusdescript = tr("UPGRADEFARMBONUS"),
				cost = {wood = 10},
				limitchange = 2
			}
		}
	},
	houses = {
		code = 'houses',
		name = tr("HOUSESUPGRADE"),
		positionorder = 4,
		descript = tr("UPGRADEHOUSESDESCRIPT"),
		levels = {
			1:{
				unlockreqs = [],
				bonusdescript = tr("UPGRADHOUSEBONUS1"),
				cost = {wood = 10},
				limitchange = 4,
			},
			2:{
				unlockreqs = [], 
				bonusdescript = tr("UPGRADHOUSEBONUS2"),
				cost = {wood = 10, elvenwood = 5},
				limitchange = 6
			}
		}
	},
	blacksmith = {
		code = 'blacksmith',
		name = tr("BLACKSMITHUPGRADE"),
		positionorder = 5,
		descript = tr("UPGRADEBLACKSMITHDESCRIPT"),
		levels = {
			1:{
				unlockreqs = [{type = "has_hero", name = "EMBER"}], 
				bonusdescript = tr("UPGRADEBLACKSMITHBONUS1"),
				cost = {goblinmetal = 10},
			},
			2:{
				unlockreqs = [],
				bonusdescript = tr("UPGRADEBLACKSMITHBONUS1"),
				cost = {elvenmetal = 10},
			},
		}
	},
	
}
