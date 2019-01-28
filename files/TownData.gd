extends Node

var buildings = {
	lumbermill = {name = 'Lumbermill', node = 'Lumber', options = ['lumberaddworker','lumberseeworkers','lumberupgrade']}
	
}

var buildingoptions = {
	lumberaddworker = {},
	lumberseeworkers = {},
	lumberupgrade = {},
	
}

var tasksdict = {
	woodcutting = {basetimer = 10, energycost = 5, triggerfunction = 'woodcuttingperiod',
	name = tr("HARVESTWOOD"),
	description = tr('WOODCUTTINGTASKDESCRIPTION'),
	product = {
		wood = {code = 'materials.wood', amount = 1, chance = 100, reqs = true, toolproductionfactor = 2},
	},
	tasktool = {type = 'axe', required = false, durabilityfactor = 1}, 
	},
	mining = {basetimer = 10, energycost = 5, triggerfunction = 'miningperiod',
	name = tr("HARVESTMETAL"),
	description = tr('HARVESTMETALDESCRIPTION'),
	product = {
		goblinmetal = {code = 'materials.goblinmetal', amount = 1, chance = 100, reqs = true},
	},
	tasktool = {type = 'pickaxe', required = true, durabilityfactor = 1}, 
	}
	
	
}

var workersdict = {
	goblin = {name = 'Goblin', 
	description = '',
	price = 50, 
	type = 'goblin', 
	maxenergy = 50, 
	icon = load("res://assets/images/gui/goblin.png"), 
	unlockreq = null
	},
	elf = {name = 'Elf', 
	description = '',
	price = 75, 
	type = 'elf', 
	maxenergy = 100, 
	icon = load("res://assets/images/gui/goblin.png"), 
	unlockreq = null
	},
}
