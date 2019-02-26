extends Node

var upgradelist = {
	bridge = {
		code = 'bridge',
		name = tr("BRIDGEUPGRADE"),
		positionorder = 1,
		descript = tr("UPGRADEBRIDGEDESCRIPT"),
		levels = {
			1:{
				unlockreqs = true, #workersunlocked
				purchasereqs = true,
				bonusdescript = tr("UPGRADEBRIDGEBONUS"),
				cost = {wood = 5},
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
				unlockreqs = true, #workersunlocked
				purchasereqs = true,
				bonusdescript = tr("UPGRADEMINEBONUS"),
				cost = {wood = 5, elvenwood = 5},
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
				unlockreqs = true, #workersunlocked
				purchasereqs = true,
				bonusdescript = tr("UPGRADEFARMBONUS"),
				cost = {wood = 10},
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
				unlockreqs = true, #workersunlocked
				purchasereqs = true,
				bonusdescript = tr("UPGRADHOUSEBONUS1"),
				cost = {wood = 10},
			},
			2:{
				unlockreqs = true,
				purchasereqs = true,
				bonusdescript = tr("UPGRADHOUSEBONUS1"),
				cost = {wood = 10, elvenwood = 5},
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
				unlockreqs = true, #ember unlocked
				purchasereqs = true,
				bonusdescript = tr("UPGRADEBLACKSMITHBONUS1"),
				cost = {goblinmetal = 10},
			},
			2:{
				unlockreqs = true,
				purchasereqs = true,
				bonusdescript = tr("UPGRADEBLACKSMITHBONUS1"),
				cost = {elvenmetal = 10},
			},
		}
	},
	
}
