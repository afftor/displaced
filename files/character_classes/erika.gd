extends hero
class_name h_erika

func _init():
	id = 'erika'
	state.heroes[id] = self
	createfromname('erika')

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
