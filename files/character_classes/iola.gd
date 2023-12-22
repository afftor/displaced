extends hero
class_name h_iola

func _init():
	id = 'iola'
	state.heroes[id] = self
	createfromname('iola')

func get_resists():
	var res = resists.duplicate()
	for r in variables.resistlist:
		if r in bonusres:
			match gear_level.armor:
				1: res[r] = 15
				2: res[r] = 30
				3: res[r] = 45
				4: res[r] = 60
		else:
			match gear_level.armor:
				1: res[r] = 7
				2: res[r] = 15
				3: res[r] = 23
				4: res[r] = 30
		if bonuses.has('resist' + r + '_add'): res[r] += bonuses['resist' + r + '_add']
		if bonuses.has('resist' + r + '_mul'): res[r] *= bonuses['resist' + r + '_mul']
	return res

func hpmax_get():
	var res = .hpmax_get()
	match state.get_upgrade_level('farm'):
		1: res *= 1.15
		2: res *= 1.3
		3: res *= 1.45
		4: res *= 1.6
	return int(res)

func damage_get():
	var res = .damage_get()
	match state.get_upgrade_level('mill'):
		1: res *= 1.15
		2: res *= 1.3
		3: res *= 1.45
		4: res *= 1.6
	return int(res)
