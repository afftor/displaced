extends hero
class_name h_arron

func _init():
	id = 'arron'
	state.heroes[id] = self
	createfromname('arron')

func get_resists():
	var res = resists.duplicate()
	for r in variables.resistlist:
		if r in bonusres:
			match gear_level.armor:
				1: res[r] = 20
				2: res[r] = 40
				3: res[r] = 60
				4: res[r] = 80
		else:
			match gear_level.armor:
				1: res[r] = 10
				2: res[r] = 20
				3: res[r] = 30
				4: res[r] = 40
		if bonuses.has('resist' + r + '_add'): res[r] += bonuses['resist' + r + '_add']
		if bonuses.has('resist' + r + '_mul'): res[r] *= bonuses['resist' + r + '_mul']
	return res

func hpmax_get():
	var res = .hpmax_get()
	match state.get_upgrade_level('tavern'):
		1: res *= 1.15
		2: res *= 1.3
		3: res *= 1.45
		4: res *= 1.6
	return int(res)

func damage_get():
	var res = .damage_get()
	match state.get_upgrade_level('mine'):
		1: res *= 1.15
		2: res *= 1.3
		3: res *= 1.45
		4: res *= 1.6
	return int(res)
