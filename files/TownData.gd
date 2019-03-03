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
	woodcutting = {basetimer = 10, energycost = 5,
	name = tr("HARVESTWOOD"),
	description = tr('WOODCUTTINGTASKDESCRIPTION'),
	unlockreq = true,
	tasktool = {type = 'axe', required = false, durabilityfactor = 0, effects = [{code = 'speed', value = 5}]}, 
	workerproducts = {
		goblin = [{code = 'materials.wood', amount = 1, chance = 100, critamount = 2, critchance = 10}],
		elf = [{code = 'materials.elvenwood', amount = 1, chance = 100, critamount = 2, critchance = 10}],
	},
},
	mining = {basetimer = 10, energycost = 5,
	name = tr("HARVESTMETAL"),
	description = tr('HARVESTMETALDESCRIPTION'),
	unlockreqs = 'mineupgrade',
	tasktool = {type = 'pickaxe', required = true, durabilityfactor = 0}, 
	workerproducts = {
		goblin = [{code = 'materials.goblinmetal', amount = 1, chance = 100, critamount = 2, critchance = 10}],
		elf = [{code = 'materials.elvenmetal', amount = 1, chance = 100, critamount = 2, critchance = 10}],
	},
},
	plantgathering = {basetimer = 10, energycost = 5,
	name = tr("HARVESTPLANT"),
	description = tr('HARVESTPLANTTASKDESCRIPTION'),
	unlockreq = true,
	tasktool = {type = 'none', required = false, durabilityfactor = 0}, 
	workerproducts = {
		goblin = [{code = 'materials.cloth', amount = 1, chance = 100, critamount = 2, critchance = 15}],
		elf = [{code = 'materials.cloth', amount = 1, chance = 100, critamount = 2, critchance = 15}],
	},
},
	
}

var workersdict = {
	goblin = {name = tr('GOBLINWORKER'), 
	description = '',
	price = 50, 
	type = 'goblin', 
	maxenergy = 50, 
	icon = load("res://assets/images/gui/goblinicon.png"), 
	unlockreq = true
	},
	elf = {name = tr("ELFWORKER"), 
	description = '',
	price = 75, 
	type = 'elf', 
	maxenergy = 100, 
	icon = load("res://assets/images/gui/elficon.png"), 
	unlockreq = false
	},
	dwarf = {name = tr('DWARFWORKER'), 
	description = '',
	price = 75, 
	type = 'dwarf', 
	maxenergy = 100, 
	icon = null, 
	unlockreq = false
	},
}
